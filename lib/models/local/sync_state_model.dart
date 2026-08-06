import 'package:isar_community/isar.dart';

part 'sync_state_model.g.dart';

@collection
class SyncStateLocal {
  Id id = Isar.autoIncrement;

  @Index()
  String tenantId = '';

  String bootstrapPhase = 'idle';
  String? bootstrapAfterId;
  int initialChangeCursor = 0;
  int changeCursor = 0;
  DateTime? cutoff;
  int generation = 0;
  DateTime? lastAttemptAt;
  DateTime? lastSuccessAt;
  String? lastError;
  bool v1Migrated = false;
}

@collection
class SyncMutationLocal {
  Id id = Isar.autoIncrement;

  @Index()
  String tenantId = '';

  @Index()
  String operationId = '';

  @Index()
  String entity = '';

  String operation = '';
  int? localId;
  String? remoteId;
  int? baseRowVersion;
  String payloadJson = '{}';
  DateTime createdAt = DateTime.now();
  DateTime? attemptedAt;
  int attemptCount = 0;
  @Index()
  String state = 'queued';
  String? lastErrorCode;
  String? lastErrorMessage;
}

@collection
class SyncConflictLocal {
  Id id = Isar.autoIncrement;

  @Index()
  String tenantId = '';

  @Index()
  String? mutationId;

  String entity = '';
  int? localId;
  String? remoteId;
  String localPayloadJson = '{}';
  String remoteSnapshotJson = '{}';
  int? baseRowVersion;
  int? currentRowVersion;
  DateTime createdAt = DateTime.now();
  DateTime? resolvedAt;
  String? resolution;
}
