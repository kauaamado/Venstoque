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
      id: map['id']?.toString(),
      tipo: map['categoria']?.toString() ?? '',
      modelo: map['nome']?.toString() ?? '',
      complemento: '',
      fornecedor: map['fornecedor']?.toString() ?? '',
      precoCusto: (map['preco_custo'] as num?)?.toDouble() ?? 0,
      valorVenda: (map['valor_venda'] as num?)?.toDouble() ?? 0,
      quantidadeEstoque: (map['quantidade_estoque'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'categoria': tipo,
      'nome': modelo,
      'fornecedor': fornecedor,
      'preco_custo': precoCusto,
      'valor_venda': valorVenda,
      'quantidade_estoque': quantidadeEstoque,
    };
  }
}
