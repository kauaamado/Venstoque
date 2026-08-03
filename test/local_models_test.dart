import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:venstoque/models/local/cliente_model.dart';
import 'package:venstoque/models/local/item_venda_model.dart';
import 'package:venstoque/models/local/parcela_model.dart';
import 'package:venstoque/models/local/produto_model.dart';
import 'package:venstoque/models/local/venda_model.dart';

void main() {
  test('persiste defaults, IDs remotos nulos e links locais', () async {
    await Isar.initializeIsarCore(download: true);
    final directory = await Directory.systemTemp.createTemp('venstoque_isar_');

    final isar = await Isar.open(
      [
        ClienteLocalSchema,
        ProdutoLocalSchema,
        VendaLocalSchema,
        ItemVendaLocalSchema,
        ParcelaLocalSchema,
      ],
      directory: directory.path,
    );

    try {
      final primeiroCliente = ClienteLocal()
        ..empresaId = 'empresa-1'
        ..nome = 'Cliente offline';
      final segundoCliente = ClienteLocal()
        ..empresaId = 'empresa-1'
        ..nome = 'Outro cliente offline';
      final produto = ProdutoLocal()
        ..empresaId = 'empresa-1'
        ..nome = 'Produto offline';
      final venda = VendaLocal()
        ..empresaId = 'empresa-1'
        ..valorTotal = 100;
      final item = ItemVendaLocal()
        ..quantidade = 2
        ..precoUnitario = 50;
      final parcela = ParcelaLocal()
        ..empresaId = 'empresa-1'
        ..numeroParcela = 1
        ..valor = 100;

      venda.cliente.value = primeiroCliente;
      item.venda.value = venda;
      item.produto.value = produto;
      parcela.venda.value = venda;

      await isar.writeTxn(() async {
        await isar.clienteLocals.putAll([
          primeiroCliente,
          segundoCliente,
        ]);
        await isar.produtoLocals.put(produto);
        await isar.vendaLocals.put(venda);
        await venda.cliente.save();
        await isar.itemVendaLocals.put(item);
        await item.venda.save();
        await item.produto.save();
        await isar.parcelaLocals.put(parcela);
        await parcela.venda.save();
      });

      final clientes = await isar.clienteLocals.where().findAll();
      expect(clientes, hasLength(2));
      expect(clientes.every((cliente) => cliente.supabaseId == null), isTrue);
      expect(clientes.every((cliente) => cliente.ativo), isTrue);

      final itemPersistido = await isar.itemVendaLocals.get(item.id);
      expect(itemPersistido, isNotNull);
      await itemPersistido!.venda.load();
      await itemPersistido.produto.load();
      expect(itemPersistido.venda.value?.id, venda.id);
      expect(itemPersistido.produto.value?.id, produto.id);

      final parcelaPersistida = await isar.parcelaLocals.get(parcela.id);
      expect(parcelaPersistida, isNotNull);
      await parcelaPersistida!.venda.load();
      expect(parcelaPersistida.venda.value?.id, venda.id);
      expect(parcelaPersistida.status, 'pendente');
    } finally {
      await isar.close(deleteFromDisk: true);
      await directory.delete(recursive: true);
    }
  });
}
