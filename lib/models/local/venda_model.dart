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

  @Index()
  DateTime dataVenda = DateTime.now();

  @Index()
  String? clienteLocalId;

  String? syncOperationId;
  bool syncPending = false;
  int syncRevision = 0;
  int rowVersion = 0;
  int bootstrapGeneration = 0;

  final cliente = IsarLink<ClienteLocal>();
  double valorTotal = 0;
  double valorEntrada = 0;
  double desconto = 0;
  String tipoPagamento = '';
  String observacoes = '';
  int? legacyId;
}
