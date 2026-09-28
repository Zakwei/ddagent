import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/quota/data/quota_repository.dart';
import 'package:ddagent_app/features/quota/view/quota_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _ViewRepo extends QuotaRepository {
  _ViewRepo() : super(Dio());

  final calls = <String>[];

  @override
  Future<Map<String, dynamic>> snapshot() async => {
    'accounts': [
      {
        'id': 'devin',
        'provider': 'devin',
        'providerLabel': 'Devin',
        'plan': 'Team',
        'accountLabel': 'Main',
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
        'id': 'gem',
        'provider': 'gemini',
        'providerLabel': 'Gemini',
        'status': 'error',
      },
    ],
    'generatedAt': DateTime.now().toIso8601String(),
  };

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
  };

  @override
  Future<void> saveConfig(Map<String, dynamic> body) async =>
      calls.add('saveConfig:${body['routingMode']}');

  @override
  Future<List<Map<String, dynamic>>> history(
    String accountId, {
    int? limit,
  }) async {
    calls.add('history:$accountId');
    return [
      {'percent': 40, 'at': 'x'},
      {'percent': 55, 'at': 'y'},
      {'percent': 62, 'at': 'z'},
    ];
  }

  @override
  Future<Map<String, dynamic>> usage({
    required String period,
    required String groupBy,
  }) async {
    calls.add('usage:$period:$groupBy');
    return {
      'totals': {
        'tokensTotal': 1000,
        'costUsd': 1.5,
        'apiCalls': 4,
        'sessions': 2,
      },
      'buckets': [
        {'label': 'Devin', 'tokensTotal': 800, 'costUsd': 1.2, 'apiCalls': 3},
      ],
      'trend': [
        {'date': '2026-01-01', 'tokensTotal': 400},
        {'date': '2026-01-02', 'tokensTotal': 600},
      ],
    };
  }

  @override
  Future<Map<String, dynamic>> agents() async => {
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
      {'agentId': 'a2', 'status': 'failed', 'elapsedSeconds': 30},
    ],
    'summary': {
      'running': 1,
      'failed': 1,
      'totalTokens': 500,
      'totalCostUsd': 0.5,
    },
    'generatedAt': 'x',
  };
}

Widget _app(_ViewRepo repo, {bool dark = false}) => ProviderScope(
  overrides: [quotaRepositoryProvider.overrideWithValue(repo)],
  child: MaterialApp(
    theme: dark ? AppTheme.dark() : AppTheme.light(),
    home: const QuotaScreen(),
  ),
);

Future<void> _pump(WidgetTester t, _ViewRepo repo) async {
  await t.pumpWidget(_app(repo));
  await t.pumpAndSettle();
}

Future<void> _nav(WidgetTester t, String label) async {
  await t.tap(find.text(label).last);
  await t.pumpAndSettle();
}

void main() {
  testWidgets('karty kont: provider, plan, window, historia', (t) async {
    await _pump(t, _ViewRepo());
    expect(find.text('Devin / Main'), findsOneWidget);
    expect(find.text('Team'), findsOneWidget);
    expect(find.text('Gemini'), findsOneWidget);
    expect(find.text('62.5%'), findsOneWidget);
    expect(find.text('a1 · Builder'), findsOneWidget);

    // History expands and loads via cached controller call.
    await t.tap(find.text('History').first);
    await t.pumpAndSettle();
    expect(find.text('3 readings recorded'), findsOneWidget);
  });

  testWidgets('filtr providerów zawęża karty', (t) async {
    await _pump(t, _ViewRepo());
    await t.tap(find.text('gemini'));
    await t.pumpAndSettle();
    expect(find.text('Devin / Main'), findsNothing);
    expect(find.text('Gemini'), findsOneWidget);
  });

  testWidgets('usage: pills period/groupBy + tabela breakdown', (t) async {
    final repo = _ViewRepo();
    await _pump(t, repo);
    await _nav(t, 'Usage');
    expect(find.text('Daily trend'), findsOneWidget);
    expect(find.text('Breakdown by provider'), findsOneWidget);
    expect(find.text('4'), findsWidgets); // apiCalls

    await t.tap(find.text('30d'));
    await t.pumpAndSettle();
    expect(repo.calls, contains('usage:30d:provider'));
    await t.tap(find.text('model'));
    await t.pumpAndSettle();
    expect(repo.calls, contains('usage:30d:model'));
  });

  testWidgets('fleet: summary, filtr statusu, ekspansja szczegółów', (t) async {
    await _pump(t, _ViewRepo());
    await _nav(t, 'Fleet');
    expect(find.text('1 running'), findsWidgets);
    expect(find.text('a1'), findsOneWidget);
    expect(find.text('a2'), findsOneWidget);

    await t.tap(find.text('failed (1)'));
    await t.pumpAndSettle();
    expect(find.text('a1'), findsNothing);
    expect(find.text('a2'), findsOneWidget);

    await t.tap(find.text('a2'));
    await t.pumpAndSettle();
    expect(find.text('Result'), findsOneWidget);
  });

  testWidgets('config: edycja i zapis przez saveConfig', (t) async {
    final repo = _ViewRepo();
    await _pump(t, repo);
    await _nav(t, 'Config');
    expect(find.text('Poller & alerts'), findsOneWidget);

    await t.tap(find.text('auto-low-risk'));
    await t.pumpAndSettle();
    await t.tap(find.text('Save config'));
    await t.pumpAndSettle();
    expect(repo.calls, contains('saveConfig:auto-low-risk'));
  });

  testWidgets('dark theme renderuje bez overflow na wąskim ekranie', (t) async {
    t.view.physicalSize = const Size(360, 640);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    final repo = _ViewRepo();
    await t.pumpWidget(_app(repo, dark: true));
    await t.pumpAndSettle();
    expect(find.text('AI Control Center'), findsOneWidget);
    expect(find.text('Devin / Main'), findsOneWidget);
    expect(t.takeException(), isNull);
  });
}
