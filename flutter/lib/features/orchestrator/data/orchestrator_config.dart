/// Client mirror of `OrchestratorConfig` (server/shared/types.ts) served by
/// `GET/PUT /api/orchestrator/config`. Plain classes — the config is edited as
/// a whole-document draft, so every node carries `copyWith`/`toJson`.
library;

/// Task types that route to a pool candidate — every `OrchestratorTaskType`
/// except `gate` (gate steps run a deterministic command, no lane).
const orchRuleLanes = [
  'plan',
  'quick',
  'research',
  'docs',
  'code',
  'code-hard',
  'test',
  'review',
  'report',
];

/// Task types offered when appending a step to a pipeline template — parity
/// with the web `ORCHESTRATOR_TASK_TYPES` list (`plan`/`report`/`gate` are
/// never authored by hand: `plan`/`report` are routing-only lanes and `gate`
/// steps carry a command the template UI cannot edit).
const orchTemplateStepTypes = [
  'plan',
  'quick',
  'research',
  'docs',
  'code',
  'code-hard',
  'test',
  'review',
];

const orchProviders = <String, String>{
  'claude': 'Claude',
  'cursor': 'Cursor',
  'codex': 'Codex',
  'opencode': 'OpenCode',
  'commandcode': 'Command Code',
  'antigravity': 'Antigravity',
  'devin': 'Devin',
};

const orchCostTiers = ['free', 'cheap', 'mid', 'premium'];
const orchPlannerModes = ['auto', 'template', 'off'];
const orchCheckpointModes = ['off', 'per-step', 'every-n'];
const orchOnNoCandidate = ['ask', 'skip'];

/// `OrchestratorFailureClass` — same-lane retry budgets.
const orchFailureClasses = ['rate_limit', 'quota', 'auth', 'timeout', 'transient'];

String _str(Object? v, [String fallback = '']) => v?.toString() ?? fallback;

int _int(Object? v, int fallback) {
  final n = v is num ? v : num.tryParse('$v');
  return n?.toInt() ?? fallback;
}

List<String> _strList(Object? v) => [for (final e in (v as List?) ?? const []) '$e'];

/// One selectable model endpoint in the pool (`OrchestratorCandidate`).
class OrchCandidate {
  const OrchCandidate({
    required this.id,
    required this.provider,
    required this.model,
    this.effort,
    this.accountId,
    this.tier = 'mid',
    this.label = '',
  });

  final String id;
  final String provider;
  final String model;
  final String? effort;

  /// provider_accounts.id override; null = provider default environment.
  final String? accountId;
  final String tier;
  final String label;

  OrchCandidate copyWith({
    String? id,
    String? provider,
    String? model,
    String? Function()? effort,
    String? Function()? accountId,
    String? tier,
    String? label,
  }) => OrchCandidate(
    id: id ?? this.id,
    provider: provider ?? this.provider,
    model: model ?? this.model,
    effort: effort != null ? effort() : this.effort,
    accountId: accountId != null ? accountId() : this.accountId,
    tier: tier ?? this.tier,
    label: label ?? this.label,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'provider': provider,
    'model': model,
    'effort': effort,
    'accountId': accountId,
    'tier': tier,
    'label': label,
  };

  factory OrchCandidate.fromJson(Map<String, dynamic> json) => OrchCandidate(
    id: _str(json['id']),
    provider: _str(json['provider'], 'claude'),
    model: _str(json['model']),
    effort: json['effort']?.toString(),
    accountId: json['accountId']?.toString(),
    tier: _str(json['tier'], 'mid'),
    label: _str(json['label']),
  );
}

/// Named pipeline template (`OrchestratorPipelineTemplate`).
class OrchTemplate {
  const OrchTemplate({required this.name, required this.steps});

  final String name;
  final List<String> steps;

  OrchTemplate copyWith({String? name, List<String>? steps}) =>
      OrchTemplate(name: name ?? this.name, steps: steps ?? this.steps);

  Map<String, dynamic> toJson() => {'name': name, 'steps': steps};

  factory OrchTemplate.fromJson(Map<String, dynamic> json) =>
      OrchTemplate(name: _str(json['name']), steps: _strList(json['steps']));
}

/// Mid-run autonomy gate for the supervised loop (`OrchestratorCheckpoint`).
class OrchCheckpoint {
  const OrchCheckpoint({this.mode = 'off', this.interval = 5});

  /// `off` | `per-step` | `every-n`.
  final String mode;

  /// Completed steps between pauses in `every-n` mode (1..50).
  final int interval;

  OrchCheckpoint copyWith({String? mode, int? interval}) =>
      OrchCheckpoint(mode: mode ?? this.mode, interval: interval ?? this.interval);

  Map<String, dynamic> toJson() => {'mode': mode, 'interval': interval};

  factory OrchCheckpoint.fromJson(Map<String, dynamic> json) => OrchCheckpoint(
    mode: orchCheckpointModes.contains(json['mode']) ? _str(json['mode']) : 'off',
    interval: _int(json['interval'], 5),
  );
}

/// Planner behaviour (`OrchestratorConfig.planner`).
class OrchPlanner {
  const OrchPlanner({
    this.candidateId = '',
    this.mode = 'auto',
    this.requireConfirm = false,
    this.checkpoint = const OrchCheckpoint(),
    this.templates = const [],
  });

  /// @deprecated upstream — supervised mode routes via `rules.plan`; kept so
  /// stored configs round-trip.
  final String candidateId;
  final String mode;
  final bool requireConfirm;
  final OrchCheckpoint checkpoint;
  final List<OrchTemplate> templates;

  OrchPlanner copyWith({
    String? candidateId,
    String? mode,
    bool? requireConfirm,
    OrchCheckpoint? checkpoint,
    List<OrchTemplate>? templates,
  }) => OrchPlanner(
    candidateId: candidateId ?? this.candidateId,
    mode: mode ?? this.mode,
    requireConfirm: requireConfirm ?? this.requireConfirm,
    checkpoint: checkpoint ?? this.checkpoint,
    templates: templates ?? this.templates,
  );

  Map<String, dynamic> toJson() => {
    'candidateId': candidateId,
    'mode': mode,
    'requireConfirm': requireConfirm,
    'checkpoint': checkpoint.toJson(),
    'templates': [for (final t in templates) t.toJson()],
  };

  factory OrchPlanner.fromJson(Map<String, dynamic> json) => OrchPlanner(
    candidateId: _str(json['candidateId']),
    mode: orchPlannerModes.contains(json['mode']) ? _str(json['mode']) : 'auto',
    requireConfirm: json['requireConfirm'] == true,
    checkpoint: json['checkpoint'] is Map
        ? OrchCheckpoint.fromJson(Map<String, dynamic>.from(json['checkpoint'] as Map))
        : const OrchCheckpoint(),
    templates: [
      for (final t in (json['templates'] as List?) ?? const [])
        if (t is Map) OrchTemplate.fromJson(Map<String, dynamic>.from(t)),
    ],
  );
}

/// Execution guardrails (`OrchestratorConfig.execution`).
class OrchExecution {
  const OrchExecution({
    this.maxParallel = 2,
    this.maxFixLoops = 2,
    this.useWorktree = false,
    this.onNoCandidate = 'ask',
    this.maxAttempts = 10,
    this.stepTimeoutMs = 30 * 60 * 1000,
    this.runTimeoutMs = 0,
    this.maxSupervisorIterations = 25,
    this.retryBackoffBaseMs = 10000,
    this.retry = const {'rate_limit': 2, 'quota': 0, 'auth': 0, 'timeout': 0, 'transient': 0},
  });

  final int maxParallel; // 1..8
  final int maxFixLoops; // 0..5
  final bool useWorktree;
  final String onNoCandidate; // ask | skip
  final int maxAttempts; // 1..50
  final int stepTimeoutMs; // 0 disables
  final int runTimeoutMs; // 0 disables
  final int maxSupervisorIterations; // 1..100
  final int retryBackoffBaseMs;

  /// Same-lane retry count per failure class (0..5 each).
  final Map<String, int> retry;

  OrchExecution copyWith({
    int? maxParallel,
    int? maxFixLoops,
    bool? useWorktree,
    String? onNoCandidate,
    int? maxAttempts,
    int? stepTimeoutMs,
    int? runTimeoutMs,
    int? maxSupervisorIterations,
    int? retryBackoffBaseMs,
    Map<String, int>? retry,
  }) => OrchExecution(
    maxParallel: maxParallel ?? this.maxParallel,
    maxFixLoops: maxFixLoops ?? this.maxFixLoops,
    useWorktree: useWorktree ?? this.useWorktree,
    onNoCandidate: onNoCandidate ?? this.onNoCandidate,
    maxAttempts: maxAttempts ?? this.maxAttempts,
    stepTimeoutMs: stepTimeoutMs ?? this.stepTimeoutMs,
    runTimeoutMs: runTimeoutMs ?? this.runTimeoutMs,
    maxSupervisorIterations: maxSupervisorIterations ?? this.maxSupervisorIterations,
    retryBackoffBaseMs: retryBackoffBaseMs ?? this.retryBackoffBaseMs,
    retry: retry ?? this.retry,
  );

  Map<String, dynamic> toJson() => {
    'maxParallel': maxParallel,
    'maxFixLoops': maxFixLoops,
    'useWorktree': useWorktree,
    'onNoCandidate': onNoCandidate,
    'maxAttempts': maxAttempts,
    'stepTimeoutMs': stepTimeoutMs,
    'runTimeoutMs': runTimeoutMs,
    'maxSupervisorIterations': maxSupervisorIterations,
    'retryBackoffBaseMs': retryBackoffBaseMs,
    'retry': retry,
  };

  factory OrchExecution.fromJson(Map<String, dynamic> json) {
    const d = OrchExecution();
    final retryRaw = json['retry'];
    return OrchExecution(
      maxParallel: _int(json['maxParallel'], d.maxParallel),
      maxFixLoops: _int(json['maxFixLoops'], d.maxFixLoops),
      useWorktree: json['useWorktree'] == true,
      onNoCandidate: orchOnNoCandidate.contains(json['onNoCandidate'])
          ? _str(json['onNoCandidate'])
          : d.onNoCandidate,
      maxAttempts: _int(json['maxAttempts'], d.maxAttempts),
      stepTimeoutMs: _int(json['stepTimeoutMs'], d.stepTimeoutMs),
      runTimeoutMs: _int(json['runTimeoutMs'], d.runTimeoutMs),
      maxSupervisorIterations: _int(json['maxSupervisorIterations'], d.maxSupervisorIterations),
      retryBackoffBaseMs: _int(json['retryBackoffBaseMs'], d.retryBackoffBaseMs),
      retry: {
        for (final cls in orchFailureClasses)
          cls: retryRaw is Map ? _int(retryRaw[cls], d.retry[cls] ?? 0) : (d.retry[cls] ?? 0),
      },
    );
  }
}

/// The whole `OrchestratorConfig` document.
class OrchestratorConfigData {
  const OrchestratorConfigData({
    required this.enabled,
    required this.pool,
    required this.rules,
    required this.planner,
    required this.execution,
  });

  final bool enabled;
  final List<OrchCandidate> pool;

  /// task type → ordered candidate ids; first available wins.
  final Map<String, List<String>> rules;
  final OrchPlanner planner;
  final OrchExecution execution;

  OrchestratorConfigData copyWith({
    bool? enabled,
    List<OrchCandidate>? pool,
    Map<String, List<String>>? rules,
    OrchPlanner? planner,
    OrchExecution? execution,
  }) => OrchestratorConfigData(
    enabled: enabled ?? this.enabled,
    pool: pool ?? this.pool,
    rules: rules ?? this.rules,
    planner: planner ?? this.planner,
    execution: execution ?? this.execution,
  );

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'pool': [for (final c in pool) c.toJson()],
    'rules': {for (final e in rules.entries) e.key: e.value},
    'planner': planner.toJson(),
    'execution': execution.toJson(),
  };

  /// Tolerant parse — unknown task types pass through, missing pieces take
  /// the same defaults the server validator fills in.
  factory OrchestratorConfigData.fromJson(Map<String, dynamic> json) {
    final rulesRaw = json['rules'];
    return OrchestratorConfigData(
      enabled: json['enabled'] != false,
      pool: [
        for (final c in (json['pool'] as List?) ?? const [])
          if (c is Map) OrchCandidate.fromJson(Map<String, dynamic>.from(c)),
      ],
      rules: {
        for (final lane in orchRuleLanes)
          lane: rulesRaw is Map ? _strList(rulesRaw[lane]) : const [],
      },
      planner: json['planner'] is Map
          ? OrchPlanner.fromJson(Map<String, dynamic>.from(json['planner'] as Map))
          : const OrchPlanner(),
      execution: json['execution'] is Map
          ? OrchExecution.fromJson(Map<String, dynamic>.from(json['execution'] as Map))
          : const OrchExecution(),
    );
  }
}

/// `/api/providers/{provider}/models` option — only what the pool row needs.
class OrchModelOption {
  const OrchModelOption({required this.value, required this.label, this.effortValues = const []});

  final String value;
  final String label;
  final List<String> effortValues;

  factory OrchModelOption.fromJson(Map<String, dynamic> json) => OrchModelOption(
    value: _str(json['value']),
    label: _str(json['label'], _str(json['value'])),
    effortValues: [
      for (final e in ((json['effort'] as Map?)?['values'] as List?) ?? const [])
        if (e is Map) _str(e['value']),
    ],
  );
}
