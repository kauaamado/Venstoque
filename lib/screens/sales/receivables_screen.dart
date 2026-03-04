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
          _data.sort((a, b) => (a['valor'] as num).compareTo(b['valor'] as num));
          break;
        case 'Valor Pendente (Decrescente)':
          _data.sort((a, b) => (b['valor'] as num).compareTo(a['valor'] as num));
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

  void _showQuitarDialog(Map<String, dynamic> item, String nomeCliente, String nomeProduto, double valor, DateTime? dueDate) {
    final String vendaId = item['venda_id'] ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Como deseja quitar?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cliente: $nomeCliente'),
            Text('Produto: $nomeProduto', style: const TextStyle(fontWeight: FontWeight.bold)), // Mostra o produto no Pop-up também!
            const SizedBox(height: 8),
            Text('Valor desta parcela: ${AppFormatters.formatCurrency(valor)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context); 
              await _processarQuitacao(item['id'], false); 
            },
            child: const Text('QUITAR UMA', style: TextStyle(color: Colors.orange)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); 
              await _processarQuitacao(vendaId, true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('QUITAR TUDO', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _processarQuitacao(String id, bool quitarTudo) async {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator())
    );

    try {
      if (quitarTudo) {
        await _service.markAllParcelsAsPaid(id);
      } else {
        await _service.markParcelAsPaid(id);
      }
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Pagamento registrado com sucesso!'), backgroundColor: Colors.green),
        );
        _load(); 
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao quitar: $e'), backgroundColor: Colors.red),
        );
      }
    }
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
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _data.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = _data[index];

                          // NOVO: Lógica de parsing para extrair nome do cliente e dos produtos
                          String cliente = '';
                          String produtosDesc = '';
                          
                          final vendas = item['vendas'];
                          if (vendas is Map<String, dynamic>) {
                            final nestedCliente = vendas['clientes'];
                            if (nestedCliente is Map<String, dynamic>) {
                              cliente = nestedCliente['nome']?.toString() ?? '';
                            }
                            
                            // Acessa a lista de itens da venda para extrair os produtos
                            final itensVenda = vendas['itens_venda'];
                            if (itensVenda is List) {
                              List<String> nomesProdutos = [];
                              for (var iv in itensVenda) {
                                final prod = iv['produtos'];
                                if (prod is Map<String, dynamic> && prod['modelo'] != null) {
                                  nomesProdutos.add(prod['modelo'].toString());
                                }
                              }
                              produtosDesc = nomesProdutos.join(', ');
                            }
                          }
                          if (cliente.isEmpty) cliente = 'Cliente não informado';
                          if (produtosDesc.isEmpty) produtosDesc = 'Produto não especificado';
                          
                          final rawDueDate = item['data_vencimento'];
                          DateTime? dueDate;
                          if (rawDueDate != null && rawDueDate.toString().isNotEmpty) {
                            try {
                              dueDate = DateTime.parse(rawDueDate.toString());
                            } catch (_) {}
                          }
                          
                          final valor = (item['valor'] as num?)?.toDouble() ?? 0.0;
                          final parcelaAtual = item['numero_parcela']?.toString() ?? '1'; // Para mostrar de qual parcela se trata

                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade700, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    cliente,
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  Text(
                                    'P: $parcelaAtual', // Exibe o número da parcela no canto superior
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade400, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Exibe o Produto!
                                    Text(
                                      produtosDesc,
                                      style: TextStyle(color: Colors.grey.shade300, fontSize: 13),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      dueDate != null
                                          ? 'Vence em: ${AppFormatters.formatDate(dueDate)}'
                                          : 'Sem data',
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
                                    AppFormatters.formatCurrency(valor),
                                    style: const TextStyle(
                                      color: Colors.greenAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  InkWell(
                                    onTap: () => _showQuitarDialog(item, cliente, produtosDesc, valor, dueDate),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'QUITAR',
                                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
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