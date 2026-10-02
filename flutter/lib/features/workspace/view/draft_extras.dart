import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_models.dart';
import 'package:ddagent_app/features/taskmaster/state/taskmaster_controller.dart';
import 'package:ddagent_app/features/taskmaster/state/tasks_settings_controller.dart';
import 'package:ddagent_app/features/taskmaster/view/task_detail_dialog.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// `ProviderSelectionEmptyState` extras for session-less chat panes (T55):
/// the workspace card (click to rebind) and the TaskMaster next-task banner.
/// The Flutter draft pane renders the session picker, so these mount above
/// it — the web renders them inside its own empty-state panel instead.
class DraftExtras extends ConsumerWidget {
  const DraftExtras({
    super.key,
    this.projectId,
    this.onSelectWorkspace,
    this.onStartTask,
    this.onShowAllTasks,
  });

  /// Pane's bound project — drives the workspace card and the task banner.
  final String? projectId;

  /// Rebinds the pane to another workspace (workspace picker row).
  final void Function(String projectId)? onSelectWorkspace;

  /// "Start Task" — callers stash `/task-master start <id>` as the draft and
  /// create the session (web `setInput` + focus on the draft composer).
  final void Function(TaskmasterTask task)? onStartTask;

  /// "View all" — the web lifts the tasks panel; Flutter routes to `/tasks`.
  final VoidCallback? onShowAllTasks;

  // Carry the pane's workspace into /tasks — the route otherwise falls back to
  // the first project, so "Przejrzyj" opened a different workspace than the one
  // the banner belongs to.
  String get _tasksRoute {
    final pid = projectId;
    return pid == null ? '/tasks' : '/tasks?projectId=$pid';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final c = context.appColors;
    final projects = ref.watch(projectsProvider).projects;
    final current = projectId == null
        ? null
        : projects.where((p) => p.projectId == projectId).firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        // `.oc-workspace-card` parity — bound workspace name + path; tap to
        // rebind through a project picker dialog.
        InkWell(
          borderRadius: AppRadii.borderMd,
          onTap: onSelectWorkspace == null
              ? null
              : () => unawaited(_pickWorkspace(context, ref, projects)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: c.card,
              border: Border.all(color: c.border),
              borderRadius: AppRadii.borderMd,
            ),
            child: Row(
              spacing: 10,
              children: [
                Icon(LucideIcons.folder, size: 16, color: c.mutedForeground),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 1,
                    children: [
                      Text(
                        t.chat.providerSelection.workspace,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: c.mutedForeground,
                        ),
                      ),
                      Text(
                        current?.displayName ?? t.chat.providerSelection.noWorkspace,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      if ((current?.path ?? '').isNotEmpty)
                        Text(
                          current!.path,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: c.mutedForeground),
                        ),
                    ],
                  ),
                ),
                if (onSelectWorkspace != null)
                  Icon(LucideIcons.chevronsUpDown, size: 14, color: c.mutedForeground),
              ],
            ),
          ),
        ),
        NextTaskBanner(
          projectId: projectId,
          onStartTask: onStartTask,
          onShowAllTasks: onShowAllTasks ?? () => context.go(_tasksRoute),
        ),
      ],
    );
  }

  Future<void> _pickWorkspace(BuildContext context, WidgetRef ref, List<Project> projects) async {
    if (projects.isEmpty) return;
    final picked = await showDialog<String>(
      context: context,
      builder: (ctx) => AppDialog(
        title: Translations.of(ctx).chat.providerSelection.chooseWorkspace,
        content: SizedBox(
          width: 360,
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final p in projects)
                ListTile(
                  dense: true,
                  leading: const Icon(LucideIcons.folder, size: 16),
                  title: Text(p.displayName, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(p.path, maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () => Navigator.of(ctx).pop(p.projectId),
                ),
            ],
          ),
        ),
      ),
    );
    if (picked != null) onSelectWorkspace?.call(picked);
  }
}

/// Port of `NextTaskBanner` — three states on the pane's project:
/// TaskMaster not configured (Initialize → /tasks setup view), an actionable
/// next task (Start / details / view-all), or all-done (Review → /tasks).
class NextTaskBanner extends ConsumerStatefulWidget {
  const NextTaskBanner({super.key, this.projectId, this.onStartTask, this.onShowAllTasks});

  final String? projectId;
  final void Function(TaskmasterTask task)? onStartTask;
  final VoidCallback? onShowAllTasks;

  @override
  ConsumerState<NextTaskBanner> createState() => _NextTaskBannerState();
}

class _NextTaskBannerState extends ConsumerState<NextTaskBanner> {
  @override
  void initState() {
    super.initState();
    // Web parity: mount re-pulls tasks so a stale session's list never shows.
    WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(_load()));
  }

  Future<void> _load() async {
    final pid = widget.projectId;
    if (pid == null) return;
    final ctrl = ref.read(taskmasterProvider.notifier);
    if (ref.read(taskmasterProvider).projectId != pid) {
      await ctrl.load(pid);
    } else {
      await ctrl.refreshTasks();
    }
  }

  // Carry the pane's workspace into /tasks — the route otherwise falls back to
  // the first project, so "Przejrzyj" opened a different workspace than the one
  // the banner belongs to.
  String get _tasksRoute {
    final pid = widget.projectId;
    return pid == null ? '/tasks' : '/tasks?projectId=$pid';
  }

  @override
  Widget build(BuildContext context) {
    final pid = widget.projectId;
    if (pid == null) return const SizedBox.shrink();
    // Web gate: `tasksEnabled && isTaskMasterInstalled` on the empty state.
    if (!ref.watch(tasksEnabledProvider)) return const SizedBox.shrink();
    final installed = ref.watch(taskmasterInstallStatusProvider).value?.isInstalled ?? false;
    if (!installed) return const SizedBox.shrink();

    final tm = ref.watch(taskmasterProvider);
    // The controller is single-project — render only once it holds ours.
    if (tm.projectId != pid || tm.loading) return const SizedBox.shrink();
    final hasTaskmaster = ref.watch(projectsProvider).taskmaster[pid]?['hasTaskmaster'] == true;
    final t = Translations.of(context).tasks.nextTask;
    final tasks = tm.tasks;

    if (tasks.isEmpty && !hasTaskmaster) {
      // Not-configured card — Initialize opens the tasks screen's setup view
      // (the web opens an inline setup modal there).
      return _BannerShell(
        color: const Color(0xFF2563EB),
        icon: LucideIcons.listTodo,
        title: t.notConfigured,
        actionLabel: t.initialize,
        actionIcon: LucideIcons.terminal,
        onAction: widget.onShowAllTasks ?? () => context.go(_tasksRoute),
      );
    }

    final next = tm.nextTask;
    if (next != null) {
      return _BannerShell(
        color: const Color(0xFF475569),
        icon: LucideIcons.target,
        title: t.taskId(id: next.idText),
        subtitle: next.title,
        actionLabel: t.startTask,
        actionIcon: LucideIcons.play,
        onAction: widget.onStartTask == null ? null : () => widget.onStartTask!(next),
        secondary: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            IconButton(
              icon: const Icon(LucideIcons.eye, size: 14),
              tooltip: t.viewDetails,
              visualDensity: VisualDensity.compact,
              onPressed: () => unawaited(TaskDetailDialog.show(context, next.idText)),
            ),
            IconButton(
              icon: const Icon(LucideIcons.list, size: 14),
              tooltip: t.viewAll,
              visualDensity: VisualDensity.compact,
              onPressed: widget.onShowAllTasks ?? () => context.go(_tasksRoute),
            ),
          ],
        ),
      );
    }

    if (tasks.isNotEmpty) {
      final done = tasks.where((task) => task.isDone).length;
      return _BannerShell(
        color: const Color(0xFF9333EA),
        icon: LucideIcons.circleCheck,
        title: done == tasks.length ? t.allComplete : t.noPending,
        trailing: Text('$done/${tasks.length}'),
        actionLabel: widget.onShowAllTasks == null ? null : t.review,
        onAction: widget.onShowAllTasks,
      );
    }
    return const SizedBox.shrink();
  }
}

/// Shared banner chrome — tinted card with a leading icon, title/subtitle,
/// and an accent action button (three NextTaskBanner states share it).
class _BannerShell extends StatelessWidget {
  const _BannerShell({
    required this.color,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.secondary,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;
  final Widget? secondary;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.06),
      border: Border.all(color: color.withValues(alpha: 0.25)),
      borderRadius: AppRadii.borderMd,
    ),
    child: Row(
      spacing: 10,
      children: [
        Icon(icon, size: 16, color: color),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: context.appColors.mutedForeground),
                ),
            ],
          ),
        ),
        ?trailing,
        if (actionLabel != null)
          AppButton(
            variant: AppButtonVariant.primary,
            size: AppButtonSize.sm,
            onPressed: onAction,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                if (actionIcon != null) Icon(actionIcon, size: 12, color: Colors.white),
                Text(actionLabel!),
              ],
            ),
          ),
        ?secondary,
      ],
    ),
  );
}
