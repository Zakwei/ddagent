import 'dart:convert';
import 'dart:io';

import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_repository.dart';
import 'package:ddagent_app/features/file_tree/state/file_tree_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

/// Queued-response adapter (same trick as api_client_test.dart).
class _FakeAdapter implements HttpClientAdapter {
  final List<ResponseBody Function(RequestOptions)> queue = [];

  void respondJson(Object data) => queue.add((_) => ResponseBody.fromString(jsonEncode(data), 200));

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) => Future.value(queue.removeAt(0)(options));

  @override
  void close({bool force = false}) {}
}

/// Realistic `/projects/:id/files` payload — bare array, nested children,
/// the metadata fields the server fills via lstat.
const _treeJson = [
  {
    'name': 'lib',
    'path': '/proj/lib',
    'type': 'directory',
    'size': 4096,
    'modified': '2026-01-02T10:00:00.000Z',
    'permissions': '755',
    'permissionsRwx': 'rwxr-xr-x',
    'children': [
      {
        'name': 'main.dart',
        'path': '/proj/lib/main.dart',
        'type': 'file',
        'size': 1536,
        'modified': '2026-01-02T10:00:00.000Z',
        'permissions': '644',
        'permissionsRwx': 'rw-r--r--',
      },
      {
        'name': 'src',
        'path': '/proj/lib/src',
        'type': 'directory',
        'size': 4096,
        'modified': null,
        'permissions': '755',
        'permissionsRwx': 'rwxr-xr-x',
        'children': [
          {
            'name': 'a.dart',
            'path': '/proj/lib/src/a.dart',
            'type': 'file',
            'size': 0,
            'modified': null,
            'permissions': '644',
            'permissionsRwx': 'rw-r--r--',
          },
        ],
      },
    ],
  },
  {
    'name': 'README.md',
    'path': '/proj/README.md',
    'type': 'file',
    'size': 2048,
    'modified': '2026-01-01T00:00:00.000Z',
    'permissions': '644',
    'permissionsRwx': 'rw-r--r--',
    'isSymlink': true,
  },
];

void main() {
  group('decodeFileTree', () {
    test('decodes bare array with nested children and metadata', () {
      final nodes = decodeFileTree(jsonDecode(jsonEncode(_treeJson)));
      expect(nodes, hasLength(2));
      final lib = nodes.first;
      expect(lib.isDirectory, isTrue);
      expect(lib.path, '/proj/lib');
      expect(lib.children, hasLength(2));
      expect(lib.children[1].children.single.name, 'a.dart');
      final readme = nodes.last;
      expect(readme.isDirectory, isFalse);
      expect(readme.isSymlink, isTrue);
      expect(readme.modified, isNotNull);
    });

    test('repository.listFiles decodes the bare-array response', () async {
      final adapter = _FakeAdapter()..respondJson(_treeJson);
      final dio = Dio(BaseOptions(baseUrl: 'http://test'))..httpClientAdapter = adapter;
      final repo = FileTreeRepository(dio);
      final nodes = await repo.listFiles('p1');
      expect(nodes, hasLength(2));
      expect(nodes.first.children[1].path, '/proj/lib/src');
    });

    test('repository.listFiles tolerates envelope-wrapped payload', () async {
      final adapter = _FakeAdapter()..respondJson({'success': true, 'data': _treeJson});
      final dio = Dio(BaseOptions(baseUrl: 'http://test'))..httpClientAdapter = adapter;
      final nodes = await FileTreeRepository(dio).listFiles('p1');
      expect(nodes.first.name, 'lib');
    });

    test('decodeSearchResult parses {results, truncated}', () {
      final res = decodeSearchResult({
        'results': [
          {'path': '/proj/lib/main.dart', 'line': 4, 'column': 2, 'text': 'void main()'},
        ],
        'truncated': true,
      });
      expect(res.truncated, isTrue);
      expect(res.matches.single.line, 4);
      expect(decodeSearchResult(null).matches, isEmpty);
    });
  });

  group('flattenVisible', () {
    final roots = decodeFileTree(jsonDecode(jsonEncode(_treeJson)));

    test('collapsed shows only roots', () {
      final flat = flattenVisible(roots, {});
      expect(flat.map((f) => f.node.name), ['lib', 'README.md']);
      expect(flat.map((f) => f.depth), [0, 0]);
    });

    test('expanded dirs reveal children at increasing depth', () {
      final flat = flattenVisible(roots, {'/proj/lib', '/proj/lib/src'});
      expect(flat.map((f) => f.node.name), ['lib', 'main.dart', 'src', 'a.dart', 'README.md']);
      expect(flat.map((f) => f.depth), [0, 1, 1, 2, 0]);
    });

    test('collapsed parent hides grandchildren even if expanded', () {
      final flat = flattenVisible(roots, {'/proj/lib/src'});
      expect(flat.map((f) => f.node.name), ['lib', 'README.md']);
    });
  });

  group('filterFileTree + collectExpandedDirectoryPaths', () {
    final roots = decodeFileTree(jsonDecode(jsonEncode(_treeJson)));

    test('keeps matching files and their ancestors', () {
      final filtered = filterFileTree(roots, 'a.dart');
      expect(filtered, hasLength(1));
      expect(filtered.single.name, 'lib');
      expect(filtered.single.children.single.name, 'src');
      expect(filtered.single.children.single.children.single.name, 'a.dart');
    });

    test('expanded paths cover every directory in the filtered subtree', () {
      final filtered = filterFileTree(roots, 'a.dart');
      expect(collectExpandedDirectoryPaths(filtered), {'/proj/lib', '/proj/lib/src'});
    });
  });

  group('deep tree filters (single-pass)', () {
    FileTreeNode chain(int depth, {required bool leafRecent}) {
      var node = FileTreeNode(
        name: 'leaf.txt',
        path: '/p/leaf.txt',
        isDirectory: false,
        modified: leafRecent ? DateTime.now().toIso8601String() : null,
      );
      for (var i = depth; i > 0; i--) {
        node = FileTreeNode(name: 'd$i', path: '/p/d$i', isDirectory: true, children: [node]);
      }
      return node;
    }

    // The old double-recursion needed ~2^depth calls; depth 30 would hang.
    test('filterFileTree walks a deep chain', () {
      final filtered = filterFileTree([chain(30, leafRecent: false)], 'leaf');
      expect(filtered, hasLength(1));
      var cur = filtered.single;
      var depth = 0;
      while (cur.children.isNotEmpty) {
        cur = cur.children.single;
        depth++;
      }
      expect(cur.name, 'leaf.txt');
      expect(depth, 30);
    });

    test('filterFileTreeByModified walks a deep chain', () {
      final since = DateTime.now().subtract(const Duration(days: 7));
      final filtered = filterFileTreeByModified([chain(30, leafRecent: true)], since);
      expect(filtered, hasLength(1));
      expect(filtered.single.children, isNotEmpty);
    });
  });

  group('formatting helpers', () {
    test('formatFileSize', () {
      expect(formatFileSize(0), '0 B');
      expect(formatFileSize(512), '512 B');
      expect(formatFileSize(1536), '1.5 KB');
      expect(formatFileSize(2 * 1024 * 1024), '2 MB');
    });

    test('isImageFile', () {
      expect(isImageFile('a.PNG'), isTrue);
      expect(isImageFile('a.dart'), isFalse);
      expect(isImageFile('noext'), isFalse);
    });
  });

  group('view-mode persistence', () {
    late Directory dir;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('file_tree_test');
      Hive.init(dir.path);
      await Hive.openBox<dynamic>('settings');
    });

    tearDown(() async {
      await Hive.close();
      await dir.delete(recursive: true);
    });

    test('defaults to detailed, persists selection', () async {
      expect(readFileTreeViewMode(), FileTreeViewMode.detailed);
      persistFileTreeViewMode(FileTreeViewMode.compact);
      expect(Hive.box<dynamic>('settings').get(kFileTreeViewModeKey), 'compact');
      expect(readFileTreeViewMode(), FileTreeViewMode.compact);
    });

    test('unknown stored value falls back to default', () async {
      await Hive.box<dynamic>('settings').put(kFileTreeViewModeKey, 'bogus');
      expect(readFileTreeViewMode(), kDefaultFileTreeViewMode);
    });
  });
}
