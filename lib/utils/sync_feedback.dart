import 'package:flutter/material.dart';

import '../models/sync_report.dart';

void showSyncFeedback(BuildContext context, SyncReport report) {
  final (message, color) = switch (report.outcome) {
    SyncOutcome.success => ('Dados atualizados.', Colors.green),
    SyncOutcome.offline => (
        'Sem conexão. Os dados locais foram mantidos.',
        Colors.orange,
      ),
    SyncOutcome.partialFailure => (
        'Alguns dados não puderam ser sincronizados.',
        Colors.redAccent,
      ),
  };

  if (report.outcome == SyncOutcome.success) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
}
