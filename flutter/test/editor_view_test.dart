import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/widgets/app_markdown.dart';
import 'package:ddagent_app/features/editor/data/editor_file_kind.dart';
import 'package:ddagent_app/features/editor/data/line_diff.dart';
import 'package:ddagent_app/features/editor/state/editor_controller.dart';
import 'package:ddagent_app/features/editor/view/code_editor.dart';
import 'package:ddagent_app/features/editor/view/editor_screen.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_repository.dart';
import 'package:ddagent_app/features/git/data/git_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'editor_test.dart' show FakeFileTreeRepository;

class FakeGitRepository extends GitRepository {
  FakeGitRepository() : super(Dio());

  Map<String, dynamic> diffResult = const {
    'oldContent': '',
    'currentContent': '',
    'isDeleted': false,
    'isUntracked': false,
  };
  Object? diffError;
  final discards = <String>[];
  Map<String, dynamic>? statusResult;
  Object? statusError;

  @override
  Future<Map<String, dynamic>> status(String projectId) async {
    if (statusError != null) throw statusError!;
    return statusResult ??
        const {
          'modified': <String>[],
          'added': <String>[],
          'deleted': <String>[],
          'untracked': <String>[],
          'staged': <String>[],
        };
  }

  @override
  Future<Map<String, dynamic>> fileWithDiff(
    String projectId,
    String filePath,
  ) async {
    if (diffError != null) throw diffError!;
    return diffResult;
  }

  @override
  Future<Map<String, dynamic>> discard(
    String projectId,
    String filePath,
  ) async {
    discards.add('$projectId:$filePath');
    return {'success': true};
  }
}

Widget _app({
  required FakeFileTreeRepository files,
  required FakeGitRepository git,
  required Widget child,
}) => ProviderScope(
  overrides: [
    fileTreeRepositoryProvider.overrideWithValue(files),
    gitRepositoryProvider.overrideWithValue(git),
  ],
  child: MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(body: child),
  ),
);

Future<void> _pumpScreen(
  WidgetTester tester,
  FakeFileTreeRepository files,
  FakeGitRepository git, {
  String projectId = 'p1',
  String file = '/a.dart',
}) async {
  await tester.pumpWidget(
    _app(
      files: files,
      git: git,
      child: EditorScreen(projectId: projectId, filePath: file),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  late FakeFileTreeRepository files;
  late FakeGitRepository git;

  setUpAll(() async {
    Hive.init('/tmp/ddagent_test_hive_editor_view');
    if (!Hive.isBoxOpen('settings')) await Hive.openBox<dynamic>('settings');
  });

  setUp(() {
    files = FakeFileTreeRepository();
    git = FakeGitRepository();
    // Default settings — the box may hold values from earlier runs.
    Hive.box<dynamic>('settings').delete('editor_settings');
  });

  group('computeLineDiff', () {
    test('identical inputs produce a single context segment', () {
      final d = computeLineDiff('a\nb\nc', 'a\nb\nc');
      expect(d.hasChanges, isFalse);
      expect(d.merged(), 'a\nb\nc');
    });

    test('insertion, deletion and edit each become change segments', () {
      final d = computeLineDiff('a\nb\nc', 'a\nx\nc\nd');
      // 'c' stays as context between the two hunks.
      expect(d.changes, hasLength(2));
      expect(d.changes.first.removed, ['b']);
      expect(d.changes.first.added, ['x']);
      expect(d.changes.last.added, ['d']);
      expect(d.addedCount, 2);
      expect(d.removedCount, 1);
      expect(d.merged(), 'a\nx\nc\nd');
    });

    test('merged honors per-hunk useOld choice', () {
      final d = computeLineDiff('a\nb\nc\nd', 'a\nB\nc\nD');
      expect(d.changes, hasLength(2));
      d.changes.first.useOld = true;
      expect(d.merged(), 'a\nb\nc\nD');
    });

    test('trailing newline round-trips', () {
      final d = computeLineDiff('a\n', 'a\nb\n');
      expect(d.merged(), 'a\nb\n');
    });
  });

  group('editorFileKind', () {
    test('classifies markdown, image, media, binary and text', () {
      expect(editorFileKind('x.md'), EditorFileKind.markdown);
      expect(editorFileKind('x.png'), EditorFileKind.image);
      expect(editorFileKind('x.mp4'), EditorFileKind.media);
      expect(editorFileKind('x.zip'), EditorFileKind.binary);
      expect(editorFileKind('x.dart'), EditorFileKind.text);
    });

    test('editorLanguage maps extensions, null for unknown', () {
      expect(editorLanguage('a.dart'), 'dart');
      expect(editorLanguage('a.py'), 'python');
      expect(editorLanguage('Dockerfile'), 'dockerfile');
      expect(editorLanguage('a.unknownext'), isNull);
    });
  });

  group('EditorScreen', () {
    testWidgets('opens file from route params, shows tabs and line numbers', (
      tester,
    ) async {
      files.files['p1:/a.dart'] = 'line one\nline two';
      await _pumpScreen(tester, files, git);
      expect(find.text('a.dart'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.byType(CodeEditor), findsOneWidget);
    });

    testWidgets('typing marks the tab dirty; Ctrl+S saves', (tester) async {
      files.files['p1:/a.dart'] = 'orig';
      await _pumpScreen(tester, files, git);
      await tester.enterText(find.byType(TextField), 'edited');
      await tester.pump();
      // Dirty dot on the tab chip.
      expect(find.byIcon(Icons.circle), findsOneWidget);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyS);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyS);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pumpAndSettle();
      expect(files.files['p1:/a.dart'], 'edited');
    });

    testWidgets('Ctrl+Tab cycles to the next tab', (tester) async {
      files.files['p1:/a.dart'] = 'a';
      files.files['p1:/b.dart'] = 'b';
      await tester.pumpWidget(
        _app(
          files: files,
          git: git,
          child: const EditorScreen(projectId: 'p1', filePath: '/a.dart'),
        ),
      );
      await tester.pumpAndSettle();
      final element = tester.element(find.byType(EditorScreen));
      final container = ProviderScope.containerOf(element);
      await container.read(editorProvider.notifier).open('p1', '/b.dart');
      await tester.pumpAndSettle();
      expect(container.read(editorProvider).active!.path, '/b.dart');
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();
      expect(container.read(editorProvider).active!.path, '/a.dart');
    });

    testWidgets('markdown file toggles to rendered preview', (tester) async {
      files.files['p1:/r.md'] = '# Title';
      await _pumpScreen(tester, files, git, file: '/r.md');
      await tester.tap(find.byTooltip('Preview'));
      await tester.pumpAndSettle();
      expect(find.byType(AppMarkdown), findsOneWidget);
      await tester.tap(find.byTooltip('Edit'));
      await tester.pumpAndSettle();
      expect(find.byType(CodeEditor), findsOneWidget);
    });

    testWidgets('binary file shows the info card instead of an editor', (
      tester,
    ) async {
      await _pumpScreen(tester, files, git, file: '/a.zip');
      expect(find.text('Binary file'), findsOneWidget);
      expect(find.byType(CodeEditor), findsNothing);
      // Blob fetch fails against the fake repo → error line appears.
      await tester.pumpAndSettle();
    });

    testWidgets('minimap setting toggles the rail', (tester) async {
      files.files['p1:/a.dart'] = 'x';
      await tester.pumpWidget(
        _app(files: files, git: git, child: const _MinimapToggle()),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('editor-minimap')), findsOneWidget);
      await tester.tap(find.text('toggle'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('editor-minimap')), findsNothing);
    });

    testWidgets('diff view shows hunks and applies merged content', (
      tester,
    ) async {
      files.files['p1:/a.dart'] = 'new line';
      git.diffResult = const {
        'oldContent': 'old line',
        'currentContent': 'new line',
        'isDeleted': false,
        'isUntracked': false,
      };
      await _pumpScreen(tester, files, git);
      await tester.tap(find.byTooltip('Diff / merge'));
      await tester.pumpAndSettle();
      expect(find.text('- old line', findRichText: true), findsOneWidget);
      expect(find.text('+ new line', findRichText: true), findsOneWidget);
      expect(find.text('Hunk 1'), findsOneWidget);
      await tester.tap(find.text('Apply merge'));
      await tester.pumpAndSettle();
      // Back to the editor, buffer unchanged (current side kept).
      expect(find.byType(CodeEditor), findsOneWidget);
    });

    testWidgets('diff falls back to saved content without git', (tester) async {
      files.files['p1:/a.dart'] = 'disk';
      git.diffError = Exception('not a git repo');
      await _pumpScreen(tester, files, git);
      await tester.tap(find.byTooltip('Diff / merge'));
      await tester.pumpAndSettle();
      expect(find.textContaining('no git'), findsOneWidget);
    });

    testWidgets('dock lists changed files; tap opens tab with diff', (
      tester,
    ) async {
      files.files['p1:/a.dart'] = 'x';
      files.files['p1:/changed.dart'] = 'mod';
      git.statusResult = const {
        'modified': ['/changed.dart'],
        'added': <String>[],
        'deleted': <String>[],
        'untracked': <String>[],
        'staged': <String>[],
      };
      await _pumpScreen(tester, files, git);
      expect(find.text('Changed files'), findsOneWidget);
      expect(find.text('1'), findsWidgets); // change counter
      await tester.tap(find.text('changed.dart'));
      await tester.pumpAndSettle();
      final element = tester.element(find.byType(EditorScreen));
      final container = ProviderScope.containerOf(element);
      expect(container.read(editorProvider).active!.path, '/changed.dart');
      // Diff surface opened for the tapped file.
      expect(find.textContaining('Hunk'), findsWidgets);
    });

    testWidgets('dock file tree row opens the file in a tab', (tester) async {
      files.files['p1:/a.dart'] = 'x';
      files.files['p1:/b.dart'] = 'y';
      files.tree = const [
        FileTreeNode(name: 'b.dart', path: '/b.dart', isDirectory: false),
      ];
      await _pumpScreen(tester, files, git);
      await tester.tap(find.text('b.dart'));
      await tester.pumpAndSettle();
      final element = tester.element(find.byType(EditorScreen));
      final container = ProviderScope.containerOf(element);
      expect(container.read(editorProvider).active!.path, '/b.dart');
      expect(container.read(editorProvider).active!.content, 'y');
    });
  });
}

/// Wraps EditorScreen so the test can flip the persisted minimap setting.
class _MinimapToggle extends ConsumerWidget {
  const _MinimapToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Expanded(
          child: EditorScreen(projectId: 'p1', filePath: '/a.dart'),
        ),
        TextButton(
          onPressed: () =>
              ref.read(editorSettingsProvider.notifier).toggleMinimap(),
          child: const Text('toggle'),
        ),
      ],
    );
  }
}
