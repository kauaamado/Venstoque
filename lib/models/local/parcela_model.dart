import 'package:isar_community/isar.dart';

import 'venda_model.dart';

part 'parcela_model.g.dart';

@collection
class ParcelaLocal {
  Id id = Isar.autoIncrement;

  @Index()
  String? supabaseId;

  @Index()
  String? empresaId;

  @Index()
  int? vendaLocalId;

  int rowVersion = 0;
  int bootstrapGeneration = 0;

  final venda = IsarLink<VendaLocal>();
  int numeroParcela = 0;
  double valor = 0;
  DateTime dataVencimento = DateTime.now();
  DateTime? dataPagamento;
  String status = 'pendente';
  bool syncPending = false;
  int syncRevision = 0;
}
