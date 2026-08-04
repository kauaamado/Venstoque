import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:venstoque/models/estoque_model.dart';
import 'package:venstoque/models/local/cliente_model.dart';
import 'package:venstoque/models/local/item_venda_model.dart';
import 'package:venstoque/models/local/produto_model.dart';
import 'package:venstoque/models/local/venda_model.dart';
import 'package:venstoque/models/produto_model.dart';
import 'package:venstoque/providers/stock_provider.dart';

void main() {
  const empresaId = 'empresa-teste';

  late Directory directory;
  late Isar isar;
  late StockProvider provider;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    directory = await Directory.systemTemp.createTemp(
      'venstoque_product_provider_',
    );
    isar = await Isar.open(
      [
        ClienteLocalSchema,
        ProdutoLocalSchema,
        VendaLocalSchema,
        ItemVendaLocalSchema,
      ],
      directory: directory.path,
      name: 'product_provider_${DateTime.now().microsecondsSinceEpoch}',
    );
    provider = StockProvider(isar, empresaId: empresaId);
    await provider.loadProducts();
  });

  tearDown(() async {
    provider.dispose();
    await isar.close(deleteFromDisk: true);
    await directory.delete(recursive: true);
  });

  test('cria e atualiza produtos somente no Isar', () async {
    await provider.addProduct(
      const ProdutoModel(
        nome: '  Produto local  ',
        categoria: ' Categoria ',
        fornecedor: ' Fornecedor ',
        precoCusto: 10,
        valorVenda: 20,
        quantidadeEstoque: 2,
      ),
    );

    final stored = await isar.produtoLocals.where().findFirst();
    expect(stored, isNotNull);
    expect(stored!.supabaseId, isNull);
    expect(stored.empresaId, empresaId);
    expect(stored.nome, 'Produto local');
    expect(provider.products.single.localId, stored.id.toString());

    await isar.writeTxn(() async {
      stored.supabaseId = 'uuid-remoto';
      await isar.produtoLocals.put(stored);
    });

    await provider.updateProduct(
      ProdutoModel(
        localId: stored.id.toString(),
        id: 'uuid-alterado-pela-ui',
        nome: 'Produto atualizado',
        categoria: 'Nova categoria',
        fornecedor: 'Novo fornecedor',
        precoCusto: 12,
        valorVenda: 25,
        quantidadeEstoque: 4,
      ),
    );

    final updated = await isar.produtoLocals.get(stored.id);
    expect(updated, isNotNull);
    expect(updated!.nome, 'Produto atualizado');
    expect(updated.supabaseId, 'uuid-remoto');
    expect(updated.empresaId, empresaId);
    expect(provider.products.single.nome, 'Produto atualizado');
  });

  test('registra entrada atualizando estoque e preços localmente', () async {
    final product = ProdutoLocal()
      ..empresaId = empresaId
      ..nome = 'Produto com estoque'
      ..quantidadeEstoque = 3
      ..precoCusto = 10
      ..valorVenda = 20;
    await isar.writeTxn(() => isar.produtoLocals.put(product));

    await provider.registerEntry(
      EstoqueModel(
        produtoId: product.id.toString(),
        quantidade: 5,
        custoUnitario: 12,
        fornecedor: 'Fornecedor atualizado',
        complemento: '',
        novoValorVenda: 24,
      ),
      24,
    );

    final updated = await isar.produtoLocals.get(product.id);
    expect(updated!.quantidadeEstoque, 8);
    expect(updated.precoCusto, 12);
    expect(updated.valorVenda, 24);
    expect(updated.fornecedor, 'Fornecedor atualizado');
  });

  test('filtra tenant e produtos inativos e ordena pelo nome', () async {
    final second = ProdutoLocal()
      ..empresaId = empresaId
      ..nome = 'Zeta';
    final first = ProdutoLocal()
      ..empresaId = empresaId
      ..nome = 'Alfa';
    final inactive = ProdutoLocal()
      ..empresaId = empresaId
      ..nome = 'Inativo'
      ..ativo = false;
    final otherTenant = ProdutoLocal()
      ..empresaId = 'outra-empresa'
      ..nome = 'Outro tenant';
    final tenantless = ProdutoLocal()..nome = 'Sem tenant';

    await isar.writeTxn(() async {
      await isar.produtoLocals.putAll([
        second,
        first,
        inactive,
        otherTenant,
        tenantless,
      ]);
    });
    await provider.loadProducts();

    expect(provider.products.map((product) => product.nome), ['Alfa', 'Zeta']);
  });

  test('remove produto sem itens e desativa produto vinculado', () async {
    final unlinked = ProdutoLocal()
      ..empresaId = empresaId
      ..nome = 'Sem itens';
    final linked = ProdutoLocal()
      ..empresaId = empresaId
      ..nome = 'Com itens';
    final item = ItemVendaLocal()..quantidade = 1;
    item.produto.value = linked;

    await isar.writeTxn(() async {
      await isar.produtoLocals.putAll([unlinked, linked]);
      await isar.itemVendaLocals.put(item);
      await item.produto.save();
    });

    final removed = await provider.deleteProduct(unlinked.id.toString());
    final deactivated = await provider.deleteProduct(linked.id.toString());

    expect(removed, ProductDeleteResult.deleted);
    expect(deactivated, ProductDeleteResult.deactivated);
    expect(await isar.produtoLocals.get(unlinked.id), isNull);

    final linkedStored = await isar.produtoLocals.get(linked.id);
    expect(linkedStored, isNotNull);
    expect(linkedStored!.ativo, isFalse);
    await item.produto.load();
    expect(item.produto.value?.id, linked.id);
    expect(provider.products, isEmpty);
  });

  test('watchLazy atualiza a lista após escrita externa', () async {
    final product = ProdutoLocal()
      ..empresaId = empresaId
      ..nome = 'Inserido fora do provider';

    await isar.writeTxn(() => isar.produtoLocals.put(product));
    await _waitUntil(
      () => provider.products.any(
        (item) => item.localId == product.id.toString(),
      ),
    );

    expect(provider.products.single.nome, 'Inserido fora do provider');
  });
}

Future<void> _waitUntil(bool Function() condition) async {
  for (var attempt = 0; attempt < 100; attempt++) {
    if (condition()) return;
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  fail('A condição esperada não foi atendida a tempo.');
}
