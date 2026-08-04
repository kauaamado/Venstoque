import 'package:flutter_test/flutter_test.dart';
import 'package:venstoque/models/produto_model.dart';

void main() {
  test('mapeia o produto legado para o schema atual', () {
    final produto = ProdutoModel.fromMap({
      'id': 'produto-1',
      'nome': 'Produto atual',
      'categoria': 'Categoria atual',
      'fornecedor': 'Fornecedor atual',
      'preco_custo': 10,
      'valor_venda': 15.5,
      'quantidade_estoque': 3,
    });

    expect(produto.modelo, 'Produto atual');
    expect(produto.tipo, 'Categoria atual');
    expect(produto.complemento, isEmpty);

    final map = produto.toMap();
    expect(map['nome'], 'Produto atual');
    expect(map['categoria'], 'Categoria atual');
    expect(map, isNot(contains('modelo')));
    expect(map, isNot(contains('tipo')));
    expect(map, isNot(contains('complemento')));
  });
}
