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
  final _quantityController = TextEditingController();
  final _costController = TextEditingController();
  final _salePriceController = TextEditingController();

  static const _suppliers = [
    'Papo de Boleiro',
    'Rasha',
    'Smart Mania',
    'Outros',
  ];

  String? _selectedSupplier;
  String? _selectedCategory;
  String? _selectedProductId;

  @override
  Widget build(BuildContext context) {
    final products = context.watch<StockProvider>().products;
    final categories = products.map((product) => product.categoria).toSet()
      ..removeWhere((category) => category.isEmpty);
    final sortedCategories = categories.toList()..sort();
    final filteredProducts = _selectedCategory == null
        ? <ProdutoModel>[]
        : products
            .where((product) => product.categoria == _selectedCategory)
            .toList()
      ..sort((first, second) => first.nome.compareTo(second.nome));
    final selectedProduct = _findProduct(filteredProducts, _selectedProductId);

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Entrada')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                initialValue: sortedCategories.contains(_selectedCategory)
                    ? _selectedCategory
                    : null,
                decoration: const InputDecoration(
                  labelText: 'Categoria do Produto',
                ),
                items: sortedCategories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                    _selectedProductId = null;
                  });
                },
                validator: _requiredValue,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: ValueKey(_selectedCategory),
                initialValue: selectedProduct?.localId,
                decoration: const InputDecoration(labelText: 'Produto'),
                items: filteredProducts
                    .map(
                      (product) => DropdownMenuItem(
                        value: product.localId,
                        child: Text(product.nome),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  final product = _findProduct(filteredProducts, value);
                  setState(() {
                    _selectedProductId = value;
                    if (product != null) {
                      _costController.text =
                          product.precoCusto.toStringAsFixed(2).replaceAll(
                                '.',
                                ',',
                              );
                      _salePriceController.text =
                          product.valorVenda.toStringAsFixed(2).replaceAll(
                                '.',
                                ',',
                              );
                      _selectedSupplier = product.fornecedor.isEmpty
                          ? null
                          : product.fornecedor;
                    }
                  });
                },
                validator: _requiredValue,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                validator: _requiredValue,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(
                  labelText: 'Custo Unitário (R\$)',
                ),
                keyboardType: TextInputType.number,
                validator: _requiredValue,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _salePriceController,
                decoration: const InputDecoration(
                  labelText: 'Novo Valor de Venda (R\$)',
                ),
                keyboardType: TextInputType.number,
                validator: _requiredValue,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: ValueKey(_selectedSupplier),
                initialValue: _suppliers.contains(_selectedSupplier)
                    ? _selectedSupplier
                    : null,
                decoration: const InputDecoration(labelText: 'Fornecedor'),
                items: _suppliers
                    .map(
                      (supplier) => DropdownMenuItem(
                        value: supplier,
                        child: Text(supplier),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedSupplier = value);
                },
                validator: _requiredValue,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('SALVAR ENTRADA'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_formKey.currentState?.validate() != true) return;

    final productId = _selectedProductId;
    final quantity = _parseInt(_quantityController.text);
    final costPrice = _parseCurrency(_costController.text);
    final salePrice = _parseCurrency(_salePriceController.text);
    if (productId == null ||
        quantity <= 0 ||
        costPrice <= 0 ||
        salePrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe valores maiores que zero.')),
      );
      return;
    }

    final entry = EstoqueModel(
      produtoId: productId,
      quantidade: quantity,
      custoUnitario: costPrice,
      fornecedor: _selectedSupplier ?? '',
      complemento: '',
      novoValorVenda: salePrice,
    );

    try {
      await context.read<StockProvider>().registerEntry(entry, salePrice);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrada registrada com sucesso!')),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registrar entrada: $error')),
      );
    }
  }

  ProdutoModel? _findProduct(List<ProdutoModel> products, String? localId) {
    if (localId == null) return null;
    for (final product in products) {
      if (product.localId == localId) return product;
    }
    return null;
  }

  String? _requiredValue(String? value) {
    return value == null || value.trim().isEmpty ? 'Obrigatório' : null;
  }

  double _parseCurrency(String text) {
    final trimmed = text.trim();
    final normalized = trimmed.contains(',')
        ? trimmed.replaceAll('.', '').replaceAll(',', '.')
        : trimmed;
    return double.tryParse(normalized) ?? 0;
  }

  int _parseInt(String text) {
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _costController.dispose();
    _salePriceController.dispose();
    super.dispose();
  }
}
