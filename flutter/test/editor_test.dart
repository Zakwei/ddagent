import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/features/editor/state/editor_controller.dart';
import 'package:ddagent_app/features/editor/view/code_editor.dart';
import 'package:ddagent_app/features/editor/view/editor_diff_view.dart';
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

class FakeFileTreeRepository extends FileTreeRepository {
  FakeFileTreeRepository() : super(Dio());

  final files = <String, String>{};
  final saves = <String>[];
  Object? readError;
  List<FileTreeNode> tree = const [];

  String _key(String projectId, String path) => '$projectId:$path';

  @override
  Future<List<FileTreeNode>> listFiles(String projectId, {bool respectGitignore = true}) async =>
      tree;

  @override
  Future<String> readFile(String projectId, String filePath) async {
    if (readError != null) throw readError!;
    final key = _key(projectId, filePath);
    if (!files.containsKey(key)) throw const ServerError('not found', 404);
    return files[key]!;
  }

  @override
  Future<void> saveFile(String projectId, String filePath, String content) async {
    files[_key(projectId, filePath)] = content;
    saves.add(_key(projectId, filePath));
  }
}

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
  Future<Map<String, dynamic>> fileWithDiff(String projectId, String filePath) async {
    if (diffError != null) throw diffError!;
    return diffResult;
  }

  @override
  Future<Map<String, dynamic>> discard(String projectId, String filePath) async {
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

ProviderContainer container(FileTreeRepository repo) =>
    ProviderContainer(overrides: [fileTreeRepositoryProvider.overrideWithValue(repo)]);

void main() {
  late FakeFileTreeRepository repo;
  late ProviderContainer c;

  setUpAll(() async {
    Hive.init('/tmp/ddagent_test_hive_editor');
    if (!Hive.isBoxOpen('settings')) await Hive.openBox<dynamic>('settings');
  });

  setUp(() {
    repo = FakeFileTreeRepository();
    c = container(repo);
  });

  tearDown(() => c.dispose());

  group('tabs', () {
    test('open loads content and activates the tab', () async {
      repo.files['p1:/a.dart'] = 'void main() {}';
      await c.read(editorProvider.notifier).open('p1', '/a.dart');
      expect(c.read(editorProvider).tabs, hasLength(1));
      expect(c.read(editorProvider).active!.path, '/a.dart');
      expect(c.read(editorProvider).active!.content, 'void main() {}');
      expect(c.read(editorProvider).active!.isDirty, isFalse);
    });

    test('open dedupes: same file activates the existing tab', () async {
      repo.files['p1:/a.dart'] = 'x';
      await c.read(editorProvider.notifier).open('p1', '/a.dart');
      await c.read(editorProvider.notifier).open('p1', '/a.dart');
      expect(c.read(editorProvider).tabs, hasLength(1));
    });

    test('same path in another project is a separate tab', () async {
      repo.files['p1:/a.dart'] = '1';
      repo.files['p2:/a.dart'] = '2';
      await c.read(editorProvider.notifier).open('p1', '/a.dart');
      await c.read(editorProvider.notifier).open('p2', '/a.dart');
      expect(c.read(editorProvider).tabs, hasLength(2));
      expect(c.read(editorProvider).active!.projectId, 'p2');
    });

    test('activate switches the active tab', () async {
      repo.files['p1:/a.dart'] = repo.files['p1:/b.dart'] = 'x';
      await c.read(editorProvider.notifier).open('p1', '/a.dart');
      await c.read(editorProvider.notifier).open('p1', '/b.dart');
      c.read(editorProvider.notifier).activate(EditorController.tabId('p1', '/a.dart'));
      expect(c.read(editorProvider).active!.path, '/a.dart');
    });

    test('close falls back to the last remaining tab', () async {
      repo.files['p1:/a.dart'] = repo.files['p1:/b.dart'] = 'x';
      await c.read(editorProvider.notifier).open('p1', '/a.dart');
      await c.read(editorProvider.notifier).open('p1', '/b.dart');
      c.read(editorProvider.notifier).close(EditorController.tabId('p1', '/b.dart'));
      expect(c.read(editorProvider).tabs, hasLength(1));
      expect(c.read(editorProvider).active!.path, '/a.dart');
    });

    test('read error lands on the tab instead of throwing', () async {
      await c.read(editorProvider.notifier).open('p1', '/missing.dart');
      expect(c.read(editorProvider).active!.error, isA<ServerError>());
      expect(c.read(editorProvider).active!.loading, isFalse);
    });
  });

  group('dirty + save', () {
    setUp(() async {
      repo.files['p1:/a.dart'] = 'original';
      await c.read(editorProvider.notifier).open('p1', '/a.dart');
    });

    test('updateContent marks the tab dirty; hasUnsavedChanges tracks it', () {
      expect(c.read(editorProvider).hasUnsavedChanges, isFalse);
      c
          .read(editorProvider.notifier)
          .updateContent(EditorController.tabId('p1', '/a.dart'), 'edited');
      expect(c.read(editorProvider).active!.isDirty, isTrue);
      expect(c.read(editorProvider).hasUnsavedChanges, isTrue);
    });

    test('updateContent back to saved clears the dirty flag', () {
      final id = EditorController.tabId('p1', '/a.dart');
      c.read(editorProvider.notifier).updateContent(id, 'edited');
      c.read(editorProvider.notifier).updateContent(id, 'original');
      expect(c.read(editorProvider).active!.isDirty, isFalse);
    });

    test('save writes via the repository and clears dirty', () async {
      final id = EditorController.tabId('p1', '/a.dart');
      c.read(editorProvider.notifier).updateContent(id, 'edited');
      expect(await c.read(editorProvider.notifier).save(id), isTrue);
      expect(repo.files['p1:/a.dart'], 'edited');
      expect(c.read(editorProvider).active!.isDirty, isFalse);
    });

    test('save is a no-op on a clean tab', () async {
      expect(
        await c.read(editorProvider.notifier).save(EditorController.tabId('p1', '/a.dart')),
        isTrue,
      );
      expect(repo.saves, isEmpty);
    });

    test('saveAll persists every dirty tab and reports failure', () async {
      repo.files['p1:/b.dart'] = 'b';
      await c.read(editorProvider.notifier).open('p1', '/b.dart');
      c.read(editorProvider.notifier).updateContent(EditorController.tabId('p1', '/a.dart'), 'a2');
      c.read(editorProvider.notifier).updateContent(EditorController.tabId('p1', '/b.dart'), 'b2');
      expect(await c.read(editorProvider.notifier).saveAll(), isTrue);
      expect(repo.files['p1:/a.dart'], 'a2');
      expect(repo.files['p1:/b.dart'], 'b2');
      expect(c.read(editorProvider).hasUnsavedChanges, isFalse);
    });

    test('reload discards local edits', () async {
      final id = EditorController.tabId('p1', '/a.dart');
      c.read(editorProvider.notifier).updateContent(id, 'edited');
      await c.read(editorProvider.notifier).reload(id);
      expect(c.read(editorProvider).active!.content, 'original');
      expect(c.read(editorProvider).active!.isDirty, isFalse);
    });
  });

  group('close confirmation', () {
    testWidgets('clean tab closes without a dialog', (tester) async {
      repo.files['p1:/a.dart'] = 'x';
      await c.read(editorProvider.notifier).open('p1', '/a.dart');
      late bool result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => TextButton(
              onPressed: () async =>
                  result = await confirmCloseTab(ctx, c.read(editorProvider).active!),
              child: const Text('go'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('go'));
      await tester.pump();
      expect(result, isTrue);
    });

    testWidgets('dirty tab asks; cancel keeps it open', (tester) async {
      repo.files['p1:/a.dart'] = 'x';
      await c.read(editorProvider.notifier).open('p1', '/a.dart');
      c
          .read(editorProvider.notifier)
          .updateContent(EditorController.tabId('p1', '/a.dart'), 'edited');
      late bool result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => TextButton(
              onPressed: () async =>
                  result = await confirmCloseTab(ctx, c.read(editorProvider).active!),
              child: const Text('go'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();
      expect(find.text('Discard unsaved changes?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(result, isFalse);
    });

    testWidgets('dirty tab asks; discard closes', (tester) async {
      repo.files['p1:/a.dart'] = 'x';
      await c.read(editorProvider.notifier).open('p1', '/a.dart');
      c
          .read(editorProvider.notifier)
          .updateContent(EditorController.tabId('p1', '/a.dart'), 'edited');
      late bool result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => TextButton(
              onPressed: () async =>
                  result = await confirmCloseTab(ctx, c.read(editorProvider).active!),
              child: const Text('go'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();
      expect(find.text('Discard unsaved changes?'), findsOneWidget);
      await tester.tap(find.text('Discard'));
      await tester.pumpAndSettle();
      expect(result, isTrue);
    });
  });

  group('full lifecycle', () {
    testWidgets(
      'open -> edit -> dirty indicator -> save -> unsaved warning on close -> reload -> tab switching -> diff view',
      (tester) async {
        final git = FakeGitRepository();
        repo.files['p1:/file1.dart'] = 'line 1\nline 2';
        repo.files['p1:/file2.dart'] = 'alpha\nbeta';
        git.diffResult = {
          'oldContent': 'line 1\nline 2',
          'currentContent': 'line 1\nline 2 edited\nline 3',
          'isDeleted': false,
          'isUntracked': false,
        };

        // 1. Otwórz plik
        await tester.pumpWidget(
          _app(
            files: repo,
            git: git,
            child: const EditorScreen(projectId: 'p1', filePath: '/file1.dart'),
          ),
        );
        await tester.pumpAndSettle();

        final element = tester.element(find.byType(EditorScreen));
        final container = ProviderScope.containerOf(element);

        expect(find.text('file1.dart'), findsOneWidget);
        expect(find.byType(CodeEditor), findsOneWidget);
        expect(container.read(editorProvider).active!.path, '/file1.dart');
        expect(container.read(editorProvider).active!.isDirty, isFalse);
        expect(container.read(editorProvider).hasUnsavedChanges, isFalse);
        expect(find.byIcon(Icons.circle), findsNothing);
        expect(find.textContaining('2 lines'), findsOneWidget);

        // 2. Edytuj treść
        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);
        await tester.enterText(textField, 'line 1\nline 2 edited\nline 3');
        await tester.pump();

        // 3. Sprawdzenie wskaźnika dirty
        expect(container.read(editorProvider).active!.isDirty, isTrue);
        expect(container.read(editorProvider).hasUnsavedChanges, isTrue);
        expect(find.byIcon(Icons.circle), findsOneWidget);
        expect(find.textContaining('modified'), findsOneWidget);

        // 4. Zapis pliku
        await tester.tap(find.widgetWithText(AppButton, 'Save'));
        await tester.pumpAndSettle();

        expect(repo.files['p1:/file1.dart'], 'line 1\nline 2 edited\nline 3');
        expect(container.read(editorProvider).active!.isDirty, isFalse);
        expect(container.read(editorProvider).hasUnsavedChanges, isFalse);
        expect(find.byIcon(Icons.circle), findsNothing);
        expect(find.textContaining('modified'), findsNothing);

        // 5. Sprawdzenie ostrzeżenia o niezapisanych zmianach przy zamknięciu/reloadzie
        // Ponowna edycja
        await tester.enterText(textField, 'line 1\nline 2 edited\nline 3 modified again');
        await tester.pump();
        expect(container.read(editorProvider).active!.isDirty, isTrue);
        expect(find.byIcon(Icons.circle), findsOneWidget);

        // Próba zamknięcia karty - pojawia się dialog ostrzeżenia
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();
        expect(find.text('Unsaved changes in file1.dart'), findsOneWidget);
        expect(find.text('Discard unsaved changes?'), findsOneWidget);

        // Wybór Cancel - anulowanie zamknięcia, karta pozostaje otwarta i dirty
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(find.text('Discard unsaved changes?'), findsNothing);
        expect(find.text('file1.dart'), findsOneWidget);
        expect(container.read(editorProvider).active!.isDirty, isTrue);

        // Reload z dysku przywraca zapisaną treść i czyści stan dirty
        await tester.tap(find.byTooltip('Reload from disk'));
        await tester.pumpAndSettle();
        expect(container.read(editorProvider).active!.content, 'line 1\nline 2 edited\nline 3');
        expect(container.read(editorProvider).active!.isDirty, isFalse);
        expect(find.byIcon(Icons.circle), findsNothing);

        // 6. Przełączanie kart
        // Otwórz drugi plik
        await container.read(editorProvider.notifier).open('p1', '/file2.dart');
        await tester.pumpAndSettle();

        expect(find.text('file1.dart'), findsOneWidget);
        expect(find.text('file2.dart'), findsOneWidget);
        expect(container.read(editorProvider).active!.path, '/file2.dart');

        // Kliknięcie w kartę file1.dart
        await tester.tap(find.text('file1.dart'));
        await tester.pumpAndSettle();
        expect(container.read(editorProvider).active!.path, '/file1.dart');

        // Przełączanie kart skrótem Ctrl+Tab
        await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
        await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
        await tester.pump();
        expect(container.read(editorProvider).active!.path, '/file2.dart');

        // 7. Renderowanie widoku diff
        // Przełącz na file1.dart
        await tester.tap(find.text('file1.dart'));
        await tester.pumpAndSettle();
        expect(container.read(editorProvider).active!.path, '/file1.dart');

        // Uruchomienie widoku diff
        final diffBtn = find.byTooltip('Diff / merge');
        expect(diffBtn, findsOneWidget);
        await tester.tap(diffBtn);
        await tester.pumpAndSettle();

        // Weryfikacja renderowania komponentu Diff View
        expect(find.byType(EditorDiffView), findsOneWidget);
        expect(find.text('HEAD vs working copy'), findsOneWidget);
        expect(find.text('Hunk 1'), findsOneWidget);
        expect(find.text('Apply merge'), findsOneWidget);

        // Zamknięcie diff view
        await tester.tap(find.byTooltip('Close diff'));
        await tester.pumpAndSettle();
        expect(find.byType(EditorDiffView), findsNothing);
        expect(find.byType(CodeEditor), findsOneWidget);
      },
    );
  });

  group('settings', () {
    test('defaults and persistence', () async {
      await Hive.box<dynamic>('settings').delete('editor_settings');
      final s = ProviderContainer();
      addTearDown(s.dispose);
      expect(s.read(editorSettingsProvider).fontSize, 13.0);
      expect(s.read(editorSettingsProvider).wordWrap, isTrue);
      expect(s.read(editorSettingsProvider).tabSize, 2);
      expect(s.read(editorSettingsProvider).minimap, isTrue);

      final sc = s.read(editorSettingsProvider.notifier);
      sc.setFontSize(18);
      sc.setWordWrap(false);
      sc.setTabSize(4);
      sc.toggleMinimap();

      final s2 = ProviderContainer();
      addTearDown(s2.dispose);
      expect(s2.read(editorSettingsProvider).fontSize, 18.0);
      expect(s2.read(editorSettingsProvider).wordWrap, isFalse);
      expect(s2.read(editorSettingsProvider).tabSize, 4);
      expect(s2.read(editorSettingsProvider).minimap, isFalse);
    });
  });
}
