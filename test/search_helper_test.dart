import 'package:flutter_test/flutter_test.dart';
import 'package:venstoque/utils/search_helper.dart';

void main() {
  group('SearchHelper.filterList', () {
    test('retorna uma cópia modificável quando a busca está vazia', () {
      final source = List<int>.unmodifiable([3, 1, 2]);

      final result = SearchHelper.filterList(
        items: source,
        query: '   ',
        searchBy: (item) => item.toString(),
      );

      expect(identical(result, source), isFalse);
      expect(() => result.sort(), returnsNormally);
      expect(result, [1, 2, 3]);
      expect(source, [3, 1, 2]);
    });

    test('normaliza espaços, ignora maiúsculas e aceita campos nulos', () {
      final result = SearchHelper.filterList<String?>(
        items: [null, 'Cliente Alpha', 'Cliente Beta'],
        query: '  ALPHA  ',
        searchBy: (item) => item,
      );

      expect(result, ['Cliente Alpha']);
    });
  });
}
