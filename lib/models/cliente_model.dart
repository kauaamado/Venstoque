class ClienteModel {
  final String? id;
  final String nome;
  final String celular;
  final String referencia;
  final String bairro;
  final String? nomeReferencia;
  final String? telefoneReferencia;

  ClienteModel({
    this.id,
    required this.nome,
    required this.celular,
    required this.referencia,
    required this.bairro,
    this.nomeReferencia,
    this.telefoneReferencia,
  });

  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      id: map['id'],
      nome: map['nome'],
      celular: map['celular'],
      referencia: map['referencia'] ?? '',
      bairro: map['bairro'] ?? '',
      nomeReferencia: map['nome_referencia'],
      telefoneReferencia: map['telefone_referencia'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'celular': celular,
      'referencia': referencia,
      'bairro': bairro,
      'nome_referencia': nomeReferencia,
      'telefone_referencia': telefoneReferencia,
    };
  }
}
