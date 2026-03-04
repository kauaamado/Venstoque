import '../models/venda_model.dart';
import '../models/item_venda_model.dart';
import '../models/parcela_model.dart';
import '../utils/constants.dart';
import 'supabase_service.dart';

class SaleService {
  final _client = SupabaseService().client;

  Future<void> processSale({
    required VendaModel venda,
    required List<ItemVendaModel> itens,
    List<ParcelaModel>? parcelas,
  }) async {
    // 1. Criar a venda
    final vendaRes = await _client
        .from(AppTables.vendas)
        .insert(venda.toMap())
        .select()
        .single();
    
    final String vendaId = vendaRes['id'];

    // 2. Criar itens e atualizar estoque
    for (var item in itens) {
      await _client.from(AppTables.itensVenda).insert(item.toMap(vendaId));
      
      // Decrementar estoque
      final prodRes = await _client.from(AppTables.produtos).select('quantidade_estoque').eq('id', item.produtoId).single();
      int currentStock = prodRes['quantidade_estoque'];
      await _client.from(AppTables.produtos).update({
        'quantidade_estoque': currentStock - item.quantidade
      }).eq('id', item.produtoId);
    }

    // 3. Criar parcelas se houver
    if (parcelas != null && parcelas.isNotEmpty) {
      for (var p in parcelas) {
        final pMap = p.toMap();
        pMap['venda_id'] = vendaId;
        await _client.from(AppTables.parcelas).insert(pMap);
      }
    }
  }

  Future<List<Map<String, dynamic>>> getReceivables() async {
    // Query estendida para buscar as ligações até o modelo do produto
    final res = await _client
        .from(AppTables.parcelas)
        .select('*, vendas(cliente_id, clientes(nome), itens_venda(produtos(modelo)))')
        .eq('status', 'pendente')
        .order('data_vencimento', ascending: true);
    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> markParcelAsPaid(String id) async {
    await _client.from(AppTables.parcelas).update({
      'status': 'pago',
      'data_pagamento': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  Future<void> markAllParcelsAsPaid(String vendaId) async {
    await _client.from(AppTables.parcelas).update({
      'status': 'pago',
      'data_pagamento': DateTime.now().toIso8601String(),
    }).eq('venda_id', vendaId).eq('status', 'pendente');
  }

  // NOVO: Método para abater o valor de um pagamento parcial
  Future<void> payPartialParcel(String id, double remainingValue) async {
    await _client.from(AppTables.parcelas).update({
      'valor': remainingValue, 
    }).eq('id', id);
  }
}