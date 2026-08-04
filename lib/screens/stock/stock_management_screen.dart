import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/produto_model.dart';
import '../../providers/stock_provider.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../utils/search_helper.dart';
import '../../widgets/custom_search_bar.dart';
import 'register_entry_screen.dart';
import 'register_product_screen.dart';

enum _ProductAction { edit, delete }

class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({super.key});

  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  String? _selectedFilter;
  String? _selectedCategory = 'Todas';
  String _searchQuery = '';

  static const _filterOptions = [
    'Preço de Custo (Crescente)',
    'Preço de Custo (Decrescente)',
    'Preço de Venda (Crescente)',
    'Preço de Venda (Decrescente)',
    'Quantidade (Crescente)',
    'Quantidade (Decrescente)',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StockProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StockProvider>();
    final products = provider.products;
    final categories = products.map((product) => product.categoria).toSet()
      ..removeWhere((category) => category.isEmpty);
    final sortedCategories = categories.toList()..sort();

    final searchedProducts = SearchHelper.filterList(
      items: products,
      query: _searchQuery,
      searchBy: (product) => '${product.nome} ${product.categoria}',
    );
    final filteredProducts = searchedProducts.where(
      (product) =>
          _selectedCategory == null ||
          _selectedCategory == 'Todas' ||
          product.categoria == _selectedCategory,
    );
    final processedProducts = _sortProducts(filteredProducts);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Estoque'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: provider.isLoading && products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomSearchBar(
                        hintText: 'Buscar produto...',
                        onChanged: (value) {
                          setState(() => _searchQuery = value);
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Filtrar Produtos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue:
                                  _filterOptions.contains(_selectedFilter)
                                      ? _selectedFilter
                                      : null,
                              decoration: _dropdownDecoration(),
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
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedCategory == 'Todas' ||
                                      sortedCategories.contains(
                                        _selectedCategory,
                                      )
                                  ? _selectedCategory
                                  : null,
                              decoration: _dropdownDecoration(),
                              items: [
                                const DropdownMenuItem(
                                  value: 'Todas',
                                  child: Text('Todas'),
                                ),
                                ...sortedCategories.map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() => _selectedCategory = value);
                              },
                              isExpanded: true,
                              hint: const Text('Categoria'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: processedProducts.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhum produto encontrado.',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: processedProducts.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            return _buildProductCard(
                              context,
                              processedProducts[index],
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'registerProduct',
            onPressed: () => _openProductForm(),
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add_box, color: Colors.white),
            label: const Text(
              'Novo Produto',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            heroTag: 'registerEntry',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RegisterEntryScreen(),
                ),
              );
            },
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
            label: const Text(
              'Nova Entrada',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProdutoModel product) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade700),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          product.nome,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          '${product.categoria}\n'
          'Fornecedor: ${product.fornecedor.isEmpty ? "-" : product.fornecedor}\n'
          'Custo: ${AppFormatters.formatCurrency(product.precoCusto)}',
          style: TextStyle(color: Colors.grey.shade400),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Qtd: ${product.quantidadeEstoque}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: product.quantidadeEstoque <= 0
                        ? Colors.red
                        : product.isLowStock
                            ? Colors.orange
                            : Colors.green,
                  ),
                ),
                Text(
                  AppFormatters.formatCurrency(product.valorVenda),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            PopupMenuButton<_ProductAction>(
              onSelected: (action) {
                switch (action) {
                  case _ProductAction.edit:
                    _openProductForm(product);
                  case _ProductAction.delete:
                    _confirmDelete(product);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: _ProductAction.edit,
                  child: Text('Editar'),
                ),
                PopupMenuItem(
                  value: _ProductAction.delete,
                  child: Text('Remover'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<ProdutoModel> _sortProducts(Iterable<ProdutoModel> products) {
    final sortedProducts = products.toList();
    sortedProducts.sort((first, second) {
      switch (_selectedFilter) {
        case 'Preço de Custo (Crescente)':
          return first.precoCusto.compareTo(second.precoCusto);
        case 'Preço de Custo (Decrescente)':
          return second.precoCusto.compareTo(first.precoCusto);
        case 'Preço de Venda (Crescente)':
          return first.valorVenda.compareTo(second.valorVenda);
        case 'Preço de Venda (Decrescente)':
          return second.valorVenda.compareTo(first.valorVenda);
        case 'Quantidade (Crescente)':
          return first.quantidadeEstoque.compareTo(second.quantidadeEstoque);
        case 'Quantidade (Decrescente)':
          return second.quantidadeEstoque.compareTo(first.quantidadeEstoque);
        default:
          return first.nome.toLowerCase().compareTo(
                second.nome.toLowerCase(),
              );
      }
    });
    return sortedProducts;
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
    );
  }

  void _openProductForm([ProdutoModel? product]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterProductScreen(product: product),
      ),
    );
  }

  Future<void> _confirmDelete(ProdutoModel product) async {
    final localId = product.localId;
    if (localId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remover produto'),
        content: Text(
          'Deseja remover ${product.nome}? Produtos presentes em vendas serão apenas desativados.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    try {
      final result = await context.read<StockProvider>().deleteProduct(localId);
      if (!mounted) return;
      final message = result == ProductDeleteResult.deactivated
          ? 'Produto desativado porque possui vendas.'
          : 'Produto removido.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao remover produto: $error')),
      );
    }
  }
}
