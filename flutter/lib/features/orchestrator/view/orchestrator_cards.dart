import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_badge.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/features/orchestrator/data/orchestrator_models.dart';
import 'package:ddagent_app/features/orchestrator/data/orchestrator_repository.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Specialized cards for orchestrated ("Auto") sessions — port of
/// `OrchestratorCards.tsx`. Rows arrive as `status` messages whose
/// `context['orchestratorKind']` picks the card; payload fields are read
/// defensively so unknown keys/older backends still render.
class OrchestratorCard extends ConsumerWidget {
  const OrchestratorCard({
    required this.message,
    required this.sessionId,
    this.projectId,
    this.projectPath,
    super.key,
  });

  final SessionMessage message;
  final String sessionId;
  final String? projectId;
  final String? projectPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = message.context ?? const <String, dynamic>{};
    final kind = data['orchestratorKind']?.toString();
    return switch (kind) {
      'routing' => _RoutingCard(data: data),
      'plan' => _PlanCard(data: data, sessionId: sessionId),
      'delegation' => _DelegationCard(
        data: data,
        sessionId: sessionId,
        projectId: projectId,
        projectPath: projectPath,
      ),
      'summary' => _SummaryCard(data: data, sessionId: sessionId),
      'taskmaster' => _TaskmasterCard(data: data),
      'gate' => _GateCard(data: data),
      _ => _CardShell(
        child: Text(
          kind ?? 'orchestrator',
          style: _mutedStyle(context),
        ),
      ),
    };
  }
}

const _amber = Color(0xFFF59E0B);
const _green = Color(0xFF10B981);
const _finalTextLimit = 800;

TextStyle? _mutedStyle(BuildContext context) => Theme.of(
  context,
).textTheme.bodySmall?.copyWith(color: context.appColors.mutedForeground);

String _fmtDuration(num? ms) {
  if (ms == null) return '';
  if (ms < 60000) return '${(ms / 1000).toStringAsFixed(1)}s';
  return '${ms ~/ 60000}m ${((ms % 60000) / 1000).round().toString().padLeft(2, '0')}s';
}

/// `idle | sending | failed` submit state shared by every card action.
enum _Submit { idle, sending, failed }

/// status → (color, icon) for delegation/taskmaster/gate badges.
(Color, IconData?) _statusStyle(BuildContext context, String status) {
  final c = context.appColors;
  return switch (status) {
    'running' || 'started' => (
      c.primary,
      Icons.hourglass_top_rounded,
    ),
    'done' || 'complete' => (_green, Icons.check_circle_outline),
    'failed' => (c.destructive, Icons.cancel_outlined),
    'awaiting_decision' => (_amber, Icons.help_outline),
    'aborted' || 'skipped' || 'paused' || 'blocked' => (
      c.mutedForeground,
      Icons.block,
    ),
    _ => (c.mutedForeground, null),
  };
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child, this.highlight = false});

  final Widget child;

  /// Summary card uses a primary-tinted surface (`bg-primary/5`).
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: highlight
            ? c.primary.withValues(alpha: 0.05)
            : c.muted.withValues(alpha: 0.3),
        borderRadius: AppRadii.borderLg,
        border: Border.all(
          color: (highlight ? c.primary : c.border).withValues(alpha: 0.4),
        ),
      ),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodySmall!,
        child: child,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _statusStyle(context, status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        borderRadius: AppRadii.borderSm,
        border: Border.all(color: color.withValues(alpha: 0.4)),
        color: color.withValues(alpha: 0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 3),
          ],
          Text(
            status,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              decoration: status == 'skipped'
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Routing ──────────────────────────────────────────────────────────────

class _RoutingCard extends StatelessWidget {
  const _RoutingCard({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final taskType = str(data['taskType']);
    final provider = str(data['provider']);
    final model = str(data['model']);
    final effort = str(data['effort']);
    final tier = str(data['tier']);
    final reason = str(data['reason']);
    final error =
        str(data['error']) ??
        (data['status'] == 'no_candidate' ? str(data['status']) : null);
    final alternatives = strList(data['alternatives']);

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.alt_route, size: 14, color: c.mutedForeground),
              if (taskType != null) AppBadge(label: taskType),
              if (provider != null) ...[
                Icon(
                  Icons.arrow_forward,
                  size: 12,
                  color: c.mutedForeground,
                ),
                Text(
                  provider,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (model != null)
                  Text('· $model', style: _mutedStyle(context)),
                if (effort != null)
                  Text('· $effort', style: _mutedStyle(context)),
                if (tier != null) AppBadge(label: tier),
              ] else
                Text(
                  'Routing',
                  style: error != null
                      ? TextStyle(color: c.destructive)
                      : _mutedStyle(context),
                ),
            ],
          ),
          if (reason != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(reason, style: _mutedStyle(context)),
            ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(error, style: TextStyle(color: c.destructive)),
            ),
          if (alternatives.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Alternatives: ${alternatives.join(', ')}',
                style: _mutedStyle(context),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Plan ─────────────────────────────────────────────────────────────────

class _PlanCard extends ConsumerStatefulWidget {
  const _PlanCard({required this.data, required this.sessionId});

  final Map<String, dynamic> data;
  final String sessionId;

  @override
  ConsumerState<_PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends ConsumerState<_PlanCard> {
  // Local copy lets the user disable steps before confirming; prompts are
  // server-side (pending plan stash), the wire sends the row fields only.
  List<PlanStep>? _edited;
  _Submit _submit = _Submit.idle;

  void _toggle(String id) {
    final shown = _edited ?? readSteps(widget.data['steps']);
    setState(() {
      _edited = [
        for (final s in shown)
          s.id == id ? s.copyWith(enabled: !s.enabled) : s,
      ];
    });
  }

  Future<void> _confirm() async {
    if (_submit == _Submit.sending) return;
    setState(() => _submit = _Submit.sending);
    final shown = _edited ?? readSteps(widget.data['steps']);
    try {
      await ref
          .read(orchestratorRepositoryProvider)
          .confirmPlan({
            'sessionId': widget.sessionId,
            'steps': [for (final s in shown) s.toJson()],
            'language': Localizations.localeOf(context).languageCode,
          });
      if (mounted) setState(() => _submit = _Submit.idle);
    } on Object {
      if (mounted) setState(() => _submit = _Submit.failed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final shown = _edited ?? readSteps(widget.data['steps']);
    final awaitingConfirm = widget.data['awaitingConfirm'] == true;
    final sourceNote = switch (str(widget.data['source'])) {
      'planner-fallback' || 'planner-error' =>
        'planner unavailable — single-step fallback',
      'template' || 'template-default' => 'from pipeline template',
      'off' => 'planner off',
      _ => null,
    };
    final failed = _submit == _Submit.failed;

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.checklist_outlined,
                size: 14,
                color: c.mutedForeground,
              ),
              const SizedBox(width: AppSpacing.xs),
              const Text(
                'Plan',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: AppSpacing.xs),
              AppBadge(label: '${shown.length} steps'),
              if (sourceNote != null) ...[
                const Spacer(),
                Text(sourceNote, style: _mutedStyle(context)),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          for (var i = 0; i < shown.length; i++)
            Opacity(
              opacity: shown[i].enabled ? 1 : 0.5,
              child: Row(
                children: [
                  if (awaitingConfirm)
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: Checkbox(
                        value: shown[i].enabled,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        onChanged: (_) => _toggle(shown[i].id),
                      ),
                    )
                  else
                    SizedBox(
                      width: 16,
                      child: Text(
                        '${i + 1}.',
                        textAlign: TextAlign.right,
                        style: _mutedStyle(context),
                      ),
                    ),
                  const SizedBox(width: AppSpacing.sm),
                  AppBadge(label: shown[i].type),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      shown[i].title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!shown[i].enabled)
                    Text('disabled', style: _mutedStyle(context)),
                ],
              ),
            ),
          if (awaitingConfirm)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  AppButton(
                    size: AppButtonSize.sm,
                    loading: _submit == _Submit.sending,
                    onPressed: shown.any((s) => s.enabled) ? _confirm : null,
                    child: const Text('Run plan'),
                  ),
                  Text(
                    failed
                        ? 'Failed to start — try again.'
                        : 'Waiting for plan confirmation.',
                    style: TextStyle(color: failed ? c.destructive : _amber),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Delegation ───────────────────────────────────────────────────────────

class _DelegationCard extends ConsumerStatefulWidget {
  const _DelegationCard({
    required this.data,
    required this.sessionId,
    this.projectId,
    this.projectPath,
  });

  final Map<String, dynamic> data;
  final String sessionId;
  final String? projectId;
  final String? projectPath;

  @override
  ConsumerState<_DelegationCard> createState() => _DelegationCardState();
}

class _DelegationCardState extends ConsumerState<_DelegationCard> {
  late bool _open;
  _Submit _submit = _Submit.idle;

  String get _status => str(widget.data['status']) ?? 'queued';

  @override
  void initState() {
    super.initState();
    _open = _status == 'running' || _status == 'done';
  }

  Future<void> _continueStep() async {
    final stepId = widget.data['stepId'];
    if (stepId == null || _submit == _Submit.sending) return;
    setState(() => _submit = _Submit.sending);
    try {
      await ref
          .read(orchestratorRepositoryProvider)
          .resume(widget.sessionId, {
            'stepId': stepId,
            'language': Localizations.localeOf(context).languageCode,
          });
      if (mounted) setState(() => _submit = _Submit.idle);
    } on Object {
      if (mounted) setState(() => _submit = _Submit.failed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final data = widget.data;
    final status = _status;
    final title =
        str(data['title']) ?? str(data['stepId']) ?? 'Delegated step';
    final provider = str(data['provider']);
    final model = str(data['model']);
    final effort = str(data['effort']);
    final tier = str(data['tier']);
    final lastEvent = str(data['lastEvent']);
    final error = str(data['error']);
    final childSessionId = str(data['childSessionId']);
    final finalText = str(data['finalText']);
    final truncatedFinalText =
        finalText != null && finalText.length > _finalTextLimit
        ? '${finalText.substring(0, _finalTextLimit)}…'
        : finalText;
    final attempt = numVal(data['attempt']);

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Row(
              children: [
                Icon(
                  _open ? Icons.expand_more : Icons.chevron_right,
                  size: 14,
                  color: c.mutedForeground,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                if (provider != null)
                  Text(
                    '$provider${model != null ? ' · $model' : ''}${effort != null ? ' · $effort' : ''}',
                    style: _mutedStyle(context),
                  ),
                if (tier != null) ...[
                  const SizedBox(width: AppSpacing.xs),
                  AppBadge(label: tier),
                ],
                if (attempt != null && attempt > 1)
                  Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.xs),
                    child: Text(
                      'attempt $attempt',
                      style: _mutedStyle(context),
                    ),
                  ),
                const SizedBox(width: AppSpacing.xs),
                _StatusBadge(status: status),
              ],
            ),
          ),
          if (_open)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (error != null)
                    Text(error, style: TextStyle(color: c.destructive)),
                  if (lastEvent != null && status != 'done')
                    Text(lastEvent, style: _mutedStyle(context)),
                  if (status == 'done' && truncatedFinalText != null)
                    Text(truncatedFinalText),
                  _metricsRow(context, data, t),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (childSessionId != null)
                        InkWell(
                          onTap: () {
                            final params = <String, String>{
                              if (widget.projectId != null)
                                'projectId': widget.projectId!,
                              if (widget.projectPath != null)
                                'projectPath': widget.projectPath!,
                            };
                            context.go(
                              Uri(
                                path: '/chat/$childSessionId',
                                queryParameters: params,
                              ).toString(),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.open_in_new,
                                size: 12,
                                color: c.primary,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'Open full session',
                                style: TextStyle(color: c.primary),
                              ),
                            ],
                          ),
                        ),
                      if ((status == 'done' || status == 'failed') &&
                          data['stepId'] != null)
                        AppButton(
                          size: AppButtonSize.sm,
                          variant: AppButtonVariant.ghost,
                          loading: _submit == _Submit.sending,
                          onPressed: _continueStep,
                          child: Text(
                            status == 'failed'
                                ? 'Retry / Fix'
                                : 'Continue / Fix',
                          ),
                        ),
                      if (_submit == _Submit.failed)
                        Text(
                          'Failed — try again.',
                          style: TextStyle(
                            color: c.destructive,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// T18.14 — duration / attempt count / candidate-switch history / cost.
  Widget _metricsRow(
    BuildContext context,
    Map<String, dynamic> data,
    TextTheme t,
  ) {
    final parts = <String>[
      if (_fmtDuration(numVal(data['durationMs'])).isNotEmpty)
        _fmtDuration(numVal(data['durationMs'])),
      if ((numVal(data['attempt']) ?? 0) > 1)
        '${numVal(data['attempt'])} attempts',
      if (data['candidateHistory'] is List &&
          (data['candidateHistory'] as List).length > 1)
        'candidates: ${strList(data['candidateHistory']).join(' → ')}',
      if (data['attempts'] is List && (data['attempts'] as List).length > 1)
        '${(data['attempts'] as List).length} candidates',
      if (numVal(data['costUsd']) != null)
        '\$${numVal(data['costUsd'])!.toStringAsFixed(4)}',
    ];
    if (parts.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Text(
        parts.join(' · '),
        style: t.labelSmall?.copyWith(
          color: context.appColors.mutedForeground,
        ),
      ),
    );
  }
}

// ─── Gate ─────────────────────────────────────────────────────────────────

class _GateCard extends StatelessWidget {
  const _GateCard({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final status = str(data['status']) ?? 'running';
    final command = str(data['command']);
    final title = str(data['title']);
    final exitCode = numVal(data['exitCode']);
    final output = str(data['output']);
    final duration = _fmtDuration(numVal(data['durationMs']));
    final timedOut = data['timedOut'] == true;
    final mono = TextStyle(
      fontFamily: 'monospace',
      fontSize: 11,
      color: c.foreground,
    );

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.terminal, size: 14, color: c.mutedForeground),
              if (title != null)
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              _StatusBadge(status: status),
              if (exitCode != null)
                AppBadge(
                  label: 'exit $exitCode',
                  variant: exitCode == 0
                      ? AppBadgeVariant.neutral
                      : AppBadgeVariant.destructive,
                ),
              if (timedOut)
                const AppBadge(
                  label: 'timed out',
                  variant: AppBadgeVariant.destructive,
                ),
              if (duration.isNotEmpty)
                Text(duration, style: _mutedStyle(context)),
            ],
          ),
          if (command != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: SelectableText(command, style: mono),
            ),
          if (output != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: AppSpacing.xs),
              padding: const EdgeInsets.all(AppSpacing.sm),
              constraints: const BoxConstraints(maxHeight: 360),
              decoration: BoxDecoration(
                color: c.background.withValues(alpha: 0.6),
                borderRadius: AppRadii.borderMd,
                border: Border.all(color: c.border),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  // Tail of the captured output — cap ~30 lines.
                  output
                      .split('\n')
                      .reversed
                      .take(30)
                      .toList()
                      .reversed
                      .join('\n'),
                  style: mono,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Taskmaster ───────────────────────────────────────────────────────────

class _TaskmasterCard extends StatelessWidget {
  const _TaskmasterCard({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final rawStatus = str(data['status']) ?? 'started';
    final status = rawStatus == 'started' ? 'running' : rawStatus;
    final taskId = str(data['taskId']);
    final title = str(data['title']);
    final text = str(data['text']);
    final error = str(data['error']);
    final remaining = numVal(data['remaining']);
    final total = numVal(data['total']);

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.list_alt, size: 14, color: c.mutedForeground),
              const Text(
                'Task queue',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              if (taskId != null)
                Text('#$taskId', style: _mutedStyle(context)),
              _StatusBadge(status: status),
              if (remaining != null)
                Text(
                  '$remaining left${total != null ? ' / $total' : ''}',
                  style: _mutedStyle(context),
                ),
            ],
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          if (text != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(text, style: _mutedStyle(context)),
            ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(error, style: TextStyle(color: c.destructive)),
            ),
        ],
      ),
    );
  }
}

// ─── Summary ──────────────────────────────────────────────────────────────

class _SummaryCard extends ConsumerStatefulWidget {
  const _SummaryCard({required this.data, required this.sessionId});

  final Map<String, dynamic> data;
  final String sessionId;

  @override
  ConsumerState<_SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends ConsumerState<_SummaryCard> {
  _Submit _submit = _Submit.idle;

  /// 'idle' | 'running' | 'failed' — the resume request stays open until the
  /// whole complete-all-tasks loop settles, so a pending call IS the run.
  /// ponytail: taskmaster progress/cancel-resync off live WS frames (the web
  /// version's milestone subscription) is skipped — the local flag is enough
  /// for the card; re-sync would need a chat_channel event hook.
  String _tasksState = 'idle';
  String? _errorText;

  bool get _busy => _submit == _Submit.sending || _tasksState == 'running';

  Future<void> _resume(Map<String, dynamic> body, {bool tasks = false}) async {
    if (_busy) return;
    setState(() {
      _errorText = null;
      if (tasks) {
        _tasksState = 'running';
      } else {
        _submit = _Submit.sending;
      }
    });
    try {
      await ref
          .read(orchestratorRepositoryProvider)
          .resume(widget.sessionId, {
            'language': Localizations.localeOf(context).languageCode,
            ...body,
          });
      if (mounted) {
        setState(() {
          if (tasks) _tasksState = 'idle';
          _submit = _Submit.idle;
        });
      }
    } on AppError catch (e) {
      if (!mounted) return;
      setState(() {
        // RUN_IN_PROGRESS (409) — a run is already going; reflect it instead
        // of showing a bogus failure.
        if (tasks && e.statusCode == 409) {
          _tasksState = 'running';
        } else {
          _errorText = e.message;
          if (tasks) _tasksState = 'failed';
          _submit = _Submit.failed;
        }
      });
    } on Object {
      if (mounted) {
        setState(() {
          if (tasks) _tasksState = 'failed';
          _submit = _Submit.failed;
        });
      }
    }
  }

  void _cancelTasks() {
    ref.read(chatChannelProvider).abort(widget.sessionId);
    setState(() => _tasksState = 'idle');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final text = str(widget.data['text']);
    final failed = strList(widget.data['failed']);
    final results = readResults(widget.data['results']);
    final running = _tasksState == 'running';

    return _CardShell(
      highlight: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 14, color: c.mutedForeground),
              const SizedBox(width: AppSpacing.xs),
              const Text(
                'Summary',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          if (text != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(text),
            ),
          for (final r in results)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: AppSpacing.xs),
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                borderRadius: AppRadii.borderMd,
                border: Border.all(color: c.border.withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: c.foreground.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    r.summary,
                    style: TextStyle(
                      fontSize: 12,
                      color: c.foreground.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          if (failed.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                'Failed steps: ${failed.join(', ')}',
                style: TextStyle(color: c.destructive),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppButton(
                  size: AppButtonSize.sm,
                  loading: _submit == _Submit.sending,
                  onPressed: _busy
                      ? null
                      : () => _resume(
                          failed.isNotEmpty ? {} : {'mode': 'continue'},
                        ),
                  child: Text(
                    failed.isNotEmpty ? 'Continue' : 'Continue work',
                  ),
                ),
                if (!running) ...[
                  AppButton(
                    size: AppButtonSize.sm,
                    variant: AppButtonVariant.ghost,
                    onPressed: _busy
                        ? null
                        : () => _resume(const {
                            'mode': 'complete-all-tasks',
                            'maxTasks': 1,
                          }, tasks: true),
                    child: const Text('Run next task'),
                  ),
                  AppButton(
                    size: AppButtonSize.sm,
                    variant: AppButtonVariant.ghost,
                    onPressed: _busy
                        ? null
                        : () => _resume(const {
                            'mode': 'complete-all-tasks',
                          }, tasks: true),
                    child: const Text('End all tasks'),
                  ),
                ] else ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 1.5),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text('Working on tasks…', style: _mutedStyle(context)),
                    ],
                  ),
                  AppButton(
                    size: AppButtonSize.sm,
                    variant: AppButtonVariant.ghost,
                    onPressed: _cancelTasks,
                    child: const Text('Cancel'),
                  ),
                ],
                if (_submit == _Submit.failed || _tasksState == 'failed')
                  Text(
                    _errorText ?? 'Failed to resume — try again.',
                    style: TextStyle(color: c.destructive, fontSize: 11),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
