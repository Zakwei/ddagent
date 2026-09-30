import 'dart:async';

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
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

/// Create-project dialog — path entry + filesystem browse + custom name.
class _CreateProjectDialog extends ConsumerStatefulWidget {
  const _CreateProjectDialog();

  @override
  ConsumerState<_CreateProjectDialog> createState() =>
      _CreateProjectDialogState();
}

class _CreateProjectDialogState extends ConsumerState<_CreateProjectDialog> {
  final _path = TextEditingController();
  final _name = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _path.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _browse() async {
    final picked = await showDialog<String>(
      context: context,
      builder: (_) => const FolderBrowserDialog(),
    );
    if (picked != null) _path.text = picked;
  }

  Future<void> _create() async {
    if (_path.text.trim().isEmpty) {
      setState(() => _error = 'Path is required');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
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

  @override
  Widget build(BuildContext context) => AppDialog(
    title: 'New project',
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: AppInput(
                controller: _path,
                hint: 'Project path',
                autofocus: true,
              ),
            ),
            IconButton(
              tooltip: 'Browse',
              icon: const Icon(Icons.folder_open),
              onPressed: _browse,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppInput(controller: _name, hint: 'Display name (optional)'),
        if (_error != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(_error!, style: TextStyle(color: context.appColors.destructive)),
        ],
      ],
    ),
    actions: [
      AppButton(
        variant: AppButtonVariant.ghost,
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      AppButton(
        onPressed: _create,
        loading: _busy,
        child: const Text('Create'),
      ),
    ],
  );
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
