import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/quota/data/quota_models.dart';
import 'package:ddagent_app/features/quota/data/quota_repository.dart';
import 'package:ddagent_app/features/quota/state/quota_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo extends QuotaRepository {
  _FakeRepo() : super(Dio());

  final calls = <String>[];
  Object? opError;

  @override
  Future<Map<String, dynamic>> snapshot() async {
    calls.add('snapshot');
    return {
      'overview': {'accountsAtRisk': 1, 'watchThreshold': 70},
      'accounts': [
        {
          'id': 'devin',
          'provider': 'devin',
          'providerLabel': 'Devin',
          'plan': 'Team',
          'status': 'active',
          'windows': [
            {'label': 'Weekly', 'kind': 'weekly', 'percent': 62.5},
          ],
          'assignedAgents': [
            {'agentId': 'a1', 'role': 'Builder', 'activeTasks': 2},
          ],
        },
        {'id': 'gemini', 'provider': 'gemini', 'status': 'error'},
      ],
      'generatedAt': '2026-01-01T00:00:00Z',
    };
  }

  @override
  Future<Map<String, dynamic>> refresh() async {
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
  Future<List<Map<String, dynamic>>> history(String accountId,
      {int? limit}) async {
    calls.add('history:$accountId');
    return [
      {'label': 'Weekly', 'percent': 40, 'at': '2026-01-01'},
      {'label': 'Weekly', 'percent': 62.5, 'at': '2026-01-02'},
    ];
  }

  @override
  Future<Map<String, dynamic>> usage(
      {required String period, required String groupBy}) async {
    calls.add('usage:$period:$groupBy');
    return {
      'period': period,
      'groupBy': groupBy,
      'totals': {'tokensTotal': 1000, 'costUsd': 1.5, 'sessions': 3},
      'buckets': [
        {'key': 'devin', 'label': 'Devin', 'tokensTotal': 800, 'costUsd': 1.2},
      ],
      'trend': [
        {'date': '2026-01-01', 'tokensTotal': 1000, 'costUsd': 1.5},
      ],
      'cacheSavingsUsd': 0.4,
      'effectiveCost': {'billedUsd': 1.0, 'listPriceUsd': 2.0},
      'source': 'test',
    };
  }

  @override
  Future<Map<String, dynamic>> agents() async => {
        'entries': [
          {
            'agentId': 'a1',
            'role': 'Builder',
            'status': 'running',
            'tokensTotal': 500,
            'costUsd': 0.5,
            'elapsedSeconds': 60,
          },
        ],
        'summary': {'running': 1, 'totalTokens': 500, 'totalCostUsd': 0.5},
        'generatedAt': 'x',
      };
}

void main() {
  late _FakeRepo repo;
  late ProviderContainer c;

  setUp(() {
    repo = _FakeRepo();
    c = ProviderContainer(
      overrides: [quotaRepositoryProvider.overrideWithValue(repo)],
    );
    c.listen(quotaProvider, (_, _) {});
    c.listen(usageChartProvider, (_, _) {});
  });

  tearDown(() => c.dispose());

  QuotaController ctrl() => c.read(quotaProvider.notifier);
  QuotaState state() => c.read(quotaProvider);

  test('modele dekodują snapshot/account/window/fleet/config', () {
    final s = QuotaSnapshot.fromJson({
      'overview': {'accountsAtRisk': 2},
      'accounts': [
        {'id': 'x', 'windows': [{'percent': 10, 'kind': 'daily'}]},
      ],
    });
    expect(s.overview.accountsAtRisk, 2);
    expect(s.accounts.single.windows.single.kind, 'daily');
    final f = FleetSnapshot.fromJson({
      'entries': [{'agentId': 'a', 'status': 'running'}],
      'summary': {'running': 1},
    });
    expect(f.entries.single.agentId, 'a');
    expect(f.summary.running, 1);
    final cfg = QuotaConfig.fromJson({'routingMode': 'ask'});
    expect(cfg.toJson()['routingMode'], 'ask');
  });

  test('load pobiera snapshot, config i fleet równolegle', () async {
    await ctrl().load();
    expect(repo.calls, contains('snapshot'));
    expect(repo.calls, isNot(contains('refresh')));
    expect(state().accounts.length, 2);
    expect(state().accounts.first.windows.single.percent, 62.5);
    expect(state().config!.routingMode, 'ask');
    expect(state().fleet!.summary.running, 1);
  });

  test('refresh() wymusza odczyt i aktualizuje snapshot', () async {
    await ctrl().load();
    repo.calls.clear();
    expect(await ctrl().refresh(), isTrue);
    expect(repo.calls, contains('refresh'));
    expect(state().refreshing, isFalse);
  });

  test('loadHistory cachuje serie per konto', () async {
    final h = await ctrl().loadHistory('devin');
    expect(h!.points.length, 2);
    await ctrl().loadHistory('devin');
    expect(
      repo.calls.where((c) => c == 'history:devin').length,
      1, // cached
    );
  });

  test('saveConfig zapisuje i aktualizuje stan', () async {
    await ctrl().load();
    final cfg = QuotaConfig.fromJson(const {'routingMode': 'auto-low-risk'});
    expect(await ctrl().saveConfig(cfg), isTrue);
    expect(repo.calls, contains('saveConfig:auto-low-risk'));
    expect(state().config!.routingMode, 'auto-low-risk');
  });

  test('błąd saveConfig ustawia error', () async {
    await ctrl().load();
    repo.opError = const ServerError('denied', 403);
    expect(await ctrl().saveConfig(const QuotaConfig()), isFalse);
    expect(state().savingConfig, isFalse);
    expect(state().error, 'denied');
  });

  test('usageChart: load + zmiana period/groupBy refetchuje', () async {
    final uctrl = c.read(usageChartProvider.notifier);
    await uctrl.load();
    final us = c.read(usageChartProvider);
    expect(us.summary!.totals.tokensTotal, 1000);
    expect(us.summary!.buckets.single.key, 'devin');
    expect(us.summary!.listPriceUsd, 2.0);

    uctrl.setPeriod('30d');
    await Future<void>.delayed(Duration.zero);
    uctrl.setGroupBy('model');
    await Future<void>.delayed(Duration.zero);
    expect(repo.calls, contains('usage:30d:provider'));
    expect(repo.calls, contains('usage:30d:model'));
    // Invalid values ignored.
    uctrl.setPeriod('bogus');
    expect(c.read(usageChartProvider).period, '30d');
  });
}
