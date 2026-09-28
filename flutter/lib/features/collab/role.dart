import 'package:ddagent_app/features/auth/state/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Port of server `roleAtLeast` — viewer < member < owner.
int roleRank(String? role) => switch (role) {
  'viewer' => 1,
  'member' => 2,
  'owner' => 3,
  _ => 0,
};

bool roleAtLeast(String? role, String minimum) => roleRank(role) >= roleRank(minimum);

/// Renders [child] only when the current user's role meets [minimum]
/// (approvals, permission-response, kanban writes, invite management).
class RequireRole extends ConsumerWidget {
  const RequireRole({required this.minimum, required this.child, this.fallback, super.key});

  final String minimum;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(authControllerProvider.select((s) => s.user?.role));
    return roleAtLeast(role, minimum) ? child : fallback ?? const SizedBox.shrink();
  }
}
