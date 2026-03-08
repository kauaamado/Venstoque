class SearchHelper {
  /// Filtra qualquer tipo de lista [T] baseado em um termo de busca.
  /// 
  /// [items]: A lista original que você quer filtrar.
  /// [query]: O texto que o usuário digitou.
  /// [searchBy]: Uma função que diz em qual campo o filtro deve olhar.
  static List<T> filterList<T>({
    required List<T> items,
    required String query,
    required String Function(T item) searchBy,
  }) {
    if (query.trim().isEmpty) return items; // Se não tem busca, devolve tudo
    
    final lowerQuery = query.toLowerCase();
    
    return items.where((item) {
      final textToSearch = searchBy(item).toLowerCase();
      return textToSearch.contains(lowerQuery);
    }).toList();
  }
}