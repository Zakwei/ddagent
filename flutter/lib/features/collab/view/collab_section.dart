import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/auth/state/auth_controller.dart';
import 'package:ddagent_app/features/collab/data/collab_repository.dart';
import 'package:ddagent_app/features/collab/role.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final collabUsersProvider = FutureProvider<List<CollabUser>>(
  (ref) => ref.watch(collabRepositoryProvider).users(),
);

final collabActivityProvider = FutureProvider.family<List<Map<String, dynamic>>, String>(
  (ref, projectId) => ref.watch(collabRepositoryProvider).activity(projectId),
);

/// Users + activity feed + owner invite minting — the shared-surface section
/// for project screens (T12.2–12.3).
class CollabSection extends ConsumerWidget {
  const CollabSection({required this.projectId, super.key});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(collabUsersProvider);
    final activity = ref.watch(collabActivityProvider(projectId));
    final isOwner = roleAtLeast(
      ref.watch(authControllerProvider.select((s) => s.user?.role)),
      'owner',
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Team', style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            if (isOwner)
              TextButton.icon(
                icon: const Icon(Icons.person_add_alt_1, size: 16),
                label: const Text('Invite'),
                onPressed: () => showInviteDialog(context, ref),
              ),
          ],
        ),
        users.when(
          data: (list) => Wrap(
            spacing: 8,
            children: [
              for (final u in list)
                Chip(
                  avatar: Icon(
                    u.role == 'owner'
                        ? Icons.shield_outlined
                        : u.role == 'viewer'
                        ? Icons.visibility_outlined
                        : Icons.person_outline,
                    size: 14,
                  ),
                  label: Text(u.displayName ?? u.username),
                ),
            ],
          ),
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('$e'),
        ),
        const SizedBox(height: 8),
        Text('Activity', style: Theme.of(context).textTheme.titleMedium),
        activity.when(
          data: (events) => events.isEmpty
              ? const Text('No activity yet')
              : Column(
                  children: [
                    for (final e in events.take(20))
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text('${e['summary'] ?? e['kind'] ?? ''}'),
                        subtitle: Text('${e['createdAt'] ?? ''}'),
                      ),
                  ],
                ),
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('$e'),
        ),
      ],
    );
  }
}

/// Mints a single-use invite (owner only) and shows the shareable token.
Future<void> showInviteDialog(BuildContext context, WidgetRef ref) async {
  String role = 'member';
  Map<String, dynamic>? invite;
  AppError? error;
  await showDialog<void>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Invite teammate'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (invite == null) ...[
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'member', label: Text('Member')),
                  ButtonSegment(value: 'viewer', label: Text('Viewer')),
                ],
                selected: {role},
                onSelectionChanged: (s) => setState(() => role = s.first),
              ),
              if (error != null) Text('$error', style: const TextStyle(color: Colors.red)),
            ] else ...[
              const Text('Share this invite token — it is shown once and expires in 72h:'),
              const SizedBox(height: 8),
              SelectableText('${invite!['token']}'),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          if (invite == null)
            FilledButton(
              onPressed: () async {
                try {
                  final created = await ref.read(collabRepositoryProvider).createInvite(role: role);
                  setState(() => invite = created);
                } on AppError catch (e) {
                  setState(() => error = e);
                }
              },
              child: const Text('Create invite'),
            )
          else
            FilledButton.icon(
              icon: const Icon(Icons.copy, size: 16),
              label: const Text('Copy token'),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: '${invite!['token']}'));
                if (context.mounted) Navigator.pop(context);
              },
            ),
        ],
      ),
    ),
  );
}
