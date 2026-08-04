import 'package:flutter/material.dart';
import '../models/cliente_model.dart';
import '../models/item_venda_model.dart';
import '../models/produto_model.dart';
import '../models/venda_model.dart';
import '../models/parcela_model.dart';
import '../services/sale_service.dart';

class SaleProvider with ChangeNotifier {
  final SaleService _saleService = SaleService();

  ClienteModel? _selectedCustomer;
  final List<ItemVendaModel> _cart = [];
  String _paymentType = 'a_vista';
  bool _isLoading = false;

  // Getters
  ClienteModel? get selectedCustomer => _selectedCustomer;
  List<ItemVendaModel> get cart => _cart;
  String get paymentType => _paymentType;
  bool get isLoading => _isLoading;

  // Calcula o total do carrinho em tempo real
  double get total {
    return _cart.fold(0, (sum, item) => sum + (item.quantidade * item.precoUnitario));
  }

  // Ações da Tela
  void setCustomer(ClienteModel customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  void setPaymentType(String type) {
    _paymentType = type;
    notifyListeners();
  }

  void addToCart(ProdutoModel produto, int quantidade) {
    // Verifica se o produto já está no carrinho para apenas somar a quantidade
    final existingIndex = _cart.indexWhere((item) => item.produtoId == produto.id);
    
    if (existingIndex >= 0) {
      _cart[existingIndex].quantidade += quantidade;
    } else {
      _cart.add(ItemVendaModel(
        produtoId: produto.id!,
        produtoNome: produto.nome,
        quantidade: quantidade,
        precoUnitario: produto.valorVenda,
        custoUnitario: produto.precoCusto,
      ));
    }
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cart.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _selectedCustomer = null;
    _cart.clear();
    _paymentType = 'a_vista';
    notifyListeners();
  }

  // O Chefão: Finaliza a Venda
  Future<void> finalizeSale(List<ParcelaModel>? parcelas) async {
    if (_selectedCustomer == null || _cart.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      // 1. Monta o objeto da Venda
      final venda = VendaModel(
        clienteId: _selectedCustomer!.id!,
        dataVenda: DateTime.now(),
        valorTotal: total,
        tipoPagamento: _paymentType,
        status: _paymentType == 'a_vista' ? 'pago' : 'pendente',
      );

      // 2. Manda pro Service (que vai jogar pro Supabase)
      if (parcelas != null && parcelas.isNotEmpty) {
        await _saleService.processSale(
          venda: venda, 
          itens: _cart,
          parcelas: parcelas,
        );
      }
      else {
        await _saleService.processSale(
          venda: venda, 
          itens: _cart,
        );
      }

      // Limpa tudo após o sucesso
      clear();
    } catch (e) {
      debugPrint('Erro ao finalizar venda: $e');
      rethrow; // Repassa o erro para a tela poder mostrar um SnackBar vermelho se quiser
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
