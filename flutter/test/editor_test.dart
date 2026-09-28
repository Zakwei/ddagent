import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/editor/state/editor_controller.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
  Future<List<FileTreeNode>> listFiles(
    String projectId, {
    bool respectGitignore = true,
  }) async => tree;

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

ProviderContainer container(FileTreeRepository repo) => ProviderContainer(
  overrides: [fileTreeRepositoryProvider.overrideWithValue(repo)],
);

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
      c.read(editorProvider.notifier).updateContent(EditorController.tabId('p1', '/a.dart'), 'edited');
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
      expect(await c.read(editorProvider.notifier).save(EditorController.tabId('p1', '/a.dart')), isTrue);
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
              onPressed: () async => result = await confirmCloseTab(
                ctx,
                c.read(editorProvider).active!,
              ),
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
      c.read(editorProvider.notifier).updateContent(EditorController.tabId('p1', '/a.dart'), 'edited');
      late bool result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) => TextButton(
              onPressed: () async => result = await confirmCloseTab(
                ctx,
                c.read(editorProvider).active!,
              ),
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
