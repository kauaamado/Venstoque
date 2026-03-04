import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/estoque_model.dart';
import '../../models/produto_model.dart';
import '../../providers/stock_provider.dart';
import '../../utils/constants.dart';

class RegisterEntryScreen extends StatefulWidget {
  const RegisterEntryScreen({super.key});

  @override
  State<RegisterEntryScreen> createState() => _RegisterEntryScreenState();
}

class _RegisterEntryScreenState extends State<RegisterEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _complementController = TextEditingController();
  final _qtyController = TextEditingController();
  final _costController = TextEditingController();
  final _salePriceController = TextEditingController();
  final List<String> _fornecedores = [
    'Papo de Boleiro', 
    'Rasha', 
    'Smart Mania', 
    'Outros'
  ];
  String? _selectedFornecedor;
  String? _selectedType;

  ProdutoModel? _selectedProduct;

  @override
  Widget build(BuildContext context) {
    final products = context.watch<StockProvider>().products;
    final productTypes = products.map((p) => p.tipo).toSet().toList()..sort();
    final filteredProducts = _selectedType == null
        ? <ProdutoModel>[]
        : products.where((product) => product.tipo == _selectedType).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Entrada')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tipo de Produto'),
                value: productTypes.contains(_selectedType) ? _selectedType : null,
                items: productTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                    _selectedProduct =
                        null; // Reset selected product when type changes
                  });
                },
                validator: (value) =>
                    value == null || value.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ProdutoModel>(
                decoration: const InputDecoration(labelText: 'Produto'),
                value: _selectedProduct != null && filteredProducts.contains(_selectedProduct)
                    ? _selectedProduct
                    : null,
                items: filteredProducts
                    .map((product) => DropdownMenuItem(
                          value: product,
                          child: Text(product.modelo),
                        ))
                    .toList()
                  ..sort((a, b) => a.value!.modelo.compareTo(b.value!.modelo)),
                onChanged: (value) {
                  setState(() {
                    _selectedProduct = value;
                    if (value != null) {
                      _costController.text = value.precoCusto.toString();
                      _salePriceController.text = value.valorVenda.toString();
                      _complementController.text = value.complemento.toString();
                      _selectedFornecedor = value.fornecedor.isNotEmpty
                          ? value.fornecedor
                          : null;
                    }
                  });
                },
                validator: (value) =>
                    value == null ? 'Selecione um produto' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _qtyController,
                decoration: const InputDecoration(labelText: 'Quantidade'),
                validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _complementController,
                decoration: const InputDecoration(labelText: 'Complemento'),
                validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _costController,
                decoration:
                    const InputDecoration(labelText: 'Custo Unitário (R\$)'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _salePriceController,
                decoration: const InputDecoration(
                    labelText: 'Novo Valor de Venda (R\$)'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Fornecedor',
                ),
                value: _selectedFornecedor,
                items: _fornecedores.map((fornecedor) {
                  return DropdownMenuItem(
                    value: fornecedor,
                    child: Text(fornecedor),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFornecedor = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione um fornecedor';
                  }
                  return null;
                },
              ),              
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white),
                  child: const Text('SALVAR ENTRADA'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate() || _selectedProduct == null) return;

    // Normaliza números no formato brasileiro (1.234,56 -> 1234.56)
    double _parseCurrency(String text) {
      final cleaned = text.trim().replaceAll('.', '').replaceAll(',', '.');
      return double.tryParse(cleaned) ?? 0.0;
    }

    int _parseInt(String text) {
      final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(digits) ?? 0;
    }

    final entry = EstoqueModel(
      produtoId: _selectedProduct!.id!,
      quantidade: _parseInt(_qtyController.text),
      custoUnitario: _parseCurrency(_costController.text),
      fornecedor: _selectedFornecedor ?? '',
      dataEntrada: DateTime.now(),
      complemento: _complementController.text,
      novoValorVenda: _parseCurrency(_salePriceController.text),
    );

    await context
        .read<StockProvider>()
        .registerEntry(entry, _parseCurrency(_salePriceController.text));
    if (mounted) Navigator.pop(context);
  }
}
