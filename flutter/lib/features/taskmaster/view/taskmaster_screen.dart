import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_models.dart';
import 'package:ddagent_app/features/taskmaster/state/taskmaster_controller.dart';
import 'package:ddagent_app/features/taskmaster/view/prd_editor_dialog.dart';
import 'package:ddagent_app/features/taskmaster/view/task_detail_dialog.dart';
import 'package:ddagent_app/features/taskmaster/view/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// TaskMaster screen (port of TasksPage + TaskBoard + toolbar): project
/// picker, feature gating (init/setup), next-task banner, search + filters +
/// sort, task list and the PRD editor entry point. Mounted at /tasks.
class TaskmasterScreen extends ConsumerStatefulWidget {
  const TaskmasterScreen({super.key, this.projectId});

  final String? projectId;

  @override
  ConsumerState<TaskmasterScreen> createState() => _TaskmasterScreenState();
}

class _TaskmasterScreenState extends ConsumerState<TaskmasterScreen> {
  String? _pid;
  bool _filtersOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(projectsProvider.notifier).load();
      _load(
        widget.projectId ??
            ref.read(projectsProvider).projects.firstOrNull?.projectId,
      );
    });
  }

  void _load(String? pid) {
    if (pid == null || pid.isEmpty || pid == _pid) return;
    _pid = pid;
    unawaited(ref.read(taskmasterProvider.notifier).load(pid));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskmasterProvider);
    final projects = ref.watch(projectsProvider).projects;
    // Project changes from the toolbar dropdown re-trigger a load.
    final projectsLoaded = projects.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _toolbar(state, projects),
            if (state.error != null) _errorBanner(state),
            Expanded(child: _body(state, projectsLoaded)),
          ],
        ),
      ),
    );
  }

  // ─── Toolbar ─────────────────────────────────────────────────────────────

  Widget _toolbar(TaskmasterState state, List<Project> projects) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final ctrl = ref.read(taskmasterProvider.notifier);
    final compact = context.breakpoint.isCompact;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (projects.isNotEmpty)
                DropdownButton<String>(
                  value: _pid,
                  hint: const Text('Project'),
                  underline: const SizedBox.shrink(),
                  isDense: true,
                  style: t.labelMedium,
                  items: [
                    for (final p in projects)
                      DropdownMenuItem(
                        value: p.projectId,
                        child: Text(p.displayName),
                      ),
                  ],
                  onChanged: _load,
                ),
              SizedBox(
                width: compact ? 180 : 280,
                child: AppInput(
                  hint: 'Search tasks…',
                  onChanged: ctrl.setSearchQuery,
                ),
              ),
              IconButton(
                tooltip: 'Filters',
                onPressed: () => setState(() => _filtersOpen = !_filtersOpen),
                icon: Icon(
                  Icons.filter_list,
                  size: 18,
                  color:
                      _filtersOpen ||
                          state.statusFilter != null ||
                          state.priorityFilter != null
                      ? c.primary
                      : c.mutedForeground,
                ),
              ),
              PopupMenuButton<TaskSort>(
                tooltip: 'Sort',
                icon: Icon(
                  Icons.sort,
                  size: 18,
                  color: state.sort != TaskSort.position
                      ? c.primary
                      : c.mutedForeground,
                ),
                initialValue: state.sort,
                onSelected: ctrl.setSort,
                itemBuilder: (_) => [
                  for (final s in TaskSort.values)
                    PopupMenuItem(value: s, child: Text(s.name)),
                ],
              ),
              IconButton(
                tooltip: 'PRD editor',
                onPressed: state.busy || _pid == null
                    ? null
                    : () => unawaited(PrdEditorDialog.show(context)),
                icon: Icon(
                  Icons.article_outlined,
                  size: 18,
                  color: c.mutedForeground,
                ),
              ),
              AppButton(
                size: AppButtonSize.sm,
                loading: state.busy,
                onPressed: _pid == null
                    ? null
                    : () => unawaited(CreateTaskDialog.show(context)),
                child: const Text('+ Task'),
              ),
              IconButton(
                tooltip: 'Refresh',
                onPressed: state.busy
                    ? null
                    : () => unawaited(
                        ref.read(taskmasterProvider.notifier).load(_pid ?? ''),
                      ),
                icon: Icon(Icons.refresh, size: 18, color: c.mutedForeground),
              ),
            ],
          ),
          if (_filtersOpen)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Wrap(
                spacing: AppSpacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _filterDropdown(
                    'Status',
                    state.statusFilter,
                    taskStatuses,
                    ctrl.setStatusFilter,
                  ),
                  _filterDropdown(
                    'Priority',
                    state.priorityFilter,
                    taskPriorities,
                    ctrl.setPriorityFilter,
                  ),
                  if (state.statusFilter != null ||
                      state.priorityFilter != null ||
                      state.searchQuery.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        ctrl.setStatusFilter(null);
                        ctrl.setPriorityFilter(null);
                        ctrl.setSearchQuery('');
                      },
                      child: const Text('Clear'),
                    ),
                  Text(
                    '${state.filteredTasks.length}/${state.tasks.length} tasks',
                    style: t.labelSmall?.copyWith(color: c.mutedForeground),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _filterDropdown(
    String label,
    String? value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(width: 4),
        DropdownButton<String?>(
          value: value,
          isDense: true,
          underline: const SizedBox.shrink(),
          items: [
            const DropdownMenuItem(value: null, child: Text('All')),
            for (final o in options) DropdownMenuItem(value: o, child: Text(o)),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _errorBanner(TaskmasterState state) {
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
              state.error!,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: c.destructive),
            ),
          ),
          InkWell(
            onTap: ref.read(taskmasterProvider.notifier).clearError,
            child: Icon(Icons.close, size: 14, color: c.destructive),
          ),
        ],
      ),
    );
  }

  // ─── Body ────────────────────────────────────────────────────────────────

  Widget _body(TaskmasterState state, bool projectsLoaded) {
    if (_pid == null) {
      return Center(
        child: projectsLoaded
            ? Text(
                'Select a project',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            : const SizedBox.shrink(),
      );
    }
    if (state.loading && state.config == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Feature gating: TaskMaster not initialized in this project.
    if (state.config != null && !state.isReady) {
      return _SetupView(state: state, projectId: _pid!);
    }

    final tasks = state.filteredTasks;
    final next = state.nextTask;
    final compact = context.breakpoint.isCompact;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.sm),
      children: [
        if (next != null) _nextTaskCard(next),
        if (!state.hasTasksFile)
          Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
              border: Border.all(
                color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
              ),
              borderRadius: AppRadii.borderMd,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'No tasks.json yet — create a task or parse a PRD to '
                    'generate them.',
                  ),
                ),
                TextButton(
                  onPressed: () => unawaited(PrdEditorDialog.show(context)),
                  child: const Text('Open PRD'),
                ),
              ],
            ),
          ),
        if (tasks.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Center(
              child: Text(
                state.tasks.isEmpty
                    ? 'No tasks yet'
                    : 'No tasks match the filters',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: context.appColors.mutedForeground),
              ),
            ),
          )
        else
          _taskGrid(tasks, compact),
      ],
    );
  }

  Widget _taskGrid(List<TaskmasterTask> tasks, bool compact) {
    if (compact) {
      return Column(children: [for (final t in tasks) _tile(t)]);
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth > 1100
            ? 3
            : constraints.maxWidth > 700
            ? 2
            : 1;
        if (cols == 1) {
          return Column(children: [for (final t in tasks) _tile(t)]);
        }
        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            for (final t in tasks)
              SizedBox(
                width:
                    (constraints.maxWidth - (cols - 1) * AppSpacing.sm) / cols,
                child: _tile(t),
              ),
          ],
        );
      },
    );
  }

  Widget _tile(TaskmasterTask task) {
    final ctrl = ref.read(taskmasterProvider.notifier);
    final busy = ref.read(taskmasterProvider).busy;
    return TaskmasterTaskTile(
      task: task,
      busy: busy,
      onTap: () => unawaited(TaskDetailDialog.show(context, task.idText)),
      onToggleDone: () => unawaited(
        ctrl.setTaskStatus(
          task.idText,
          task.status == 'done' ? 'pending' : 'done',
        ),
      ),
      onRun: () => unawaited(ctrl.setTaskStatus(task.idText, 'in-progress')),
    );
  }

  Widget _nextTaskCard(TaskmasterTask task) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final ctrl = ref.read(taskmasterProvider.notifier);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: c.primary.withValues(alpha: 0.08),
        border: Border.all(color: c.primary.withValues(alpha: 0.3)),
        borderRadius: AppRadii.borderMd,
      ),
      child: Row(
        children: [
          Icon(Icons.my_location, size: 16, color: c.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: InkWell(
              onTap: () =>
                  unawaited(TaskDetailDialog.show(context, task.idText)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next task · #${task.idText}',
                    style: t.labelSmall?.copyWith(color: c.mutedForeground),
                  ),
                  Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          AppButton(
            size: AppButtonSize.sm,
            onPressed: () =>
                unawaited(ctrl.setTaskStatus(task.idText, 'in-progress')),
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}

/// Feature-gating view — TaskMaster missing/uninitialized for the project
/// (TaskEmptyState + TaskMasterSetupModal parity).
class _SetupView extends ConsumerWidget {
  const _SetupView({required this.state, required this.projectId});

  final TaskmasterState state;
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final cfg = state.config!;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Card(
          margin: const EdgeInsets.all(AppSpacing.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.terminal, size: 36, color: c.primary),
                const SizedBox(height: AppSpacing.sm),
                Text('TaskMaster is not set up', style: t.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  cfg.reason ??
                      'Creates a .taskmaster folder in this project. Tasks '
                          'are stored locally — no external tooling required.',
                  textAlign: TextAlign.center,
                  style: t.bodySmall?.copyWith(color: c.mutedForeground),
                ),
                if (cfg.isInstalled && cfg.version != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: Text(
                      'Installed: ${cfg.version}',
                      style: t.labelSmall?.copyWith(color: c.mutedForeground),
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    AppButton(
                      loading: state.busy,
                      onPressed: () async {
                        final ctrl = ref.read(taskmasterProvider.notifier);
                        if (await ctrl.init()) await ctrl.load(projectId);
                      },
                      child: const Text('Initialize'),
                    ),
                    AppButton(
                      variant: AppButtonVariant.secondary,
                      onPressed: () => unawaited(PrdEditorDialog.show(context)),
                      child: const Text('Write PRD first'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
