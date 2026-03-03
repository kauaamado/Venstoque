class EstoqueModel {
  final String? id;
  final String produtoId;
  final int quantidade;
  final double custoUnitario;
  final String fornecedor;
  final DateTime dataEntrada;
  final String complemento;
  final double novoValorVenda;

  EstoqueModel({
    this.id,
    required this.produtoId,
    required this.quantidade,
    required this.custoUnitario,
    required this.fornecedor,
    required this.dataEntrada,
    required this.complemento,
    required this.novoValorVenda,
  });

  factory EstoqueModel.fromMap(Map<String, dynamic> map) {
    return EstoqueModel(
      id: map['id'],
      produtoId: map['produto_id'],
      quantidade: map['quantidade'] is int
          ? map['quantidade'] as int
          : int.tryParse(map['quantidade']?.toString() ?? '') ?? 0,
      custoUnitario: (map['custo_unitario'] as num?)?.toDouble() ?? 0.0,
      fornecedor: map['fornecedor']?.toString() ?? '',
      dataEntrada: map['data_entrada'] != null
          ? DateTime.parse(map['data_entrada'].toString())
          : DateTime.now(),
      complemento: map['complemento']?.toString() ?? '',
      novoValorVenda: (map['novo_valor_venda'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Map para insert/update no Supabase (apenas colunas que existem em estoque).
  /// A tabela não possui complemento nem novo_valor_venda; o novo preço é aplicado no produto no service.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'produto_id': produtoId,
      'quantidade': quantidade,
      'custo_unitario': custoUnitario,
      'fornecedor': fornecedor,
      'data_entrada': dataEntrada.toIso8601String(),
    };
  }
}
