import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cliente_model.dart';
import '../../providers/customer_provider.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';

class CustomerProfileScreen extends StatelessWidget {
  final ClienteModel customer;

  const CustomerProfileScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customer.nome),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dados de Contato',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Nome: ${customer.nome}'),
            Text('Telefone: ${customer.celular}'),
            Text('Bairro: ${customer.bairro}'),
            const Divider(),
            const Text(
              'Referência',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Nome: ${customer.nomeReferencia ?? "-"}'),
            Text('Telefone: ${customer.telefoneReferencia ?? "-"}'),
            const Divider(),
            const Text(
              'Insights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureBuilder<Map<String, dynamic>>(
              future: context
                  .read<CustomerProvider>()
                  .getCustomerInsights(customer.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return const Text('Erro ao carregar insights');
                }
                final insights = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Total comprado: ${AppFormatters.formatCurrency(insights['totalComprado'] ?? 0.0)}'),
                    Text(
                        'Tipo mais comprado: ${insights['tipoMaisComprado'] ?? '-'}'),
                    Text(
                        'Tipo de pagamento mais usado: ${insights['tipoPagamentoMaisUsado'] ?? '-'}'),
                    const Divider(),
                    const Text(
                      'Ficha',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                        'Total pendente: ${AppFormatters.formatCurrency(insights['totalPendente'] ?? 0.0)}'),
                    Text('Total de atrasos: ${insights['totalAtrasos'] ?? 0}'),
                  ],
                );
              },
            ),
            const Divider(),
            const Text(
              'Histórico',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              items: const [
                DropdownMenuItem(value: '30', child: Text('Últimos 30 dias')),
                DropdownMenuItem(value: '90', child: Text('Últimos 3 meses')),
                DropdownMenuItem(value: '180', child: Text('Últimos 6 meses')),
                DropdownMenuItem(value: '365', child: Text('Últimos 12 meses')),
              ],
              onChanged: (value) {
                context
                    .read<CustomerProvider>()
                    .loadCustomerHistory(customer.id!, int.parse(value!));
              },
              hint: const Text('Selecione o período'),
            ),
            const SizedBox(height: 16),
            Consumer<CustomerProvider>(
              builder: (context, provider, _) {
                if (provider.isLoadingHistory) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Proteção caso o cliente não tenha histórico no período
                if (provider.customerHistory.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Nenhum histórico encontrado para este período.', 
                                style: TextStyle(color: Colors.grey)),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.customerHistory.length,
                  itemBuilder: (context, index) {
                    final history = provider.customerHistory[index];
                    final rawValor = history['valor'];
                    
                    String valorTexto;
                    if (rawValor is num) {
                      valorTexto = context
                          .read<CustomerProvider>()
                          .formatarPreco(rawValor);
                    } else {
                      valorTexto = rawValor.toString();
                    }

                    final rawParcelas = history['numero_parcela']; 
                    final int? numParcelas = (rawParcelas is num) 
                        ? rawParcelas.toInt() 
                        : int.tryParse(rawParcelas?.toString() ?? '');
                    
                    if (numParcelas != null && numParcelas > 1) {
                      valorTexto = '$valorTexto em ${numParcelas}x'; 
                    }

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(history['produto'] ?? 'Produto'),
                      subtitle: Text(
                        'Data: ${AppFormatters.formatDate(DateTime.parse(history['data']))}',
                      ),
                      trailing: Text(
                        valorTexto,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            history['tipo_pagamento']?.toString().toUpperCase().replaceAll('_', ' ') ?? '-',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}