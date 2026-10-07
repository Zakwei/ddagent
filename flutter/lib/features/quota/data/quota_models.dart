/// Domain models for /api/quota — mirrors server/shared/types.ts quota types.
library;

num _num(Object? v) => v is num ? v : num.tryParse('$v') ?? 0;
String _str(Object? v) => v?.toString() ?? '';
String? _strOrNull(Object? v) => v?.toString();

class QuotaWindow {
  const QuotaWindow({
    this.label = '',
    this.kind = 'session',
    this.percent = 0,
    this.remainingPercent = 100,
    this.resetsAt,
    this.status = '',
    this.projectedExhaustionAt,
    this.etaSeconds,
    this.burnRatePerHour,
  });

  final String label;
  final String kind;
  final double percent;
  final double remainingPercent;
  final String? resetsAt;
  final String status;
  final String? projectedExhaustionAt;
  final int? etaSeconds;
  final double? burnRatePerHour;

  static QuotaWindow fromJson(Map<String, dynamic> j) => QuotaWindow(
    label: _str(j['label']),
    kind: _str(j['kind']).isEmpty ? 'session' : _str(j['kind']),
    percent: _num(j['percent']).toDouble(),
    remainingPercent: _num(j['remainingPercent']).toDouble(),
    resetsAt: _strOrNull(j['resetsAt']),
    status: _str(j['status']),
    projectedExhaustionAt: _strOrNull(j['projectedExhaustionAt']),
    etaSeconds: j['etaSeconds'] == null ? null : _num(j['etaSeconds']).toInt(),
    burnRatePerHour: j['burnRatePerHour'] == null ? null : _num(j['burnRatePerHour']).toDouble(),
  );
}

class QuotaAssignedAgent {
  const QuotaAssignedAgent({this.agentId = '', this.role = '', this.activeTasks = 0});

  final String agentId;
  final String role;
  final int activeTasks;

  static QuotaAssignedAgent fromJson(Map<String, dynamic> j) => QuotaAssignedAgent(
    agentId: _str(j['agentId']),
    role: _str(j['role']),
    activeTasks: _num(j['activeTasks']).toInt(),
  );
}

class QuotaAccount {
  const QuotaAccount({
    required this.id,
    this.provider = '',
    this.providerLabel = '',
    this.plan = '',
    this.accountLabel = '',
    this.accountEmail = '',
    this.status = 'unknown',
    this.quality = 'unknown',
    this.lastSyncedAt,
    this.syncError,
    this.windows = const [],
    this.assignedAgents = const [],
  });

  final String id;
  final String provider;
  final String providerLabel;
  final String plan;
  final String accountLabel;
  final String accountEmail; // login email of the credentials; '' when unknown
  final String status; // active | inactive | error
  final String quality; // live | cached | estimate | unknown | error
  final String? lastSyncedAt;
  final String? syncError;
  final List<QuotaWindow> windows;
  final List<QuotaAssignedAgent> assignedAgents;

  static QuotaAccount fromJson(Map<String, dynamic> j) => QuotaAccount(
    id: _str(j['id'] ?? j['provider']),
    provider: _str(j['provider']),
    providerLabel: _str(j['providerLabel']),
    plan: _str(j['plan']),
    accountLabel: _str(j['accountLabel']),
    accountEmail: _str(j['accountEmail']),
    status: _str(j['status']).isEmpty ? 'unknown' : _str(j['status']),
    quality: _str(j['quality']).isEmpty ? 'unknown' : _str(j['quality']),
    lastSyncedAt: _strOrNull(j['lastSyncedAt']),
    syncError: _strOrNull(j['syncError']),
    windows: [
      for (final w in j['windows'] as List? ?? const [])
        if (w is Map) QuotaWindow.fromJson(Map<String, dynamic>.from(w)),
    ],
    assignedAgents: [
      for (final a in j['assignedAgents'] as List? ?? const [])
        if (a is Map) QuotaAssignedAgent.fromJson(Map<String, dynamic>.from(a)),
    ],
  );
}

class QuotaOverview {
  const QuotaOverview({
    this.accountsAtRisk = 0,
    this.accountsErrored = 0,
    this.windowsAtRisk = 0,
    this.nextResetAt,
    this.watchThreshold = 0,
    this.dangerThreshold = 0,
  });

  final int accountsAtRisk;
  final int accountsErrored;
  final int windowsAtRisk;
  final String? nextResetAt;
  final double watchThreshold;
  final double dangerThreshold;

  static QuotaOverview fromJson(Map<String, dynamic> j) => QuotaOverview(
    accountsAtRisk: _num(j['accountsAtRisk']).toInt(),
    accountsErrored: _num(j['accountsErrored']).toInt(),
    windowsAtRisk: _num(j['windowsAtRisk']).toInt(),
    nextResetAt: _strOrNull(j['nextResetAt']),
    watchThreshold: _num(j['watchThreshold']).toDouble(),
    dangerThreshold: _num(j['dangerThreshold']).toDouble(),
  );
}

class QuotaSnapshot {
  const QuotaSnapshot({
    this.overview = const QuotaOverview(),
    this.accounts = const [],
    this.generatedAt,
  });

  final QuotaOverview overview;
  final List<QuotaAccount> accounts;
  final String? generatedAt;

  static QuotaSnapshot fromJson(Map<String, dynamic> j) => QuotaSnapshot(
    overview: j['overview'] is Map
        ? QuotaOverview.fromJson(Map<String, dynamic>.from(j['overview'] as Map))
        : const QuotaOverview(),
    accounts: [
      for (final a in j['accounts'] as List? ?? const [])
        if (a is Map) QuotaAccount.fromJson(Map<String, dynamic>.from(a)),
    ],
    generatedAt: _strOrNull(j['generatedAt']),
  );
}

class QuotaHistoryPoint {
  const QuotaHistoryPoint({this.label = '', this.percent = 0, this.at = '', this.resetsAt});

  final String label;
  final double percent;
  final String at;
  final String? resetsAt;

  static QuotaHistoryPoint fromJson(Map<String, dynamic> j) => QuotaHistoryPoint(
    label: _str(j['label']),
    percent: _num(j['percent']).toDouble(),
    at: _str(j['at']),
    resetsAt: _strOrNull(j['resetsAt']),
  );
}

/// Per-account sparkline series (oldest first).
class AccountHistory {
  const AccountHistory({this.accountId = '', this.points = const []});

  final String accountId;
  final List<QuotaHistoryPoint> points;

  static AccountHistory fromJson(Map<String, dynamic> j) => AccountHistory(
    accountId: _str(j['accountId']),
    points: [
      for (final p in j['points'] as List? ?? const [])
        if (p is Map) QuotaHistoryPoint.fromJson(Map<String, dynamic>.from(p)),
    ],
  );
}

/// Token/cost totals — one bucket or the whole summary's totals row.
class UsageMetric {
  const UsageMetric({
    this.key = '',
    this.label = '',
    this.tokensInput = 0,
    this.tokensOutput = 0,
    this.tokensReasoning = 0,
    this.tokensCacheRead = 0,
    this.tokensCacheWrite = 0,
    this.tokensTotal = 0,
    this.apiCalls = 0,
    this.costUsd = 0,
    this.sessions = 0,
  });

  final String key;
  final String label;
  final int tokensInput;
  final int tokensOutput;
  final int tokensReasoning;
  final int tokensCacheRead;
  final int tokensCacheWrite;
  final int tokensTotal;
  final int apiCalls;
  final double costUsd;
  final int sessions;

  static UsageMetric fromJson(Map<String, dynamic> j) => UsageMetric(
    key: _str(j['key']),
    label: _str(j['label']),
    tokensInput: _num(j['tokensInput']).toInt(),
    tokensOutput: _num(j['tokensOutput']).toInt(),
    tokensReasoning: _num(j['tokensReasoning']).toInt(),
    tokensCacheRead: _num(j['tokensCacheRead']).toInt(),
    tokensCacheWrite: _num(j['tokensCacheWrite']).toInt(),
    tokensTotal: _num(j['tokensTotal']).toInt(),
    apiCalls: _num(j['apiCalls']).toInt(),
    costUsd: _num(j['costUsd']).toDouble(),
    sessions: _num(j['sessions']).toInt(),
  );
}

class UsageTrendPoint {
  const UsageTrendPoint({this.date = '', this.tokensTotal = 0, this.costUsd = 0});

  final String date;
  final int tokensTotal;
  final double costUsd;

  static UsageTrendPoint fromJson(Map<String, dynamic> j) => UsageTrendPoint(
    date: _str(j['date']),
    tokensTotal: _num(j['tokensTotal']).toInt(),
    costUsd: _num(j['costUsd']).toDouble(),
  );
}

/// `GET /api/quota/usage` payload.
class UsageSummary {
  const UsageSummary({
    this.period = '7d',
    this.groupBy = 'provider',
    this.totals = const UsageMetric(),
    this.buckets = const [],
    this.trend = const [],
    this.cacheSavingsUsd = 0,
    this.billedUsd = 0,
    this.listPriceUsd = 0,
    this.subscriptionValueUsd = 0,
    this.source = '',
    this.generatedAt,
  });

  final String period;
  final String groupBy;
  final UsageMetric totals;
  final List<UsageMetric> buckets;
  final List<UsageTrendPoint> trend;
  final double cacheSavingsUsd;
  final double billedUsd;
  final double listPriceUsd;
  final double subscriptionValueUsd;
  final String source;
  final String? generatedAt;

  static UsageSummary fromJson(Map<String, dynamic> j) {
    final eff = j['effectiveCost'] as Map<String, dynamic>? ?? const {};
    return UsageSummary(
      period: _str(j['period']).isEmpty ? '7d' : _str(j['period']),
      groupBy: _str(j['groupBy']).isEmpty ? 'provider' : _str(j['groupBy']),
      totals: j['totals'] is Map
          ? UsageMetric.fromJson(Map<String, dynamic>.from(j['totals'] as Map))
          : const UsageMetric(),
      buckets: [
        for (final b in j['buckets'] as List? ?? const [])
          if (b is Map) UsageMetric.fromJson(Map<String, dynamic>.from(b)),
      ],
      trend: [
        for (final t in j['trend'] as List? ?? const [])
          if (t is Map) UsageTrendPoint.fromJson(Map<String, dynamic>.from(t)),
      ],
      cacheSavingsUsd: _num(j['cacheSavingsUsd']).toDouble(),
      billedUsd: _num(eff['billedUsd']).toDouble(),
      listPriceUsd: _num(eff['listPriceUsd']).toDouble(),
      subscriptionValueUsd: _num(eff['subscriptionValueUsd']).toDouble(),
      source: _str(j['source']),
      generatedAt: _strOrNull(j['generatedAt']),
    );
  }
}

class AgentFleetEntry {
  const AgentFleetEntry({
    this.agentId = '',
    this.role = '',
    this.status = 'queued',
    this.taskId,
    this.taskTitle,
    this.provider,
    this.model,
    this.sessionId,
    this.tokensTotal = 0,
    this.costUsd = 0,
    this.startedAt,
    this.elapsedSeconds = 0,
    this.result,
    this.retryCount,
  });

  final String agentId;
  final String role;
  final String status; // running | waiting | failed | finished | queued
  final String? taskId;
  final String? taskTitle;
  final String? provider;
  final String? model;
  final String? sessionId;
  final int tokensTotal;
  final double costUsd;
  final String? startedAt;
  final int elapsedSeconds;
  final String? result;
  final int? retryCount;

  static AgentFleetEntry fromJson(Map<String, dynamic> j) => AgentFleetEntry(
    agentId: _str(j['agentId']),
    role: _str(j['role']),
    status: _str(j['status']).isEmpty ? 'queued' : _str(j['status']),
    taskId: _strOrNull(j['taskId']),
    taskTitle: _strOrNull(j['taskTitle']),
    provider: _strOrNull(j['provider']),
    model: _strOrNull(j['model']),
    sessionId: _strOrNull(j['sessionId']),
    tokensTotal: _num(j['tokensTotal']).toInt(),
    costUsd: _num(j['costUsd']).toDouble(),
    startedAt: _strOrNull(j['startedAt']),
    elapsedSeconds: _num(j['elapsedSeconds']).toInt(),
    result: _strOrNull(j['result']),
    retryCount: j['retryCount'] == null ? null : _num(j['retryCount']).toInt(),
  );
}

class AgentFleetSummary {
  const AgentFleetSummary({
    this.running = 0,
    this.waiting = 0,
    this.failed = 0,
    this.finished = 0,
    this.queued = 0,
    this.totalTokens = 0,
    this.totalCostUsd = 0,
  });

  final int running;
  final int waiting;
  final int failed;
  final int finished;
  final int queued;
  final int totalTokens;
  final double totalCostUsd;

  static AgentFleetSummary fromJson(Map<String, dynamic> j) => AgentFleetSummary(
    running: _num(j['running']).toInt(),
    waiting: _num(j['waiting']).toInt(),
    failed: _num(j['failed']).toInt(),
    finished: _num(j['finished']).toInt(),
    queued: _num(j['queued']).toInt(),
    totalTokens: _num(j['totalTokens']).toInt(),
    totalCostUsd: _num(j['totalCostUsd']).toDouble(),
  );
}

/// `GET /api/quota/agents` payload.
class FleetSnapshot {
  const FleetSnapshot({
    this.entries = const [],
    this.summary = const AgentFleetSummary(),
    this.generatedAt,
  });

  final List<AgentFleetEntry> entries;
  final AgentFleetSummary summary;
  final String? generatedAt;

  static FleetSnapshot fromJson(Map<String, dynamic> j) => FleetSnapshot(
    entries: [
      for (final e in j['entries'] as List? ?? const [])
        if (e is Map) AgentFleetEntry.fromJson(Map<String, dynamic>.from(e)),
    ],
    summary: j['summary'] is Map
        ? AgentFleetSummary.fromJson(Map<String, dynamic>.from(j['summary'] as Map))
        : const AgentFleetSummary(),
    generatedAt: _strOrNull(j['generatedAt']),
  );
}

class QuotaAccountConfig {
  const QuotaAccountConfig({
    this.accountId = '',
    this.watchThreshold = 0,
    this.dangerThreshold = 0,
    this.routingEnabled = true,
  });

  final String accountId;
  final double watchThreshold;
  final double dangerThreshold;
  final bool routingEnabled;

  static QuotaAccountConfig fromJson(Map<String, dynamic> j) => QuotaAccountConfig(
    accountId: _str(j['accountId']),
    watchThreshold: _num(j['watchThreshold']).toDouble(),
    dangerThreshold: _num(j['dangerThreshold']).toDouble(),
    routingEnabled: j['routingEnabled'] != false,
  );
}

/// `GET/PUT /api/quota/config` — alerting, thresholds, routing behaviour.
class QuotaConfig {
  const QuotaConfig({
    this.routingMode = 'manual',
    this.alertsEnabled = true,
    this.watchThreshold = 0,
    this.dangerThreshold = 0,
    this.accounts = const [],
  });

  final String routingMode; // manual | ask | auto-low-risk
  final bool alertsEnabled;
  final double watchThreshold;
  final double dangerThreshold;
  final List<QuotaAccountConfig> accounts;

  static QuotaConfig fromJson(Map<String, dynamic> j) => QuotaConfig(
    routingMode: _str(j['routingMode']).isEmpty ? 'manual' : _str(j['routingMode']),
    alertsEnabled: j['alertsEnabled'] != false,
    watchThreshold: _num(j['watchThreshold']).toDouble(),
    dangerThreshold: _num(j['dangerThreshold']).toDouble(),
    accounts: [
      for (final a in j['accounts'] as List? ?? const [])
        if (a is Map) QuotaAccountConfig.fromJson(Map<String, dynamic>.from(a)),
    ],
  );

  Map<String, dynamic> toJson() => {
    'routingMode': routingMode,
    'alertsEnabled': alertsEnabled,
    'watchThreshold': watchThreshold,
    'dangerThreshold': dangerThreshold,
    'accounts': [
      for (final a in accounts)
        {
          'accountId': a.accountId,
          'watchThreshold': a.watchThreshold,
          'dangerThreshold': a.dangerThreshold,
          'routingEnabled': a.routingEnabled,
        },
    ],
  };
}
