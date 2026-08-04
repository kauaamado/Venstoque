import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/produto_model.dart';
import '../../providers/stock_provider.dart';
import '../../utils/constants.dart';

class RegisterProductScreen extends StatefulWidget {
  const RegisterProductScreen({super.key, this.product});

  final ProdutoModel? product;

  @override
  State<RegisterProductScreen> createState() => _RegisterProductScreenState();
}

class _RegisterProductScreenState extends State<RegisterProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _costController;
  late final TextEditingController _salePriceController;

  String? _selectedCategory;
  String? _selectedSupplier;

  static const _defaultCategories = [
    'Perfumes',
    'Eletrônicos',
    'Relógios',
    'Copos',
    'Garrafas',
    'Camisas',
    'Canecas',
  ];

  static const _defaultSuppliers = [
    'Papo de Boleiro',
    'Rasha',
    'Smart Mania',
    'Outros',
  ];

  bool get _isEditing => widget.product != null;

  List<String> get _categories => _optionsIncluding(
        _defaultCategories,
        widget.product?.categoria,
      );

  List<String> get _suppliers => _optionsIncluding(
        _defaultSuppliers,
        widget.product?.fornecedor,
      );

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product?.nome ?? '');
    _costController = TextEditingController(
      text: product == null
          ? ''
          : product.precoCusto.toStringAsFixed(2).replaceAll('.', ','),
    );
    _salePriceController = TextEditingController(
      text: product == null
          ? ''
          : product.valorVenda.toStringAsFixed(2).replaceAll('.', ','),
    );
    _selectedCategory = product?.categoria;
    _selectedSupplier = product?.fornecedor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Produto' : 'Cadastrar Produto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: _categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value);
                },
                validator: _requiredValue,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome do Produto'),
                validator: _requiredValue,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(
                  labelText: 'Custo Unitário (R\$)',
                ),
                keyboardType: TextInputType.number,
                validator: _requiredValue,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _salePriceController,
                decoration: const InputDecoration(
                  labelText: 'Preço de Venda (R\$)',
                ),
                keyboardType: TextInputType.number,
                validator: _requiredValue,
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                initialValue: _selectedSupplier,
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
                  child: Text(
                    _isEditing ? 'SALVAR ALTERAÇÕES' : 'SALVAR PRODUTO',
                  ),
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

    final costPrice = _parseCurrency(_costController.text);
    final salePrice = _parseCurrency(_salePriceController.text);
    if (costPrice <= 0 || salePrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe valores de custo e venda maiores que zero.'),
        ),
      );
      return;
    }

    final current = widget.product;
    final product = ProdutoModel(
      localId: current?.localId,
      id: current?.id,
      nome: _nameController.text,
      categoria: _selectedCategory ?? '',
      fornecedor: _selectedSupplier ?? '',
      precoCusto: costPrice,
      valorVenda: salePrice,
      quantidadeEstoque: current?.quantidadeEstoque ?? 0,
      ativo: current?.ativo ?? true,
    );

    try {
      final provider = context.read<StockProvider>();
      if (_isEditing) {
        await provider.updateProduct(product);
      } else {
        await provider.addProduct(product);
      }
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Produto atualizado com sucesso!'
                : 'Produto cadastrado com sucesso!',
          ),
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar produto: $error')),
      );
    }
  }

  List<String> _optionsIncluding(List<String> defaults, String? current) {
    if (current == null || current.isEmpty || defaults.contains(current)) {
      return defaults;
    }
    return [current, ...defaults];
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

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    _salePriceController.dispose();
    super.dispose();
  }
}
