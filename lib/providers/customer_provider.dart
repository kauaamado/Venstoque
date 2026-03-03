import 'package:flutter/material.dart';
import '../models/cliente_model.dart';
import '../services/supabase_service.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class CustomerProvider with ChangeNotifier {
  List<ClienteModel> _customers = [];
  bool _isLoading = false;

  List<ClienteModel> get customers => _customers;
  bool get isLoading => _isLoading;

  final _client = SupabaseService().client;

  // Cache de insights por cliente (total comprado, pendente, etc.)
  Map<String, Map<String, dynamic>>? _customerInsightsCache;

  Map<String, Map<String, dynamic>> _ensureInsightsCache() {
    // Garante que o cache sempre exista, mesmo após hot reload
    var cache = _customerInsightsCache;
    if (cache == null) {
      cache = <String, Map<String, dynamic>>{};
      _customerInsightsCache = cache;
    }
    return cache;
  }

  Map<String, Map<String, dynamic>> get customerInsightsCache =>
      _ensureInsightsCache();

  Map<String, dynamic>? getCachedInsights(String customerId) {
    final cache = _ensureInsightsCache();
    return cache[customerId];
  }

  Future<void> loadCustomers() async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _client.from(AppTables.clientes).select().order('nome');
      _customers = (res as List).map((c) => ClienteModel.fromMap(c)).toList();

      // Pré-carrega insights básicos de todos os clientes (importante para telas críticas)
      for (final c in _customers) {
        if (c.id != null) {
          await getCustomerInsights(c.id!);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCustomer(ClienteModel cliente) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _client.from(AppTables.clientes).insert(cliente.toMap());
      await loadCustomers(); // Recarrega a lista
    } catch (e) {
      debugPrint('Erro ao salvar cliente: $e');
      // Aqui no futuro você pode colocar um aviso de "Sem internet"
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> _customerHistory = [];
  bool _isLoadingHistory = false;

  List<Map<String, dynamic>> get customerHistory => _customerHistory;
  bool get isLoadingHistory => _isLoadingHistory;

  Future<Map<String, dynamic>> getCustomerInsights(String customerId) async {
    final cache = _ensureInsightsCache();
    try {
      final vendas = await _client
          .from(AppTables.vendas)
          .select(
              'id, tipo_pagamento, valor_total, data_venda, itens_venda(produto_id, quantidade), parcelas(data_vencimento, status, valor)')
          .eq('cliente_id', customerId);

      double totalComprado = 0;
      double totalPendente = 0;
      int totalAtrasos = 0;
      Map<String, int> tipoMaisComprado = {};
      Map<String, int> tipoPagamentoMaisUsado = {};

      double _toDouble(dynamic v) =>
          (v is num) ? v.toDouble() : (double.tryParse(v?.toString() ?? '') ?? 0.0);
      int _toInt(dynamic v) =>
          (v is int) ? v : (v is num) ? v.toInt() : (int.tryParse(v?.toString() ?? '') ?? 0);

      for (var venda in vendas) {
        totalComprado += _toDouble(venda['valor_total']);

        final parcelas = venda['parcelas'] is List ? venda['parcelas'] as List : <dynamic>[];
        for (var parcela in parcelas) {
          final rawVenc = parcela['data_vencimento'];
          DateTime? dataVencimento;
          if (rawVenc != null && rawVenc.toString().isNotEmpty) {
            try {
              dataVencimento = DateTime.parse(rawVenc.toString());
            } catch (_) {}
          }
          final status = parcela['status']?.toString() ?? '';

          if (status != 'pago') {
            totalPendente += _toDouble(parcela['valor']);
          }
          if (dataVencimento != null &&
              status != 'pago' &&
              dataVencimento.isBefore(DateTime.now())) {
            totalAtrasos++;
          }
        }

        final itensVenda = venda['itens_venda'] is List ? venda['itens_venda'] as List : <dynamic>[];
        for (var item in itensVenda) {
          final produtoId = item['produto_id'];
          if (produtoId == null) continue;
          final quantidade = _toInt(item['quantidade']);

          try {
            final produto = await _client
                .from(AppTables.produtos)
                .select('tipo')
                .eq('id', produtoId)
                .single();
            final tipo = produto['tipo']?.toString() ?? '-';
            tipoMaisComprado[tipo] = (tipoMaisComprado[tipo] ?? 0) + quantidade;
          } catch (_) {}
        }

        final tipoPagamento = venda['tipo_pagamento']?.toString() ?? '';
        final tipoPagamentoFormatado = _formatarTipoPagamento(tipoPagamento);
        tipoPagamentoMaisUsado[tipoPagamentoFormatado] =
            (tipoPagamentoMaisUsado[tipoPagamentoFormatado] ?? 0) + 1;
      }

      final tipoMaisCompradoFinal = tipoMaisComprado.isNotEmpty
          ? tipoMaisComprado.entries
              .reduce((a, b) => a.value > b.value ? a : b)
              .key
          : '-';

      final tipoPagamentoMaisUsadoFinal = tipoPagamentoMaisUsado.isNotEmpty
          ? tipoPagamentoMaisUsado.entries
              .reduce((a, b) => a.value > b.value ? a : b)
              .key
          : '-';
      final result = {
        'totalComprado': totalComprado,
        'tipoMaisComprado': tipoMaisCompradoFinal,
        'tipoPagamentoMaisUsado': tipoPagamentoMaisUsadoFinal,
        'totalPendente': totalPendente,
        'totalAtrasos': totalAtrasos,
      };
      cache[customerId] = result;
      return result;
    } catch (e) {
      debugPrint('Erro ao carregar insights do cliente: $e');
      return {
        'totalComprado': 0.0,
        'tipoMaisComprado': '-',
        'tipoPagamentoMaisUsado': '-',
        'totalPendente': 0.0,
        'totalAtrasos': 0,
      };
    }
  }

  String _formatarTipoPagamento(String tipoPagamento) {
    switch (tipoPagamento) {
      case 'a_vista':
        return 'À vista';
      case 'fiado':
        return 'Fiado';
      case 'parcelado':
        return 'Parcelado';
      default:
        return tipoPagamento;
    }
  }

  String formatarPreco(num preco) {
    return AppFormatters.formatCurrency(preco.toDouble());
  }

  Future<void> loadCustomerHistory(String customerId, int days) async {
    _isLoadingHistory = true;
    notifyListeners();
    try {
      final vendas = await _client
          .from(AppTables.vendas)
          .select(
              'id, data_venda, valor_total, itens_venda(produto_id, quantidade)')
          .eq('cliente_id', customerId)
          .gte('data_venda',
              DateTime.now().subtract(Duration(days: days)).toIso8601String())
          .order('data_venda', ascending: false);

      final List<Map<String, dynamic>> history = [];

      for (var venda in vendas) {
        for (var item in venda['itens_venda']) {
          final produtoId = item['produto_id'];
          final produto = await _client
              .from(AppTables.produtos)
              .select('modelo')
              .eq('id', produtoId)
              .single();

          history.add({
            'produto': produto['modelo'],
            'data': venda['data_venda'],
            // Armazena o valor como número bruto; formatação fica para a UI
            'valor': (venda['valor_total'] as num).toDouble(),
          });
        }
      }

      _customerHistory = history;
    } catch (e) {
      debugPrint('Erro ao carregar histórico do cliente: $e');
      _customerHistory = [];
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
    }
  }
}
