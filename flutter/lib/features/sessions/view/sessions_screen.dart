import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/sse_client.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_nav_menu.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/chat/view/chat_utilities.dart';
import 'package:ddagent_app/features/orchestrator/state/orchestrator_controller.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/sessions_controller.dart';
import 'package:ddagent_app/features/sessions/view/session_list_row.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// The picker's centered reading column — `mx-auto w-full max-w-4xl`.
const double _contentMaxWidth = 896;

/// Sessions for one project (query params projectId/projectPath) — parity with
/// the mobile SessionsScreen: search, archive toggle, provider picker for new
/// sessions, pinned ordering, running/unread indicators, action sheet.
class SessionsScreen extends ConsumerStatefulWidget {
  const SessionsScreen({super.key, this.projectId, this.projectPath});

  final String? projectId;
  final String? projectPath;

  @override
  ConsumerState<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends ConsumerState<SessionsScreen> {
  String _query = '';
  Timer? _searchDebounce;
  Timer? _ageTicker;
  CancelToken? _searchCancel;
  List<Map<String, String>> _searchMatches = const [];
  bool _searching = false;

  (String?, String?) get _scope => (widget.projectId, widget.projectPath);

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
    _searchDebounce?.cancel();
    _ageTicker?.cancel();
    _searchCancel?.cancel();
    super.dispose();
  }

  /// Full-text message search is SSE (title-results → result → done).
  void _onSearchChanged(String q) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      _searchCancel?.cancel();
      if (q.trim().isEmpty) {
        setState(() => _searchMatches = const []);
        return;
      }
      setState(() {
        _searching = true;
        _searchMatches = const [];
      });
      final token = _searchCancel = CancelToken();
      unawaited(() async {
        try {
          await for (final e
              in ref.read(sseClientProvider).searchSessions(q.trim(), cancelToken: token)) {
            if (!mounted) return;
            if (e.event == 'error') {
              setState(() => _searching = false);
              return;
            }
            if (e.event == 'done') {
              setState(() => _searching = false);
              return;
            }
            if (e.event != 'result') continue;
            final pr = e.data['projectResult'];
            if (pr is! Map) continue;
            final pid = pr['projectId']?.toString();
            if (widget.projectId != null && pid != null && pid != widget.projectId) {
              continue;
            }
            final found = <Map<String, String>>[
              for (final s in (pr['sessions'] as List? ?? const []))
                if ((s as Map)['sessionId'] != null)
                  {
                    'id': s['sessionId'].toString(),
                    'label': (s['sessionSummary'] ?? '').toString(),
                    'provider': (s['provider'] ?? '').toString(),
                    'snippet': () {
                      final m = s['matches'];
                      return (m is List && m.isNotEmpty && m.first is Map)
                          ? ((m.first as Map)['snippet'] ?? '').toString()
                          : '';
                    }(),
                  },
            ];
            if (found.isNotEmpty) {
              setState(() => _searchMatches = [..._searchMatches, ...found]);
            }
          }
        } on DioException catch (e) {
          if (!CancelToken.isCancel(e) && mounted) {
            setState(() => _searching = false);
          }
        }
        if (mounted) setState(() => _searching = false);
      }());
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final state = ref.watch(sessionsProvider(_scope));
    final ctrl = ref.read(sessionsProvider(_scope).notifier);

    if (state.loading && state.sessions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final q = _query.trim().toLowerCase();
    final local = q.isEmpty
        ? ctrl.sorted(state.sessions)
        : ctrl.sorted([
            for (final s in state.sessions)
              if (s.displayTitle.toLowerCase().contains(q) ||
                  (s.provider ?? '').toLowerCase().contains(q))
                s,
          ]);
    final localIds = {for (final s in local) s.sessionId};
    final extraMatches = [
      for (final m in _searchMatches)
        if (!localIds.contains(m['id'])) m,
    ];

    return Scaffold(
      body: Column(
        children: [
          _toolbar(c, state, ctrl),
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
                    decoration: BoxDecoration(
                      color: c.destructive.withValues(alpha: 0.1),
                      borderRadius: AppRadii.borderMd,
                      border: Border.all(color: c.destructive.withValues(alpha: 0.4)),
                    ),
                    child: Text(state.error!, style: TextStyle(fontSize: 11, color: c.destructive)),
                  ),
                ),
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: ctrl.load,
              child: ListView(
                padding: const EdgeInsets.all(6),
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // The picker's "+ New chat" dashed row — the old
                          // panel keeps session creation in the list body,
                          // not in the toolbar (stays up in Archived too).
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: SessionNewChatButton(onTap: () => unawaited(_newSession())),
                          ),
                          if (widget.projectId != null &&
                              !state.showArchived &&
                              local.isNotEmpty) ...[
                            // Same split as the in-pane picker: the scoped
                            // project first, everything else under OTHER
                            // PROJECTS (SessionPicker.tsx:707).
                            // Scoped rows from /projects/:id/sessions carry
                            // no projectId — a missing id means "belongs to
                            // this scope", not "other project".
                            if (local.any((s) => _isScopeSession(s)))
                              SessionListGroupHeading('Current project (${_scopeProjectName()})'),
                            for (final s in local)
                              if (_isScopeSession(s)) _row(c, s, ctrl, state),
                            if (local.any((s) => !_isScopeSession(s)))
                              const SessionListGroupHeading('Other projects'),
                            for (final s in local)
                              if (!_isScopeSession(s)) _row(c, s, ctrl, state),
                          ] else ...[
                            SessionListGroupHeading(
                              state.showArchived ? 'Archived sessions' : 'Recent sessions',
                            ),
                            for (final s in local) _row(c, s, ctrl, state),
                          ],
                          for (final m in extraMatches)
                            _SearchMatchRow(
                              label: m['label']!.isEmpty ? m['id']! : m['label']!,
                              snippet: m['snippet'] ?? '',
                              provider: m['provider'],
                              onTap: () => _open(m['id']!),
                            ),
                          if (local.isEmpty && extraMatches.isEmpty && !state.loading)
                            SessionListEmptyState(
                              icon: q.isEmpty ? LucideIcons.messageSquarePlus : LucideIcons.search,
                              label: q.isEmpty ? 'No sessions' : 'No sessions match your search',
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Scoped rows carry no `projectId` — only an explicit mismatch counts as
  /// "other project".
  bool _isScopeSession(Session s) => s.projectId == null || s.projectId == widget.projectId;

  /// Display name for the `Current project (…)` heading.
  String _scopeProjectName() {
    for (final p in ref.read(projectsProvider).projects) {
      if (p.projectId == widget.projectId) {
        return p.displayName.isNotEmpty ? p.displayName : p.path;
      }
    }
    return widget.projectId ?? '';
  }

  Widget _row(AppColors c, Session s, SessionsController ctrl, SessionsState state) {
    return SessionListRow(
      session: s,
      running: s.isRunning,
      unread: s.isUnread,
      subtitle: sessionRowSubtitle(s),
      trailing: [
        if (ctrl.isPinned(s.sessionId)) Icon(LucideIcons.pin, size: 12, color: c.mutedForeground),
      ],
      onTap: () => _open(s.sessionId),
      // sm+ widths get the hover-revealed inline buttons; the ⋯ menu below
      // only survives on narrow (touch) panes.
      actions: [
        if (!state.showArchived)
          SessionRowIconButton(
            icon: LucideIcons.eyeOff,
            tooltip: 'Archive session',
            onTap: () => _run(() => ctrl.archive(s.sessionId), 'Session archived'),
          )
        else
          SessionRowIconButton(
            icon: LucideIcons.rotateCcw,
            tooltip: 'Restore session',
            onTap: () => _run(() => ctrl.restore(s.sessionId), 'Session restored'),
          ),
        SessionRowIconButton(
          icon: LucideIcons.trash2,
          tooltip: 'Delete permanently',
          danger: true,
          onTap: () => _confirmDelete(s, ctrl),
        ),
      ],
      menu: _sessionMenu(s, ctrl, state.showArchived),
    );
  }

  /// border-b border-border/50, px-2 py-1.5, centered max-w-4xl row —
  /// same top-bar language as the in-pane picker.
  Widget _toolbar(AppColors c, SessionsState state, SessionsController ctrl) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.border.withValues(alpha: 0.5))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
          child: LayoutBuilder(
            builder: (context, box) {
              final compact = box.maxWidth < 640;
              return Row(
                spacing: 6,
                children: [
                  const AppNavMenuButton(),
                  Expanded(
                    child: SessionSearchField(
                      showSpinner: _searching,
                      onChanged: (v) {
                        setState(() => _query = v);
                        _onSearchChanged(v);
                      },
                    ),
                  ),
                  SessionListToolbarButton(
                    icon: LucideIcons.archive,
                    label: 'Archived',
                    active: state.showArchived,
                    showLabel: !compact,
                    onTap: () => unawaited(ctrl.toggleArchived()),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _open(String sessionId) {
    unawaited(ref.read(sessionsRepositoryProvider).markViewed(sessionId));
    final params = <String, String>{
      if (widget.projectId != null) 'projectId': widget.projectId!,
      if (widget.projectPath != null) 'projectPath': widget.projectPath!,
    };
    context.go(Uri(path: '/chat/$sessionId', queryParameters: params).toString());
  }

  Widget _sessionMenu(Session s, SessionsController ctrl, bool archived) {
    final entries = archived
        ? <(String, VoidCallback)>[
            ('Restore', () => _run(() => ctrl.restore(s.sessionId), 'Session restored')),
            ('Delete permanently', () => _confirmDelete(s, ctrl)),
          ]
        : <(String, VoidCallback)>[
            ('Rename', () => unawaited(_renameDialog(s, ctrl))),
            ('Change workspace', () => unawaited(_workspaceDialog(s, ctrl))),
            (
              ctrl.isPinned(s.sessionId) ? 'Unpin session' : 'Pin session',
              () {
                final pinned = ctrl.togglePin(s.sessionId);
                AppToast.show(context, pinned ? 'Session pinned' : 'Session unpinned');
                setState(() {});
              },
            ),
            ('Compare with…', () => unawaited(_compareDialog(s))),
            ('Archive', () => _run(() => ctrl.archive(s.sessionId), 'Session archived')),
            ('Delete permanently', () => _confirmDelete(s, ctrl)),
          ];
    final c = context.appColors;
    return PopupMenuButton<int>(
      tooltip: 'Session options',
      style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      onSelected: (i) => entries[i].$2(),
      itemBuilder: (_) => [
        for (var i = 0; i < entries.length; i++)
          PopupMenuItem(
            value: i,
            child: Text(
              entries[i].$1,
              style: entries[i].$1.contains('Delete')
                  ? TextStyle(color: context.appColors.destructive)
                  : null,
            ),
          ),
      ],
      child: SizedBox(
        width: 28,
        height: 28,
        child: Icon(LucideIcons.moreHorizontal, size: 14, color: c.mutedForeground),
      ),
    );
  }

  /// T17.8 — pick another session, then show the side-by-side usage compare.
  Future<void> _compareDialog(Session s) async {
    final others = ref
        .read(sessionsProvider(_scope))
        .sessions
        .where((o) => o.sessionId != s.sessionId)
        .toList();
    final other = await showDialog<Session>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Compare with…'),
        children: [
          for (final o in others.take(20))
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, o),
              child: Text(
                (o.summary?.isNotEmpty ?? false) ? o.summary! : o.sessionId,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
    if (other == null || !mounted) return;
    unawaited(
      showDialog<void>(
        context: context,
        builder: (_) => SessionCompareDialog(
          left: (
            s.sessionId,
            s.provider,
            (s.summary?.isNotEmpty ?? false) ? s.summary! : s.sessionId,
          ),
          right: (
            other.sessionId,
            other.provider,
            (other.summary?.isNotEmpty ?? false) ? other.summary! : other.sessionId,
          ),
        ),
      ),
    );
  }

  Future<void> _run(Future<String?> Function() call, String ok) async {
    final err = await call();
    if (!mounted) return;
    if (err != null) {
      AppToast.error(context, err);
    } else {
      AppToast.show(context, ok);
    }
  }

  Future<void> _confirmDelete(Session s, SessionsController ctrl) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: 'Delete session?',
      message: 'Removes "${s.displayTitle}" and its transcript. This cannot be undone.',
      confirmLabel: 'Delete',
    );
    if (confirmed) {
      await _run(() => ctrl.hardDelete(s.sessionId), 'Session deleted');
    }
  }

  Future<void> _renameDialog(Session s, SessionsController ctrl) async {
    final field = TextEditingController(text: s.displayTitle);
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Rename session',
        content: AppInput(controller: field, autofocus: true),
        actions: [
          AppButton(
            variant: AppButtonVariant.ghost,
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          AppButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Save')),
        ],
      ),
    );
    if (saved == true && field.text.trim().isNotEmpty) {
      await _run(() => ctrl.rename(s.sessionId, field.text.trim()), 'Session renamed');
    }
    field.dispose();
  }

  Future<void> _workspaceDialog(Session s, SessionsController ctrl) async {
    final field = TextEditingController(text: s.projectPath ?? '');
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Change workspace',
        content: AppInput(controller: field, hint: 'Project path', autofocus: true),
        actions: [
          AppButton(
            variant: AppButtonVariant.ghost,
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          AppButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Save')),
        ],
      ),
    );
    if (saved == true && field.text.trim().isNotEmpty) {
      await _run(() => ctrl.changeWorkspace(s.sessionId, field.text.trim()), 'Workspace changed');
    }
    field.dispose();
  }

  /// New session: pick provider from capabilities (multi-provider prompt,
  /// same as web/mobile), then open the (not-yet-implemented) chat route.
  /// 'Auto (orchestrator)' is a static extra entry (T18.1) — it needs a
  /// concrete projectPath, so it's only offered when one is known.
  Future<void> _newSession() async {
    String provider = 'claude';
    final canOrchestrate = (widget.projectPath ?? '').isNotEmpty;
    try {
      final caps = await ref.read(sessionsRepositoryProvider).capabilities();
      final providers = [
        for (final p
            in (caps['data']?['providers'] ?? caps['providers'] ?? const <dynamic>[]) as List)
          if ((p as Map)['provider'] != null) p['provider'].toString(),
        if (canOrchestrate) 'orchestrator',
      ];
      if (providers.length > 1 && mounted) {
        final picked = await showDialog<String>(
          context: context,
          builder: (ctx) => AppDialog(
            title: 'New session — provider',
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final p in providers)
                  ListTile(
                    title: Text(p == 'orchestrator' ? 'Auto (orchestrator)' : p),
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
    } on AppError {
      // Fall back to the default provider.
    }
    if (!mounted) return;
    if (provider == 'orchestrator' && canOrchestrate) {
      try {
        final sessionId = await createOrchestratorSession(ref, projectPath: widget.projectPath!);
        if (!mounted) return;
        _open(sessionId);
      } on Object catch (e) {
        if (mounted) AppToast.error(context, 'Failed to create session: $e');
      }
      return;
    }
    context.go('/chat/new?projectId=${widget.projectId ?? ''}&provider=$provider');
  }
}

/// Full-text search hit — same flat-row language as [SessionListRow],
/// with the matched snippet as the second line.
class _SearchMatchRow extends StatelessWidget {
  const _SearchMatchRow({
    required this.label,
    required this.snippet,
    required this.onTap,
    this.provider,
  });

  final String label;
  final String snippet;
  final VoidCallback onTap;
  final String? provider;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.borderMd,
        hoverColor: c.accent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
          child: Row(
            spacing: AppSpacing.sm,
            children: [
              SessionProviderBadge(provider: (provider?.isEmpty ?? true) ? null : provider),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 16 / 12,
                        color: c.foreground,
                      ),
                    ),
                    if (snippet.isNotEmpty)
                      Text(
                        snippet,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10, color: c.mutedForeground),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// /recent — recent sessions across projects, infinite scroll (limit 40/page,
/// cap 100 per the API contract).
class RecentScreen extends ConsumerStatefulWidget {
  const RecentScreen({super.key});

  @override
  ConsumerState<RecentScreen> createState() => _RecentScreenState();
}

class _RecentScreenState extends ConsumerState<RecentScreen> {
  final _scroll = ScrollController();
  final List<Session> _sessions = [];
  bool _loading = false;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 200) {
        _load();
      }
    });
    _load();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (_loading || !_hasMore) return;
    setState(() => _loading = true);
    try {
      final page = await ref
          .read(sessionsRepositoryProvider)
          .recent(limit: 40, offset: _sessions.length);
      if (!mounted) return;
      setState(() {
        _sessions.addAll(page.sessions);
        _hasMore = page.hasMore && _sessions.length < 100;
        _loading = false;
        _error = null;
      });
    } on AppError catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.message;
        });
      }
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _sessions.clear();
      _hasMore = true;
    });
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = context.appColors;
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        controller: _scroll,
        padding: const EdgeInsets.all(6),
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SessionListGroupHeading('Recent sessions'),
                  for (final s in _sessions)
                    SessionListRow(
                      session: s,
                      running: s.isRunning,
                      unread: s.isUnread,
                      onTap: () {
                        unawaited(ref.read(sessionsRepositoryProvider).markViewed(s.sessionId));
                        context.go('/chat/${s.sessionId}');
                      },
                    ),
                  if (_loading)
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Text(_error!, style: TextStyle(color: c.destructive)),
                    ),
                  if (!_loading && _sessions.isEmpty && _error == null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'No recent sessions',
                          style: t.textTheme.bodySmall?.copyWith(color: c.mutedForeground),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
