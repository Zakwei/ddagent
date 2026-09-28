import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_models.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_repository.dart';
import 'package:ddagent_app/features/taskmaster/state/taskmaster_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeChatChannel extends ChatChannel {
  _FakeChatChannel()
      : super(WsClient(urlBuilder: () async => Uri.parse('ws://t')));

  final _controller = StreamController<ServerEvent>.broadcast();

  @override
  Stream<ServerEvent> get events => _controller.stream;

  void emit(Map<String, dynamic> raw) =>
      _controller.add(ServerEvent(raw: raw));

  @override
  Future<void> close() async => _controller.close();
}

class _FakeRepo extends TaskmasterRepository {
  _FakeRepo() : super(Dio());

  final calls = <String>[];
  List<Map<String, dynamic>> taskRows = [
    {'id': 1, 'title': 'Setup', 'status': 'done', 'priority': 'high'},
    {
      'id': 2,
      'title': 'Build UI',
      'description': 'make it',
      'status': 'pending',
      'priority': 'medium',
      'dependencies': [1],
    },
    {
      'id': 3,
      'title': 'Polish',
      'status': 'pending',
      'priority': 'high',
      'dependencies': [2],
    },
    {'id': 4, 'title': 'Blocked', 'status': 'pending', 'dependencies': [9]},
  ];
  Object? opError;

  Map<String, dynamic> _ok(String name, [Map<String, dynamic>? extra]) {
    if (opError != null) throw opError!;
    calls.add(name);
    return {'success': true, ...?extra};
  }

  @override
  Future<Map<String, dynamic>> installationStatus() async => const {
        'success': true,
        'installation': {'isInstalled': true, 'version': 'native'},
        'mcpServer': {'hasMCPServer': false},
        'isReady': true,
      };

  @override
  Future<Map<String, dynamic>> tasks(String projectId) async {
    calls.add('tasks:$projectId');
    return {
        'projectId': projectId,
        'tasks': taskRows,
        'currentTag': 'master',
        'totalTasks': taskRows.length,
        'tasksByStatus': const {'pending': 3, 'done': 1},
      };
  }

  @override
  Future<List<Map<String, dynamic>>> prdList(String projectId) async =>
      const [{'fileName': 'prd.md'}];

  @override
  Future<List<Map<String, dynamic>>> prdTemplates() async =>
      const [{'id': 'default', 'name': 'Default'}];

  @override
  Future<Map<String, dynamic>> prdFile(String p, String f) async =>
      _ok('prdFile:$f', {'content': '# PRD'});

  @override
  Future<Map<String, dynamic>> createPrd(
          String p, Map<String, dynamic> body) async =>
      _ok('createPrd:${body['fileName']}');

  @override
  Future<void> init(String p) async => _ok('init');

  @override
  Future<Map<String, dynamic>> addTask(
          String p, Map<String, dynamic> body) async =>
      _ok('add:${body['title']}');

  @override
  Future<void> updateTask(
      String p, String id, Map<String, dynamic> updates) async {
    _ok('update:$id:${updates['status'] ?? 'fields'}');
    taskRows = [
      for (final t in taskRows)
        if ('${t['id']}' == id) {...t, ...updates} else t,
    ];
  }

  @override
  Future<void> deleteTask(String p, String id) async {
    _ok('delete:$id');
    taskRows = taskRows.where((t) => '${t['id']}' != id).toList();
  }

  @override
  Future<Map<String, dynamic>> parsePrd(
    String p, {
    String? fileName,
    int? numTasks,
    bool? append,
  }) async =>
      _ok('parse:$fileName');
}

void main() {
  late _FakeRepo repo;
  late _FakeChatChannel channel;
  late ProviderContainer c;

  setUp(() {
    repo = _FakeRepo();
    channel = _FakeChatChannel();
    c = ProviderContainer(
      overrides: [
        taskmasterRepositoryProvider.overrideWithValue(repo),
        chatChannelProvider.overrideWithValue(channel),
      ],
    );
    c.listen(taskmasterProvider, (_, _) {});
  });

  tearDown(() => c.dispose());

  TaskmasterController ctrl() => c.read(taskmasterProvider.notifier);
  TaskmasterState state() => c.read(taskmasterProvider);

  test('Model TaskmasterTask toleruje warianty tasks.json', () {
    final t = TaskmasterTask.fromJson({
      'id': 7,
      'title': 'T',
      'test_strategy': 'run it',
      'dependencies': [1, 'x'],
      'subtasks': [{'id': 1, 'title': 'sub'}],
    });
    expect(t.status, 'pending');
    expect(t.testStrategy, 'run it');
    expect(t.subtasks.single.title, 'sub');
    expect(t.idText, '7');
  });

  test('TaskmasterStatus dekoduje format tagged', () {
    final s = TaskmasterStatus.fromJson({
      'master': {'tasks': [{'id': 1, 'title': 'A'}]},
    });
    expect(s.tasks.single.title, 'A');
  });

  test('load pobiera config, tasks, prd i szablony', () async {
    await ctrl().load('p1');
    await Future<void>.delayed(Duration.zero);
    expect(state().isReady, isTrue);
    expect(state().tasks.length, 4);
    expect(state().tasksByStatus['pending'], 3);
    await Future<void>.delayed(Duration.zero);
    expect(state().prdFiles.single.fileName, 'prd.md');
    expect(state().prdTemplates.single.name, 'Default');
  });

  test('filtrowanie status/priority/search i sort priority', () async {
    await ctrl().load('p1');
    ctrl().setStatusFilter('pending');
    expect(state().filteredTasks.length, 3);
    ctrl().setPriorityFilter('high');
    expect(state().filteredTasks.single.title, 'Polish');
    ctrl().setPriorityFilter(null);
    ctrl().setSearchQuery('blocked');
    expect(state().filteredTasks.single.idText, '4');
    ctrl().setSearchQuery('');
    ctrl().setSort(TaskSort.priority);
    expect(state().filteredTasks.first.title, 'Polish');
  });

  test('nextTask — pierwszy pending ze spełnionymi deps', () async {
    await ctrl().load('p1');
    expect(state().nextTask!.title, 'Build UI'); // dep 1 done
  });

  test('CRUD i updateTask odświeża listę', () async {
    await ctrl().load('p1');
    await ctrl().createTask({'title': 'New'});
    expect(repo.calls, contains('add:New'));
    await ctrl().updateTask('2', {'status': 'in-progress'});
    expect(repo.calls, contains('update:2:in-progress'));
    await ctrl().deleteTask('2');
    expect(repo.calls, contains('delete:2'));
  });

  test('parsePrd i init', () async {
    await ctrl().load('p1');
    await ctrl().parsePrd(fileName: 'prd.md');
    expect(repo.calls, contains('parse:prd.md'));
    await ctrl().init();
    expect(repo.calls, contains('init'));
  });

  test('WS taskmaster-tasks-updated dla własnego projektu refetchuje', () async {
    await ctrl().load('p1');
    final before = repo.calls.where((c) => c.startsWith('tasks')).length;
    channel.emit({'type': 'taskmaster-tasks-updated', 'projectId': 'p1'});
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(
      repo.calls.where((c) => c.startsWith('tasks')).length,
      greaterThan(before),
    );
  });

  test('WS z innego projektu jest ignorowany', () async {
    await ctrl().load('p1');
    await Future<void>.delayed(Duration.zero);
    repo.calls.clear();
    channel.emit({'type': 'taskmaster-tasks-updated', 'projectId': 'p2'});
    await Future<void>.delayed(Duration.zero);
    expect(repo.calls.where((c) => c.startsWith('tasks')), isEmpty);
  });

  test('błąd mutacji ustawia error i zwalnia busy', () async {
    await ctrl().load('p1');
    repo.opError = const ServerError('boom', 500);
    expect(await ctrl().deleteTask('2'), isFalse);
    expect(state().busy, isFalse);
    expect(state().error, 'boom');
  });
}
