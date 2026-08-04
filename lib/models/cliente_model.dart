class ClienteModel {
  const ClienteModel({
    this.localId,
    this.id,
    required this.nome,
    required this.celular,
    required this.referencia,
    required this.observacoes,
    this.ativo = true,
    this.legacyId,
  });

  final String? localId;
  final String? id;
  final String nome;
  final String celular;
  final String referencia;
  final String observacoes;
  final bool ativo;
  final int? legacyId;

  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      localId: map['local_id']?.toString(),
      id: map['id']?.toString(),
      nome: map['nome']?.toString() ?? '',
      celular: map['celular']?.toString() ?? '',
      referencia: map['referencia']?.toString() ?? '',
      observacoes: map['observacoes']?.toString() ?? '',
      ativo: map['ativo'] as bool? ?? true,
      legacyId: (map['legacy_id'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'celular': celular,
      'referencia': referencia,
      'observacoes': observacoes,
      'ativo': ativo,
      'legacy_id': legacyId,
    };
  }
}
