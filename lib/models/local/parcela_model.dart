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

  final venda = IsarLink<VendaLocal>();
  int numeroParcela = 0;
  double valor = 0;
  DateTime dataVencimento = DateTime.now();
  DateTime? dataPagamento;
  String status = 'pendente';
}
