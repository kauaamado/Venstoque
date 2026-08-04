import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:venstoque/models/cliente_model.dart';
import 'package:venstoque/models/local/cliente_model.dart';
import 'package:venstoque/models/local/item_venda_model.dart';
import 'package:venstoque/models/local/parcela_model.dart';
import 'package:venstoque/models/local/produto_model.dart';
import 'package:venstoque/models/local/venda_model.dart';
import 'package:venstoque/models/parcela_model.dart';
import 'package:venstoque/models/produto_model.dart';
import 'package:venstoque/providers/sale_provider.dart';

void main() {
  const empresaId = 'empresa-teste';

  late Directory directory;
  late Isar isar;
  late SaleProvider provider;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    directory = await Directory.systemTemp.createTemp(
      'venstoque_sale_provider_',
    );
    isar = await Isar.open(
      [
        ClienteLocalSchema,
        ProdutoLocalSchema,
        VendaLocalSchema,
        ItemVendaLocalSchema,
        ParcelaLocalSchema,
      ],
      directory: directory.path,
      name: 'sale_provider_${DateTime.now().microsecondsSinceEpoch}',
    );
    provider = SaleProvider(isar, empresaId: empresaId);
    await provider.loadSales();
  });

  tearDown(() async {
    provider.dispose();
    await isar.close(deleteFromDisk: true);
    await directory.delete(recursive: true);
  });

  test('registra venda, itens e parcelas atomicamente com links', () async {
    final customer = ClienteLocal()
      ..empresaId = empresaId
      ..nome = 'Cliente offline';
    final product = ProdutoLocal()
      ..empresaId = empresaId
      ..nome = 'Produto offline'
      ..categoria = 'Perfumes'
      ..quantidadeEstoque = 10
      ..precoCusto = 20
      ..valorVenda = 50;
    await isar.writeTxn(() async {
      await isar.clienteLocals.put(customer);
      await isar.produtoLocals.put(product);
    });

    provider.setCustomer(_customerDto(customer));
    provider.addToCart(_productDto(product), 2);
    provider.setPaymentType('parcelado');
    await provider.finalizeSale([
      ParcelaModel(
        numeroParcela: 1,
        valor: 50,
        dataVencimento: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ParcelaModel(
        numeroParcela: 2,
        valor: 50,
        dataVencimento: DateTime.now().add(const Duration(days: 30)),
      ),
    ]);

    expect(await isar.vendaLocals.count(), 1);
    expect(await isar.itemVendaLocals.count(), 1);
    expect(await isar.parcelaLocals.count(), 2);

    final sale = await isar.vendaLocals.where().findFirst();
    expect(sale, isNotNull);
    expect(sale!.supabaseId, isNull);
    expect(sale.empresaId, empresaId);
    await sale.cliente.load();
    expect(sale.cliente.value?.id, customer.id);

    final item = await isar.itemVendaLocals.where().findFirst();
    expect(item, isNotNull);
    await item!.venda.load();
    await item.produto.load();
    expect(item.venda.value?.id, sale.id);
    expect(item.produto.value?.id, product.id);

    final installments = await isar.parcelaLocals.where().findAll();
    for (final installment in installments) {
      expect(installment.empresaId, empresaId);
      expect(installment.supabaseId, isNull);
      await installment.venda.load();
      expect(installment.venda.value?.id, sale.id);
    }

    final storedProduct = await isar.produtoLocals.get(product.id);
    expect(storedProduct!.quantidadeEstoque, 8);
    expect(provider.cart, isEmpty);
    expect(provider.selectedCustomer, isNull);
    expect(provider.sales, hasLength(1));
    expect(provider.receivables, hasLength(2));
  });

  test('reverte toda a transação quando o estoque é insuficiente', () async {
    final customer = ClienteLocal()
      ..empresaId = empresaId
      ..nome = 'Cliente';
    final product = ProdutoLocal()
      ..empresaId = empresaId
      ..nome = 'Produto sem estoque'
      ..quantidadeEstoque = 1
      ..valorVenda = 50;
    await isar.writeTxn(() async {
      await isar.clienteLocals.put(customer);
      await isar.produtoLocals.put(product);
    });

    provider.setCustomer(_customerDto(customer));
    provider.addToCart(_productDto(product), 2);

    await expectLater(
      provider.finalizeSale(null),
      throwsA(isA<StateError>()),
    );

    expect(await isar.vendaLocals.count(), 0);
    expect(await isar.itemVendaLocals.count(), 0);
    expect(await isar.parcelaLocals.count(), 0);
    expect(
      (await isar.produtoLocals.get(product.id))!.quantidadeEstoque,
      1,
    );
  });

  test('calcula insights, histórico e pagamentos usando dados locais',
      () async {
    final customer = ClienteLocal()
      ..empresaId = empresaId
      ..nome = 'Cliente';
    final product = ProdutoLocal()
      ..empresaId = empresaId
      ..nome = 'Perfume'
      ..categoria = 'Perfumes'
      ..quantidadeEstoque = 5
      ..precoCusto = 10
      ..valorVenda = 40;
    await isar.writeTxn(() async {
      await isar.clienteLocals.put(customer);
      await isar.produtoLocals.put(product);
    });

    provider.setCustomer(_customerDto(customer));
    provider.addToCart(_productDto(product), 2);
    provider.setPaymentType('fiado');
    await provider.finalizeSale([
      ParcelaModel(
        numeroParcela: 1,
        valor: 80,
        dataVencimento: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ]);

    final insights = await provider.getCustomerInsights(
      customer.id.toString(),
    );
    expect(insights['totalComprado'], 80);
    expect(insights['tipoMaisComprado'], 'Perfumes');
    expect(insights['tipoPagamentoMaisUsado'], 'fiado');
    expect(insights['totalPendente'], 80);
    expect(insights['totalAtrasos'], 1);

    await provider.loadCustomerHistory(customer.id.toString(), 30);
    expect(provider.customerHistory, hasLength(1));
    expect(provider.customerHistory.single['produto'], 'Perfume');

    final installmentId = provider.receivables.single['local_id'].toString();
    await provider.payPartialParcel(installmentId, 30);
    expect(provider.receivables.single['valor'], 30);
    await provider.markParcelAsPaid(installmentId);
    expect(provider.receivables, isEmpty);
  });

  test('watchers atualizam vendas externas e filtram outro tenant', () async {
    final customer = ClienteLocal()
      ..empresaId = empresaId
      ..nome = 'Cliente';
    await isar.writeTxn(() => isar.clienteLocals.put(customer));

    final currentSale = VendaLocal()
      ..empresaId = empresaId
      ..valorTotal = 25;
    currentSale.cliente.value = customer;
    final otherSale = VendaLocal()
      ..empresaId = 'outra-empresa'
      ..valorTotal = 100;
    await isar.writeTxn(() async {
      await isar.vendaLocals.put(currentSale);
      await currentSale.cliente.save();
      await isar.vendaLocals.put(otherSale);
    });

    await _waitUntil(() => provider.sales.length == 1);
    expect(provider.sales.single.valorTotal, 25);
  });
}

ClienteModel _customerDto(ClienteLocal customer) {
  return ClienteModel(
    localId: customer.id.toString(),
    nome: customer.nome,
    celular: '',
    referencia: '',
    observacoes: '',
  );
}

ProdutoModel _productDto(ProdutoLocal product) {
  return ProdutoModel(
    localId: product.id.toString(),
    nome: product.nome,
    categoria: product.categoria,
    fornecedor: product.fornecedor,
    precoCusto: product.precoCusto,
    valorVenda: product.valorVenda,
    quantidadeEstoque: product.quantidadeEstoque,
  );
}

Future<void> _waitUntil(bool Function() condition) async {
  for (var attempt = 0; attempt < 100; attempt++) {
    if (condition()) return;
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  fail('A condição esperada não foi atendida a tempo.');
}
