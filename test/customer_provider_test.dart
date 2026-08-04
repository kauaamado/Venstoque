import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:venstoque/models/cliente_model.dart';
import 'package:venstoque/models/local/cliente_model.dart';
import 'package:venstoque/models/local/venda_model.dart';
import 'package:venstoque/providers/customer_provider.dart';

void main() {
  const empresaId = 'empresa-teste';

  late Directory directory;
  late Isar isar;
  late CustomerProvider provider;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    directory = await Directory.systemTemp.createTemp(
      'venstoque_customer_provider_',
    );
    isar = await Isar.open(
      [ClienteLocalSchema, VendaLocalSchema],
      directory: directory.path,
      name: 'customer_provider_${DateTime.now().microsecondsSinceEpoch}',
    );
    provider = CustomerProvider(isar, empresaId: empresaId);
    await provider.loadCustomers();
  });

  tearDown(() async {
    provider.dispose();
    await isar.close(deleteFromDisk: true);
    await directory.delete(recursive: true);
  });

  test('cria e atualiza clientes somente no Isar', () async {
    await provider.addCustomer(
      const ClienteModel(
        nome: '  Cliente local  ',
        celular: ' 999999999 ',
        referencia: ' Próximo à praça ',
        observacoes: ' Teste offline ',
      ),
    );

    final stored = await isar.clienteLocals.where().findFirst();
    expect(stored, isNotNull);
    expect(stored!.supabaseId, isNull);
    expect(stored.empresaId, empresaId);
    expect(stored.nome, 'Cliente local');
    expect(provider.customers.single.localId, stored.id.toString());

    await provider.updateCustomer(
      ClienteModel(
        localId: stored.id.toString(),
        nome: 'Cliente atualizado',
        celular: '888888888',
        referencia: 'Nova referência',
        observacoes: 'Atualizado no aparelho',
      ),
    );

    final updated = await isar.clienteLocals.get(stored.id);
    expect(updated, isNotNull);
    expect(updated!.nome, 'Cliente atualizado');
    expect(updated.supabaseId, isNull);
    expect(updated.empresaId, empresaId);
    expect(provider.customers.single.nome, 'Cliente atualizado');
  });

  test('preserva UUID remoto e isola clientes por tenant', () async {
    final currentTenant = ClienteLocal()
      ..empresaId = empresaId
      ..supabaseId = 'uuid-remoto'
      ..nome = 'Cliente sincronizado';
    final otherTenant = ClienteLocal()
      ..empresaId = 'outra-empresa'
      ..nome = 'Cliente de outro tenant';

    await isar.writeTxn(() async {
      await isar.clienteLocals.putAll([currentTenant, otherTenant]);
    });
    await provider.loadCustomers();

    expect(provider.customers, hasLength(1));
    expect(provider.customers.single.nome, 'Cliente sincronizado');

    await provider.updateCustomer(
      ClienteModel(
        localId: currentTenant.id.toString(),
        id: 'uuid-alterado-pela-ui',
        nome: 'Nome alterado',
        celular: '',
        referencia: '',
        observacoes: '',
      ),
    );

    final updated = await isar.clienteLocals.get(currentTenant.id);
    expect(updated!.supabaseId, 'uuid-remoto');
    expect(updated.empresaId, empresaId);
  });

  test('remove cliente sem vendas e desativa cliente vinculado', () async {
    final unlinked = ClienteLocal()
      ..empresaId = empresaId
      ..nome = 'Sem vendas';
    final linked = ClienteLocal()
      ..empresaId = empresaId
      ..nome = 'Com vendas';
    final sale = VendaLocal()
      ..empresaId = empresaId
      ..valorTotal = 100;
    sale.cliente.value = linked;

    await isar.writeTxn(() async {
      await isar.clienteLocals.putAll([unlinked, linked]);
      await isar.vendaLocals.put(sale);
      await sale.cliente.save();
    });

    final removed = await provider.deleteCustomer(unlinked.id.toString());
    final deactivated = await provider.deleteCustomer(linked.id.toString());

    expect(removed, CustomerDeleteResult.deleted);
    expect(deactivated, CustomerDeleteResult.deactivated);
    expect(await isar.clienteLocals.get(unlinked.id), isNull);

    final linkedStored = await isar.clienteLocals.get(linked.id);
    expect(linkedStored, isNotNull);
    expect(linkedStored!.ativo, isFalse);
    await sale.cliente.load();
    expect(sale.cliente.value?.id, linked.id);
    expect(provider.customers, isEmpty);
  });

  test('watchLazy atualiza a lista após escrita externa', () async {
    final customer = ClienteLocal()
      ..empresaId = empresaId
      ..nome = 'Inserido fora do provider';

    await isar.writeTxn(() => isar.clienteLocals.put(customer));
    await _waitUntil(
      () => provider.customers.any(
        (item) => item.localId == customer.id.toString(),
      ),
    );

    expect(provider.customers.single.nome, 'Inserido fora do provider');
  });
}

Future<void> _waitUntil(bool Function() condition) async {
  for (var attempt = 0; attempt < 100; attempt++) {
    if (condition()) return;
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  fail('A condição esperada não foi atendida a tempo.');
}
