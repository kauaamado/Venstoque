import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/customer_provider.dart';
import '../../providers/stock_provider.dart';
import '../../providers/sale_provider.dart';
import '../../models/parcela_model.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';

class NewSaleScreen extends StatefulWidget {
  const NewSaleScreen({super.key});

  @override
  State<NewSaleScreen> createState() => _NewSaleScreenState();
}

class _NewSaleScreenState extends State<NewSaleScreen> {
  int _currentStep = 0;

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
          if (_currentStep == 0 && saleProvider.selectedCustomer == null)
            return;
          if (_currentStep == 1 && saleProvider.cart.isEmpty) return;
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
                'Toque no cliente para selecionar',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        if (customers.isEmpty) ...[
          const SizedBox(height: 16),
          const Text(
              'Nenhum cliente cadastrado. Cadastre um cliente para prosseguir.'),
        ] else ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final c = customers[index];
              final isSelected = selected?.id == c.id;

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
                      c.bairro,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Adicionar Produto',
            border: OutlineInputBorder(),
          ),
          items: products
              .map((p) => DropdownMenuItem(value: p.id, child: Text(p.modelo)))
              .toList(),
          onChanged: (id) {
            if (id != null) {
              final prod = products.firstWhere((p) => p.id == id);
              context.read<SaleProvider>().addToCart(prod, 1);
            }
          },
        ),
        const SizedBox(height: 24),
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
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                ),
                trailing: IconButton(
                  icon:
                      const Icon(Icons.delete_outline, color: Colors.redAccent),
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
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPaymentStep() {
    final type = context.watch<SaleProvider>().paymentType;
    return Column(
      children: [
        RadioListTile(
          title: const Text('À Vista', style: TextStyle(color: Colors.white)),
          value: 'a_vista',
          groupValue: type,
          activeColor: AppColors.primary,
          onChanged: (v) => context.read<SaleProvider>().setPaymentType(v!),
        ),
        RadioListTile(
          title: const Text('Fiado / Pendente',
              style: TextStyle(color: Colors.white)),
          value: 'fiado',
          groupValue: type,
          activeColor: AppColors.primary,
          onChanged: (v) => context.read<SaleProvider>().setPaymentType(v!),
        ),
        RadioListTile(
          title: const Text('Parcelado', style: TextStyle(color: Colors.white)),
          value: 'parcelado',
          groupValue: type,
          activeColor: AppColors.primary,
          onChanged: (v) => context.read<SaleProvider>().setPaymentType(v!),
        ),
      ],
    );
  }

  void _finalize() async {
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

      if (selectedDate == null) return;

      if (saleProvider.paymentType == 'parcelado') {
        final result = await showDialog<int>(
          context: context,
          barrierDismissible: false, // 1. Trava o clique fora do pop-up
          builder: (context) {
            int count = 1;
            return AlertDialog(
              title: const Text('Número de Parcelas'),
              content: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) => count = int.tryParse(value) ?? 1,
                decoration: const InputDecoration(hintText: 'Ex: 3'),
                style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              actions: [
                // 2. Adicionado o botão de Cancelar para o seu pai poder desistir
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, count),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: const Text('OK', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );

        // 3. Se ele clicou em Cancelar (result é null), aborta a venda na hora!
        if (result == null) return; 
        
        parcelasCount = result;
      }

      List<ParcelaModel> parcelas = [];
      double valorDaParcela = saleProvider.total / parcelasCount;

      for (int i = 1; i <= parcelasCount; i++) {
        // NOVO: Adiciona meses exatos em vez de 30 dias para manter o mesmo dia do mês.
        // O Flutter entende que, se foi dia 5, o próximo mês (selectedDate.month + i - 1) também cai no dia 5.
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

      _executeSale(saleProvider, parcelas);
    } else {
      _executeSale(saleProvider, null);
    }
  }

  void _executeSale(SaleProvider provider, List<ParcelaModel>? parcelas) async {
    // 1. SALVA OS DADOS ANTES DE FINALIZAR
    final customer = provider.selectedCustomer;
    final cartItems = List.from(provider.cart);
    final totalVenda = provider.total;
    final tipoPagamento = provider.paymentType;
    final String telefoneCliente = (customer as dynamic)?.celular ?? '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 2. SALVA NO BANCO
      await provider.finalizeSale(parcelas);

      // 3. MONTA A MENSAGEM
      String mensagem = 'Olá, *${customer?.nome ?? 'Cliente'}*! 👋\n\n';
      mensagem += '✅ *Sua compra foi registrada com sucesso!*\n\n';
      mensagem += '🛒 *Resumo da Compra:*\n';

      for (var item in cartItems) {
        mensagem +=
            '▪ ${item.quantidade}x ${item.produtoNome} - ${AppFormatters.formatCurrency(item.precoUnitario)}\n';
      }

      mensagem += '\n💰 *Total:* ${AppFormatters.formatCurrency(totalVenda)}\n';

      // Lógica atualizada para formatar Parcelado e Fiado com Vencimento
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
        mensagem += '$vencimentoStr';
      }

      mensagem += '\nAgradecemos a preferência! Volte sempre. 🤝';

      if (mounted) {
        Navigator.pop(context); // Fecha o loading
        setState(() => _currentStep = 0); // Volta pro início do stepper

        // Recarrega os dados da tela
        await context.read<CustomerProvider>().loadCustomers();
        await context.read<StockProvider>().loadProducts();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('✅ Venda salva no sistema!'),
          backgroundColor: Colors.green,
        ));

        // 4. POP-UP DE ENVIAR RECIBO
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
                      } catch (e) {
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