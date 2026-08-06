import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_controller.dart';
import '../services/session_coordinator.dart';
import '../utils/constants.dart';

class AccountMenuButton extends StatelessWidget {
  const AccountMenuButton({super.key});

  Future<void> _open(BuildContext context) async {
    final auth = context.read<AuthController>();
    final session = context.read<SessionCoordinator>();
    final shouldSignOut = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Conta',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                auth.user?.email ?? 'Usuário autenticado',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(sheetContext, true),
                icon: const Icon(Icons.logout),
                label: const Text('Sair da conta'),
              ),
            ],
          ),
        ),
      ),
    );

    if (shouldSignOut != true || !context.mounted) return;
    var result = await session.signOut();
    if (result == LogoutResult.needsConfirmation && context.mounted) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Há alterações pendentes'),
          content: const Text(
            'Não foi possível enviar tudo para a nuvem. '
            'Sair agora apagará os dados locais desta empresa. Deseja continuar?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Continuar no app'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Sair e apagar dados'),
            ),
          ],
        ),
      );
      if (confirm == true) result = await session.signOut(force: true);
    }
    if (result == LogoutResult.failed && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Não foi possível sair da conta.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Conta',
      onPressed: () => _open(context),
      icon: const Icon(Icons.account_circle_outlined),
    );
  }
}
