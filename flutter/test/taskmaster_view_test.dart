import 'dart:async';

import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_repository.dart';
import 'package:ddagent_app/features/taskmaster/view/taskmaster_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'git_test.dart' show FakeProjectsController;

class _FakeChannel extends ChatChannel {
  _FakeChannel() : super(WsClient(urlBuilder: () async => Uri.parse('ws://t')));

  final _events = StreamController<ServerEvent>.broadcast();

  @override
  Stream<ServerEvent> get events => _events.stream;

  @override
  Future<void> close() async => _events.close();
}

class _FakeTmRepo extends TaskmasterRepository {
  _FakeTmRepo() : super(Dio());

  final calls = <String>[];
  bool ready = true;
  bool hasTasksFile = true;
  List<Map<String, dynamic>> taskRows = [
    {'id': 1, 'title': 'Setup', 'status': 'done', 'priority': 'high'},
    {
      'id': 2,
      'title': 'Build UI',
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

  @override
  Future<Map<String, dynamic>> installationStatus() async => {
    'success': true,
    'installation': {'isInstalled': ready, 'version': 'native'},
    'mcpServer': {'hasMCPServer': false},
    'isReady': ready,
  };

  @override
  Future<Map<String, dynamic>> tasks(String projectId) async => {
    'projectId': projectId,
    'tasks': taskRows,
    'currentTag': 'master',
    'tasksByStatus': const {'pending': 3, 'done': 1},
    if (!hasTasksFile) 'message': 'no tasks file',
  };

  @override
  Future<List<Map<String, dynamic>>> prdList(String p) async => const [
    {'fileName': 'prd.md'},
  ];

  @override
  Future<List<Map<String, dynamic>>> prdTemplates() async => const [
    {'id': 'default', 'name': 'Default', 'content': '# Tpl'},
  ];

  @override
  Future<Map<String, dynamic>> prdFile(String p, String f) async => {
    'content': '# PRD',
  };

  @override
  Future<Map<String, dynamic>> createPrd(
    String p,
    Map<String, dynamic> body,
  ) async {
    calls.add('createPrd:${body['fileName']}');
    return {'success': true};
  }

  @override
  Future<void> init(String p) async {
    calls.add('init');
    ready = true;
  }

  @override
  Future<Map<String, dynamic>> addTask(
    String p,
    Map<String, dynamic> body,
  ) async {
    calls.add('add:${body['title']}');
    taskRows.add({'id': 9, 'title': body['title'], 'status': 'pending'});
    return {'success': true};
  }

  @override
  Future<void> updateTask(
    String p,
    String id,
    Map<String, dynamic> updates,
  ) async {
    calls.add('update:$id:${updates['status'] ?? 'fields'}');
    taskRows = [
      for (final t in taskRows)
        if ('${t['id']}' == id) {...t, ...updates} else t,
    ];
  }

  @override
  Future<void> deleteTask(String p, String id) async {
    calls.add('delete:$id');
    taskRows = taskRows.where((t) => '${t['id']}' != id).toList();
  }

  @override
  Future<Map<String, dynamic>> parsePrd(
    String p, {
    String? fileName,
    int? numTasks,
    bool? append,
  }) async {
    calls.add('parse:$fileName');
    return {'success': true};
  }
}

Widget _app(_FakeTmRepo repo) => ProviderScope(
  overrides: [
    taskmasterRepositoryProvider.overrideWithValue(repo),
    chatChannelProvider.overrideWithValue(_FakeChannel()),
    projectsProvider.overrideWith(
      () => FakeProjectsController([
        const Project(
          projectId: 'p1',
          path: '/workspace/p1',
          displayName: 'Project 1',
        ),
      ]),
    ),
  ],
  child: MaterialApp(
    theme: AppTheme.light(),
    home: const TaskmasterScreen(projectId: 'p1'),
  ),
);

Future<void> _pump(WidgetTester tester, _FakeTmRepo repo) async {
  await tester.pumpWidget(_app(repo));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    Hive.init('/tmp/ddagent_test_hive_tm_view');
    if (!Hive.isBoxOpen('settings')) await Hive.openBox<dynamic>('settings');
  });

  group('feature gating', () {
    testWidgets('not-ready project shows setup card with Initialize', (
      tester,
    ) async {
      final repo = _FakeTmRepo()..ready = false;
      await _pump(tester, repo);
      expect(find.text('TaskMaster is not set up'), findsOneWidget);
      await tester.tap(find.text('Initialize'));
      await tester.pumpAndSettle();
      expect(repo.calls, contains('init'));
      // After init + reload the board renders.
      expect(find.text('Build UI'), findsWidgets);
    });
  });

  group('task list', () {
    testWidgets('renders tiles, next-task banner and counts', (tester) async {
      final repo = _FakeTmRepo();
      await _pump(tester, repo);
      expect(find.text('Next task · #2'), findsOneWidget);
      expect(find.text('Setup'), findsOneWidget);
      expect(find.text('Build UI'), findsWidgets);
      expect(find.text('Blocked'), findsOneWidget);
    });

    testWidgets('search narrows the list', (tester) async {
      final repo = _FakeTmRepo();
      await _pump(tester, repo);
      await tester.enterText(find.byType(TextField).first, 'blocked');
      await tester.pumpAndSettle();
      expect(find.text('Blocked'), findsOneWidget);
      expect(find.text('Polish'), findsNothing);
      // Banner 'Next task' still shows Build UI (it is not filtered).
      expect(find.text('Build UI'), findsOneWidget);
    });

    testWidgets('status filter shows only matching tasks', (tester) async {
      final repo = _FakeTmRepo();
      await _pump(tester, repo);
      await tester.tap(find.byTooltip('Filters'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('All').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('done').last);
      await tester.pumpAndSettle();
      expect(find.text('Setup'), findsOneWidget);
      expect(find.text('Polish'), findsNothing);
      expect(find.text('Blocked'), findsNothing);
      expect(find.text('1/4 tasks'), findsOneWidget);
    });

    testWidgets('sort by priority puts high first', (tester) async {
      final repo = _FakeTmRepo();
      await _pump(tester, repo);
      await tester.tap(find.byTooltip('Sort'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('priority'));
      await tester.pumpAndSettle();
      // 'Polish' (high) sorts before 'Build UI' (medium); .last skips the
      // next-task banner which also renders the 'Build UI' title.
      final polish = tester.getTopLeft(find.text('Polish'));
      final build = tester.getTopLeft(find.text('Build UI').last);
      expect(polish.dy, lessThan(build.dy));
    });
  });

  group('quick actions', () {
    testWidgets('done toggle flips status via update-task', (tester) async {
      final repo = _FakeTmRepo();
      await _pump(tester, repo);
      final row = find.ancestor(
        of: find.text('Build UI').last,
        matching: find.byType(Card),
      );
      await tester.tap(
        find.descendant(of: row, matching: find.byTooltip('Mark done')),
      );
      await tester.pumpAndSettle();
      expect(repo.calls, contains('update:2:done'));
    });

    testWidgets('start button sets in-progress', (tester) async {
      final repo = _FakeTmRepo();
      await _pump(tester, repo);
      final row = find.ancestor(
        of: find.text('Build UI').last,
        matching: find.byType(Card),
      );
      await tester.tap(
        find.descendant(of: row, matching: find.byTooltip('Start task')),
      );
      await tester.pumpAndSettle();
      expect(repo.calls, contains('update:2:in-progress'));
    });
  });

  group('detail dialog', () {
    testWidgets('opens on tap, edits title and status', (tester) async {
      final repo = _FakeTmRepo();
      await _pump(tester, repo);
      await tester.tap(find.text('Polish').first);
      await tester.pumpAndSettle();
      expect(find.text('#3 Polish'), findsOneWidget);
      // Live status change (last dropdown = in-dialog status picker).
      await tester.tap(find.byType(DropdownButton<String>).last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('in-progress').last);
      await tester.pumpAndSettle();
      expect(repo.calls, contains('update:3:in-progress'));
      // Edit mode → change title → Save.
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find
            .descendant(
              of: find.byType(AlertDialog),
              matching: find.byType(TextField),
            )
            .first,
        'Polish v2',
      );
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(repo.calls, contains('update:3:fields'));
    });

    testWidgets('delete requires confirmation', (tester) async {
      final repo = _FakeTmRepo();
      await _pump(tester, repo);
      await tester.tap(find.text('Blocked').first);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Delete task'));
      await tester.pumpAndSettle();
      expect(find.text('Delete task?'), findsOneWidget);
      await tester.tap(find.text('Delete').last);
      await tester.pumpAndSettle();
      expect(repo.calls, contains('delete:4'));
    });
  });

  group('create task', () {
    testWidgets('+ Task dialog adds a task', (tester) async {
      final repo = _FakeTmRepo();
      await _pump(tester, repo);
      await tester.tap(find.text('+ Task'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find
            .descendant(
              of: find.byType(AlertDialog),
              matching: find.byType(TextField),
            )
            .first,
        'New task',
      );
      await tester.pump();
      expect(find.text('New task'), findsOneWidget);
      await tester.tap(find.text('Add Task'));
      await tester.pumpAndSettle();
      expect(repo.calls, contains('add:New task'));
      expect(find.text('New task'), findsOneWidget);
    });
  });

  group('PRD editor', () {
    testWidgets('saves and parses the PRD', (tester) async {
      final repo = _FakeTmRepo();
      await _pump(tester, repo);
      await tester.tap(find.byTooltip('PRD editor'));
      await tester.pumpAndSettle();
      expect(find.text('Parse PRD'), findsOneWidget);
      // Content field is the expanded editor.
      await tester.enterText(
        find.byType(TextField).last,
        '# My PRD\nDo things',
      );
      await tester.tap(find.text('Parse PRD'));
      await tester.pumpAndSettle();
      expect(repo.calls, contains('createPrd:prd.txt'));
      expect(repo.calls, contains('parse:prd.txt'));
    });
  });
}
