class SearchHelper {
  /// Filtra qualquer tipo de lista [T] baseado em um termo de busca.
  static List<T> filterList<T>({
    required List<T> items,
    String? query, // Mudamos para String? para aceitar nulos em segurança
    required String? Function(T item) searchBy, // Aceita que o nome venha nulo do banco
  }) {
    // Se a query for nula ou vazia, não precisa filtrar nada
    if (query == null || query.trim().isEmpty) return items; 
    
    final lowerQuery = query.toLowerCase();
    
    return items.where((item) {
      final value = searchBy(item);
      if (value == null) return false; // Se o produto/cliente estiver sem nome no banco, ignora
      
      final textToSearch = value.toLowerCase();
      return textToSearch.contains(lowerQuery);
    }).toList();
  }
}