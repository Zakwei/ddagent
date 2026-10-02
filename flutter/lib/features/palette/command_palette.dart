import 'dart:async';

import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/sse_client.dart';
import 'package:ddagent_app/core/theme/theme_controller.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/utils/model_pricing.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_repository.dart';
import 'package:ddagent_app/features/git/data/git_models.dart';
import 'package:ddagent_app/features/git/data/git_repository.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/settings/view/settings_screen.dart';
import 'package:ddagent_app/features/taskmaster/state/tasks_settings_controller.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/state/workspace_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Ctrl/Cmd+Shift+K command palette — port of
/// `src/components/command-palette/CommandPalette.tsx`.
Future<void> showCommandPalette(BuildContext context) =>
    showDialog<void>(context: context, builder: (_) => const CommandPaletteDialog());

enum _PalettePage { actions, files, sessions, commits, branches, compare }

class _SessionRow {
  const _SessionRow({
    required this.id,
    required this.label,
    this.provider,
    this.snippet,
    this.projectId,
  });

  final String id;
  final String label;
  final String? provider;
  final String? snippet;
  final String? projectId;
}

class _FlatFile {
  const _FlatFile(this.name, this.path);
  final String name;
  final String path;
}

class _Item {
  const _Item({
    required this.id,
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    this.keywords = '',
    this.enabled = true,
    this.disabledHint,
    required this.onSelect,
  });

  final String id;
  final IconData icon;
  final String label;
  final String? subtitle;
  final String? trailing;
  final String keywords;
  final bool enabled;
  final String? disabledHint;
  final void Function() onSelect;

  bool matches(String query) {
    if (query.isEmpty) return true;
    final hay = '$label ${subtitle ?? ''} $keywords'.toLowerCase();
    return hay.contains(query);
  }
}

class _Group {
  const _Group(this.heading, this.items);
  final String heading;
  final List<_Item> items;
}

/// Token/cost snapshot for the compare page — mirrors the web panel's
/// `SessionUsage` (token-usage + active-model + client-side cost estimate).
class _SessionUsage {
  const _SessionUsage({
    this.used,
    this.input,
    this.output,
    this.model,
    this.costUsd,
    this.unsupported = false,
  });

  final num? used;
  final num? input;
  final num? output;
  final String? model;
  final double? costUsd;
  final bool unsupported;
}

class CommandPaletteDialog extends ConsumerStatefulWidget {
  const CommandPaletteDialog({super.key});

  @override
  ConsumerState<CommandPaletteDialog> createState() => _CommandPaletteDialogState();
}

class _CommandPaletteDialogState extends ConsumerState<CommandPaletteDialog> {
  static const _browseLimit = 5;
  static const _minSearchQuery = 2;
  static const _searchDebounce = Duration(milliseconds: 250);
  static const _maxFiles = 500;

  final _searchCtl = TextEditingController();
  final _inputFocus = FocusNode();
  final _listCtl = ScrollController();
  String _search = '';
  final List<_PalettePage> _pages = [];
  final List<String?> _compare = [null, null];
  int _selected = 0;
  final Map<String, GlobalObjectKey> _itemKeys = {};

  // Lazily fetched sources (web `enabled` flags) — null until needed.
  List<_SessionRow>? _sessions;
  List<_FlatFile>? _files;
  List<GitCommit>? _commits;
  List<String>? _branches;
  final List<_SessionRow> _messageMatches = [];
  Timer? _msgDebounce;
  CancelToken? _msgCancel;
  StreamSubscription<SseEvent>? _msgSub;
  final Map<int, _SessionUsage?> _usage = {};

  _PalettePage? get _page => _pages.isEmpty ? null : _pages.last;

  String? get _projectId =>
      ref.read(workspaceProvider).lastUsedProjectId ??
      ref.read(projectsProvider).projects.firstOrNull?.projectId;

  bool get _showActions => _page == null || _page == _PalettePage.actions;
  bool get _showSessions =>
      _page == null || _page == _PalettePage.sessions || _page == _PalettePage.compare;
  bool get _showFiles => _page == null || _page == _PalettePage.files;
  bool get _showCommits => _page == null || _page == _PalettePage.commits;
  bool get _showBranches =>
      _page == null || _page == _PalettePage.branches || _page == _PalettePage.actions;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _inputFocus.requestFocus());
  }

  @override
  void dispose() {
    _msgDebounce?.cancel();
    _msgCancel?.cancel();
    _msgSub?.cancel();
    _searchCtl.dispose();
    _inputFocus.dispose();
    _listCtl.dispose();
    super.dispose();
  }

  // ─── Sources ─────────────────────────────────────────────────────────────

  final Set<String> _requested = {};

  void _ensureLoaded() {
    final projectId = _projectId;
    if (projectId == null) return;
    void once(String key, Future<void> Function() load) {
      if (_requested.add(key)) unawaited(load());
    }

    if (_showSessions) once('sessions', _loadSessions);
    if (_showFiles) once('files', _loadFiles);
    if (_showCommits) once('commits', _loadCommits);
    if (_showBranches) once('branches', _loadBranches);
  }

  Future<void> _loadSessions() async {
    try {
      final page = await ref.read(projectsRepositoryProvider).sessions(_projectId!, limit: 200);
      if (!mounted) return;
      setState(() {
        _sessions = [
          for (final s in page.sessions)
            _SessionRow(
              id: (s['id'] ?? '').toString(),
              label: (s['title'] ?? s['summary'] ?? s['name'] ?? s['id'] ?? '').toString(),
              provider: (s['__provider'] ?? s['provider'])?.toString(),
              projectId: _projectId,
            ),
        ];
      });
    } on Object {
      if (mounted) setState(() => _sessions = const []);
    }
  }

  Future<void> _loadFiles() async {
    try {
      final nodes = await ref.read(fileTreeRepositoryProvider).listFiles(_projectId!);
      final flat = <_FlatFile>[];
      void walk(List<FileTreeNode> list) {
        for (final n in list) {
          if (flat.length >= _maxFiles) return;
          if (n.isDirectory) {
            walk(n.children);
          } else {
            flat.add(_FlatFile(n.name, n.path));
          }
        }
      }

      walk(nodes);
      if (mounted) setState(() => _files = flat);
    } on Object {
      if (mounted) setState(() => _files = const []);
    }
  }

  Future<void> _loadCommits() async {
    try {
      final res = await ref.read(gitRepositoryProvider).commits(_projectId!, limit: 50);
      final list = res['commits'] as List? ?? const [];
      if (mounted) {
        setState(
          () => _commits = [
            for (final c in list) GitCommit.fromJson(Map<String, dynamic>.from(c as Map)),
          ],
        );
      }
    } on Object {
      if (mounted) setState(() => _commits = const []);
    }
  }

  Future<void> _loadBranches() async {
    try {
      final res = await ref.read(gitRepositoryProvider).branches(_projectId!);
      final list = res['branches'] as List? ?? res['local'] as List? ?? const [];
      if (mounted) {
        setState(() => _branches = [for (final b in list) b.toString()]);
      }
    } on Object {
      if (mounted) setState(() => _branches = const []);
    }
  }

  /// Session-message matches via GET /api/providers/search/sessions SSE —
  /// port of `useSessionMessageSearch` (debounce, min 2 chars, 'result'
  /// events filtered to the selected project).
  void _searchMessages(String query) {
    _msgDebounce?.cancel();
    _msgCancel?.cancel();
    _msgSub?.cancel();
    _msgSub = null;
    final projectId = _projectId;
    final trimmed = query.trim();
    if (trimmed.length < _minSearchQuery || projectId == null) {
      if (_messageMatches.isNotEmpty) {
        setState(() => _messageMatches.clear());
      }
      return;
    }
    _msgDebounce = Timer(_searchDebounce, () {
      _msgCancel = CancelToken();
      final accumulated = <_SessionRow>[];
      _msgSub = ref
          .read(sseClientProvider)
          .searchSessions(trimmed, cancelToken: _msgCancel)
          .listen(
            (event) {
              if (event.event != 'result' || !mounted) return;
              final pr = event.data['projectResult'];
              if (pr is! Map || pr['projectId'] != projectId) return;
              for (final s in pr['sessions'] as List? ?? const []) {
                final m = s as Map;
                final matches = m['matches'] as List? ?? const [];
                accumulated.add(
                  _SessionRow(
                    id: (m['sessionId'] ?? '').toString(),
                    label: (m['sessionSummary'] ?? m['sessionId'] ?? '').toString(),
                    provider: m['provider']?.toString(),
                    snippet: matches.isEmpty ? '' : (matches.first['snippet'] ?? '').toString(),
                    projectId: pr['projectId']?.toString(),
                  ),
                );
              }
              if (mounted) {
                setState(
                  () => _messageMatches
                    ..clear()
                    ..addAll(accumulated),
                );
              }
            },
            onDone: () => _msgSub = null,
            onError: (_) => _msgSub = null,
          );
    });
  }

  Future<void> _loadUsage(int side) async {
    final row = _sessionById(_compare[side]);
    if (row == null) return;
    try {
      final repo = ref.read(sessionsRepositoryProvider);
      Map<String, dynamic>? usage;
      Map<String, dynamic>? modelRes;
      try {
        usage = await repo.tokenUsage(row.id);
      } on Object {
        usage = null;
      }
      if (row.provider != null) {
        try {
          modelRes = await repo.activeModel(row.provider!, row.id);
        } on Object {
          modelRes = null;
        }
      }
      if (!mounted || _compare[side] != row.id) return;

      num? used;
      num? input;
      num? output;
      var unsupported = false;
      final data = usage?['data'];
      if (data is Map) {
        unsupported = data['unsupported'] == true;
        input = _num(data['breakdown']?['input'] ?? data['inputTokens']);
        output = _num(data['breakdown']?['output'] ?? data['outputTokens']);
        used =
            _num(data['used']) ?? ((input ?? output) != null ? (input ?? 0) + (output ?? 0) : null);
      }
      String? model;
      final mdata = modelRes?['data'];
      if (mdata is Map && (mdata['model']?.toString().trim() ?? '') != '') {
        model = mdata['model'].toString().trim();
      }
      setState(() {
        _usage[side] = _SessionUsage(
          used: used,
          input: input,
          output: output,
          model: model,
          unsupported: unsupported,
          costUsd: estimateCostUsd(
            model: model,
            inputTokens: input ?? 0,
            outputTokens: output ?? 0,
          ),
        );
      });
    } on Object {
      if (mounted && _compare[side] == row.id) {
        setState(() => _usage[side] = const _SessionUsage());
      }
    }
  }

  static num? _num(dynamic v) => v is num ? v : num.tryParse(v?.toString() ?? '');

  _SessionRow? _sessionById(String? id) => _sessionRows.where((s) => s.id == id).firstOrNull;

  /// Sessions merged with message-content matches — web `sessionRows`.
  List<_SessionRow> get _sessionRows {
    if (!_showSessions) return const [];
    final byId = <String, _SessionRow>{for (final s in _sessions ?? const <_SessionRow>[]) s.id: s};
    for (final m in _messageMatches) {
      final existing = byId[m.id];
      byId[m.id] = _SessionRow(
        id: m.id,
        label: existing?.label ?? m.label,
        provider: existing?.provider ?? m.provider,
        snippet: existing?.snippet ?? m.snippet,
        projectId: existing?.projectId ?? m.projectId,
      );
    }
    return byId.values.toList();
  }

  // ─── Actions ─────────────────────────────────────────────────────────────

  void _run(void Function() fn) {
    Navigator.of(context).pop();
    fn();
  }

  void _resetList() {
    _search = '';
    _searchCtl.clear();
    _selected = 0;
    if (_listCtl.hasClients) _listCtl.jumpTo(0);
  }

  void _pushPage(_PalettePage page) => setState(() {
    _resetList();
    _pages.add(page);
    _ensureLoaded();
  });

  void _popPage() => setState(() {
    _resetList();
    _pages.removeLast();
    _ensureLoaded();
  });

  void _goWorkspace([void Function()? then]) {
    context.go('/workspace');
    then?.call();
  }

  void _openChatSession(String sessionId, String? projectId) {
    // Web openSession: focuses an existing chat pane, else opens a new one.
    _goWorkspace(() {
      final ws = ref.read(workspaceProvider);
      final ctl = ref.read(workspaceProvider.notifier);
      for (final p in ws.panes) {
        if (p.kind == PaneKind.chat && p.sessionId == sessionId) {
          ctl.setActivePaneId(p.id);
          return;
        }
      }
      ctl.openPane(PaneKind.chat, sessionId: sessionId, projectId: projectId);
    });
  }

  void _openGit() {
    // Web onShowTab('git') reveals the git workspace UI → git split pane.
    _goWorkspace(
      () => ref.read(workspaceProvider.notifier).openPane(PaneKind.git, projectId: _projectId),
    );
  }

  void _openComparedInSplit() {
    final a = _compare[0];
    final b = _compare[1];
    if (a == null || b == null || a == b) return;
    _openChatSession(a, _projectId);
    _openChatSession(b, _projectId);
  }

  // ─── Item list ───────────────────────────────────────────────────────────

  List<_Group> _buildGroups() {
    final t = Translations.of(context).common.commandPalette;
    final groups = <_Group>[];
    final projectId = _projectId;
    final hasProject = projectId != null;
    final browsing = _page == null && _search.isEmpty;
    // Web `shouldShowTasksTab` — gates the Alt+2 badge on Tasks vs Git.
    final showTasks =
        ref.watch(tasksEnabledProvider) &&
        (ref.watch(taskmasterInstallStatusProvider).value?.isInstalled ?? false);

    if (_showActions) {
      groups.add(
        _Group(t.groups.actions, [
          _Item(
            id: 'new-chat',
            icon: LucideIcons.messageSquarePlus,
            label: t.items.startNewChat,
            enabled: hasProject,
            disabledHint: hasProject ? null : t.items.selectProjectFirst,
            onSelect: () => _run(
              () => _goWorkspace(
                () => ref
                    .read(workspaceProvider.notifier)
                    .openPane(PaneKind.chat, projectId: projectId),
              ),
            ),
          ),
          _Item(
            id: 'open-settings',
            icon: LucideIcons.settings,
            label: t.items.openSettings,
            trailing: 'Ctrl+,',
            onSelect: () => _run(() => context.go('/settings/${lastSettingsSection()}')),
          ),
          _Item(
            id: 'toggle-theme',
            icon: LucideIcons.sunMoon,
            label: t.items.toggleTheme,
            onSelect: () => _run(() {
              final current = ref.read(themeModeProvider);
              ref
                  .read(themeModeProvider.notifier)
                  .set(current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
            }),
          ),
          _Item(
            id: 'compare',
            icon: LucideIcons.gitMerge,
            label: t.items.compareSessions,
            enabled: hasProject,
            trailing: t.items.tokensAndCost,
            onSelect: () {
              _compare[0] = null;
              _compare[1] = null;
              _pushPage(_PalettePage.compare);
            },
          ),
        ]),
      );

      final navT = t.nav;
      groups.add(
        _Group(t.groups.navigate, [
          for (final (id, icon, label, keywords, dest)
              in <(String, IconData, String, String, void Function())>[
                (
                  'chat',
                  LucideIcons.messageSquare,
                  navT.chat,
                  'chat messages conversation',
                  () => _goWorkspace(),
                ),
                ('git', LucideIcons.gitBranch, navT.git, 'git diff branches', _openGit),
                (
                  'board',
                  LucideIcons.squareKanban,
                  navT.board,
                  'board kanban agents projects',
                  () => context.go('/board'),
                ),
                (
                  'tasks',
                  LucideIcons.clipboardCheck,
                  navT.tasks,
                  'tasks taskmaster',
                  () => context.go('/tasks'),
                ),
                (
                  'usage',
                  LucideIcons.gauge,
                  navT.usage,
                  'usage quota control center tokens cost',
                  () => context.go('/quota'),
                ),
                (
                  'source-control',
                  LucideIcons.folderGit2,
                  navT.sourceControl,
                  'source control scm repositories',
                  () => context.go('/git${projectId != null ? '?projectId=$projectId' : ''}'),
                ),
                (
                  'files',
                  LucideIcons.folder,
                  navT.files,
                  'files explorer tree',
                  () => context.go('/files'),
                ),
              ])
            _Item(
              id: 'nav-$id',
              icon: icon,
              label: label,
              keywords: keywords,
              // Alt+1..3 quick-switch badge — web `navShortcut` parity.
              trailing: switch (id) {
                'chat' => 'Alt+1',
                'tasks' when showTasks => 'Alt+2',
                'git' => showTasks ? 'Alt+3' : 'Alt+2',
                _ => null,
              },
              onSelect: () => _run(dest),
            ),
        ]),
      );

      if (hasProject) {
        final git = ref.read(gitRepositoryProvider);
        _Item gitAction(String id, IconData icon, String label, Future<void> Function() op) =>
            _Item(
              id: id,
              icon: icon,
              label: label,
              onSelect: () => _run(() {
                _openGit();
                unawaited(op());
              }),
            );
        groups.add(
          _Group(t.groups.git, [
            gitAction(
              'git-fetch',
              LucideIcons.refreshCw,
              t.items.gitFetch,
              () => git.fetch(projectId),
            ),
            gitAction(
              'git-pull',
              LucideIcons.arrowDownToLine,
              t.items.gitPull,
              () => git.pull(projectId),
            ),
            gitAction(
              'git-push',
              LucideIcons.arrowUpFromLine,
              t.items.gitPush,
              () => git.push(projectId),
            ),
          ]),
        );
      }

      groups.add(
        _Group(t.groups.settings, [
          for (final s in settingsSections)
            _Item(
              id: 'settings-${s.id}',
              icon: s.icon,
              label: t.items.settingsEntry(label: s.label(Translations.of(context))),
              onSelect: () => _run(() => context.go('/settings/${s.id}')),
            ),
        ]),
      );
    }

    if (_showSessions && _page != _PalettePage.compare && hasProject) {
      final shown = _sessionRows.where((s) => s.matches(_search.toLowerCase())).toList();
      final sliced = browsing ? shown.take(_browseLimit).toList() : shown;
      if (sliced.isNotEmpty ||
          (!browsing && shown.length > _browseLimit) ||
          (browsing && shown.length > _browseLimit)) {
        groups.add(
          _Group(t.groups.sessions, [
            for (final s in sliced)
              _Item(
                id: 'session-${s.id}',
                icon: LucideIcons.messageSquare,
                label: s.label,
                subtitle: s.snippet?.isNotEmpty == true ? s.snippet : null,
                trailing: s.provider,
                keywords: s.id,
                onSelect: () => _run(() => _openChatSession(s.id, s.projectId)),
              ),
            if (_page == null && shown.length > _browseLimit)
              _Item(
                id: 'browse-sessions',
                icon: LucideIcons.chevronRight,
                label: t.browseAll.sessions(count: shown.length),
                onSelect: () => _pushPage(_PalettePage.sessions),
              ),
          ]),
        );
      }
    }

    if (_showFiles && hasProject) {
      final shown = (_files ?? const <_FlatFile>[])
          .where((f) => f.path.toLowerCase().contains(_search.toLowerCase()))
          .toList();
      final sliced = browsing ? shown.take(_browseLimit).toList() : shown;
      if (sliced.isNotEmpty) {
        groups.add(
          _Group(t.groups.files, [
            for (final f in sliced)
              _Item(
                id: 'file-${f.path}',
                icon: LucideIcons.fileText,
                label: f.name,
                subtitle: f.path,
                keywords: f.path,
                onSelect: () => _run(
                  () => _goWorkspace(
                    () => ref.read(workspaceProvider.notifier).openFileInEditor(projectId, f.path),
                  ),
                ),
              ),
            if (_page == null && shown.length > _browseLimit)
              _Item(
                id: 'browse-files',
                icon: LucideIcons.chevronRight,
                label: t.browseAll.files(count: shown.length),
                onSelect: () => _pushPage(_PalettePage.files),
              ),
          ]),
        );
      }
    }

    if (_showCommits && hasProject) {
      final shown = (_commits ?? const <GitCommit>[])
          .where(
            (c) => '${c.message} ${c.author} ${c.shortHash}'.toLowerCase().contains(
              _search.toLowerCase(),
            ),
          )
          .toList();
      final sliced = browsing ? shown.take(_browseLimit).toList() : shown;
      if (sliced.isNotEmpty) {
        groups.add(
          _Group(t.groups.commits, [
            for (final c in sliced)
              _Item(
                id: 'commit-${c.hash}',
                icon: LucideIcons.gitCommit,
                label: c.message,
                subtitle: c.author,
                trailing: c.shortHash,
                keywords: '${c.author} ${c.shortHash}',
                onSelect: () => _run(_openGit),
              ),
            if (_page == null && shown.length > _browseLimit)
              _Item(
                id: 'browse-commits',
                icon: LucideIcons.chevronRight,
                label: t.browseAll.commits(count: shown.length),
                onSelect: () => _pushPage(_PalettePage.commits),
              ),
          ]),
        );
      }
    }

    if (_showBranches && hasProject) {
      final shown = (_branches ?? const <String>[])
          .where((b) => b.toLowerCase().contains(_search.toLowerCase()))
          .toList();
      final sliced = browsing ? shown.take(_browseLimit).toList() : shown;
      if (sliced.isNotEmpty) {
        groups.add(
          _Group(t.groups.branches, [
            for (final b in sliced)
              _Item(
                id: 'branch-$b',
                icon: LucideIcons.gitMerge,
                label: t.items.switchTo(name: b),
                keywords: b,
                onSelect: () => _run(() {
                  _openGit();
                  unawaited(ref.read(gitRepositoryProvider).checkout(projectId, b));
                }),
              ),
            if (_page == null && shown.length > _browseLimit)
              _Item(
                id: 'browse-branches',
                icon: LucideIcons.chevronRight,
                label: t.browseAll.branches(count: shown.length),
                onSelect: () => _pushPage(_PalettePage.branches),
              ),
          ]),
        );
      }
    }

    // cmdk parity: the input filters every rendered item (label + keywords).
    final query = _search.trim().toLowerCase();
    if (query.isEmpty) return groups;
    return [
      for (final g in groups) _Group(g.heading, g.items.where((i) => i.matches(query)).toList()),
    ];
  }

  // ─── Keyboard handling (web cmdk: ↑↓ navigate, ↵ select, ⌫ pops page) ───

  List<_Item> _flatten(List<_Group> groups) => [for (final g in groups) ...g.items];

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final groups = _buildGroups();
    final flat = _flatten(groups);
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() => _selected = (_selected + 1) % flat.length.clamp(1, 1 << 31));
      _scrollToSelected(flat);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() => _selected = (_selected - 1 + flat.length) % flat.length.clamp(1, 1 << 31));
      _scrollToSelected(flat);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (_selected >= 0 && _selected < flat.length) {
        final item = flat[_selected];
        if (item.enabled) item.onSelect();
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.backspace && _search.isEmpty && _pages.isNotEmpty) {
      _popPage();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _scrollToSelected(List<_Item> flat) {
    if (_selected < 0 || _selected >= flat.length) return;
    final key = _itemKeys[flat[_selected].id];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = key?.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 100));
      }
    });
  }

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    _ensureLoaded();
    final t = Translations.of(context).common.commandPalette;
    final colors = context.appColors;
    final groups = _buildGroups();
    final flat = _flatten(groups);
    if (_selected >= flat.length) {
      _selected = flat.isEmpty ? 0 : flat.length - 1;
    }
    final page = _page;

    return Dialog(
      clipBehavior: Clip.antiAlias,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 576, maxHeight: 560),
        child: Focus(
          onKeyEvent: _onKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (page != null)
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Chip(
                        visualDensity: VisualDensity.compact,
                        label: Text(_pageLabel(t, page)),
                        onDeleted: _popPage,
                        deleteButtonTooltipMessage: t.backToAll,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        t.backspaceHint,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: colors.mutedForeground),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: _searchCtl,
                  focusNode: _inputFocus,
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: const Icon(Icons.search, size: 18),
                    hintText: page != null
                        ? t.searchPagePlaceholder(page: _pageLabel(t, page).toLowerCase())
                        : t.placeholder,
                    border: InputBorder.none,
                  ),
                  onChanged: (v) {
                    setState(() {
                      _search = v;
                      _selected = 0;
                    });
                    _searchMessages(v);
                  },
                  onSubmitted: (_) {
                    if (flat.isNotEmpty && _selected < flat.length) {
                      final item = flat[_selected];
                      if (item.enabled) item.onSelect();
                    }
                  },
                ),
              ),
              Divider(height: 1, color: colors.border),
              Flexible(
                child: page == _PalettePage.compare
                    ? _buildCompare(t, colors)
                    : flat.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(t.noResults, style: Theme.of(context).textTheme.bodySmall),
                      )
                    : ListView(
                        controller: _listCtl,
                        shrinkWrap: true,
                        children: [
                          for (final g in groups)
                            if (g.items.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12, 10, 12, 2),
                                child: Text(
                                  g.heading,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: colors.mutedForeground),
                                ),
                              ),
                              for (final item in g.items)
                                _itemTile(item, flat.indexOf(item), colors),
                            ],
                        ],
                      ),
              ),
              if (page != _PalettePage.compare) _buildHints(t, colors),
            ],
          ),
        ),
      ),
    );
  }

  String _pageLabel(Translations$common$commandPalette$en t, _PalettePage p) => switch (p) {
    _PalettePage.actions => t.pages.actions,
    _PalettePage.files => t.pages.files,
    _PalettePage.sessions => t.pages.sessions,
    _PalettePage.commits => t.pages.commits,
    _PalettePage.branches => t.pages.branches,
    _PalettePage.compare => t.pages.compare,
  };

  Widget _itemTile(_Item item, int index, AppColors colors) {
    final selected = index == _selected;
    final key = _itemKeys.putIfAbsent(item.id, () => GlobalObjectKey(item.id));
    return ListTile(
      key: key,
      dense: true,
      enabled: item.enabled,
      selected: selected,
      selectedTileColor: colors.accent,
      leading: Icon(item.icon, size: 16, color: colors.mutedForeground),
      title: Text(
        item.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 13),
      ),
      subtitle: item.subtitle == null
          ? null
          : Text(
              item.subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, color: colors.mutedForeground),
            ),
      trailing: item.enabled
          ? (item.trailing == null ? null : _kbd(item.trailing!, colors))
          : (item.disabledHint == null
                ? null
                : Text(
                    item.disabledHint!,
                    style: TextStyle(fontSize: 11, color: colors.mutedForeground),
                  )),
      onTap: item.enabled ? item.onSelect : null,
      mouseCursor: item.enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
    );
  }

  Widget _buildCompare(Translations$common$commandPalette$en t, AppColors colors) {
    final tt = Theme.of(context).textTheme;
    final filter = _search.trim().toLowerCase();
    final sessions = _sessionRows;
    final left = _sessionById(_compare[0]);
    final right = _sessionById(_compare[1]);
    final lu = _usage[0];
    final ru = _usage[1];
    final canSplit = _compare[0] != null && _compare[1] != null && _compare[0] != _compare[1];

    String fmtTokens(num? v) => v == null ? '—' : _intFmt(v);
    String side(_SessionRow? sel, _SessionUsage? u, String Function(_SessionUsage) pick) =>
        sel == null ? '—' : (u == null ? '…' : pick(u));

    final rows = <(String, String, String)>[
      (t.compare.provider, left?.provider ?? '—', right?.provider ?? '—'),
      (
        t.compare.model,
        side(left, lu, (u) => u.model ?? '—'),
        side(right, ru, (u) => u.model ?? '—'),
      ),
      (
        t.compare.tokensUsed,
        side(left, lu, (u) => u.unsupported ? t.compare.na : fmtTokens(u.used)),
        side(right, ru, (u) => u.unsupported ? t.compare.na : fmtTokens(u.used)),
      ),
      (
        t.compare.inputOutput,
        side(left, lu, (u) => '${fmtTokens(u.input)} / ${fmtTokens(u.output)}'),
        side(right, ru, (u) => '${fmtTokens(u.input)} / ${fmtTokens(u.output)}'),
      ),
      (
        t.compare.estCost,
        side(left, lu, (u) => formatCostUsd(u.costUsd)),
        side(right, ru, (u) => formatCostUsd(u.costUsd)),
      ),
    ];

    Widget select(int side) {
      final options = filter.isEmpty
          ? sessions
          : sessions
                .where((s) => s.id == _compare[side] || s.label.toLowerCase().contains(filter))
                .toList();
      return DropdownButtonFormField<String>(
        initialValue: _compare[side],
        isExpanded: true,
        decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
        hint: Text(t.compare.selectSession),
        items: [
          for (final s in options)
            DropdownMenuItem(
              value: s.id,
              child: Text(
                s.provider == null ? s.label : '${s.label} · ${s.provider}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ),
        ],
        onChanged: (v) => setState(() {
          _compare[side] = v;
          _usage.remove(side);
          if (v != null) unawaited(_loadUsage(side));
        }),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      children: [
        Row(
          children: [
            Expanded(child: select(0)),
            const SizedBox(width: 8),
            Expanded(child: select(1)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: colors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (final (label, l, r) in rows)
                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: colors.border, width: 0.5)),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 112,
                        child: Container(
                          color: colors.muted.withValues(alpha: 0.3),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Text(
                            label,
                            style: tt.bodySmall?.copyWith(
                              color: colors.mutedForeground,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                      for (final v in [l, r])
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            child: Text(
                              v,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                t.compare.costNote,
                style: tt.bodySmall?.copyWith(color: colors.mutedForeground, fontSize: 11),
              ),
            ),
            TextButton(
              onPressed: canSplit ? () => _run(_openComparedInSplit) : null,
              child: Text(t.compare.openSplit),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHints(Translations$common$commandPalette$en t, AppColors colors) {
    Widget hint(String key, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _kbd(key, colors),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, color: colors.mutedForeground)),
      ],
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            hint('↑↓', t.hints.navigate),
            const SizedBox(width: 16),
            hint('↵', t.hints.select),
            const SizedBox(width: 16),
            hint('Esc', t.hints.close),
            const SizedBox(width: 24),
            hint('Ctrl+Shift+K', t.hints.togglePalette),
          ],
        ),
      ),
    );
  }

  static String _intFmt(num v) {
    final s = v.toInt().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

// Same bordered-muted chip as the web `Kbd`.
Widget _kbd(String label, AppColors colors) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
  decoration: BoxDecoration(
    border: Border.all(color: colors.border),
    borderRadius: BorderRadius.circular(4),
    color: colors.muted.withValues(alpha: 0.4),
  ),
  child: Text(
    label,
    style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: colors.mutedForeground),
  ),
);

extension on _SessionRow {
  bool matches(String query) {
    if (query.isEmpty) return true;
    return '$label ${snippet ?? ''} $id'.toLowerCase().contains(query);
  }
}
