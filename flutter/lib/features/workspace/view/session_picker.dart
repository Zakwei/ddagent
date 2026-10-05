import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/provider_accounts/data/provider_accounts_repository.dart';
import 'package:ddagent_app/features/quota/data/quota_models.dart';
import 'package:ddagent_app/features/quota/data/quota_repository.dart';
import 'package:ddagent_app/features/quota/view/quota_tone.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/sessions_controller.dart';
import 'package:ddagent_app/features/sessions/view/session_list_row.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/view/draft_extras.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
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
    this.projectId,
    this.onSelectWorkspace,
  });

  final Set<String> openSessionIds;
  final Set<String> processingSessionIds;
  final void Function(Session session) onSelectSession;

  /// "+ New chat" — creates a session. The dialog picks the provider and,
  /// when multi-account is configured, a specific [accountId].
  final void Function(String provider, {String? accountId}) onNewChat;
  final bool canCancel;
  final VoidCallback? onCancel;

  /// Offers 'Auto (orchestrator)' in the provider dialog (T18.1) — only when
  /// the pane's project resolves to a concrete path.
  final bool allowOrchestrator;

  /// Pane's project — drives the `Current project` group in the list.
  final String? projectId;

  /// Workspace-card callback — rebinds the session-less pane to another
  /// project (web `ProviderSelectionEmptyState.onSelectWorkspace`).
  final void Function(String projectId)? onSelectWorkspace;

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

  /// `draftPrompt` (NextTaskBanner "Start Task") — stash
  /// `/task-master start <id>` so the new session's composer prefills it
  /// like the web's `setInput` on the draft composer.
  Future<void> _pickProviderAndCreate({String? draftPrompt}) async {
    var provider = 'claude';
    String? accountId;
    try {
      final caps = await ref.read(sessionsRepositoryProvider).capabilities();
      final providers = [
        for (final p
            in (caps['data']?['providers'] ?? caps['providers'] ?? const <dynamic>[]) as List)
          if ((p as Map)['provider'] != null) p['provider'].toString(),
        if (widget.allowOrchestrator) 'orchestrator',
      ];
      // Grouped picker (provider → accounts). Returns null when no accounts
      // are configured or the accounts API is unavailable, in which case we
      // keep the original flat provider list.
      final groups = await _providerAccountGroups(providers);
      if (groups != null && mounted) {
        final options = groups.fold<int>(
          0,
          (n, g) => n + (g.choices.isEmpty ? 1 : g.choices.length),
        );
        if (options <= 1) {
          // A lone provider/account needs no dialog — pin it directly.
          final sole = groups.firstWhere((g) => g.choices.isNotEmpty, orElse: () => groups.first);
          provider = sole.provider;
          accountId = sole.choices.isEmpty ? null : sole.choices.first.accountId;
        } else {
          final picked = await showDialog<_ProviderPick>(
            context: context,
            builder: (ctx) => AppDialog(
              title: Translations.of(ctx).workspace.newChatProvider,
              content: _providerDialogBody(ctx, groups),
            ),
          );
          if (picked == null) return;
          provider = picked.provider;
          accountId = picked.accountId;
        }
      } else if (providers.length > 1 && mounted) {
        final picked = await showDialog<String>(
          context: context,
          builder: (ctx) => AppDialog(
            title: Translations.of(ctx).workspace.newChatProvider,
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
    } on Object {
      // Fall back to the default provider.
    }
    final pid = widget.projectId;
    if (draftPrompt != null && pid != null) {
      ChatStorage.stashRunTask(pid, draftPrompt);
      unawaited(ChatStorage.writeDraft(ChatStorage.draftKey(projectId: pid), draftPrompt));
    }
    widget.onNewChat(provider, accountId: accountId);
  }

  /// Fetches `/api/provider-accounts`, groups the rows by provider and
  /// resolves each account's quota health from the `/api/quota` snapshot
  /// (worst window percentage vs the configured thresholds). Returns null
  /// when no accounts are configured or the accounts call fails so the caller
  /// falls back to the flat provider list.
  Future<List<_ProviderGroup>?> _providerAccountGroups(List<String> providers) async {
    final i18n = Translations.of(context);
    List<ProviderAccount> accounts;
    try {
      accounts = await ref.read(providerAccountsRepositoryProvider).list();
    } on Object {
      return null;
    }
    if (accounts.isEmpty) return null;

    var quotaById = const <String, QuotaAccount>{};
    var watch = 75.0;
    var danger = 90.0;
    try {
      final snap = QuotaSnapshot.fromJson(await ref.read(quotaRepositoryProvider).snapshot());
      quotaById = {for (final a in snap.accounts) a.id: a};
      if (snap.overview.watchThreshold > 0) watch = snap.overview.watchThreshold;
      if (snap.overview.dangerThreshold > 0) danger = snap.overview.dangerThreshold;
    } on Object {
      // Quota colours are best-effort — the dialog still lists the accounts.
    }

    QuotaTone toneForQuota(QuotaAccount? qa) {
      if (qa == null || qa.status == 'error') return QuotaTone.neutral;
      final worst = qa.windows.fold<double>(0, (m, w) => w.percent > m ? w.percent : m);
      return toneForPercent(worst, watch, danger);
    }

    /// The ambient (unpinned) credential — sessions that pin no account run
    /// under it. Antigravity's quota adapter reports ambient under 'gemini'.
    QuotaAccount? ambientQuota(String provider) =>
        quotaById[provider == 'antigravity' ? 'gemini' : provider];

    _AccountChoice ambientChoice(String provider) {
      final qa = ambientQuota(provider);
      final label = qa?.accountLabel ?? '';
      return _AccountChoice(
        accountId: null,
        label: label.isEmpty
            ? i18n.chat.composer.accountIsDefault
            : i18n.workspace.accountWithLabel(label: label),
        tone: toneForQuota(qa),
      );
    }

    final byProvider = <String, List<ProviderAccount>>{};
    for (final a in accounts) {
      final p = a.provider ?? '';
      if (p.isEmpty) continue;
      byProvider.putIfAbsent(p, () => []).add(a);
    }

    // Capabilities order first, then any provider the accounts call surfaced
    // that capabilities didn't list.
    final ordered = <String>[
      ...providers,
      for (final p in byProvider.keys)
        if (!providers.contains(p)) p,
    ];

    final groups = [
      for (final p in ordered)
        _ProviderGroup(
          provider: p,
          choices: [
            // Providers with named accounts also offer the ambient default —
            // without it the unpinned login can't be picked at all.
            if ((byProvider[p] ?? const <ProviderAccount>[]).isNotEmpty) ambientChoice(p),
            for (final a in byProvider[p] ?? const <ProviderAccount>[])
              _AccountChoice(
                accountId: a.id,
                label: (a.label ?? '').isNotEmpty ? a.label! : a.id,
                tone: toneForQuota(quotaById[a.id]),
              ),
          ],
        ),
    ];
    return groups.isEmpty ? null : groups;
  }

  Widget _providerDialogBody(BuildContext ctx, List<_ProviderGroup> groups) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360, maxHeight: 420),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final g in groups)
              if (g.choices.isEmpty)
                ListTile(
                  dense: true,
                  title: Text(_providerLabel(g.provider)),
                  onTap: () => Navigator.of(ctx).pop(_ProviderPick(g.provider, null)),
                )
              else ...[
                _providerGroupHeader(ctx, g.provider),
                for (final choice in g.choices) _accountRow(ctx, g.provider, choice),
              ],
          ],
        ),
      ),
    );
  }

  Widget _providerGroupHeader(BuildContext ctx, String provider) {
    final c = ctx.appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, 2),
      child: Text(
        _providerLabel(provider),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: c.mutedForeground),
      ),
    );
  }

  Widget _accountRow(BuildContext ctx, String provider, _AccountChoice choice) {
    final c = ctx.appColors;
    return InkWell(
      onTap: () => Navigator.of(ctx).pop(_ProviderPick(provider, choice.accountId)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 8),
        child: Row(
          spacing: AppSpacing.xs,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(shape: BoxShape.circle, color: quotaToneColor(choice.tone)),
            ),
            Expanded(
              child: Text(
                choice.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: c.foreground),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _providerLabel(String provider) =>
      provider == 'orchestrator' ? 'Auto (orchestrator)' : provider;

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
            // React filterPickerSessions: title + project name.
            (q.isEmpty ||
                s.displayTitle.toLowerCase().contains(q) ||
                _sessionProjectName(s).toLowerCase().contains(q)))
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
    final i18n = Translations.of(context);
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
              // Tailwind sm: — the Archived label hides on narrow panes.
              final compact = box.maxWidth < 640;
              return Row(
                spacing: 6,
                children: [
                  Expanded(
                    child: SessionSearchField(
                      // React calls searchInputRef.focus() whenever the pane
                      // is active — the blue focus ring is part of the look.
                      autofocus: true,
                      onChanged: (v) => setState(() => _query = v),
                      onEscape: widget.canCancel ? widget.onCancel : null,
                    ),
                  ),
                  SessionListToolbarButton(
                    icon: LucideIcons.archive,
                    label: i18n.chat.sessionPicker.archivedToggle,
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
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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

  /// Project the pane is bound to — `null` for a fresh, unbound picker.
  String? get _projectId => widget.projectId;

  /// `projectId` from the raw API row, else resolved through the path.
  String? _sessionProjectId(Session s) {
    final id = s.raw['projectId']?.toString();
    if (id != null && id.isNotEmpty) return id;
    final path = s.projectPath;
    if (path == null || path.isEmpty) return null;
    for (final p in ref.read(projectsProvider).projects) {
      if (p.path == path || p.fullPath == path) return p.projectId;
    }
    return null;
  }

  /// `session.projectName` equivalent — display name of the owning project
  /// (React candidates carry it from the projects feed).
  String _sessionProjectName(Session s) {
    final raw = s.raw['projectDisplayName'] ?? s.raw['projectName'];
    if (raw is String && raw.isNotEmpty) return raw;
    final pid = _sessionProjectId(s);
    if (pid != null) {
      for (final p in ref.read(projectsProvider).projects) {
        if (p.projectId == pid) {
          return p.displayName.isNotEmpty ? p.displayName : p.path;
        }
      }
    }
    final path = s.projectPath;
    if (path != null && path.isNotEmpty) {
      final segs = path.split(RegExp(r'[\\/]'))..removeWhere((e) => e.isEmpty);
      if (segs.isNotEmpty) return segs.last;
    }
    return '';
  }

  String _currentProjectName([String? pid]) {
    pid ??= _projectId;
    if (pid == null) return '';
    for (final p in ref.read(projectsProvider).projects) {
      if (p.projectId == pid) {
        return p.displayName.isNotEmpty ? p.displayName : p.path;
      }
    }
    return '';
  }

  Widget _sessionList(AppColors c, List<Session> sessions, bool loading, SessionsController ctrl) {
    final hasQuery = _query.trim().isNotEmpty;
    // Port of resolvedCurrentProjectId (splitSessionUtils.ts): the pane's
    // project wins when it contributes candidates; when it doesn't (fresh,
    // unbound picker) a lone contributing project stands in — otherwise no
    // session is "current" and everything lists under `Recent sessions`.
    final contributing = {
      for (final s in sessions)
        if (_sessionProjectId(s) != null) _sessionProjectId(s)!,
    };
    final pid = _projectId;
    final resolvedPid = pid != null && contributing.contains(pid)
        ? pid
        : contributing.length == 1
        ? contributing.single
        : null;
    final currentProject = resolvedPid == null
        ? const <Session>[]
        : [
            for (final s in sessions)
              if (_sessionProjectId(s) == resolvedPid) s,
          ];
    final currentIds = {for (final s in currentProject) s.sessionId};
    final otherProjects = [
      for (final s in sessions)
        if (!currentIds.contains(s.sessionId)) s,
    ];
    return ListView(
      padding: const EdgeInsets.all(6),
      children: [
        _newChatRow(),
        // `ProviderSelectionEmptyState` extras (T55) — workspace card and the
        // next-task banner above the session list on panes
        // that aren't the picker overlay of a live session.
        if (widget.canCancel == false)
          _constrained(
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: DraftExtras(
                projectId: widget.projectId,
                onSelectWorkspace: widget.onSelectWorkspace,
                onStartTask: (task) => unawaited(
                  _pickProviderAndCreate(draftPrompt: '/task-master start ${task.idText}'),
                ),
              ),
            ),
          ),
        if (sessions.isEmpty)
          _constrained(
            SessionListEmptyState(
              icon: hasQuery ? LucideIcons.search : LucideIcons.messageSquarePlus,
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
                // `Current project (name)` / `Other projects` — the old
                // picker splits the candidates once a project is bound
                // (groupPickerSessions + SessionPicker.tsx:707).
                if (currentProject.isNotEmpty) ...[
                  SessionListGroupHeading('Current project (${_currentProjectName(resolvedPid)})'),
                  for (final s in currentProject) _sessionRow(c, s, ctrl),
                ],
                if (otherProjects.isNotEmpty) ...[
                  SessionListGroupHeading(
                    currentProject.isEmpty ? 'Recent sessions' : 'Other projects',
                  ),
                  for (final s in otherProjects) _sessionRow(c, s, ctrl),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _sessionRow(AppColors c, Session s, SessionsController ctrl) {
    final i18n = Translations.of(context);
    return SessionListRow(
      session: s,
      running: widget.processingSessionIds.contains(s.sessionId) || s.isRunning,
      unread: s.isUnread,
      onTap: () => widget.onSelectSession(s),
      // sm+ panes get the hover-revealed inline buttons (EyeOff / Trash2);
      // the ⋯ menu below only survives on narrow (touch) panes.
      actions: [
        SessionRowIconButton(
          icon: LucideIcons.eyeOff,
          tooltip: i18n.sidebar.deleteConfirmation.archiveSession,
          onTap: () => unawaited(_sessionAction('archive', s, ctrl)),
        ),
        SessionRowIconButton(
          icon: LucideIcons.trash2,
          tooltip: i18n.sidebar.deleteConfirmation.deleteSessionPermanently,
          danger: true,
          onTap: () => unawaited(_sessionAction('delete', s, ctrl)),
        ),
      ],
      menu: PopupMenuButton<String>(
        tooltip: i18n.sidebar.sessions.options,
        style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        onSelected: (v) => unawaited(_sessionAction(v, s, ctrl)),
        itemBuilder: (_) => [
          PopupMenuItem(value: 'archive', child: Text(i18n.sidebar.search.archiveOnly)),
          PopupMenuItem(
            value: 'delete',
            child: Text(i18n.sidebar.deleteConfirmation.deleteSessionPermanently),
          ),
        ],
        child: SizedBox(
          width: 28,
          height: 28,
          child: Icon(LucideIcons.moreHorizontal, size: 14, color: c.mutedForeground),
        ),
      ),
    );
  }

  // ─── Archived view ──────────────────────────────────────────────────────

  /// React keeps the dashed "+ New chat" row visible above the archived
  /// groups too — it lives in the scroll area ahead of the body switch.
  Widget _newChatRow() => _constrained(
    Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: SessionNewChatButton(onTap: _pickProviderAndCreate),
    ),
  );

  Widget _archivedBody(AppColors c) {
    final i18n = Translations.of(context);
    if (_loadingArchived) {
      return ListView(
        padding: const EdgeInsets.all(6),
        children: [
          _newChatRow(),
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
          _newChatRow(),
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
                    child: Text(
                      i18n.chat.session.messages.retry,
                      style: const TextStyle(fontSize: 12),
                    ),
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
          _newChatRow(),
          _constrained(
            SessionListEmptyState(
              icon: LucideIcons.archive,
              label: i18n.chat.sessionPicker.archivedEmpty,
            ),
          ),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.all(6),
      children: [
        _newChatRow(),
        _constrained(Column(children: [for (final g in groups) _archivedGroup(c, g)])),
      ],
    );
  }

  /// Groups archived sessions under their project, newest activity first
  /// (port of groupArchivedPickerSessions); archived projects without
  /// sessions are appended as empty groups so the workspace can be restored.
  List<_ArchivedGroup> _archivedGroups() {
    final q = _query.trim().toLowerCase();
    bool match(String? v) => q.isEmpty || (v != null && v.toLowerCase().contains(q));

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
      if (la != null && (g.latestActivity == null || la.compareTo(g.latestActivity!) > 0)) {
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
    return groups.values.toList()
      ..sort((a, b) => (b.latestActivity ?? '').compareTo(a.latestActivity ?? ''));
  }

  String _archivedTitle(Session s) {
    final t = (s.raw['sessionTitle'] as String?)?.trim();
    return (t != null && t.isNotEmpty) ? t : s.displayTitle;
  }

  String _archivedProjectName(Session s) {
    final i18n = Translations.of(context);
    final n = s.raw['projectDisplayName'] as String?;
    if (n != null && n.isNotEmpty) return n;
    final path = s.projectPath;
    if (path != null && path.isNotEmpty) {
      final segs = path.split(RegExp(r'[\\/]'))..removeWhere((e) => e.isEmpty);
      if (segs.isNotEmpty) return segs.last;
    }
    return s.projectId ?? i18n.workspace.archivedWorkspaceName;
  }

  Widget _archivedGroup(AppColors c, _ArchivedGroup g) {
    final i18n = Translations.of(context);
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
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
            decoration: BoxDecoration(
              color: c.muted.withValues(alpha: 0.3),
              border: Border(bottom: BorderSide(color: c.border.withValues(alpha: 0.5))),
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
                    label: i18n.chat.sessionPicker.restoreProject,
                    busy: _busyProjectId == g.projectId,
                    onTap: () => unawaited(_restoreProject(g.projectId!)),
                  ),
              ],
            ),
          ),
          if (g.sessions.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
              child: Text(
                'Workspace archived — restore it to see its sessions.',
                style: TextStyle(fontSize: 10, color: c.mutedForeground),
              ),
            )
          else
            for (var i = 0; i < g.sessions.length; i++)
              _archivedRow(c, g.sessions[i], isLast: i == g.sessions.length - 1),
        ],
      ),
    );
  }

  Widget _archivedRow(AppColors c, Session s, {required bool isLast}) {
    final i18n = Translations.of(context);
    final age = formatSessionAge(s.lastActivity, DateTime.now());
    final meta = [if (age.isNotEmpty) age, if (s.messageCount > 0) '${s.messageCount}'].join(' · ');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: c.border.withValues(alpha: 0.35))),
      ),
      child: Row(
        spacing: AppSpacing.sm,
        children: [
          SessionProviderBadge(provider: s.provider),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _archivedTitle(s),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, height: 16 / 12, color: c.foreground),
                ),
                // React archived meta row carries mt-0.5 above the line.
                if (meta.isNotEmpty) const SizedBox(height: 2),
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
            label: i18n.chat.sessionPicker.restore,
            busy: _busySessionId == s.sessionId,
            onTap: () => unawaited(_restore(s)),
          ),
          SessionRowIconButton(
            icon: LucideIcons.trash2,
            tooltip: i18n.sidebar.deleteConfirmation.deleteSessionPermanently,
            danger: true,
            onTap: () => unawaited(_delete(s, refreshArchived: true)),
          ),
        ],
      ),
    );
  }

  // ─── Actions ────────────────────────────────────────────────────────────

  Future<void> _sessionAction(String action, Session s, SessionsController ctrl) async {
    if (action == 'archive') {
      final err = await ctrl.archive(s.sessionId);
      if (!mounted) return;
      final i18n = Translations.of(context);
      if (err != null) {
        AppToast.error(context, err);
      } else {
        AppToast.show(context, i18n.sessions.toasts.archived);
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
      AppToast.show(context, Translations.of(context).sessions.toasts.restored);
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
      AppToast.show(context, Translations.of(context).workspace.restored);
      unawaited(_loadArchived());
    } on Object catch (e) {
      if (mounted) AppToast.error(context, '$e');
    } finally {
      if (mounted) setState(() => _busyProjectId = null);
    }
  }

  Future<void> _delete(Session s, {bool refreshArchived = false}) async {
    final i18n = Translations.of(context);
    final ok = await AppDialog.confirm(
      context,
      title: i18n.common.browserUse.deleteSession,
      message:
          'Removes "${s.displayTitle}" and its transcript. '
          'This cannot be undone.',
      confirmLabel: 'Delete',
    );
    if (!ok) return;
    try {
      await ref.read(sessionsRepositoryProvider).delete(s.sessionId, hardDelete: true);
      if (!mounted) return;
      AppToast.show(context, i18n.sessions.toasts.deleted);
      if (refreshArchived) {
        unawaited(_loadArchived());
      }
      unawaited(ref.read(sessionsProvider(_globalScope).notifier).load());
    } on Object catch (e) {
      if (mounted) AppToast.error(context, '$e');
    }
  }
}

/// One provider in the account picker dialog. [choices] is empty when the
/// provider has no named accounts (or is the orchestrator) — the provider then
/// renders as a single selectable row.
class _ProviderGroup {
  const _ProviderGroup({required this.provider, required this.choices});

  final String provider;
  final List<_AccountChoice> choices;
}

/// One selectable account row — [accountId] is null when no account is pinned.
class _AccountChoice {
  const _AccountChoice({required this.accountId, required this.label, required this.tone});

  final String? accountId;
  final String label;
  final QuotaTone tone;
}

/// The dialog result: a provider plus the optional pinned account.
class _ProviderPick {
  const _ProviderPick(this.provider, this.accountId);

  final String provider;
  final String? accountId;
}

/// One archived-project group (port of PickerArchivedGroup).
class _ArchivedGroup {
  _ArchivedGroup({required this.projectId, required this.name, required this.isProjectArchived});

  final String? projectId;
  final String name;
  final bool isProjectArchived;
  String? latestActivity;
  final List<Session> sessions = [];
}

/// Small icon + label button used by the archived view's Restore actions
/// (React restoreButtonClass: h-6 px-1.5 text-[10px], hover emerald).
class _RestoreButton extends StatefulWidget {
  const _RestoreButton({required this.label, required this.onTap, this.busy = false});

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
                    child: CircularProgressIndicator(strokeWidth: 1.5, color: fg),
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
