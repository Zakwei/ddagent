/// Domain models for /api/schedules — mirrors schedules.db.ts + routes.
library;

import 'package:ddagent_app/i18n/strings.g.dart';

String _str(Object? v) => v?.toString() ?? '';
String? _strOrNull(Object? v) => v?.toString();

/// One recurring agent run (server `Schedule`, camelCase via toClient).
class SchedulerJob {
  const SchedulerJob({
    required this.id,
    this.projectId = '',
    this.provider = '',
    this.cron = '',
    this.prompt = '',
    this.useWorktree = false,
    this.catchUp = false,
    this.enabled = true,
    this.failCount = 0,
    this.lastRunAt,
    this.nextRunAt,
    this.createdAt,
  });

  final String id;
  final String projectId;
  final String provider;
  final String cron;
  final String prompt;
  final bool useWorktree;
  final bool catchUp;
  final bool enabled;
  final int failCount;
  final String? lastRunAt;
  final String? nextRunAt;
  final String? createdAt;

  SchedulerJob copyWith({bool? enabled, String? Function()? nextRunAt}) => SchedulerJob(
    id: id,
    projectId: projectId,
    provider: provider,
    cron: cron,
    prompt: prompt,
    useWorktree: useWorktree,
    catchUp: catchUp,
    enabled: enabled ?? this.enabled,
    failCount: failCount,
    lastRunAt: lastRunAt,
    nextRunAt: nextRunAt != null ? nextRunAt() : this.nextRunAt,
    createdAt: createdAt,
  );

  static SchedulerJob fromJson(Map<String, dynamic> j) => SchedulerJob(
    id: _str(j['id']),
    projectId: _str(j['projectId']),
    provider: _str(j['provider']),
    cron: _str(j['cron']),
    prompt: _str(j['prompt']),
    useWorktree: j['useWorktree'] == true,
    catchUp: j['catchUp'] == true,
    enabled: j['enabled'] != false,
    failCount: (j['failCount'] as num?)?.toInt() ?? 0,
    lastRunAt: _strOrNull(j['lastRunAt']),
    nextRunAt: _strOrNull(j['nextRunAt']),
    createdAt: _strOrNull(j['createdAt']),
  );
}

/// One fired/skipped/failed/completed execution of a schedule.
class SchedulerRun {
  const SchedulerRun({
    required this.id,
    this.scheduleId = '',
    this.sessionId,
    this.status = 'fired',
    this.error,
    this.startedAt = '',
    this.finishedAt,
  });

  final String id;
  final String scheduleId;
  final String? sessionId;
  final String status; // fired | skipped | failed | completed
  final String? error;
  final String startedAt;
  final String? finishedAt;

  static SchedulerRun fromJson(Map<String, dynamic> j) => SchedulerRun(
    id: _str(j['id']),
    scheduleId: _str(j['scheduleId']),
    sessionId: _strOrNull(j['sessionId']),
    status: _str(j['status']).isEmpty ? 'fired' : _str(j['status']),
    error: _strOrNull(j['error']),
    startedAt: _str(j['startedAt']),
    finishedAt: _strOrNull(j['finishedAt']),
  );
}

/// Answer of `GET /preview?cron=` — the server-materialized next fire time.
class CronPreview {
  const CronPreview({this.cron = '', this.nextRunAt});

  final String cron;
  final String? nextRunAt;

  static CronPreview fromJson(Map<String, dynamic> j) =>
      CronPreview(cron: _str(j['cron']), nextRunAt: _strOrNull(j['nextRunAt']));
}

// ─── Cron validation ──────────────────────────────────────────────────────

const _monthNames = {
  'jan': 1,
  'feb': 2,
  'mar': 3,
  'apr': 4,
  'may': 5,
  'jun': 6,
  'jul': 7,
  'aug': 8,
  'sep': 9,
  'oct': 10,
  'nov': 11,
  'dec': 12,
};
const _dowNames = {'sun': 0, 'mon': 1, 'tue': 2, 'wed': 3, 'thu': 4, 'fri': 5, 'sat': 6};

/// Structural validation of a 5-field cron expression (min hour dom mon dow).
/// Returns an error string or null when the shape is valid — the server
/// remains authoritative (it rejects with `CRON_INVALID`).
String? validateCron(String expr) {
  final fields = expr.trim().split(RegExp(r'\s+'));
  if (fields.length != 5) return t.scheduler.cronErrors.fieldCount(got: fields.length);
  const ranges = [(0, 59), (0, 23), (1, 31), (1, 12), (0, 7)];
  const names = [null, null, null, _monthNames, _dowNames];
  for (var i = 0; i < 5; i++) {
    final err = _checkField(fields[i], ranges[i].$1, ranges[i].$2, names[i]);
    if (err != null) return t.scheduler.cronErrors.fieldError(index: i + 1, error: err);
  }
  return null;
}

String? _checkField(String f, int lo, int hi, Map<String, int>? names) {
  if (f.isEmpty) return t.scheduler.cronErrors.empty;
  int? value(String v) {
    if (v == '*') return null;
    final n = names?[v.toLowerCase()] ?? int.tryParse(v);
    if (n == null) return -1;
    if (n < lo || n > hi) return -1;
    return n;
  }

  for (final part in f.split(',')) {
    // part = base[/step]; base = '*' | value | value-value
    final slash = part.split('/');
    if (slash.length > 2 || (slash.length == 2 && (int.tryParse(slash[1]) ?? 0) < 1)) {
      return t.scheduler.cronErrors.invalidPart(part: part);
    }
    final base = slash[0];
    if (base.isEmpty) return t.scheduler.cronErrors.invalidPart(part: part);
    for (final v in base.split('-')) {
      if (v.isEmpty) return t.scheduler.cronErrors.invalidPart(part: part);
      if (value(v) == -1) return t.scheduler.cronErrors.invalidValue(value: v);
    }
  }
  return null;
}
