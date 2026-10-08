import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_models.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Column visual spec — port of `KANBAN_COLUMN_CONFIG`
/// (src/components/task-master/utils/taskKanban.ts). Headers are the
/// Tailwind `*-100/*-800` (light) / `*-800/*-200` (dark) pairs.
class TaskColumnSpec {
  const TaskColumnSpec({
    required this.status,
    required this.title,
    required this.headerBgLight,
    required this.headerFgLight,
    required this.headerBgDark,
    required this.headerFgDark,
  });

  final String status;
  final String title;
  final Color headerBgLight;
  final Color headerFgLight;
  final Color headerBgDark;
  final Color headerFgDark;
}

List<TaskColumnSpec> _taskColumnConfig(Translations i18n) => [
  TaskColumnSpec(
    status: 'pending',
    title: i18n.tasks.kanban.pending,
    headerBgLight: Color(0xFFF1F5F9), // slate-100
    headerFgLight: Color(0xFF1E293B), // slate-800
    headerBgDark: Color(0xFF1E293B), // slate-800
    headerFgDark: Color(0xFFE2E8F0), // slate-200
  ),
  TaskColumnSpec(
    status: 'in-progress',
    title: i18n.tasks.kanban.inProgress,
    headerBgLight: Color(0xFFDBEAFE), // blue-100
    headerFgLight: Color(0xFF1E40AF), // blue-800
    headerBgDark: Color(0xFF1E40AF), // blue-800
    headerFgDark: Color(0xFFBFDBFE), // blue-200
  ),
  TaskColumnSpec(
    status: 'review',
    title: i18n.tasks.kanban.review,
    headerBgLight: Color(0xFFEDE9FE), // violet-100
    headerFgLight: Color(0xFF5B21B6), // violet-800
    headerBgDark: Color(0xFF5B21B6), // violet-800
    headerFgDark: Color(0xFFDDD6FE), // violet-200
  ),
  TaskColumnSpec(
    status: 'done',
    title: i18n.tasks.kanban.done,
    headerBgLight: Color(0xFFD1FAE5), // emerald-100
    headerFgLight: Color(0xFF065F46), // emerald-800
    headerBgDark: Color(0xFF065F46), // emerald-800
    headerFgDark: Color(0xFFA7F3D0), // emerald-200
  ),
  TaskColumnSpec(
    status: 'blocked',
    title: i18n.tasks.kanban.blocked,
    headerBgLight: Color(0xFFFEE2E2), // red-100
    headerFgLight: Color(0xFF991B1B), // red-800
    headerBgDark: Color(0xFF991B1B), // red-800
    headerFgDark: Color(0xFFFECACA), // red-200
  ),
  TaskColumnSpec(
    status: 'deferred',
    title: i18n.tasks.kanban.deferred,
    headerBgLight: Color(0xFFFEF3C7), // amber-100
    headerFgLight: Color(0xFF92400E), // amber-800
    headerBgDark: Color(0xFF92400E), // amber-800
    headerFgDark: Color(0xFFFDE68A), // amber-200
  ),
  TaskColumnSpec(
    status: 'cancelled',
    title: i18n.tasks.kanban.cancelled,
    headerBgLight: Color(0xFFF3F4F6), // gray-100
    headerFgLight: Color(0xFF1F2937), // gray-800
    headerBgDark: Color(0xFF1F2937), // gray-800
    headerFgDark: Color(0xFFE5E7EB), // gray-200
  ),
];

/// Core statuses always render; the rest only appear when they hold tasks
/// (`buildKanbanColumns` + `CORE_WORKFLOW_STATUSES`).
const _coreStatuses = {'pending', 'in-progress', 'done'};

class TaskKanbanColumn {
  const TaskKanbanColumn({required this.spec, required this.tasks});

  final TaskColumnSpec spec;
  final List<TaskmasterTask> tasks;
}

List<TaskKanbanColumn> buildTaskKanbanColumns(List<TaskmasterTask> tasks, Translations i18n) {
  final byStatus = <String, List<TaskmasterTask>>{};
  for (final t in tasks) {
    (byStatus[t.status] ??= []).add(t);
  }
  return [
    for (final spec in _taskColumnConfig(i18n))
      if (_coreStatuses.contains(spec.status) || (byStatus[spec.status]?.isNotEmpty ?? false))
        TaskKanbanColumn(spec: spec, tasks: byStatus[spec.status] ?? const []),
  ];
}

/// Status → (dot color, label color, label) — `getStatusStyle` in TaskCard.tsx.
({Color dot, Color fg, String label}) taskStatusStyle(
  String status,
  AppColors c,
  bool dark,
  Translations i18n,
) => switch (status) {
  'done' => (
    dot: const Color(0xFF16A34A),
    fg: dark ? const Color(0xFFDCFCE7) : const Color(0xFF14532D),
    label: i18n.tasks.statuses.done,
  ),
  'in-progress' => (
    dot: const Color(0xFF2563EB),
    fg: dark ? const Color(0xFFDBEAFE) : const Color(0xFF1E3A8A),
    label: i18n.tasks.statuses.inProgress,
  ),
  'review' => (
    dot: const Color(0xFFD97706),
    fg: dark ? const Color(0xFFFEF3C7) : const Color(0xFF78350F),
    label: i18n.tasks.statuses.review,
  ),
  'deferred' => (
    dot: c.mutedForeground,
    fg: c.mutedForeground,
    label: i18n.tasks.statuses.deferred,
  ),
  'cancelled' => (
    dot: const Color(0xFFDC2626),
    fg: dark ? const Color(0xFFFEE2E2) : const Color(0xFF7F2D2D),
    label: i18n.tasks.statuses.cancelled,
  ),
  'blocked' => (
    dot: const Color(0xFFDC2626),
    fg: dark ? const Color(0xFFFEE2E2) : const Color(0xFF7F2D2D),
    label: i18n.tasks.statuses.blocked,
  ),
  _ => (dot: c.mutedForeground, fg: c.foreground, label: i18n.tasks.statuses.pending),
};

/// 16×16 rounded priority tile — `renderPriorityIcon` in TaskCard.tsx.
Widget taskPriorityTile(String priority, AppColors c, bool dark) {
  final (bg, icon, iconColor) = switch (priority) {
    'high' => (
      dark ? const Color(0xFF7F1D1D).withValues(alpha: 0.3) : const Color(0xFFFEE2E2),
      LucideIcons.chevronUp,
      dark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
    ),
    'medium' => (
      dark ? const Color(0xFF78350F).withValues(alpha: 0.3) : const Color(0xFFFEF3C7),
      LucideIcons.minus,
      dark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
    ),
    'low' => (
      dark ? const Color(0xFF1E3A8A).withValues(alpha: 0.3) : const Color(0xFFDBEAFE),
      LucideIcons.circle,
      dark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
    ),
    _ => (c.muted, LucideIcons.circle, c.mutedForeground),
  };
  final label = switch (priority) {
    'high' => t.tasks.card.highPriority,
    'medium' => t.tasks.card.mediumPriority,
    'low' => t.tasks.card.lowPriority,
    _ => t.tasks.card.noPriority,
  };
  return Tooltip(
    message: label,
    child: Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(color: bg, borderRadius: AppRadii.borderSm),
      child: Icon(icon, size: 10, color: iconColor),
    ),
  );
}

/// Play/run affordance shared by card + row — `Play` 14px in a 24px tile;
/// blue when in progress, muted otherwise.
Widget taskRunButton(
  AppColors c,
  bool dark, {
  required bool inProgress,
  required VoidCallback? onRun,
}) {
  return Tooltip(
    message: inProgress ? t.tasks.card.taskInProgress : t.tasks.card.runTask,
    child: InkWell(
      onTap: onRun,
      borderRadius: AppRadii.borderSm,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: inProgress
              ? (dark ? const Color(0xFF1E3A8A).withValues(alpha: 0.3) : const Color(0xFFEFF6FF))
              : null,
          borderRadius: AppRadii.borderSm,
        ),
        child: Icon(
          LucideIcons.play,
          size: 14,
          color: inProgress
              ? (dark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB))
              : c.mutedForeground,
        ),
      ),
    ),
  );
}

/// Monospace id chip — `rounded bg-muted px-2 py-0.5 font-mono text-xs
/// text-muted-foreground` (kanban card) / gray-100 (compact row).
Widget taskIdChip(AppColors c, String idText, {bool compact = false, bool dark = false}) {
  return Container(
    padding: compact
        ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
        : const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: compact ? (dark ? const Color(0xFF374151) : const Color(0xFFF3F4F6)) : c.muted,
      borderRadius: AppRadii.borderSm,
    ),
    child: Text(
      idText,
      style: TextStyle(
        color: compact
            ? (dark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280))
            : c.mutedForeground,
        fontSize: 12,
        fontFamily: 'monospace',
      ),
    ),
  );
}

/// Kanban column — `rounded-xl border bg-muted/50 border-border shadow-sm`
/// with the status-colored `px-4 py-3` header and a drag target body.
class TaskBoardColumn extends StatelessWidget {
  const TaskBoardColumn({
    super.key,
    required this.column,
    required this.onTaskTap,
    required this.onRunTask,
    required this.onStatusChange,
    this.width,
  });

  final TaskKanbanColumn column;
  final ValueChanged<TaskmasterTask> onTaskTap;
  final ValueChanged<TaskmasterTask> onRunTask;
  final ValueChanged<(TaskmasterTask, String)> onStatusChange;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final headerBg = dark ? column.spec.headerBgDark : column.spec.headerBgLight;
    final headerFg = dark ? column.spec.headerFgDark : column.spec.headerFgLight;

    return Container(
      width: width,
      constraints: const BoxConstraints(minHeight: 220),
      decoration: BoxDecoration(
        color: c.muted.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: c.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    column.spec.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: headerFg, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: dark
                        ? Colors.black.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    '${column.tasks.length}',
                    style: TextStyle(color: headerFg, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          DragTarget<TaskmasterTask>(
            onWillAcceptWithDetails: (d) => d.data.status != column.spec.status,
            onAcceptWithDetails: (d) => onStatusChange((d.data, column.spec.status)),
            builder: (context, candidateData, _) => Container(
              constraints: const BoxConstraints(minHeight: 200),
              width: double.infinity,
              color: candidateData.isNotEmpty
                  ? c.primary.withValues(alpha: 0.05)
                  : Colors.transparent,
              padding: const EdgeInsets.all(12),
              child: column.tasks.isEmpty
                  ? _TaskColumnEmpty(status: column.spec.status)
                  : Column(
                      children: [
                        for (final t in column.tasks)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Draggable<TaskmasterTask>(
                              data: t,
                              feedback: Material(
                                color: Colors.transparent,
                                child: SizedBox(
                                  width: 300,
                                  child: Opacity(
                                    opacity: 0.9,
                                    child: TaskBoardCard(
                                      task: t,
                                      onTap: () {},
                                      onRun: null,
                                      interactive: false,
                                    ),
                                  ),
                                ),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.4,
                                child: TaskBoardCard(
                                  task: t,
                                  onTap: () {},
                                  onRun: null,
                                  interactive: false,
                                ),
                              ),
                              child: TaskBoardCard(
                                key: ValueKey(t.idText),
                                task: t,
                                onTap: () => onTaskTap(t),
                                onRun: () => onRunTask(t),
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// `EmptyState size="sm"` for an empty column — icon tile + title + status
/// description, centered.
class _TaskColumnEmpty extends StatelessWidget {
  const _TaskColumnEmpty({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final i18n = Translations.of(context);
    final desc = switch (status) {
      'pending' => i18n.tasks.kanban.tasksWillAppear,
      'in-progress' => i18n.tasks.kanban.moveTasksHere,
      'done' => i18n.tasks.kanban.completedTasksHere,
      _ => i18n.tasks.kanban.statusTasksHere,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: c.muted.withValues(alpha: 0.4),
              border: Border.all(color: c.border.withValues(alpha: 0.6)),
              borderRadius: AppRadii.borderLg,
            ),
            child: Icon(LucideIcons.circleDashed, size: 16, color: c.mutedForeground),
          ),
          const SizedBox(height: 8),
          Text(
            i18n.tasks.kanban.noTasksYet,
            style: TextStyle(color: c.foreground, fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(color: c.mutedForeground, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Task card — port of `TaskCard`: id chip + clamped title, priority tile +
/// run button top-right, dependency line, status dot + label, subtask
/// progress bar. `hover:border-blue-300 shadow-md -translate-y-0.5`.
class TaskBoardCard extends StatefulWidget {
  const TaskBoardCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onRun,
    this.interactive = true,
  });

  final TaskmasterTask task;
  final VoidCallback onTap;
  final VoidCallback? onRun;

  /// False while used as drag feedback — no hover state needed.
  final bool interactive;

  @override
  State<TaskBoardCard> createState() => _TaskBoardCardState();
}

class _TaskBoardCardState extends State<TaskBoardCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final i18n = Translations.of(context);
    final task = widget.task;
    final status = taskStatusStyle(task.status, c, dark, i18n);
    final subs = task.subtasks;
    final subsDone = subs.where((s) => s.isDone).length;
    final parentId = task.raw['parentId'];
    final deps = task.dependencies;
    final depsLabel = i18n.tasks.card.dependsOnList(tasks: deps.join(', '));
    final inProgress = task.status == 'in-progress';

    final card = AnimatedContainer(
      duration: AppMotion.base,
      transform: Matrix4.translationValues(0, _hover && widget.interactive ? -2 : 0, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: AppRadii.borderLg,
        border: Border.all(
          color: _hover && widget.interactive
              ? (dark ? const Color(0xFF2563EB) : const Color(0xFF93C5FD))
              : c.border,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000)
                .withValues(alpha: _hover && widget.interactive ? 0.10 : 0.05),
            blurRadius: _hover && widget.interactive ? 6 : 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    taskIdChip(c, task.idText, dark: dark),
                    const SizedBox(height: 4),
                    Text(
                      task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: c.foreground,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                      ),
                    ),
                    if (parentId != null && '$parentId'.isNotEmpty)
                      Text(
                        i18n.tasks.card.parentTask(id: '$parentId'),
                        style: TextStyle(
                          color: c.mutedForeground,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              taskPriorityTile(task.priority, c, dark),
              const SizedBox(width: 6),
              taskRunButton(
                c,
                dark,
                inProgress: inProgress,
                onRun: inProgress ? null : widget.onRun,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (deps.isNotEmpty)
                Tooltip(
                  message: depsLabel,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.arrowRight,
                        size: 12,
                        color: dark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        depsLabel,
                        style: TextStyle(
                          color: dark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              Tooltip(
                message: i18n.tasks.card.statusTooltip(status: status.label),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: status.dot, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      status.label,
                      style: TextStyle(color: status.fg, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (subs.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                children: [
                  Text(
                    i18n.tasks.card.progressLabel,
                    style: TextStyle(color: c.mutedForeground, fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9999),
                      child: SizedBox(
                        height: 6,
                        child: LinearProgressIndicator(
                          value: subs.isEmpty ? 0 : subsDone / subs.length,
                          backgroundColor: c.muted,
                          color: task.status == 'done'
                              ? const Color(0xFF22C55E)
                              : const Color(0xFF3B82F6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$subsDone/${subs.length}',
                    style: TextStyle(color: c.mutedForeground, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );

    return MouseRegion(
      onEnter: widget.interactive ? (_) => setState(() => _hover = true) : null,
      onExit: widget.interactive ? (_) => setState(() => _hover = false) : null,
      child: InkWell(
        onTap: widget.interactive ? widget.onTap : null,
        borderRadius: AppRadii.borderLg,
        hoverColor: Colors.transparent,
        child: card,
      ),
    );
  }
}

/// Bordered status/priority capsule used by the compact list row —
/// `px-2 py-0.5 rounded text-[11px] font-medium` with per-priority tint.
class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge(this.priority);

  final String priority;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final i18n = Translations.of(context);
    final (bg, fg, border) = switch (priority) {
      'high' => (
        dark ? const Color(0xFF450A0A).withValues(alpha: 0.5) : const Color(0xFFFEF2F2),
        dark ? const Color(0xFFFCA5A5) : const Color(0xFFB91C1C),
        dark ? const Color(0xFF7F1D1D) : const Color(0xFFFECACA),
      ),
      'medium' => (
        dark ? const Color(0xFF451A03).withValues(alpha: 0.5) : const Color(0xFFFFFBEB),
        dark ? const Color(0xFFFCD34D) : const Color(0xFFB45309),
        dark ? const Color(0xFF78350F) : const Color(0xFFFDE68A),
      ),
      'low' => (
        dark ? const Color(0xFF172554).withValues(alpha: 0.5) : const Color(0xFFEFF6FF),
        dark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
        dark ? const Color(0xFF1E3A8A) : const Color(0xFFBFDBFE),
      ),
      _ => (
        dark ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB),
        dark ? const Color(0xFF9CA3AF) : const Color(0xFF4B5563),
        dark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
      ),
    };
    final label = switch (priority) {
      'high' => i18n.tasks.priorities.high,
      'medium' => i18n.tasks.priorities.medium,
      'low' => i18n.tasks.priorities.low,
      _ => priority,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: AppRadii.borderSm,
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }
}

/// Compact list row — `CompactTaskRow`: status toggle, id chip, title
/// (line-through when done), priority badge, run button; `border-b`
/// separated inside the surrounding container.
class TaskCompactRow extends StatefulWidget {
  const TaskCompactRow({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggleDone,
    required this.onRun,
    this.busy = false,
  });

  final TaskmasterTask task;
  final VoidCallback onTap;
  final VoidCallback onToggleDone;
  final VoidCallback onRun;
  final bool busy;

  @override
  State<TaskCompactRow> createState() => _TaskCompactRowState();
}

class _TaskCompactRowState extends State<TaskCompactRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final i18n = Translations.of(context);
    final task = widget.task;
    final done = task.status == 'done';
    final inProgress = task.status == 'in-progress';
    final parentId = task.raw['parentId'];

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: InkWell(
        onTap: widget.onTap,
        hoverColor: Colors.transparent,
        child: AnimatedContainer(
          duration: AppMotion.hover,
          color: _hover
              ? (dark ? const Color(0xFF374151).withValues(alpha: 0.5) : const Color(0xFFF9FAFB))
              : done
              ? (dark
                    ? const Color(0xFF1F2937).withValues(alpha: 0.4)
                    : const Color(0xFFF9FAFB).withValues(alpha: 0.4))
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Tooltip(
                message: done
                    ? i18n.tasks.list.completedReopen
                    : inProgress
                    ? i18n.tasks.list.inProgressComplete
                    : i18n.tasks.list.markCompleted,
                child: InkWell(
                  onTap: widget.busy ? null : widget.onToggleDone,
                  borderRadius: BorderRadius.circular(9999),
                  child: Icon(
                    done
                        ? LucideIcons.checkCircle
                        : inProgress
                        ? LucideIcons.clock
                        : LucideIcons.circle,
                    size: 16,
                    color: done
                        ? (dark ? const Color(0xFF34D399) : const Color(0xFF10B981))
                        : inProgress
                        ? (dark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6))
                        : (_hover
                              ? (dark ? const Color(0xFF4B5563) : const Color(0xFF9CA3AF))
                              : (dark ? const Color(0xFF4B5563) : const Color(0xFFD1D5DB))),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              taskIdChip(c, task.idText, compact: true, dark: dark),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: done ? TextDecoration.lineThrough : null,
                          color: done
                              ? (dark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF))
                              : (dark ? const Color(0xFFF9FAFB) : const Color(0xFF111827)),
                        ),
                      ),
                    ),
                    if (parentId != null && '$parentId'.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: dark
                              ? const Color(0xFF374151).withValues(alpha: 0.6)
                              : const Color(0xFFF3F4F6),
                          borderRadius: AppRadii.borderSm,
                        ),
                        child: Text(
                          i18n.tasks.card.parentTask(id: '$parentId'),
                          style: TextStyle(
                            color: dark ? const Color(0xFF9CA3AF) : const Color(0xFF9CA3AF),
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _PriorityBadge(task.priority),
              const SizedBox(width: 8),
              taskRunButton(
                c,
                dark,
                inProgress: inProgress,
                onRun: widget.busy || inProgress ? null : widget.onRun,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
