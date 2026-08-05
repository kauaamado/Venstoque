import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../../providers/sale_provider.dart';
import '../../providers/stock_provider.dart';
import '../../providers/sync_controller.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../utils/sync_feedback.dart';
import '../../widgets/summary_card.dart';
import '../../widgets/sync_status_button.dart';
import '../sales/sale_history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadStats());
  }

  Future<void> _loadStats() async {
    try {
      await Future.wait([
        context.read<SaleProvider>().loadSales(),
        context.read<StockProvider>().loadProducts(),
      ]);
    } catch (error, stackTrace) {
      debugPrint('Erro ao carregar dados locais do dashboard: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _refreshDashboard() async {
    final report = await context.read<SyncController>().syncNow();
    if (!mounted) return;
    await _loadStats();
    if (!mounted) return;
    showSyncFeedback(context, report);
  }

  @override
  Widget build(BuildContext context) {
    final sales = context.watch<SaleProvider>();
    final stock = context.watch<StockProvider>();
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month);
    final startOfNextMonth = DateTime(now.year, now.month + 1);
    final monthlySales = sales.sales
        .where(
          (sale) =>
              !sale.dataVenda.isBefore(startOfMonth) &&
              sale.dataVenda.isBefore(startOfNextMonth),
        )
        .fold<double>(0, (total, sale) => total + sale.valorTotal);
    final receivables = sales.receivables.where((installment) {
      final dueDate = DateTime.tryParse(
        installment['data_vencimento']?.toString() ?? '',
      );
      return dueDate != null &&
          !dueDate.isBefore(startOfMonth) &&
          dueDate.isBefore(startOfNextMonth);
    }).fold<double>(
      0,
      (total, installment) =>
          total + ((installment['valor'] as num?)?.toDouble() ?? 0),
    );
    final topCategories = <String, int>{};
    for (final product in stock.products) {
      if (product.quantidadeEstoque <= 0) continue;
      final category = product.categoria.isEmpty ? 'Outros' : product.categoria;
      topCategories[category] =
          (topCategories[category] ?? 0) + product.quantidadeEstoque;
    }
    final totalItensEstoque =
        topCategories.values.fold(0, (sum, item) => sum + item);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Venstoque',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: const [SyncStatusButton()],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDashboard,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics:
              const AlwaysScrollableScrollPhysics(), // Garante que o refresh funcione mesmo se a tela for pequena
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Visão Geral',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  SummaryCard(
                    title: 'Vendido (Mês)',
                    value: AppFormatters.formatCurrency(monthlySales),
                    icon: Icons.attach_money,
                    color: AppColors.primary,
                  ),
                  SummaryCard(
                    title: 'A Receber (Mês)',
                    value: AppFormatters.formatCurrency(receivables),
                    icon: Icons.account_balance_wallet,
                    color: AppColors.warning,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              const Text(
                'Distribuição do Estoque',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),

              // Bloco do Gráfico
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade800, width: 1),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 220, // Altura do gráfico
                      child: topCategories.isEmpty
                          ? const Center(
                              child: Text('Estoque zerado',
                                  style: TextStyle(color: Colors.grey)))
                          : PieChart(
                              PieChartData(
                                centerSpaceRadius:
                                    0, // Zero tira o buraco e faz virar pizza completa
                                sectionsSpace:
                                    1, // Espaço mínimo entre as fatias
                                sections: topCategories.entries.map((e) {
                                  final color = Colors.primaries[topCategories
                                          .keys
                                          .toList()
                                          .indexOf(e.key) %
                                      Colors.primaries.length];
                                  return PieChartSectionData(
                                    value: e.value.toDouble(),
                                    color: color,
                                    radius: 110, // Tamanho da fatia
                                    showTitle: false, // Esconde os textos
                                  );
                                }).toList(),
                              ),
                            ),
                    ),

                    const SizedBox(height: 32),

                    // Legenda customizada com as Porcentagens
                    if (topCategories.isNotEmpty)
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: topCategories.entries.map((e) {
                          final category = e.key;
                          final value = e.value;
                          final color = Colors.primaries[
                              topCategories.keys.toList().indexOf(category) %
                                  Colors.primaries.length];

                          // Regra de 3 para descobrir a porcentagem
                          final percentage = totalItensEstoque > 0
                              ? (value / totalItensEstoque) * 100
                              : 0.0;

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$category (${percentage.toStringAsFixed(1)}%)',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SalesHistoryScreen()),
                    );
                  },
                  icon: const Icon(Icons.history, color: AppColors.primary),
                  label: const Text('VER HISTÓRICO DE VENDAS',
                      style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
