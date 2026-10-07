/// Client mirror of `MiniOrchestratorConfig` (server/shared/types.ts) served by
/// `GET/PUT /api/mini-orchestrator/config`. The mini engine has exactly two
/// roles — a non-flash `thinker` and a flash `worker` — and `roles` maps each
/// task type to the role (i.e. the model) that handles it.
library;

import 'package:ddagent_app/features/orchestrator/data/orchestrator_config.dart';

/// Task types a mini-orchestrator role can be assigned to (`MiniOrchestratorRole`
/// per task type). Same set as the engine's `OrchestratorTaskType`.
const miniRoleTaskTypes = [
  'plan',
  'quick',
  'research',
  'docs',
  'code',
  'code-hard',
  'test',
  'review',
  'gate',
  'report',
];

const miniRoleValues = ['thinker', 'worker'];
const miniPlannerModes = ['auto', 'off'];

String _str(Object? v, [String fallback = '']) => v?.toString() ?? fallback;

int _int(Object? v, int fallback) {
  final n = v is num ? v : num.tryParse('$v');
  return n?.toInt() ?? fallback;
}

String _role(Object? v) => miniRoleValues.contains(v) ? _str(v) : 'worker';

/// The whole `MiniOrchestratorConfig` document.
class MiniOrchestratorConfigData {
  const MiniOrchestratorConfigData({
    this.enabled = true,
    this.thinker = const [],
    this.worker = const [],
    this.roles = const {},
    this.plannerMode = 'auto',
    this.requireConfirm = false,
    this.maxParallel = 2,
    this.maxSteps = 12,
    this.stepTimeoutMs = 30 * 60 * 1000,
    this.runTimeoutMs = 0,
  });

  final bool enabled;

  /// Non-flash reasoning model(s) — the thinker. Primary first, fallbacks after.
  final List<OrchCandidate> thinker;

  /// Flash execution model(s) — the worker. Primary first, fallbacks after.
  final List<OrchCandidate> worker;

  /// task type → 'thinker' | 'worker'.
  final Map<String, String> roles;

  /// 'auto' plans with the thinker; 'off' runs a single step on the task role.
  final String plannerMode;
  final bool requireConfirm;

  final int maxParallel;
  final int maxSteps;
  final int stepTimeoutMs;
  final int runTimeoutMs;

  MiniOrchestratorConfigData copyWith({
    bool? enabled,
    List<OrchCandidate>? thinker,
    List<OrchCandidate>? worker,
    Map<String, String>? roles,
    String? plannerMode,
    bool? requireConfirm,
    int? maxParallel,
    int? maxSteps,
    int? stepTimeoutMs,
    int? runTimeoutMs,
  }) => MiniOrchestratorConfigData(
    enabled: enabled ?? this.enabled,
    thinker: thinker ?? this.thinker,
    worker: worker ?? this.worker,
    roles: roles ?? this.roles,
    plannerMode: plannerMode ?? this.plannerMode,
    requireConfirm: requireConfirm ?? this.requireConfirm,
    maxParallel: maxParallel ?? this.maxParallel,
    maxSteps: maxSteps ?? this.maxSteps,
    stepTimeoutMs: stepTimeoutMs ?? this.stepTimeoutMs,
    runTimeoutMs: runTimeoutMs ?? this.runTimeoutMs,
  );

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'thinker': [for (final c in thinker) c.toJson()],
    'worker': [for (final c in worker) c.toJson()],
    'roles': {for (final e in roles.entries) e.key: e.value},
    'planner': {'mode': plannerMode, 'requireConfirm': requireConfirm},
    'execution': {
      'maxParallel': maxParallel,
      'maxSteps': maxSteps,
      'stepTimeoutMs': stepTimeoutMs,
      'runTimeoutMs': runTimeoutMs,
    },
  };

  /// Tolerant parse — missing pieces take the same defaults the server fills in.
  factory MiniOrchestratorConfigData.fromJson(Map<String, dynamic> json) {
    final rolesRaw = json['roles'];
    final plannerRaw = json['planner'];
    final execRaw = json['execution'];
    const d = MiniOrchestratorConfigData();
    return MiniOrchestratorConfigData(
      enabled: json['enabled'] != false,
      thinker: [
        for (final c in (json['thinker'] as List?) ?? const [])
          if (c is Map) OrchCandidate.fromJson(Map<String, dynamic>.from(c)),
      ],
      worker: [
        for (final c in (json['worker'] as List?) ?? const [])
          if (c is Map) OrchCandidate.fromJson(Map<String, dynamic>.from(c)),
      ],
      roles: {
        for (final type in miniRoleTaskTypes) type: _role(rolesRaw is Map ? rolesRaw[type] : null),
      },
      plannerMode: plannerRaw is Map && miniPlannerModes.contains(plannerRaw['mode'])
          ? _str(plannerRaw['mode'])
          : d.plannerMode,
      requireConfirm: plannerRaw is Map && plannerRaw['requireConfirm'] == true,
      maxParallel: execRaw is Map ? _int(execRaw['maxParallel'], d.maxParallel) : d.maxParallel,
      maxSteps: execRaw is Map ? _int(execRaw['maxSteps'], d.maxSteps) : d.maxSteps,
      stepTimeoutMs: execRaw is Map
          ? _int(execRaw['stepTimeoutMs'], d.stepTimeoutMs)
          : d.stepTimeoutMs,
      runTimeoutMs: execRaw is Map ? _int(execRaw['runTimeoutMs'], d.runTimeoutMs) : d.runTimeoutMs,
    );
  }
}
