import 'package:isar_community/isar.dart';

part 'cliente_model.g.dart';

@collection
class ClienteLocal {
  Id id = Isar.autoIncrement;

  @Index()
  String? supabaseId;

  @Index()
  String? empresaId;

  String nome = '';
  String celular = '';
  String referencia = '';
  String observacoes = '';
  bool ativo = true;
  bool syncPending = false;
  bool pendingDelete = false;
  int syncRevision = 0;
  int? legacyId;
}
