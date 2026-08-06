import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/local/cliente_model.dart';
import '../models/local/item_venda_model.dart';
import '../models/local/parcela_model.dart';
import '../models/local/produto_model.dart';
import '../models/local/venda_model.dart';
import '../models/local/sync_state_model.dart';

class LocalDatabase {
  static const String _instanceName = 'venstoque';

  static const List<CollectionSchema<dynamic>> schemas = [
    ClienteLocalSchema,
    ProdutoLocalSchema,
    VendaLocalSchema,
    ItemVendaLocalSchema,
    ParcelaLocalSchema,
    SyncStateLocalSchema,
    SyncMutationLocalSchema,
    SyncConflictLocalSchema,
  ];

  static Future<Isar> init({String? directory}) async {
    final openInstance = Isar.getInstance(_instanceName);
    if (openInstance != null) return openInstance;

    final databaseDirectory =
        directory ?? (await getApplicationSupportDirectory()).path;

    return Isar.open(
      schemas,
      directory: databaseDirectory,
      name: _instanceName,
    );
  }
}
