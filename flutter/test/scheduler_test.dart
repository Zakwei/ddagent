import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/scheduler/data/scheduler_models.dart';
import 'package:ddagent_app/features/scheduler/data/scheduler_repository.dart';
import 'package:ddagent_app/features/scheduler/state/scheduler_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo extends SchedulerRepository {
  _FakeRepo() : super(Dio());

  final calls = <String>[];
  Object? opError;

  Map<String, dynamic> _ok(String name) {
    if (opError != null) throw opError!;
    calls.add(name);
    return {'data': {'schedule': {'id': 'j1'}}};
  }

  @override
  Future<List<Map<String, dynamic>>> list() async {
    calls.add('list');
    return const [
      {
        'id': 'j1',
        'projectId': 'p1',
        'provider': 'claude',
        'cron': '0 9 * * 1-5',
        'prompt': 'daily',
        'enabled': true,
        'nextRunAt': '2026-01-05T09:00:00Z',
      },
      {'id': 'j2', 'projectId': 'p1', 'cron': '*/15 * * * *', 'enabled': false},
    ];
  }

  @override
  Future<Map<String, dynamic>> preview(String cron) async {
    if (cron.contains('99')) {
      throw const ServerError('CRON_INVALID', 400);
    }
    calls.add('preview:$cron');
    return {'cron': cron, 'nextRunAt': '2026-01-05T09:00:00Z'};
  }

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> body) async =>
      _ok('create:${body['cron']}');

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> body) async =>
      _ok('update:$id:${body['enabled'] ?? 'x'}');

  @override
  Future<void> delete(String id) async {
    if (opError != null) throw opError!;
    calls.add('delete:$id');
  }

  @override
  Future<Map<String, dynamic>> runNow(String id) async => _ok('runNow:$id');

  @override
  Future<List<Map<String, dynamic>>> runs(String id) async {
    calls.add('runs:$id');
    return const [
      {'id': 'r1', 'scheduleId': 'x', 'status': 'completed', 'startedAt': 't'},
    ];
  }
}

void main() {
  test('validateCron — poprawne i błędne wyrażenia', () {
    expect(validateCron('0 9 * * 1-5'), isNull);
    expect(validateCron('*/15 * * * *'), isNull);
    expect(validateCron('0 9 1 jan mon'), isNull);
    expect(validateCron('0 9'), isNotNull);
    expect(validateCron('61 * * * *'), isNotNull);
    expect(validateCron('* 25 * * *'), isNotNull);
    expect(validateCron('*/0 * * * *'), isNotNull);
    expect(validateCron('foo * * * *'), isNotNull);
  });

  group('SchedulerController', () {
    late _FakeRepo repo;
    late ProviderContainer c;

    setUp(() {
      repo = _FakeRepo();
      c = ProviderContainer(
        overrides: [schedulerRepositoryProvider.overrideWithValue(repo)],
      );
      c.listen(schedulerProvider, (_, _) {});
    });

    tearDown(() => c.dispose());

    SchedulerController ctrl() => c.read(schedulerProvider.notifier);
    SchedulerState state() => c.read(schedulerProvider);

    test('refresh ładuje jobs', () async {
      await ctrl().refresh();
      expect(state().jobs.length, 2);
      expect(state().jobs.first.nextRunAt, '2026-01-05T09:00:00Z');
      expect(state().jobs.first.enabled, isTrue);
    });

    test('previewCron — debounce do /preview, błędy lokalne bez calla',
        () async {
      await ctrl().refresh();
      ctrl().previewCron('0 9'); // niepoprawny lokalnie — brak calla
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

    test('CRUD + toggleEnabled + runNow', () async {
      await ctrl().refresh();
      await ctrl().createJob({'cron': '0 8 * * *', 'prompt': 'x'});
      await ctrl().updateJob('j1', {'prompt': 'new'});
      await ctrl().toggleEnabled('j2', true);
      await ctrl().runNow('j1');
      await ctrl().deleteJob('j2');
      expect(
        repo.calls,
        containsAll([
          'create:0 8 * * *',
          'update:j1:x',
          'update:j2:true',
          'runNow:j1',
          'delete:j2',
        ]),
      );
      // runNow odświeża też historię.
      expect(repo.calls, contains('runs:j1'));
    });

    test('loadRuns cachuje historię', () async {
      await ctrl().loadRuns('j1');
      await ctrl().loadRuns('j1');
      expect(repo.calls.where((x) => x == 'runs:j1').length, 1);
      expect(state().runs['j1']!.single.status, 'completed');
    });

    test('błąd mutacji ustawia error i zwalnia busy', () async {
      await ctrl().refresh();
      repo.opError = const ServerError('nope', 500);
      expect(await ctrl().deleteJob('j1'), isFalse);
      expect(state().busy, isFalse);
      expect(state().error, 'nope');
    });
  });
}
