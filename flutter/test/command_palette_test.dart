import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/sse_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_repository.dart';
import 'package:ddagent_app/features/git/data/git_repository.dart';
import 'package:ddagent_app/features/palette/command_palette.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/state/workspace_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'git_test.dart' show FakeGitRepository, FakeProjectsController;

class _FakeProjects extends ProjectsRepository {
  _FakeProjects() : super(Dio());

  @override
  Future<List<Project>> list({
    bool skipSync = false,
    int? sessionsLimit,
    int? sessionsOffset,
  }) async => [];

  @override
  Future<List<Project>> archived() async => [];

  @override
  Future<ProjectSessionsPage> sessions(
    String projectId, {
    int limit = 20,
    int offset = 0,
  }) async => ProjectSessionsPage(
    projectId: projectId,
    sessions: const [
      {'id': 's-1', 'title': 'Fix login bug', 'provider': 'claude'},
      {'id': 's-2', 'summary': 'Refactor auth', 'provider': 'codex'},
    ],
  );
}

class _FakeFiles extends FileTreeRepository {
  _FakeFiles() : super(Dio());

  List<FileTreeNode> nodes = const [
    FileTreeNode(name: 'main.dart', path: 'lib/main.dart', isDirectory: false),
    FileTreeNode(
      name: 'src',
      path: 'src',
      isDirectory: true,
      children: [
        FileTreeNode(name: 'app.tsx', path: 'src/app.tsx', isDirectory: false),
      ],
    ),
  ];

  @override
  Future<List<FileTreeNode>> listFiles(
    String projectId, {
    bool respectGitignore = true,
  }) async => nodes;
}

class _FakeSse extends SseClient {
  _FakeSse() : super(Dio());

  List<SseEvent> events = const [];

  @override
  Stream<SseEvent> searchSessions(
    String query, {
    int limit = 50,
    CancelToken? cancelToken,
  }) => Stream.fromIterable(events);
}

class _FakeSessions extends SessionsRepository {
  _FakeSessions() : super(Dio());

  @override
  Future<Map<String, dynamic>> tokenUsage(String sessionId) async => {
    'data': {
      'used': 1200,
      'breakdown': {'input': 800, 'output': 400},
    },
  };

  @override
  Future<Map<String, dynamic>> activeModel(
    String provider,
    String sessionId,
  ) async => {
    'data': {'model': 'claude-sonnet-4'},
  };
}

class _Harness {
  _Harness() {
    container = ProviderContainer(
      overrides: [
        projectsProvider.overrideWith(
          () => FakeProjectsController([
            const Project(projectId: 'p1', path: '/p', displayName: 'Demo'),
          ]),
        ),
        projectsRepositoryProvider.overrideWithValue(_FakeProjects()),
        fileTreeRepositoryProvider.overrideWithValue(files),
        sseClientProvider.overrideWithValue(sse),
        sessionsRepositoryProvider.overrideWithValue(sessions),
        gitRepositoryProvider.overrideWithValue(git),
      ],
    );
  }

  late final ProviderContainer container;
  final files = _FakeFiles();
  final sse = _FakeSse();
  final sessions = _FakeSessions();
  final git = FakeGitRepository();

  late final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, _) => Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showCommandPalette(context),
              child: const Text('open'),
            ),
          ),
        ),
      ),
      for (final p in ['/workspace', '/board', '/tasks', '/quota', '/files'])
        GoRoute(path: p, builder: (_, _) => Text('PAGE:$p')),
      GoRoute(
        path: '/git',
        builder: (_, s) => Text('PAGE:/git:${s.uri.queryParameters}'),
      ),
      for (final s in ['agents', 'appearance', 'api'])
        GoRoute(
          path: '/settings/$s',
          builder: (_, _) => const Text('PAGE:/settings'),
        ),
      GoRoute(
        path: '/settings',
        builder: (_, _) => const Text('PAGE:/settings'),
      ),
    ],
  );

  Widget app() => TranslationProvider(
    child: UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
    ),
  );
}

void main() {
  setUpAll(() async {
    Hive.init('/tmp/ddagent_test_hive_palette');
    for (final box in ['settings', 'workspace']) {
      if (!Hive.isBoxOpen(box)) await Hive.openBox<dynamic>(box);
    }
  });

  Future<void> open(WidgetTester tester, _Harness h) async {
    await tester.pumpWidget(h.app());
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  /// The palette list is lazy — below-the-fold items don't exist in the
  /// tree until scrolled. Searching narrows the list so the target renders.
  Future<void> search(WidgetTester tester, String query) async {
    await tester.enterText(find.byType(TextField), query);
    await tester.pumpAndSettle();
  }

  Future<void> dragList(WidgetTester tester, double dy) async {
    await tester.drag(
      find.descendant(
        of: find.byType(CommandPaletteDialog),
        matching: find.byType(ListView),
      ),
      Offset(0, dy),
    );
    await tester.pumpAndSettle();
  }

  group('command palette — T62.8', () {
    testWidgets('lists action/nav/git/settings groups plus sources', (
      tester,
    ) async {
      final h = _Harness();
      await open(tester, h);

      expect(find.text('Actions'), findsOneWidget);
      expect(find.text('Navigate'), findsWidgets); // group + kbd hint label
      expect(find.text('Start new chat'), findsOneWidget);
      expect(find.text('Ctrl+Shift+K'), findsOneWidget);

      await search(tester, 'git:');
      expect(find.text('Git: Pull'), findsOneWidget);

      // Below-the-fold groups exist once the list is filtered.
      await search(tester, 'login');
      expect(find.text('Fix login bug'), findsOneWidget);
      expect(find.text('Sessions'), findsOneWidget);

      await search(tester, 'main.dart');
      // One in the search input, one in the file tile.
      expect(find.text('main.dart'), findsWidgets);

      await search(tester, 'first');
      expect(find.text('first'), findsWidgets); // input + commit tile
      expect(find.text('Commits'), findsWidgets);

      await search(tester, 'main');
      expect(find.text('Switch to: main'), findsOneWidget);
      expect(find.text('Branches'), findsWidgets);
    });

    testWidgets('search filters items', (tester) async {
      final h = _Harness();
      await open(tester, h);
      await tester.enterText(find.byType(TextField), 'pull');
      await tester.pumpAndSettle();

      expect(find.text('Git: Pull'), findsOneWidget);
      expect(find.text('Start new chat'), findsNothing);
      expect(find.text('Git: Fetch'), findsNothing);
    });

    testWidgets('nav item navigates to its route and closes', (tester) async {
      final h = _Harness();
      await open(tester, h);
      await tester.tap(find.text('Go to Agent Board'));
      await tester.pumpAndSettle();

      expect(find.text('PAGE:/board'), findsOneWidget);
      expect(find.byType(CommandPaletteDialog), findsNothing);
    });

    testWidgets('session opens a chat pane in the workspace', (tester) async {
      final h = _Harness();
      await open(tester, h);
      await search(tester, 'login');
      await tester.tap(find.text('Fix login bug'));
      await tester.pumpAndSettle();

      expect(find.text('PAGE:/workspace'), findsOneWidget);
      final panes = h.container.read(workspaceProvider).panes;
      expect(
        panes.any((p) => p.kind == PaneKind.chat && p.sessionId == 's-1'),
        isTrue,
      );
    });

    testWidgets('file opens an in-pane editor', (tester) async {
      final h = _Harness();
      await open(tester, h);
      await search(tester, 'main.dart');
      await tester.tap(find.widgetWithText(ListTile, 'main.dart'));
      await tester.pumpAndSettle();

      final panes = h.container.read(workspaceProvider).panes;
      expect(
        panes.any(
          (p) =>
              p.kind == PaneKind.editor &&
              p.filePath == 'lib/main.dart' &&
              p.projectId == 'p1',
        ),
        isTrue,
      );
      await tester.pump(const Duration(milliseconds: 400));
    });

    testWidgets('git actions call the repo and reveal git', (tester) async {
      final h = _Harness();
      await open(tester, h);
      await search(tester, 'pull');
      await tester.tap(find.text('Git: Pull'));
      await tester.pumpAndSettle();

      expect(h.git.calls, contains('pull'));
      expect(find.text('PAGE:/workspace'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 400));
    });

    testWidgets('branch item checks out the branch', (tester) async {
      final h = _Harness();
      await open(tester, h);
      await search(tester, 'dev');
      await tester.tap(find.text('Switch to: dev'));
      await tester.pumpAndSettle();

      expect(h.git.calls, contains('checkout:dev'));
      await tester.pump(const Duration(milliseconds: 400));
    });

    testWidgets('browse-all pushes a page and the chip pops it', (
      tester,
    ) async {
      final h = _Harness();
      h.files.nodes = [
        for (var i = 0; i < 7; i++)
          FileTreeNode(
            name: 'f$i.dart',
            path: 'lib/f$i.dart',
            isDirectory: false,
          ),
      ];
      await open(tester, h);

      for (
        var i = 0;
        i < 6 && find.text('Browse all files (7)').evaluate().isEmpty;
        i++
      ) {
        await dragList(tester, -400);
      }
      // The row can exist in the lazy list but sit past the clip edge —
      // ensureVisible scrolls it fully into view before the tap.
      await tester.ensureVisible(find.text('Browse all files (7)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Browse all files (7)'));
      await tester.pumpAndSettle();
      expect(find.text('f0.dart'), findsOneWidget);
      // Page chip shows the active page; actions are hidden.
      expect(find.text('Start new chat'), findsNothing);

      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();
      expect(find.text('Start new chat'), findsOneWidget);
    });

    testWidgets('compare picks two sessions and opens split view', (
      tester,
    ) async {
      final h = _Harness();
      await open(tester, h);
      await tester.tap(find.text('Compare sessions'));
      await tester.pumpAndSettle();

      // Two session dropdowns, split button disabled until both picked.
      final splitBtn = find.widgetWithText(TextButton, 'Open in split view');
      expect(tester.widget<TextButton>(splitBtn).onPressed, isNull);

      await tester.tap(find.byType(DropdownButtonFormField<String>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Fix login bug · claude').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButtonFormField<String>).last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Refactor auth · codex').last);
      await tester.pumpAndSettle();

      // Usage columns loaded for the left selection.
      expect(find.text('1,200'), findsWidgets);
      expect(find.text('claude-sonnet-4'), findsWidgets);

      await tester.tap(splitBtn);
      await tester.pumpAndSettle();
      expect(find.text('PAGE:/workspace'), findsOneWidget);
      final panes = h.container.read(workspaceProvider).panes;
      expect(
        panes.where((p) => p.kind == PaneKind.chat).map((p) => p.sessionId),
        containsAll(['s-1', 's-2']),
      );
      await tester.pump(const Duration(milliseconds: 400));
    });

    testWidgets('escape closes the palette', (tester) async {
      final h = _Harness();
      await open(tester, h);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(CommandPaletteDialog), findsNothing);
    });
  });
}
