import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_nav_menu.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/quota/view/quota_tone.dart';
import 'package:ddagent_app/features/scheduler/data/scheduler_models.dart';
import 'package:ddagent_app/features/scheduler/state/scheduler_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Scheduler dashboard (port of settings/SchedulesSettingsTab.tsx): list of
/// cron-driven agent runs with quick actions + expandable run history.
/// Mounted at /scheduler.
class SchedulerScreen extends ConsumerWidget {
  const SchedulerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(schedulerProvider);
    final ctrl = ref.read(schedulerProvider.notifier);
    final projects = ref.watch(projectsProvider).projects;
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final compact = context.breakpoint.isCompact;

    final projectName = {for (final p in projects) p.projectId: p.displayName};

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: c.border)),
              ),
              child: Row(
                children: [
                  const AppNavMenuButton(),
                  Icon(Icons.schedule, size: 18, color: c.mutedForeground),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      'Schedules',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleSmall,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppButton(
                    variant: AppButtonVariant.ghost,
                    size: AppButtonSize.sm,
                    onPressed: ctrl.refresh,
                    child: const Icon(Icons.refresh, size: 16),
                  ),
                  AppButton(
                    size: AppButtonSize.sm,
                    onPressed: () => _JobDialog.show(context),
                    child: Text(compact ? 'New' : 'New schedule'),
                  ),
                ],
              ),
            ),
            if (state.error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                color: c.destructive.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.error!,
                        style: t.bodySmall?.copyWith(color: c.destructive),
                      ),
                    ),
                    InkWell(
                      onTap: ctrl.clearError,
                      child: Icon(Icons.close, size: 14, color: c.destructive),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: state.loading && state.jobs.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : state.jobs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 32,
                            color: c.mutedForeground,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'No schedules yet.',
                            style: t.bodyMedium?.copyWith(
                              color: c.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      children: [
                        for (final j in state.jobs)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.xs,
                            ),
                            child: _JobTile(
                              job: j,
                              projectLabel:
                                  projectName[j.projectId] ?? j.projectId,
                              runs: state.runs[j.id],
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Job tile ────────────────────────────────────────────────────────────────

class _JobTile extends ConsumerStatefulWidget {
  const _JobTile({required this.job, required this.projectLabel, this.runs});

  final SchedulerJob job;
  final String projectLabel;
  final List<SchedulerRun>? runs;

  @override
  ConsumerState<_JobTile> createState() => _JobTileState();
}

class _JobTileState extends ConsumerState<_JobTile> {
  bool _runsOpen = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final ctrl = ref.read(schedulerProvider.notifier);
    final j = widget.job;
    final busy = ref.watch(schedulerProvider.select((s) => s.busy));

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.xs,
              runSpacing: 4,
              children: [
                Icon(
                  Icons.event_repeat,
                  size: 16,
                  color: j.enabled ? c.mutedForeground : c.border,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Text(
                    j.prompt.isEmpty ? j.id : j.prompt,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                if (!j.enabled) _badge(context, 'disabled', c.mutedForeground),
                if (j.failCount > 0)
                  _badge(context, '${j.failCount} failures', c.destructive),
              ],
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: 2,
              children: [
                Text(
                  j.cron,
                  style: t.labelSmall?.copyWith(
                    fontFamily: 'monospace',
                    color: c.foreground,
                  ),
                ),
                _meta(widget.projectLabel.isEmpty ? '—' : widget.projectLabel),
                _meta(j.provider.isEmpty ? '—' : j.provider),
                if (j.useWorktree) _meta('worktree'),
                if (j.enabled && j.nextRunAt != null)
                  _meta('next in ${formatRelativeTo(j.nextRunAt)}'),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppButton(
                  variant: AppButtonVariant.ghost,
                  size: AppButtonSize.sm,
                  onPressed: () {
                    setState(() => _runsOpen = !_runsOpen);
                    if (_runsOpen && widget.runs == null) {
                      unawaited(ctrl.loadRuns(j.id));
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.history, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Runs',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                AppButton(
                  variant: AppButtonVariant.ghost,
                  size: AppButtonSize.sm,
                  onPressed: busy ? null : () => unawaited(ctrl.runNow(j.id)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.play_arrow, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        'Run now',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                AppButton(
                  variant: AppButtonVariant.ghost,
                  size: AppButtonSize.sm,
                  onPressed: () => _JobDialog.show(context, job: j),
                  child: Text(
                    'Edit',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                AppButton(
                  variant: AppButtonVariant.ghost,
                  size: AppButtonSize.sm,
                  onPressed: () async {
                    final ok = await AppDialog.confirm(
                      context,
                      title: 'Delete schedule?',
                      message:
                          'This removes the recurring job '
                          '${j.id}. Existing sessions are kept.',
                      confirmLabel: 'Delete',
                    );
                    if (ok && context.mounted) {
                      unawaited(ctrl.deleteJob(j.id));
                    }
                  },
                  child: Icon(
                    Icons.delete_outline,
                    size: 14,
                    color: c.destructive,
                  ),
                ),
                Transform.scale(
                  scale: 0.75,
                  child: Switch(
                    value: j.enabled,
                    onChanged: busy
                        ? null
                        : (v) => unawaited(ctrl.toggleEnabled(j.id, v)),
                  ),
                ),
              ],
            ),
            if (_runsOpen) ...[
              Divider(height: AppSpacing.md, color: c.border),
              if (widget.runs == null)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else if (widget.runs!.isEmpty)
                Text(
                  'No runs yet.',
                  style: t.bodySmall?.copyWith(color: c.mutedForeground),
                )
              else
                for (final r in widget.runs!) _runRow(context, r),
            ],
          ],
        ),
      ),
    );
  }

  Widget _meta(String s) => Text(
    s,
    style: Theme.of(context).textTheme.labelSmall
        ?.copyWith(color: context.appColors.mutedForeground),
  );

  Widget _badge(BuildContext context, String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
    decoration: BoxDecoration(
      border: Border.all(color: color.withValues(alpha: 0.4)),
      borderRadius: AppRadii.borderSm,
    ),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelSmall
          ?.copyWith(fontSize: 10, color: color),
    ),
  );

  Widget _runRow(BuildContext context, SchedulerRun r) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final tone = switch (r.status) {
      'completed' => quotaToneColor(QuotaTone.safe),
      'failed' => c.destructive,
      'skipped' => c.mutedForeground,
      _ => quotaToneColor(QuotaTone.info),
    };
    final started = DateTime.tryParse(r.startedAt);
    final finished = r.finishedAt == null
        ? null
        : DateTime.tryParse(r.finishedAt!);
    final duration = started != null && finished != null
        ? formatDuration(finished.difference(started).inSeconds)
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: 2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: tone),
          ),
          SizedBox(
            width: 70,
            child: Text(r.status, style: t.labelSmall?.copyWith(color: tone)),
          ),
          Text(
            started?.toLocal().toString().split('.').first ?? r.startedAt,
            style: t.labelSmall?.copyWith(color: c.mutedForeground),
          ),
          if (duration != null)
            Text(
              duration,
              style: t.labelSmall?.copyWith(color: c.mutedForeground),
            ),
          if (r.sessionId != null)
            InkWell(
              key: Key('run-session-${r.id}'),
              onTap: () => context.go('/chat/${r.sessionId}'),
              borderRadius: BorderRadius.circular(AppRadii.sm),
              child: Text(
                'session ${r.sessionId!.substring(0, r.sessionId!.length.clamp(0, 8))}',
                style: t.labelSmall?.copyWith(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: c.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          if (r.error != null)
            Text(r.error!, style: t.labelSmall?.copyWith(color: c.destructive)),
        ],
      ),
    );
  }
}

// ─── Create / edit dialog ───────────────────────────────────────────────────

class _JobDialog extends ConsumerStatefulWidget {
  const _JobDialog({this.job});

  final SchedulerJob? job;

  static const _providers = ['claude', 'codex', 'cursor', 'opencode', 'devin'];

  static Future<void> show(BuildContext context, {SchedulerJob? job}) =>
      showDialog<void>(
        context: context,
        builder: (_) => _JobDialog(job: job),
      );

  @override
  ConsumerState<_JobDialog> createState() => _JobDialogState();
}

class _JobDialogState extends ConsumerState<_JobDialog> {
  late final TextEditingController _cron;
  late final TextEditingController _prompt;
  late String _projectId;
  late String _provider;
  late bool _worktree;
  late bool _catchUp;
  bool _saving = false;

  bool get _editing => widget.job != null;

  @override
  void initState() {
    super.initState();
    final j = widget.job;
    _cron = TextEditingController(text: j?.cron ?? '')
      ..addListener(
        () => ref.read(schedulerProvider.notifier).previewCron(_cron.text),
      );
    _prompt = TextEditingController(text: j?.prompt ?? '');
    _projectId = j?.projectId ?? '';
    _provider = j?.provider.isNotEmpty == true
        ? j!.provider
        : _JobDialog._providers.first;
    _worktree = j?.useWorktree ?? false;
    _catchUp = j?.catchUp ?? false;
    if (!_editing) {
      Future.microtask(
        () => ref.read(schedulerProvider.notifier).previewCron(''),
      );
    }
  }

  @override
  void dispose() {
    _cron.dispose();
    _prompt.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final ctrl = ref.read(schedulerProvider.notifier);
    final body = {
      'projectId': _projectId,
      'provider': _provider,
      'cron': _cron.text.trim(),
      'prompt': _prompt.text.trim(),
      'useWorktree': _worktree,
      'catchUp': _catchUp,
      'enabled': widget.job?.enabled ?? true,
    };
    final ok = _editing
        ? await ctrl.updateJob(widget.job!.id, body)
        : await ctrl.createJob(body);
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final s = ref.watch(schedulerProvider);
    final projects = ref.watch(projectsProvider).projects;
    if (_projectId.isEmpty && projects.isNotEmpty) {
      _projectId = projects.first.projectId;
    }

    final cronHint = _cron.text.trim().isEmpty
        ? null
        : s.cronError ??
              (s.previewLoading
                  ? 'Checking…'
                  : s.cronPreview?.nextRunAt != null
                  ? 'Next run: ${DateTime.tryParse(s.cronPreview!.nextRunAt!)?.toLocal()}'
                  : null);
    final canSave =
        !_saving &&
        _projectId.isNotEmpty &&
        _prompt.text.trim().isNotEmpty &&
        validateCron(_cron.text) == null;

    return AlertDialog(
      title: Text(_editing ? 'Edit schedule' : 'New schedule'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _projectId.isEmpty ? null : _projectId,
                decoration: const InputDecoration(labelText: 'Project'),
                items: [
                  for (final p in projects)
                    DropdownMenuItem(
                      value: p.projectId,
                      child: Text(
                        p.displayName.isEmpty ? p.projectId : p.displayName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (_projectId.isNotEmpty &&
                      !projects.any((p) => p.projectId == _projectId))
                    DropdownMenuItem(
                      value: _projectId,
                      child: Text(_projectId),
                    ),
                ],
                onChanged: (v) => setState(() => _projectId = v ?? ''),
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                initialValue: _provider,
                decoration: const InputDecoration(labelText: 'Provider'),
                items: [
                  for (final p in {
                    ..._JobDialog._providers,
                    if (_provider.isNotEmpty) _provider,
                  })
                    DropdownMenuItem(value: p, child: Text(p)),
                ],
                onChanged: (v) => setState(() => _provider = v ?? _provider),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppInput(
                controller: _cron,
                hint: 'Cron (min hour day month weekday) — e.g. 0 9 * * *',
                onChanged: (_) => setState(() {}),
              ),
              if (cronHint != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    cronHint,
                    style: t.labelSmall?.copyWith(
                      color: s.cronError != null
                          ? c.destructive
                          : c.mutedForeground,
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.sm),
              AppInput(
                controller: _prompt,
                hint: 'Prompt for the agent',
                maxLines: 3,
                onChanged: (_) => setState(() {}),
              ),
              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Run in a fresh worktree'),
                value: _worktree,
                onChanged: (v) => setState(() => _worktree = v ?? false),
              ),
              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Catch up missed runs'),
                value: _catchUp,
                onChanged: (v) => setState(() => _catchUp = v ?? false),
              ),
            ],
          ),
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          size: AppButtonSize.sm,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          size: AppButtonSize.sm,
          loading: _saving,
          onPressed: canSave ? _save : null,
          child: Text(_editing ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}
