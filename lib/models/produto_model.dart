class ProdutoModel {
  const ProdutoModel({
    this.localId,
    this.id,
    required this.nome,
    required this.categoria,
    required this.fornecedor,
    required this.precoCusto,
    required this.valorVenda,
    required this.quantidadeEstoque,
    this.ativo = true,
  });

  final String? localId;
  final String? id;
  final String nome;
  final String categoria;
  final String fornecedor;
  final double precoCusto;
  final double valorVenda;
  final int quantidadeEstoque;
  final bool ativo;

  bool get isLowStock => quantidadeEstoque <= 3;

  factory ProdutoModel.fromMap(Map<String, dynamic> map) {
    return ProdutoModel(
      localId: map['local_id']?.toString(),
      id: map['id']?.toString(),
      nome: map['nome']?.toString() ?? '',
      categoria: map['categoria']?.toString() ?? '',
      fornecedor: map['fornecedor']?.toString() ?? '',
      precoCusto: (map['preco_custo'] as num?)?.toDouble() ?? 0,
      valorVenda: (map['valor_venda'] as num?)?.toDouble() ?? 0,
      quantidadeEstoque: (map['quantidade_estoque'] as num?)?.toInt() ?? 0,
      ativo: map['ativo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'categoria': categoria,
      'fornecedor': fornecedor,
      'preco_custo': precoCusto,
      'valor_venda': valorVenda,
      'quantidade_estoque': quantidadeEstoque,
      'ativo': ativo,
    };
  }
}
