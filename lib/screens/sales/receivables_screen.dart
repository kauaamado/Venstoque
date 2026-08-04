import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/sale_provider.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../widgets/custom_search_bar.dart';

class ReceivablesScreen extends StatefulWidget {
  const ReceivablesScreen({super.key});

  @override
  State<ReceivablesScreen> createState() => _ReceivablesScreenState();
}

class _ReceivablesScreenState extends State<ReceivablesScreen> {
  String? _selectedFilter;
  String _searchQuery = '';

  static const _filterOptions = [
    'Valor Pendente (Crescente)',
    'Valor Pendente (Decrescente)',
    'Data de Vencimento (Mais Próxima)',
    'Data de Vencimento (Mais Distante)',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SaleProvider>().loadSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SaleProvider>();
    final receivables = provider.receivables.where((item) {
      final customer = _customerMap(item)['nome']?.toString() ?? '';
      return customer.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
    _sortReceivables(receivables);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contas a Receber'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSearchBar(
                  hintText: 'Buscar conta pelo nome do cliente...',
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Filtrar Contas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _filterOptions.contains(_selectedFilter)
                      ? _selectedFilter
                      : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                  items: _filterOptions
                      .map(
                        (filter) => DropdownMenuItem(
                          value: filter,
                          child: Text(filter),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedFilter = value);
                  },
                  isExpanded: true,
                  hint: const Text('Ordenar por'),
                ),
              ],
            ),
          ),
          Expanded(
            child: provider.isLoading && provider.receivables.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : receivables.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma conta a receber.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: receivables.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          return _buildReceivableCard(
                            context,
                            receivables[index],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceivableCard(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    final customer = _customerMap(item);
    final customerName = customer['nome']?.toString().isNotEmpty == true
        ? customer['nome'].toString()
        : 'Cliente não informado';
    final productNames = _productNames(item);
    final dueDate = DateTime.parse(item['data_vencimento'].toString());
    final value = (item['valor'] as num?)?.toDouble() ?? 0;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade700),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                customerName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              'P: ${item['numero_parcela'] ?? 1}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productNames,
                style: TextStyle(color: Colors.grey.shade300, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                'Vence em: ${AppFormatters.formatDate(dueDate)}',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ],
          ),
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppFormatters.formatCurrency(value),
              style: const TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: () => _showPaymentDialog(item),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'QUITAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog(Map<String, dynamic> item) {
    final saleId = item['venda_id'].toString();
    final installmentId = item['local_id'].toString();
    final value = (item['valor'] as num?)?.toDouble() ?? 0;
    final provider = context.read<SaleProvider>();
    final totalPending = provider.receivables
        .where((installment) => installment['venda_id'].toString() == saleId)
        .fold<double>(
          0,
          (sum, installment) =>
              sum + ((installment['valor'] as num?)?.toDouble() ?? 0),
        );

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Opções de Pagamento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cliente: ${_customerMap(item)['nome'] ?? '-'}'),
            Text(
              'Produto: ${_productNames(item)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Valor desta parcela: ${AppFormatters.formatCurrency(value)}',
            ),
            if (totalPending > value)
              Text(
                'Total pendente: ${AppFormatters.formatCurrency(totalPending)}',
                style: const TextStyle(color: Colors.orange),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _showPartialPaymentDialog(installmentId, value);
            },
            child: const Text('Pagamento parcial'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _settleInstallment(installmentId);
            },
            child: const Text('Quitar parcela'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _settleSale(saleId);
            },
            child: const Text('Quitar compra'),
          ),
        ],
      ),
    );
  }

  void _showPartialPaymentDialog(String installmentId, double totalValue) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Pagamento Parcial'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Valor recebido'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final paid = double.tryParse(
                controller.text.replaceAll(',', '.'),
              );
              if (paid == null || paid <= 0) return;
              Navigator.pop(dialogContext);
              if (paid >= totalValue) {
                _settleInstallment(installmentId);
              } else {
                _payPartial(installmentId, totalValue - paid);
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    ).whenComplete(controller.dispose);
  }

  Future<void> _payPartial(String installmentId, double remaining) async {
    await _runPayment(
      () => context
          .read<SaleProvider>()
          .payPartialParcel(installmentId, remaining),
      'Pagamento parcial registrado.',
    );
  }

  Future<void> _settleInstallment(String installmentId) async {
    await _runPayment(
      () => context.read<SaleProvider>().markParcelAsPaid(installmentId),
      'Parcela quitada com sucesso.',
    );
  }

  Future<void> _settleSale(String saleId) async {
    await _runPayment(
      () => context.read<SaleProvider>().markAllParcelsAsPaid(saleId),
      'Compra quitada com sucesso.',
    );
  }

  Future<void> _runPayment(
    Future<void> Function() operation,
    String successMessage,
  ) async {
    try {
      await operation();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao registrar pagamento: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Map<String, dynamic> _customerMap(Map<String, dynamic> item) {
    final sale = item['vendas'] as Map<String, dynamic>?;
    return sale?['clientes'] as Map<String, dynamic>? ?? const {};
  }

  String _productNames(Map<String, dynamic> item) {
    final sale = item['vendas'] as Map<String, dynamic>?;
    final items = sale?['itens_venda'] as List? ?? const [];
    final names = items.map((rawItem) {
      final saleItem = rawItem as Map<String, dynamic>;
      final product = saleItem['produtos'] as Map<String, dynamic>?;
      return product?['nome']?.toString() ?? 'Produto excluído';
    });
    return names.isEmpty ? 'Produto não especificado' : names.join(', ');
  }

  void _sortReceivables(List<Map<String, dynamic>> receivables) {
    switch (_selectedFilter) {
      case 'Valor Pendente (Crescente)':
        receivables.sort(
          (first, second) => (first['valor'] as num).compareTo(
            second['valor'] as num,
          ),
        );
      case 'Valor Pendente (Decrescente)':
        receivables.sort(
          (first, second) => (second['valor'] as num).compareTo(
            first['valor'] as num,
          ),
        );
      case 'Data de Vencimento (Mais Distante)':
        receivables.sort(
          (first, second) => DateTime.parse(
            second['data_vencimento'].toString(),
          ).compareTo(
            DateTime.parse(first['data_vencimento'].toString()),
          ),
        );
      default:
        receivables.sort(
          (first, second) => DateTime.parse(
            first['data_vencimento'].toString(),
          ).compareTo(
            DateTime.parse(second['data_vencimento'].toString()),
          ),
        );
    }
  }
}
