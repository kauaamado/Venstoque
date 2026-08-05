import 'package:isar_community/isar.dart';

part 'produto_model.g.dart';

@collection
class ProdutoLocal {
  Id id = Isar.autoIncrement;

  @Index()
  String? supabaseId;

  @Index()
  String? empresaId;

  String nome = '';
  String categoria = '';
  String fornecedor = '';
  double precoCusto = 0;
  double valorVenda = 0;
  int quantidadeEstoque = 0;
  bool ativo = true;
  bool syncPending = false;
  bool pendingDelete = false;
  int syncRevision = 0;
}
