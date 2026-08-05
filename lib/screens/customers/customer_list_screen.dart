import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cliente_model.dart';
import '../../providers/customer_provider.dart';
import '../../providers/sale_provider.dart';
import '../../providers/sync_controller.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../utils/search_helper.dart';
import '../../utils/sync_feedback.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/sync_status_button.dart';
import 'customer_profile_screen.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  String? _selectedFilter;
  String _searchQuery = '';

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

  Future<void> _refreshCustomers() async {
    final report = await context.read<SyncController>().refreshCustomers();
    if (!mounted) return;
    await context.read<CustomerProvider>().loadCustomers();
    if (!mounted) return;
    showSyncFeedback(context, report);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerProvider>();
    final saleProvider = context.watch<SaleProvider>();
    final customers = provider.customers;

    final filteredCustomers = SearchHelper.filterList(
      items: customers,
      query: _searchQuery,
      searchBy: (customer) => customer.nome,
    ).toList();

    double totalPendenteFor(ClienteModel c) {
      if (c.localId == null) return 0.0;
      final insights = saleProvider.getCachedInsights(c.localId!);
      return (insights?['totalPendente'] as num?)?.toDouble() ?? 0.0;
    }

    double totalCompradoFor(ClienteModel c) {
      if (c.localId == null) return 0.0;
      final insights = saleProvider.getCachedInsights(c.localId!);
      return (insights?['totalComprado'] as num?)?.toDouble() ?? 0.0;
    }

    if (_selectedFilter != null) {
      switch (_selectedFilter) {
        case 'Maiores Devedores':
          filteredCustomers.sort(
            (a, b) => totalPendenteFor(b).compareTo(totalPendenteFor(a)),
          );
          break;
        case 'Menores Devedores':
          filteredCustomers.sort(
            (a, b) => totalPendenteFor(a).compareTo(totalPendenteFor(b)),
          );
          break;
        case 'Maiores Compradores':
          filteredCustomers.sort(
            (a, b) => totalCompradoFor(b).compareTo(totalCompradoFor(a)),
          );
          break;
        case 'Menores Compradores':
          filteredCustomers.sort(
            (a, b) => totalCompradoFor(a).compareTo(totalCompradoFor(b)),
          );
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: const [SyncStatusButton()],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshCustomers,
        child: provider.isLoading
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(
                    height: 400,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          initialValue: _filterOptions.contains(_selectedFilter)
                              ? _selectedFilter
                              : null,
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
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(
                                height: 300,
                                child: Center(
                                  child: Text(
                                    'Nenhum cliente encontrado.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 0,
                            ),
                            itemCount: filteredCustomers.length,
                            itemBuilder: (context, index) {
                              final c = filteredCustomers[index];
                              final totalComprado = totalCompradoFor(c);
                              final totalPendente = totalPendenteFor(c);

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
                                        builder: (_) =>
                                            CustomerProfileScreen(customer: c),
                                      ),
                                    );
                                  },
                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          c.referencia.isEmpty
                                              ? c.celular
                                              : c.referencia,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () => _showEditDialog(c),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () => _confirmDelete(c),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.message,
                                            color: Colors.green),
                                        onPressed: () =>
                                            _openWhatsApp(c.celular),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Future<void> _openWhatsApp(String phone) async {
    try {
      await WhatsAppHelper.openConversation(phone);
    } on WhatsAppException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: AppColors.error,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      debugPrint('Erro inesperado ao abrir conversa no WhatsApp: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir o WhatsApp.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showAddDialog(BuildContext context) {
    final provider = context.read<CustomerProvider>();
    final nomeController = TextEditingController();
    final phoneController = TextEditingController();
    final referenciaController = TextEditingController();
    final observacoesController = TextEditingController();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
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
                controller: referenciaController,
                decoration: const InputDecoration(labelText: 'Referência'),
              ),
              TextField(
                controller: observacoesController,
                decoration: const InputDecoration(labelText: 'Observações'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              final c = ClienteModel(
                nome: nomeController.text,
                celular: phoneController.text,
                referencia: referenciaController.text,
                observacoes: observacoesController.text,
              );
              try {
                await provider.addCustomer(c);
                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
              } catch (error) {
                if (!dialogContext.mounted) return;
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  SnackBar(content: Text('Erro ao salvar cliente: $error')),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    ).whenComplete(() {
      nomeController.dispose();
      phoneController.dispose();
      referenciaController.dispose();
      observacoesController.dispose();
    });
  }

  void _showEditDialog(ClienteModel cliente) {
    final provider = context.read<CustomerProvider>();
    final nomeController = TextEditingController(text: cliente.nome);
    final phoneController = TextEditingController(text: cliente.celular);
    final referenciaController =
        TextEditingController(text: cliente.referencia);
    final observacoesController =
        TextEditingController(text: cliente.observacoes);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
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
                controller: referenciaController,
                decoration: const InputDecoration(labelText: 'Referência'),
              ),
              TextField(
                controller: observacoesController,
                decoration: const InputDecoration(labelText: 'Observações'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              final c = ClienteModel(
                localId: cliente.localId,
                id: cliente.id,
                nome: nomeController.text,
                celular: phoneController.text,
                referencia: referenciaController.text,
                observacoes: observacoesController.text,
                ativo: cliente.ativo,
                legacyId: cliente.legacyId,
              );

              try {
                await provider.updateCustomer(c);
                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
              } catch (error) {
                if (!dialogContext.mounted) return;
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  SnackBar(content: Text('Erro ao atualizar cliente: $error')),
                );
              }
            },
            child: const Text('Salvar Alterações'),
          ),
        ],
      ),
    ).whenComplete(() {
      nomeController.dispose();
      phoneController.dispose();
      referenciaController.dispose();
      observacoesController.dispose();
    });
  }

  Future<void> _confirmDelete(ClienteModel cliente) async {
    final localId = cliente.localId;
    if (localId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remover cliente'),
        content: Text(
          'Deseja remover ${cliente.nome}? Clientes com vendas serão apenas desativados.',
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
      final result =
          await context.read<CustomerProvider>().deleteCustomer(localId);
      if (!mounted) return;
      final message = result == CustomerDeleteResult.deactivated
          ? 'Cliente desativado porque possui vendas.'
          : 'Cliente removido.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao remover cliente: $error')),
      );
    }
  }
}
