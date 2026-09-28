import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/scheduler/data/scheduler_models.dart';
import 'package:ddagent_app/features/scheduler/data/scheduler_repository.dart';
import 'package:ddagent_app/features/scheduler/state/scheduler_controller.dart';
import 'package:ddagent_app/features/scheduler/view/scheduler_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _FakeSchedulerRepo extends SchedulerRepository {
  _FakeSchedulerRepo() : super(Dio());

  final calls = <String>[];
  Object? opError;

  List<Map<String, dynamic>> jobsList = [
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

  Map<String, List<Map<String, dynamic>>> runsMap = {
    'j1': [
      {
        'id': 'r1',
        'scheduleId': 'j1',
        'sessionId': 'sess1234abcd',
        'status': 'completed',
        'startedAt': '2026-01-01T09:00:00Z',
        'finishedAt': '2026-01-01T09:02:30Z',
      },
      {
        'id': 'r2',
        'scheduleId': 'j1',
        'status': 'failed',
        'error': 'provider quota exceeded',
        'startedAt': '2026-01-02T09:00:00Z',
      },
    ],
  };

  @override
  Future<List<Map<String, dynamic>>> list() async {
    if (opError != null) throw opError!;
    calls.add('list');
    return jobsList;
  }

  @override
  Future<Map<String, dynamic>> preview(String cron) async {
    if (opError != null) throw opError!;
    if (cron.contains('99')) {
      throw const ServerError('CRON_INVALID', 400);
    }
    calls.add('preview:$cron');
    return {'cron': cron, 'nextRunAt': '2026-01-05T09:00:00Z'};
  }

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> body) async {
    if (opError != null) throw opError!;
    calls.add('create:${body['prompt'] ?? body['cron']}');
    final newJob = {
      'id': 'j_${calls.length}',
      'projectId': body['projectId'] ?? 'p1',
      'provider': body['provider'] ?? 'claude',
      'cron': body['cron'] ?? '',
      'prompt': body['prompt'] ?? '',
      'enabled': body['enabled'] ?? true,
      'useWorktree': body['useWorktree'] ?? false,
      'catchUp': body['catchUp'] ?? false,
    };
    jobsList = [...jobsList, newJob];
    return {'schedule': newJob};
  }

  @override
  Future<Map<String, dynamic>> update(
    String id,
    Map<String, dynamic> body,
  ) async {
    if (opError != null) throw opError!;
    calls.add('update:$id:${body['enabled'] ?? body['prompt'] ?? 'x'}');
    jobsList = [
      for (final j in jobsList)
        if (j['id'] == id) {...j, ...body} else j,
    ];
    return {'schedule': {'id': id, ...body}};
  }

  @override
  Future<void> delete(String id) async {
    if (opError != null) throw opError!;
    calls.add('delete:$id');
    jobsList = jobsList.where((j) => j['id'] != id).toList();
  }

  @override
  Future<Map<String, dynamic>> runNow(String id) async {
    if (opError != null) throw opError!;
    calls.add('runNow:$id');
    final newSessionId = 'sess_run_${calls.length}';
    final newRun = {
      'id': 'run_${calls.length}',
      'scheduleId': id,
      'sessionId': newSessionId,
      'status': 'fired',
      'startedAt': '2026-01-05T10:00:00Z',
    };
    runsMap = {
      ...runsMap,
      id: [newRun, ...(runsMap[id] ?? const [])],
    };
    return {'schedule': {'id': id}, 'run': newRun};
  }

  @override
  Future<List<Map<String, dynamic>>> runs(String id) async {
    if (opError != null) throw opError!;
    calls.add('runs:$id');
    return runsMap[id] ?? const [];
  }
}

class _FakeProjectsRepo extends ProjectsRepository {
  _FakeProjectsRepo() : super(Dio());

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

Widget _buildTestApp({
  required _FakeSchedulerRepo schedulerRepo,
  bool dark = false,
  GoRouter? customRouter,
}) {
  final router = customRouter ??
      GoRouter(
        initialLocation: '/scheduler',
        routes: [
          GoRoute(
            path: '/scheduler',
            builder: (_, _) => const SchedulerScreen(),
          ),
        ],
      );

  return ProviderScope(
    overrides: [
      schedulerRepositoryProvider.overrideWithValue(schedulerRepo),
      projectsRepositoryProvider.overrideWithValue(_FakeProjectsRepo()),
      chatChannelProvider.overrideWithValue(
        ChatChannel(WsClient(urlBuilder: () async => Uri.parse('ws://dummy'))),
      ),
    ],
    child: MaterialApp.router(
      theme: dark ? AppTheme.dark() : AppTheme.light(),
      routerConfig: router,
    ),
  );
}

void main() {
  group('1. Testy jednostkowe modeli i ich deserializacji', () {
    test('SchedulerJob.fromJson — pełny model, wartości domyślne i copyWith', () {
      final fullJson = {
        'id': 'job_1',
        'projectId': 'project_alpha',
        'provider': 'claude',
        'cron': '0 9 * * 1-5',
        'prompt': 'Review PRs',
        'useWorktree': true,
        'catchUp': true,
        'enabled': true,
        'failCount': 3,
        'lastRunAt': '2026-01-01T09:00:00Z',
        'nextRunAt': '2026-01-02T09:00:00Z',
        'createdAt': '2025-12-01T00:00:00Z',
      };
      final job = SchedulerJob.fromJson(fullJson);
      expect(job.id, 'job_1');
      expect(job.projectId, 'project_alpha');
      expect(job.provider, 'claude');
      expect(job.cron, '0 9 * * 1-5');
      expect(job.prompt, 'Review PRs');
      expect(job.useWorktree, isTrue);
      expect(job.catchUp, isTrue);
      expect(job.enabled, isTrue);
      expect(job.failCount, 3);
      expect(job.lastRunAt, '2026-01-01T09:00:00Z');
      expect(job.nextRunAt, '2026-01-02T09:00:00Z');
      expect(job.createdAt, '2025-12-01T00:00:00Z');

      // Wartości domyślne dla minimalnego jsona
      final minimalJob = SchedulerJob.fromJson({'id': 'j_min'});
      expect(minimalJob.id, 'j_min');
      expect(minimalJob.projectId, '');
      expect(minimalJob.provider, '');
      expect(minimalJob.cron, '');
      expect(minimalJob.prompt, '');
      expect(minimalJob.useWorktree, isFalse);
      expect(minimalJob.catchUp, isFalse);
      expect(minimalJob.enabled, isTrue);
      expect(minimalJob.failCount, 0);
      expect(minimalJob.lastRunAt, isNull);
      expect(minimalJob.nextRunAt, isNull);
      expect(minimalJob.createdAt, isNull);

      // copyWith zmiana enabled oraz nextRunAt
      final toggled = job.copyWith(enabled: false);
      expect(toggled.enabled, isFalse);
      expect(toggled.id, job.id);

      final updatedNext = job.copyWith(nextRunAt: () => '2026-01-03T09:00:00Z');
      expect(updatedNext.nextRunAt, '2026-01-03T09:00:00Z');

      final clearedNext = job.copyWith(nextRunAt: () => null);
      expect(clearedNext.nextRunAt, isNull);
    });

    test('SchedulerRun.fromJson — deserializacja i obsługa pól opcjonalnych', () {
      final runJson = {
        'id': 'run_10',
        'scheduleId': 'job_1',
        'sessionId': 'sess_xyz_789',
        'status': 'completed',
        'error': 'test error',
        'startedAt': '2026-01-01T09:00:00Z',
        'finishedAt': '2026-01-01T09:05:00Z',
      };
      final run = SchedulerRun.fromJson(runJson);
      expect(run.id, 'run_10');
      expect(run.scheduleId, 'job_1');
      expect(run.sessionId, 'sess_xyz_789');
      expect(run.status, 'completed');
      expect(run.error, 'test error');
      expect(run.startedAt, '2026-01-01T09:00:00Z');
      expect(run.finishedAt, '2026-01-01T09:05:00Z');

      final defaultRun = SchedulerRun.fromJson({'id': 'run_min'});
      expect(defaultRun.id, 'run_min');
      expect(defaultRun.scheduleId, '');
      expect(defaultRun.sessionId, isNull);
      expect(defaultRun.status, 'fired');
      expect(defaultRun.error, isNull);
      expect(defaultRun.startedAt, '');
      expect(defaultRun.finishedAt, isNull);
    });

    test('CronPreview.fromJson — deserializacja preview z serwera', () {
      final preview = CronPreview.fromJson({
        'cron': '0 9 * * *',
        'nextRunAt': '2026-01-02T09:00:00Z',
      });
      expect(preview.cron, '0 9 * * *');
      expect(preview.nextRunAt, '2026-01-02T09:00:00Z');

      final emptyPreview = CronPreview.fromJson({});
      expect(emptyPreview.cron, '');
      expect(emptyPreview.nextRunAt, isNull);
    });

    test('validateCron — poprawne i błędne wyrażenia cron', () {
      expect(validateCron('0 9 * * 1-5'), isNull);
      expect(validateCron('*/15 * * * *'), isNull);
      expect(validateCron('0 9 1 jan mon'), isNull);
      expect(validateCron('0 9'), isNotNull);
      expect(validateCron('61 * * * *'), isNotNull);
      expect(validateCron('* 25 * * *'), isNotNull);
      expect(validateCron('*/0 * * * *'), isNotNull);
      expect(validateCron('foo * * * *'), isNotNull);
    });
  });

  group('2. Testy SchedulerController', () {
    late _FakeSchedulerRepo repo;
    late ProviderContainer c;

    setUp(() {
      repo = _FakeSchedulerRepo();
      c = ProviderContainer(
        overrides: [schedulerRepositoryProvider.overrideWithValue(repo)],
      );
      c.listen(schedulerProvider, (_, _) {});
    });

    tearDown(() => c.dispose());

    SchedulerController ctrl() => c.read(schedulerProvider.notifier);
    SchedulerState state() => c.read(schedulerProvider);

    test('refresh ładuje listę jobs', () async {
      await ctrl().refresh();
      expect(state().jobs.length, 2);
      expect(state().jobs.first.nextRunAt, '2026-01-05T09:00:00Z');
      expect(state().jobs.first.enabled, isTrue);
    });

    test('previewCron — debounce do /preview i błędy lokalne bez calla', () async {
      await ctrl().refresh();
      ctrl().previewCron('0 9'); // Błędny lokalnie — brak zapytania do repo
      await Future<void>.delayed(
        SchedulerController.previewDebounce + const Duration(milliseconds: 50),
      );
      expect(state().cronError, isNotNull);
      expect(repo.calls.where((x) => x.startsWith('preview')), isEmpty);

      ctrl().previewCron('0 9 * * 1-5');
      await Future<void>.delayed(
        SchedulerController.previewDebounce + const Duration(milliseconds: 50),
      );
      expect(repo.calls, contains('preview:0 9 * * 1-5'));
      expect(state().cronPreview!.nextRunAt, '2026-01-05T09:00:00Z');
    });

    test('tworzenie z preview crona (createJob)', () async {
      await ctrl().refresh();
      ctrl().previewCron('0 9 * * *');
      await Future<void>.delayed(
        SchedulerController.previewDebounce + const Duration(milliseconds: 50),
      );
      expect(state().cronPreview?.nextRunAt, '2026-01-05T09:00:00Z');

      final success = await ctrl().createJob({
        'cron': state().cronPreview!.cron,
        'prompt': 'morning task',
        'provider': 'claude',
        'projectId': 'p1',
      });
      expect(success, isTrue);
      expect(repo.calls, contains('create:morning task'));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(state().jobs.any((j) => j.prompt == 'morning task'), isTrue);
    });

    test('edycja (updateJob)', () async {
      await ctrl().refresh();
      final success = await ctrl().updateJob('j1', {'prompt': 'new prompt'});
      expect(success, isTrue);
      expect(repo.calls, contains('update:j1:new prompt'));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(state().jobs.firstWhere((j) => j.id == 'j1').prompt, 'new prompt');
    });

    test('usuwanie (deleteJob)', () async {
      await ctrl().refresh();
      expect(state().jobs.any((j) => j.id == 'j2'), isTrue);
      final success = await ctrl().deleteJob('j2');
      expect(success, isTrue);
      expect(repo.calls, contains('delete:j2'));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(state().jobs.any((j) => j.id == 'j2'), isFalse);
    });

    test('toggle aktywności (toggleEnabled)', () async {
      await ctrl().refresh();
      final success = await ctrl().toggleEnabled('j2', true);
      expect(success, isTrue);
      expect(repo.calls, contains('update:j2:true'));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(state().jobs.firstWhere((j) => j.id == 'j2').enabled, isTrue);
    });

    test('wywołanie runNow generujące nową sesję w runs', () async {
      await ctrl().refresh();
      expect(state().runs['j1'], isNull);

      final ok = await ctrl().runNow('j1');
      expect(ok, isTrue);
      expect(repo.calls, contains('runNow:j1'));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(repo.calls, contains('runs:j1'));

      final runs = state().runs['j1'];
      expect(runs, isNotNull);
      expect(runs!.isNotEmpty, isTrue);
      expect(runs.first.sessionId, startsWith('sess_run_'));
      expect(runs.first.status, 'fired');
    });

    test('loadRuns cachuje historię i force odświeża', () async {
      await ctrl().loadRuns('j1');
      await ctrl().loadRuns('j1');
      expect(repo.calls.where((x) => x == 'runs:j1').length, 1);

      await ctrl().loadRuns('j1', force: true);
      expect(repo.calls.where((x) => x == 'runs:j1').length, 2);
    });

    test('błąd mutacji ustawia error i zwalnia busy', () async {
      await ctrl().refresh();
      repo.opError = const ServerError('Failed operation', 500);
      expect(await ctrl().deleteJob('j1'), isFalse);
      expect(state().busy, isFalse);
      expect(state().error, 'Failed operation');

      ctrl().clearError();
      expect(state().error, isNull);
    });
  });

  group('3. Testy widgetowe ekranu i dialogu Scheduler', () {
    testWidgets('wyświetlanie listy: status, cron, projekt, provider, akcje', (tester) async {
      final repo = _FakeSchedulerRepo();
      await tester.pumpWidget(_buildTestApp(schedulerRepo: repo));
      await tester.pumpAndSettle();

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

    testWidgets('uruchomienie akcji Run Now', (tester) async {
      final repo = _FakeSchedulerRepo();
      await tester.pumpWidget(_buildTestApp(schedulerRepo: repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Run now').first);
      await tester.pumpAndSettle();

      expect(repo.calls, contains('runNow:j1'));
      expect(repo.calls, contains('runs:j1'));

      // Po uruchomieniu run pojawia się w historii
      await tester.tap(find.text('Runs').first);
      await tester.pumpAndSettle();
      expect(find.text('fired'), findsOneWidget);
    });

    testWidgets('dialog z 5 providerami, walidacją crona i tworzeniem zadania', (tester) async {
      final repo = _FakeSchedulerRepo();
      await tester.pumpWidget(_buildTestApp(schedulerRepo: repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('New schedule'));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('New schedule'),
        ),
        findsOneWidget,
      );

      // Sprawdzenie dostępności wszystkich 5 wspieranych providerów
      final providerDropdown = find.byType(DropdownButtonFormField<String>).at(1);
      await tester.tap(providerDropdown);
      await tester.pumpAndSettle();

      expect(find.text('claude'), findsWidgets);
      expect(find.text('codex'), findsWidgets);
      expect(find.text('cursor'), findsWidgets);
      expect(find.text('opencode'), findsWidgets);
      expect(find.text('devin'), findsWidgets);

      // Wybór providera 'devin'
      await tester.tap(find.text('devin').last);
      await tester.pumpAndSettle();

      // Niepoprawny cron — walidacja lokalna blokuje przycisk Create
      await tester.enterText(find.byType(TextField).first, 'bad cron');
      await tester.pump();
      expect(find.textContaining('Expected 5 fields'), findsOneWidget);

      // Poprawny cron i prompt
      await tester.enterText(find.byType(TextField).first, '0 9 * * *');
      await tester.enterText(find.byType(TextField).last, 'morning sync');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      expect(repo.calls, contains('create:morning sync'));
      expect(find.text('morning sync'), findsOneWidget);
    });

    testWidgets('nawigacja do sesji po kliknięciu linku w historii runów', (tester) async {
      String? navigatedLocation;
      final repo = _FakeSchedulerRepo();

      final router = GoRouter(
        initialLocation: '/scheduler',
        routes: [
          GoRoute(
            path: '/scheduler',
            builder: (_, _) => const SchedulerScreen(),
          ),
          GoRoute(
            path: '/chat/:id',
            builder: (_, state) {
              navigatedLocation = state.uri.toString();
              return Scaffold(
                body: Text('ChatView: ${state.pathParameters['id']}'),
              );
            },
          ),
        ],
      );

      await tester.pumpWidget(
        _buildTestApp(
          schedulerRepo: repo,
          customRouter: router,
        ),
      );
      await tester.pumpAndSettle();

      // Otwórz sekcję historii runów pierwszego zadania
      await tester.tap(find.text('Runs').first);
      await tester.pumpAndSettle();

      // Kliknij w sesję sess1234abcd
      final sessionLink = find.byKey(const Key('run-session-r1'));
      expect(sessionLink, findsOneWidget);
      expect(find.textContaining('session sess123'), findsOneWidget);

      await tester.tap(sessionLink);
      await tester.pumpAndSettle();

      expect(navigatedLocation, '/chat/sess1234abcd');
      expect(find.text('ChatView: sess1234abcd'), findsOneWidget);
    });

    testWidgets('dark theme i wąski ekran 360px renderuje się bez overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final repo = _FakeSchedulerRepo();
      await tester.pumpWidget(_buildTestApp(schedulerRepo: repo, dark: true));
      await tester.pumpAndSettle();

      expect(find.text('nightly review'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
