import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/sale_provider.dart';
import '../../providers/sync_controller.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../utils/sync_feedback.dart';
import '../../widgets/sync_status_button.dart';
import 'remote_history_screen.dart';

class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SaleProvider>().loadSales();
    });
  }

  Future<void> _refreshSales() async {
    final report = await context.read<SyncController>().refreshSales();
    if (!mounted) return;
    await context.read<SaleProvider>().loadSales();
    if (!mounted) return;
    showSyncFeedback(context, report);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SaleProvider>();
    final groupedData = <DateTime, List<Map<String, dynamic>>>{};
    final monthTotals = <DateTime, Map<String, double>>{};
    _groupHistory(provider.salesHistory, groupedData, monthTotals);

    final sortedMonths = groupedData.keys.toList()
      ..sort((first, second) => second.compareTo(first));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Vendas (últimos 12 meses)'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          const SyncStatusButton(),
          IconButton(
            tooltip: 'Consultar histórico anterior',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RemoteHistoryScreen(),
                ),
              );
            },
            icon: const Icon(Icons.cloud_download_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshSales,
        child: provider.isLoading && provider.salesHistory.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(
                    height: 400,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              )
            : sortedMonths.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(
                        height: 300,
                        child: Center(
                          child: Text(
                            'Nenhuma venda registrada.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: sortedMonths.length,
                    itemBuilder: (context, index) {
                      final monthKey = sortedMonths[index];
                      final monthName = DateFormat(
                        'MMMM / yyyy',
                        'pt_BR',
                      ).format(monthKey);
                      final events = groupedData[monthKey]!
                        ..sort(
                          (first, second) => (second['data'] as DateTime)
                              .compareTo(first['data'] as DateTime),
                        );
                      final totals = monthTotals[monthKey]!;

                      return ExpansionTile(
                        initiallyExpanded: index == 0,
                        title: Text(
                          monthName.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Wrap(
                          spacing: 12,
                          runSpacing: 2,
                          children: [
                            _monthlyMetric(
                              'Total',
                              totals['venda'] ?? 0,
                              Colors.white70,
                            ),
                            _monthlyMetric(
                              'Lucro',
                              totals['lucro'] ?? 0,
                              Colors.greenAccent,
                            ),
                            _monthlyMetric(
                              'Pendente',
                              totals['pendente'] ?? 0,
                              Colors.orangeAccent,
                            ),
                          ],
                        ),
                        children: events.map(_buildEventTile).toList(),
                      );
                    },
                  ),
      ),
    );
  }

  void _groupHistory(
    List<Map<String, dynamic>> sales,
    Map<DateTime, List<Map<String, dynamic>>> grouped,
    Map<DateTime, Map<String, double>> totals,
  ) {
    for (final sale in sales) {
      final paymentType = sale['tipo_pagamento']?.toString() ?? '';
      final customer =
          (sale['clientes'] as Map<String, dynamic>?)?['nome']?.toString() ??
              'Cliente não informado';
      final saleDate = DateTime.parse(sale['data_venda'].toString());
      final items = (sale['itens_venda'] as List?) ?? const [];
      final installments = (sale['parcelas'] as List?) ?? const [];
      var totalCost = 0.0;
      final productDescriptions = <String>[];

      for (final rawItem in items) {
        final item = rawItem as Map<String, dynamic>;
        final quantity = (item['quantidade'] as num?)?.toInt() ?? 0;
        final unitCost = (item['custo_unitario'] as num?)?.toDouble() ?? 0;
        final product = item['produtos'] as Map<String, dynamic>?;
        totalCost += unitCost * quantity;
        productDescriptions.add(
          '${quantity}x ${product?['nome'] ?? 'Produto excluído'} '
          '(${AppFormatters.formatDate(saleDate)})',
        );
      }

      if (paymentType == 'a_vista' || installments.isEmpty) {
        final value = (sale['valor_total'] as num?)?.toDouble() ?? 0;
        _addEvent(
          grouped,
          totals,
          saleDate,
          value,
          value - totalCost,
          customer,
          productDescriptions.join(', '),
          paymentType == 'a_vista' ? 'À Vista' : 'Sem parcelas',
          isPending: false,
        );
        continue;
      }

      for (final rawInstallment in installments) {
        final installment = rawInstallment as Map<String, dynamic>;
        final value = (installment['valor'] as num?)?.toDouble() ?? 0;
        final date = DateTime.parse(
          installment['data_vencimento'].toString(),
        );
        _addEvent(
          grouped,
          totals,
          date,
          value,
          value - totalCost / installments.length,
          customer,
          productDescriptions.join(', '),
          'Parcelado (P: ${installment['numero_parcela']}/${installments.length})',
          isPending: installment['status']?.toString() != 'pago',
        );
      }
    }
  }

  void _addEvent(
    Map<DateTime, List<Map<String, dynamic>>> grouped,
    Map<DateTime, Map<String, double>> totals,
    DateTime date,
    double value,
    double profit,
    String customer,
    String products,
    String payment, {
    required bool isPending,
  }) {
    final monthKey = DateTime(date.year, date.month);
    grouped.putIfAbsent(monthKey, () => []).add({
      'comprador': customer,
      'produtos': products,
      'pagamento': payment,
      'valor': value,
      'data': date,
    });
    final month = totals.putIfAbsent(
      monthKey,
      () => {'venda': 0, 'lucro': 0, 'pendente': 0},
    );
    month['venda'] = (month['venda'] ?? 0) + value;
    month['lucro'] = (month['lucro'] ?? 0) + profit;
    if (isPending) {
      month['pendente'] = (month['pendente'] ?? 0) + value;
    }
  }

  Widget _monthlyMetric(String label, double value, Color color) {
    return Text(
      '$label: ${AppFormatters.formatCurrency(value)}',
      style: TextStyle(
        fontSize: 12,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildEventTile(Map<String, dynamic> event) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        event['comprador'].toString(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            event['produtos'].toString(),
            style: TextStyle(color: Colors.grey.shade300, fontSize: 13),
          ),
          const SizedBox(height: 2),
          Text(
            '${event['pagamento']}  •  '
            '${AppFormatters.formatDate(event['data'] as DateTime)}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
      trailing: Text(
        AppFormatters.formatCurrency((event['valor'] as num).toDouble()),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.greenAccent,
        ),
      ),
    );
  }
}
