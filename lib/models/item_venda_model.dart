class ItemVendaModel {
  final String? id;
  final String? vendaId;
  final String produtoId;
  final String? produtoNome; // Auxiliar para UI
  int quantidade;
  final double precoUnitario;
  final double custoUnitario;

  ItemVendaModel({
    this.id,
    this.vendaId,
    required this.produtoId,
    this.produtoNome,
    required this.quantidade,
    required this.precoUnitario,
    required this.custoUnitario,
  });

  double get subtotal => quantidade * precoUnitario;

  factory ItemVendaModel.fromMap(Map<String, dynamic> map) {
    return ItemVendaModel(
      id: map['id'],
      vendaId: map['venda_id'],
      produtoId: map['produto_id'],
      quantidade: map['quantidade'],
      precoUnitario: (map['preco_unitario'] as num).toDouble(),
      custoUnitario: (map['custo_unitario'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap(String vId) {
    return {
      'venda_id': vId,
      'produto_id': produtoId,
      'quantidade': quantidade,
      'preco_unitario': precoUnitario,
      'custo_unitario': custoUnitario,
    };
  }
}
