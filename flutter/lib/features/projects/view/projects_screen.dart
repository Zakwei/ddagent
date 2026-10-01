import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/sse_client.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_card.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_nav_menu.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/file_tree/view/folder_browser.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/settings/data/api_credentials_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Projects home — list + archive + management parity with the mobile
/// ProjectsScreen and the web sidebar.
class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  String _query = '';
  bool _archivedOpen = false;

  List<Project> _sorted(List<Project> list) {
    final q = _query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? list
        : [
            for (final p in list)
              if (p.displayName.toLowerCase().contains(q) ||
                  p.path.toLowerCase().contains(q))
                p,
          ];
    return [...filtered]..sort((a, b) {
      if (a.isStarred != b.isStarred) return a.isStarred ? -1 : 1;
      return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
    });
  }

  Future<void> _actionError(String? err, [String? okMsg]) async {
    if (!mounted) return;
    if (err != null) {
      AppToast.error(context, err);
    } else if (okMsg != null) {
      AppToast.show(context, okMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = context.appColors;
    final state = ref.watch(projectsProvider);
    final ctrl = ref.read(projectsProvider.notifier);

    if (state.loading && state.projects.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    Future<void> onAction(Future<String?> Function() call, String ok) async =>
        _actionError(await call(), ok);

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
                const AppNavMenuButton(),
                Expanded(
                  child: AppInput(
                    hint: 'Search projects…',
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
                if (state.syncing)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                IconButton(
                  tooltip: 'Clone repository',
                  icon: const Icon(Icons.cloud_download_outlined),
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => const _CloneDialog(),
                  ).then((_) => ctrl.load()),
                ),
                IconButton(
                  tooltip: 'New project',
                  icon: Icon(Icons.add, color: c.primary),
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => const _CreateProjectDialog(),
                  ).then((_) => ctrl.load()),
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
                  for (final p in _sorted(state.projects))
                    _ProjectTile(
                      project: p,
                      taskmasterBadge: state.taskmaster.containsKey(
                        p.projectId,
                      ),
                      onStar: () => ctrl.toggleStar(p.projectId),
                      onOpenSession: (id) => context.go(
                        Uri(
                          path: '/chat/$id',
                          queryParameters: {
                            'projectId': p.projectId,
                            'projectPath': p.fullPath ?? p.path,
                          },
                        ).toString(),
                      ),
                      menu: _ProjectMenu(
                        entries: [
                          ('Rename', () => unawaited(_renameDialog(p))),
                          (
                            'Archive',
                            () => onAction(
                              () => ctrl.archive(p.projectId),
                              'Project archived',
                            ),
                          ),
                          (
                            'Delete permanently',
                            () => unawaited(_hardDeleteConfirm(p)),
                          ),
                        ],
                      ),
                    ),
                  if (_sorted(state.projects).isEmpty && _query.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: Text(
                        'No projects yet',
                        textAlign: TextAlign.center,
                        style: t.textTheme.bodyLarge?.copyWith(
                          color: c.mutedForeground,
                        ),
                      ),
                    ),
                  if (state.archived.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    InkWell(
                      onTap: () =>
                          setState(() => _archivedOpen = !_archivedOpen),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _archivedOpen
                                  ? Icons.expand_more
                                  : Icons.chevron_right,
                              size: 18,
                              color: c.mutedForeground,
                            ),
                            Text(
                              'Archived (${state.archived.length})',
                              style: t.textTheme.titleSmall?.copyWith(
                                color: c.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_archivedOpen)
                      for (final p in _sorted(state.archived))
                        _ProjectTile(
                          project: p,
                          onOpenSession: (id) => context.go(
                            Uri(
                              path: '/chat/$id',
                              queryParameters: {
                                'projectId': p.projectId,
                                'projectPath': p.fullPath ?? p.path,
                              },
                            ).toString(),
                          ),
                          menu: _ProjectMenu(
                            entries: [
                              (
                                'Restore',
                                () => onAction(
                                  () => ctrl.restore(p.projectId),
                                  'Project restored',
                                ),
                              ),
                              (
                                'Delete permanently',
                                () => unawaited(_hardDeleteConfirm(p)),
                              ),
                            ],
                          ),
                        ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _renameDialog(Project p) async {
    final ctrl = ref.read(projectsProvider.notifier);
    final field = TextEditingController(text: p.displayName);
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Rename project',
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
      await _actionError(
        await ctrl.rename(p.projectId, field.text.trim()),
        'Project renamed',
      );
    }
    field.dispose();
  }

  Future<void> _hardDeleteConfirm(Project p) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: 'Delete project?',
      message:
          'Permanently removes "${p.displayName}" including all sessions and stored history (JSONL wipe). This cannot be undone.',
      confirmLabel: 'Delete',
    );
    if (confirmed) {
      await _actionError(
        await ref.read(projectsProvider.notifier).hardDelete(p.projectId),
        'Project deleted',
      );
    }
  }
}

/// Overflow menu for a project tile.
class _ProjectMenu extends StatelessWidget {
  const _ProjectMenu({required this.entries});

  final List<(String, VoidCallback)> entries;

  @override
  Widget build(BuildContext context) => PopupMenuButton<int>(
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

/// One project row — expands inline to show recent sessions with paging.
class _ProjectTile extends ConsumerStatefulWidget {
  const _ProjectTile({
    required this.project,
    required this.onOpenSession,
    required this.menu,
    this.onStar,
    this.taskmasterBadge = false,
  });

  final Project project;
  final void Function(String sessionId) onOpenSession;
  final Widget menu;
  final VoidCallback? onStar;
  final bool taskmasterBadge;

  @override
  ConsumerState<_ProjectTile> createState() => _ProjectTileState();
}

class _ProjectTileState extends ConsumerState<_ProjectTile> {
  bool _expanded = false;
  int _offset = 0;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = context.appColors;
    final p = widget.project;
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () => setState(() => _expanded = !_expanded),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.folder_outlined, size: 20, color: c.mutedForeground),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              p.displayName,
                              style: t.textTheme.titleSmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (widget.taskmasterBadge) ...[
                            const SizedBox(width: AppSpacing.xs),
                            Icon(Icons.task_alt, size: 15, color: c.primary),
                          ],
                        ],
                      ),
                      Text(
                        p.path,
                        style: t.textTheme.bodySmall?.copyWith(
                          color: c.mutedForeground,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if ((p.sessionMeta?.total ?? 0) > 0)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: Text(
                      '${p.sessionMeta!.total} sessions',
                      style: t.textTheme.bodySmall?.copyWith(
                        color: c.mutedForeground,
                      ),
                    ),
                  ),
                if (widget.onStar != null)
                  InkWell(
                    onTap: widget.onStar,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      child: Icon(
                        p.isStarred ? Icons.star : Icons.star_border,
                        size: 18,
                        color: p.isStarred ? c.primary : c.mutedForeground,
                      ),
                    ),
                  ),
                widget.menu,
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                  color: c.mutedForeground,
                ),
              ],
            ),
            if (_expanded)
              _SessionsList(
                projectId: p.projectId,
                offset: _offset,
                onOffset: (o) => setState(() => _offset = o),
                onOpenSession: widget.onOpenSession,
              ),
          ],
        ),
      ),
    );
  }
}

class _SessionsList extends ConsumerWidget {
  const _SessionsList({
    required this.projectId,
    required this.offset,
    required this.onOffset,
    required this.onOpenSession,
  });

  final String projectId;
  final int offset;
  final ValueChanged<int> onOffset;
  final void Function(String sessionId) onOpenSession;

  static const _limit = 20;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final page = ref.watch(
      projectSessionsProvider((projectId, _limit, offset)),
    );
    return page.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Center(
          child: SizedBox.square(
            dimension: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Text('$e', style: TextStyle(color: c.destructive)),
      ),
      data: (data) => Column(
        children: [
          for (final s in data.sessions)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.chat_bubble_outline,
                size: 16,
                color: c.mutedForeground,
              ),
              title: Text(
                (s['title'] ?? s['displayName'] ?? s['id'] ?? 'session')
                    .toString(),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: s['provider'] != null
                  ? Text(
                      s['provider'].toString(),
                      style: TextStyle(color: c.mutedForeground),
                    )
                  : null,
              onTap: () =>
                  onOpenSession((s['id'] ?? s['sessionId']).toString()),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (offset > 0)
                TextButton(
                  onPressed: () => onOffset(offset - _limit),
                  child: const Text('Newer'),
                ),
              if (data.sessionMeta?.hasMore == true)
                TextButton(
                  onPressed: () => onOffset(offset + _limit),
                  child: const Text('Older'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Project-creation wizard — port of `ProjectCreationWizard.tsx`: step 1
/// configures the workspace path + optional GitHub clone (stored/new/none
/// token modes), step 2 reviews and runs create or SSE clone.
class _CreateProjectDialog extends ConsumerStatefulWidget {
  const _CreateProjectDialog();

  @override
  ConsumerState<_CreateProjectDialog> createState() =>
      _CreateProjectDialogState();
}

class _CreateProjectDialogState extends ConsumerState<_CreateProjectDialog> {
  final _path = TextEditingController();
  final _name = TextEditingController();
  final _githubUrl = TextEditingController();
  final _newToken = TextEditingController();
  int _step = 1;
  String _tokenMode = 'stored'; // stored | new | none
  String _selectedTokenId = '';
  List<GithubCredentialEntry> _tokens = const [];
  bool _tokensLoaded = false;
  bool _loadingTokens = false;
  String? _tokenError;
  bool _busy = false;
  String? _error;
  String _cloneProgress = '';
  CancelToken? _cancel;

  @override
  void initState() {
    super.initState();
    _githubUrl.addListener(_maybeLoadTokens);
  }

  @override
  void dispose() {
    _cancel?.cancel();
    _path.dispose();
    _name.dispose();
    _githubUrl.dispose();
    _newToken.dispose();
    super.dispose();
  }

  // pathUtils.ts
  bool get _isSsh {
    final u = _githubUrl.text.trim();
    return u.startsWith('git@') || u.startsWith('ssh://');
  }

  bool get _showGithubAuth => _githubUrl.text.trim().isNotEmpty && !_isSsh;
  bool get _isClone => _githubUrl.text.trim().isNotEmpty;

  String? get _selectedTokenName {
    for (final t in _tokens) {
      if (t.id == _selectedTokenId) return t.name;
    }
    return null;
  }

  // useGithubTokens — load once when the auth card becomes visible,
  // auto-select the first stored token.
  void _maybeLoadTokens() {
    if (!_showGithubAuth || _tokensLoaded || _loadingTokens) return;
    _loadingTokens = true;
    unawaited(
      ref
          .read(apiCredentialsRepositoryProvider)
          .githubCredentials()
          .then((all) {
            if (!mounted) return;
            setState(() {
              _loadingTokens = false;
              _tokensLoaded = true;
              _tokens = [
                for (final t in all)
                  if (t.isActive) t,
              ];
              if (_tokens.isNotEmpty && _selectedTokenId.isEmpty) {
                _selectedTokenId = _tokens.first.id;
              }
            });
          })
          .catchError((Object e) {
            if (!mounted) return;
            setState(() {
              _loadingTokens = false;
              _tokensLoaded = true;
              _tokenError = e is AppError
                  ? e.message
                  : 'Failed to load GitHub tokens';
            });
          }),
    );
    setState(() {});
  }

  Future<void> _browse() async {
    final picked = await showDialog<String>(
      context: context,
      builder: (_) => const FolderBrowserDialog(),
    );
    if (picked != null) _path.text = picked;
  }

  void _next() {
    setState(() => _error = null);
    if (_step == 1) {
      if (_path.text.trim().isEmpty) {
        setState(() => _error = 'Please provide a workspace path');
        return;
      }
      setState(() => _step = 2);
    }
  }

  void _back() {
    setState(() {
      _error = null;
      if (_step > 1) _step -= 1;
    });
  }

  Future<void> _create() async {
    setState(() {
      _busy = true;
      _error = null;
      _cloneProgress = '';
    });
    if (_isClone) {
      await _clone();
      return;
    }
    final err = await ref
        .read(projectsProvider.notifier)
        .create(
          _path.text.trim(),
          customName: _name.text.trim().isEmpty ? null : _name.text.trim(),
        );
    if (!mounted) return;
    if (err == null) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _busy = false;
        _error = err;
      });
    }
  }

  Future<void> _clone() async {
    _cancel = CancelToken();
    try {
      await for (final e
          in ref
              .read(sseClientProvider)
              .cloneProgress(
                path: _path.text.trim(),
                githubUrl: _githubUrl.text.trim(),
                githubTokenId:
                    _tokenMode == 'stored' && _selectedTokenId.isNotEmpty
                    ? _selectedTokenId
                    : null,
                newGithubToken:
                    _tokenMode == 'new' && _newToken.text.trim().isNotEmpty
                    ? _newToken.text.trim()
                    : null,
                cancelToken: _cancel,
              )) {
        if (!mounted) return;
        final type = e.data['type'];
        if (type == 'error') {
          setState(() {
            _busy = false;
            _error = (e.data['error'] ?? e.data['message'] ?? 'Clone failed')
                .toString();
          });
          return;
        }
        if (type == 'complete') {
          if (mounted) Navigator.of(context).pop();
          return;
        }
        final msg = (e.data['message'] ?? type).toString();
        if (msg.isNotEmpty) setState(() => _cloneProgress = msg);
      }
    } on DioException catch (e) {
      if (mounted && !CancelToken.isCancel(e)) {
        setState(() {
          _busy = false;
          _error = e.message;
        });
      }
    }
  }

  String get _authLabel {
    if (_tokenMode == 'stored' && _selectedTokenId.isNotEmpty) {
      return 'Using stored token: ${_selectedTokenName ?? 'Unknown'}';
    }
    if (_tokenMode == 'new' && _newToken.text.trim().isNotEmpty) {
      return 'Using provided token';
    }
    if (_isSsh) return 'SSH Key';
    return 'No authentication';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    // Dismissal is blocked while creating (Escape/backdrop/header X).
    return PopScope(
      canPop: !_busy,
      child: Dialog(
        backgroundColor: c.popover,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: c.primary.withValues(alpha: 0.15),
                        borderRadius: AppRadii.borderLg,
                      ),
                      child: Icon(
                        LucideIcons.folderPlus,
                        size: 16,
                        color: c.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Create New Project',
                        style: t.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      tooltip: 'Close',
                      onPressed: _busy
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              _WizardProgress(step: _step),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_error != null) ...[
                        Text(
                          _error!,
                          style: t.bodySmall?.copyWith(color: c.destructive),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                      if (_step == 1) _buildStep1(c, t) else _buildStep2(c, t),
                    ],
                  ),
                ),
              ),
              Divider(height: 1, color: c.border),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    AppButton(
                      variant: AppButtonVariant.outline,
                      onPressed: _busy ? null : (_step == 1 ? _close : _back),
                      child: Text(_step == 1 ? 'Cancel' : 'Back'),
                    ),
                    const Spacer(),
                    AppButton(
                      variant: AppButtonVariant.primary,
                      loading: _busy,
                      onPressed: _busy ? null : (_step == 2 ? _create : _next),
                      child: Text(
                        _busy
                            ? (_isClone ? 'Cloning...' : 'Creating...')
                            : (_step == 2 ? 'Create Project' : 'Next'),
                      ),
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

  void _close() => Navigator.of(context).pop();

  // StepConfiguration.tsx
  Widget _buildStep1(AppColors c, TextTheme t) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _fieldLabel(t, 'Workspace Path'),
      Row(
        children: [
          Expanded(
            child: AppInput(
              controller: _path,
              hint: '/path/to/new/workspace',
              autofocus: true,
              enabled: !_busy,
            ),
          ),
          IconButton(
            tooltip: 'Browse',
            icon: const Icon(Icons.folder_open),
            onPressed: _busy ? null : _browse,
          ),
        ],
      ),
      _fieldHelp(t, 'Full path to your workspace directory'),
      const SizedBox(height: AppSpacing.md),
      _fieldLabel(t, 'Display name (optional)'),
      AppInput(controller: _name, enabled: !_busy),
      const SizedBox(height: AppSpacing.md),
      _fieldLabel(t, 'GitHub URL (Optional)'),
      AppInput(
        controller: _githubUrl,
        hint: 'https://github.com/username/repository',
        enabled: !_busy,
      ),
      _fieldHelp(t, 'Optional: provide a GitHub URL to clone a repository'),
      if (_showGithubAuth) ...[
        const SizedBox(height: AppSpacing.md),
        _githubAuthCard(c, t),
      ],
    ],
  );

  // GithubAuthenticationCard.tsx
  Widget _githubAuthCard(AppColors c, TextTheme t) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: c.muted.withValues(alpha: 0.3),
      border: Border.all(color: c.border),
      borderRadius: AppRadii.borderLg,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(LucideIcons.keyRound, size: 18, color: c.mutedForeground),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GitHub Authentication (Optional)',
                    style: t.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Only required for private repositories. Public repos '
                    'can be cloned without authentication.',
                    style: t.bodySmall?.copyWith(color: c.mutedForeground),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_loadingTokens)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 8),
                Text(
                  'Loading stored tokens...',
                  style: t.bodySmall?.copyWith(color: c.mutedForeground),
                ),
              ],
            ),
          ),
        if (!_loadingTokens && _tokenError != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              _tokenError!,
              style: t.bodySmall?.copyWith(color: c.destructive),
            ),
          ),
        if (!_loadingTokens && _tokens.isNotEmpty) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              for (final (mode, label) in [
                ('stored', 'Stored Token'),
                ('new', 'New Token'),
                ('none', 'None (Public)'),
              ])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _ModeButton(
                      label: label,
                      selected: _tokenMode == mode,
                      none: mode == 'none',
                      onTap: () => setState(() {
                        _tokenMode = mode;
                        if (mode == 'none') {
                          _selectedTokenId = '';
                          _newToken.clear();
                        }
                      }),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (_tokenMode == 'stored') ...[
            _fieldLabel(t, 'Select Token'),
            DropdownButtonFormField<String>(
              initialValue: _selectedTokenId.isEmpty ? null : _selectedTokenId,
              hint: const Text('-- Select a token --'),
              isExpanded: true,
              items: [
                for (final tok in _tokens)
                  DropdownMenuItem(value: tok.id, child: Text(tok.name)),
              ],
              onChanged: (v) => setState(() => _selectedTokenId = v ?? ''),
            ),
          ] else if (_tokenMode == 'new') ...[
            _fieldLabel(t, 'New Token'),
            AppInput(
              controller: _newToken,
              hint: 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
              obscureText: true,
            ),
            _fieldHelp(t, 'This token will be used only for this operation'),
          ],
        ],
        if (!_loadingTokens && _tokenError == null && _tokens.isEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: c.primary.withValues(alpha: 0.08),
              border: Border.all(color: c.primary.withValues(alpha: 0.3)),
              borderRadius: AppRadii.borderLg,
            ),
            child: Text(
              "Public repositories don't require authentication. You can "
              'skip providing a token if cloning a public repo.',
              style: t.bodySmall?.copyWith(color: c.primary),
            ),
          ),
          const SizedBox(height: 12),
          _fieldLabel(t, 'GitHub Token (Optional for Public Repos)'),
          AppInput(
            controller: _newToken,
            hint:
                'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx '
                '(leave empty for public repos)',
            obscureText: true,
            onChanged: (v) =>
                setState(() => _tokenMode = v.trim().isEmpty ? 'none' : 'new'),
          ),
          _fieldHelp(
            t,
            'No stored tokens available. You can add tokens in Settings '
            '→ API Keys for easier reuse.',
          ),
        ],
      ],
    ),
  );

  // StepReview.tsx
  Widget _buildStep2(AppColors c, TextTheme t) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: c.muted.withValues(alpha: 0.3),
          border: Border.all(color: c.border),
          borderRadius: AppRadii.borderLg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Review Your Configuration',
              style: t.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _reviewRow(t, c, 'Path:', _path.text, mono: true),
            if (_githubUrl.text.trim().isNotEmpty) ...[
              _reviewRow(t, c, 'Clone From:', _githubUrl.text, mono: true),
              _reviewRow(t, c, 'Authentication:', _authLabel),
            ],
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: c.primary.withValues(alpha: 0.08),
          border: Border.all(color: c.primary.withValues(alpha: 0.3)),
          borderRadius: AppRadii.borderLg,
        ),
        child: _busy && _cloneProgress.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cloning repository...',
                    style: t.bodySmall?.copyWith(
                      color: c.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _cloneProgress,
                    style: t.bodySmall?.copyWith(
                      color: c.primary,
                      fontFamily: 'monospace',
                      fontSize: 11,
                    ),
                  ),
                ],
              )
            : Text(
                _isClone
                    ? 'The repository will be cloned from this folder.'
                    : 'The workspace will be added to your project list '
                          'and will be available for Claude/Cursor sessions.',
                style: t.bodySmall?.copyWith(color: c.primary),
              ),
      ),
    ],
  );

  Widget _reviewRow(
    TextTheme t,
    AppColors c,
    String label,
    String value, {
    bool mono = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: t.bodySmall?.copyWith(color: c.mutedForeground)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: t.bodySmall?.copyWith(
              fontFamily: mono ? 'monospace' : null,
              fontSize: mono ? 12 : null,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _fieldLabel(TextTheme t, String label) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      label,
      style: t.bodySmall?.copyWith(fontWeight: FontWeight.w500),
    ),
  );

  Widget _fieldHelp(TextTheme t, String help) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Text(
      help,
      style: t.labelSmall?.copyWith(color: context.appColors.mutedForeground),
    ),
  );
}

/// WizardProgress.tsx — numbered circles + connector.
class _WizardProgress extends StatelessWidget {
  const _WizardProgress({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    Widget circle(int s, String label) => Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: s < step
                ? const Color(0xFF22C55E)
                : s == step
                ? c.primary
                : c.muted,
          ),
          child: Center(
            child: s < step
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    '$s',
                    style: t.bodySmall?.copyWith(
                      color: s == step
                          ? c.primaryForeground
                          : c.mutedForeground,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: t.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
      ],
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        children: [
          circle(1, 'Configure'),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              height: 4,
              decoration: BoxDecoration(
                color: step > 1 ? const Color(0xFF22C55E) : c.muted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          circle(2, 'Confirm'),
        ],
      ),
    );
  }
}

/// GithubAuthenticationCard mode button (stored/new/none).
class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.selected,
    required this.none,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool none;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final bg = selected
        ? (none ? const Color(0xFF22C55E) : c.primary)
        : c.muted;
    final fg = selected ? Colors.white : c.foreground;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.borderLg,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: bg, borderRadius: AppRadii.borderLg),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// Clone-repository dialog — SSE clone-progress (progress/error/complete).
class _CloneDialog extends ConsumerStatefulWidget {
  const _CloneDialog();

  @override
  ConsumerState<_CloneDialog> createState() => _CloneDialogState();
}

class _CloneDialogState extends ConsumerState<_CloneDialog> {
  final _url = TextEditingController();
  final _dest = TextEditingController();
  final _token = TextEditingController();
  final _log = <String>[];
  bool _busy = false;
  bool _done = false;
  String? _error;
  CancelToken? _cancel;

  @override
  void dispose() {
    _cancel?.cancel();
    _url.dispose();
    _dest.dispose();
    _token.dispose();
    super.dispose();
  }

  Future<void> _browseDest() async {
    final picked = await showDialog<String>(
      context: context,
      builder: (_) => const FolderBrowserDialog(),
    );
    if (picked != null) _dest.text = picked;
  }

  Future<void> _clone() async {
    if (_url.text.trim().isEmpty) {
      setState(() => _error = 'Repository URL is required');
      return;
    }
    if (_dest.text.trim().isEmpty) {
      setState(() => _error = 'Destination path is required');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _log.clear();
    });
    _cancel = CancelToken();
    try {
      await for (final e
          in ref
              .read(sseClientProvider)
              .cloneProgress(
                githubUrl: _url.text.trim(),
                path: _dest.text.trim(),
                newGithubToken: _token.text.trim().isEmpty
                    ? null
                    : _token.text.trim(),
                cancelToken: _cancel,
              )) {
        if (!mounted) return;
        final type = e.data['type'];
        if (type == 'error') {
          setState(() {
            _busy = false;
            _error = (e.data['error'] ?? e.data['message'] ?? 'Clone failed')
                .toString();
          });
          return;
        }
        if (type == 'complete') {
          setState(() {
            _busy = false;
            _done = true;
          });
          return;
        }
        setState(() => _log.add((e.data['message'] ?? type).toString()));
      }
    } on DioException catch (e) {
      if (mounted && !CancelToken.isCancel(e)) {
        setState(() {
          _busy = false;
          _error = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return AppDialog(
      title: _done ? 'Repository cloned' : 'Clone repository',
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_done) ...[
              AppInput(
                controller: _url,
                hint: 'https://github.com/org/repo.git',
                autofocus: true,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppInput(
                      controller: _dest,
                      hint: 'Destination path',
                    ),
                  ),
                  IconButton(
                    tooltip: 'Browse',
                    icon: const Icon(Icons.folder_open),
                    onPressed: _browseDest,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AppInput(
                controller: _token,
                hint: 'GitHub token (optional)',
                obscureText: true,
              ),
            ],
            if (_log.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 140,
                child: ListView(
                  children: [
                    for (final l in _log)
                      Text(l, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
            if (_busy)
              const Padding(
                padding: EdgeInsets.only(top: AppSpacing.md),
                child: LinearProgressIndicator(),
              ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(_error!, style: TextStyle(color: c.destructive)),
            ],
            if (_done)
              const Padding(
                padding: EdgeInsets.only(top: AppSpacing.md),
                child: Text('Clone finished. Refreshing project list…'),
              ),
          ],
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () {
            _cancel?.cancel();
            Navigator.of(context).pop();
          },
          child: Text(_done ? 'Close' : 'Cancel'),
        ),
        if (!_done)
          AppButton(
            onPressed: _clone,
            loading: _busy,
            child: const Text('Clone'),
          ),
      ],
    );
  }
}
