import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/worktrees/data/worktrees_models.dart';
import 'package:ddagent_app/features/worktrees/state/worktrees_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen displaying Git worktrees for a project: list, create, open, merge, remove,
/// script config and run/stop execution.
class WorktreesScreen extends ConsumerStatefulWidget {
  const WorktreesScreen({super.key, this.projectId});

  final String? projectId;

  @override
  ConsumerState<WorktreesScreen> createState() => _WorktreesScreenState();
}

class _WorktreesScreenState extends ConsumerState<WorktreesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(projectsProvider.notifier).load();
      final pid = widget.projectId ?? ref.read(projectsProvider).projects.firstOrNull?.projectId;
      ref.read(worktreesProvider.notifier).selectProject(pid);
    });
  }

  @override
  void didUpdateWidget(covariant WorktreesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.projectId != widget.projectId) {
      ref.read(worktreesProvider.notifier).selectProject(widget.projectId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(worktreesProvider);
    final ctrl = ref.read(worktreesProvider.notifier);
    final projects = ref.watch(projectsProvider).projects;
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final compact = context.breakpoint.isCompact;
    final i18n = Translations.of(context);

    final selectedProject = projects.cast<Project?>().firstWhere(
      (p) => p?.projectId == state.projectId,
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Top action bar
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: c.border)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Icon(Icons.fork_right, size: 20, color: c.mutedForeground),
                    const SizedBox(width: AppSpacing.xs),
                    Text(i18n.common.gitPanel.tabs.worktrees, style: t.titleSmall),
                    const SizedBox(width: AppSpacing.md),
                    // Project selector
                    if (projects.isNotEmpty)
                      DropdownButton<String>(
                        value: selectedProject?.projectId ?? projects.first.projectId,
                        underline: const SizedBox.shrink(),
                        items: [
                          for (final p in projects)
                            DropdownMenuItem(
                              value: p.projectId,
                              child: Text(
                                p.displayName.isNotEmpty ? p.displayName : p.projectId,
                                style: t.bodySmall,
                              ),
                            ),
                        ],
                        onChanged: (newId) {
                          if (newId != null) ctrl.selectProject(newId);
                        },
                      ),
                    const SizedBox(width: AppSpacing.sm),
                    AppButton(
                      variant: AppButtonVariant.ghost,
                      size: AppButtonSize.sm,
                      onPressed: state.loading ? null : ctrl.refresh,
                      child: const Icon(Icons.refresh, size: 16),
                    ),
                    const SizedBox(width: 4),
                    AppButton(
                      variant: AppButtonVariant.ghost,
                      size: AppButtonSize.sm,
                      onPressed: state.projectId == null
                          ? null
                          : () => _WorktreeScriptsDialog.show(
                              context,
                              config: state.scriptsStatus?.scripts,
                              onSave: (setup, run, port) =>
                                  ctrl.saveConfig(setup: setup, run: run, runPort: port),
                            ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.code, size: 16),
                          if (!compact) ...[const SizedBox(width: 4), Text(i18n.worktrees.scripts)],
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    AppButton(
                      size: AppButtonSize.sm,
                      onPressed: state.projectId == null
                          ? null
                          : () => _NewWorktreeDialog.show(
                              context,
                              baseBranch: state.baseBranch,
                              onCreate: (branch, baseBranch) =>
                                  ctrl.createWorktree(branch, baseBranch: baseBranch),
                            ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, size: 16),
                          if (!compact) ...[
                            const SizedBox(width: 4),
                            Text(i18n.common.gitPanel.worktrees.kNew),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (state.error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
                color: c.destructive.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(state.error!, style: t.bodySmall?.copyWith(color: c.destructive)),
                    ),
                    InkWell(
                      onTap: ctrl.clearError,
                      child: Icon(Icons.close, size: 14, color: c.destructive),
                    ),
                  ],
                ),
              ),

            // Content
            Expanded(
              child: state.loading && state.worktrees.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : state.worktrees.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.fork_right, size: 48, color: c.mutedForeground),
                          const SizedBox(height: AppSpacing.sm),
                          Text(i18n.worktrees.emptyTitle, style: t.titleMedium),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            i18n.worktrees.emptyDescription,
                            style: t.bodySmall?.copyWith(color: c.mutedForeground),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppButton(
                            onPressed: () => _NewWorktreeDialog.show(
                              context,
                              baseBranch: state.baseBranch,
                              onCreate: (branch, baseBranch) =>
                                  ctrl.createWorktree(branch, baseBranch: baseBranch),
                            ),
                            child: Text(i18n.common.gitPanel.worktrees.createFirst),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: state.worktrees.length,
                      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final item = state.worktrees[index];
                        final runtime = state.runtimeFor(item.path);
                        final isBusy = state.busyWorktreePath == item.path;
                        return _WorktreeCard(
                          worktree: item,
                          runtime: runtime,
                          baseBranch: state.baseBranch,
                          isBusy: isBusy,
                          onOpen: () async {
                            final proj = await ctrl.openWorktree(item.path);
                            if (context.mounted && proj != null) {
                              AppToast.show(
                                context,
                                i18n.worktrees.opened(branch: item.branch ?? ''),
                              );
                            }
                          },
                          onMerge: () => _MergeWorktreeDialog.show(
                            context,
                            worktree: item,
                            baseBranch: state.baseBranch,
                            onMerge: (squash, msg, removeAfter) => ctrl.mergeWorktree(
                              item.path,
                              squash: squash,
                              message: msg,
                              removeAfterMerge: removeAfter,
                            ),
                          ),
                          onRemove: () => _RemoveWorktreeDialog.show(
                            context,
                            worktree: item,
                            onRemove: (force, deleteBranch) => ctrl.removeWorktree(
                              item.path,
                              force: force,
                              deleteBranch: deleteBranch,
                            ),
                          ),
                          onRunScript: () {
                            final targetId = item.linkedProjectId ?? state.projectId;
                            if (targetId != null) ctrl.runScript(targetId);
                          },
                          onStopScript: () {
                            final targetId = item.linkedProjectId ?? state.projectId;
                            if (targetId != null) ctrl.stopScript(targetId);
                          },
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

// ─── Worktree Card ──────────────────────────────────────────────────────────

class _WorktreeCard extends StatelessWidget {
  const _WorktreeCard({
    required this.worktree,
    required this.runtime,
    required this.baseBranch,
    required this.isBusy,
    required this.onOpen,
    required this.onMerge,
    required this.onRemove,
    required this.onRunScript,
    required this.onStopScript,
  });

  final WorktreeDescriptor worktree;
  final WorktreeRuntimeInfo? runtime;
  final String? baseBranch;
  final bool isBusy;
  final VoidCallback onOpen;
  final VoidCallback onMerge;
  final VoidCallback onRemove;
  final VoidCallback onRunScript;
  final VoidCallback onStopScript;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);

    final isMain = worktree.isMain;
    final branchName =
        worktree.branch ??
        (worktree.isDetached
            ? i18n.worktrees.headDetachedAt(sha: worktree.headSha?.substring(0, 7) ?? 'unknown')
            : i18n.common.gitPanel.worktrees.detached);

    final runStatus = runtime?.run.status ?? 'idle';
    final isRunRunning = runStatus == 'running';

    return Container(
      decoration: BoxDecoration(
        color: c.card,
        border: Border.all(color: worktree.isCurrent ? c.primary.withValues(alpha: 0.6) : c.border),
        borderRadius: AppRadii.borderMd,
      ),
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon + Branch + Badges + Actions
          Row(
            children: [
              Icon(
                isMain ? Icons.home_outlined : Icons.fork_right,
                size: 18,
                color: isMain ? c.primary : c.mutedForeground,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        branchName,
                        style: t.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isMain) ...[
                      const SizedBox(width: 6),
                      _badge(context, i18n.worktrees.mainBadge, c.primary),
                    ],
                    if (worktree.isCurrent) ...[
                      const SizedBox(width: 6),
                      _badge(context, i18n.common.gitPanel.branches.current, c.accent),
                    ],
                    if (worktree.isLocked) ...[
                      const SizedBox(width: 6),
                      _badge(context, i18n.common.gitPanel.worktrees.locked, c.destructive),
                    ],
                  ],
                ),
              ),
              if (isBusy)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else ...[
                AppButton(
                  variant: AppButtonVariant.ghost,
                  size: AppButtonSize.sm,
                  onPressed: onOpen,
                  child: Text(i18n.common.gitPanel.worktrees.open),
                ),
                if (!isMain) ...[
                  AppButton(
                    variant: AppButtonVariant.ghost,
                    size: AppButtonSize.sm,
                    onPressed: onMerge,
                    child: Text(i18n.common.gitPanel.mergeWorktree.merge),
                  ),
                  AppButton(
                    variant: AppButtonVariant.ghost,
                    size: AppButtonSize.sm,
                    onPressed: onRemove,
                    child: Icon(Icons.delete_outline, size: 16, color: c.destructive),
                  ),
                ],
              ],
            ],
          ),

          const SizedBox(height: AppSpacing.xs),

          // Meta info: Path, Ahead/Behind, Changed files, Commits
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                worktree.shortPath,
                style: t.labelSmall?.copyWith(fontFamily: 'monospace', color: c.mutedForeground),
              ),
              if (worktree.changedFileCount > 0)
                _badge(
                  context,
                  i18n.common.gitPanel.worktrees.changes(count: worktree.changedFileCount),
                  Colors.amber,
                ),
              if (worktree.ahead > 0 || worktree.behind > 0)
                Text(
                  '${worktree.ahead}↑ ${worktree.behind}↓',
                  style: t.labelSmall?.copyWith(color: c.mutedForeground),
                ),
              if (worktree.lastCommitSubject != null)
                Text(
                  worktree.lastCommitSubject!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.labelSmall?.copyWith(color: c.mutedForeground),
                ),
            ],
          ),

          // Script execution bar (if scripts configured or runtime present)
          if (runtime != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: c.muted.withValues(alpha: 0.4),
                borderRadius: AppRadii.borderSm,
              ),
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Setup script status
                      if (runtime!.setup.status != 'idle') ...[
                        Text(i18n.worktrees.setupLabel, style: t.labelSmall),
                        _badge(
                          context,
                          runtime!.setup.status,
                          runtime!.setup.status == 'done'
                              ? Colors.green
                              : runtime!.setup.status == 'failed'
                              ? c.destructive
                              : Colors.blue,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],

                      // Run script status
                      Text(i18n.worktrees.serverLabel, style: t.labelSmall),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isRunRunning ? Colors.green : c.mutedForeground,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isRunRunning
                            ? (runtime!.run.port != null
                                  ? i18n.worktrees.runRunningWithPort(port: runtime!.run.port!)
                                  : i18n.worktrees.runRunning)
                            : runStatus,
                        style: t.labelSmall?.copyWith(
                          color: isRunRunning ? Colors.green : c.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  AppButton(
                    variant: AppButtonVariant.ghost,
                    size: AppButtonSize.sm,
                    onPressed: isRunRunning ? onStopScript : onRunScript,
                    child: Text(
                      isRunRunning ? i18n.worktrees.stopButton : i18n.worktrees.runButton,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _badge(BuildContext context, String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      border: Border.all(color: color.withValues(alpha: 0.3)),
      borderRadius: AppRadii.borderSm,
    ),
    child: Text(
      label,
      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
    ),
  );
}

// ─── Dialog: New Worktree ───────────────────────────────────────────────────

class _NewWorktreeDialog extends StatefulWidget {
  const _NewWorktreeDialog({required this.baseBranch, required this.onCreate});

  final String? baseBranch;
  final Future<Project?> Function(String branch, String? baseBranch) onCreate;

  static Future<void> show(
    BuildContext context, {
    String? baseBranch,
    required Future<Project?> Function(String branch, String? baseBranch) onCreate,
  }) => showDialog<void>(
    context: context,
    builder: (_) => _NewWorktreeDialog(baseBranch: baseBranch, onCreate: onCreate),
  );

  @override
  State<_NewWorktreeDialog> createState() => _NewWorktreeDialogState();
}

class _NewWorktreeDialogState extends State<_NewWorktreeDialog> {
  final _branchCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _branchCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final i18n = Translations.of(context);
    final branch = _branchCtrl.text.trim();
    if (branch.isEmpty || _saving) return;

    setState(() => _saving = true);
    final res = await widget.onCreate(branch, widget.baseBranch);
    if (!mounted) return;
    setState(() => _saving = false);
    if (res != null) {
      Navigator.of(context).pop();
      AppToast.show(context, i18n.worktrees.created);
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18n = Translations.of(context);
    return AlertDialog(
      title: Text(i18n.common.gitPanel.worktrees.kNew),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppInput(
              controller: _branchCtrl,
              hint: i18n.worktrees.branchHint,
              onChanged: (_) => setState(() {}),
            ),
            if (widget.baseBranch != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                i18n.worktrees.branchingOff(branch: widget.baseBranch!),
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: context.appColors.mutedForeground),
              ),
            ],
          ],
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          size: AppButtonSize.sm,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(i18n.chat.orchestrator.summary.cancelTasks),
        ),
        AppButton(
          size: AppButtonSize.sm,
          loading: _saving,
          onPressed: _branchCtrl.text.trim().isNotEmpty ? _submit : null,
          child: Text(i18n.common.buttons.create),
        ),
      ],
    );
  }
}

// ─── Dialog: Merge Worktree ─────────────────────────────────────────────────

class _MergeWorktreeDialog extends StatefulWidget {
  const _MergeWorktreeDialog({
    required this.worktree,
    required this.baseBranch,
    required this.onMerge,
  });

  final WorktreeDescriptor worktree;
  final String? baseBranch;
  final Future<MergeWorktreeResult?> Function(bool squash, String? message, bool removeAfterMerge)
  onMerge;

  static Future<void> show(
    BuildContext context, {
    required WorktreeDescriptor worktree,
    String? baseBranch,
    required Future<MergeWorktreeResult?> Function(
      bool squash,
      String? message,
      bool removeAfterMerge,
    )
    onMerge,
  }) => showDialog<void>(
    context: context,
    builder: (_) =>
        _MergeWorktreeDialog(worktree: worktree, baseBranch: baseBranch, onMerge: onMerge),
  );

  @override
  State<_MergeWorktreeDialog> createState() => _MergeWorktreeDialogState();
}

class _MergeWorktreeDialogState extends State<_MergeWorktreeDialog> {
  late final TextEditingController _msgCtrl;
  bool _squash = false;
  bool _cleanup = false;
  bool _merging = false;

  @override
  void initState() {
    super.initState();
    _msgCtrl = TextEditingController(
      text: t.common.gitPanel.mergeWorktree.mergeMessage(
        branch: widget.worktree.branch ?? 'worktree',
      ),
    );
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final i18n = Translations.of(context);
    setState(() => _merging = true);
    final res = await widget.onMerge(
      _squash,
      _msgCtrl.text.trim().isEmpty ? null : _msgCtrl.text.trim(),
      _cleanup,
    );
    if (!mounted) return;
    setState(() => _merging = false);
    if (res != null) {
      Navigator.of(context).pop();
      AppToast.show(context, i18n.worktrees.merged(branch: res.targetBranch));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = context.appColors;
    final i18n = Translations.of(context);

    return AlertDialog(
      title: Text(i18n.worktrees.mergeTitle(branch: widget.worktree.branch ?? 'worktree')),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              i18n.worktrees.mergeDescription(branch: widget.baseBranch ?? 'base branch'),
              style: t.bodyMedium?.copyWith(color: c.mutedForeground),
            ),
            const SizedBox(height: AppSpacing.sm),
            CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(i18n.common.gitPanel.mergeWorktree.squashLabel),
              subtitle: Text(i18n.worktrees.squashDescription),
              value: _squash,
              onChanged: (v) {
                setState(() {
                  _squash = v ?? false;
                  _msgCtrl.text = _squash
                      ? i18n.common.gitPanel.mergeWorktree.squashMessage(
                          branch: widget.worktree.branch ?? 'worktree',
                        )
                      : i18n.common.gitPanel.mergeWorktree.mergeMessage(
                          branch: widget.worktree.branch ?? 'worktree',
                        );
                });
              },
            ),
            const SizedBox(height: AppSpacing.xs),
            AppInput(
              controller: _msgCtrl,
              hint: i18n.common.gitPanel.mergeWorktree.messageLabel,
              onChanged: (_) => setState(() {}),
            ),
            CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(i18n.common.gitPanel.mergeWorktree.cleanupLabel),
              subtitle: Text(i18n.worktrees.cleanupDescription),
              value: _cleanup,
              onChanged: (v) => setState(() => _cleanup = v ?? false),
            ),
          ],
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          size: AppButtonSize.sm,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(i18n.chat.orchestrator.summary.cancelTasks),
        ),
        AppButton(
          size: AppButtonSize.sm,
          loading: _merging,
          onPressed: _submit,
          child: Text(
            _squash
                ? i18n.common.gitPanel.mergeWorktree.squashMerge
                : i18n.common.gitPanel.mergeWorktree.merge,
          ),
        ),
      ],
    );
  }
}

// ─── Dialog: Remove Worktree ────────────────────────────────────────────────

class _RemoveWorktreeDialog extends StatefulWidget {
  const _RemoveWorktreeDialog({required this.worktree, required this.onRemove});

  final WorktreeDescriptor worktree;
  final Future<RemoveWorktreeResult?> Function(bool force, bool deleteBranch) onRemove;

  static Future<void> show(
    BuildContext context, {
    required WorktreeDescriptor worktree,
    required Future<RemoveWorktreeResult?> Function(bool force, bool deleteBranch) onRemove,
  }) => showDialog<void>(
    context: context,
    builder: (_) => _RemoveWorktreeDialog(worktree: worktree, onRemove: onRemove),
  );

  @override
  State<_RemoveWorktreeDialog> createState() => _RemoveWorktreeDialogState();
}

class _RemoveWorktreeDialogState extends State<_RemoveWorktreeDialog> {
  bool _force = false;
  bool _deleteBranch = true;
  bool _removing = false;

  Future<void> _submit() async {
    final i18n = Translations.of(context);
    setState(() => _removing = true);
    final res = await widget.onRemove(_force, _deleteBranch);
    if (!mounted) return;
    setState(() => _removing = false);
    if (res != null) {
      Navigator.of(context).pop();
      AppToast.show(context, i18n.worktrees.removed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final isDirty = widget.worktree.changedFileCount > 0;

    return AlertDialog(
      title: Text(i18n.worktrees.removeTitle(branch: widget.worktree.branch ?? '')),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              i18n.worktrees.removeDescription,
              style: t.bodySmall?.copyWith(color: c.mutedForeground),
            ),
            if (isDirty) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: c.destructive.withValues(alpha: 0.1),
                  borderRadius: AppRadii.borderSm,
                ),
                child: Text(
                  i18n.worktrees.dirtyWarning(count: widget.worktree.changedFileCount),
                  style: t.bodySmall?.copyWith(color: c.destructive),
                ),
              ),
              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(i18n.worktrees.forceRemoveLabel),
                value: _force,
                onChanged: (v) => setState(() => _force = v ?? false),
              ),
            ],
            CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(i18n.worktrees.deleteBranchLabel),
              value: _deleteBranch,
              onChanged: (v) => setState(() => _deleteBranch = v ?? false),
            ),
          ],
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          size: AppButtonSize.sm,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(i18n.chat.orchestrator.summary.cancelTasks),
        ),
        AppButton(
          variant: AppButtonVariant.destructive,
          size: AppButtonSize.sm,
          loading: _removing,
          onPressed: (!isDirty || _force) ? _submit : null,
          child: Text(i18n.common.gitPanel.remove),
        ),
      ],
    );
  }
}

// ─── Dialog: Worktree Scripts Config ────────────────────────────────────────

class _WorktreeScriptsDialog extends StatefulWidget {
  const _WorktreeScriptsDialog({this.config, required this.onSave});

  final WorktreeScriptsConfig? config;
  final Future<bool> Function(String? setup, String? run, int? port) onSave;

  static Future<void> show(
    BuildContext context, {
    WorktreeScriptsConfig? config,
    required Future<bool> Function(String? setup, String? run, int? port) onSave,
  }) => showDialog<void>(
    context: context,
    builder: (_) => _WorktreeScriptsDialog(config: config, onSave: onSave),
  );

  @override
  State<_WorktreeScriptsDialog> createState() => _WorktreeScriptsDialogState();
}

class _WorktreeScriptsDialogState extends State<_WorktreeScriptsDialog> {
  late final TextEditingController _setupCtrl;
  late final TextEditingController _runCtrl;
  late final TextEditingController _portCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _setupCtrl = TextEditingController(text: widget.config?.setup ?? '');
    _runCtrl = TextEditingController(text: widget.config?.run ?? '');
    _portCtrl = TextEditingController(text: widget.config?.runPort?.toString() ?? '');
  }

  @override
  void dispose() {
    _setupCtrl.dispose();
    _runCtrl.dispose();
    _portCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final i18n = Translations.of(context);
    setState(() => _saving = true);
    final port = int.tryParse(_portCtrl.text.trim());
    final ok = await widget.onSave(
      _setupCtrl.text.trim().isEmpty ? null : _setupCtrl.text.trim(),
      _runCtrl.text.trim().isEmpty ? null : _runCtrl.text.trim(),
      port,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      Navigator.of(context).pop();
      AppToast.show(context, i18n.worktrees.scriptsSaved);
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18n = Translations.of(context);
    return AlertDialog(
      title: Text(i18n.common.gitPanel.worktreeScripts.title),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppInput(controller: _setupCtrl, hint: i18n.worktrees.setupHint),
            const SizedBox(height: AppSpacing.sm),
            AppInput(controller: _runCtrl, hint: i18n.worktrees.runHint),
            const SizedBox(height: AppSpacing.sm),
            AppInput(controller: _portCtrl, hint: i18n.worktrees.portHint),
          ],
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          size: AppButtonSize.sm,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(i18n.chat.orchestrator.summary.cancelTasks),
        ),
        AppButton(
          size: AppButtonSize.sm,
          loading: _saving,
          onPressed: _submit,
          child: Text(i18n.codeEditor.actions.save),
        ),
      ],
    );
  }
}
