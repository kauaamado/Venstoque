class ParcelaModel {
  ParcelaModel({
    this.localId,
    this.id,
    this.vendaId = '',
    required this.numeroParcela,
    required this.valor,
    required this.dataVencimento,
    this.dataPagamento,
    this.status = 'pendente',
  });

  final String? localId;
  final String? id;
  final String vendaId;
  final int numeroParcela;
  final double valor;
  final DateTime dataVencimento;
  DateTime? dataPagamento;
  String status;

  factory ParcelaModel.fromMap(Map<String, dynamic> map) {
    return ParcelaModel(
      localId: map['local_id']?.toString(),
      id: map['id']?.toString(),
      vendaId: map['venda_local_id']?.toString() ??
          map['venda_id']?.toString() ??
          '',
      numeroParcela: (map['numero_parcela'] as num?)?.toInt() ?? 0,
      valor: (map['valor'] as num?)?.toDouble() ?? 0,
      dataVencimento: DateTime.parse(map['data_vencimento'].toString()),
      dataPagamento: map['data_pagamento'] == null
          ? null
          : DateTime.parse(map['data_pagamento'].toString()),
      status: map['status']?.toString() ?? 'pendente',
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
