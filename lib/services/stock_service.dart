import '../models/produto_model.dart';
import '../models/estoque_model.dart';
import '../utils/constants.dart';
import 'supabase_service.dart';

class StockService {
  final _client = SupabaseService().client;

  Future<List<ProdutoModel>> getProducts() async {
    final response = await _client
        .from(AppTables.produtos)
        .select()
        .order('nome', ascending: true);
    return (response as List).map((p) => ProdutoModel.fromMap(p)).toList();
  }

  Future<void> registerProductEntry(
      EstoqueModel entry, double newSalePrice) async {
    // 1. Registrar Entrada
    await _client.from(AppTables.estoque).insert(entry.toMap());

    // 2. Atualizar Produto (Soma estoque e atualiza custo/venda)
    final productRes = await _client
        .from(AppTables.produtos)
        .select('quantidade_estoque')
        .eq('id', entry.produtoId)
        .single();

    int currentStock = productRes['quantidade_estoque'] ?? 0;
    int updatedStock = currentStock + entry.quantidade;

    await _client.from(AppTables.produtos).update({
      'quantidade_estoque': updatedStock,
      'preco_custo': entry.custoUnitario,
      'valor_venda': newSalePrice,
      'fornecedor': entry.fornecedor,
    }).eq('id', entry.produtoId);
  }

  Future<void> createProduct(ProdutoModel product) async {
    await _client.from(AppTables.produtos).insert(product.toMap());
  }
}
