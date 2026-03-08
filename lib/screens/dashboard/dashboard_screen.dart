import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../widgets/summary_card.dart';
import '../../services/supabase_service.dart';
import '../sales/sale_history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double _monthlySales = 0;
  double _receivables = 0;
  Map<String, int> _topCategories = {};

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final client = SupabaseService().client;

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final salesRes = await client
        .from(AppTables.vendas)
        .select('valor_total')
        .gte('data_venda', startOfMonth.toIso8601String())
        .lte('data_venda', endOfMonth.toIso8601String());

    final parcelsRes = await client
        .from(AppTables.parcelas)
        .select('valor')
        .eq('status', 'pendente')
        .gte('data_vencimento', startOfMonth.toIso8601String())
        .lte('data_vencimento', endOfMonth.toIso8601String());

    // 1. Busca também a quantidade_estoque agora!
    final productsRes = await client.from(AppTables.produtos).select('tipo, quantidade_estoque');

    double totalSales = 0;
    for (var s in (salesRes as List)) {
      totalSales += (s['valor_total'] as num).toDouble();
    }

    double totalReceivables = 0;
    for (var p in (parcelsRes as List)) {
      totalReceivables += (p['valor'] as num).toDouble();
    }

    // 2. Soma a quantidade real do estoque por categoria
    Map<String, int> categories = {};
    for (var prod in (productsRes as List)) {
      String t = prod['tipo'] ?? 'Outros';
      int qtd = (prod['quantidade_estoque'] as num?)?.toInt() ?? 0;
      
      // Só adiciona no gráfico se tiver pelo menos 1 no estoque
      if (qtd > 0) {
        categories[t] = (categories[t] ?? 0) + qtd;
      }
    }

    setState(() {
      _monthlySales = totalSales;
      _receivables = totalReceivables;
      _topCategories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calcula o total geral de itens no estoque para fazer a porcentagem
    final totalItensEstoque = _topCategories.values.fold(0, (sum, item) => sum + item);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Venstoque', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadStats,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(), // Garante que o refresh funcione mesmo se a tela for pequena
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Visão Geral',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  SummaryCard(
                    title: 'Vendido (Mês)',
                    value: AppFormatters.formatCurrency(_monthlySales),
                    icon: Icons.attach_money,
                    color: AppColors.primary,
                  ),
                  SummaryCard(
                    title: 'A Receber (Mês)',
                    value: AppFormatters.formatCurrency(_receivables),
                    icon: Icons.account_balance_wallet,
                    color: AppColors.warning,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              const Text(
                'Distribuição do Estoque',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              
              // Bloco do Gráfico
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade800, width: 1),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 220, // Altura do gráfico
                      child: _topCategories.isEmpty 
                        ? const Center(child: Text('Estoque zerado', style: TextStyle(color: Colors.grey)))
                        : PieChart(
                            PieChartData(
                              centerSpaceRadius: 0, // Zero tira o buraco e faz virar pizza completa
                              sectionsSpace: 1, // Espaço mínimo entre as fatias
                              sections: _topCategories.entries.map((e) {
                                final color = Colors.primaries[_topCategories.keys.toList().indexOf(e.key) % Colors.primaries.length];
                                return PieChartSectionData(
                                  value: e.value.toDouble(),
                                  color: color,
                                  radius: 110, // Tamanho da fatia
                                  showTitle: false, // Esconde os textos
                                );
                              }).toList(),
                            ),
                          ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Legenda customizada com as Porcentagens
                    if (_topCategories.isNotEmpty)
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: _topCategories.entries.map((e) {
                          final category = e.key;
                          final value = e.value;
                          final color = Colors.primaries[_topCategories.keys.toList().indexOf(category) % Colors.primaries.length];
                          
                          // Regra de 3 para descobrir a porcentagem
                          final percentage = totalItensEstoque > 0 ? (value / totalItensEstoque) * 100 : 0.0;
                          
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$category (${percentage.toStringAsFixed(1)}%)',
                                style: const TextStyle(
                                  color: Colors.white, 
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SalesHistoryScreen()),
                    );
                  },
                  icon: const Icon(Icons.history, color: AppColors.primary),
                  label: const Text('VER HISTÓRICO DE VENDAS', style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}