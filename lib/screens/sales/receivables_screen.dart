import 'package:flutter/material.dart';
import '../../services/sale_service.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../widgets/custom_search_bar.dart'; // NOVO IMPORT
import '../../utils/search_helper.dart'; // NOVO IMPORT

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
  String _searchQuery = ''; // NOVO: Variável de busca

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

  void _showQuitarDialog(Map<String, dynamic> item, String nomeCliente, String nomeProduto, double valor, DateTime? dueDate, String telefoneCliente) {
    final String vendaId = item['venda_id'] ?? '';
    final String parcelaId = item['id'];

    // Calcula o valor TOTAL pendente somando todas as parcelas dessa mesma venda
    double valorTotalPendente = 0;
    for (var p in _data) {
      if (p['venda_id'] == vendaId) {
        valorTotalPendente += (p['valor'] as num?)?.toDouble() ?? 0.0;
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => AlertDialog(
        title: const Text('Opções de Pagamento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cliente: $nomeCliente'),
            Text('Produto: $nomeProduto', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Valor desta parcela: ${AppFormatters.formatCurrency(valor)}'),
            
            // Mostra o total pendente se houver mais de uma parcela
            if (valorTotalPendente > valor) ...[
              const SizedBox(height: 8),
              Text(
                'Total pendente da compra: ${AppFormatters.formatCurrency(valorTotalPendente)}',
                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ]
          ],
        ),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context); 
                  _showPartialPaymentDialog(parcelaId, valor, telefoneCliente); 
                },
                style: OutlinedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('PAGAMENTO PARCIAL', style: TextStyle(color: Colors.white),),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context); 
                  await _processarQuitacao(parcelaId, false, valorPago: valor, telefone: telefoneCliente); 
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('QUITAR ESTA PARCELA', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context); 
                  await _processarQuitacao(vendaId, true, valorPago: valorTotalPendente, telefone: telefoneCliente);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('QUITAR TODA A COMPRA', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCELAR / VOLTAR', style: TextStyle(color: Colors.grey)),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showPartialPaymentDialog(String parcelaId, double valorTotal, String telefoneCliente) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Pagamento Parcial'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Valor atual: ${AppFormatters.formatCurrency(valorTotal)}'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Valor Recebido (R\$)',
                hintText: 'Ex: 50.00',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final input = controller.text.replaceAll(',', '.');
              final valorPago = double.tryParse(input);

              if (valorPago == null || valorPago <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Digite um valor válido.'), backgroundColor: Colors.red),
                );
                return;
              }

              if (valorPago >= valorTotal) {
                Navigator.pop(context);
                await _processarQuitacao(parcelaId, false, valorPago: valorTotal, telefone: telefoneCliente);
              } else {
                Navigator.pop(context);
                await _processarPagamentoParcial(parcelaId, valorTotal, valorPago, telefoneCliente);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _processarPagamentoParcial(String parcelaId, double valorTotal, double valorPago, String telefoneCliente) async {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator())
    );

    try {
      final double restante = valorTotal - valorPago;
      await _service.payPartialParcel(parcelaId, restante);
      
      if (mounted) {
        Navigator.pop(context); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Pagamento parcial registrado!'), backgroundColor: Colors.blue),
        );
        _load(); 
        
        _perguntarEnviarReciboWhatsApp(valorPago, telefoneCliente, restante: restante);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao registrar: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _processarQuitacao(String id, bool quitarTudo, {double? valorPago, required String telefone}) async {
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
        
        _perguntarEnviarReciboWhatsApp(valorPago ?? 0, telefone);
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

  void _perguntarEnviarReciboWhatsApp(double valorPago, String telefone, {double? restante}) {
    if (telefone.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Enviar Recibo?'),
        content: const Text('Deseja enviar a confirmação de pagamento para o WhatsApp do cliente?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Não', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              
              String msg = 'Olá! Confirmamos o recebimento do seu pagamento no valor de *${AppFormatters.formatCurrency(valorPago)}*.\n\n';
              if (restante != null && restante > 0) {
                msg += 'Ainda resta um saldo pendente de *${AppFormatters.formatCurrency(restante)}* nesta parcela.\n\n';
              } else {
                msg += 'Esta parcela/conta foi totalmente quitada! 🎉\n\n';
              }
              msg += 'Obrigado!';
              
              try {
                await WhatsAppHelper.sendMessage(telefone, msg);
              } catch (e) {
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                   content: Text('Não foi possível abrir o WhatsApp.'), backgroundColor: Colors.orange));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Sim, enviar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ==========================================
    // 1. APLICA A BARRA DE PESQUISA (SearchHelper)
    // ==========================================
    final filteredList = SearchHelper.filterList(
      items: _data,
      query: _searchQuery,
      searchBy: (item) {
        final vendas = item['vendas'];
        if (vendas is Map<String, dynamic>) {
          final nestedCliente = vendas['clientes'];
          if (nestedCliente is Map<String, dynamic>) {
            return nestedCliente['nome']?.toString() ?? '';
          }
        }
        return '';
      },
    );

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
                // ==========================================
                // BARRA DE PESQUISA NA TELA
                // ==========================================
                CustomSearchBar(
                  hintText: 'Buscar Conta pelo nome do cliente...',
                  onChanged: (texto) {
                    setState(() {
                      _searchQuery = texto;
                    });
                  },
                ),
                const SizedBox(height: 16),

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
                : filteredList.isEmpty
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
                        itemCount: filteredList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = filteredList[index];

                          // Lógica de parsing para extrair nome do cliente e dos produtos
                          String cliente = '';
                          String telefoneCliente = '';
                          String produtosDesc = '';
                          
                          final vendas = item['vendas'];
                          if (vendas is Map<String, dynamic>) {
                            final nestedCliente = vendas['clientes'];
                            if (nestedCliente is Map<String, dynamic>) {
                              cliente = nestedCliente['nome']?.toString() ?? '';
                              telefoneCliente = nestedCliente['celular']?.toString() ?? '';
                            }
                            
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
                          final parcelaAtual = item['numero_parcela']?.toString() ?? '1';

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
                                    'P: $parcelaAtual',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade400, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                    onTap: () => _showQuitarDialog(item, cliente, produtosDesc, valor, dueDate, telefoneCliente),
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