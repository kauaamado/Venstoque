import 'package:flutter/material.dart';

import '../../models/sync_report.dart';
import '../../utils/constants.dart';

class InitialSyncScreen extends StatelessWidget {
  const InitialSyncScreen({
    super.key,
    required this.isSyncing,
    required this.statusMessage,
    required this.lastReport,
    required this.onRetry,
  });

  final bool isSyncing;
  final String statusMessage;
  final SyncReport? lastReport;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final hasFailure = lastReport?.issues.isNotEmpty == true;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_sync,
                    size: 64, color: AppColors.primary),
                const SizedBox(height: 24),
                const Text(
                  'Preparando seus dados',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  statusMessage,
                  style: const TextStyle(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (isSyncing)
                  const CircularProgressIndicator()
                else if (hasFailure)
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                const SizedBox(height: 20),
                const Text(
                  'Você poderá vender assim que clientes e produtos essenciais estiverem disponíveis.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
