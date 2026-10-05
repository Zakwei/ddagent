import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/features/queue/data/queue_repository.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/view/split_workspace_grid.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One tile in the overview grid — title/subtitle/action already resolved
/// through `splitPaneDisplay` by the caller.
class OverviewPaneInfo {
  const OverviewPaneInfo({
    required this.pane,
    required this.title,
    this.subtitle,
    this.action = PaneAction.idle,
  });

  final SplitPane pane;
  final String title;
  final String? subtitle;
  final PaneAction action;
}

/// Split panes overview (port of SplitOverviewDialog.tsx): grid of pane
/// cards with kind icon, title, subtitle and action badge; tap activates
/// the pane and closes.
class SplitOverviewDialog extends StatelessWidget {
  const SplitOverviewDialog({
    super.key,
    required this.panes,
    required this.onSelectPane,
    this.activePaneId,
  });

  final List<OverviewPaneInfo> panes;
  final String? activePaneId;
  final ValueChanged<String> onSelectPane;

  static Future<void> show(
    BuildContext context, {
    required List<OverviewPaneInfo> panes,
    required ValueChanged<String> onSelectPane,
    String? activePaneId,
  }) => showDialog<void>(
    context: context,
    builder: (_) =>
        SplitOverviewDialog(panes: panes, onSelectPane: onSelectPane, activePaneId: activePaneId),
  );

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final i18n = Translations.of(context);
    final c = context.appColors;
    return Dialog(
      insetPadding: const EdgeInsets.all(AppSpacing.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Text(i18n.chat.splitOverview.title, style: t.textTheme.titleSmall),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${panes.length} panes',
                    style: t.textTheme.labelSmall?.copyWith(color: c.mutedForeground),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: i18n.chat.splitOverview.close,
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(AppSpacing.lg),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 240,
                  mainAxisExtent: 140,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                itemCount: panes.length,
                itemBuilder: (context, i) {
                  final info = panes[i];
                  final isActive = info.pane.id == activePaneId;
                  final (border, bg) = switch (info.action) {
                    PaneAction.question => (
                      const Color(0xFFF59E0B),
                      const Color(0xFFF59E0B).withValues(alpha: 0.05),
                    ),
                    PaneAction.processing => (
                      const Color(0xFF22C55E),
                      const Color(0xFF22C55E).withValues(alpha: 0.05),
                    ),
                    PaneAction.idle => (c.border, c.card),
                  };
                  return InkWell(
                    borderRadius: AppRadii.borderLg,
                    onTap: () {
                      onSelectPane(info.pane.id);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: AppRadii.borderLg,
                        border: Border.all(
                          color: isActive ? c.primary : border,
                          width: isActive ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                paneKindIcon(info.pane.kind),
                                size: 16,
                                color: c.mutedForeground,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                info.pane.kind.name.toUpperCase(),
                                style: t.textTheme.labelSmall?.copyWith(
                                  color: c.mutedForeground,
                                  fontSize: 10,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const Spacer(),
                              if (isActive)
                                Text(
                                  'ACTIVE',
                                  style: t.textTheme.labelSmall?.copyWith(
                                    color: c.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            info.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.textTheme.titleMedium,
                          ),
                          if (info.subtitle != null)
                            Text(
                              info.subtitle!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.textTheme.labelSmall?.copyWith(color: c.mutedForeground),
                            ),
                          const Spacer(),
                          SizedBox(
                            height: 18,
                            child: switch (info.action) {
                              PaneAction.question => Row(
                                children: [
                                  const Icon(
                                    Icons.warning_amber_rounded,
                                    size: 14,
                                    color: Color(0xFFF59E0B),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'QUESTION — input required',
                                    style: t.textTheme.labelSmall?.copyWith(
                                      color: const Color(0xFFF59E0B),
                                    ),
                                  ),
                                ],
                              ),
                              PaneAction.processing => Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF22C55E),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'PROCESSING',
                                    style: t.textTheme.labelSmall?.copyWith(
                                      color: const Color(0xFF22C55E),
                                    ),
                                  ),
                                ],
                              ),
                              PaneAction.idle => const SizedBox.shrink(),
                            },
                          ),
                        ],
                      ),
                    ),
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

/// Broadcast (port of BroadcastDialog.tsx): multi-select non-archived
/// sessions — orchestrators-only toggle + select-all — then one queued
/// message per session via `POST /api/queue/broadcast`; the server returns
/// per-session results so rejected targets surface here instead of a snackbar.
class BroadcastDialog extends ConsumerStatefulWidget {
  const BroadcastDialog({super.key, required this.sessions});

  /// Candidate sessions; archived rows are filtered out.
  final List<Session> sessions;

  static Future<void> show(BuildContext context, {required List<Session> sessions}) =>
      showDialog<void>(
        context: context,
        builder: (_) => BroadcastDialog(sessions: sessions),
      );

  @override
  ConsumerState<BroadcastDialog> createState() => _BroadcastDialogState();
}

class _BroadcastDialogState extends ConsumerState<BroadcastDialog> {
  final _message = TextEditingController();
  final _selected = <String>{};
  bool _orchestratorsOnly = false;
  bool _sending = false;
  List<Map<String, dynamic>>? _results;
  String? _error;

  static bool _isOrchestrator(Session s) => (s.provider ?? s.raw['__provider']) == 'orchestrator';

  List<Session> get _selectable => [
    for (final s in widget.sessions)
      if (!s.isArchived) s,
  ];

  List<Session> get _visible => _orchestratorsOnly
      ? [
          for (final s in _selectable)
            if (_isOrchestrator(s)) s,
        ]
      : _selectable;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final content = _message.text.trim();
    if (content.isEmpty || _selected.isEmpty) return;
    setState(() {
      _sending = true;
      _results = null;
      _error = null;
    });
    try {
      final results = await ref
          .read(queueRepositoryProvider)
          .broadcast(_selected.toList(), content);
      if (mounted) setState(() => _results = results);
    } on Object catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final i18n = Translations.of(context);
    final c = context.appColors;
    final hasOrchestrators = _selectable.any(_isOrchestrator);
    return AppDialog(
      title: i18n.chat.splitWorkspace.broadcast,
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasOrchestrators || _orchestratorsOnly)
              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(i18n.chat.broadcast.orchestratorsOnly, style: t.textTheme.bodySmall),
                value: _orchestratorsOnly,
                onChanged: (v) {
                  setState(() {
                    _orchestratorsOnly = v ?? false;
                    if (_orchestratorsOnly) {
                      _selected.removeWhere(
                        (id) => !_selectable.any((s) => s.sessionId == id && _isOrchestrator(s)),
                      );
                    }
                  });
                },
              ),
            Container(
              constraints: const BoxConstraints(maxHeight: 220),
              decoration: BoxDecoration(
                border: Border.all(color: c.border),
                borderRadius: AppRadii.borderMd,
              ),
              child: _visible.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Center(
                        child: Text(
                          _orchestratorsOnly
                              ? 'No orchestrator sessions available'
                              : 'No sessions available',
                          style: t.textTheme.bodySmall?.copyWith(color: c.mutedForeground),
                        ),
                      ),
                    )
                  : ListView(
                      shrinkWrap: true,
                      children: [
                        for (final s in _visible)
                          CheckboxListTile(
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(
                              s.displayTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.textTheme.bodySmall,
                            ),
                            value: _selected.contains(s.sessionId),
                            onChanged: (v) => setState(() {
                              if (v ?? false) {
                                _selected.add(s.sessionId);
                              } else {
                                _selected.remove(s.sessionId);
                              }
                            }),
                          ),
                      ],
                    ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                TextButton(
                  onPressed: () => setState(
                    () => _selected
                      ..clear()
                      ..addAll([for (final s in _visible) s.sessionId]),
                  ),
                  child: Text(i18n.chat.broadcast.selectAll),
                ),
                if (hasOrchestrators && !_orchestratorsOnly)
                  TextButton(
                    onPressed: () => setState(
                      () => _selected
                        ..clear()
                        ..addAll([
                          for (final s in _visible)
                            if (_isOrchestrator(s)) s.sessionId,
                        ]),
                    ),
                    child: Text(i18n.chat.broadcast.selectOrchestrators),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            AppInput(controller: _message, hint: i18n.chat.broadcast.placeholder, maxLines: 3),
            if (_results != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                _results!.where((r) => r['ok'] == false).isEmpty
                    ? 'Queued for ${_results!.length} session(s)'
                    : '${_results!.where((r) => r['ok'] == false).length} session(s) rejected the message',
                style: t.textTheme.bodySmall?.copyWith(
                  color: _results!.where((r) => r['ok'] == false).isEmpty
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFF59E0B),
                ),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(_error!, style: t.textTheme.bodySmall?.copyWith(color: c.destructive)),
            ],
          ],
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(i18n.chat.orchestrator.summary.cancelTasks),
        ),
        AppButton(
          loading: _sending,
          onPressed: _selected.isEmpty || _message.text.trim().isEmpty
              ? null
              : () => unawaited(_send()),
          child: Text(i18n.workspace.sendTo(count: _selected.length)),
        ),
      ],
    );
  }
}
