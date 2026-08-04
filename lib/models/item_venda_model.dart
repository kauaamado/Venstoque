class ItemVendaModel {
  ItemVendaModel({
    this.localId,
    this.id,
    this.vendaId,
    required this.produtoId,
    this.produtoNome,
    required this.quantidade,
    required this.precoUnitario,
    required this.custoUnitario,
  });

  final String? localId;
  final String? id;
  final String? vendaId;
  final String produtoId;
  final String? produtoNome;
  int quantidade;
  final double precoUnitario;
  final double custoUnitario;

  double get subtotal => quantidade * precoUnitario;

  factory ItemVendaModel.fromMap(Map<String, dynamic> map) {
    return ItemVendaModel(
      localId: map['local_id']?.toString(),
      id: map['id']?.toString(),
      vendaId: map['venda_local_id']?.toString() ?? map['venda_id']?.toString(),
      produtoId: map['produto_local_id']?.toString() ??
          map['produto_id']?.toString() ??
          '',
      produtoNome: map['produto_nome']?.toString(),
      quantidade: (map['quantidade'] as num?)?.toInt() ?? 0,
      precoUnitario: (map['preco_unitario'] as num?)?.toDouble() ?? 0,
      custoUnitario: (map['custo_unitario'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap(String vendaId) {
    return {
      'venda_id': vendaId,
      'produto_id': produtoId,
      'quantidade': quantidade,
      'preco_unitario': precoUnitario,
      'custo_unitario': custoUnitario,
    };
  }
}
