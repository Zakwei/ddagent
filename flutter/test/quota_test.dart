import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/quota/data/quota_models.dart';
import 'package:ddagent_app/features/quota/data/quota_repository.dart';
import 'package:ddagent_app/features/quota/state/quota_controller.dart';
import 'package:ddagent_app/features/quota/view/quota_screen.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeQuotaRepo extends QuotaRepository {
  _FakeQuotaRepo() : super(Dio());

  final calls = <String>[];
  Object? opError;
  Object? snapshotError;
  Object? refreshError;
  Object? usageError;
  Map<String, dynamic>? snapshotJson;
  Map<String, dynamic>? agentsJson;

  @override
  Future<Map<String, dynamic>> snapshot() async {
    if (snapshotError != null) throw snapshotError!;
    calls.add('snapshot');
    return snapshotJson ??
        {
          'overview': {
            'accountsAtRisk': 1,
            'accountsErrored': 1,
            'windowsAtRisk': 1,
            'watchThreshold': 70,
            'dangerThreshold': 90,
          },
          'accounts': [
            {
              'id': 'devin',
              'provider': 'devin',
              'providerLabel': 'Devin',
              'accountLabel': 'Main',
              'plan': 'Team',
              'status': 'active',
              'quality': 'live',
              'windows': [
                {'label': 'Weekly', 'kind': 'weekly', 'percent': 62.5},
              ],
              'assignedAgents': [
                {'agentId': 'a1', 'role': 'Builder', 'activeTasks': 2},
              ],
            },
            {
              'id': 'gemini',
              'provider': 'gemini',
              'providerLabel': 'Gemini',
              'status': 'error',
              'syncError': 'Sync error with provider',
            },
            {
              'id': 'copilot',
              'provider': 'copilot',
              'providerLabel': 'GitHub Copilot',
              'plan': 'Enterprise',
              'status': 'inactive',
            },
          ],
          'generatedAt': '2026-01-01T00:00:00Z',
        };
  }

  @override
  Future<Map<String, dynamic>> refresh() async {
    if (refreshError != null) throw refreshError!;
    calls.add('refresh');
    return snapshot();
  }

  @override
  Future<Map<String, dynamic>> config() async => {
    'routingMode': 'ask',
    'alertsEnabled': true,
    'watchThreshold': 70,
    'dangerThreshold': 90,
    'accounts': [
      {'accountId': 'devin', 'routingEnabled': false},
    ],
  };

  @override
  Future<void> saveConfig(Map<String, dynamic> body) async {
    if (opError != null) throw opError!;
    calls.add('saveConfig:${body['routingMode']}');
  }

  @override
  Future<List<Map<String, dynamic>>> history(String accountId, {int? limit}) async {
    if (opError != null) throw opError!;
    calls.add('history:$accountId');
    return [
      {'label': 'Weekly', 'percent': 40, 'at': '2026-01-01'},
      {'label': 'Weekly', 'percent': 55, 'at': '2026-01-02'},
      {'label': 'Weekly', 'percent': 62.5, 'at': '2026-01-03'},
    ];
  }

  @override
  Future<Map<String, dynamic>> usage({required String period, required String groupBy}) async {
    if (usageError != null) throw usageError!;
    calls.add('usage:$period:$groupBy');
    return {
      'period': period,
      'groupBy': groupBy,
      'totals': {'tokensTotal': 1000, 'costUsd': 1.5, 'apiCalls': 4, 'sessions': 3},
      'buckets': [
        {'key': 'devin', 'label': 'Devin', 'tokensTotal': 800, 'costUsd': 1.2, 'apiCalls': 3},
      ],
      'trend': [
        {'date': '2026-01-01', 'tokensTotal': 400, 'costUsd': 0.6},
        {'date': '2026-01-02', 'tokensTotal': 600, 'costUsd': 0.9},
      ],
      'cacheSavingsUsd': 0.4,
      'effectiveCost': {'billedUsd': 1.0, 'listPriceUsd': 2.0, 'subscriptionValueUsd': 5.0},
      'source': 'test',
    };
  }

  @override
  Future<Map<String, dynamic>> agents() async =>
      agentsJson ??
      {
        'entries': [
          {
            'agentId': 'a1',
            'role': 'Builder',
            'status': 'running',
            'provider': 'devin',
            'taskTitle': 'Ship quota UI',
            'tokensTotal': 500,
            'costUsd': 0.5,
            'elapsedSeconds': 60,
          },
          {
            'agentId': 'a2',
            'role': 'Reviewer',
            'status': 'failed',
            'elapsedSeconds': 30,
            'result': 'Timed out',
          },
        ],
        'summary': {'running': 1, 'failed': 1, 'totalTokens': 500, 'totalCostUsd': 0.5},
        'generatedAt': '2026-01-01T00:00:00Z',
      };
}

Widget _buildApp(_FakeQuotaRepo repo, {bool dark = false}) => TranslationProvider(
  child: ProviderScope(
    overrides: [quotaRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(theme: dark ? AppTheme.dark() : AppTheme.light(), home: const QuotaScreen()),
  ),
);

Future<void> _pumpScreen(WidgetTester t, _FakeQuotaRepo repo) async {
  await t.pumpWidget(_buildApp(repo));
  await t.pumpAndSettle();
}

Future<void> _switchNav(WidgetTester t, String label) async {
  await t.tap(find.text(label).last);
  await t.pumpAndSettle();
}

void main() {
  group('Modele domenowe Quota i Usage (deserializacja)', () {
    test('QuotaSnapshot, QuotaOverview, QuotaAccount, QuotaWindow', () {
      final json = {
        'overview': {
          'accountsAtRisk': 2,
          'accountsErrored': 1,
          'windowsAtRisk': 3,
          'nextResetAt': '2026-01-02T00:00:00Z',
          'watchThreshold': 70,
          'dangerThreshold': 90,
        },
        'accounts': [
          {
            'id': 'acc1',
            'provider': 'devin',
            'providerLabel': 'Devin AI',
            'plan': 'Pro',
            'accountLabel': 'Primary',
            'status': 'active',
            'quality': 'live',
            'lastSyncedAt': '2026-01-01T12:00:00Z',
            'syncError': null,
            'windows': [
              {
                'label': 'Daily',
                'kind': 'daily',
                'percent': 45.5,
                'remainingPercent': 54.5,
                'resetsAt': '2026-01-02T00:00:00Z',
                'status': 'normal',
                'projectedExhaustionAt': '2026-01-01T23:00:00Z',
                'etaSeconds': 3600,
                'burnRatePerHour': 4.5,
              },
            ],
            'assignedAgents': [
              {'agentId': 'ag1', 'role': 'Builder', 'activeTasks': 2},
            ],
          },
        ],
        'generatedAt': '2026-01-01T00:00:00Z',
      };

      final snapshot = QuotaSnapshot.fromJson(json);
      expect(snapshot.overview.accountsAtRisk, 2);
      expect(snapshot.overview.accountsErrored, 1);
      expect(snapshot.overview.windowsAtRisk, 3);
      expect(snapshot.overview.nextResetAt, '2026-01-02T00:00:00Z');
      expect(snapshot.overview.watchThreshold, 70.0);
      expect(snapshot.overview.dangerThreshold, 90.0);

      expect(snapshot.accounts.length, 1);
      final acc = snapshot.accounts.first;
      expect(acc.id, 'acc1');
      expect(acc.provider, 'devin');
      expect(acc.providerLabel, 'Devin AI');
      expect(acc.plan, 'Pro');
      expect(acc.status, 'active');
      expect(acc.quality, 'live');
      expect(acc.windows.first.percent, 45.5);
      expect(acc.windows.first.remainingPercent, 54.5);
      expect(acc.windows.first.etaSeconds, 3600);
      expect(acc.windows.first.burnRatePerHour, 4.5);
      expect(acc.assignedAgents.first.agentId, 'ag1');
      expect(acc.assignedAgents.first.role, 'Builder');
      expect(acc.assignedAgents.first.activeTasks, 2);
    });

    test('QuotaConfig i QuotaAccountConfig (deserializacja i toJson)', () {
      final json = {
        'routingMode': 'auto-low-risk',
        'alertsEnabled': true,
        'watchThreshold': 65,
        'dangerThreshold': 85,
        'accounts': [
          {
            'accountId': 'acc1',
            'watchThreshold': 60,
            'dangerThreshold': 80,
            'routingEnabled': true,
          },
          {
            'accountId': 'acc2',
            'watchThreshold': 75,
            'dangerThreshold': 95,
            'routingEnabled': false,
          },
        ],
      };

      final config = QuotaConfig.fromJson(json);
      expect(config.routingMode, 'auto-low-risk');
      expect(config.alertsEnabled, isTrue);
      expect(config.watchThreshold, 65.0);
      expect(config.dangerThreshold, 85.0);
      expect(config.accounts.length, 2);
      expect(config.accounts[0].accountId, 'acc1');
      expect(config.accounts[0].routingEnabled, isTrue);
      expect(config.accounts[1].accountId, 'acc2');
      expect(config.accounts[1].routingEnabled, isFalse);

      final exported = config.toJson();
      expect(exported['routingMode'], 'auto-low-risk');
      expect(exported['alertsEnabled'], isTrue);
      expect((exported['accounts'] as List).length, 2);
    });

    test('FleetSnapshot, AgentFleetEntry i AgentFleetSummary', () {
      final json = {
        'entries': [
          {
            'agentId': 'ag1',
            'role': 'Coder',
            'status': 'running',
            'taskId': 't1',
            'taskTitle': 'Implement feature',
            'provider': 'opencode',
            'model': 'claude-3-5-sonnet',
            'sessionId': 's1',
            'tokensTotal': 12000,
            'costUsd': 0.08,
            'startedAt': '2026-01-01T00:00:00Z',
            'elapsedSeconds': 120,
            'result': null,
            'retryCount': 1,
          },
        ],
        'summary': {
          'running': 1,
          'waiting': 0,
          'failed': 0,
          'finished': 2,
          'queued': 0,
          'totalTokens': 12000,
          'totalCostUsd': 0.08,
        },
        'generatedAt': '2026-01-01T00:05:00Z',
      };

      final fleet = FleetSnapshot.fromJson(json);
      expect(fleet.entries.length, 1);
      final entry = fleet.entries.first;
      expect(entry.agentId, 'ag1');
      expect(entry.role, 'Coder');
      expect(entry.status, 'running');
      expect(entry.tokensTotal, 12000);
      expect(entry.costUsd, 0.08);
      expect(entry.retryCount, 1);

      expect(fleet.summary.running, 1);
      expect(fleet.summary.finished, 2);
      expect(fleet.summary.totalTokens, 12000);
      expect(fleet.summary.totalCostUsd, 0.08);
    });

    test('UsageSummary, UsageMetric, UsageTrendPoint i effectiveCost', () {
      final json = {
        'period': '30d',
        'groupBy': 'model',
        'totals': {
          'key': 'total',
          'label': 'Total',
          'tokensInput': 5000,
          'tokensOutput': 2000,
          'tokensReasoning': 1000,
          'tokensCacheRead': 3000,
          'tokensCacheWrite': 500,
          'tokensTotal': 11500,
          'apiCalls': 25,
          'costUsd': 3.50,
          'sessions': 5,
        },
        'buckets': [
          {
            'key': 'claude-3-7-sonnet',
            'label': 'Claude 3.7 Sonnet',
            'tokensTotal': 8000,
            'costUsd': 2.50,
            'apiCalls': 15,
          },
        ],
        'trend': [
          {'date': '2026-01-01', 'tokensTotal': 4000, 'costUsd': 1.20},
          {'date': '2026-01-02', 'tokensTotal': 7500, 'costUsd': 2.30},
        ],
        'cacheSavingsUsd': 0.85,
        'effectiveCost': {'billedUsd': 3.50, 'listPriceUsd': 5.20, 'subscriptionValueUsd': 10.00},
        'source': 'server',
        'generatedAt': '2026-01-01T00:00:00Z',
      };

      final usage = UsageSummary.fromJson(json);
      expect(usage.period, '30d');
      expect(usage.groupBy, 'model');
      expect(usage.totals.tokensTotal, 11500);
      expect(usage.totals.tokensReasoning, 1000);
      expect(usage.totals.apiCalls, 25);
      expect(usage.totals.costUsd, 3.50);
      expect(usage.buckets.first.key, 'claude-3-7-sonnet');
      expect(usage.trend.length, 2);
      expect(usage.trend.first.date, '2026-01-01');
      expect(usage.cacheSavingsUsd, 0.85);
      expect(usage.billedUsd, 3.50);
      expect(usage.listPriceUsd, 5.20);
      expect(usage.subscriptionValueUsd, 10.00);
    });

    test('AccountHistory i QuotaHistoryPoint', () {
      final json = {
        'accountId': 'acc1',
        'points': [
          {'label': 'Daily', 'percent': 20.0, 'at': '2026-01-01T10:00:00Z'},
          {'label': 'Daily', 'percent': 50.0, 'at': '2026-01-01T14:00:00Z'},
        ],
      };

      final history = AccountHistory.fromJson(json);
      expect(history.accountId, 'acc1');
      expect(history.points.length, 2);
      expect(history.points.first.percent, 20.0);
      expect(history.points.last.percent, 50.0);
      expect(history.points.last.at, '2026-01-01T14:00:00Z');
    });
  });

  group('QuotaController — testy jednostkowe', () {
    late _FakeQuotaRepo repo;
    late ProviderContainer c;

    setUp(() {
      repo = _FakeQuotaRepo();
      c = ProviderContainer(overrides: [quotaRepositoryProvider.overrideWithValue(repo)]);
      c.listen(quotaProvider, (_, _) {});
    });

    tearDown(() => c.dispose());

    QuotaController ctrl() => c.read(quotaProvider.notifier);
    QuotaState state() => c.read(quotaProvider);

    test('load() pobiera równolegle snapshot, config i fleet', () async {
      await ctrl().load();
      expect(repo.calls, contains('snapshot'));
      expect(state().loading, isFalse);
      expect(state().accounts.length, 3);
      expect(state().accounts.first.provider, 'devin');
      expect(state().config!.routingMode, 'ask');
      expect(state().fleet!.summary.running, 1);
      expect(state().error, isNull);
    });

    test('refresh() wymusza odczyt providerów i aktualizuje snapshot', () async {
      await ctrl().load();
      repo.calls.clear();
      final ok = await ctrl().refresh();
      expect(ok, isTrue);
      expect(repo.calls, contains('refresh'));
      expect(state().refreshing, isFalse);
      expect(state().error, isNull);
    });

    test('refresh() przy błędzie API zapisuje error i resetuje refreshing', () async {
      await ctrl().load();
      repo.refreshError = const ServerError('Refresh failed', 500);
      final ok = await ctrl().refresh();
      expect(ok, isFalse);
      expect(state().refreshing, isFalse);
      expect(state().error, 'Refresh failed');
    });

    test('loadSnapshot przy błędzie API ustawia error w stanie', () async {
      repo.snapshotError = const ServerError('Snapshot unreachable', 503);
      await ctrl().load();
      expect(state().loading, isFalse);
      expect(state().error, 'Snapshot unreachable');
    });

    test('loadHistory() cachuje serie i force=true wymusza odpytanie', () async {
      final h1 = await ctrl().loadHistory('devin');
      expect(h1, isNotNull);
      expect(h1!.points.length, 3);
      expect(repo.calls.where((c) => c == 'history:devin').length, 1);

      // Drugie wywołanie z pamięci podręcznej
      final h2 = await ctrl().loadHistory('devin');
      expect(h2!.points.length, 3);
      expect(repo.calls.where((c) => c == 'history:devin').length, 1);

      // force: true omija cache
      await ctrl().loadHistory('devin', force: true);
      expect(repo.calls.where((c) => c == 'history:devin').length, 2);
    });

    test('loadHistory() błąd ustawia error i zwraca null', () async {
      repo.opError = const ServerError('History not found', 404);
      final res = await ctrl().loadHistory('devin');
      expect(res, isNull);
      expect(state().error, 'History not found');
    });

    test('saveConfig() zapisuje nową konfigurację i aktualizuje stan', () async {
      await ctrl().load();
      final updated = QuotaConfig.fromJson(const {
        'routingMode': 'auto-low-risk',
        'alertsEnabled': false,
      });
      final ok = await ctrl().saveConfig(updated);
      expect(ok, isTrue);
      expect(repo.calls, contains('saveConfig:auto-low-risk'));
      expect(state().config!.routingMode, 'auto-low-risk');
      expect(state().config!.alertsEnabled, isFalse);
      expect(state().savingConfig, isFalse);
    });

    test('saveConfig() błąd API ustawia error i resetuje savingConfig', () async {
      await ctrl().load();
      repo.opError = const ServerError('Forbidden', 403);
      final ok = await ctrl().saveConfig(const QuotaConfig());
      expect(ok, isFalse);
      expect(state().savingConfig, isFalse);
      expect(state().error, 'Forbidden');
    });

    test('clearError() czyści pole błędu', () async {
      await ctrl().load();
      repo.opError = const ServerError('Test error', 400);
      await ctrl().saveConfig(const QuotaConfig());
      expect(state().error, 'Test error');
      ctrl().clearError();
      expect(state().error, isNull);
    });
  });

  group('UsageChartController — testy jednostkowe', () {
    late _FakeQuotaRepo repo;
    late ProviderContainer c;

    setUp(() {
      repo = _FakeQuotaRepo();
      c = ProviderContainer(overrides: [quotaRepositoryProvider.overrideWithValue(repo)]);
      c.listen(usageChartProvider, (_, _) {});
    });

    tearDown(() => c.dispose());

    UsageChartController ctrl() => c.read(usageChartProvider.notifier);
    UsageChartState state() => c.read(usageChartProvider);

    test('load() pobiera dane z domyślnym period i groupBy', () async {
      await ctrl().load();
      expect(state().loading, isFalse);
      expect(state().summary, isNotNull);
      expect(state().summary!.totals.tokensTotal, 1000);
      expect(state().summary!.buckets.first.key, 'devin');
      expect(state().summary!.listPriceUsd, 2.0);
    });

    test('setPeriod() i setGroupBy() aktualizują filtry i refetchują', () async {
      await ctrl().load();
      ctrl().setPeriod('30d');
      await Future<void>.delayed(Duration.zero);
      expect(state().period, '30d');
      expect(repo.calls, contains('usage:30d:provider'));

      ctrl().setGroupBy('model');
      await Future<void>.delayed(Duration.zero);
      expect(state().groupBy, 'model');
      expect(repo.calls, contains('usage:30d:model'));

      // Niepoprawne wartości są ignorowane
      ctrl().setPeriod('invalid');
      expect(state().period, '30d');
      ctrl().setGroupBy('invalid');
      expect(state().groupBy, 'model');
    });

    test('load() błąd API ustawia error i resetuje loading', () async {
      repo.usageError = const ServerError('Usage service down', 503);
      await ctrl().load();
      expect(state().loading, isFalse);
      expect(state().error, 'Usage service down');

      ctrl().clearError();
      expect(state().error, isNull);
    });
  });

  group('QuotaScreen — testy widgetowe', () {
    testWidgets('native subscription accounts render and support provider filtering', (t) async {
      final repo = _FakeQuotaRepo();
      repo.snapshotJson = {
        'accounts': [
          for (final provider in ['codex', 'claude'])
            {
              'id': provider,
              'provider': provider,
              'providerLabel': provider == 'codex' ? 'Codex' : 'Claude Code',
              'plan': provider == 'codex' ? 'ChatGPT plus' : 'Claude max',
              'status': 'active',
              'quality': 'live',
              'windows': [
                {'label': '5h', 'kind': 'session', 'percent': 25},
                {'label': 'Weekly', 'kind': 'weekly', 'percent': 75},
              ],
            },
        ],
      };
      await _pumpScreen(t, repo);
      await _switchNav(t, 'Quotas');
      expect(find.text('Codex'), findsOneWidget);
      expect(find.text('Claude Code'), findsOneWidget);
      expect(find.text('ChatGPT plus'), findsOneWidget);
      expect(find.text('Claude max'), findsOneWidget);
      await t.tap(find.text('codex'));
      await t.pumpAndSettle();
      expect(find.text('Codex'), findsOneWidget);
      expect(find.text('Claude Code'), findsNothing);
      await t.tap(find.text('History').first);
      await t.pumpAndSettle();
      expect(repo.calls, contains('history:codex'));
    });

    testWidgets('karty kont: provider, plan, window, agenci oraz gating subskrypcyjny', (t) async {
      final repo = _FakeQuotaRepo();
      await _pumpScreen(t, repo);
      await _switchNav(t, 'Quotas');

      // Karta konta aktywnego
      expect(find.text('Devin / Main'), findsOneWidget);
      expect(find.text('Team'), findsOneWidget);
      expect(find.text('62.5%'), findsOneWidget);
      expect(find.text('a1 · Builder'), findsOneWidget);

      // Gating subskrypcyjny: konto inactive
      expect(find.text('GitHub Copilot'), findsOneWidget);
      expect(find.text('NO SUBSCRIPTION'), findsOneWidget);
      expect(find.text('The provider reports no active plan for this account.'), findsOneWidget);

      // Konto ze statusem error
      expect(find.text('Gemini'), findsOneWidget);
      expect(find.text('Sync error with provider'), findsOneWidget);
    });

    testWidgets('historia konta: kliknięcie History rozwija odczyty', (t) async {
      final repo = _FakeQuotaRepo();
      await _pumpScreen(t, repo);
      await _switchNav(t, 'Quotas');

      await t.tap(find.text('History').first);
      await t.pumpAndSettle();
      expect(find.text('3 readings recorded'), findsOneWidget);
      expect(repo.calls, contains('history:devin'));
    });

    testWidgets('filtry dostawców: kliknięcie chipa zawęża widoczne karty', (t) async {
      final repo = _FakeQuotaRepo();
      await _pumpScreen(t, repo);
      await _switchNav(t, 'Quotas');

      // Klikamy filtr 'gemini'
      await t.tap(find.text('gemini'));
      await t.pumpAndSettle();
      expect(find.text('Devin / Main'), findsNothing);
      expect(find.text('Gemini'), findsOneWidget);

      // Reset filtra z powrotem
      await t.tap(find.text('All'));
      await t.pumpAndSettle();
      expect(find.text('Devin / Main'), findsOneWidget);
      expect(find.text('Gemini'), findsOneWidget);
    });

    testWidgets('wykresy i panel Usage: daily trend, breakdown tabela i filtry period/groupBy', (
      t,
    ) async {
      final repo = _FakeQuotaRepo();
      await _pumpScreen(t, repo);

      await _switchNav(t, 'Usage');
      expect(find.text('Daily trend'), findsOneWidget);
      expect(find.text('Breakdown by Provider'), findsOneWidget);
      expect(find.text('4'), findsWidgets); // apiCalls

      // Zmiana okresu na 30d
      await t.tap(find.text('30 days').last);
      await t.pumpAndSettle();
      expect(repo.calls, contains('usage:30d:provider'));

      // Zmiana grupowania na model
      await t.tap(find.text('Model'));
      await t.pumpAndSettle();
      expect(repo.calls, contains('usage:30d:model'));
    });

    testWidgets('flota agentów: summary, filtr statusu i ekspansja szczegółów', (t) async {
      final repo = _FakeQuotaRepo();
      await _pumpScreen(t, repo);

      await _switchNav(t, 'Agents');
      expect(find.text('1 running'), findsWidgets);
      expect(find.text('a1'), findsOneWidget);
      expect(find.text('a2'), findsOneWidget);

      // Filtr na 'failed (1)'
      await t.tap(find.text('Failed (1)'));
      await t.pumpAndSettle();
      expect(find.text('a1'), findsNothing);
      expect(find.text('a2'), findsOneWidget);

      // Rozwinięcie szczegółów agenta a2
      await t.tap(find.text('a2'));
      await t.pumpAndSettle();
      expect(find.text('Result'), findsOneWidget);
      expect(find.text('Timed out'), findsOneWidget);
    });

    testWidgets('edycja i zapis konfiguracji pollera przez saveConfig', (t) async {
      final repo = _FakeQuotaRepo();
      await _pumpScreen(t, repo);

      await _switchNav(t, 'Config');
      expect(find.text('Poller & alerts'), findsOneWidget);

      // Wybór trybu auto-low-risk
      await t.tap(find.text('Auto-switch for low-risk tasks'));
      await t.pumpAndSettle();

      // Zapis
      await t.tap(find.text('Save config'));
      await t.pumpAndSettle();
      expect(repo.calls, contains('saveConfig:auto-low-risk'));
    });

    testWidgets('przycisk Sync now wywołuje refresh()', (t) async {
      final repo = _FakeQuotaRepo();
      await _pumpScreen(t, repo);

      await t.tap(find.text('Sync now'));
      await t.pump();
      expect(repo.calls, contains('refresh'));
    });

    testWidgets('motyw dark i mały viewport (360x640) renderuje bez overflow', (t) async {
      t.view.physicalSize = const Size(360, 640);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);

      final repo = _FakeQuotaRepo();
      await t.pumpWidget(_buildApp(repo, dark: true));
      await t.pumpAndSettle();

      expect(find.text('AI Control Center'), findsOneWidget);
      expect(find.text('Limits at risk'), findsOneWidget);
      await _switchNav(t, 'Quotas');
      expect(find.text('Devin / Main'), findsOneWidget);
      expect(t.takeException(), isNull);
    });
  });

  group('QuotaScreen — overview', () {
    Future<void> pumpOverview(WidgetTester t, _FakeQuotaRepo repo) async {
      t.view.physicalSize = const Size(1000, 2400);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      await _pumpScreen(t, repo);
    }

    testWidgets('KPI cards, limity kont, aktywne zadania i puste alerty', (t) async {
      await pumpOverview(t, _FakeQuotaRepo());

      // 4 KPIs
      expect(find.text('Limits at risk'), findsOneWidget);
      expect(find.text('Active agents'), findsOneWidget);
      // 'Tokens' also labels the chart's metric toggle.
      expect(find.text('Tokens'), findsWidgets);
      expect(find.text('Estimated cost'), findsOneWidget);
      expect(find.text('accounts over 70%'), findsOneWidget);
      expect(find.text('0 waiting · 0 queued'), findsOneWidget);
      expect(find.text('1.0K'), findsOneWidget);
      expect(find.text('3 sessions'), findsOneWidget);
      expect(find.text('\$1.50'), findsOneWidget);
      expect(find.text('\$5.00 covered by plans'), findsOneWidget);

      // Usage and limits
      expect(find.text('Usage and limits'), findsOneWidget);
      expect(find.textContaining('Devin · Main'), findsOneWidget);
      // 62.5% → toStringAsFixed(0); VM rounding gives '62'.
      expect(find.textContaining(RegExp(r'6[23]%')), findsOneWidget);
      expect(find.text('Error'), findsOneWidget);
      expect(find.text('No subscription'), findsOneWidget);

      // Active tasks
      expect(find.text('Active tasks'), findsOneWidget);
      expect(find.text('Ship quota UI'), findsOneWidget);
      expect(find.text('1 min'), findsOneWidget);

      // Trend + alerts
      expect(find.text('Tokens and cost'), findsOneWidget);
      expect(find.text('Alerts'), findsOneWidget);
      expect(find.text('Nothing needs attention right now.'), findsOneWidget);
    });

    testWidgets('KPI nawiguje do Quotas i Agents', (t) async {
      await pumpOverview(t, _FakeQuotaRepo());

      await t.tap(find.text('Limits at risk'));
      await t.pumpAndSettle();
      expect(find.text('Devin / Main'), findsOneWidget);

      await _switchNav(t, 'Overview');
      await t.tap(find.text('Active agents'));
      await t.pumpAndSettle();
      expect(find.text('1 running'), findsWidgets);
      expect(find.text('a2'), findsOneWidget);
    });

    testWidgets('alerty: pace (eta) i okno powyżej progu watch', (t) async {
      final repo = _FakeQuotaRepo()
        ..snapshotJson = {
          'overview': {'accountsAtRisk': 1, 'watchThreshold': 70},
          'accounts': [
            {
              'id': 'devin',
              'provider': 'devin',
              'providerLabel': 'Devin',
              'status': 'active',
              'windows': [
                {'label': 'Weekly', 'kind': 'weekly', 'percent': 80},
                {
                  'label': 'Session',
                  'kind': 'session',
                  'percent': 40,
                  'etaSeconds': 3600,
                  'projectedExhaustionAt': DateTime.now()
                      .add(const Duration(hours: 1))
                      .toIso8601String(),
                },
              ],
            },
          ],
          'generatedAt': '2026-01-01T00:00:00Z',
        };
      await pumpOverview(t, repo);

      expect(find.textContaining('Devin · Weekly: 80% used (threshold 70%)'), findsOneWidget);
      expect(
        find.textContaining('Devin · Session: at the current pace the limit runs out in'),
        findsOneWidget,
      );
      // worst window is the 80% one — resetsAt is null → '—'.
      expect(find.text('80% · —'), findsOneWidget);
    });

    testWidgets('puste konta i brak agentów renderują empty states', (t) async {
      final repo = _FakeQuotaRepo()
        ..snapshotJson = {
          'overview': {'accountsAtRisk': 0},
          'accounts': const <dynamic>[],
          'generatedAt': '2026-01-01T00:00:00Z',
        }
        ..agentsJson = {
          'entries': const <dynamic>[],
          'summary': {'running': 0},
          'generatedAt': '2026-01-01T00:00:00Z',
        };
      await pumpOverview(t, repo);

      expect(find.text('No accounts connected'), findsOneWidget);
      expect(find.text('No agents are running right now.'), findsOneWidget);
    });
  });
}
