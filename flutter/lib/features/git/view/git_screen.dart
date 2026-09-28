import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/git/data/git_models.dart';
import 'package:ddagent_app/features/git/data/git_repository.dart';
import 'package:ddagent_app/features/git/state/git_controller.dart';
import 'package:ddagent_app/features/git/view/checkpoints_dialog.dart';
import 'package:ddagent_app/features/git/view/git_diff_viewer.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Git/version-control panel (port of GitPanel.tsx): branch+remote toolbar,
/// staged/changes lists with per-file diffs and hunk staging, commit
/// composer, checkpoints. Mounted standalone via /git and as a workspace
/// pane (PaneKind.git).
class GitScreen extends ConsumerStatefulWidget {
  const GitScreen({super.key, this.projectId});

  final String? projectId;

  @override
  ConsumerState<GitScreen> createState() => _GitScreenState();
}

class _GitScreenState extends ConsumerState<GitScreen> {
  final _message = TextEditingController();
  final _expanded = <String>{};

  /// file → loading / diff text / error, fetched lazily on expand.
  final _diffs = <String, Object?>{};
  GitDiffViewMode _viewMode = GitDiffViewMode.unified;
  ProviderSubscription<GitStatus?>? _statusSub;

  @override
  void initState() {
    super.initState();
    _statusSub = ref.listenManual(
      gitProvider.select((s) => s.status),
      // Status changes can land mid-build (watch-driven) — defer the
      // setState in _fetchDiff to the next frame.
      (_, _) => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_refetchExpandedDiffs());
      }),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(projectsProvider.notifier).load();
      final pid =
          widget.projectId ??
          ref.read(projectsProvider).projects.firstOrNull?.projectId;
      ref.read(gitProvider.notifier).selectProject(pid);
    });
  }

  @override
  void dispose() {
    _statusSub?.close();
    _message.dispose();
    super.dispose();
  }

  String? get _projectId => widget.projectId ?? ref.read(gitProvider).projectId;

  /// `key` is the expanded/diff map key (`staged:<f>` / `change:<f>`) —
  /// staged and unstaged sections may show the same path simultaneously.
  Future<void> _fetchDiff(String key, String file) async {
    final pid = _projectId;
    if (pid == null) return;
    setState(() => _diffs[key] = null); // loading
    try {
      final res = await ref
          .read(gitRepositoryProvider)
          .diff(pid, filePath: file);
      if (!mounted) return;
      setState(() => _diffs[key] = res['diff']?.toString() ?? '');
    } on Object catch (e) {
      if (!mounted) return;
      setState(() => _diffs[key] = e);
    }
  }

  /// Diffs go stale after every mutation — refetch the open ones.
  Future<void> _refetchExpandedDiffs() async {
    for (final key in _expanded.toList()) {
      await _fetchDiff(key, key.substring(key.indexOf(':') + 1));
    }
  }

  void _toggle(String key, String file) {
    setState(() {
      if (_expanded.remove(key)) return;
      _expanded.add(key);
    });
    if (_expanded.contains(key) && !_diffs.containsKey(key)) {
      unawaited(_fetchDiff(key, file));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gitProvider);
    final c = context.appColors;
    final status = state.status;

    if (status != null && status.notGitRepository) {
      return _NotGitView(
        busy: state.busy,
        error: state.error,
        onInit: () => unawaited(ref.read(gitProvider.notifier).init()),
      );
    }
    if (status == null && state.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (status == null) {
      return Center(
        child: Text(
          state.error ?? 'Select a project',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: c.mutedForeground),
        ),
      );
    }

    final staged = status.staged;
    final unstaged = [
      for (final f in status.modified) (f, 'M'),
      for (final f in status.added) (f, 'A'),
      for (final f in status.deleted) (f, 'D'),
      for (final f in status.untracked) (f, 'U'),
    ];
    final changes = staged.length + unstaged.length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _GitHeader(
            state: state,
            viewMode: _viewMode,
            onViewMode: (m) => setState(() => _viewMode = m),
          ),
          if (state.error != null)
            _ErrorBanner(
              message: state.error!,
              onDismiss: ref.read(gitProvider.notifier).clearError,
            ),
          if (status.hasCommits && changes > 0)
            _CommitComposer(
              message: _message,
              busy: state.busy,
              stagedCount: staged.length,
              onGenerate: () async {
                final files = staged.isNotEmpty
                    ? staged
                    : [for (final e in unstaged) e.$1];
                final msg = await ref
                    .read(gitProvider.notifier)
                    .generateCommitMessage(files);
                if (!mounted || msg == null) return;
                _message.text = msg;
              },
              onCommit: () async {
                final ok = await ref
                    .read(gitProvider.notifier)
                    .commit(_message.text.trim(), staged);
                if (!context.mounted) return;
                if (ok) {
                  _message.clear();
                  AppToast.show(context, 'Commit created');
                }
              },
            ),
          Expanded(
            child: changes == 0
                ? _EmptyChanges(hasCommits: status.hasCommits, state: state)
                : ListView(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    children: [
                      _SectionHeader(
                        title: 'Staged Changes',
                        count: staged.length,
                        actionLabel: 'Unstage All',
                        onAction: staged.isEmpty || state.busy
                            ? null
                            : () => unawaited(
                                ref.read(gitProvider.notifier).unstageAll(),
                              ),
                      ),
                      for (final f in staged)
                        _FileRow(
                          key: ValueKey('staged:$f'),
                          file: f,
                          status: 'S',
                          staged: true,
                          expanded: _expanded.contains('staged:$f'),
                          busy: state.busy,
                          diffState: _diffs['staged:$f'],
                          viewMode: _viewMode,
                          onToggle: () => _toggle('staged:$f', f),
                          onAction: () => unawaited(
                            ref.read(gitProvider.notifier).unstage([f]),
                          ),
                          onHunk: (i) => unawaited(
                            ref.read(gitProvider.notifier).unstageHunks(f, [i]),
                          ),
                        ),
                      const SizedBox(height: AppSpacing.sm),
                      _SectionHeader(
                        title: 'Changes',
                        count: unstaged.length,
                        actionLabel: 'Stage All',
                        onAction: unstaged.isEmpty || state.busy
                            ? null
                            : () => unawaited(
                                ref.read(gitProvider.notifier).stageAll(),
                              ),
                      ),
                      for (final e in unstaged)
                        _FileRow(
                          key: ValueKey('change:${e.$1}'),
                          file: e.$1,
                          status: e.$2,
                          staged: false,
                          expanded: _expanded.contains('change:${e.$1}'),
                          busy: state.busy,
                          diffState: _diffs['change:${e.$1}'],
                          viewMode: _viewMode,
                          onToggle: () => _toggle('change:${e.$1}', e.$1),
                          onAction: () => unawaited(
                            ref.read(gitProvider.notifier).stage([e.$1]),
                          ),
                          onDiscard: () =>
                              _discard(e.$1, untracked: e.$2 == 'U'),
                          onHunk: (i) => unawaited(
                            ref.read(gitProvider.notifier).stageHunks(e.$1, [
                              i,
                            ]),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _discard(String file, {required bool untracked}) async {
    final ok = await AppDialog.confirm(
      context,
      title: untracked ? 'Delete File' : 'Discard Changes',
      message: untracked
          ? 'Permanently delete "$file"?'
          : 'Discard all changes in "$file"?',
      confirmLabel: untracked ? 'Delete' : 'Discard',
    );
    if (!ok || !mounted) return;
    final ctrl = ref.read(gitProvider.notifier);
    final done = untracked
        ? await ctrl.deleteUntracked(file)
        : await ctrl.discard(file);
    if (!mounted) return;
    if (done) _diffs.remove('change:$file');
  }
}

// ─── Not-a-repo / empty states ────────────────────────────────────────────

class _NotGitView extends StatelessWidget {
  const _NotGitView({
    required this.busy,
    required this.error,
    required this.onInit,
  });

  final bool busy;
  final String? error;
  final VoidCallback onInit;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.alt_route, size: 40, color: c.mutedForeground),
          const SizedBox(height: AppSpacing.sm),
          Text('Not a git repository', style: t.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Initialize a repository to track changes.',
            style: t.bodySmall?.copyWith(color: c.mutedForeground),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            loading: busy,
            onPressed: onInit,
            child: const Text('Initialize repository'),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                error!,
                style: t.bodySmall?.copyWith(color: c.destructive),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyChanges extends StatelessWidget {
  const _EmptyChanges({required this.hasCommits, required this.state});

  final bool hasCommits;
  final GitState state;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Icon(Icons.check_circle_outline, size: 36, color: c.mutedForeground),
        const SizedBox(height: AppSpacing.sm),
        Text(
          hasCommits ? 'Working tree clean' : 'No commits yet',
          textAlign: TextAlign.center,
          style: t.titleSmall,
        ),
        if (state.commits.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Recent commits',
            style: t.labelSmall?.copyWith(color: c.mutedForeground),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final cm in state.commits.take(5))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Text(
                    cm.hash.length > 7 ? cm.hash.substring(0, 7) : cm.hash,
                    style: t.labelSmall?.copyWith(fontFamily: 'monospace'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      cm.message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      margin: const EdgeInsets.all(AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: c.destructive.withValues(alpha: 0.08),
        border: Border.all(color: c.destructive.withValues(alpha: 0.4)),
        borderRadius: AppRadii.borderMd,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: c.destructive),
            ),
          ),
          InkWell(
            onTap: onDismiss,
            child: Icon(Icons.close, size: 14, color: c.destructive),
          ),
        ],
      ),
    );
  }
}

// ─── Header: branch selector + remote + checkpoints ───────────────────────

class _GitHeader extends ConsumerWidget {
  const _GitHeader({
    required this.state,
    required this.viewMode,
    required this.onViewMode,
  });

  final GitState state;
  final GitDiffViewMode viewMode;
  final ValueChanged<GitDiffViewMode> onViewMode;

  Future<void> _newBranch(BuildContext context, WidgetRef ref) async {
    var input = '';
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'New branch',
        content: AppInput(
          hint: 'branch-name',
          autofocus: true,
          onChanged: (v) => input = v,
        ),
        actions: [
          AppButton(
            variant: AppButtonVariant.ghost,
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          AppButton(
            onPressed: () => Navigator.of(ctx).pop(input.trim()),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    final ctrl = ref.read(gitProvider.notifier);
    if (await ctrl.createBranch(name)) {
      await ctrl.checkout(name);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final remote = state.remoteStatus;
    final branches = state.branches;
    final current = state.status?.branch ?? 'no branch';
    final ctrl = ref.read(gitProvider.notifier);

    Widget remoteBtn(
      IconData icon,
      String label,
      int badge,
      VoidCallback? onTap,
    ) {
      return _HeaderButton(
        icon: icon,
        label: badge > 0 ? '$label $badge' : label,
        onPressed: state.busy ? null : onTap,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      child: Row(
        children: [
          PopupMenuButton<String>(
            tooltip: 'Switch branch',
            onSelected: (v) {
              if (v == '__new__') {
                unawaited(_newBranch(context, ref));
              } else if (v != current) {
                unawaited(ctrl.checkout(v));
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: '__new__',
                child: Row(
                  children: [
                    Icon(Icons.add, size: 14),
                    SizedBox(width: 8),
                    Text('New branch…'),
                  ],
                ),
              ),
              for (final b in branches.local)
                PopupMenuItem(
                  value: b,
                  child: Row(
                    children: [
                      Icon(
                        b == current ? Icons.check : Icons.alt_route,
                        size: 14,
                        color: b == current ? c.primary : c.mutedForeground,
                      ),
                      const SizedBox(width: 8),
                      Text(b),
                    ],
                  ),
                ),
              if (branches.remote.isNotEmpty) const PopupMenuDivider(),
              for (final b in branches.remote)
                PopupMenuItem(
                  value: b,
                  child: Row(
                    children: [
                      Icon(
                        Icons.cloud_outlined,
                        size: 14,
                        color: c.mutedForeground,
                      ),
                      const SizedBox(width: 8),
                      Text(b),
                    ],
                  ),
                ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.alt_route, size: 14, color: c.primary),
                  const SizedBox(width: 4),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 140),
                    child: Text(
                      current,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.labelMedium,
                    ),
                  ),
                  Icon(Icons.expand_more, size: 14, color: c.mutedForeground),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          if (remote.hasRemote) ...[
            remoteBtn(
              Icons.download_outlined,
              'Fetch',
              0,
              () => unawaited(ctrl.fetch()),
            ),
            remoteBtn(
              Icons.south,
              'Pull',
              remote.behind,
              () => unawaited(ctrl.pull()),
            ),
            remoteBtn(
              Icons.north,
              'Push',
              remote.ahead,
              () => unawaited(ctrl.push()),
            ),
          ],
          const Spacer(),
          _HeaderButton(
            icon: Icons.view_agenda_outlined,
            label: '',
            selected: viewMode == GitDiffViewMode.unified,
            tooltip: 'Unified diff',
            onPressed: () => onViewMode(GitDiffViewMode.unified),
          ),
          _HeaderButton(
            icon: Icons.vertical_split_outlined,
            label: '',
            selected: viewMode == GitDiffViewMode.split,
            tooltip: 'Split diff',
            onPressed: () => onViewMode(GitDiffViewMode.split),
          ),
          _HeaderButton(
            icon: Icons.flag_outlined,
            label: '',
            tooltip: 'Checkpoints',
            onPressed: () => unawaited(
              showDialog<void>(
                context: context,
                builder: (_) => const CheckpointsDialog(),
              ),
            ),
          ),
          _HeaderButton(
            icon: Icons.refresh,
            label: '',
            tooltip: 'Refresh',
            onPressed: state.busy ? null : () => unawaited(ctrl.refresh()),
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    required this.label,
    this.selected = false,
    this.tooltip,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final String? tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final color = selected ? c.primary : c.mutedForeground;
    return Tooltip(
      message: tooltip ?? label,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadii.borderMd,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: selected
              ? BoxDecoration(
                  color: c.primary.withValues(alpha: 0.1),
                  borderRadius: AppRadii.borderMd,
                )
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              if (label.isNotEmpty) ...[
                const SizedBox(width: 3),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: color),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sections, file rows, commit composer ─────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.count,
    required this.actionLabel,
    this.onAction,
  });

  final String title;
  final int count;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs, top: 2),
      child: Row(
        children: [
          Text(
            '$title ($count)',
            style: t.labelMedium?.copyWith(color: c.mutedForeground),
          ),
          const Spacer(),
          InkWell(
            onTap: onAction,
            borderRadius: AppRadii.borderMd,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 2,
              ),
              child: Text(
                actionLabel,
                style: t.labelSmall?.copyWith(
                  color: onAction == null ? c.mutedForeground : c.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const _statusColors = {
  'S': Color(0xFF2EA043),
  'M': Color(0xFFD29922),
  'A': Color(0xFF2EA043),
  'D': Color(0xFFF85149),
  'U': Color(0xFF8B949E),
};

class _FileRow extends StatelessWidget {
  const _FileRow({
    super.key,
    required this.file,
    required this.status,
    required this.staged,
    required this.expanded,
    required this.busy,
    required this.diffState,
    required this.viewMode,
    required this.onToggle,
    required this.onAction,
    required this.onHunk,
    this.onDiscard,
  });

  final String file;
  final String status;
  final bool staged;
  final bool expanded;
  final bool busy;
  final Object? diffState;
  final GitDiffViewMode viewMode;
  final VoidCallback onToggle;
  final VoidCallback onAction;
  final ValueChanged<int> onHunk;
  final VoidCallback? onDiscard;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final color = _statusColors[status] ?? c.mutedForeground;
    final name = file.split('/').last;
    final dir = file.length > name.length
        ? file.substring(0, file.length - name.length)
        : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: AppRadii.borderMd,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 6,
              ),
              child: Row(
                children: [
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    size: 14,
                    color: c.mutedForeground,
                  ),
                  Container(
                    width: 18,
                    height: 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: color.withValues(alpha: 0.5)),
                      borderRadius: AppRadii.borderSm,
                    ),
                    child: Text(
                      status,
                      style: t.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: name,
                        style: t.bodySmall,
                        children: [
                          if (dir.isNotEmpty)
                            TextSpan(
                              text: '  $dir',
                              style: t.labelSmall?.copyWith(
                                color: c.mutedForeground,
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _FileAction(
                    icon: staged ? Icons.remove : Icons.add,
                    tooltip: staged ? 'Unstage' : 'Stage',
                    onPressed: busy ? null : onAction,
                  ),
                  if (!staged)
                    _FileAction(
                      icon: status == 'U' ? Icons.delete_outline : Icons.undo,
                      tooltip: status == 'U'
                          ? 'Delete file'
                          : 'Discard changes',
                      destructive: true,
                      onPressed: busy ? null : onDiscard,
                    ),
                ],
              ),
            ),
          ),
          if (expanded)
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: c.border)),
              ),
              child: _diffArea(context),
            ),
        ],
      ),
    );
  }

  Widget _diffArea(BuildContext context) {
    final d = diffState;
    if (d == null) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (d is! String) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Text(
          'Failed to load diff: $d',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }
    return GitDiffViewer(
      diff: d,
      viewMode: viewMode,
      hunkAction: GitDiffHunkAction(
        isAdd: !staged,
        tooltip: staged ? 'Unstage hunk' : 'Stage hunk',
        onAction: onHunk,
      ),
    );
  }
}

class _FileAction extends StatelessWidget {
  const _FileAction({
    required this.icon,
    required this.tooltip,
    this.destructive = false,
    this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final bool destructive;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 15,
        color: destructive ? c.destructive : c.mutedForeground,
      ),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 26, height: 26),
    );
  }
}

class _CommitComposer extends ConsumerStatefulWidget {
  const _CommitComposer({
    required this.message,
    required this.busy,
    required this.stagedCount,
    required this.onGenerate,
    required this.onCommit,
  });

  final TextEditingController message;
  final bool busy;
  final int stagedCount;
  final Future<void> Function() onGenerate;
  final Future<void> Function() onCommit;

  @override
  ConsumerState<_CommitComposer> createState() => _CommitComposerState();
}

class _CommitComposerState extends ConsumerState<_CommitComposer> {
  bool _generating = false;

  @override
  void initState() {
    super.initState();
    widget.message.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.message.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final canCommit =
        !widget.busy &&
        widget.message.text.trim().isNotEmpty &&
        widget.stagedCount > 0;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AppInput(
              controller: widget.message,
              hint: 'Commit message',
              maxLines: 2,
              enabled: !widget.busy,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            children: [
              AppButton(
                variant: AppButtonVariant.ghost,
                size: AppButtonSize.sm,
                loading: _generating,
                onPressed: () async {
                  setState(() => _generating = true);
                  try {
                    await widget.onGenerate();
                  } finally {
                    if (mounted) setState(() => _generating = false);
                  }
                },
                child: const Text('✦ AI'),
              ),
              const SizedBox(height: AppSpacing.xs),
              AppButton(
                size: AppButtonSize.sm,
                loading: widget.busy,
                onPressed: canCommit ? widget.onCommit : null,
                child: const Text('Commit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
