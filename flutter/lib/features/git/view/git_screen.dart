import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/core/widgets/subpage_header.dart';
import 'package:ddagent_app/features/git/data/git_models.dart';
import 'package:ddagent_app/features/git/data/git_repository.dart';
import 'package:ddagent_app/features/git/state/git_controller.dart';
import 'package:ddagent_app/features/git/view/checkpoints_dialog.dart';
import 'package:ddagent_app/features/git/view/git_branches.dart';
import 'package:ddagent_app/features/git/view/git_confirm.dart';
import 'package:ddagent_app/features/git/view/git_diff_viewer.dart';
import 'package:ddagent_app/features/git/view/git_history.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/projects/view/project_menu_button.dart';
import 'package:ddagent_app/features/worktrees/view/worktrees_screen.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Git/version-control panel (port of GitPanel.tsx): branch+remote toolbar,
/// Changes/Commits/Branches/Worktrees view tabs, staged/changes lists with
/// per-file diffs and hunk staging, commit composer, checkpoints. Mounted
/// standalone via /git and as a workspace pane (PaneKind.git).
enum _GitView { changes, history, branches, worktrees }

class GitScreen extends ConsumerStatefulWidget {
  const GitScreen({super.key, this.projectId, this.standalone = false});

  final String? projectId;

  /// `/git` route embeds the SubpageHeader (back-to-chat + project picker);
  /// workspace panes render their own chrome and pass `standalone: false`.
  final bool standalone;

  @override
  ConsumerState<GitScreen> createState() => _GitScreenState();
}

class _GitScreenState extends ConsumerState<GitScreen> {
  final _message = TextEditingController();
  final _expanded = <String>{};
  _GitView _view = _GitView.changes;

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
      final pid = widget.projectId ?? ref.read(projectsProvider).projects.firstOrNull?.projectId;
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
      final res = await ref.read(gitRepositoryProvider).diff(pid, filePath: file);
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
    final i18n = Translations.of(context);
    final status = state.status;
    final projects = ref.watch(projectsProvider).projects;

    Widget content;
    if (status != null && status.notGitRepository) {
      content = _NotGitView(
        busy: state.busy,
        error: state.error,
        onInit: () => unawaited(ref.read(gitProvider.notifier).init()),
      );
    } else if (status == null && state.loading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (status == null) {
      content = Center(
        child: Text(
          state.error ?? i18n.git.selectProject,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: c.mutedForeground),
        ),
      );
    } else {
      content = _buildBody(state, status, c);
    }

    if (!widget.standalone) return content;
    final active = projects.where((p) => p.projectId == state.projectId).firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SubpageHeader(
          icon: LucideIcons.gitBranch,
          children: [
            if (projects.isNotEmpty)
              ProjectMenuButton(
                projects: projects,
                selected: active,
                onSelected: (p) => ref.read(gitProvider.notifier).selectProject(p.projectId),
              ),
          ],
        ),
        Expanded(child: content),
      ],
    );
  }

  Widget _buildBody(GitState state, GitStatus status, AppColors c) {
    final staged = status.staged;
    final unstaged = [
      for (final f in status.modified) (f, 'M'),
      for (final f in status.added) (f, 'A'),
      for (final f in status.deleted) (f, 'D'),
      for (final f in status.untracked) (f, 'U'),
    ];
    final changes = staged.length + unstaged.length;
    // Web `hasExpandedFiles` — an open file diff collapses the tabs and the
    // commit composer so the diff gets the whole pane.
    final hasExpanded = _expanded.isNotEmpty;

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
          if (!hasExpanded)
            _ViewTabs(
              view: _view,
              changeCount: changes,
              onChange: (v) => setState(() => _view = v),
            ),
          Expanded(
            child: switch (_view) {
              _GitView.changes => _changesTab(state, status, staged, unstaged, hasExpanded),
              _GitView.history => GitHistoryView(viewMode: _viewMode),
              _GitView.branches => const GitBranchesView(),
              _GitView.worktrees => WorktreesScreen(projectId: state.projectId),
            },
          ),
        ],
      ),
    );
  }

  Widget _changesTab(
    GitState state,
    GitStatus status,
    List<String> staged,
    List<(String, String)> unstaged,
    bool hasExpanded,
  ) {
    final i18n = Translations.of(context);
    final changes = staged.length + unstaged.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Web CommitComposer renders always when no file diff is expanded —
        // it collapses to a pill on mobile or when the tree is clean.
        if (!hasExpanded)
          _CommitComposer(
            message: _message,
            busy: state.busy,
            stagedCount: staged.length,
            hasChanges: changes > 0,
            collapsed: context.breakpoint.isCompact,
            onGenerate: () async {
              final files = staged.isNotEmpty ? staged : [for (final e in unstaged) e.$1];
              final msg = await ref.read(gitProvider.notifier).generateCommitMessage(files);
              if (!mounted || msg == null) return;
              _message.text = msg;
            },
            onCommit: () => _commit(staged),
          ),
        // FileStatusLegend — desktop only in the web UI.
        if (!context.breakpoint.isCompact) const _FileStatusLegend(),
        Expanded(
          child: !status.hasCommits && changes > 0
              ? _InitialCommitEmpty(state: state)
              : changes == 0
              ? _EmptyChanges(
                  state: state,
                  onOpenHistory: () => setState(() => _view = _GitView.history),
                )
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  children: [
                    _SectionHeader(
                      title: i18n.git.stagedChanges,
                      count: staged.length,
                      actionLabel: i18n.common.gitPanel.unstageAll,
                      onAction: staged.isEmpty || state.busy
                          ? null
                          : () => unawaited(ref.read(gitProvider.notifier).unstageAll()),
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
                        onToggleStaged: state.busy
                            ? null
                            : () => unawaited(ref.read(gitProvider.notifier).unstage([f])),
                        onHunk: (i) =>
                            unawaited(ref.read(gitProvider.notifier).unstageHunks(f, [i])),
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    _SectionHeader(
                      title: i18n.common.gitPanel.tabs.changes,
                      count: unstaged.length,
                      actionLabel: i18n.common.gitPanel.stageAll,
                      onAction: unstaged.isEmpty || state.busy
                          ? null
                          : () => unawaited(ref.read(gitProvider.notifier).stageAll()),
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
                        onToggleStaged: state.busy
                            ? null
                            : () => unawaited(ref.read(gitProvider.notifier).stage([e.$1])),
                        onDiscard: () => _discard(e.$1, untracked: e.$2 == 'U'),
                        onHunk: (i) =>
                            unawaited(ref.read(gitProvider.notifier).stageHunks(e.$1, [i])),
                      ),
                  ],
                ),
        ),
      ],
    );
  }

  /// CommitComposer → web confirms the commit first ('commit' type).
  Future<void> _commit(List<String> staged) async {
    final message = _message.text.trim();
    if (message.isEmpty || staged.isEmpty) return;
    final i18n = Translations.of(context);
    final res = await gitConfirm(
      context,
      type: GitConfirmType.commit,
      message: i18n.common.gitPanel.confirmCommit(count: staged.length, message: message),
    );
    if (res != false || !mounted) return;
    final ok = await ref.read(gitProvider.notifier).commit(message, staged);
    if (!mounted) return;
    if (ok) {
      _message.clear();
      AppToast.show(context, i18n.git.commitCreated);
    }
  }

  Future<void> _discard(String file, {required bool untracked}) async {
    final i18n = Translations.of(context);
    final res = await gitConfirm(
      context,
      type: untracked ? GitConfirmType.delete : GitConfirmType.discard,
      message: untracked
          ? i18n.common.gitPanel.confirmDeleteFile(file: file)
          : i18n.common.gitPanel.confirmDiscardFile(file: file),
    );
    if (res != false || !mounted) return;
    final ctrl = ref.read(gitProvider.notifier);
    final done = untracked ? await ctrl.deleteUntracked(file) : await ctrl.discard(file);
    if (!mounted) return;
    if (done) _diffs.remove('change:$file');
  }
}

// ─── Not-a-repo / empty states ────────────────────────────────────────────

class _NotGitView extends StatelessWidget {
  const _NotGitView({required this.busy, required this.error, required this.onInit});

  final bool busy;
  final String? error;
  final VoidCallback onInit;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: c.muted, borderRadius: BorderRadius.circular(12)),
            child: Icon(LucideIcons.gitBranch, size: 24, color: c.mutedForeground),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            i18n.common.gitPanel.noRepo.title,
            style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              i18n.common.gitPanel.noRepo.description,
              textAlign: TextAlign.center,
              style: t.bodySmall?.copyWith(color: c.mutedForeground),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            loading: busy,
            onPressed: onInit,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.gitBranch, size: 16),
                const SizedBox(width: 6),
                Text(i18n.common.gitPanel.noRepo.init),
              ],
            ),
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

/// `hasCommits === false && hasChangedFiles` EmptyState — the repo is a git
/// repo but nothing has been committed yet.
class _InitialCommitEmpty extends ConsumerWidget {
  const _InitialCommitEmpty({required this.state});

  final GitState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.gitBranch, size: 36, color: c.mutedForeground),
            const SizedBox(height: AppSpacing.sm),
            Text(i18n.common.gitPanel.noCommits.title, style: t.titleSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              i18n.common.gitPanel.noCommits.description,
              textAlign: TextAlign.center,
              style: t.bodySmall?.copyWith(color: c.mutedForeground),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              loading: state.busy,
              onPressed: () => unawaited(ref.read(gitProvider.notifier).initialCommit()),
              child: Text(i18n.common.gitPanel.noCommits.create),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyChanges extends StatelessWidget {
  const _EmptyChanges({required this.state, this.onOpenHistory});

  final GitState state;

  /// "View all" link next to the recent-commits header → Commits tab.
  final VoidCallback? onOpenHistory;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Icon(LucideIcons.gitCommitHorizontal, size: 36, color: c.mutedForeground),
        const SizedBox(height: AppSpacing.sm),
        Text(i18n.common.gitPanel.noChanges, textAlign: TextAlign.center, style: t.titleSmall),
        if (state.commits.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Text(
                i18n.common.gitPanel.recentCommits,
                style: t.labelSmall?.copyWith(color: c.mutedForeground),
              ),
              const Spacer(),
              if (onOpenHistory != null)
                InkWell(
                  onTap: onOpenHistory,
                  child: Text(
                    i18n.common.gitPanel.viewAll,
                    style: t.labelSmall?.copyWith(color: c.primary),
                  ),
                ),
            ],
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.destructive),
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
  const _GitHeader({required this.state, required this.viewMode, required this.onViewMode});

  final GitState state;
  final GitDiffViewMode viewMode;
  final ValueChanged<GitDiffViewMode> onViewMode;

  Future<void> _revertLatest(BuildContext context, WidgetRef ref) async {
    final i18n = Translations.of(context);
    final res = await gitConfirm(
      context,
      type: GitConfirmType.revert,
      message: i18n.common.gitPanel.confirmRevert,
    );
    if (res != false || !context.mounted) return;
    await ref.read(gitProvider.notifier).revertLocalCommit();
  }

  /// GitPanelHeader remote ops — pull/push/publish all go through
  /// ConfirmActionModal first (fetch doesn't).
  Future<void> _remoteOp(
    BuildContext context,
    WidgetRef ref,
    GitConfirmType type,
    String message,
    Future<bool> Function(GitController ctrl) op,
  ) async {
    final res = await gitConfirm(context, type: type, message: message);
    if (res != false || !context.mounted) return;
    await op(ref.read(gitProvider.notifier));
  }

  Future<void> _newBranch(BuildContext context, WidgetRef ref) async {
    final i18n = Translations.of(context);
    var input = '';
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AppDialog(
        title: i18n.common.gitPanel.branches.kNew,
        content: AppInput(hint: 'branch-name', autofocus: true, onChanged: (v) => input = v),
        actions: [
          AppButton(
            variant: AppButtonVariant.ghost,
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(i18n.chat.orchestrator.summary.cancelTasks),
          ),
          AppButton(
            onPressed: () => Navigator.of(ctx).pop(input.trim()),
            child: Text(i18n.common.buttons.create),
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
    final i18n = Translations.of(context);
    final remote = state.remoteStatus;
    final branches = state.branches;
    final current = state.status?.branch ?? i18n.git.noBranch;
    final ctrl = ref.read(gitProvider.notifier);

    Widget remoteBtn(IconData icon, String label, int badge, VoidCallback? onTap) {
      return _HeaderButton(
        icon: icon,
        label: badge > 0 ? '$label $badge' : label,
        onPressed: state.busy ? null : onTap,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      child: Row(
        children: [
          PopupMenuButton<String>(
            tooltip: i18n.git.switchBranch,
            onSelected: (v) {
              if (v == '__new__') {
                unawaited(_newBranch(context, ref));
              } else if (v != current) {
                unawaited(ctrl.checkout(v));
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: '__new__',
                child: Row(
                  children: [
                    const Icon(Icons.add, size: 14),
                    const SizedBox(width: 8),
                    // Ellipsis retained from the original literal: the widget
                    // tests locate this menu item by its full text.
                    Text('${i18n.common.gitPanel.branches.kNew}…'),
                  ],
                ),
              ),
              for (final b in branches.local)
                PopupMenuItem(
                  value: b,
                  child: Row(
                    children: [
                      Icon(
                        b == current ? LucideIcons.check : LucideIcons.gitBranch,
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
                      Icon(LucideIcons.cloud, size: 14, color: c.mutedForeground),
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
                  Icon(LucideIcons.gitBranch, size: 14, color: c.primary),
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
                  Icon(LucideIcons.chevronDown, size: 14, color: c.mutedForeground),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          if (remote.hasRemote) ...[
            remoteBtn(
              LucideIcons.download,
              i18n.common.gitPanel.fetch,
              0,
              () => unawaited(ctrl.fetch()),
            ),
            remoteBtn(
              LucideIcons.arrowDown,
              i18n.common.gitPanel.pull,
              remote.behind,
              () => unawaited(
                _remoteOp(
                  context,
                  ref,
                  GitConfirmType.pull,
                  i18n.common.gitPanel.confirmPull(
                    count: remote.behind,
                    remote: remote.remoteName ?? 'remote',
                  ),
                  (ctrl) => ctrl.pull(),
                ),
              ),
            ),
            remoteBtn(
              LucideIcons.arrowUp,
              i18n.common.gitPanel.push,
              remote.ahead,
              () => unawaited(
                _remoteOp(
                  context,
                  ref,
                  GitConfirmType.push,
                  i18n.common.gitPanel.confirmPush(
                    count: remote.ahead,
                    remote: remote.remoteName ?? 'remote',
                  ),
                  (ctrl) => ctrl.push(),
                ),
              ),
            ),
            // Publish shows only when the branch has no upstream yet.
            if (!remote.hasUpstream)
              remoteBtn(
                LucideIcons.upload,
                i18n.common.gitPanel.publish,
                0,
                () => unawaited(
                  _remoteOp(
                    context,
                    ref,
                    GitConfirmType.publish,
                    i18n.common.gitPanel.confirmPublish(
                      branch: current,
                      remote: remote.remoteName ?? 'remote',
                    ),
                    (ctrl) => ctrl.publish(),
                  ),
                ),
              ),
          ],
          const Spacer(),
          _HeaderButton(
            icon: LucideIcons.rows3,
            label: '',
            selected: viewMode == GitDiffViewMode.unified,
            tooltip: i18n.git.unifiedDiff,
            onPressed: () => onViewMode(GitDiffViewMode.unified),
          ),
          _HeaderButton(
            icon: LucideIcons.columns2,
            label: '',
            selected: viewMode == GitDiffViewMode.split,
            tooltip: i18n.git.splitDiff,
            onPressed: () => onViewMode(GitDiffViewMode.split),
          ),
          _HeaderButton(
            icon: LucideIcons.undo2,
            label: '',
            tooltip: i18n.common.gitPanel.revertLatest,
            onPressed: state.busy || state.commits.isEmpty
                ? null
                : () => unawaited(_revertLatest(context, ref)),
          ),
          _HeaderButton(
            icon: LucideIcons.flag,
            label: '',
            tooltip: i18n.git.checkpoints.title,
            onPressed: () => unawaited(
              showDialog<void>(context: context, builder: (_) => const CheckpointsDialog()),
            ),
          ),
          _HeaderButton(
            icon: LucideIcons.refreshCw,
            label: '',
            tooltip: i18n.common.buttons.refresh,
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
                Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color)),
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
          Text('$title ($count)', style: t.labelMedium?.copyWith(color: c.mutedForeground)),
          const Spacer(),
          InkWell(
            onTap: onAction,
            borderRadius: AppRadii.borderMd,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
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
    required this.onToggleStaged,
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

  /// Leading checkbox bound to the git index — web FileChangeItem: checked =
  /// staged, toggling runs stage/unstage. Null while a mutation is in flight.
  final VoidCallback? onToggleStaged;
  final ValueChanged<int> onHunk;
  final VoidCallback? onDiscard;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final color = _statusColors[status] ?? c.mutedForeground;
    final name = file.split('/').last;
    final dir = file.length > name.length ? file.substring(0, file.length - name.length) : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: AppRadii.borderMd,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Checkbox(
                      value: staged,
                      onChanged: onToggleStaged == null ? null : (_) => onToggleStaged!(),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
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
                      style: t.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w600),
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
                              style: t.labelSmall?.copyWith(color: c.mutedForeground, fontSize: 10),
                            ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!staged)
                    _FileAction(
                      icon: status == 'U' ? Icons.delete_outline : Icons.undo,
                      tooltip: status == 'U'
                          ? i18n.git.deleteFile
                          : i18n.common.gitPanel.discardChanges,
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
    final i18n = Translations.of(context);
    final d = diffState;
    if (d == null) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Center(
          child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );
    }
    if (d is! String) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Text(
          i18n.git.loadDiffFailed(error: d),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }
    return GitDiffViewer(
      diff: d,
      viewMode: viewMode,
      hunkAction: GitDiffHunkAction(
        isAdd: !staged,
        tooltip: staged ? i18n.git.unstageHunk : i18n.git.stageHunk,
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
      icon: Icon(icon, size: 15, color: destructive ? c.destructive : c.mutedForeground),
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
    required this.hasChanges,
    required this.collapsed,
  });

  final TextEditingController message;
  final bool busy;
  final int stagedCount;
  final Future<void> Function() onGenerate;
  final Future<void> Function() onCommit;

  /// Web `hasChanges` — drives the collapsed pill copy.
  final bool hasChanges;

  /// Web `isMobile` — compact layouts start collapsed even with changes.
  final bool collapsed;

  @override
  ConsumerState<_CommitComposer> createState() => _CommitComposerState();
}

class _CommitComposerState extends ConsumerState<_CommitComposer> {
  bool _generating = false;

  /// Web `isCollapsed = isMobile || !hasChanges`, re-collapses on change.
  late bool _collapsed;

  @override
  void initState() {
    super.initState();
    _collapsed = widget.collapsed || !widget.hasChanges;
    widget.message.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(_CommitComposer old) {
    super.didUpdateWidget(old);
    if (old.hasChanges != widget.hasChanges || old.collapsed != widget.collapsed) {
      _collapsed = widget.collapsed || !widget.hasChanges;
    }
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
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final canCommit =
        !widget.busy && widget.message.text.trim().isNotEmpty && widget.stagedCount > 0;

    if (_collapsed) {
      // Collapsed pill — "Commit N file(s)" or "No changes to commit".
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.border)),
        ),
        child: InkWell(
          onTap: () => setState(() => _collapsed = false),
          borderRadius: AppRadii.borderMd,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: widget.hasChanges ? c.primary : null,
              border: widget.hasChanges ? null : Border.all(color: c.border),
              borderRadius: AppRadii.borderMd,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.gitCommitHorizontal,
                  size: 16,
                  color: widget.hasChanges ? Colors.white : c.mutedForeground,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.hasChanges
                      ? i18n.common.gitPanel.commitFiles(count: widget.stagedCount)
                      : i18n.common.gitPanel.noChangesToCommit,
                  style: t.bodyMedium?.copyWith(
                    color: widget.hasChanges ? Colors.white : c.mutedForeground,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  LucideIcons.chevronDown,
                  size: 12,
                  color: widget.hasChanges ? Colors.white : c.mutedForeground,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      child: Column(
        children: [
          // Header + re-collapse control — only when the collapsed state
          // would be reachable again (mobile or clean tree).
          if (widget.collapsed || !widget.hasChanges)
            Row(
              children: [
                Text(i18n.common.gitPanel.commitChanges, style: t.titleSmall),
                const Spacer(),
                InkWell(
                  onTap: () => setState(() => _collapsed = true),
                  child: Icon(LucideIcons.chevronUp, size: 16, color: c.mutedForeground),
                ),
              ],
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppInput(
                  controller: widget.message,
                  hint: i18n.git.commitMessage,
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
                    onPressed: widget.stagedCount == 0
                        ? null
                        : () async {
                            setState(() => _generating = true);
                            try {
                              await widget.onGenerate();
                            } finally {
                              if (mounted) {
                                setState(() => _generating = false);
                              }
                            }
                          },
                    child: Text(i18n.git.aiButton),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppButton(
                    size: AppButtonSize.sm,
                    loading: widget.busy,
                    onPressed: canCommit ? widget.onCommit : null,
                    child: Text(i18n.common.gitPanel.commit),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── View tabs (web GitViewTabs) ──────────────────────────────────────────

class _ViewTabs extends StatelessWidget {
  const _ViewTabs({required this.view, required this.changeCount, required this.onChange});

  final _GitView view;
  final int changeCount;
  final ValueChanged<_GitView> onChange;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);

    Widget tab(_GitView v, String label, {int? count}) {
      final selected = view == v;
      return InkWell(
        onTap: selected ? null : () => onChange(v),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 2, color: selected ? c.primary : Colors.transparent),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: t.labelMedium?.copyWith(
                  color: selected ? c.foreground : c.mutedForeground,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              if (count != null && count > 0) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(color: c.muted, borderRadius: AppRadii.borderSm),
                  child: Text(
                    '$count',
                    style: t.labelSmall?.copyWith(color: c.mutedForeground, fontSize: 10),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      child: Row(
        children: [
          tab(_GitView.changes, i18n.common.gitPanel.tabs.changes, count: changeCount),
          tab(_GitView.history, i18n.common.gitPanel.tabs.history),
          tab(_GitView.branches, i18n.common.gitPanel.tabs.branches),
          tab(_GitView.worktrees, i18n.common.gitPanel.tabs.worktrees),
        ],
      ),
    );
  }
}

// ─── File status legend (web FileStatusLegend — desktop only) ─────────────

class _FileStatusLegend extends StatelessWidget {
  const _FileStatusLegend();

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final entries = [
      ('M', i18n.common.gitPanel.status.modified),
      ('A', i18n.common.gitPanel.status.added),
      ('D', i18n.common.gitPanel.status.deleted),
      ('U', i18n.common.gitPanel.status.untracked),
      ('S', i18n.git.statusStaged),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      child: Row(
        children: [
          for (final e in entries)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _statusColors[e.$1]!.withValues(alpha: 0.15),
                      borderRadius: AppRadii.borderSm,
                    ),
                    child: Text(
                      e.$1,
                      style: t.labelSmall?.copyWith(
                        color: _statusColors[e.$1],
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(e.$2, style: t.labelSmall?.copyWith(color: c.mutedForeground, fontSize: 10)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
