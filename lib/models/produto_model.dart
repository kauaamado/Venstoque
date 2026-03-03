class ProdutoModel {
  final String? id;
  final String tipo;
  final String modelo;
  final String complemento;
  final String fornecedor;
  final double precoCusto;
  final double valorVenda;
  final int quantidadeEstoque;

  ProdutoModel({
    this.id,
    required this.tipo,
    required this.modelo,
    required this.complemento,
    required this.fornecedor,
    required this.precoCusto,
    required this.valorVenda,
    required this.quantidadeEstoque,
  });

  bool get isLowStock => quantidadeEstoque <= 3;

  factory ProdutoModel.fromMap(Map<String, dynamic> map) {
    return ProdutoModel(
      id: map['id'],
      tipo: map['tipo'],
      modelo: map['modelo'],
      complemento: map['complemento'] ?? '',
      fornecedor: map['fornecedor'] ?? '',
      precoCusto: (map['preco_custo'] as num).toDouble(),
      valorVenda: (map['valor_venda'] as num).toDouble(),
      quantidadeEstoque: map['quantidade_estoque'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'tipo': tipo,
      'modelo': modelo,
      'complemento': complemento,
      'fornecedor': fornecedor,
      'preco_custo': precoCusto,
      'valor_venda': valorVenda,
      'quantidade_estoque': quantidadeEstoque,
    };
  }
}
