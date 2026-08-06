import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:venstoque/models/local/cliente_model.dart';
import 'package:venstoque/models/local/parcela_model.dart';
import 'package:venstoque/models/local/produto_model.dart';
import 'package:venstoque/models/local/venda_model.dart';
import 'package:venstoque/services/local_database.dart';
import 'package:venstoque/services/sync_worker.dart';

void main() {
  test('worker preserva venda antiga com parcela pendente', () async {
    await Isar.initializeIsarCore(download: true);
    final directory =
        await Directory.systemTemp.createTemp('venstoque_worker_');
    final isar = await Isar.open(
      LocalDatabase.schemas,
      directory: directory.path,
      name: 'venstoque',
    );
    const tenantId = 'empresa-worker';
    final cutoff = DateTime(2026, 8, 5);
    final cliente = ClienteLocal()
      ..empresaId = tenantId
      ..supabaseId = 'cliente-remoto'
      ..nome = 'Cliente';
    final produto = ProdutoLocal()
      ..empresaId = tenantId
      ..supabaseId = 'produto-remoto'
      ..nome = 'Produto';
    final quitada = VendaLocal()
      ..empresaId = tenantId
      ..supabaseId = 'venda-quitada'
      ..dataVenda = DateTime(2024, 1, 1);
    final pendente = VendaLocal()
      ..empresaId = tenantId
      ..supabaseId = 'venda-pendente'
      ..dataVenda = DateTime(2024, 1, 1);
    final parcela = ParcelaLocal()
      ..empresaId = tenantId
      ..supabaseId = 'parcela-pendente'
      ..status = 'pendente'
      ..vendaLocalId = pendente.id;
    await isar.writeTxn(() async {
      await isar.clienteLocals.put(cliente);
      await isar.produtoLocals.put(produto);
      await isar.vendaLocals.putAll([quitada, pendente]);
      parcela.vendaLocalId = pendente.id;
      await isar.parcelaLocals.put(parcela);
    });

    try {
      final result = await SyncWorker.migrateAndPrune(
        isar: isar,
        tenantId: tenantId,
        cutoff: cutoff,
      );
      expect(result.prunedSales, 1);
      expect(await isar.vendaLocals.get(quitada.id), isNull);
      expect(await isar.vendaLocals.get(pendente.id), isNotNull);
      expect(await isar.parcelaLocals.get(parcela.id), isNotNull);
    } finally {
      await isar.close(deleteFromDisk: true);
      await directory.delete(recursive: true);
    }
  });
}
