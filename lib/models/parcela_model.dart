class ParcelaModel {
  final String? id;
  final String vendaId;
  final int numeroParcela;
  final double valor;
  final DateTime dataVencimento;
  DateTime? dataPagamento;
  String status; // pendente, pago

  ParcelaModel({
    this.id,
    required this.vendaId,
    required this.numeroParcela,
    required this.valor,
    required this.dataVencimento,
    this.dataPagamento,
    required this.status,
  });

  factory ParcelaModel.fromMap(Map<String, dynamic> map) {
    return ParcelaModel(
      id: map['id'],
      vendaId: map['venda_id'],
      numeroParcela: map['numero_parcela'],
      valor: (map['valor'] as num).toDouble(),
      dataVencimento: DateTime.parse(map['data_vencimento']),
      dataPagamento: map['data_pagamento'] != null ? DateTime.parse(map['data_pagamento']) : null,
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'venda_id': vendaId,
      'numero_parcela': numeroParcela,
      'valor': valor,
      'data_vencimento': dataVencimento.toIso8601String(),
      'data_pagamento': dataPagamento?.toIso8601String(),
      'status': status,
    };
  }
}
