import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/features/editor/state/editor_controller.dart';
import 'package:ddagent_app/features/file_tree/data/explorer_rows.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_repository.dart';
import 'package:ddagent_app/features/file_tree/state/file_tree_controller.dart';
import 'package:ddagent_app/features/file_tree/view/explorer_tree.dart';
import 'package:ddagent_app/features/file_tree/view/file_tree_screen.dart';
import 'package:ddagent_app/features/git/data/git_repository.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

const _tree = [
  FileTreeNode(
    name: 'lib',
    path: '/proj/lib',
    isDirectory: true,
    children: [
      FileTreeNode(name: 'main.dart', path: '/proj/lib/main.dart', isDirectory: false),
      FileTreeNode(
        name: 'src',
        path: '/proj/lib/src',
        isDirectory: true,
        children: [FileTreeNode(name: 'a.dart', path: '/proj/lib/src/a.dart', isDirectory: false)],
      ),
    ],
  ),
  FileTreeNode(
    name: 'pkg',
    path: '/proj/pkg',
    isDirectory: true,
    children: [
      FileTreeNode(
        name: 'inner',
        path: '/proj/pkg/inner',
        isDirectory: true,
        children: [
          FileTreeNode(
            name: 'deep',
            path: '/proj/pkg/inner/deep',
            isDirectory: true,
            children: [
              FileTreeNode(name: 'x.ts', path: '/proj/pkg/inner/deep/x.ts', isDirectory: false),
            ],
          ),
        ],
      ),
    ],
  ),
  FileTreeNode(name: 'README.md', path: '/proj/README.md', isDirectory: false),
];

class _FakeFiles extends FileTreeRepository {
  _FakeFiles() : super(Dio());

  final creates = <String>[];
  final renames = <String>[];
  final searches = <String>[];
  final moves = <String>[];
  final copies = <String>[];

  String _into(String target, String source) =>
      '${target.isEmpty ? '/proj' : target}/${source.split('/').last}';

  @override
  Future<String> moveFile(
    String projectId, {
    required String sourcePath,
    required String targetPath,
  }) async {
    moves.add('$sourcePath->$targetPath');
    return _into(targetPath, sourcePath);
  }

  @override
  Future<String> copyFile(
    String projectId, {
    required String sourcePath,
    required String targetPath,
  }) async {
    copies.add('$sourcePath->$targetPath');
    return _into(targetPath, sourcePath);
  }

  @override
  Future<FileSearchResult> search(String projectId, String query, {int? limit}) async {
    searches.add(query);
    return const FileSearchResult(
      matches: [
        FileSearchMatch(path: '/proj/lib/main.dart', line: 3, column: 1, text: 'void main() {}'),
      ],
      truncated: false,
    );
  }

  @override
  Future<List<FileTreeNode>> listFiles(String projectId, {bool respectGitignore = true}) async =>
      _tree;

  @override
  Future<void> createFile(
    String projectId, {
    required String path,
    required String type,
    required String name,
  }) async => creates.add('$type:$path:$name');

  @override
  Future<void> renameFile(
    String projectId, {
    required String oldPath,
    required String newName,
  }) async => renames.add('$oldPath->$newName');
}

class _FakeGit extends GitRepository {
  _FakeGit(this.result) : super(Dio());

  final Map<String, dynamic> result;

  @override
  Future<Map<String, dynamic>> status(String project) async => result;
}

class _Projects extends ProjectsController {
  @override
  ProjectsState build() => const ProjectsState(
    projects: [Project(projectId: 'p1', path: '/proj', displayName: 'proj')],
    loading: false,
  );

  @override
  Future<void> load() async {}
}

void main() {
  group('buildExplorerRows', () {
    test('collapses single-directory chains into one compact row', () {
      final rows = buildExplorerRows(_tree, const {});
      expect(rows.map((r) => r.label), ['lib', 'pkg/inner/deep', 'README.md']);
      expect(rows[1].path, '/proj/pkg/inner/deep');
      expect(rows[1].chain.map((n) => n.name), ['pkg', 'inner', 'deep']);
    });

    test('a compact row expands to the children of its last directory', () {
      final rows = buildExplorerRows(_tree, const {'/proj/pkg/inner/deep'});
      expect(rows.map((r) => (r.label, r.depth)), [
        ('lib', 0),
        ('pkg/inner/deep', 0),
        ('x.ts', 1),
        ('README.md', 0),
      ]);
    });

    test('compactFolders: false keeps one row per directory', () {
      final rows = buildExplorerRows(_tree, const {}, compactFolders: false);
      expect(rows.map((r) => r.label), ['lib', 'pkg', 'README.md']);
    });

    test('parent index walks up to the owning row', () {
      final rows = buildExplorerRows(_tree, const {'/proj/lib', '/proj/lib/src'});
      // lib, main.dart, src, a.dart, pkg/inner/deep, README.md
      expect(explorerParentIndex(rows, 3), 2);
      expect(explorerParentIndex(rows, 2), 0);
      expect(explorerParentIndex(rows, 0), -1);
      expect(explorerParentIndex(rows, 5), -1);
    });
  });

  group('path helpers', () {
    test('ancestors stop at the project root', () {
      expect(explorerAncestors('/proj/lib/src/a.dart', root: '/proj'), [
        '/proj/lib/src',
        '/proj/lib',
      ]);
      expect(explorerAncestors('/proj/README.md', root: '/proj'), isEmpty);
    });

    test('relative paths handle POSIX, Windows and outside paths', () {
      expect(explorerRelativePath('/proj/lib/a.dart', '/proj'), 'lib/a.dart');
      expect(explorerRelativePath(r'C:\proj\lib\a.dart', r'C:\proj'), 'lib/a.dart');
      expect(explorerRelativePath('/other/a.dart', '/proj'), isNull);
      expect(explorerRelativePath('/b.dart', '/'), 'b.dart');
    });

    test('join keeps the separator of the directory', () {
      expect(explorerJoin('/proj/lib', 'x.dart'), '/proj/lib/x.dart');
      expect(explorerJoin(r'C:\proj', 'x.dart'), r'C:\proj\x.dart');
    });

    test('sibling names are case-insensitive and support the root', () {
      expect(explorerSiblingNames(_tree, ''), {'lib', 'pkg', 'readme.md'});
      expect(explorerSiblingNames(_tree, '/proj/lib'), {'main.dart', 'src'});
    });
  });

  group('GitDecorations', () {
    final paths = explorerRelativePaths(_tree, '/proj');

    test('maps files, bubbles the strongest change up to folders', () {
      final d = GitDecorations.fromStatus({
        'modified': ['lib/main.dart'],
        'untracked': ['lib/src/a.dart'],
      }, paths);
      expect(d.of('lib/main.dart', isDirectory: false), GitDecoration.modified);
      expect(d.of('lib/src/a.dart', isDirectory: false), GitDecoration.untracked);
      expect(d.of('lib', isDirectory: true), GitDecoration.untracked);
      expect(d.of('README.md', isDirectory: false), isNull);
    });

    test('strips the repo prefix when the project is a sub-directory', () {
      final d = GitDecorations.fromStatus({
        'modified': ['apps/proj/lib/main.dart'],
      }, paths);
      expect(d.of('lib/main.dart', isDirectory: false), GitDecoration.modified);
    });

    test('an untracked directory marks everything below it', () {
      final d = GitDecorations.fromStatus({
        'untracked': ['pkg/'],
      }, paths);
      expect(d.of('pkg/inner/deep/x.ts', isDirectory: false), GitDecoration.untracked);
      expect(d.of('pkg', isDirectory: true), GitDecoration.untracked);
      expect(d.of('lib', isDirectory: true), isNull);
    });
  });

  group('ExplorerTree', () {
    late _FakeFiles files;
    late List<String> opened;

    Future<ProviderContainer> pump(
      WidgetTester tester, {
      Map<String, dynamic> git = const {},
    }) async {
      files = _FakeFiles();
      opened = [];
      await tester.pumpWidget(
        TranslationProvider(
          child: ProviderScope(
            overrides: [
              fileTreeRepositoryProvider.overrideWithValue(files),
              gitRepositoryProvider.overrideWithValue(_FakeGit(git)),
            ],
            child: MaterialApp(
              theme: AppTheme.light(),
              home: Scaffold(
                body: ExplorerTree(title: 'proj', onOpenFile: (n) => opened.add(n.path)),
              ),
            ),
          ),
        ),
      );
      final container = ProviderScope.containerOf(tester.element(find.byType(ExplorerTree)));
      container.read(fileTreeProvider.notifier).selectProject('p1');
      await tester.pumpAndSettle();
      return container;
    }

    testWidgets('renders compact rows and opens a file on click', (tester) async {
      await pump(tester);
      expect(find.text('PROJ'), findsOneWidget);
      expect(find.text('pkg/inner/deep'), findsOneWidget);
      await tester.tap(find.text('README.md'));
      await tester.pumpAndSettle();
      expect(opened, ['/proj/README.md']);
    });

    testWidgets('arrow keys move, expand and open like VS Code', (tester) async {
      final container = await pump(tester);
      await tester.tap(find.text('lib'));
      await tester.pumpAndSettle();
      expect(container.read(fileTreeProvider).expanded, contains('/proj/lib'));

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown); // main.dart
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(opened, ['/proj/lib/main.dart']);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft); // → lib
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft); // collapse lib
      await tester.pumpAndSettle();
      expect(container.read(fileTreeProvider).expanded, isNot(contains('/proj/lib')));

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight); // expand lib
      await tester.pumpAndSettle();
      expect(container.read(fileTreeProvider).expanded, contains('/proj/lib'));
    });

    testWidgets('F2 renames inline; Enter commits', (tester) async {
      await pump(tester);
      await tester.tap(find.text('README.md'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.f2);
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'NOTES.md');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(files.renames, ['/proj/README.md->NOTES.md']);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('inline rename refuses a sibling name and Escape cancels', (tester) async {
      await pump(tester);
      await tester.tap(find.text('README.md'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.f2);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'lib');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(files.renames, isEmpty);
      expect(find.byType(TextField), findsOneWidget, reason: 'box stays open on a clash');
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNothing);
      expect(files.renames, isEmpty);
    });

    testWidgets('New File from the header creates inside the selected folder', (tester) async {
      await pump(tester);
      await tester.tap(find.text('lib'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip(t.common.fileTree.context.newFile));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'util.dart');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(files.creates, ['file:/proj/lib:util.dart']);
      expect(opened, ['/proj/lib/util.dart']);
    });

    Future<void> pressWithControl(WidgetTester tester, LogicalKeyboardKey key) async {
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(key);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pumpAndSettle();
    }

    testWidgets('Ctrl+X then Ctrl+V on a folder moves the entry once', (tester) async {
      await pump(tester);
      await tester.tap(find.text('README.md'));
      await tester.pumpAndSettle();
      await pressWithControl(tester, LogicalKeyboardKey.keyX);
      await tester.tap(find.text('lib'));
      await tester.pumpAndSettle();
      await pressWithControl(tester, LogicalKeyboardKey.keyV);
      await pressWithControl(tester, LogicalKeyboardKey.keyV); // clipboard is spent
      expect(files.moves, ['/proj/README.md->/proj/lib']);
    });

    testWidgets('Ctrl+C then Ctrl+V on a root file copies into the root', (tester) async {
      await pump(tester);
      await tester.tap(find.text('lib'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('main.dart'));
      await tester.pumpAndSettle();
      await pressWithControl(tester, LogicalKeyboardKey.keyC);
      await tester.tap(find.text('README.md'));
      await tester.pumpAndSettle();
      await pressWithControl(tester, LogicalKeyboardKey.keyV);
      expect(files.copies, ['/proj/lib/main.dart->']);
      expect(files.moves, isEmpty);
    });

    Future<void> dragOnto(WidgetTester tester, String from, String to) async {
      final g = await tester.startGesture(
        tester.getCenter(find.text(from)),
        kind: PointerDeviceKind.mouse,
      );
      final target = tester.getCenter(find.text(to));
      final start = tester.getCenter(find.text(from));
      for (var i = 1; i <= 10; i++) {
        await g.moveTo(Offset.lerp(start, target, i / 10)!);
        await tester.pump(const Duration(milliseconds: 16));
      }
      await g.up();
      await tester.pumpAndSettle();
    }

    testWidgets('dragging a file onto a folder moves it after confirmation', (tester) async {
      await pump(tester);
      await dragOnto(tester, 'README.md', 'lib');
      expect(files.moves, isEmpty, reason: 'VS Code asks before a drag-and-drop move');
      await tester.tap(find.widgetWithText(AppButton, t.common.fileOperations.move));
      await tester.pumpAndSettle();
      expect(files.moves, ['/proj/README.md->/proj/lib']);
    });

    testWidgets('a folder cannot be dropped into itself', (tester) async {
      await pump(tester);
      await tester.tap(find.text('lib'));
      await tester.pumpAndSettle();
      await dragOnto(tester, 'lib', 'main.dart');
      expect(find.byType(AppButton), findsNothing);
      expect(files.moves, isEmpty);
    });

    testWidgets('git status colours rows with VS Code badges', (tester) async {
      await pump(
        tester,
        git: {
          'modified': ['README.md'],
          'untracked': ['lib/main.dart'],
        },
      );
      expect(find.text('M'), findsOneWidget);
      await tester.tap(find.text('lib'));
      await tester.pumpAndSettle();
      expect(find.text('U'), findsOneWidget);
    });
  });

  group('FileTreeScreen', () {
    late _FakeFiles files;

    Future<void> pumpScreen(WidgetTester tester) async {
      files = _FakeFiles();
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        TranslationProvider(
          child: ProviderScope(
            overrides: [
              fileTreeRepositoryProvider.overrideWithValue(files),
              gitRepositoryProvider.overrideWithValue(_FakeGit(const {})),
              projectsProvider.overrideWith(_Projects.new),
            ],
            child: MaterialApp(
              theme: AppTheme.light(),
              home: const Scaffold(body: FileTreeScreen(projectId: 'p1')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('side bar + empty editor; filter narrows, Enter searches contents', (tester) async {
      await pumpScreen(tester);
      expect(find.byType(ExplorerTree), findsOneWidget);
      expect(find.text(t.fileTree.noFileOpen), findsOneWidget);
      expect(find.text('README.md'), findsOneWidget);

      final filter = find.byType(TextField).first;
      await tester.enterText(filter, 'x.ts');
      await tester.pumpAndSettle();
      expect(find.text('README.md'), findsNothing);
      expect(files.searches, isEmpty, reason: 'typing filters names locally');

      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(files.searches, ['x.ts']);
      expect(find.text('void main() {}'), findsOneWidget);
      expect(find.byType(ExplorerTree), findsNothing);
    });

    testWidgets('on a phone a file opens in the editor screen; Back returns to Files', (
      tester,
    ) async {
      files = _FakeFiles();
      tester.view.physicalSize = const Size(390, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final router = GoRouter(
        initialLocation: '/files',
        routes: [
          GoRoute(
            path: '/files',
            builder: (_, _) => const Scaffold(body: FileTreeScreen(projectId: 'p1')),
          ),
          GoRoute(
            path: '/editor',
            builder: (_, s) => Scaffold(
              body: Text(
                'editor ${s.uri.queryParameters['projectId']} ${s.uri.queryParameters['file']}',
              ),
            ),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        TranslationProvider(
          child: ProviderScope(
            overrides: [
              fileTreeRepositoryProvider.overrideWithValue(files),
              gitRepositoryProvider.overrideWithValue(_FakeGit(const {})),
              projectsProvider.overrideWith(_Projects.new),
            ],
            child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('README.md'));
      await tester.pumpAndSettle();
      expect(find.textContaining('editor p1 '), findsOneWidget);
      expect(find.textContaining('README.md'), findsOneWidget);

      router.pop();
      await tester.pumpAndSettle();
      expect(find.byType(ExplorerTree), findsOneWidget);
    });

    testWidgets('a held right-click on a row opens a single menu', (tester) async {
      await pumpScreen(tester);
      final g = await tester.startGesture(
        tester.getCenter(find.text('README.md')),
        kind: PointerDeviceKind.mouse,
        buttons: kSecondaryButton,
      );
      await tester.pump(const Duration(milliseconds: 300));
      await g.up();
      await tester.pumpAndSettle();
      expect(find.text(t.common.fileTree.context.rename), findsOneWidget);
      expect(find.text(t.common.fileTree.context.newFolder), findsNothing);
    });
  });

  test('editor tabs follow a moved folder and keep their buffers', () async {
    final container = ProviderContainer(
      overrides: [fileTreeRepositoryProvider.overrideWithValue(_FakeFiles())],
    );
    addTearDown(container.dispose);
    final editor = container.read(editorProvider.notifier);
    await editor.open('p1', '/proj/lib/src/a.dart', load: false);
    await editor.open('p1', '/proj/README.md', load: false);
    editor.activate(EditorController.tabId('p1', '/proj/lib/src/a.dart'));
    editor.updateContent(EditorController.tabId('p1', '/proj/lib/src/a.dart'), 'edited');

    editor.retarget('p1', '/proj/lib', '/proj/pkg/lib');

    final state = container.read(editorProvider);
    expect(state.tabs.map((t) => t.path), ['/proj/pkg/lib/src/a.dart', '/proj/README.md']);
    expect(state.active!.path, '/proj/pkg/lib/src/a.dart');
    expect(state.active!.content, 'edited');
  });
}
