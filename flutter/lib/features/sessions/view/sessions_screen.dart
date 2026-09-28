import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/sse_client.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_card.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/chat/view/chat_utilities.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/sessions_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  CancelToken? _searchCancel;
  List<Map<String, String>> _searchMatches = const [];
  bool _searching = false;

  (String?, String?) get _scope => (widget.projectId, widget.projectPath);

  @override
  void dispose() {
    _searchDebounce?.cancel();
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
              in ref
                  .read(sseClientProvider)
                  .searchSessions(q.trim(), cancelToken: token)) {
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
            if (widget.projectId != null &&
                pid != null &&
                pid != widget.projectId) {
              continue;
            }
            final found = <Map<String, String>>[
              for (final s in (pr['sessions'] as List? ?? const []))
                if ((s as Map)['sessionId'] != null)
                  {
                    'id': s['sessionId'].toString(),
                    'label': (s['sessionSummary'] ?? '').toString(),
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
    final t = Theme.of(context);
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
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppInput(
                    hint: 'Search sessions…',
                    onChanged: (v) {
                      setState(() => _query = v);
                      _onSearchChanged(v);
                    },
                  ),
                ),
                if (_searching)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                IconButton(
                  tooltip: state.showArchived
                      ? 'Hide archived'
                      : 'Show archived',
                  icon: Icon(
                    Icons.archive_outlined,
                    color: state.showArchived ? c.primary : c.mutedForeground,
                  ),
                  onPressed: ctrl.toggleArchived,
                ),
                IconButton(
                  tooltip: 'New session',
                  icon: Icon(Icons.add, color: c.primary),
                  onPressed: _newSession,
                ),
              ],
            ),
          ),
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(state.error!, style: TextStyle(color: c.destructive)),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: ctrl.load,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  for (final s in local)
                    _SessionCard(
                      session: s,
                      pinned: ctrl.isPinned(s.sessionId),
                      onOpen: () => _open(s.sessionId),
                      menu: _sessionMenu(s, ctrl, state.showArchived),
                    ),
                  for (final m in extraMatches)
                    AppCard(
                      onTap: () => _open(m['id']!),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m['label']!.isEmpty ? m['id']! : m['label']!,
                            style: t.textTheme.titleSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (m['snippet']?.isNotEmpty == true)
                            Text(
                              m['snippet']!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: t.textTheme.bodySmall?.copyWith(
                                color: c.mutedForeground,
                              ),
                            ),
                        ],
                      ),
                    ),
                  if (local.isEmpty && extraMatches.isEmpty && !state.loading)
                    Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: Text(
                        'No sessions',
                        textAlign: TextAlign.center,
                        style: t.textTheme.bodyLarge?.copyWith(
                          color: c.mutedForeground,
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

  void _open(String sessionId) {
    unawaited(ref.read(sessionsRepositoryProvider).markViewed(sessionId));
    final params = <String, String>{
      if (widget.projectId != null) 'projectId': widget.projectId!,
      if (widget.projectPath != null) 'projectPath': widget.projectPath!,
    };
    context.go(
      Uri(path: '/chat/$sessionId', queryParameters: params).toString(),
    );
  }

  Widget _sessionMenu(Session s, SessionsController ctrl, bool archived) {
    final entries = archived
        ? <(String, VoidCallback)>[
            (
              'Restore',
              () => _run(() => ctrl.restore(s.sessionId), 'Session restored'),
            ),
            ('Delete permanently', () => _confirmDelete(s, ctrl)),
          ]
        : <(String, VoidCallback)>[
            ('Rename', () => unawaited(_renameDialog(s, ctrl))),
            ('Change workspace', () => unawaited(_workspaceDialog(s, ctrl))),
            (
              ctrl.isPinned(s.sessionId) ? 'Unpin session' : 'Pin session',
              () {
                final pinned = ctrl.togglePin(s.sessionId);
                AppToast.show(
                  context,
                  pinned ? 'Session pinned' : 'Session unpinned',
                );
                setState(() {});
              },
            ),
            ('Compare with…', () => unawaited(_compareDialog(s))),
            (
              'Archive',
              () => _run(() => ctrl.archive(s.sessionId), 'Session archived'),
            ),
            ('Delete permanently', () => _confirmDelete(s, ctrl)),
          ];
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert, size: 18),
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
            (other.summary?.isNotEmpty ?? false)
                ? other.summary!
                : other.sessionId,
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
      message:
          'Removes "${s.displayTitle}" and its transcript. This cannot be undone.',
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
          AppButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (saved == true && field.text.trim().isNotEmpty) {
      await _run(
        () => ctrl.rename(s.sessionId, field.text.trim()),
        'Session renamed',
      );
    }
    field.dispose();
  }

  Future<void> _workspaceDialog(Session s, SessionsController ctrl) async {
    final field = TextEditingController(text: s.projectPath ?? '');
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Change workspace',
        content: AppInput(
          controller: field,
          hint: 'Project path',
          autofocus: true,
        ),
        actions: [
          AppButton(
            variant: AppButtonVariant.ghost,
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          AppButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (saved == true && field.text.trim().isNotEmpty) {
      await _run(
        () => ctrl.changeWorkspace(s.sessionId, field.text.trim()),
        'Workspace changed',
      );
    }
    field.dispose();
  }

  /// New session: pick provider from capabilities (multi-provider prompt,
  /// same as web/mobile), then open the (not-yet-implemented) chat route.
  Future<void> _newSession() async {
    String provider = 'claude';
    try {
      final caps = await ref.read(sessionsRepositoryProvider).capabilities();
      final providers = [
        for (final p
            in (caps['data']?['providers'] ??
                    caps['providers'] ??
                    const <dynamic>[])
                as List)
          if ((p as Map)['provider'] != null) p['provider'].toString(),
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
                    title: Text(p),
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
    context.go(
      '/chat/new?projectId=${widget.projectId ?? ''}&provider=$provider',
    );
  }
}

/// One session row — provider icon/label, message count, running + unread
/// dots, pin, updated timestamp.
class _SessionCard extends StatelessWidget {
  const _SessionCard({
    required this.session,
    required this.pinned,
    required this.onOpen,
    required this.menu,
  });

  final Session session;
  final bool pinned;
  final VoidCallback onOpen;
  final Widget menu;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = context.appColors;
    final s = session;
    final subtitle = [
      if (s.provider != null) s.provider,
      if (s.updatedAt != null)
        DateTime.tryParse(s.updatedAt!)?.toLocal().toString().substring(0, 16),
    ].join(' · ');
    return AppCard(
      onTap: onOpen,
      child: Row(
        children: [
          Icon(Icons.chat_bubble_outline, size: 18, color: c.mutedForeground),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.displayTitle,
                  style: t.textTheme.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: t.textTheme.bodySmall?.copyWith(
                    color: c.mutedForeground,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (s.messageCount > 0)
            Text(
              '${s.messageCount}',
              style: t.textTheme.bodySmall?.copyWith(color: c.mutedForeground),
            ),
          if (pinned) Icon(Icons.push_pin, size: 14, color: c.primary),
          if (s.isRunning)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(left: AppSpacing.xs),
              decoration: BoxDecoration(
                color: c.primary,
                shape: BoxShape.circle,
              ),
            ),
          if (s.isUnread)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(left: AppSpacing.xs),
              decoration: const BoxDecoration(
                color: Color(0xFF0EA5E9),
                shape: BoxShape.circle,
              ),
            ),
          menu,
        ],
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
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          for (final s in _sessions)
            _SessionCard(
              session: s,
              pinned: false,
              onOpen: () {
                unawaited(
                  ref.read(sessionsRepositoryProvider).markViewed(s.sessionId),
                );
                context.go('/chat/${s.sessionId}');
              },
              menu: const SizedBox.shrink(),
            ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(_error!, style: TextStyle(color: c.destructive)),
            ),
          if (!_loading && _sessions.isEmpty && _error == null)
            Padding(
              padding: const EdgeInsets.only(top: 48),
              child: Text(
                'No recent sessions',
                textAlign: TextAlign.center,
                style: t.textTheme.bodyLarge?.copyWith(
                  color: c.mutedForeground,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
