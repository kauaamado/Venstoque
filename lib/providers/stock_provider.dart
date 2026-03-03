import 'package:flutter/material.dart';
import '../models/produto_model.dart';
import '../models/estoque_model.dart';
import '../services/stock_service.dart';

class StockProvider with ChangeNotifier {
  final _service = StockService();
  List<ProdutoModel> _products = [];
  bool _isLoading = false;

  List<ProdutoModel> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _service.getProducts();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerEntry(EstoqueModel entry, double newPrice) async {
    await _service.registerProductEntry(entry, newPrice);
    await loadProducts();
  }

  Future<void> addProduct(ProdutoModel product) async {
    await _service.createProduct(product);
    await loadProducts();
  }
}
