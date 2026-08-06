import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/sync_service.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../widgets/sync_status_button.dart';

class RemoteHistoryScreen extends StatefulWidget {
  const RemoteHistoryScreen({super.key});

  @override
  State<RemoteHistoryScreen> createState() => _RemoteHistoryScreenState();
}

class _RemoteHistoryScreenState extends State<RemoteHistoryScreen> {
  DateTimeRange? _range;
  final _records = <RemoteHistoryRecord>[];
  DateTime? _nextBefore;
  String? _nextBeforeId;
  bool _isLoading = false;
  bool _hasMore = false;
  String? _errorMessage;

  DateTime get _cutoff {
    final now = DateTime.now();
    return DateTime(now.year - 1, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    final cutoff = _cutoff;
    _range = DateTimeRange(
      start: cutoff.subtract(const Duration(days: 30)),
      end: cutoff.subtract(const Duration(days: 1)),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPage(reset: true));
  }

  Future<void> _chooseRange() async {
    final cutoff = _cutoff;
    final selected = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2010),
      lastDate: cutoff.subtract(const Duration(days: 1)),
      initialDateRange: _range,
      helpText: 'Escolha até 90 dias do histórico remoto',
      cancelText: 'Cancelar',
      confirmText: 'Aplicar',
    );
    if (selected == null || !mounted) return;
    if (selected.duration.inDays > 90) {
      _showMessage('O intervalo máximo é de 90 dias.');
      return;
    }
    setState(() => _range = selected);
    await _loadPage(reset: true);
  }

  Future<void> _loadPage({required bool reset}) async {
    final range = _range;
    if (range == null || _isLoading) return;
    if (reset) {
      _nextBefore = null;
      _nextBeforeId = null;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final page = await context.read<SyncService>().fetchRemoteHistoryPage(
            from: range.start,
            to: range.end,
            before: reset ? null : _nextBefore,
            beforeId: reset ? null : _nextBeforeId,
          );
      if (!mounted) return;
      setState(() {
        if (reset) _records.clear();
        _records.addAll(page.records);
        _nextBefore = page.nextBefore;
        _nextBeforeId = page.nextBeforeId;
        _hasMore = page.hasMore;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage =
          'Não foi possível consultar o histórico remoto. Verifique a conexão.');
      debugPrint('Falha no histórico remoto: $error');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico remoto'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: const [SyncStatusButton()],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _chooseRange,
                    icon: const Icon(Icons.date_range),
                    label: Text(
                      '${AppFormatters.formatDate(_range!.start)} - '
                      '${AppFormatters.formatDate(_range!.end)}',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isLoading ? null : () => _loadPage(reset: true),
                  tooltip: 'Atualizar histórico',
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.orangeAccent),
              ),
            ),
          Expanded(
            child: _isLoading && _records.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _records.isEmpty
                    ? const Center(
                        child: Text('Nenhuma venda encontrada neste período.'),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _records.length + (_hasMore ? 1 : 0),
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          if (index == _records.length) {
                            return OutlinedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => _loadPage(reset: false),
                              child: Text(_isLoading
                                  ? 'Carregando...'
                                  : 'Carregar mais'),
                            );
                          }
                          return _saleCard(_records[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _saleCard(RemoteHistoryRecord record) {
    final sale = record.snapshot['venda'] as Map<String, dynamic>? ?? {};
    final client = record.snapshot['cliente'] as Map<String, dynamic>? ?? {};
    final items = record.snapshot['itens'] as List? ?? const [];
    final total = (sale['valor_total'] as num?)?.toDouble() ?? 0;
    final itemText = items.map((raw) {
      final item = raw as Map<String, dynamic>;
      final product = item['produto'] as Map<String, dynamic>?;
      return '${item['quantidade'] ?? 0}x ${product?['nome'] ?? 'Produto'}';
    }).join(', ');
    return Card(
      child: ListTile(
        title: Text(client['nome']?.toString() ?? 'Cliente não informado'),
        subtitle: Text(
          '${AppFormatters.formatDate(record.date)}\n'
          '${itemText.isEmpty ? 'Itens não informados' : itemText}',
        ),
        isThreeLine: true,
        trailing: Text(
          AppFormatters.formatCurrency(total),
          style: const TextStyle(
            color: Colors.greenAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
