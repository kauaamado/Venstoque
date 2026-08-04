class VendaModel {
  const VendaModel({
    this.localId,
    this.id,
    required this.clienteId,
    this.clienteNome,
    required this.dataVenda,
    required this.valorTotal,
    this.valorEntrada = 0,
    this.desconto = 0,
    required this.tipoPagamento,
    this.observacoes = '',
    this.status = 'pendente',
    this.legacyId,
  });

  final String? localId;
  final String? id;
  final String clienteId;
  final String? clienteNome;
  final DateTime dataVenda;
  final double valorTotal;
  final double valorEntrada;
  final double desconto;
  final String tipoPagamento;
  final String observacoes;
  final String status;
  final int? legacyId;

  factory VendaModel.fromMap(Map<String, dynamic> map) {
    return VendaModel(
      localId: map['local_id']?.toString(),
      id: map['id']?.toString(),
      clienteId: map['cliente_local_id']?.toString() ??
          map['cliente_id']?.toString() ??
          '',
      clienteNome: map['cliente_nome']?.toString(),
      dataVenda: DateTime.parse(map['data_venda'].toString()),
      valorTotal: (map['valor_total'] as num?)?.toDouble() ?? 0,
      valorEntrada: (map['valor_entrada'] as num?)?.toDouble() ?? 0,
      desconto: (map['desconto'] as num?)?.toDouble() ?? 0,
      tipoPagamento: map['tipo_pagamento']?.toString() ?? '',
      observacoes: map['observacoes']?.toString() ?? '',
      status: map['status']?.toString() ?? 'pendente',
      legacyId: (map['legacy_id'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'cliente_id': clienteId,
      'data_venda': dataVenda.toIso8601String(),
      'valor_total': valorTotal,
      'valor_entrada': valorEntrada,
      'desconto': desconto,
      'tipo_pagamento': tipoPagamento,
      'observacoes': observacoes,
      'legacy_id': legacyId,
    };
  }
}
