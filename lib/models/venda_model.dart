class VendaModel {
  final String? id;
  final String clienteId;
  final DateTime dataVenda;
  final double valorTotal;
  final String tipoPagamento; // a_vista, parcelado, fiado
  final String status;

  VendaModel({
    this.id,
    required this.clienteId,
    required this.dataVenda,
    required this.valorTotal,
    required this.tipoPagamento,
    required this.status,
  });

  factory VendaModel.fromMap(Map<String, dynamic> map) {
    return VendaModel(
      id: map['id'],
      clienteId: map['cliente_id'],
      dataVenda: DateTime.parse(map['data_venda']),
      valorTotal: (map['valor_total'] as num).toDouble(),
      tipoPagamento: map['tipo_pagamento'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'cliente_id': clienteId,
      'data_venda': dataVenda.toIso8601String(),
      'valor_total': valorTotal,
      'tipo_pagamento': tipoPagamento,
      'status': status,
    };
  }
}
