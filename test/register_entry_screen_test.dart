import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:venstoque/models/produto_model.dart';
import 'package:venstoque/providers/stock_provider.dart';
import 'package:venstoque/screens/stock/register_entry_screen.dart';

void main() {
  testWidgets('abre o formulário sem chaves duplicadas', (tester) async {
    final provider = _FakeStockProvider();
    addTearDown(provider.dispose);

    await tester.pumpWidget(
      ChangeNotifierProvider<StockProvider>.value(
        value: provider,
        child: const MaterialApp(home: RegisterEntryScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Registrar Entrada'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FakeStockProvider extends ChangeNotifier implements StockProvider {
  @override
  List<ProdutoModel> get products => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
