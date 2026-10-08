import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_models.dart';
import 'package:ddagent_app/features/taskmaster/state/taskmaster_controller.dart';
import 'package:ddagent_app/features/taskmaster/view/task_tile.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Task details + edit dialog (port of TaskDetailModal): status select is
/// always live; the rest flips between view and edit mode; dependencies are
/// edited as comma-separated ids; delete sits behind a confirmation.
class TaskDetailDialog extends ConsumerStatefulWidget {
  const TaskDetailDialog({super.key, required this.taskId});

  /// Resolved live from `taskmasterProvider.tasks` so edits re-render.
  final String taskId;

  static Future<void> show(BuildContext context, String taskId) => showDialog<void>(
    context: context,
    builder: (_) => TaskDetailDialog(taskId: taskId),
  );

  @override
  ConsumerState<TaskDetailDialog> createState() => _TaskDetailDialogState();
}

class _TaskDetailDialogState extends ConsumerState<TaskDetailDialog> {
  bool _editing = false;
  String _error = '';
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _details;
  late final TextEditingController _testStrategy;
  late final TextEditingController _deps;
  String _priority = 'medium';
  String? _taskId;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _details.dispose();
    _testStrategy.dispose();
    _deps.dispose();
    super.dispose();
  }

  /// Fill the form once per task; never overwrite in-flight edits.
  void _loadIntoFields(TaskmasterTask task) {
    if (_taskId == task.idText || _editing) return;
    _taskId = task.idText;
    _title.text = task.title;
    _description.text = task.description;
    _details.text = task.details;
    _testStrategy.text = task.testStrategy;
    _deps.text = task.dependencies.join(', ');
    _priority = task.priority;
  }

  @override
  void initState() {
    super.initState();
    _title = TextEditingController();
    _description = TextEditingController();
    _details = TextEditingController();
    _testStrategy = TextEditingController();
    _deps = TextEditingController();
  }

  TaskmasterTask? _task(TaskmasterState s) {
    for (final t in s.tasks) {
      if (t.idText == widget.taskId) return t;
    }
    return null;
  }

  Future<void> _save(TaskmasterTask task) async {
    if (_title.text.trim().isEmpty) {
      setState(() => _error = Translations.of(context).tasks.taskDetail.titleRequired);
      return;
    }
    final deps = [
      for (final e in _deps.text.split(','))
        if (e.trim().isNotEmpty) e.trim(),
    ];
    final updates = <String, dynamic>{};
    if (_title.text.trim() != task.title) {
      updates['title'] = _title.text.trim();
    }
    if (_description.text != task.description) {
      updates['description'] = _description.text;
    }
    if (_details.text != task.details) updates['details'] = _details.text;
    if (_testStrategy.text != task.testStrategy) {
      updates['testStrategy'] = _testStrategy.text;
    }
    if (_priority != task.priority) updates['priority'] = _priority;
    if (deps.join(',') != task.dependencies.map((d) => '$d').join(',')) {
      updates['dependencies'] = deps;
    }
    if (updates.isEmpty) {
      setState(() => _editing = false);
      return;
    }
    final ok = await ref.read(taskmasterProvider.notifier).updateTask(task.idText, updates);
    if (!mounted) return;
    if (ok) {
      setState(() {
        _editing = false;
        _error = '';
      });
    } else {
      setState(
        () => _error =
            ref.read(taskmasterProvider).error ??
            Translations.of(context).tasks.taskDetail.updateFailed,
      );
    }
  }

  Future<void> _copyId(String id) async {
    await Clipboard.setData(ClipboardData(text: id));
    if (!mounted) return;
    AppToast.show(context, Translations.of(context).tasks.taskDetail.idCopied);
  }

  /// Dependency chip — opens the referenced task (TaskDetailModal parity).
  Widget _dependencyChip(String id, TextTheme t) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final color = dark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8);
    return InkWell(
      onTap: () => unawaited(TaskDetailDialog.show(context, id)),
      borderRadius: AppRadii.borderSm,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF1E3A8A) : const Color(0xFFDBEAFE),
          borderRadius: AppRadii.borderSm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_right_alt, size: 14, color: color),
            const SizedBox(width: 4),
            Text(id, style: t.bodySmall?.copyWith(color: color)),
          ],
        ),
      ),
    );
  }

  Future<void> _delete(TaskmasterTask task) async {
    final i18n = Translations.of(context);
    final ok = await AppDialog.confirm(
      context,
      title: i18n.tasks.taskDetail.deleteConfirmTitle,
      message: i18n.tasks.taskDetail.deleteConfirmMessage(id: task.idText),
      confirmLabel: i18n.common.buttons.delete,
    );
    if (!ok || !mounted) return;
    final done = await ref.read(taskmasterProvider.notifier).deleteTask(task.idText);
    if (!mounted) return;
    if (done) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskmasterProvider);
    final task = _task(state);
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    if (task == null) {
      return AppDialog(
        title: i18n.tasks.taskDetail.taskId(id: widget.taskId),
        content: SizedBox(
          width: 420,
          height: 120,
          child: Center(child: Text(i18n.tasks.taskDetail.notFound)),
        ),
      );
    }
    _loadIntoFields(task);
    final busy = state.busy;

    Widget field(String label, TextEditingController ctrl, {int lines = 1}) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: t.labelSmall?.copyWith(color: c.mutedForeground)),
        const SizedBox(height: 4),
        AppInput(controller: ctrl, maxLines: lines, enabled: !busy),
      ],
    );

    return AppDialog(
      title: '#${task.idText} ${task.title}',
      content: SizedBox(
        width: 560,
        height: 480,
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        i18n.tasks.taskDetail.status,
                        style: t.labelSmall?.copyWith(color: c.mutedForeground),
                      ),
                      DropdownButton<String>(
                        value: task.status,
                        isDense: true,
                        underline: const SizedBox.shrink(),
                        onChanged: busy
                            ? null
                            : (v) {
                                if (v != null && v != task.status) {
                                  unawaited(
                                    ref
                                        .read(taskmasterProvider.notifier)
                                        .setTaskStatus(task.idText, v),
                                  );
                                }
                              },
                        items: [
                          for (final s in taskStatuses)
                            DropdownMenuItem(value: s, child: Text(taskStatusLabel(s, i18n))),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: i18n.tasks.taskDetail.copyTaskId,
                  onPressed: busy ? null : () => unawaited(_copyId(task.idText)),
                  icon: Icon(Icons.copy, size: 16, color: c.mutedForeground),
                ),
                IconButton(
                  tooltip: i18n.tasks.taskDetail.delete,
                  onPressed: busy ? null : () => unawaited(_delete(task)),
                  icon: Icon(Icons.delete_outline, size: 18, color: c.destructive),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (_editing) ...[
              field(i18n.tasks.createTask.titleLabel, _title),
              const SizedBox(height: AppSpacing.sm),
              field(i18n.tasks.taskDetail.description, _description, lines: 3),
              const SizedBox(height: AppSpacing.sm),
              field(i18n.tasks.taskDetail.implDetails, _details, lines: 4),
              const SizedBox(height: AppSpacing.sm),
              field(i18n.tasks.taskDetail.testStrategy, _testStrategy, lines: 2),
              const SizedBox(height: AppSpacing.sm),
              field(i18n.tasks.taskmaster.detail.dependenciesLabel, _deps),
              const SizedBox(height: AppSpacing.sm),
              Text(
                i18n.tasks.taskDetail.priority,
                style: t.labelSmall?.copyWith(color: c.mutedForeground),
              ),
              DropdownButton<String>(
                value: _priority,
                isDense: true,
                underline: const SizedBox.shrink(),
                onChanged: (v) => v == null ? null : setState(() => _priority = v),
                items: [
                  for (final p in taskPriorities)
                    DropdownMenuItem(value: p, child: Text(taskPriorityLabel(p, i18n))),
                ],
              ),
            ] else ...[
              Text(
                i18n.tasks.taskDetail.description,
                style: t.labelSmall?.copyWith(color: c.mutedForeground),
              ),
              Text(
                task.description.isEmpty ? i18n.tasks.taskDetail.noDescription : task.description,
                style: t.bodySmall,
              ),
              if (task.details.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(i18n.tasks.taskDetail.implDetails, style: t.labelMedium),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(task.details, style: t.bodySmall),
                    ),
                  ],
                ),
              ],
              if (task.testStrategy.isNotEmpty) ...[
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(i18n.tasks.taskDetail.testStrategy, style: t.labelMedium),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(task.testStrategy, style: t.bodySmall),
                    ),
                  ],
                ),
              ],
              if (task.dependencies.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  i18n.tasks.taskDetail.dependencies,
                  style: t.labelSmall?.copyWith(color: c.mutedForeground),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [for (final d in task.dependencies) _dependencyChip('$d', t)],
                ),
              ],
            ],
            if (_error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(_error, style: t.bodySmall?.copyWith(color: c.destructive)),
              ),
            if (task.subtasks.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(i18n.tasks.taskDetail.subtasks, style: t.labelMedium),
              for (final s in task.subtasks)
                Row(
                  children: [
                    Icon(taskStatusIcon(s.status), size: 14, color: taskStatusColor(s.status, c)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${s.idText} · ${s.title}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodySmall,
                      ),
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(i18n.tasks.taskDetail.close),
        ),
        if (_editing)
          AppButton(
            loading: busy,
            onPressed: () => unawaited(_save(task)),
            child: Text(i18n.tasks.taskDetail.save),
          )
        else
          AppButton(
            variant: AppButtonVariant.secondary,
            onPressed: () => setState(() => _editing = true),
            child: Text(i18n.common.buttons.edit),
          ),
      ],
    );
  }
}

/// Minimal create-task form (title, description, priority) — the detail
/// dialog stays for editing existing tasks.
class CreateTaskDialog extends ConsumerStatefulWidget {
  const CreateTaskDialog({super.key});

  static Future<void> show(BuildContext context) =>
      showDialog<void>(context: context, builder: (_) => const CreateTaskDialog());

  @override
  ConsumerState<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends ConsumerState<CreateTaskDialog> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  String _priority = 'medium';

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = Translations.of(context);
    final busy = ref.watch(taskmasterProvider).busy;
    return AppDialog(
      title: i18n.tasks.createTask.title,
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppInput(
              controller: _title,
              hint: i18n.tasks.createTask.titlePlaceholder,
              autofocus: true,
              enabled: !busy,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppInput(
              controller: _description,
              hint: i18n.tasks.createTask.descriptionPlaceholder,
              maxLines: 3,
              enabled: !busy,
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: DropdownButton<String>(
                value: _priority,
                isDense: true,
                underline: const SizedBox.shrink(),
                onChanged: (v) => v == null ? null : setState(() => _priority = v),
                items: [
                  for (final p in taskPriorities)
                    DropdownMenuItem(value: p, child: Text(taskPriorityLabel(p, i18n))),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(i18n.tasks.createTask.cancel),
        ),
        AppButton(
          loading: busy,
          onPressed: _title.text.trim().isEmpty
              ? null
              : () async {
                  final ok = await ref.read(taskmasterProvider.notifier).createTask({
                    'title': _title.text.trim(),
                    'description': _description.text.trim(),
                    'priority': _priority,
                  });
                  if (!context.mounted) return;
                  if (ok) {
                    Navigator.of(context).pop();
                  } else {
                    final err = ref.read(taskmasterProvider).error;
                    if (err != null) AppToast.error(context, err);
                  }
                },
          child: Text(i18n.tasks.createTask.submit),
        ),
      ],
    );
  }
}
