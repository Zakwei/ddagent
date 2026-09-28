import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/scheduler/data/scheduler_repository.dart';
import 'package:ddagent_app/features/scheduler/view/scheduler_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repo extends SchedulerRepository {
  _Repo() : super(Dio());

  final calls = <String>[];
  List<Map<String, dynamic>> Function(String id)? runsFor;

  @override
  Future<List<Map<String, dynamic>>> list() async => const [
    {
      'id': 'j1',
      'projectId': 'p1',
      'provider': 'claude',
      'cron': '0 9 * * 1-5',
      'prompt': 'nightly review',
      'enabled': true,
      'useWorktree': true,
      'nextRunAt': '2026-01-05T09:00:00Z',
    },
    {
      'id': 'j2',
      'projectId': 'p1',
      'provider': 'devin',
      'cron': '*/15 * * * *',
      'prompt': 'poll',
      'enabled': false,
      'failCount': 2,
    },
  ];

  @override
  Future<Map<String, dynamic>> preview(String cron) async {
    calls.add('preview:$cron');
    return {'cron': cron, 'nextRunAt': '2026-01-05T09:00:00Z'};
  }

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> body) async {
    calls.add('create:${body['prompt']}');
    return {};
  }

  @override
  Future<Map<String, dynamic>> update(
    String id,
    Map<String, dynamic> body,
  ) async {
    calls.add('update:$id:${body['enabled'] ?? body['prompt'] ?? 'x'}');
    return {};
  }

  @override
  Future<void> delete(String id) async => calls.add('delete:$id');

  @override
  Future<Map<String, dynamic>> runNow(String id) async {
    calls.add('runNow:$id');
    return {};
  }

  @override
  Future<List<Map<String, dynamic>>> runs(String id) async {
    calls.add('runs:$id');
    return runsFor?.call(id) ??
        const [
          {
            'id': 'r1',
            'status': 'completed',
            'sessionId': 'sess1234abcd',
            'startedAt': '2026-01-01T09:00:00Z',
            'finishedAt': '2026-01-01T09:02:30Z',
          },
          {
            'id': 'r2',
            'status': 'failed',
            'error': 'provider quota exceeded',
            'startedAt': '2026-01-02T09:00:00Z',
          },
        ];
  }
}

class _Projects extends ProjectsRepository {
  _Projects() : super(Dio());

  @override
  Future<List<Project>> list({
    bool skipSync = false,
    int? sessionsLimit,
    int? sessionsOffset,
  }) async => [
    const Project(
      projectId: 'p1',
      path: '/w/p1',
      displayName: 'Demo app',
      sessionMeta: SessionMeta(total: 0),
    ),
  ];

  @override
  Future<List<Project>> archived() async => [];
}

Widget _app(_Repo repo, {bool dark = false}) => ProviderScope(
  overrides: [
    schedulerRepositoryProvider.overrideWithValue(repo),
    projectsRepositoryProvider.overrideWithValue(_Projects()),
    chatChannelProvider.overrideWithValue(
      ChatChannel(WsClient(urlBuilder: () async => Uri.parse('ws://t'))),
    ),
  ],
  child: MaterialApp(
    theme: dark ? AppTheme.dark() : AppTheme.light(),
    home: const SchedulerScreen(),
  ),
);

Future<void> _pump(WidgetTester t, _Repo repo) async {
  await t.pumpWidget(_app(repo));
  await t.pumpAndSettle();
}

void main() {
  testWidgets('lista: status, cron, projekt, provider, akcje', (t) async {
    await _pump(t, _Repo());
    expect(find.text('Schedules'), findsOneWidget);
    expect(find.text('nightly review'), findsOneWidget);
    expect(find.text('0 9 * * 1-5'), findsOneWidget);
    expect(find.text('Demo app'), findsWidgets);
    expect(find.text('claude'), findsOneWidget);
    expect(find.text('worktree'), findsOneWidget);
    expect(find.text('disabled'), findsOneWidget);
    expect(find.text('2 failures'), findsOneWidget);
    expect(find.text('Run now'), findsNWidgets(2));
    expect(find.byType(Switch), findsNWidgets(2));
  });

  testWidgets('toggle + run now + delete', (t) async {
    final repo = _Repo();
    await _pump(t, repo);

    await t.tap(find.byType(Switch).last);
    await t.pumpAndSettle();
    expect(repo.calls, contains('update:j2:true'));

    await t.tap(find.text('Run now').first);
    await t.pumpAndSettle();
    expect(repo.calls, contains('runNow:j1'));
    expect(repo.calls, contains('runs:j1'));

    await t.tap(find.byIcon(Icons.delete_outline).first);
    await t.pumpAndSettle();
    await t.tap(find.text('Delete').last);
    await t.pumpAndSettle();
    expect(repo.calls, contains('delete:j1'));
  });

  testWidgets('historia runów: status, czas, sesja, błąd', (t) async {
    await _pump(t, _Repo());
    await t.tap(find.text('Runs').first);
    await t.pumpAndSettle();
    expect(find.text('completed'), findsOneWidget);
    expect(find.text('failed'), findsOneWidget);
    expect(find.textContaining('session sess123'), findsOneWidget);
    expect(find.text('provider quota exceeded'), findsOneWidget);
    expect(find.text('3 min'), findsOneWidget);
  });

  testWidgets('dialog: walidacja crona i create', (t) async {
    final repo = _Repo();
    await _pump(t, repo);
    await t.tap(find.text('New schedule'));
    await t.pumpAndSettle();

    // Invalid cron → local error, no server preview call, disabled create.
    await t.enterText(find.byType(TextField).first, 'bad cron');
    await t.pump();
    expect(find.textContaining('Expected 5 fields'), findsOneWidget);
    expect(repo.calls.where((c) => c.startsWith('preview')), isEmpty);

    await t.enterText(find.byType(TextField).first, '0 9 * * *');
    await t.enterText(find.byType(TextField).last, 'morning sync');
    await t.pumpAndSettle();
    await t.tap(find.text('Create'));
    await t.pumpAndSettle();
    expect(repo.calls, contains('create:morning sync'));
  });

  testWidgets('dark theme + wąski ekran bez overflow', (t) async {
    t.view.physicalSize = const Size(360, 640);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(_app(_Repo(), dark: true));
    await t.pumpAndSettle();
    expect(find.text('nightly review'), findsOneWidget);
    expect(t.takeException(), isNull);
  });
}
