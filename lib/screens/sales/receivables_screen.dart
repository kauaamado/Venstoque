import 'package:flutter/material.dart';
import '../../services/sale_service.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';

class ReceivablesScreen extends StatefulWidget {
  const ReceivablesScreen({super.key});

  @override
  State<ReceivablesScreen> createState() => _ReceivablesScreenState();
}

class _ReceivablesScreenState extends State<ReceivablesScreen> {
  final _service = SaleService();
  List<Map<String, dynamic>> _data = [];
  bool _loading = true;
  String? _selectedFilter;

  final List<String> _filterOptions = [
    'Valor Pendente (Crescente)',
    'Valor Pendente (Decrescente)',
    'Data de Vencimento (Mais Próxima)',
    'Data de Vencimento (Mais Distante)',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final res = await _service.getReceivables();
    setState(() {
      _data = res;
      _loading = false;
    });
  }

  void _applyFilter() {
    if (_selectedFilter == null) return;

    setState(() {
      switch (_selectedFilter) {
        case 'Valor Pendente (Crescente)':
          _data
              .sort((a, b) => (a['valor'] as num).compareTo(b['valor'] as num));
          break;
        case 'Valor Pendente (Decrescente)':
          _data
              .sort((a, b) => (b['valor'] as num).compareTo(a['valor'] as num));
          break;
        case 'Data de Vencimento (Mais Próxima)':
          _data.sort((a, b) => DateTime.parse(a['data_vencimento'])
              .compareTo(DateTime.parse(b['data_vencimento'])));
          break;
        case 'Data de Vencimento (Mais Distante)':
          _data.sort((a, b) => DateTime.parse(b['data_vencimento'])
              .compareTo(DateTime.parse(a['data_vencimento'])));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contas a Receber'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filtrar Contas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                value: _filterOptions.contains(_selectedFilter) ? _selectedFilter : null,
                items: _filterOptions
                      .map(
                        (filter) => DropdownMenuItem(
                          value: filter,
                          child: Text(filter),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value;
                      _applyFilter();
                    });
                  },
                  isExpanded: true,
                  hint: const Text('Ordenar por'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _data.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma conta a receber.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        itemCount: _data.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = _data[index];

                          // Tenta primeiro um campo direto "cliente"
                          String cliente = '';
                          final directCliente = item['cliente'];
                          if (directCliente != null &&
                              directCliente.toString().trim().isNotEmpty) {
                            cliente = directCliente.toString();
                          } else {
                            // Estrutura aninhada vinda do Supabase:
                            // vendas(cliente_id, clientes(nome))
                            final vendas = item['vendas'];
                            if (vendas is Map<String, dynamic>) {
                              final nestedCliente = vendas['clientes'];
                              if (nestedCliente is Map<String, dynamic>) {
                                final nome = nestedCliente['nome'];
                                if (nome != null &&
                                    nome.toString().trim().isNotEmpty) {
                                  cliente = nome.toString();
                                }
                              }
                            }
                          }

                          if (cliente.isEmpty) {
                            cliente = 'Cliente não informado';
                          }
                          final rawDueDate = item['data_vencimento'];
                          DateTime? dueDate;
                          if (rawDueDate != null &&
                              rawDueDate.toString().isNotEmpty) {
                            try {
                              dueDate = DateTime.parse(rawDueDate.toString());
                            } catch (_) {
                              dueDate = null;
                            }
                          }
                          final valor = (item['valor'] as num?)?.toDouble() ?? 0.0;

                          return Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              title: Text(
                                cliente,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                dueDate != null
                                    ? 'Vence em: ${AppFormatters.formatDate(dueDate)}'
                                    : 'Data de vencimento não informada',
                              ),
                              trailing: Text(
                                AppFormatters.formatCurrency(valor),
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
