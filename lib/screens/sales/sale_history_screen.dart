import 'package:flutter/material.dart';
import '../../services/sale_service.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import 'package:intl/intl.dart';

class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  final _service = SaleService();
  bool _loading = true;
  
  // Agora usamos DateTime como chave para conseguirmos ordenar do mais novo pro mais antigo
  Map<DateTime, List<Map<String, dynamic>>> _groupedData = {};
  Map<DateTime, Map<String, double>> _monthTotals = {};

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await _service.getSalesHistory();
    
    Map<DateTime, List<Map<String, dynamic>>> grouped = {};
    Map<DateTime, Map<String, double>> totals = {};

    for (var venda in data) {
      final tipo = venda['tipo_pagamento'];
      final cliente = venda['clientes']?['nome'] ?? 'Cliente não informado';
      
      // NOVO: Pega a data original em que a compra foi feita e formata
      final dataDaCompra = DateTime.parse(venda['data_venda']);
      final dataCompraFormatada = AppFormatters.formatDate(dataDaCompra);
      
      double custoTotalVenda = 0;
      List<String> produtosList = [];
      
      for (var item in venda['itens_venda']) {
        custoTotalVenda += (item['custo_unitario'] as num).toDouble() * (item['quantidade'] as num);
        
        final qtd = item['quantidade'];
        final modelo = item['produtos']?['nome'] ?? 'Produto excluído';
        
        // NOVO: Adiciona a data da compra entre parênteses ao lado do modelo
        produtosList.add('${qtd}x $modelo ($dataCompraFormatada)');
      }
      
      final descricaoProdutos = produtosList.join(', ');

      if (tipo == 'a_vista') {
        _processEvent(
          grouped, totals,
          date: dataDaCompra,
          value: (venda['valor_total'] as num).toDouble(),
          profit: (venda['valor_total'] as num).toDouble() - custoTotalVenda,
          displayData: {
            'comprador': cliente,
            'produtos': descricaoProdutos,
            'pagamento': 'À Vista',
            'valor': (venda['valor_total'] as num).toDouble(),
            'data': dataDaCompra,
          }
        );
      } else {
        final List parcelas = venda['parcelas'] ?? [];
        for (var p in parcelas) {
          double valorParcela = (p['valor'] as num).toDouble();
          double lucroParcela = valorParcela - (custoTotalVenda / parcelas.length);

          _processEvent(
            grouped, totals,
            date: DateTime.parse(p['data_vencimento']),
            value: valorParcela,
            profit: lucroParcela,
            displayData: {
              'comprador': cliente,
              'produtos': descricaoProdutos,
              'pagamento': 'Parcelado (P: ${p['numero_parcela']}/${parcelas.length})',
              'valor': valorParcela,
              'data': DateTime.parse(p['data_vencimento']),
            }
          );
        }
      }
    }

    setState(() {
      _groupedData = grouped;
      _monthTotals = totals;
      _loading = false;
    });
  }

  void _processEvent(
    Map<DateTime, List<Map<String, dynamic>>> grouped, 
    Map<DateTime, Map<String, double>> totals, 
    {required DateTime date, 
    required double value, 
    required double profit, 
    required Map<String, dynamic> displayData}
  ) {
    // Normaliza a data para o dia 1º daquele mês/ano, ignorando dias e horas
    DateTime monthKey = DateTime(date.year, date.month, 1);
    
    grouped.putIfAbsent(monthKey, () => <Map<String, dynamic>>[]);
    grouped[monthKey]!.add(displayData);

    totals.putIfAbsent(monthKey, () => <String, double>{'venda': 0.0, 'lucro': 0.0});
    totals[monthKey]!['venda'] = totals[monthKey]!['venda']! + value;
    totals[monthKey]!['lucro'] = totals[monthKey]!['lucro']! + profit;
  }

  @override
  Widget build(BuildContext context) {
    // 1. Extrai todas as "chaves de mês" (DateTimes) e ordena da mais nova pra mais velha
    List<DateTime> sortedMonths = _groupedData.keys.toList();
    sortedMonths.sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Vendas'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _loading 
        ? const Center(child: CircularProgressIndicator())
        : sortedMonths.isEmpty
            ? const Center(child: Text('Nenhuma venda registrada.', style: TextStyle(color: Colors.grey)))
            : ListView.builder(
                itemCount: sortedMonths.length,
                itemBuilder: (context, index) {
                  // 2. Pega o mês atual do loop e formata para texto bonito
                  DateTime monthKey = sortedMonths[index];
                  String monthName = DateFormat('MMMM / yyyy', 'pt_BR').format(monthKey);
                  
                  List events = _groupedData[monthKey]!;
                  events.sort((a, b) => b['data'].compareTo(a['data'])); // Ordem de data dos eventos

                  return ExpansionTile(
                    initiallyExpanded: index == 0,
                    title: Text(monthName.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    subtitle: Text(
                      'Total: ${AppFormatters.formatCurrency(_monthTotals[monthKey]!['venda']!)} | '
                      'Lucro: ${AppFormatters.formatCurrency(_monthTotals[monthKey]!['lucro']!)}',
                      style: const TextStyle(fontSize: 13, color: Colors.greenAccent, fontWeight: FontWeight.bold),
                    ),
                    children: events.map((e) => ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      title: Text(e['comprador'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          // EXIBE OS PRODUTOS AQUI:
                          Text(e['produtos'], style: TextStyle(color: Colors.grey.shade300, fontSize: 13)),
                          const SizedBox(height: 2),
                          Text('${e['pagamento']}  •  ${AppFormatters.formatDate(e['data'])}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                        ],
                      ),
                      trailing: Text(
                        AppFormatters.formatCurrency(e['valor']), 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.greenAccent)
                      ),
                    )).toList(),
                  );
                },
              ),
    );
  }
}
