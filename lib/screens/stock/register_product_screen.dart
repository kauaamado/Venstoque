import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/produto_model.dart';
import '../../providers/stock_provider.dart';
import '../../utils/constants.dart';

class RegisterProductScreen extends StatefulWidget {
  const RegisterProductScreen({super.key});

  @override
  State<RegisterProductScreen> createState() => _RegisterProductScreenState();
}

class _RegisterProductScreenState extends State<RegisterProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _complementController = TextEditingController();
  final _costController = TextEditingController();
  final _salePriceController = TextEditingController();
  
  String? _selectedType;
  String? _selectedFornecedor; // <-- Nova variável para o fornecedor selecionado

  final List<String> _productTypes = [
    'Perfumes',
    'Eletrônicos',
    'Relógios',
    'Copos',
    'Garrafas',
    'Camisas',
    'Canecas',
  ];

  // <-- Lista fixa de fornecedores
  final List<String> _fornecedores = [
    'Papo de Boleiro',
    'Rasha',
    'Smart Mania',
    'Outros',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Produto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tipo'),
                value: _selectedType,
                items: _productTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
                validator: (value) =>
                    value == null || value.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome do Produto'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _complementController,
                decoration: const InputDecoration(labelText: 'Complemento'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _costController,
                decoration:
                    const InputDecoration(labelText: 'Custo Unitário (R\$)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _salePriceController,
                decoration:
                    const InputDecoration(labelText: 'Preço de Venda (R\$)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 24),
              
              // <-- Dropdown de Fornecedores substituiu o TextFormField aqui
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Fornecedor'),
                value: _selectedFornecedor,
                items: _fornecedores
                    .map((fornecedor) => DropdownMenuItem(
                          value: fornecedor,
                          child: Text(fornecedor),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFornecedor = value;
                  });
                },
                validator: (value) =>
                    value == null || value.isEmpty ? 'Obrigatório' : null,
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
                  child: const Text('SALVAR PRODUTO'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final precoCusto = double.tryParse(_costController.text);
      final valorVenda = double.tryParse(_salePriceController.text);

      if (precoCusto == null || precoCusto <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Custo Unitário deve ser um número válido e maior que zero.')),
        );
        return;
      }

      if (valorVenda == null || valorVenda <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Preço de Venda deve ser um número válido e maior que zero.')),
        );
        return;
      }

      final newProduct = ProdutoModel(
        modelo: _nameController.text,
        tipo: _selectedType!,
        complemento: _complementController.text,
        fornecedor: _selectedFornecedor!, // <-- Usando a variável do dropdown
        precoCusto: precoCusto,
        valorVenda: valorVenda,
        quantidadeEstoque: 0,
      );

      await context.read<StockProvider>().addProduct(newProduct);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto cadastrado com sucesso!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar produto: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    _complementController.dispose();
    _salePriceController.dispose();
    // _supplierController.dispose(); <-- Removido daqui também
    super.dispose();
  }
}