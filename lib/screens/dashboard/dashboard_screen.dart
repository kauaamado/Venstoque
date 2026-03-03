import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../widgets/summary_card.dart';
import '../../services/supabase_service.dart';

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

    // 1. Descobre o início e o fim do mês atual
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    // O dia "0" do mês seguinte é o último dia do mês atual
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59); 

    // 2. Busca apenas as vendas dentro desse intervalo (data_venda)
    final salesRes = await client
        .from(AppTables.vendas)
        .select('valor_total')
        .gte('data_venda', startOfMonth.toIso8601String())
        .lte('data_venda', endOfMonth.toIso8601String());

    // 3. Busca parcelas pendentes que vencem no mês atual (data_vencimento)
    final parcelsRes = await client
        .from(AppTables.parcelas)
        .select('valor')
        .eq('status', 'pendente')
        .gte('data_vencimento', startOfMonth.toIso8601String())
        .lte('data_vencimento', endOfMonth.toIso8601String());
        
    final productsRes = await client.from(AppTables.produtos).select('tipo');

    double totalSales = 0;
    for (var s in (salesRes as List)) {
      totalSales += (s['valor_total'] as num).toDouble();
    }

    double totalReceivables = 0;
    for (var p in (parcelsRes as List)) {
      totalReceivables += (p['valor'] as num).toDouble();
    }

    Map<String, int> categories = {};
    for (var prod in (productsRes as List)) {
      String t = prod['tipo'];
      categories[t] = (categories[t] ?? 0) + 1;
    }

    setState(() {
      _monthlySales = totalSales;
      _receivables = totalReceivables;
      _topCategories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Venstoque',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadStats,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Visão Geral',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
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
                    title: 'Vendido (Mês)', // Mudei o título para deixar claro!
                    value: AppFormatters.formatCurrency(_monthlySales),
                    icon: Icons.attach_money,
                    color: AppColors.primary,
                  ),
                  SummaryCard(
                    title: 'A Receber',
                    value: AppFormatters.formatCurrency(_receivables),
                    icon: Icons.account_balance_wallet,
                    color: AppColors.warning,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Produtos por Categoria',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _topCategories.isEmpty
                    ? const Center(child: Text('Sem dados'))
                    : PieChart(
                        PieChartData(
                          sections: _topCategories.entries.map((e) {
                            return PieChartSectionData(
                              value: e.value.toDouble(),
                              title: '${e.key}\n${e.value}',
                              color: Colors.primaries[
                                  _topCategories.keys.toList().indexOf(e.key) %
                                      Colors.primaries.length],
                              radius: 50,
                              titleStyle: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            );
                          }).toList(),
                        ),
                      ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Cores por Categoria',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _topCategories.keys.map((category) {
                  final color = Colors.primaries[
                      _topCategories.keys.toList().indexOf(category) %
                          Colors.primaries.length];
                  return Chip(
                    label: Text(category,
                        style: const TextStyle(color: Colors.white)),
                    backgroundColor: color,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}