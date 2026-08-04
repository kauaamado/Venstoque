class SearchHelper {
  const SearchHelper._();

  static List<T> filterList<T>({
    required List<T> items,
    String? query,
    required String? Function(T item) searchBy,
  }) {
    final normalizedQuery = query?.trim().toLowerCase();
    if (normalizedQuery == null || normalizedQuery.isEmpty) {
      return List<T>.of(items);
    }

    return items.where((item) {
      final value = searchBy(item);
      return value?.toLowerCase().contains(normalizedQuery) ?? false;
    }).toList();
  }
}
