import 'package:ddagent_app/features/orchestrator/data/orchestrator_config.dart';
import 'package:flutter_test/flutter_test.dart';

/// Round-trip checks for the settings draft model — the section edits a
/// whole-document draft, so `fromJson(toJson(x))` must be a fixed point.
void main() {
  const payload = {
    'enabled': true,
    'pool': [
      {
        'id': 'cand-1',
        'provider': 'claude',
        'model': 'claude-sonnet-4-5',
        'effort': 'high',
        'accountId': 'acct-9',
        'fallbackAccountIds': ['acct-7', 'acct-8'],
        'tier': 'premium',
        'label': 'Main',
      },
      {
        'id': 'cand-2',
        'provider': 'codex',
        'model': 'gpt-5.2-codex',
        'effort': null,
        'accountId': null,
        'tier': 'free',
        'label': '',
      },
    ],
    'rules': {
      'plan': ['cand-1'],
      'code': ['cand-1', 'cand-2'],
      'gate': ['deterministic'],
    },
    'planner': {
      'candidateId': 'cand-1',
      'mode': 'auto',
      'requireConfirm': true,
      'checkpoint': {'mode': 'every-n', 'interval': 3},
      'templates': [
        {
          'name': 'default',
          'steps': ['code', 'test', 'review'],
        },
      ],
    },
    'execution': {
      'maxParallel': 4,
      'maxFixLoops': 1,
      'useWorktree': true,
      'onNoCandidate': 'skip',
      'maxAttempts': 20,
      'stepTimeoutMs': 60000,
      'runTimeoutMs': 3600000,
      'maxSupervisorIterations': 50,
      'retryBackoffBaseMs': 5000,
      'retry': {'rate_limit': 3, 'quota': 1, 'auth': 0, 'timeout': 2, 'transient': 4},
    },
  };

  test('fromJson parses every section of the server payload', () {
    final config = OrchestratorConfigData.fromJson(Map<String, dynamic>.from(payload));

    expect(config.enabled, isTrue);
    expect(config.pool, hasLength(2));
    expect(config.pool.first.accountId, 'acct-9');
    expect(config.pool.first.fallbackAccountIds, ['acct-7', 'acct-8']);
    expect(config.pool[1].fallbackAccountIds, isEmpty);
    expect(config.rules['code'], ['cand-1', 'cand-2']);
    expect(config.planner.checkpoint.mode, 'every-n');
    expect(config.planner.checkpoint.interval, 3);
    expect(config.planner.templates.single.steps, ['code', 'test', 'review']);
    expect(config.execution.maxAttempts, 20);
    expect(config.execution.retry['rate_limit'], 3);
    expect(config.execution.retry['transient'], 4);
  });

  test('toJson(fromJson(x)) round-trips the full document', () {
    final config = OrchestratorConfigData.fromJson(Map<String, dynamic>.from(payload));
    final again = OrchestratorConfigData.fromJson(Map<String, dynamic>.from(config.toJson()));
    expect(again.toJson(), config.toJson());
  });

  test('rules parse keeps every editable lane, drops non-lane keys', () {
    final config = OrchestratorConfigData.fromJson(Map<String, dynamic>.from(payload));
    // `gate` is deterministic — never a routable lane.
    expect(config.rules.keys, containsAll(orchRuleLanes));
    expect(config.rules.keys, isNot(contains('gate')));
    expect(config.rules['quick'], isEmpty);
  });

  test('tolerant parse fills defaults for missing/garbage fields', () {
    final config = OrchestratorConfigData.fromJson(const {
      'enabled': 'yes',
      'planner': {'mode': 'nonsense', 'checkpoint': 'bad'},
      'execution': {'maxParallel': '3', 'onNoCandidate': '???'},
    });
    expect(config.enabled, isTrue); // only `false` disables
    expect(config.planner.mode, 'auto');
    expect(config.planner.checkpoint.mode, 'off');
    expect(config.execution.maxParallel, 3);
    expect(config.execution.onNoCandidate, 'ask');
    expect(config.execution.retry.keys, containsAll(orchFailureClasses));
  });
}
