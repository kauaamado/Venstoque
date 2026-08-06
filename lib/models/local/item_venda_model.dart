import 'package:isar_community/isar.dart';

import 'produto_model.dart';
import 'venda_model.dart';

part 'item_venda_model.g.dart';

@collection
class ItemVendaLocal {
  Id id = Isar.autoIncrement;

  @Index()
  String? supabaseId;

  @Index()
  String? empresaId;

  @Index()
  int? vendaLocalId;

  @Index()
  int? produtoLocalId;

  int rowVersion = 0;
  int bootstrapGeneration = 0;

  final venda = IsarLink<VendaLocal>();
  final produto = IsarLink<ProdutoLocal>();
  int quantidade = 0;
  double precoUnitario = 0;
  double custoUnitario = 0;
}
