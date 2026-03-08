import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/customer_provider.dart';
import '../../models/cliente_model.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import 'customer_profile_screen.dart';
import '../../widgets/custom_search_bar.dart'; // NOVO IMPORT
import '../../utils/search_helper.dart'; // NOVO IMPORT (verifique a ortografia)

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  String? _selectedFilter;
  String _searchQuery = ''; // NOVO: Variável da busca

  final List<String> _filterOptions = const [
    'Maiores Devedores',
    'Menores Devedores',
    'Maiores Compradores',
    'Menores Compradores',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerProvider>().loadCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerProvider>();
    final customers = provider.customers;

    // 1. APLICA A BARRA DE PESQUISA (Filtra a lista original)
    List<ClienteModel> filteredCustomers = SearchHelper.filterList(
      items: customers,
      query: _searchQuery,
      searchBy: (c) => c.nome, // Diz pra função buscar pelo Nome do Cliente
    );

    double _totalPendente(ClienteModel c) {
      if (c.id == null) return 0.0;
      final insights = provider.getCachedInsights(c.id!);
      return (insights?['totalPendente'] as num?)?.toDouble() ?? 0.0;
    }

    double _totalComprado(ClienteModel c) {
      if (c.id == null) return 0.0;
      final insights = provider.getCachedInsights(c.id!);
      return (insights?['totalComprado'] as num?)?.toDouble() ?? 0.0;
    }

    // 2. APLICA A ORDENAÇÃO NO RESULTADO DA PESQUISA
    if (_selectedFilter != null) {
      switch (_selectedFilter) {
        case 'Maiores Devedores':
          filteredCustomers.sort(
            (a, b) => _totalPendente(b).compareTo(_totalPendente(a)),
          );
          break;
        case 'Menores Devedores':
          filteredCustomers.sort(
            (a, b) => _totalPendente(a).compareTo(_totalPendente(b)),
          );
          break;
        case 'Maiores Compradores':
          filteredCustomers.sort(
            (a, b) => _totalComprado(b).compareTo(_totalComprado(a)),
          );
          break;
        case 'Menores Compradores':
          filteredCustomers.sort(
            (a, b) => _totalComprado(a).compareTo(_totalComprado(b)),
          );
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NOVO: BARRA DE PESQUISA NA TELA
                      CustomSearchBar(
                        hintText: 'Buscar Cliente pelo nome...',
                        onChanged: (texto) {
                          setState(() {
                            _searchQuery = texto;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      const Text(
                        'Filtrar Clientes',
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
                          });
                        },
                        isExpanded: true,
                        hint: const Text('Ordenar por'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: filteredCustomers.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhum cliente encontrado.',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          itemCount: filteredCustomers.length,
                          itemBuilder: (context, index) {
                            final c = filteredCustomers[index];
                            final totalComprado = _totalComprado(c);
                            final totalPendente = _totalPendente(c);

                            return Card(
                              color: AppColors.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.shade800),
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CustomerProfileScreen(customer: c),
                                    ),
                                  );
                                },
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        c.nome,
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        c.bairro,
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      'Total comprado: ${AppFormatters.formatCurrency(totalComprado)}',
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      'Pendente: ${AppFormatters.formatCurrency(totalPendente)}',
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _showEditDialog(c),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.message, color: Colors.green),
                                      onPressed: () => _openWhatsApp(c.celular),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void _openWhatsApp(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final url = Uri.parse("https://wa.me/55$cleanPhone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _showAddDialog(BuildContext context) {
    final nomeController = TextEditingController();
    final phoneController = TextEditingController();
    final bairroController = TextEditingController();
    final referenciaController = TextEditingController();
    final referenciaNomeController = TextEditingController();
    final referenciaTelefoneController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false, // NOVO: Trava o modal de adicionar
      builder: (context) => AlertDialog(
        title: const Text('Novo Cliente'),
        titleTextStyle: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 85, 186, 22)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome')),
              TextField(
                  controller: phoneController,
                  decoration:
                      const InputDecoration(labelText: 'Celular (com DDD)')),
              TextField(
                  controller: bairroController,
                  decoration: const InputDecoration(labelText: 'Bairro')),
              const Divider(height: 32, thickness: 1),
              const Icon(Icons.person_outline, size: 32, color: Colors.grey),
              const SizedBox(height: 16),
              TextField(
                  controller: referenciaNomeController,
                  decoration:
                      const InputDecoration(labelText: 'Nome da Referência')),
              TextField(
                  controller: referenciaTelefoneController,
                  decoration: const InputDecoration(
                      labelText: 'Telefone da Referência')),
              const SizedBox(height: 16),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () {
              final c = ClienteModel(
                nome: nomeController.text,
                celular: phoneController.text,
                referencia: referenciaController.text,
                bairro: bairroController.text,
                nomeReferencia: referenciaNomeController.text,
                telefoneReferencia: referenciaTelefoneController.text,
              );
              context.read<CustomerProvider>().addCustomer(c);
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(ClienteModel cliente) {
    final nomeController = TextEditingController(text: cliente.nome);
    final phoneController = TextEditingController(text: cliente.celular);
    final bairroController = TextEditingController(text: cliente.bairro);
    final referenciaController =
        TextEditingController(text: cliente.referencia);
    final referenciaNomeController =
        TextEditingController(text: cliente.nomeReferencia);
    final referenciaTelefoneController =
        TextEditingController(text: cliente.telefoneReferencia);

    showDialog(
      context: context,
      barrierDismissible: false, // NOVO: Trava o modal de editar
      builder: (context) => AlertDialog(
        title: const Text('Editar Cliente'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome')),
              TextField(
                  controller: phoneController,
                  decoration:
                      const InputDecoration(labelText: 'Celular (com DDD)')),
              TextField(
                  controller: bairroController,
                  decoration: const InputDecoration(labelText: 'Bairro')),
              const Divider(height: 32, thickness: 1),
              const Icon(Icons.person_outline, size: 32, color: Colors.grey),
              const SizedBox(height: 16),
              TextField(
                  controller: referenciaNomeController,
                  decoration:
                      const InputDecoration(labelText: 'Nome da Referência')),
              TextField(
                  controller: referenciaTelefoneController,
                  decoration: const InputDecoration(
                      labelText: 'Telefone da Referência')),
              const SizedBox(height: 16),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () {
              // Atenção: Aqui é recomendável usar um updateCustomer no Provider 
              // em vez de addCustomer para não duplicar o cliente.
              final c = ClienteModel(
                id: cliente.id, // Preserva o ID original para atualizar
                nome: nomeController.text,
                celular: phoneController.text,
                referencia: referenciaController.text,
                bairro: bairroController.text,
                nomeReferencia: referenciaNomeController.text,
                telefoneReferencia: referenciaTelefoneController.text,
              );
              
              // Verifique se você tem uma função updateCustomer no seu CustomerProvider
              // Se não tiver, o ideal é criar para ele dar um UPDATE no banco e não um INSERT.
              context.read<CustomerProvider>().addCustomer(c); 
              Navigator.pop(context);
            },
            child: const Text('Salvar Alterações'),
          ),
        ],
      ),
    );
  }
}