import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:venstoque/models/local/cliente_model.dart';
import 'package:venstoque/models/local/item_venda_model.dart';
import 'package:venstoque/models/local/parcela_model.dart';
import 'package:venstoque/models/local/produto_model.dart';
import 'package:venstoque/models/local/venda_model.dart';
import 'package:venstoque/services/local_database.dart';

void main() {
  test('abre os schemas locais e reutiliza a instância', () async {
    await Isar.initializeIsarCore(download: true);
    final directory = await Directory.systemTemp.createTemp(
      'venstoque_local_database_',
    );
    final isar = await LocalDatabase.init(directory: directory.path);

    try {
      expect(await isar.clienteLocals.count(), 0);
      expect(await isar.produtoLocals.count(), 0);
      expect(await isar.vendaLocals.count(), 0);
      expect(await isar.itemVendaLocals.count(), 0);
      expect(await isar.parcelaLocals.count(), 0);

      final reused = await LocalDatabase.init(directory: directory.path);
      expect(identical(reused, isar), isTrue);
    } finally {
      await isar.close(deleteFromDisk: true);
      await directory.delete(recursive: true);
    }
  });
}
