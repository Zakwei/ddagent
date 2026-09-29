import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/subpage_header.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/projects/view/project_menu_button.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_models.dart';
import 'package:ddagent_app/features/taskmaster/state/taskmaster_controller.dart';
import 'package:ddagent_app/features/taskmaster/view/prd_editor_dialog.dart';
import 'package:ddagent_app/features/taskmaster/view/task_board.dart';
import 'package:ddagent_app/features/taskmaster/view/task_detail_dialog.dart';
import 'package:ddagent_app/features/taskmaster/view/task_tile.dart'
    show taskPriorities, taskStatuses;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// TaskMaster screen (port of TasksPage + TaskBoard): back-to-chat strip with
/// the project picker, then the toolbar (search, view toggle, filters, PRD,
/// add task), sort chips and the status kanban/list/grid. Mounted at /tasks.
class TaskmasterScreen extends ConsumerStatefulWidget {
  const TaskmasterScreen({super.key, this.projectId});

  final String? projectId;

  @override
  ConsumerState<TaskmasterScreen> createState() => _TaskmasterScreenState();
}

class _TaskmasterScreenState extends ConsumerState<TaskmasterScreen> {
  String? _pid;
  bool _filtersOpen = false;
  String _viewMode = 'kanban'; // kanban | list | grid — TaskBoardView parity
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(ref.read(projectsProvider.notifier).load());
      _load(
        widget.projectId ??
            ref.read(projectsProvider).projects.firstOrNull?.projectId,
      );
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _load(String? pid) {
    if (pid == null || pid.isEmpty || pid == _pid) return;
    _pid = pid;
    unawaited(ref.read(taskmasterProvider.notifier).load(pid));
  }

  /// TasksPage keeps its own selection — the route param seeds it, the
  /// dropdown overrides locally, and the first project is the fallback.
  String? _resolvePid(List<Project> projects) {
    final requested = widget.projectId ?? _pid;
    if (requested != null &&
        requested.isNotEmpty &&
        (projects.isEmpty || projects.any((p) => p.projectId == requested))) {
      return requested;
    }
    return projects.firstOrNull?.projectId;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskmasterProvider);
    final projectsState = ref.watch(projectsProvider);
    final projects = projectsState.projects;
    final c = context.appColors;
    final pid = _resolvePid(projects);
    final active = projects.where((p) => p.projectId == pid).firstOrNull;

    if (pid != null && pid != _pid) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _load(pid);
      });
    }

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SubpageHeader(
              icon: LucideIcons.clipboardCheck,
              children: [
                if (active != null && projects.isNotEmpty)
                  ProjectMenuButton(
                    projects: projects,
                    selected: active,
                    onSelected: (p) => _load(p.projectId),
                  ),
              ],
            ),
            if (state.error != null) _errorBanner(state),
            Expanded(child: _body(state, projectsState, pid)),
          ],
        ),
      ),
    );
  }

  Widget _errorBanner(TaskmasterState state) {
    final c = context.appColors;
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  // ─── Body ────────────────────────────────────────────────────────────

  Widget _body(
    TaskmasterState state,
    ProjectsState projectsState,
    String? pid,
  ) {
    final c = context.appColors;
    if (pid == null) {
      return Center(
        child: projectsState.loading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: c.muted.withValues(alpha: 0.4),
                      border: Border.all(
                        color: c.border.withValues(alpha: 0.6),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      LucideIcons.clipboardCheck,
                      size: 28,
                      color: c.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No project selected',
                    style: TextStyle(
                      color: c.foreground,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add a project first, then create tasks for it.',
                    style: TextStyle(color: c.mutedForeground, fontSize: 14),
                  ),
                ],
              ),
      );
    }
    if (state.loading && state.config == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Feature gating: TaskMaster not initialized in this project.
    if (state.config != null && !state.isReady) {
      return _SetupView(state: state, projectId: pid);
    }

    // TaskBoard parity: with zero tasks the toolbar is replaced entirely by
    // the getting-started panel.
    if (state.tasks.isEmpty) {
      return _GettingStarted(state: state);
    }

    final tasks = state.filteredTasks;
    final next = state.nextTask;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (next != null) _nextTaskBanner(next),
        _toolbar(state),
        const SizedBox(height: 12),
        _sortChips(state),
        if (_filtersOpen) ...[const SizedBox(height: 12), _filtersPanel(state)],
        const SizedBox(height: 16),
        _content(state, tasks),
      ],
    );
  }

  // ─── Toolbar — TaskBoardToolbar parity ────────────────────────────────

  Widget _toolbar(TaskmasterState state) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final compact = context.breakpoint.isCompact;

    final search = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 448),
      child: SizedBox(
        height: 36,
        child: TextField(
          controller: _searchCtrl,
          onChanged: ref.read(taskmasterProvider.notifier).setSearchQuery,
          style: TextStyle(
            color: dark ? Colors.white : const Color(0xFF111827),
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: 'Search tasks…',
            filled: true,
            fillColor: dark ? const Color(0xFF1F2937) : Colors.white,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 8,
            ),
            prefixIcon: const Icon(
              LucideIcons.search,
              size: 16,
              color: Color(0xFF9CA3AF),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadii.borderLg,
              borderSide: BorderSide(
                color: dark ? const Color(0xFF4B5563) : const Color(0xFFD1D5DB),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadii.borderLg,
              borderSide: BorderSide(
                color: dark ? const Color(0xFF4B5563) : const Color(0xFFD1D5DB),
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );

    final cluster = Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _viewToggle(dark),
        _filtersButton(dark),
        _helpButton(dark),
        _prdButton(state, dark),
        _addTaskButton(state),
      ],
    );

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [search, const SizedBox(height: 12), cluster],
      );
    }
    return Row(
      children: [
        Expanded(child: search),
        const SizedBox(width: 12),
        cluster,
      ],
    );
  }

  /// `flex rounded-lg bg-gray-100 p-1` segmented icon group.
  Widget _viewToggle(bool dark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6),
        borderRadius: AppRadii.borderLg,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _modeButton(LucideIcons.layoutGrid, 'kanban', 'Kanban view', dark),
          _modeButton(LucideIcons.list, 'list', 'List view', dark),
          _modeButton(LucideIcons.grid, 'grid', 'Grid view', dark),
        ],
      ),
    );
  }

  Widget _modeButton(IconData icon, String mode, String tooltip, bool dark) {
    final active = _viewMode == mode;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => setState(() => _viewMode = mode),
        borderRadius: AppRadii.borderMd,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: active
                ? (dark ? const Color(0xFF374151) : Colors.white)
                : Colors.transparent,
            borderRadius: AppRadii.borderMd,
            boxShadow: active
                ? const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            size: 16,
            color: active
                ? (dark ? Colors.white : const Color(0xFF111827))
                : (dark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
          ),
        ),
      ),
    );
  }

  /// `Filters` outline button — blue tint while the panel is open.
  Widget _filtersButton(bool dark) {
    final open = _filtersOpen;
    return InkWell(
      onTap: () => setState(() => _filtersOpen = !open),
      borderRadius: AppRadii.borderLg,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: open
              ? (dark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF))
              : (dark ? const Color(0xFF1F2937) : Colors.white),
          border: Border.all(
            color: open
                ? (dark ? const Color(0xFF1D4ED8) : const Color(0xFFBFDBFE))
                : (dark ? const Color(0xFF4B5563) : const Color(0xFFD1D5DB)),
          ),
          borderRadius: AppRadii.borderLg,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.filter,
              size: 16,
              color: open
                  ? (dark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8))
                  : (dark ? const Color(0xFFD1D5DB) : const Color(0xFF374151)),
            ),
            const SizedBox(width: 8),
            Text(
              'Filters',
              style: TextStyle(
                fontSize: 14,
                color: open
                    ? (dark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8))
                    : (dark
                          ? const Color(0xFFD1D5DB)
                          : const Color(0xFF374151)),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              LucideIcons.chevronDown,
              size: 16,
              color: open
                  ? (dark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8))
                  : (dark ? const Color(0xFFD1D5DB) : const Color(0xFF374151)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _helpButton(bool dark) {
    return Tooltip(
      message: 'TaskMaster Getting Started Guide',
      child: InkWell(
        onTap: () => showDialog<void>(
          context: context,
          builder: (_) => const _HelpDialog(),
        ),
        borderRadius: AppRadii.borderLg,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            border: Border.all(
              color: dark ? const Color(0xFF4B5563) : const Color(0xFFD1D5DB),
            ),
            borderRadius: AppRadii.borderLg,
          ),
          child: Icon(
            LucideIcons.circleHelp,
            size: 16,
            color: dark ? const Color(0xFF9CA3AF) : const Color(0xFF4B5563),
          ),
        ),
      ),
    );
  }

  /// `bg-purple-600` PRD button — flat "Add PRD" without files, a dropdown
  /// ("PRDs" + count badge) once `.taskmaster/docs` has documents.
  Widget _prdButton(TaskmasterState state, bool dark) {
    final prds = state.prdFiles;
    Widget trigger(String label, {int? count}) => Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF9333EA), // purple-600
        borderRadius: AppRadii.borderLg,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.fileText, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: 6),
            Container(
              constraints: const BoxConstraints(minWidth: 20),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFA855F7), // purple-500
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                '$count',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const Icon(LucideIcons.chevronDown, size: 12, color: Colors.white),
          ],
        ],
      ),
    );

    if (prds.isEmpty) {
      return InkWell(
        onTap: state.busy || _pid == null
            ? null
            : () => unawaited(PrdEditorDialog.show(context)),
        borderRadius: AppRadii.borderLg,
        child: trigger('Add PRD'),
      );
    }
    return PopupMenuButton<String>(
      tooltip: '${prds.length} PRD(s) available',
      position: PopupMenuPosition.under,
      offset: const Offset(0, 8),
      onSelected: (name) {
        if (name == '__new') {
          unawaited(PrdEditorDialog.show(context));
        } else {
          unawaited(PrdEditorDialog.show(context, fileName: name));
        }
      },
      itemBuilder: (ctx) => [
        PopupMenuItem<String>(
          value: '__new',
          height: 36,
          child: const Row(
            children: [
              Icon(LucideIcons.plus, size: 16, color: Color(0xFF7E22CE)),
              SizedBox(width: 8),
              Text(
                'Create New PRD',
                style: TextStyle(
                  color: Color(0xFF7E22CE),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(height: 8),
        for (final p in prds)
          PopupMenuItem<String>(
            value: p.fileName,
            height: 36,
            child: Row(
              children: [
                Icon(
                  LucideIcons.fileText,
                  size: 16,
                  color: dark
                      ? const Color(0xFFD1D5DB)
                      : const Color(0xFF374151),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    p.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: dark
                          ? const Color(0xFFD1D5DB)
                          : const Color(0xFF374151),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
      child: trigger('PRDs', count: prds.length),
    );
  }

  /// `bg-blue-600` primary action.
  Widget _addTaskButton(TaskmasterState state) {
    return InkWell(
      onTap: state.busy || _pid == null
          ? null
          : () => unawaited(CreateTaskDialog.show(context)),
      borderRadius: AppRadii.borderLg,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2563EB), // blue-600
          borderRadius: AppRadii.borderLg,
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.plus, size: 16, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Add Task',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Quick sort chips — TaskQuickSortBar parity ──────────────────────

  Widget _sortChips(TaskmasterState state) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ctrl = ref.read(taskmasterProvider.notifier);
    return Wrap(
      spacing: 8,
      children: [
        _sortChip('ID', TaskSort.position, state.sort, dark, ctrl),
        _sortChip('Status', TaskSort.status, state.sort, dark, ctrl),
        _sortChip('Priority', TaskSort.priority, state.sort, dark, ctrl),
      ],
    );
  }

  Widget _sortChip(
    String label,
    TaskSort sort,
    TaskSort current,
    bool dark,
    TaskmasterController ctrl,
  ) {
    final active = current == sort;
    return InkWell(
      onTap: () => ctrl.setSort(sort),
      borderRadius: AppRadii.borderMd,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? (dark ? const Color(0xFF1E3A8A) : const Color(0xFFDBEAFE))
              : (dark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6)),
          borderRadius: AppRadii.borderMd,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: active
                    ? (dark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8))
                    : (dark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF4B5563)),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              active ? LucideIcons.arrowUp : LucideIcons.arrowUpDown,
              size: 16,
              color: active
                  ? (dark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8))
                  : (dark ? const Color(0xFF9CA3AF) : const Color(0xFF4B5563)),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Filters panel — TaskFiltersPanel parity ─────────────────────────

  Widget _filtersPanel(TaskmasterState state) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ctrl = ref.read(taskmasterProvider.notifier);

    // Old panel offers the statuses/priorities actually present in the task
    // list, ordered by the canonical config order.
    final presentStatuses = state.tasks.map((t) => t.status).toSet();
    final statusOptions = [
      for (final s in taskStatuses)
        if (presentStatuses.contains(s)) s,
      for (final s in presentStatuses)
        if (!taskStatuses.contains(s)) s,
    ];
    final presentPriorities = state.tasks.map((t) => t.priority).toSet();
    final priorityOptions = [
      for (final p in taskPriorities)
        if (presentPriorities.contains(p)) p,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB),
        borderRadius: AppRadii.borderLg,
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _filterField(
                'Status',
                'All Statuses',
                state.statusFilter,
                statusOptions,
                ctrl.setStatusFilter,
                dark,
              ),
              _filterField(
                'Priority',
                'All Priorities',
                state.priorityFilter,
                priorityOptions,
                ctrl.setPriorityFilter,
                dark,
              ),
              _filterField(
                'Sort By',
                null,
                switch (state.sort) {
                  TaskSort.position => 'id',
                  TaskSort.status => 'status',
                  TaskSort.priority => 'priority',
                  TaskSort.title => 'title',
                },
                const ['id', 'title', 'status', 'priority'],
                (v) => ctrl.setSort(switch (v) {
                  'status' => TaskSort.status,
                  'priority' => TaskSort.priority,
                  'title' => TaskSort.title,
                  _ => TaskSort.position,
                }),
                dark,
                labels: const {
                  'id': 'ID (Ascending)',
                  'title': 'Title (A-Z)',
                  'status': 'Status',
                  'priority': 'Priority (High First)',
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Showing ${state.filteredTasks.length} of '
                '${state.tasks.length} tasks',
                style: TextStyle(
                  color: dark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF4B5563),
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  ctrl.setStatusFilter(null);
                  ctrl.setPriorityFilter(null);
                  ctrl.setSearchQuery('');
                  _searchCtrl.clear();
                },
                child: const Text(
                  'Clear Filters',
                  style: TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterField(
    String label,
    String? allLabel,
    String? value,
    List<String> options,
    ValueChanged<String?> onChanged,
    bool dark, {
    Map<String, String> labels = const {},
  }) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: dark ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: dark ? const Color(0xFF1F2937) : Colors.white,
              border: Border.all(
                color: dark ? const Color(0xFF4B5563) : const Color(0xFFD1D5DB),
              ),
              borderRadius: AppRadii.borderMd,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                value: value,
                isDense: true,
                isExpanded: true,
                dropdownColor: context.appColors.popover,
                style: TextStyle(
                  color: dark ? Colors.white : const Color(0xFF111827),
                  fontSize: 14,
                ),
                items: [
                  if (allLabel != null)
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(allLabel),
                    ),
                  for (final o in options)
                    DropdownMenuItem<String?>(
                      value: o,
                      child: Text(labels[o] ?? o),
                    ),
                ],
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Content: kanban | list | grid ───────────────────────────────────

  Widget _content(TaskmasterState state, List<TaskmasterTask> tasks) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ctrl = ref.read(taskmasterProvider.notifier);

    if (tasks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Icon(
              LucideIcons.search,
              size: 48,
              color: (dark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280))
                  .withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks match your filters',
              style: TextStyle(
                color: dark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filter criteria.',
              style: TextStyle(
                color: dark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    void onRun(TaskmasterTask t) =>
        unawaited(ctrl.setTaskStatus(t.idText, 'in-progress'));
    void onTap(TaskmasterTask t) =>
        unawaited(TaskDetailDialog.show(context, t.idText));
    void onStatusChange((TaskmasterTask, String) e) =>
        unawaited(ctrl.setTaskStatus(e.$1.idText, e.$2));

    if (_viewMode == 'list') {
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: AppRadii.borderLg,
          border: Border.all(
            color: dark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            for (var i = 0; i < tasks.length; i++) ...[
              if (i > 0)
                Divider(
                  height: 1,
                  color: dark
                      ? const Color(0xFF374151).withValues(alpha: 0.6)
                      : const Color(0xFFF3F4F6),
                ),
              TaskCompactRow(
                key: ValueKey(tasks[i].idText),
                task: tasks[i],
                busy: state.busy,
                onTap: () => onTap(tasks[i]),
                onToggleDone: () => unawaited(
                  ctrl.setTaskStatus(
                    tasks[i].idText,
                    tasks[i].status == 'done' ? 'pending' : 'done',
                  ),
                ),
                onRun: () => onRun(tasks[i]),
              ),
            ],
          ],
        ),
      );
    }

    if (_viewMode == 'grid') {
      return LayoutBuilder(
        builder: (context, constraints) {
          final cols = constraints.maxWidth > 1280
              ? 3
              : constraints.maxWidth > 768
              ? 2
              : 1;
          if (cols == 1) {
            return Column(
              children: [
                for (final t in tasks)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TaskBoardCard(
                      task: t,
                      onTap: () => onTap(t),
                      onRun: () => onRun(t),
                    ),
                  ),
              ],
            );
          }
          final w = (constraints.maxWidth - (cols - 1) * 16) / cols;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final t in tasks)
                SizedBox(
                  width: w,
                  child: TaskBoardCard(
                    task: t,
                    onTap: () => onTap(t),
                    onRun: () => onRun(t),
                  ),
                ),
            ],
          );
        },
      );
    }

    // Kanban — responsive grid like `sm:grid md:grid-cols-2 lg:grid-cols-N`,
    // horizontal snap-scroll below that.
    final columns = buildTaskKanbanColumns(tasks);
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        if (columns.length == 1) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448),
              child: TaskBoardColumn(
                column: columns.first,
                onTaskTap: onTap,
                onRunTask: onRun,
                onStatusChange: onStatusChange,
              ),
            ),
          );
        }
        final fits = w >= columns.length * 280 + (columns.length - 1) * 24;
        if (fits) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < columns.length; i++) ...[
                  if (i > 0) const SizedBox(width: 24),
                  Expanded(
                    child: TaskBoardColumn(
                      column: columns[i],
                      onTaskTap: onTap,
                      onRunTask: onRun,
                      onStatusChange: onStatusChange,
                    ),
                  ),
                ],
              ],
            ),
          );
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < columns.length; i++) ...[
                if (i > 0) const SizedBox(width: 16),
                TaskBoardColumn(
                  column: columns[i],
                  width: 280,
                  onTaskTap: onTap,
                  onRunTask: onRun,
                  onStatusChange: onStatusChange,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // ─── Next task banner — NextTaskBanner parity ────────────────────────

  Widget _nextTaskBanner(TaskmasterTask task) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final c = context.appColors;
    final ctrl = ref.read(taskmasterProvider.notifier);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: dark
            ? const Color(0xFF0F172A).withValues(alpha: 0.3)
            : const Color(0xFFF8FAFC),
        border: Border.all(
          color: dark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        borderRadius: AppRadii.borderLg,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () =>
                  unawaited(TaskDetailDialog.show(context, task.idText)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: dark
                              ? const Color(0xFF1E3A8A).withValues(alpha: 0.5)
                              : const Color(0xFFDBEAFE),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.target,
                          size: 12,
                          color: dark
                              ? const Color(0xFF60A5FA)
                              : const Color(0xFF2563EB),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Task ${task.idText}',
                        style: TextStyle(
                          color: dark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF475569),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      taskPriorityTile(task.priority, c, dark),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: dark
                          ? const Color(0xFFF1F5F9)
                          : const Color(0xFF0F172A),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: stateBusySafe(ctrl, task),
            borderRadius: AppRadii.borderMd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: AppRadii.borderMd,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.play, size: 12, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'Start Task',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
          Tooltip(
            message: 'View task details',
            child: InkWell(
              onTap: () =>
                  unawaited(TaskDetailDialog.show(context, task.idText)),
              borderRadius: AppRadii.borderMd,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: dark
                        ? const Color(0xFF475569)
                        : const Color(0xFFCBD5E1),
                  ),
                  borderRadius: AppRadii.borderMd,
                ),
                child: Icon(
                  LucideIcons.eye,
                  size: 12,
                  color: dark
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF475569),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  VoidCallback stateBusySafe(TaskmasterController ctrl, TaskmasterTask t) =>
      () => unawaited(ctrl.setTaskStatus(t.idText, 'in-progress'));
}

/// `TaskHelpModal` parity — getting-started steps in a dialog.
class _HelpDialog extends StatelessWidget {
  const _HelpDialog();

  static const _steps = [
    (
      'Create a Product Requirements Document (PRD)',
      'Discuss your project idea and create a PRD that describes what you '
          'want to build.',
    ),
    (
      'Generate Tasks from PRD',
      'Once you have a PRD, ask your AI assistant to parse it and TaskMaster '
          'will automatically break it down into manageable tasks with '
          'implementation details.',
    ),
    (
      'Analyze & Expand Tasks',
      'Ask your AI assistant to analyze task complexity and expand them into '
          'detailed subtasks for easier implementation.',
    ),
    (
      'Start Building',
      'Ask your AI assistant to begin working on tasks, update their status, '
          'and add new tasks as your project evolves.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return AlertDialog(
      backgroundColor: c.popover,
      title: const Text('Getting Started with TaskMaster'),
      content: SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < _steps.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: c.border),
                    borderRadius: AppRadii.borderLg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${i + 1}. ${_steps[i].$1}',
                        style: TextStyle(
                          color: c.foreground,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _steps[i].$2,
                        style: TextStyle(
                          color: c.mutedForeground,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

/// `TaskEmptyState` (hasTaskMasterDirectory branch) — getting-started panel
/// shown when the project is initialized but has zero tasks.
class _GettingStarted extends ConsumerWidget {
  const _GettingStarted({required this.state});

  final TaskmasterState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    const stepTitles = [
      '1. Create a Product Requirements Document (PRD)',
      '2. Generate Tasks from PRD',
      '3. Analyze & Expand Tasks',
      '4. Start Building',
    ];
    const stepDescs = [
      'Discuss your project idea and create a PRD that describes what you '
          'want to build.',
      'Once you have a PRD, ask your AI assistant to parse it and TaskMaster '
          'will automatically break it down into manageable tasks with '
          'implementation details.',
      'Ask your AI assistant to analyze task complexity and expand them into '
          'detailed subtasks for easier implementation.',
      'Ask your AI assistant to begin working on tasks, update their status, '
          'and add new tasks as your project evolves.',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 896),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: dark
                        ? [
                            const Color(0xFF172554).withValues(alpha: 0.5),
                            const Color(0xFF1E1B4B).withValues(alpha: 0.5),
                          ]
                        : const [Color(0xFFEFF6FF), Color(0xFFEEF2FF)],
                  ),
                  border: Border.all(
                    color: dark
                        ? const Color(0xFF1E40AF)
                        : const Color(0xFFBFDBFE),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: dark
                                ? const Color(0xFF1E3A8A).withValues(alpha: 0.5)
                                : const Color(0xFFDBEAFE),
                            borderRadius: AppRadii.borderLg,
                          ),
                          child: const Icon(
                            LucideIcons.fileText,
                            size: 20,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Getting Started with TaskMaster',
                              style: TextStyle(
                                color: c.foreground,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'TaskMaster is initialized! '
                              'Here\'s what to do next:',
                              style: TextStyle(
                                color: c.mutedForeground,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    for (var i = 0; i < 4; i++)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: dark ? c.card.withValues(alpha: 0.6) : c.card,
                          border: Border.all(color: c.border),
                          borderRadius: AppRadii.borderLg,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stepTitles[i],
                              style: TextStyle(
                                color: c.foreground,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              stepDescs[i],
                              style: TextStyle(
                                color: c.mutedForeground,
                                fontSize: 14,
                              ),
                            ),
                            if (i == 0) ...[
                              const SizedBox(height: 12),
                              InkWell(
                                onTap: () =>
                                    unawaited(PrdEditorDialog.show(context)),
                                borderRadius: AppRadii.borderSm,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: dark
                                        ? const Color(0xFF581C87)
                                              .withValues(alpha: 0.3)
                                        : const Color(0xFFF3E8FF),
                                    borderRadius: AppRadii.borderSm,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        LucideIcons.fileText,
                                        size: 12,
                                        color: dark
                                            ? const Color(0xFFD8B4FE)
                                            : const Color(0xFF7E22CE),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Add PRD',
                                        style: TextStyle(
                                          color: dark
                                              ? const Color(0xFFD8B4FE)
                                              : const Color(0xFF7E22CE),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (state.prdFiles.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Divider(color: c.border, height: 1),
                                const SizedBox(height: 8),
                                Text(
                                  'Existing PRDs:',
                                  style: TextStyle(
                                    color: c.mutedForeground,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    for (final p in state.prdFiles)
                                      InkWell(
                                        onTap: () => unawaited(
                                          PrdEditorDialog.show(
                                            context,
                                            fileName: p.fileName,
                                          ),
                                        ),
                                        borderRadius: AppRadii.borderSm,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: c.muted,
                                            borderRadius: AppRadii.borderSm,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                LucideIcons.fileText,
                                                size: 12,
                                                color: c.foreground,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                p.fileName,
                                                style: TextStyle(
                                                  color: c.foreground,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                    InkWell(
                      onTap: () => unawaited(PrdEditorDialog.show(context)),
                      borderRadius: AppRadii.borderLg,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9333EA),
                          borderRadius: AppRadii.borderLg,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.fileText,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Add PRD',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '💡 Tip: Start with a PRD to get the most out of '
                "TaskMaster's AI-powered task generation",
                style: TextStyle(color: c.mutedForeground, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// `TaskEmptyState` (not-configured branch) + TaskMasterSetupModal parity —
/// centered feature-gating view.
class _SetupView extends ConsumerWidget {
  const _SetupView({required this.state, required this.projectId});

  final TaskmasterState state;
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    const features = [
      '- AI-Powered Task Management: Break complex projects into manageable '
          'subtasks',
      '- PRD Templates: Generate tasks from Product Requirements Documents',
      '- Dependency Tracking: Understand task relationships and execution '
          'order',
      '- Progress Visualization: Kanban boards and detailed task analytics',
      '- CLI Integration: Use taskmaster commands for advanced workflows',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 448),
          child: Column(
            children: [
              const Icon(
                LucideIcons.settings,
                size: 48,
                color: Color(0xFF2563EB),
              ),
              const SizedBox(height: 16),
              Text(
                'TaskMaster AI is not configured',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: c.foreground,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.config?.reason ??
                    'TaskMaster helps break down complex projects into '
                        'manageable tasks with AI-powered assistance',
                textAlign: TextAlign.center,
                style: TextStyle(color: c.mutedForeground, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: dark
                      ? const Color(0xFF172554)
                      : const Color(0xFFEFF6FF),
                  borderRadius: AppRadii.borderLg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎯 What is TaskMaster?',
                      style: TextStyle(
                        color: dark
                            ? const Color(0xFFDBEAFE)
                            : const Color(0xFF1E3A8A),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final f in features)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          f,
                          style: TextStyle(
                            color: dark
                                ? const Color(0xFFBFDBFE)
                                : const Color(0xFF1E40AF),
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (state.config?.isInstalled == true &&
                  state.config?.version != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Installed: ${state.config!.version}',
                    style: TextStyle(color: c.mutedForeground, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  InkWell(
                    onTap: state.busy
                        ? null
                        : () async {
                            final ctrl = ref.read(taskmasterProvider.notifier);
                            if (await ctrl.init()) {
                              await ctrl.load(projectId);
                            }
                          },
                    borderRadius: AppRadii.borderLg,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: AppRadii.borderLg,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            LucideIcons.terminal,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          if (state.busy)
                            const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          else
                            const Text(
                              'Initialize TaskMaster AI',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
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
    );
  }
}
