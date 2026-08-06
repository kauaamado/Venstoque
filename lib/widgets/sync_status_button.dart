import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/sync_controller.dart';
import '../utils/constants.dart';

class SyncStatusButton extends StatelessWidget {
  const SyncStatusButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SyncController>();
    final (icon, color, tooltip) = switch (controller.status) {
      SyncStatus.idle => (
          Icons.cloud_sync_outlined,
          Colors.white,
          'Sincronizar'
        ),
      SyncStatus.syncing => (Icons.sync, Colors.white, 'Sincronizando'),
      SyncStatus.success => (
          Icons.cloud_done_outlined,
          Colors.white,
          'Sincronizado'
        ),
      SyncStatus.partialFailure => (
          Icons.cloud_off_outlined,
          Colors.amber,
          'Sincronização parcial',
        ),
      SyncStatus.offline => (
          Icons.cloud_off_outlined,
          Colors.orange,
          'Offline'
        ),
    };

    return IconButton(
      tooltip: tooltip,
      onPressed: () => _showDetails(context),
      icon: controller.isSyncing
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(icon, color: color),
    );
  }

  Future<void> _showDetails(BuildContext context) {
    final controller = context.read<SyncController>();
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => ChangeNotifierProvider.value(
        value: controller,
        child: const _SyncDetailsSheet(),
      ),
    );
  }
}

class _SyncDetailsSheet extends StatelessWidget {
  const _SyncDetailsSheet();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SyncController>();
    final report = controller.lastReport;
    final statusText = switch (controller.status) {
      SyncStatus.idle => 'Aguardando a primeira sincronização',
      SyncStatus.syncing => 'Sincronizando dados...',
      SyncStatus.success => 'Dados sincronizados',
      SyncStatus.partialFailure => 'Sincronização concluída com pendências',
      SyncStatus.offline => 'Sem conexão com o servidor',
    };

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sync, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    statusText,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            if (report != null) ...[
              const SizedBox(height: 16),
              Text(
                'Última tentativa: ${DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(report.completedAt.toLocal())}',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  Text('Enviados: ${report.pushed}'),
                  Text('Recebidos: ${report.received}'),
                  Text('Salvos: ${report.saved}'),
                  Text('Adiados: ${report.deferred}'),
                  Text('Falhas: ${report.failed}'),
                  Text('Pendentes: ${report.pendingAfter}'),
                  Text('Conflitos: ${report.conflicts}'),
                ],
              ),
              if (report.issues.isNotEmpty) ...[
                const SizedBox(height: 12),
                ...report.issues.take(3).map(
                      (issue) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '${issue.operation}: ${issue.message}',
                          style: const TextStyle(color: Colors.orangeAccent),
                        ),
                      ),
                    ),
              ],
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: controller.isSyncing
                    ? null
                    : () => context.read<SyncController>().syncNow(),
                icon: const Icon(Icons.sync),
                label: Text(
                  controller.isSyncing
                      ? 'Sincronizando...'
                      : 'Sincronizar agora',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
