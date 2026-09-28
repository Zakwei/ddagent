import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_card.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/sessions_controller.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global (unscoped) sessions feed for the picker — `recent(limit: 100)`
/// backs /sessions when no project is selected.
const _globalScope = (null, null);

/// Sessions already bound to a chat pane must not be pickable again —
/// mounting a second chat for the same session duplicates its websocket
/// subscriptions (port of the openSessionIds exclusion in MainContent.tsx).
Set<String> boundChatSessionIds(List<SplitPane> panes) => {
  for (final p in panes)
    if (p.kind == PaneKind.chat && p.sessionId != null) p.sessionId!,
};

/// Session picker rendered inside a chat pane (port of SessionPicker.tsx):
/// searchable list of non-archived sessions not already bound to another
/// chat pane, "+ New chat" with provider choice, and an Archived section
/// with restore/delete actions.
class SessionPickerPane extends ConsumerStatefulWidget {
  const SessionPickerPane({
    super.key,
    required this.openSessionIds,
    required this.processingSessionIds,
    required this.onSelectSession,
    required this.onNewChat,
    this.canCancel = false,
    this.onCancel,
    this.allowOrchestrator = false,
  });

  final Set<String> openSessionIds;
  final Set<String> processingSessionIds;
  final void Function(Session session) onSelectSession;

  /// "+ New chat" — creates a session (provider chosen via dialog).
  final void Function(String provider) onNewChat;
  final bool canCancel;
  final VoidCallback? onCancel;

  /// Offers 'Auto (orchestrator)' in the provider dialog (T18.1) — only when
  /// the pane's project resolves to a concrete path.
  final bool allowOrchestrator;

  @override
  ConsumerState<SessionPickerPane> createState() => _SessionPickerPaneState();
}

class _SessionPickerPaneState extends ConsumerState<SessionPickerPane> {
  String _query = '';
  bool _showArchived = false;
  bool _loadingArchived = false;
  List<Session> _archived = const [];

  Future<void> _loadArchived() async {
    setState(() => _loadingArchived = true);
    try {
      final list = await ref.read(sessionsRepositoryProvider).archived();
      if (mounted) {
        setState(() {
          _archived = list;
          _loadingArchived = false;
        });
      }
    } on Object {
      if (mounted) setState(() => _loadingArchived = false);
    }
  }

  Future<void> _pickProviderAndCreate() async {
    var provider = 'claude';
    try {
      final caps = await ref.read(sessionsRepositoryProvider).capabilities();
      final providers = [
        for (final p
            in (caps['data']?['providers'] ??
                    caps['providers'] ??
                    const <dynamic>[])
                as List)
          if ((p as Map)['provider'] != null) p['provider'].toString(),
        if (widget.allowOrchestrator) 'orchestrator',
      ];
      if (providers.length > 1 && mounted) {
        final picked = await showDialog<String>(
          context: context,
          builder: (ctx) => AppDialog(
            title: 'New chat — provider',
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final p in providers)
                  ListTile(
                    title: Text(
                      p == 'orchestrator' ? 'Auto (orchestrator)' : p,
                    ),
                    onTap: () => Navigator.of(ctx).pop(p),
                  ),
              ],
            ),
          ),
        );
        if (picked == null) return;
        provider = picked;
      } else if (providers.isNotEmpty) {
        provider = providers.first;
      }
    } on Object {
      // Fall back to the default provider.
    }
    widget.onNewChat(provider);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = context.appColors;
    final state = ref.watch(sessionsProvider(_globalScope));
    final ctrl = ref.read(sessionsProvider(_globalScope).notifier);
    final q = _query.trim().toLowerCase();
    final sessions = [
      for (final s in state.sessions)
        if (!s.isArchived &&
            !widget.openSessionIds.contains(s.sessionId) &&
            (q.isEmpty ||
                s.displayTitle.toLowerCase().contains(q) ||
                (s.provider ?? '').toLowerCase().contains(q)))
          s,
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              Expanded(
                child: AppInput(
                  hint: 'Select session…',
                  autofocus: true,
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              IconButton(
                tooltip: _showArchived ? 'Hide archived' : 'Archived',
                icon: Icon(
                  Icons.archive_outlined,
                  size: 18,
                  color: _showArchived ? c.primary : c.mutedForeground,
                ),
                onPressed: () {
                  final next = !_showArchived;
                  setState(() => _showArchived = next);
                  if (next) unawaited(_loadArchived());
                },
              ),
              if (widget.canCancel && widget.onCancel != null)
                IconButton(
                  tooltip: 'Cancel',
                  icon: Icon(Icons.close, size: 18, color: c.mutedForeground),
                  onPressed: widget.onCancel,
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: SizedBox(
            width: double.infinity,
            child: AppButton(
              size: AppButtonSize.sm,
              variant: AppButtonVariant.secondary,
              onPressed: _pickProviderAndCreate,
              child: const Text('+ New chat'),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: _showArchived
              ? _archivedList(t, c)
              : _sessionList(t, c, sessions, state.loading, ctrl),
        ),
      ],
    );
  }

  Widget _sessionList(
    ThemeData t,
    AppColors c,
    List<Session> sessions,
    bool loading,
    SessionsController ctrl,
  ) {
    if (sessions.isEmpty) {
      return Center(
        child: Text(
          loading ? 'Loading…' : 'No sessions',
          style: t.textTheme.bodySmall?.copyWith(color: c.mutedForeground),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.sm),
      children: [
        for (final s in sessions)
          AppCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            onTap: () => widget.onSelectSession(s),
            child: Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 16,
                  color: c.mutedForeground,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.displayTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.textTheme.bodySmall,
                      ),
                      if (s.provider != null)
                        Text(
                          s.provider!,
                          style: t.textTheme.labelSmall?.copyWith(
                            color: c.mutedForeground,
                          ),
                        ),
                    ],
                  ),
                ),
                if (widget.processingSessionIds.contains(s.sessionId))
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: c.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    size: 16,
                    color: c.mutedForeground,
                  ),
                  onSelected: (v) => unawaited(_sessionAction(v, s, ctrl)),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'archive', child: Text('Archive')),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete permanently'),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _archivedList(ThemeData t, AppColors c) {
    if (_loadingArchived) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_archived.isEmpty) {
      return Center(
        child: Text(
          'No archived sessions',
          style: t.textTheme.bodySmall?.copyWith(color: c.mutedForeground),
        ),
      );
    }
    final q = _query.trim().toLowerCase();
    final sessions = [
      for (final s in _archived)
        if (q.isEmpty || s.displayTitle.toLowerCase().contains(q)) s,
    ];
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.sm),
      children: [
        for (final s in sessions)
          AppCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.archive_outlined,
                  size: 16,
                  color: c.mutedForeground,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    s.displayTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.textTheme.bodySmall,
                  ),
                ),
                TextButton(
                  onPressed: () => unawaited(_restore(s)),
                  child: const Text('Restore'),
                ),
                IconButton(
                  tooltip: 'Delete permanently',
                  icon: Icon(
                    Icons.delete_outline,
                    size: 16,
                    color: c.destructive,
                  ),
                  onPressed: () => unawaited(_delete(s, refreshArchived: true)),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _sessionAction(
    String action,
    Session s,
    SessionsController ctrl,
  ) async {
    if (action == 'archive') {
      final err = await ctrl.archive(s.sessionId);
      if (!mounted) return;
      if (err != null) {
        AppToast.error(context, err);
      } else {
        AppToast.show(context, 'Session archived');
      }
    } else if (action == 'delete') {
      await _delete(s);
    }
  }

  Future<void> _restore(Session s) async {
    try {
      await ref.read(sessionsRepositoryProvider).restore(s.sessionId);
      if (!mounted) return;
      AppToast.show(context, 'Session restored');
      unawaited(_loadArchived());
      unawaited(ref.read(sessionsProvider(_globalScope).notifier).load());
    } on Object catch (e) {
      if (mounted) AppToast.error(context, '$e');
    }
  }

  Future<void> _delete(Session s, {bool refreshArchived = false}) async {
    final ok = await AppDialog.confirm(
      context,
      title: 'Delete session?',
      message:
          'Removes "${s.displayTitle}" and its transcript. '
          'This cannot be undone.',
      confirmLabel: 'Delete',
    );
    if (!ok) return;
    try {
      await ref
          .read(sessionsRepositoryProvider)
          .delete(s.sessionId, hardDelete: true);
      if (!mounted) return;
      AppToast.show(context, 'Session deleted');
      if (refreshArchived) {
        unawaited(_loadArchived());
      }
      unawaited(ref.read(sessionsProvider(_globalScope).notifier).load());
    } on Object catch (e) {
      if (mounted) AppToast.error(context, '$e');
    }
  }
}
