import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_models.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_repository.dart';
import 'package:ddagent_app/features/taskmaster/state/taskmaster_controller.dart';
import 'package:ddagent_app/features/taskmaster/view/task_board.dart';
import 'package:ddagent_app/features/taskmaster/view/taskmaster_screen.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'git_test.dart' show FakeProjectsController;

class _FakeChatChannel extends ChatChannel {
  _FakeChatChannel() : super(WsClient(urlBuilder: () async => Uri.parse('ws://t')));

  final _controller = StreamController<ServerEvent>.broadcast();

  @override
  Stream<ServerEvent> get events => _controller.stream;

  void emit(Map<String, dynamic> raw) => _controller.add(ServerEvent(raw: raw));

  @override
  Future<void> close() async => _controller.close();
}

class _FakeRepo extends TaskmasterRepository {
  _FakeRepo() : super(Dio());

  final calls = <String>[];
  bool ready = true;
  bool hasTasksFile = true;
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
    {
      'id': 4,
      'title': 'Blocked',
      'status': 'pending',
      'dependencies': [9],
    },
  ];
  Object? opError;
  final pendingTasks = <Completer<Map<String, dynamic>>>[];
  bool deferTasks = false;

  Map<String, dynamic> _ok(String name, [Map<String, dynamic>? extra]) {
    if (opError != null) throw opError!;
    calls.add(name);
    return {'success': true, ...?extra};
  }

  @override
  Future<Map<String, dynamic>> installationStatus() async => {
    'success': true,
    'installation': {'isInstalled': ready, 'version': 'native'},
    'mcpServer': {'hasMCPServer': false},
    'isReady': ready,
  };

  @override
  Future<Map<String, dynamic>> tasks(String projectId) async {
    calls.add('tasks:$projectId');
    if (deferTasks) {
      final request = Completer<Map<String, dynamic>>();
      pendingTasks.add(request);
      return request.future;
    }
    return {
      'projectId': projectId,
      'tasks': List<Map<String, dynamic>>.from(taskRows),
      'currentTag': 'master',
      'totalTasks': taskRows.length,
      'tasksByStatus': {
        'done': taskRows.where((t) => t['status'] == 'done').length,
        'pending': taskRows.where((t) => t['status'] == 'pending').length,
        'in-progress': taskRows.where((t) => t['status'] == 'in-progress').length,
      },
      if (!hasTasksFile) 'message': 'no tasks file',
    };
  }

  @override
  Future<List<Map<String, dynamic>>> prdList(String projectId) async => const [
    {'fileName': 'prd.md'},
  ];

  @override
  Future<List<Map<String, dynamic>>> prdTemplates() async => const [
    {'id': 'default', 'name': 'Default', 'content': '# Tpl Content'},
  ];

  @override
  Future<Map<String, dynamic>> prdFile(String p, String f) async =>
      _ok('prdFile:$f', {'content': '# PRD content'});

  @override
  Future<Map<String, dynamic>> createPrd(String p, Map<String, dynamic> body) async =>
      _ok('createPrd:${body['fileName']}');

  @override
  Future<void> init(String p) async {
    _ok('init');
    ready = true;
  }

  @override
  Future<Map<String, dynamic>> addTask(String p, Map<String, dynamic> body) async {
    final res = _ok('add:${body['title']}');
    taskRows.add({
      'id': taskRows.length + 1,
      'title': body['title'],
      'status': 'pending',
      'priority': body['priority'] ?? 'medium',
      'dependencies': <dynamic>[],
    });
    return res;
  }

  @override
  Future<void> updateTask(String p, String id, Map<String, dynamic> updates) async {
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
  }) async {
    final res = _ok('parse:$fileName');
    taskRows.add({
      'id': 100,
      'title': 'Generated from PRD',
      'status': 'pending',
      'priority': 'medium',
      'dependencies': <dynamic>[],
    });
    return res;
  }
}

Widget _app(_FakeRepo repo, _FakeChatChannel channel) => TranslationProvider(
  child: ProviderScope(
    overrides: [
      taskmasterRepositoryProvider.overrideWithValue(repo),
      chatChannelProvider.overrideWithValue(channel),
      projectsProvider.overrideWith(
        () => FakeProjectsController([
          const Project(projectId: 'p1', path: '/workspace/p1', displayName: 'Project 1'),
        ]),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: const TaskmasterScreen(projectId: 'p1'),
    ),
  ),
);

Future<void> _pump(WidgetTester tester, _FakeRepo repo, _FakeChatChannel channel) async {
  tester.view.physicalSize = const Size(1280, 900);
  tester.view.devicePixelRatio = 1.0;
  await tester.pumpWidget(_app(repo, channel));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    Hive.init('/tmp/ddagent_test_hive_tm');
    if (!Hive.isBoxOpen('settings')) await Hive.openBox<dynamic>('settings');
    if (!Hive.isBoxOpen('chat')) await Hive.openBox<dynamic>('chat');
  });

  group('TaskmasterController — testy jednostkowe', () {
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

    Future<void> flush() async {
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
    }

    test('Model TaskmasterTask i TaskmasterStatus tolerują różne formaty', () {
      final t = TaskmasterTask.fromJson({
        'id': 7,
        'title': 'T',
        'test_strategy': 'run it',
        'dependencies': [1, 'x'],
        'subtasks': [
          {'id': 1, 'title': 'sub'},
        ],
      });
      expect(t.status, 'pending');
      expect(t.testStrategy, 'run it');
      expect(t.subtasks.single.title, 'sub');
      expect(t.idText, '7');

      final s = TaskmasterStatus.fromJson({
        'master': {
          'tasks': [
            {'id': 1, 'title': 'A'},
          ],
        },
      });
      expect(s.tasks.single.title, 'A');
    });

    test('Sprawdzenie ładowania statusu i feature gatingu (isReady == true)', () async {
      await ctrl().load('p1');
      await flush();
      expect(state().isReady, isTrue);
      expect(state().config?.isInstalled, isTrue);
      expect(state().tasks.length, 4);
      expect(state().tasksByStatus['pending'], 3);
      expect(state().prdFiles.single.fileName, 'prd.md');
      expect(state().prdTemplates.single.name, 'Default');
    });

    test('Sprawdzenie feature gatingu gdy instalacja nie jest gotowa', () async {
      repo.ready = false;
      await ctrl().load('p1');
      await flush();
      expect(state().isReady, isFalse);
      expect(state().config?.isInstalled, isFalse);
    });

    test('Filtrowanie, wyszukiwanie i sortowanie listy zadań', () async {
      await ctrl().load('p1');
      await flush();
      ctrl().setStatusFilter('pending');
      expect(state().filteredTasks.length, 3);
      ctrl().setPriorityFilter('high');
      expect(state().filteredTasks.single.title, 'Polish');
      ctrl().setPriorityFilter(null);

      ctrl().setSearchQuery('blocked');
      expect(state().filteredTasks.single.idText, '4');
      ctrl().setSearchQuery('');

      // Sortowanie po priorytecie
      ctrl().setSort(TaskSort.priority);
      expect(state().filteredTasks.first.title, 'Polish');

      // Sortowanie po tytule
      ctrl().setSort(TaskSort.title);
      expect(state().filteredTasks.first.title, 'Blocked');

      // Sortowanie po statusie
      ctrl().setStatusFilter(null);
      ctrl().setSort(TaskSort.status);
      expect(state().filteredTasks.first.status, 'done');

      // Sortowanie po pozycji / ID
      ctrl().setSort(TaskSort.position);
      expect(state().filteredTasks.first.idText, '1');
    });

    test('Pobieranie i wyznaczanie next-task w oparciu o zależności i priorytety', () async {
      await ctrl().load('p1');
      await flush();
      // Task 1 jest done -> Task 2 ma spełnione deps -> kandydat
      expect(state().nextTask!.idText, '2');
      expect(state().nextTask!.title, 'Build UI');

      // Oznaczamy task 2 jako done -> Task 3 ma spełnione deps -> staje się nextTask
      await ctrl().setTaskStatus('2', 'done');
      await flush();
      expect(state().nextTask!.idText, '3');
      expect(state().nextTask!.title, 'Polish');

      // Gdy nie ma żadnych zadań pending ze spełnionymi zależnościami
      await ctrl().setTaskStatus('3', 'done');
      await flush();
      expect(state().nextTask, isNull); // Task 4 zależy od 9 (brak 9)
    });

    test('Operacje CRUD na zadaniach i aktualizacja statusu', () async {
      await ctrl().load('p1');
      await flush();
      final okAdd = await ctrl().createTask({'title': 'New Task', 'priority': 'low'});
      expect(okAdd, isTrue);
      expect(repo.calls, contains('add:New Task'));
      await flush();
      expect(state().tasks.any((t) => t.title == 'New Task'), isTrue);

      final okUpdate = await ctrl().updateTask('2', {
        'status': 'in-progress',
        'title': 'Build UI v2',
      });
      expect(okUpdate, isTrue);
      expect(repo.calls, contains('update:2:in-progress'));

      final okStatus = await ctrl().setTaskStatus('2', 'done');
      expect(okStatus, isTrue);
      expect(repo.calls, contains('update:2:done'));

      final okDelete = await ctrl().deleteTask('2');
      expect(okDelete, isTrue);
      expect(repo.calls, contains('delete:2'));
      await flush();
      expect(state().tasks.any((t) => t.idText == '2'), isFalse);
    });

    test('Parsowanie PRD (parsePrd) i pojawianie się nowych zadań w stanie', () async {
      await ctrl().load('p1');
      await flush();
      final beforeCount = state().tasks.length;
      final okParse = await ctrl().parsePrd(fileName: 'prd.md');
      expect(okParse, isTrue);
      expect(repo.calls, contains('parse:prd.md'));
      await flush();
      expect(state().tasks.length, greaterThan(beforeCount));
      expect(state().tasks.any((t) => t.title == 'Generated from PRD'), isTrue);

      // openPrd i savePrd
      await ctrl().openPrd('prd.md');
      expect(state().prdContent, '# PRD content');
      ctrl().setPrdContent('# Modified PRD');
      final okSave = await ctrl().savePrd('prd.md');
      expect(okSave, isTrue);
      expect(repo.calls, contains('createPrd:prd.md'));
    });

    test('Obsługa zdarzeń WebSocket (tasks-updated, taskmaster-project-updated)', () async {
      await ctrl().load('p1');
      await flush();
      repo.calls.clear();

      // tasks-updated dla p1
      channel.emit({'type': 'tasks-updated', 'projectId': 'p1'});
      await flush();
      expect(repo.calls.where((c) => c.startsWith('tasks:p1')), isNotEmpty);

      repo.calls.clear();
      // taskmaster-project-updated dla p1
      channel.emit({'type': 'taskmaster-project-updated', 'projectId': 'p1'});
      await flush();
      expect(repo.calls.where((c) => c.startsWith('tasks:p1')), isNotEmpty);

      repo.calls.clear();
      // Zdarzenie dla innego projektu ignorowane
      channel.emit({'type': 'tasks-updated', 'projectId': 'other-project'});
      await flush();
      expect(repo.calls.where((c) => c.startsWith('tasks')), isEmpty);
    });

    test('successive task broadcasts update status and ignore stale responses', () async {
      await ctrl().load('p1');
      await flush();
      expect(state().tasks.firstWhere((t) => t.idText == '2').status, 'pending');
      for (final status in ['in-progress', 'done']) {
        repo.taskRows[1] = {...repo.taskRows[1], 'status': status};
        channel.emit({'kind': 'taskmaster-tasks-updated', 'projectId': 'p1'});
        await flush();
        expect(state().tasks.firstWhere((t) => t.idText == '2').status, status);
        expect(state().tasksByStatus[status], greaterThan(0));
      }
      repo.deferTasks = true;
      channel.emit({'kind': 'taskmaster-tasks-updated', 'projectId': 'other'});
      await flush();
      expect(repo.pendingTasks, isEmpty);
      for (var i = 0; i < 2; i++) {
        channel.emit({'kind': 'taskmaster-tasks-updated', 'projectId': 'p1'});
        await flush();
      }
      Map<String, dynamic> response(String status) => {
        'tasks': [
          {'id': 2, 'title': 'Build UI', 'status': status},
        ],
        'tasksByStatus': {status: 1},
      };
      expect(repo.pendingTasks, hasLength(2));
      repo.pendingTasks[1].complete(response('done'));
      await flush();
      expect(state().tasks.single.status, 'done');
      repo.pendingTasks[0].complete(response('in-progress'));
      await flush();
      expect(state().tasks.single.status, 'done');
      expect(state().tasksByStatus, {'done': 1});
    });

    test('stale task request errors do not overwrite a newer project', () async {
      await ctrl().load('p1');
      await flush();
      repo.deferTasks = true;
      channel.emit({'kind': 'tasks-updated', 'projectId': 'p1'});
      await flush();
      repo.deferTasks = false;
      await ctrl().load('p2');
      repo.pendingTasks.single.completeError(const ServerError('old project failed', 500));
      await flush();
      expect(state().projectId, 'p2');
      expect(state().error, isNull);
    });

    test('Obsługa błędów API przy mutacjach i ładowaniu', () async {
      await ctrl().load('p1');
      await flush();
      repo.opError = const ServerError('Błąd serwera', 500);
      final ok = await ctrl().deleteTask('2');
      expect(ok, isFalse);
      expect(state().busy, isFalse);
      expect(state().error, 'Błąd serwera');
      ctrl().clearError();
      expect(state().error, isNull);
    });
  });

  group('TaskmasterScreen — testy widgetowe', () {
    testWidgets('Renderowanie listy zadań, sekcji next-task oraz pasków filtrów', (tester) async {
      final repo = _FakeRepo();
      final channel = _FakeChatChannel();
      await _pump(tester, repo, channel);
      addTearDown(() => tester.view.resetPhysicalSize());

      expect(find.text('Task 2'), findsOneWidget);
      expect(find.text('Setup'), findsOneWidget);
      expect(find.text('Build UI'), findsWidgets);
      expect(find.text('Blocked'), findsOneWidget);

      // Search input zawęża listę
      await tester.enterText(find.byType(TextField).first, 'blocked');
      await tester.pumpAndSettle();
      expect(find.text('Blocked'), findsOneWidget);
      expect(find.text('Polish'), findsNothing);

      // Czyszczenie wyszukiwania
      await tester.enterText(find.byType(TextField).first, '');
      await tester.pumpAndSettle();

      // Filtry statusu
      await tester.tap(find.text('Filters'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButton<String?>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('done').last);
      await tester.pumpAndSettle();
      expect(find.text('Setup'), findsOneWidget);
      expect(find.text('Polish'), findsNothing);
      expect(find.text('Blocked'), findsNothing);

      // Sortowanie po priorytecie
      await tester.tap(find.text('Clear Filters'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButton<String?>).last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Priority (High First)').last);
      await tester.pumpAndSettle();
      final polish = tester.getTopLeft(find.text('Polish'));
      final build = tester.getTopLeft(find.text('Build UI').last);
      expect(polish.dy < build.dy || (polish.dy == build.dy && polish.dx < build.dx), isTrue);
    });

    testWidgets('Feature gating: brak konfiguracji wyświetla kartę z Initialize', (tester) async {
      final repo = _FakeRepo()..ready = false;
      final channel = _FakeChatChannel();
      await _pump(tester, repo, channel);
      addTearDown(() => tester.view.resetPhysicalSize());

      expect(find.text('TaskMaster AI is not configured'), findsOneWidget);
      await tester.tap(find.text('Initialize TaskMaster AI'));
      await tester.pumpAndSettle();
      // Setup modal parity: init runs inside the dialog.
      await tester.tap(find.text('Initialize'));
      await tester.pump();
      expect(repo.calls, contains('init'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 900));
      await tester.tap(find.text('Close & Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Build UI'), findsWidgets);
    });

    testWidgets('Otwarcie szczegółów zadania i edycja jego pól', (tester) async {
      final repo = _FakeRepo();
      final channel = _FakeChatChannel();
      await _pump(tester, repo, channel);
      addTearDown(() => tester.view.resetPhysicalSize());

      // Kliknięcie kafelka Polish otwiera dialog
      await tester.tap(find.text('Polish').first);
      await tester.pumpAndSettle();
      expect(find.text('#3 Polish'), findsOneWidget);

      // Zmiana statusu w dialogu
      await tester.tap(find.byType(DropdownButton<String>).last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('In Progress').last);
      await tester.pumpAndSettle();
      expect(repo.calls, contains('update:3:in-progress'));

      // Tryb edycji pól
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextField)).first,
        'Polish updated title',
      );
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(repo.calls, contains('update:3:fields'));

      // Usunięcie zadania wymaga potwierdzenia
      await tester.tap(find.byTooltip('Delete task'));
      await tester.pumpAndSettle();
      expect(find.text('Delete task?'), findsOneWidget);
      await tester.tap(find.text('Delete').last);
      await tester.pumpAndSettle();
      expect(repo.calls, contains('delete:3'));
    });

    testWidgets('Szybka akcja: oznaczenie jako done (toggle)', (tester) async {
      final repo = _FakeRepo();
      final channel = _FakeChatChannel();
      await _pump(tester, repo, channel);
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.tap(find.byTooltip('List view'));
      await tester.pumpAndSettle();
      final row = find.ancestor(
        of: find.text('Build UI').last,
        matching: find.byType(TaskCompactRow),
      );
      await tester.tap(find.descendant(of: row, matching: find.byTooltip('Mark completed')));
      await tester.pumpAndSettle();
      expect(repo.calls, contains('update:2:done'));
    });

    testWidgets('Szybka akcja: uruchomienie zadania (Start task)', (tester) async {
      final repo = _FakeRepo();
      final channel = _FakeChatChannel();
      await _pump(tester, repo, channel);
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.tap(find.byTooltip('List view'));
      await tester.pumpAndSettle();
      final row = find.ancestor(
        of: find.text('Build UI').last,
        matching: find.byType(TaskCompactRow),
      );
      await tester.tap(find.descendant(of: row, matching: find.byTooltip('Run task')));
      await tester.pumpAndSettle();
      expect(repo.calls, contains('update:2:in-progress'));
    });

    testWidgets('+ Task otwiera dialog dodawania zadania', (tester) async {
      final repo = _FakeRepo();
      final channel = _FakeChatChannel();
      await _pump(tester, repo, channel);
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.tap(find.text('Add Task').first);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.descendant(of: find.byType(AlertDialog), matching: find.byType(TextField)).first,
        'Created Via Dialog',
      );
      await tester.pump();
      await tester.tap(find.text('Add Task').last);
      await tester.pumpAndSettle();
      expect(repo.calls, contains('add:Created Via Dialog'));
      expect(find.text('Created Via Dialog'), findsOneWidget);
    });

    testWidgets('Otwarcie edytora PRD, wybór szablonu i wywołanie akcji parse PRD', (tester) async {
      final repo = _FakeRepo();
      final channel = _FakeChatChannel();
      await _pump(tester, repo, channel);
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.tap(find.text('PRDs'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create New PRD'));
      await tester.pumpAndSettle();
      expect(find.text('Parse PRD'), findsOneWidget);

      // Wybór szablonu z dropdowna wewnątrz dialogu
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(DropdownButton<String>),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Default').last);
      await tester.pumpAndSettle();

      // Kliknięcie Parse PRD
      await tester.tap(find.text('Parse PRD'));
      await tester.pumpAndSettle();

      expect(repo.calls, contains('createPrd:prd.txt'));
      expect(repo.calls, contains('parse:prd.txt'));
      expect(find.text('Generated from PRD'), findsOneWidget);
    });

    testWidgets('Reakcja interfejsu na aktualizacje ze strumienia WS', (tester) async {
      final repo = _FakeRepo();
      final channel = _FakeChatChannel();
      await _pump(tester, repo, channel);
      addTearDown(() => tester.view.resetPhysicalSize());

      expect(find.text('WS Realtime Task'), findsNothing);

      // Symulacja nadejścia nowego zadania z WebSocket
      repo.taskRows.add({
        'id': 77,
        'title': 'WS Realtime Task',
        'status': 'pending',
        'priority': 'medium',
        'dependencies': <dynamic>[],
      });
      channel.emit({'type': 'tasks-updated', 'projectId': 'p1'});
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();

      expect(find.text('WS Realtime Task'), findsOneWidget);
    });
  });

  group('TaskmasterScreen — setup i help modale', () {
    testWidgets('Initialize otwiera setup modal; init kończy się statusem i reloadem', (t) async {
      final repo = _FakeRepo()..ready = false;
      final channel = _FakeChatChannel();
      await _pump(t, repo, channel);
      addTearDown(t.view.resetPhysicalSize);

      // SetupView zamiast boarda
      expect(find.text('TaskMaster AI is not configured'), findsOneWidget);

      // Klik w Initialize otwiera modal (nie init bezpośrednio)
      await t.tap(find.text('Initialize TaskMaster AI'));
      await t.pumpAndSettle();
      expect(find.text('TaskMaster Setup'), findsOneWidget);
      expect(find.text('Interactive CLI for Project 1'), findsOneWidget);
      expect(find.textContaining('Creates a .taskmaster folder'), findsOneWidget);
      expect(repo.calls, isNot(contains('init')));

      // Init w środku modala
      await t.tap(find.text('Initialize'));
      await t.pump();
      expect(repo.calls, contains('init'));
      await t.pumpAndSettle();
      expect(
        find.text('TaskMaster setup completed! You can now close this window.'),
        findsOneWidget,
      );
      expect(find.text('Close & Continue'), findsOneWidget);

      // onAfterClose po ~800 ms — przeładowanie boarda
      await t.pump(const Duration(milliseconds: 900));
      await t.pumpAndSettle();
      expect(repo.calls.where((c) => c == 'tasks:p1').length, greaterThan(1));

      // Modal nadal otwarty do zamknięcia ręcznego
      await t.tap(find.text('Close & Continue'));
      await t.pumpAndSettle();
      expect(find.text('TaskMaster Setup'), findsNothing);
    });

    testWidgets('setup modal: błąd init pokazuje komunikat i pozostaje otwarty', (t) async {
      final repo = _FakeRepo()
        ..ready = false
        ..opError = const ServerError('init failed', 500);
      final channel = _FakeChatChannel();
      await _pump(t, repo, channel);
      addTearDown(t.view.resetPhysicalSize);

      await t.tap(find.text('Initialize TaskMaster AI'));
      await t.pumpAndSettle();
      await t.tap(find.text('Initialize'));
      await t.pumpAndSettle();

      // Dialog error + the screen's error banner behind it.
      expect(find.text('init failed'), findsWidgets);
      expect(find.text('TaskMaster Setup'), findsOneWidget);
      expect(find.text('Initialize'), findsOneWidget);
    });

    testWidgets('help modal: kroki, pro tips, GitHub i Add PRD w kroku 1', (t) async {
      final repo = _FakeRepo();
      final channel = _FakeChatChannel();
      await _pump(t, repo, channel);
      addTearDown(t.view.resetPhysicalSize);

      await t.tap(find.byIcon(LucideIcons.circleHelp));
      await t.pumpAndSettle();

      expect(find.text('Getting Started with TaskMaster'), findsWidgets);
      expect(find.text('Your guide to productive task management'), findsOneWidget);
      expect(find.text('Create a Product Requirements Document (PRD)'), findsOneWidget);
      expect(find.text('Start Building'), findsOneWidget);
      expect(find.textContaining('Pro Tips'), findsOneWidget);
      expect(find.text('View on GitHub'), findsOneWidget);

      // Add PRD w kroku 1 zamyka modal i otwiera edytor PRD
      await t.tap(find.text('Add PRD'));
      await t.pumpAndSettle();
      expect(find.text('Your guide to productive task management'), findsNothing);
      expect(find.textContaining('PRD — prd.txt'), findsOneWidget);
    });
  });
}
