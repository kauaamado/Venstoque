import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/stock_provider.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../models/produto_model.dart';
import 'register_entry_screen.dart';
import 'register_product_screen.dart';
import '../../widgets/custom_search_bar.dart';
import '../../utils/search_helper.dart'; // Corrigido para search_helper.dart

class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({super.key});

  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  String? _selectedFilter;
  String? _selectedType = 'Todos';
  String _searchQuery = ''; // Nossa variável da barra de pesquisa

  final List<String> _filterOptions = [
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
    final products = context.watch<StockProvider>().products;

    // ==========================================
    // 1. APLICA A BARRA DE PESQUISA (SearchHelper)
    // ==========================================
    List<ProdutoModel> processedProducts = SearchHelper.filterList(
      items: products,
      query: _searchQuery,
      // Busca pelo nome do modelo (se quiser buscar por tipo também, mude para: (p) => '${p.modelo} ${p.tipo}')
      searchBy: (p) => p.modelo, 
    );

    // ==========================================
    // 2. APLICA O FILTRO DE TIPO (Dropdown)
    // ==========================================
    if (_selectedType != null && _selectedType != 'Todos') {
      processedProducts = processedProducts.where((p) => p.tipo == _selectedType).toList();
    }

    // ==========================================
    // 3. APLICA A ORDENAÇÃO (Dropdown de Filtros)
    // ==========================================
    if (_selectedFilter != null) {
      processedProducts.sort((a, b) {
        switch (_selectedFilter) {
          case 'Preço de Custo (Crescente)':
            return a.precoCusto.compareTo(b.precoCusto);
          case 'Preço de Custo (Decrescente)':
            return b.precoCusto.compareTo(a.precoCusto);
          case 'Preço de Venda (Crescente)':
            return a.valorVenda.compareTo(b.valorVenda);
          case 'Preço de Venda (Decrescente)':
            return b.valorVenda.compareTo(a.valorVenda);
          case 'Quantidade (Crescente)':
            return a.quantidadeEstoque.compareTo(b.quantidadeEstoque);
          case 'Quantidade (Decrescente)':
            return b.quantidadeEstoque.compareTo(a.quantidadeEstoque);
          default:
            return 0;
        }
      });
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
                // ==========================================
                // BARRA DE PESQUISA NA TELA
                // ==========================================
                CustomSearchBar(
                  hintText: 'Buscar Produto pelo nome...',
                  onChanged: (texto) {
                    setState(() {
                      _searchQuery = texto;
                    });
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
                        hint: const Text('Ordenar por'),
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
                        hint: const Text('Tipo'),
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
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final prod = processedProducts[index];
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade700),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(prod.modelo,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          subtitle: Text(
                              '${prod.tipo} - ${prod.complemento}\nCusto: ${AppFormatters.formatCurrency(prod.precoCusto)}',
                              style: TextStyle(color: Colors.grey.shade400)),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Qtd: ${prod.quantidadeEstoque}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: prod.quantidadeEstoque <= 0
                                      ? Colors.red
                                      : (prod.isLowStock
                                          ? Colors.orange
                                          : Colors.green),
                                ),
                              ),
                              Text(
                                AppFormatters.formatCurrency(prod.valorVenda),
                                style: const TextStyle(
                                    color: Colors.white,
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
            icon: const Icon(Icons.add_box, color: Colors.white),
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
            icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
            label: const Text('Nova Entrada',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}