import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_models.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';

const taskStatuses = ['pending', 'in-progress', 'review', 'done', 'deferred', 'cancelled'];

const taskPriorities = ['high', 'medium', 'low'];

Color taskStatusColor(String status, AppColors c) => switch (status) {
  'done' => const Color(0xFF22C55E),
  'in-progress' => c.primary,
  'review' => const Color(0xFFF59E0B),
  'cancelled' => c.destructive,
  _ => c.mutedForeground,
};

IconData taskStatusIcon(String status) => switch (status) {
  'done' => Icons.check_circle,
  'in-progress' => Icons.schedule,
  'review' => Icons.error_outline,
  'deferred' => Icons.pause_circle_outline,
  'cancelled' => Icons.cancel_outlined,
  _ => Icons.radio_button_unchecked,
};

/// Localized display name for a task status wire value (unknown → as-is).
String taskStatusLabel(String status, Translations i18n) => switch (status) {
  'pending' => i18n.tasks.statuses.pending,
  'in-progress' => i18n.tasks.statuses.inProgress,
  'review' => i18n.tasks.statuses.review,
  'done' => i18n.tasks.statuses.done,
  'blocked' => i18n.tasks.statuses.blocked,
  'deferred' => i18n.tasks.statuses.deferred,
  'cancelled' => i18n.tasks.statuses.cancelled,
  _ => status,
};

/// Localized display name for a task priority wire value (unknown → as-is).
String taskPriorityLabel(String priority, Translations i18n) => switch (priority) {
  'high' => i18n.tasks.priorities.high,
  'medium' => i18n.tasks.priorities.medium,
  'low' => i18n.tasks.priorities.low,
  _ => priority,
};

Color taskPriorityColor(String priority, AppColors c) => switch (priority) {
  'high' => c.destructive,
  'medium' => const Color(0xFFF59E0B),
  'low' => c.primary,
  _ => c.mutedForeground,
};

/// Task row/card for the taskmaster list (port of CompactTaskRow/TaskCard):
/// status checkbox, id chip, title, priority badge, dependency chips,
/// subtask progress and a run shortcut.
class TaskmasterTaskTile extends StatelessWidget {
  const TaskmasterTaskTile({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggleDone,
    required this.onRun,
    this.busy = false,
  });

  final TaskmasterTask task;
  final VoidCallback onTap;

  /// done → reopen as pending; anything else → done.
  final VoidCallback onToggleDone;

  /// Start the task (pending → in-progress).
  final VoidCallback onRun;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final done = task.status == 'done';
    final inProgress = task.status == 'in-progress';
    final subs = task.subtasks;
    final subsDone = subs.where((s) => s.isDone).length;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.borderMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                tooltip: done ? i18n.tasks.list.reopen : i18n.tasks.list.markDone,
                onPressed: busy ? null : onToggleDone,
                icon: Icon(
                  taskStatusIcon(task.status),
                  size: 18,
                  color: taskStatusColor(task.status, c),
                ),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 28, height: 28),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: c.muted,
                            borderRadius: AppRadii.borderSm,
                          ),
                          child: Text(
                            '#${task.idText}',
                            style: t.labelSmall?.copyWith(
                              fontFamily: 'monospace',
                              color: c.mutedForeground,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _badge(
                          taskPriorityLabel(task.priority, i18n),
                          taskPriorityColor(task.priority, c),
                          t,
                        ),
                        const SizedBox(width: 4),
                        _badge(
                          taskStatusLabel(task.status, i18n),
                          taskStatusColor(task.status, c),
                          t,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodyMedium?.copyWith(
                        decoration: done ? TextDecoration.lineThrough : null,
                        color: done ? c.mutedForeground : c.foreground,
                      ),
                    ),
                    if (task.description.isNotEmpty)
                      Text(
                        task.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodySmall?.copyWith(color: c.mutedForeground),
                      ),
                    if (task.dependencies.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          i18n.tasks.card.dependsOnList(tasks: task.dependencies.join(', ')),
                          style: t.labelSmall?.copyWith(
                            color: const Color(0xFFF59E0B),
                            fontSize: 10,
                          ),
                        ),
                      ),
                    if (subs.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: AppRadii.borderSm,
                                child: LinearProgressIndicator(
                                  value: subsDone / subs.length,
                                  minHeight: 4,
                                  backgroundColor: c.muted,
                                  color: done ? const Color(0xFF22C55E) : c.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$subsDone/${subs.length}',
                              style: t.labelSmall?.copyWith(color: c.mutedForeground, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (!done)
                IconButton(
                  tooltip: inProgress
                      ? i18n.tasks.card.taskInProgress
                      : i18n.tasks.nextTask.startTask,
                  onPressed: busy || inProgress ? null : onRun,
                  icon: Icon(
                    Icons.play_arrow,
                    size: 18,
                    color: inProgress ? c.primary : c.mutedForeground,
                  ),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(width: 28, height: 28),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(String label, Color color, TextTheme t) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      border: Border.all(color: color.withValues(alpha: 0.35)),
      borderRadius: AppRadii.borderSm,
    ),
    child: Text(label, style: t.labelSmall?.copyWith(color: color, fontSize: 10)),
  );
}
