import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/stock_provider.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../models/produto_model.dart';
import 'register_entry_screen.dart';
import 'register_product_screen.dart';

class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({super.key});

  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  String? _selectedFilter;
  String? _selectedType = 'Todos';

  final List<String> _filterOptions = [
    'Preço de Custo (Crescente)',
    'Preço de Custo (Decrescente)',
    'Preço de Venda (Crescente)',
    'Preço de Venda (Decrescente)',
    'Lucro (Crescente)',
    'Lucro (Decrescente)',
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
    final products = context.watch<StockProvider>().products;

/*
    if (products.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
*/
    List<ProdutoModel> filteredProducts = products;

    if (_selectedType != null && _selectedType != 'Todos') {
      filteredProducts =
          products.where((p) => p.tipo == _selectedType).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Estoque'),
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
                            .map((filter) => DropdownMenuItem(
                                  value: filter,
                                  child: Text(filter),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFilter = value;
                          });
                        },
                        isExpanded: true,
                        hint: const Text('Selecione um filtro'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                        value: () {
                          final types = products.map((p) => p.tipo).toSet().toList();
                          final valid = ['Todos', ...types];
                          return valid.contains(_selectedType) ? _selectedType : null;
                        }(),
                        items: [
                          const DropdownMenuItem(
                            value: 'Todos',
                            child: Text('Todos'),
                          ),
                          ...products
                              .map((p) => p.tipo)
                              .toSet()
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value;
                          });
                        },
                        isExpanded: true,
                        hint: const Text('Selecione um tipo'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredProducts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final prod = filteredProducts[index];
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(prod.modelo,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        '${prod.tipo} - ${prod.complemento}\nCusto: ${AppFormatters.formatCurrency(prod.precoCusto)}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Qtd: ${prod.quantidadeEstoque}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: prod.quantidadeEstoque <= 0
                                ? AppColors.error
                                : (prod.isLowStock
                                    ? AppColors.warning
                                    : AppColors.textPrimary),
                          ),
                        ),
                        Text(
                          AppFormatters.formatCurrency(prod.valorVenda),
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'registerProduct',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterProductScreen(),
                ),
              );
            },
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add_box),
            label: const Text('Novo Produto',
                style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            heroTag: 'registerEntry',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterEntryScreen(),
                ),
              );
            },
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Nova Entrada',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
