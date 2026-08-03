import 'package:isar_community/isar.dart';

import 'cliente_model.dart';

part 'venda_model.g.dart';

@collection
class VendaLocal {
  Id id = Isar.autoIncrement;

  @Index()
  String? supabaseId;

  @Index()
  String? empresaId;

  final cliente = IsarLink<ClienteLocal>();
  DateTime dataVenda = DateTime.now();
  double valorTotal = 0;
  double valorEntrada = 0;
  double desconto = 0;
  String tipoPagamento = '';
  String observacoes = '';
  int? legacyId;
}
