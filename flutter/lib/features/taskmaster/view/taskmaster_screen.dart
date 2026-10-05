import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/core/widgets/subpage_header.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/projects/view/project_menu_button.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_models.dart';
import 'package:ddagent_app/features/taskmaster/state/taskmaster_controller.dart';
import 'package:ddagent_app/features/taskmaster/view/prd_editor_dialog.dart';
import 'package:ddagent_app/features/taskmaster/view/task_board.dart';
import 'package:ddagent_app/features/taskmaster/view/task_detail_dialog.dart';
import 'package:ddagent_app/features/taskmaster/view/task_tile.dart'
    show taskPriorities, taskStatuses;
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

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
      _load(widget.projectId ?? ref.read(projectsProvider).projects.firstOrNull?.projectId);
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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.destructive),
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

  Widget _body(TaskmasterState state, ProjectsState projectsState, String? pid) {
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
                      border: Border.all(color: c.border.withValues(alpha: 0.6)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(LucideIcons.clipboardCheck, size: 28, color: c.mutedForeground),
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
      return _SetupView(
        state: state,
        projectId: pid,
        projectName:
            projectsState.projects.where((p) => p.projectId == pid).firstOrNull?.displayName ?? pid,
      );
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
    final i18n = Translations.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final compact = context.breakpoint.isCompact;

    final search = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 448),
      child: SizedBox(
        height: 36,
        child: TextField(
          controller: _searchCtrl,
          onChanged: ref.read(taskmasterProvider.notifier).setSearchQuery,
          style: TextStyle(color: dark ? Colors.white : const Color(0xFF111827), fontSize: 14),
          decoration: InputDecoration(
            hintText: i18n.tasks.search.placeholder,
            filled: true,
            fillColor: dark ? const Color(0xFF1F2937) : Colors.white,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            prefixIcon: const Icon(LucideIcons.search, size: 16, color: Color(0xFF9CA3AF)),
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
            color: active ? (dark ? const Color(0xFF374151) : Colors.white) : Colors.transparent,
            borderRadius: AppRadii.borderMd,
            boxShadow: active
                ? const [BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))]
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
                    : (dark ? const Color(0xFFD1D5DB) : const Color(0xFF374151)),
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
    final i18n = Translations.of(context);
    return Tooltip(
      message: i18n.tasks.buttons.help,
      child: InkWell(
        onTap: () => showDialog<void>(
          context: context,
          builder: (_) => _HelpDialog(onCreatePrd: () => unawaited(PrdEditorDialog.show(context))),
        ),
        borderRadius: AppRadii.borderLg,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            border: Border.all(color: dark ? const Color(0xFF4B5563) : const Color(0xFFD1D5DB)),
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
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
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
        onTap: state.busy || _pid == null ? null : () => unawaited(PrdEditorDialog.show(context)),
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
                  color: dark ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    p.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: dark ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
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
      onTap: state.busy || _pid == null ? null : () => unawaited(CreateTaskDialog.show(context)),
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
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
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
        _sortChip('ID', TaskSort.position, state, dark, ctrl),
        _sortChip('Status', TaskSort.status, state, dark, ctrl),
        _sortChip('Priority', TaskSort.priority, state, dark, ctrl),
      ],
    );
  }

  Widget _sortChip(
    String label,
    TaskSort sort,
    TaskmasterState state,
    bool dark,
    TaskmasterController ctrl,
  ) {
    final active = state.sort == sort;
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
                    : (dark ? const Color(0xFF9CA3AF) : const Color(0xFF4B5563)),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              !active
                  ? LucideIcons.arrowUpDown
                  : state.sortOrder == SortOrder.asc
                  ? LucideIcons.arrowUp
                  : LucideIcons.arrowDown,
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

  static String _sortKey(TaskSort s) => switch (s) {
    TaskSort.position => 'id',
    TaskSort.status => 'status',
    TaskSort.priority => 'priority',
    TaskSort.title => 'title',
  };

  Widget _filtersPanel(TaskmasterState state) {
    final i18n = Translations.of(context);
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
                '${_sortKey(state.sort)}-${state.sortOrder.name}',
                const [
                  'id-asc',
                  'id-desc',
                  'title-asc',
                  'title-desc',
                  'status-asc',
                  'status-desc',
                  'priority-asc',
                  'priority-desc',
                ],
                (v) {
                  if (v == null) return;
                  final parts = v.split('-');
                  ctrl.setSortConfig(switch (parts.first) {
                    'status' => TaskSort.status,
                    'priority' => TaskSort.priority,
                    'title' => TaskSort.title,
                    _ => TaskSort.position,
                  }, parts.last == 'desc' ? SortOrder.desc : SortOrder.asc);
                },
                dark,
                labels: {
                  'id-asc': 'ID (Ascending)',
                  'id-desc': 'ID (Descending)',
                  'title-asc': i18n.tasks.sort.titleAsc,
                  'title-desc': i18n.tasks.sort.titleDesc,
                  'status-asc': 'Status (A-Z)',
                  'status-desc': 'Status (Z-A)',
                  'priority-asc': 'Priority (High First)',
                  'priority-desc': 'Priority (Low First)',
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
                  color: dark ? const Color(0xFF9CA3AF) : const Color(0xFF4B5563),
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
              border: Border.all(color: dark ? const Color(0xFF4B5563) : const Color(0xFFD1D5DB)),
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
                    DropdownMenuItem<String?>(value: null, child: Text(allLabel)),
                  for (final o in options)
                    DropdownMenuItem<String?>(value: o, child: Text(labels[o] ?? o)),
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
    final i18n = Translations.of(context);
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
              color: (dark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)).withValues(
                alpha: 0.5,
              ),
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

    void onRun(TaskmasterTask t) => unawaited(_runTask(t));
    void onTap(TaskmasterTask t) => unawaited(TaskDetailDialog.show(context, t.idText));
    void onStatusChange((TaskmasterTask, String) e) =>
        unawaited(ctrl.setTaskStatus(e.$1.idText, e.$2));

    if (_viewMode == 'list') {
      return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: AppRadii.borderLg,
          border: Border.all(color: dark ? const Color(0xFF374151) : const Color(0xFFE5E7EB)),
          boxShadow: const [
            BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
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
                    child: TaskBoardCard(task: t, onTap: () => onTap(t), onRun: () => onRun(t)),
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
                  child: TaskBoardCard(task: t, onTap: () => onTap(t), onRun: () => onRun(t)),
                ),
            ],
          );
        },
      );
    }

    // Kanban — responsive grid like `sm:grid md:grid-cols-2 lg:grid-cols-N`,
    // horizontal snap-scroll below that.
    final columns = buildTaskKanbanColumns(tasks, i18n);
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
    final i18n = Translations.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final c = context.appColors;
    final ctrl = ref.read(taskmasterProvider.notifier);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF0F172A).withValues(alpha: 0.3) : const Color(0xFFF8FAFC),
        border: Border.all(color: dark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
        borderRadius: AppRadii.borderLg,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => unawaited(TaskDetailDialog.show(context, task.idText)),
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
                          color: dark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Task ${task.idText}',
                        style: TextStyle(
                          color: dark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
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
                      color: dark ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
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
            message: i18n.tasks.nextTask.viewDetails,
            child: InkWell(
              onTap: () => unawaited(TaskDetailDialog.show(context, task.idText)),
              borderRadius: AppRadii.borderMd,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: dark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                  ),
                  borderRadius: AppRadii.borderMd,
                ),
                child: Icon(
                  LucideIcons.eye,
                  size: 12,
                  color: dark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  VoidCallback stateBusySafe(TaskmasterController ctrl, TaskmasterTask t) =>
      () => unawaited(_runTask(t));

  /// TaskMasterPanel.handleRunTask parity — flip the status, stash
  /// `/task-master start <id>` for the project composer, then open chat.
  Future<void> _runTask(TaskmasterTask t) async {
    final i18n = Translations.of(context);
    final ctrl = ref.read(taskmasterProvider.notifier);
    final pid = ref.read(taskmasterProvider).projectId;
    final prompt = '/task-master start ${t.idText}';
    final ok = await ctrl.setTaskStatus(t.idText, 'in-progress');
    if (!mounted) return;
    if (!ok) {
      AppToast.error(
        context,
        ref.read(taskmasterProvider).error ?? i18n.tasks.taskDetail.statusFailed,
      );
      return;
    }
    await ChatStorage.writeDraft(ChatStorage.draftKey(projectId: pid), prompt);
    ChatStorage.stashRunTask(pid, prompt);
    if (!mounted) return;
    AppToast.show(context, i18n.tasks.toasts.statusInProgress(id: t.idText));
    context.go('/workspace');
  }
}

/// `TaskHelpModal` parity — getting-started steps, pro tips and the GitHub
/// link in a dialog.
class _HelpDialog extends StatelessWidget {
  const _HelpDialog({this.onCreatePrd});

  /// Called after the dialog closes when the step-1 "Add PRD" button is
  /// tapped — must be bound to a context that outlives the dialog route.
  final VoidCallback? onCreatePrd;

  // accent colors from TaskHelpModal.tsx (border + bg per step).
  static const _steps = [
    (
      'Create a Product Requirements Document (PRD)',
      'Discuss your project idea and create a PRD that describes what you '
          'want to build.',
      Color(0xFFBFDBFE),
      Color(0xFFEFF6FF),
    ),
    (
      'Generate Tasks from PRD',
      'Once you have a PRD, ask your AI assistant to parse it and TaskMaster '
          'will automatically break it down into manageable tasks with '
          'implementation details.',
      Color(0xFFA7F3D0),
      Color(0xFFECFDF5),
    ),
    (
      'Analyze & Expand Tasks',
      'Ask your AI assistant to analyze task complexity and expand them into '
          'detailed subtasks for easier implementation.',
      Color(0xFFFDE68A),
      Color(0xFFFFFBEB),
    ),
    (
      'Start Building',
      'Ask your AI assistant to begin working on tasks, update their status, '
          'and add new tasks as your project evolves.',
      Color(0xFFE9D5FF),
      Color(0xFFFAF5FF),
    ),
  ];

  static const _tips = [
    'Use the search bar to quickly find specific tasks',
    'Switch between Kanban, List, and Grid views using the view toggles',
    'Use filters to focus on specific task statuses or priorities',
    'Click on any task to view detailed information and manage subtasks',
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      backgroundColor: c.popover,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 896),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
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
                    child: const Icon(LucideIcons.fileText, size: 20, color: Color(0xFF2563EB)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Getting Started with TaskMaster',
                          style: t.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Your guide to productive task management',
                          style: t.bodySmall?.copyWith(color: c.mutedForeground),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    tooltip: i18n.tasks.helpGuide.closeTitle,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: c.border),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    for (var i = 0; i < _steps.length; i++)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: dark ? _steps[i].$4.withValues(alpha: 0.08) : _steps[i].$4,
                          border: Border.all(
                            color: dark ? _steps[i].$3.withValues(alpha: 0.4) : _steps[i].$3,
                          ),
                          borderRadius: AppRadii.borderLg,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2563EB),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${i + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _steps[i].$1,
                                    style: t.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _steps[i].$2,
                                    style: t.bodySmall?.copyWith(color: c.mutedForeground),
                                  ),
                                  if (i == 0) ...[
                                    const SizedBox(height: 12),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        onCreatePrd?.call();
                                      },
                                      borderRadius: AppRadii.borderSm,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: dark
                                              ? const Color(0xFF581C87).withValues(alpha: 0.3)
                                              : const Color(0xFFF3E8FF),
                                          borderRadius: AppRadii.borderSm,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              LucideIcons.fileText,
                                              size: 16,
                                              color: dark
                                                  ? const Color(0xFFD8B4FE)
                                                  : const Color(0xFF7E22CE),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Add PRD',
                                              style: t.bodySmall?.copyWith(
                                                color: dark
                                                    ? const Color(0xFFD8B4FE)
                                                    : const Color(0xFF7E22CE),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: dark ? c.muted.withValues(alpha: 0.3) : const Color(0xFFF9FAFB),
                        border: Border.all(color: c.border),
                        borderRadius: AppRadii.borderLg,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '💡 Pro Tips',
                            style: t.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          for (final tip in _tips)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                tip,
                                style: t.bodySmall?.copyWith(color: c.mutedForeground),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: dark
                            ? const Color(0xFF172554).withValues(alpha: 0.4)
                            : const Color(0xFFEFF6FF),
                        border: Border.all(
                          color: dark ? const Color(0xFF1E40AF) : const Color(0xFFBFDBFE),
                        ),
                        borderRadius: AppRadii.borderLg,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '📚 Learn More',
                            style: t.titleSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: dark ? const Color(0xFFDBEAFE) : const Color(0xFF1E3A8A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'TaskMaster AI is an advanced task management '
                            'system built for developers. Get documentation, '
                            'examples, and contribute to the project.',
                            style: t.bodySmall?.copyWith(
                              color: dark ? const Color(0xFFBFDBFE) : const Color(0xFF1E40AF),
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () => unawaited(
                              launchUrl(
                                Uri.parse(
                                  'https://github.com/eyaltoledano/'
                                  'claude-task-master',
                                ),
                                mode: LaunchMode.externalApplication,
                              ),
                            ),
                            borderRadius: AppRadii.borderLg,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2563EB),
                                borderRadius: AppRadii.borderLg,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'View on GitHub',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(LucideIcons.externalLink, size: 16, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
                    color: dark ? const Color(0xFF1E40AF) : const Color(0xFFBFDBFE),
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
                              style: TextStyle(color: c.mutedForeground, fontSize: 14),
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
                              style: TextStyle(color: c.mutedForeground, fontSize: 14),
                            ),
                            if (i == 0) ...[
                              const SizedBox(height: 12),
                              InkWell(
                                onTap: () => unawaited(PrdEditorDialog.show(context)),
                                borderRadius: AppRadii.borderSm,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: dark
                                        ? const Color(0xFF581C87).withValues(alpha: 0.3)
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
                                  style: TextStyle(color: c.mutedForeground, fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    for (final p in state.prdFiles)
                                      InkWell(
                                        onTap: () => unawaited(
                                          PrdEditorDialog.show(context, fileName: p.fileName),
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
                                                style: TextStyle(color: c.foreground, fontSize: 12),
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
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9333EA),
                          borderRadius: AppRadii.borderLg,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.fileText, size: 16, color: Colors.white),
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
  const _SetupView({required this.state, required this.projectId, required this.projectName});

  final TaskmasterState state;
  final String projectId;
  final String projectName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final i18n = Translations.of(context);
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
              const Icon(LucideIcons.settings, size: 48, color: Color(0xFF2563EB)),
              const SizedBox(height: 16),
              Text(
                'TaskMaster AI is not configured',
                textAlign: TextAlign.center,
                style: TextStyle(color: c.foreground, fontSize: 18, fontWeight: FontWeight.w600),
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
                  color: dark ? const Color(0xFF172554) : const Color(0xFFEFF6FF),
                  borderRadius: AppRadii.borderLg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎯 What is TaskMaster?',
                      style: TextStyle(
                        color: dark ? const Color(0xFFDBEAFE) : const Color(0xFF1E3A8A),
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
                            color: dark ? const Color(0xFFBFDBFE) : const Color(0xFF1E40AF),
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (state.config?.isInstalled == true && state.config?.version != null)
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
                    // TaskEmptyState → TaskMasterSetupModal: the button opens
                    // the setup dialog; init runs inside it.
                    onTap: () => unawaited(
                      showDialog<void>(
                        context: context,
                        builder: (_) => _SetupDialog(
                          projectId: projectId,
                          projectName: projectName,
                          onAfterClose: () =>
                              unawaited(ref.read(taskmasterProvider.notifier).load(projectId)),
                        ),
                      ),
                    ),
                    borderRadius: AppRadii.borderLg,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: AppRadii.borderLg,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.terminal, size: 16, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
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
                    child: Text(i18n.tasks.notConfigured.writePrdFirst),
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

/// `TaskMasterSetupModal` parity — confirms init, runs `ctrl.init()`, shows
/// the completed state, auto-fires `onAfterClose` after 800 ms (single-fire,
/// the dialog itself stays open for "Close & Continue").
class _SetupDialog extends ConsumerStatefulWidget {
  const _SetupDialog({
    required this.projectId,
    required this.projectName,
    required this.onAfterClose,
  });

  final String projectId;
  final String projectName;
  final VoidCallback onAfterClose;

  @override
  ConsumerState<_SetupDialog> createState() => _SetupDialogState();
}

class _SetupDialogState extends ConsumerState<_SetupDialog> {
  bool _initializing = false;
  bool _complete = false;
  String? _error;
  bool _afterCloseNotified = false;
  Timer? _afterCloseTimer;

  @override
  void dispose() {
    _afterCloseTimer?.cancel();
    super.dispose();
  }

  void _notifyAfterClose() {
    if (_afterCloseNotified) return;
    _afterCloseNotified = true;
    widget.onAfterClose();
  }

  void _close() {
    _afterCloseTimer?.cancel();
    if (_complete) _notifyAfterClose();
    Navigator.of(context).pop();
  }

  Future<void> _initialize() async {
    if (_initializing) return;
    setState(() {
      _initializing = true;
      _error = null;
      _afterCloseNotified = false;
    });
    final ok = await ref.read(taskmasterProvider.notifier).init();
    if (!mounted) return;
    setState(() {
      _initializing = false;
      if (ok) {
        _complete = true;
      } else {
        _error = ref.read(taskmasterProvider).error ?? 'Failed to initialize TaskMaster';
      }
    });
    if (ok) {
      _afterCloseTimer = Timer(const Duration(milliseconds: 800), _notifyAfterClose);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return AlertDialog(
      backgroundColor: c.popover,
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      actionsPadding: const EdgeInsets.all(16),
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: dark
                  ? const Color(0xFF1E3A8A).withValues(alpha: 0.5)
                  : const Color(0xFFDBEAFE),
              borderRadius: AppRadii.borderLg,
            ),
            child: const Icon(LucideIcons.terminal, size: 16, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TaskMaster Setup',
                  style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Interactive CLI for ${widget.projectName}',
                  style: t.bodySmall?.copyWith(color: c.mutedForeground),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            tooltip: i18n.tasks.setupModal.closeTitle,
            onPressed: _close,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Creates a .taskmaster folder in this project. No external '
            'tooling or API keys required — tasks are stored locally.',
            style: t.bodySmall?.copyWith(color: c.mutedForeground),
          ),
          if (_complete)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.circleCheck,
                    size: 16,
                    color: dark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'TaskMaster setup completed! '
                      'You can now close this window.',
                      style: t.bodySmall?.copyWith(
                        color: dark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_error!, style: t.bodySmall?.copyWith(color: c.destructive)),
            ),
        ],
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.outline,
          onPressed: _close,
          child: Text(_complete ? 'Close & Continue' : 'Close'),
        ),
        if (!_complete)
          AppButton(
            variant: AppButtonVariant.primary,
            loading: _initializing,
            onPressed: _initializing ? null : () => unawaited(_initialize()),
            child: Text(_initializing ? 'Initializing...' : 'Initialize'),
          ),
      ],
    );
  }
}
