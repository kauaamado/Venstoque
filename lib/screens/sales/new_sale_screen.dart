import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/stock_provider.dart';
import '../../providers/sale_provider.dart';
import '../../models/item_venda_model.dart';
import '../../models/parcela_model.dart';
import '../../models/cliente_model.dart';
import '../../models/produto_model.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../widgets/custom_search_bar.dart';
import '../../utils/search_helper.dart';

class NewSaleScreen extends StatefulWidget {
  const NewSaleScreen({super.key});

  @override
  State<NewSaleScreen> createState() => _NewSaleScreenState();
}

class _NewSaleScreenState extends State<NewSaleScreen> {
  int _currentStep = 0;
  String _searchCustomerQuery = '';
  String _searchProductQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerProvider>().loadCustomers();
      context.read<StockProvider>().loadProducts();
      context.read<SaleProvider>().clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final saleProvider = context.watch<SaleProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Nova Venda')),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == 0 && saleProvider.selectedCustomer == null) {
            return;
          }
          if (_currentStep == 1 && saleProvider.cart.isEmpty) {
            return;
          }
          if (_currentStep < 2) {
            setState(() => _currentStep++);
          } else {
            _finalize();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) setState(() => _currentStep--);
        },
        steps: [
          Step(
            title: const Text('Cliente'),
            isActive: _currentStep >= 0,
            content: _buildCustomerStep(),
          ),
          Step(
            title: const Text('Itens'),
            isActive: _currentStep >= 1,
            content: _buildItemsStep(),
          ),
          Step(
            title: const Text('Fim'),
            isActive: _currentStep >= 2,
            content: _buildPaymentStep(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerStep() {
    final customers = context.watch<CustomerProvider>().customers;
    final selected = context.watch<SaleProvider>().selectedCustomer;

    final List<ClienteModel> filteredCustomers = SearchHelper.filterList(
      items: customers,
      query: _searchCustomerQuery,
      searchBy: (c) => c.nome,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selecione o Cliente',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Busque e toque no cliente para selecionar',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        CustomSearchBar(
          hintText: 'Buscar cliente pelo nome...',
          onChanged: (val) {
            setState(() {
              _searchCustomerQuery = val;
            });
          },
        ),
        const SizedBox(height: 16),
        if (customers.isEmpty) ...[
          const Text(
              'Nenhum cliente cadastrado. Cadastre um cliente para prosseguir.'),
        ] else if (filteredCustomers.isEmpty) ...[
          const Text('Nenhum cliente encontrado com esse nome.',
              style: TextStyle(color: Colors.grey)),
        ] else ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredCustomers.length,
            itemBuilder: (context, index) {
              final c = filteredCustomers[index];
              final isSelected = selected?.localId == c.localId;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        isSelected ? AppColors.primary : Colors.grey.shade600,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    c.nome,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      c.referencia.isEmpty ? c.celular : c.referencia,
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade400),
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () => context.read<SaleProvider>().setCustomer(c),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildItemsStep() {
    final products = context.watch<StockProvider>().products;
    final cart = context.watch<SaleProvider>().cart;

    final List<ProdutoModel> filteredProducts = SearchHelper.filterList(
      items: products,
      query: _searchProductQuery,
      searchBy: (p) => p.nome,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Adicionar Produto',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        CustomSearchBar(
          hintText: 'Buscar produto...',
          onChanged: (val) {
            setState(() {
              _searchProductQuery = val;
            });
          },
        ),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(maxHeight: 220),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade800),
            borderRadius: BorderRadius.circular(8),
            color: Colors.black12,
          ),
          child: filteredProducts.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Nenhum produto encontrado.',
                      style: TextStyle(color: Colors.grey)),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: filteredProducts.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade800),
                  itemBuilder: (context, index) {
                    final prod = filteredProducts[index];
                    return ListTile(
                      title: Text(prod.nome,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        'Estoque: ${prod.quantidadeEstoque}  •  ${AppFormatters.formatCurrency(prod.valorVenda)}',
                        style: TextStyle(
                            color: Colors.grey.shade400, fontSize: 13),
                      ),
                      trailing: const Icon(Icons.add_shopping_cart,
                          color: Colors.green),
                      onTap: () {
                        context.read<SaleProvider>().addToCart(prod, 1);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('${prod.nome} adicionado ao carrinho!'),
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.green,
                        ));
                      },
                    );
                  },
                ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Carrinho de Compras:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (cart.isEmpty)
          const Text('O carrinho está vazio.',
              style: TextStyle(color: Colors.grey))
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cart.length,
            itemBuilder: (context, index) {
              final item = cart[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade600, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    item.produtoNome ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${item.quantidade}x ${AppFormatters.formatCurrency(item.precoUnitario)}',
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade400),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.redAccent),
                    onPressed: () =>
                        context.read<SaleProvider>().removeFromCart(index),
                  ),
                ),
              );
            },
          ),
        const Divider(height: 32),
        Text(
          'TOTAL: ${AppFormatters.formatCurrency(context.watch<SaleProvider>().total)}',
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPaymentStep() {
    final type = context.watch<SaleProvider>().paymentType;
    return RadioGroup<String>(
      groupValue: type,
      onChanged: (value) {
        if (value != null) {
          context.read<SaleProvider>().setPaymentType(value);
        }
      },
      child: const Column(
        children: [
          RadioListTile(
            title: Text('À Vista', style: TextStyle(color: Colors.white)),
            value: 'a_vista',
            activeColor: AppColors.primary,
          ),
          RadioListTile(
            title: Text(
              'Fiado / Pendente',
              style: TextStyle(color: Colors.white),
            ),
            value: 'fiado',
            activeColor: AppColors.primary,
          ),
          RadioListTile(
            title: Text('Parcelado', style: TextStyle(color: Colors.white)),
            value: 'parcelado',
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Future<void> _finalize() async {
    final saleProvider = context.read<SaleProvider>();
    int parcelasCount = 1;

    if (saleProvider.paymentType == 'fiado' ||
        saleProvider.paymentType == 'parcelado') {
      final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 30)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
        helpText: 'Selecione a Data do 1º Vencimento',
      );

      if (selectedDate == null || !mounted) return;

      if (saleProvider.paymentType == 'parcelado') {
        final result = await showDialog<int>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            int count = 1;
            return AlertDialog(
              title: const Text('Número de Parcelas'),
              content: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) => count = int.tryParse(value) ?? 1,
                decoration: const InputDecoration(hintText: 'Ex: 3'),
                style:
                    const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Cancelar',
                      style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, count),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary),
                  child:
                      const Text('OK', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );

        if (result == null || result <= 0 || !mounted) return;

        parcelasCount = result;
      }

      List<ParcelaModel> parcelas = [];
      double valorDaParcela = saleProvider.total / parcelasCount;

      for (int i = 1; i <= parcelasCount; i++) {
        DateTime dataVenc = DateTime(
            selectedDate.year, selectedDate.month + (i - 1), selectedDate.day);

        parcelas.add(ParcelaModel(
          vendaId: '',
          numeroParcela: i,
          valor: valorDaParcela,
          dataVencimento: dataVenc,
          status: 'pendente',
        ));
      }

      await _executeSale(saleProvider, parcelas);
    } else {
      await _executeSale(saleProvider, null);
    }
  }

  Future<void> _executeSale(
    SaleProvider provider,
    List<ParcelaModel>? parcelas,
  ) async {
    final customer = provider.selectedCustomer;
    final cartItems = List<ItemVendaModel>.from(provider.cart);
    final totalVenda = provider.total;
    final tipoPagamento = provider.paymentType;
    final telefoneCliente = customer?.celular ?? '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await provider.finalizeSale(parcelas);

      String mensagem = 'Olá, *${customer?.nome ?? 'Cliente'}*! 👋\n\n';
      mensagem += '✅ *Sua compra foi registrada com sucesso!*\n\n';
      mensagem += '🛒 *Resumo da Compra:*\n';

      for (var item in cartItems) {
        mensagem +=
            '▪ ${item.quantidade}x ${item.produtoNome} - ${AppFormatters.formatCurrency(item.precoUnitario)}\n';
      }

      mensagem += '\n💰 *Total:* ${AppFormatters.formatCurrency(totalVenda)}\n';

      String formaPagamentoStr = '';
      String vencimentoStr = '';

      if (tipoPagamento == 'a_vista') {
        formaPagamentoStr = 'À Vista';
      } else if (tipoPagamento == 'fiado') {
        formaPagamentoStr = 'Fiado / Pendente';
        if (parcelas != null && parcelas.isNotEmpty) {
          vencimentoStr =
              '🗓️ *Vencimento:* ${AppFormatters.formatDate(parcelas.first.dataVencimento)}\n';
        }
      } else if (tipoPagamento == 'parcelado') {
        if (parcelas != null && parcelas.isNotEmpty) {
          formaPagamentoStr =
              'Parcelado (${parcelas.length}x de ${AppFormatters.formatCurrency(parcelas.first.valor)})';
          vencimentoStr =
              '🗓️ *1º Vencimento:* ${AppFormatters.formatDate(parcelas.first.dataVencimento)}\n';
        } else {
          formaPagamentoStr = 'Parcelado';
        }
      }

      mensagem += '💳 *Pagamento:* $formaPagamentoStr\n';
      if (vencimentoStr.isNotEmpty) {
        mensagem += vencimentoStr;
      }

      mensagem += '\nAgradecemos a preferência! Volte sempre. 🤝';

      if (mounted) {
        Navigator.pop(context);
        setState(() => _currentStep = 0);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('✅ Venda salva no sistema!'),
          backgroundColor: Colors.green,
        ));

        showDialog(
            context: context,
            builder: (ctx) {
              final phoneController = TextEditingController();
              final bool temTelefone = telefoneCliente.isNotEmpty;

              return AlertDialog(
                title: const Text('Venda Finalizada! 🎉'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (temTelefone) ...[
                      Text(
                          'Deseja enviar o recibo para o WhatsApp de ${customer?.nome}?'),
                      const SizedBox(height: 8),
                      Text(telefoneCliente,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green)),
                    ] else ...[
                      const Text(
                          'Este cliente não possui celular cadastrado.\nDeseja informar um número agora?'),
                      const SizedBox(height: 16),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'WhatsApp do Cliente',
                          hintText: 'Ex: 21999999999',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Não Enviar',
                        style: TextStyle(color: Colors.grey)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(ctx);

                      String numeroParaEnviar =
                          temTelefone ? telefoneCliente : phoneController.text;

                      if (numeroParaEnviar.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Nenhum número informado.'),
                                backgroundColor: Colors.orange));
                        return;
                      }

                      try {
                        await WhatsAppHelper.sendMessage(
                            numeroParaEnviar, mensagem);
                        if (!mounted) return;
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Não foi possível abrir o WhatsApp: $e'),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Enviar Recibo',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              );
            });
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro ao salvar venda: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }
}
