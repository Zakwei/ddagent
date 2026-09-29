import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/sessions_controller.dart';
import 'package:ddagent_app/features/sessions/view/session_list_row.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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

/// The picker's centered reading column — `mx-auto w-full max-w-4xl`.
const double _contentMaxWidth = 896;

Widget _constrained(Widget child) => Align(
  alignment: Alignment.topCenter,
  child: ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
    child: child,
  ),
);

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
  bool _archivedError = false;
  List<Session> _archived = const [];
  List<Project> _archivedProjects = const [];
  String? _busySessionId;
  String? _busyProjectId;
  Timer? _ageTicker;

  @override
  void initState() {
    super.initState();
    // Ages are coarse ("42m") — refresh once a minute like the React picker.
    _ageTicker = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ageTicker?.cancel();
    super.dispose();
  }

  Future<void> _loadArchived() async {
    setState(() {
      _loadingArchived = true;
      _archivedError = false;
    });
    List<Session> sessions;
    try {
      sessions = await ref.read(sessionsRepositoryProvider).archived();
    } on Object {
      if (mounted) {
        setState(() {
          _loadingArchived = false;
          _archivedError = true;
        });
      }
      return;
    }
    var projects = const <Project>[];
    try {
      projects = await ref.read(projectsRepositoryProvider).archived();
    } on Object {
      // Older servers lack /api/projects/archived — sessions still list.
    }
    if (mounted) {
      setState(() {
        _archived = sessions;
        _archivedProjects = projects;
        _loadingArchived = false;
      });
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

    return Container(
      color: c.background,
      child: Column(
        children: [
          _topBar(c),
          Expanded(
            child: _showArchived
                ? _archivedBody(c)
                : _sessionList(c, sessions, state.loading, ctrl),
          ),
        ],
      ),
    );
  }

  /// border-b border-border/50, px-2 py-1.5, centered max-w-4xl row.
  Widget _topBar(AppColors c) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: c.border.withValues(alpha: 0.5)),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
          child: LayoutBuilder(
            builder: (context, box) {
              // Tailwind sm: — the Archived label hides on narrow panes.
              final compact = box.maxWidth < 640;
              return Row(
                spacing: 6,
                children: [
                  Expanded(
                    child: SessionSearchField(
                      autofocus: true,
                      onChanged: (v) => setState(() => _query = v),
                      onEscape: widget.canCancel ? widget.onCancel : null,
                    ),
                  ),
                  SessionListToolbarButton(
                    icon: LucideIcons.archive,
                    label: 'Archived',
                    active: _showArchived,
                    showLabel: !compact,
                    onTap: () {
                      final next = !_showArchived;
                      setState(() => _showArchived = next);
                      if (next) unawaited(_loadArchived());
                    },
                  ),
                  if (widget.canCancel && widget.onCancel != null)
                    SizedBox(
                      height: 32,
                      child: AppButton(
                        variant: AppButtonVariant.ghost,
                        size: AppButtonSize.sm,
                        onPressed: widget.onCancel,
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _sessionList(
    AppColors c,
    List<Session> sessions,
    bool loading,
    SessionsController ctrl,
  ) {
    final hasQuery = _query.trim().isNotEmpty;
    return ListView(
      padding: const EdgeInsets.all(6),
      children: [
        _constrained(
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: _NewChatButton(onTap: _pickProviderAndCreate),
          ),
        ),
        if (sessions.isEmpty)
          _constrained(
            _PickerEmptyState(
              icon: hasQuery
                  ? LucideIcons.search
                  : LucideIcons.messageSquarePlus,
              label: loading
                  ? 'Loading…'
                  : hasQuery
                  ? 'No sessions match your search'
                  : 'No other sessions available',
            ),
          )
        else
          _constrained(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SessionListGroupHeading('Recent sessions'),
                for (final s in sessions) _sessionRow(c, s, ctrl),
              ],
            ),
          ),
      ],
    );
  }

  Widget _sessionRow(AppColors c, Session s, SessionsController ctrl) {
    return SessionListRow(
      session: s,
      running: widget.processingSessionIds.contains(s.sessionId) || s.isRunning,
      unread: s.isUnread,
      onTap: () => widget.onSelectSession(s),
      menu: PopupMenuButton<String>(
        tooltip: 'Session options',
        style: const ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onSelected: (v) => unawaited(_sessionAction(v, s, ctrl)),
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'archive', child: Text('Archive')),
          PopupMenuItem(value: 'delete', child: Text('Delete permanently')),
        ],
        child: SizedBox(
          width: 28,
          height: 28,
          child: Icon(
            LucideIcons.moreHorizontal,
            size: 14,
            color: c.mutedForeground,
          ),
        ),
      ),
    );
  }

  // ─── Archived view ──────────────────────────────────────────────────────

  Widget _archivedBody(AppColors c) {
    if (_loadingArchived) {
      return ListView(
        padding: const EdgeInsets.all(6),
        children: [
          _constrained(
            Column(
              children: [
                for (var i = 0; i < 4; i++)
                  Container(
                    height: 36,
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: c.muted.withValues(alpha: 0.6),
                      borderRadius: AppRadii.borderMd,
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    }
    if (_archivedError) {
      return ListView(
        padding: const EdgeInsets.all(6),
        children: [
          _constrained(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Text(
                    'Could not load archived sessions',
                    style: TextStyle(fontSize: 12, color: c.destructive),
                  ),
                  const SizedBox(height: 8),
                  AppButton(
                    variant: AppButtonVariant.outline,
                    size: AppButtonSize.sm,
                    onPressed: () => unawaited(_loadArchived()),
                    child: const Text('Retry', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
    final groups = _archivedGroups();
    if (groups.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(6),
        children: [
          _constrained(
            const _PickerEmptyState(
              icon: LucideIcons.archive,
              label: 'No archived sessions',
            ),
          ),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.all(6),
      children: [
        _constrained(
          Column(children: [for (final g in groups) _archivedGroup(c, g)]),
        ),
      ],
    );
  }

  /// Groups archived sessions under their project, newest activity first
  /// (port of groupArchivedPickerSessions); archived projects without
  /// sessions are appended as empty groups so the workspace can be restored.
  List<_ArchivedGroup> _archivedGroups() {
    final q = _query.trim().toLowerCase();
    bool match(String? v) =>
        q.isEmpty || (v != null && v.toLowerCase().contains(q));

    final groups = <String, _ArchivedGroup>{};
    for (final s in _archived) {
      if (!match(_archivedTitle(s)) && !match(_archivedProjectName(s))) {
        continue;
      }
      final key = s.projectId ?? s.projectPath ?? 'session:${s.sessionId}';
      final g = groups.putIfAbsent(
        key,
        () => _ArchivedGroup(
          projectId: s.projectId,
          name: _archivedProjectName(s),
          isProjectArchived: s.raw['isProjectArchived'] == true,
        ),
      );
      g.sessions.add(s);
      final la = s.lastActivity;
      if (la != null &&
          (g.latestActivity == null || la.compareTo(g.latestActivity!) > 0)) {
        g.latestActivity = la;
      }
    }
    for (final p in _archivedProjects) {
      if (!match(p.displayName) && !match(p.projectId)) continue;
      groups.putIfAbsent(
        p.projectId,
        () => _ArchivedGroup(
          projectId: p.projectId,
          name: p.displayName.isNotEmpty ? p.displayName : p.projectId,
          isProjectArchived: true,
        ),
      );
    }
    return groups.values.toList()..sort(
      (a, b) => (b.latestActivity ?? '').compareTo(a.latestActivity ?? ''),
    );
  }

  String _archivedTitle(Session s) {
    final t = (s.raw['sessionTitle'] as String?)?.trim();
    return (t != null && t.isNotEmpty) ? t : s.displayTitle;
  }

  String _archivedProjectName(Session s) {
    final n = s.raw['projectDisplayName'] as String?;
    if (n != null && n.isNotEmpty) return n;
    final path = s.projectPath;
    if (path != null && path.isNotEmpty) {
      final segs = path.split(RegExp(r'[\\/]'))..removeWhere((e) => e.isEmpty);
      if (segs.isNotEmpty) return segs.last;
    }
    return s.projectId ?? 'Archived';
  }

  Widget _archivedGroup(AppColors c, _ArchivedGroup g) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        border: Border.all(color: c.border.withValues(alpha: 0.6)),
        borderRadius: AppRadii.borderMd,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: c.muted.withValues(alpha: 0.3),
              border: Border(
                bottom: BorderSide(color: c.border.withValues(alpha: 0.5)),
              ),
            ),
            child: Row(
              spacing: AppSpacing.sm,
              children: [
                Icon(LucideIcons.folder, size: 14, color: c.mutedForeground),
                Expanded(
                  child: Text(
                    g.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: c.foreground,
                    ),
                  ),
                ),
                if (g.isProjectArchived && g.projectId != null)
                  _RestoreButton(
                    label: 'Restore workspace',
                    busy: _busyProjectId == g.projectId,
                    onTap: () => unawaited(_restoreProject(g.projectId!)),
                  ),
              ],
            ),
          ),
          if (g.sessions.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 6,
              ),
              child: Text(
                'Workspace archived — restore it to see its sessions.',
                style: TextStyle(fontSize: 10, color: c.mutedForeground),
              ),
            )
          else
            for (var i = 0; i < g.sessions.length; i++)
              _archivedRow(
                c,
                g.sessions[i],
                isLast: i == g.sessions.length - 1,
              ),
        ],
      ),
    );
  }

  Widget _archivedRow(AppColors c, Session s, {required bool isLast}) {
    final age = formatSessionAge(s.lastActivity, DateTime.now());
    final meta = [
      if (age.isNotEmpty) age,
      if (s.messageCount > 0) '${s.messageCount}',
    ].join(' · ');
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: c.border.withValues(alpha: 0.35)),
              ),
      ),
      child: Row(
        spacing: AppSpacing.sm,
        children: [
          const SessionProviderBadge(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _archivedTitle(s),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: c.foreground),
                ),
                if (meta.isNotEmpty)
                  Text(
                    meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: c.mutedForeground,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
              ],
            ),
          ),
          _RestoreButton(
            label: 'Restore',
            busy: _busySessionId == s.sessionId,
            onTap: () => unawaited(_restore(s)),
          ),
          _IconActionButton(
            icon: LucideIcons.trash2,
            tooltip: 'Delete permanently',
            danger: true,
            onTap: () => unawaited(_delete(s, refreshArchived: true)),
          ),
        ],
      ),
    );
  }

  // ─── Actions ────────────────────────────────────────────────────────────

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
    setState(() => _busySessionId = s.sessionId);
    try {
      await ref.read(sessionsRepositoryProvider).restore(s.sessionId);
      if (!mounted) return;
      AppToast.show(context, 'Session restored');
      unawaited(_loadArchived());
      unawaited(ref.read(sessionsProvider(_globalScope).notifier).load());
    } on Object catch (e) {
      if (mounted) AppToast.error(context, '$e');
    } finally {
      if (mounted) setState(() => _busySessionId = null);
    }
  }

  Future<void> _restoreProject(String projectId) async {
    setState(() => _busyProjectId = projectId);
    try {
      await ref.read(projectsRepositoryProvider).restore(projectId);
      if (!mounted) return;
      AppToast.show(context, 'Workspace restored');
      unawaited(_loadArchived());
    } on Object catch (e) {
      if (mounted) AppToast.error(context, '$e');
    } finally {
      if (mounted) setState(() => _busyProjectId = null);
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

/// One archived-project group (port of PickerArchivedGroup).
class _ArchivedGroup {
  _ArchivedGroup({
    required this.projectId,
    required this.name,
    required this.isProjectArchived,
  });

  final String? projectId;
  final String name;
  final bool isProjectArchived;
  String? latestActivity;
  final List<Session> sessions = [];
}

/// "+ New chat" — full-width dashed-border row (React: border-dashed
/// border-border/70, hover border-primary/50 + bg-accent).
class _NewChatButton extends StatefulWidget {
  const _NewChatButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_NewChatButton> createState() => _NewChatButtonState();
}

class _NewChatButtonState extends State<_NewChatButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: AppRadii.borderMd,
          hoverColor: Colors.transparent,
          child: CustomPaint(
            foregroundPainter: _DashedRRect(
              color: _hover
                  ? c.primary.withValues(alpha: 0.5)
                  : c.border.withValues(alpha: 0.7),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: _hover ? c.accent : Colors.transparent,
                borderRadius: AppRadii.borderMd,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 6,
              ),
              child: Row(
                spacing: AppSpacing.sm,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: c.primary.withValues(alpha: 0.1),
                      borderRadius: AppRadii.borderMd,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      LucideIcons.messageSquarePlus,
                      size: 16,
                      color: c.primary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '+ New chat',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: c.foreground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Dashed rounded-rect stroke for the "+ New chat" row.
class _DashedRRect extends CustomPainter {
  const _DashedRRect({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(AppRadii.md),
    ).deflate(0.5);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    const dash = 4.0;
    const gap = 3.0;
    for (final metric in (Path()..addRRect(rrect)).computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + dash), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRRect old) => old.color != color;
}

/// Small icon + label button used by the archived view's Restore actions
/// (React restoreButtonClass: h-6 px-1.5 text-[10px], hover emerald).
class _RestoreButton extends StatefulWidget {
  const _RestoreButton({
    required this.label,
    required this.onTap,
    this.busy = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool busy;

  @override
  State<_RestoreButton> createState() => _RestoreButtonState();
}

class _RestoreButtonState extends State<_RestoreButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final emerald = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF6EE7B7) // emerald-300
        : const Color(0xFF047857); // emerald-700
    final fg = _hover ? emerald : c.mutedForeground;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.busy ? null : widget.onTap,
          borderRadius: AppRadii.borderSm,
          hoverColor: const Color(0xFF10B981).withValues(alpha: 0.1),
          child: Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                if (widget.busy)
                  SizedBox.square(
                    dimension: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: fg,
                    ),
                  )
                else
                  Icon(LucideIcons.rotateCcw, size: 12, color: fg),
                Text(widget.label, style: TextStyle(fontSize: 10, color: fg)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 28×28 icon button for row actions (React rowActionButtonClass — muted,
/// hover bg-muted / hover red for destructive).
class _IconActionButton extends StatefulWidget {
  const _IconActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool danger;

  @override
  State<_IconActionButton> createState() => _IconActionButtonState();
}

class _IconActionButtonState extends State<_IconActionButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    const red = Color(0xFFDC2626); // red-600
    final fg = _hover
        ? (widget.danger ? red : c.foreground)
        : c.mutedForeground;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Tooltip(
        message: widget.tooltip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: AppRadii.borderMd,
            hoverColor: widget.danger
                ? const Color(0xFFEF4444).withValues(alpha: 0.1)
                : c.muted,
            child: SizedBox(
              width: 28,
              height: 28,
              child: Icon(widget.icon, size: 14, color: fg),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small centered empty state (React EmptyState size="sm": icon + title).
class _PickerEmptyState extends StatelessWidget {
  const _PickerEmptyState({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 24,
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: c.mutedForeground),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: c.mutedForeground),
          ),
        ],
      ),
    );
  }
}
