import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/sessions_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Ctrl/Cmd+K quick switcher — port of the web session-picker Panel shortcut:
/// searchable session list, Enter/click jumps to `/chat/:id`.
Future<void> showSessionQuickSwitcher(BuildContext context) => showDialog<void>(
  context: context,
  builder: (_) => const SessionQuickSwitcherDialog(),
);

class SessionQuickSwitcherDialog extends ConsumerStatefulWidget {
  const SessionQuickSwitcherDialog({super.key});

  @override
  ConsumerState<SessionQuickSwitcherDialog> createState() =>
      _SessionQuickSwitcherDialogState();
}

class _SessionQuickSwitcherDialogState
    extends ConsumerState<SessionQuickSwitcherDialog> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final sessions = ref
        .watch(sessionsProvider((null, null)))
        .sessions
        .where((s) => !s.isArchived)
        .where(
          (s) =>
              _query.isEmpty ||
              s.displayTitle.toLowerCase().contains(_query) ||
              s.sessionId.toLowerCase().contains(_query) ||
              (s.projectPath ?? '').toLowerCase().contains(_query),
        )
        .toList();

    void open(Session s) {
      Navigator.of(context).pop();
      context.go('/chat/${s.sessionId}');
    }

    return Dialog(
      backgroundColor: c.card,
      shape: RoundedRectangleBorder(borderRadius: AppRadii.borderLg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _search,
                autofocus: true,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Jump to session…',
                  prefixIcon: const Icon(LucideIcons.search, size: 16),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: AppRadii.borderMd,
                    borderSide: BorderSide(color: c.input),
                  ),
                ),
                onChanged: (v) => setState(() => _query = v.toLowerCase()),
                onSubmitted: (_) {
                  if (sessions.isNotEmpty) open(sessions.first);
                },
              ),
            ),
            Flexible(
              child: sessions.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'No sessions',
                        style: TextStyle(
                          fontSize: 13,
                          color: c.mutedForeground,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: sessions.length,
                      itemBuilder: (context, i) {
                        final s = sessions[i];
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            s.isRunning
                                ? LucideIcons.loaderCircle
                                : LucideIcons.messageSquare,
                            size: 15,
                            color: s.isRunning
                                ? const Color(0xFF10B981)
                                : c.mutedForeground,
                          ),
                          title: Text(
                            s.displayTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                          subtitle: s.projectPath != null
                              ? Text(
                                  s.projectPath!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: c.mutedForeground,
                                  ),
                                )
                              : null,
                          onTap: () => open(s),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
