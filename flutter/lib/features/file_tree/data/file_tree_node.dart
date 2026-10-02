import 'dart:convert';

// File-tree domain model + pure tree helpers.
// Mirrors `FileTreeNode` in server/shared/types.ts and ports the pure parts
// of src/components/file-tree/utils/fileTreeUtils.ts.

/// One filesystem item returned by `/api/file-tree`.
class FileTreeNode {
  const FileTreeNode({
    required this.name,
    required this.path,
    required this.isDirectory,
    this.size = 0,
    this.modified,
    this.permissionsRwx = '',
    this.isSymlink = false,
    this.children = const [],
  });

  final String name;
  final String path;
  final bool isDirectory;
  final int size;
  final String? modified;
  final String permissionsRwx;
  final bool isSymlink;
  final List<FileTreeNode> children;

  FileTreeNode copyWith({List<FileTreeNode>? children}) => FileTreeNode(
    name: name,
    path: path,
    isDirectory: isDirectory,
    size: size,
    modified: modified,
    permissionsRwx: permissionsRwx,
    isSymlink: isSymlink,
    children: children ?? this.children,
  );

  factory FileTreeNode.fromJson(Map<String, dynamic> json) => FileTreeNode(
    name: (json['name'] ?? '').toString(),
    path: (json['path'] ?? '').toString(),
    isDirectory: json['type'] == 'directory',
    size: (json['size'] as num?)?.toInt() ?? 0,
    modified: json['modified'] as String?,
    permissionsRwx: (json['permissionsRwx'] ?? '').toString(),
    isSymlink: json['isSymlink'] == true,
    children: [
      for (final c in (json['children'] as List? ?? const []))
        FileTreeNode.fromJson(Map<String, dynamic>.from(c as Map)),
    ],
  );
}

/// `GET /projects/:id/files` returns a bare array (depth-10, children inline).
/// Tolerates a raw JSON string body (missing content-type).
List<FileTreeNode> decodeFileTree(dynamic data) {
  if (data is String) {
    data = jsonDecode(data);
  }
  if (data is Map && data.containsKey('data')) {
    data = data['data'];
  }
  return [
    for (final e in (data as List? ?? const []))
      FileTreeNode.fromJson(Map<String, dynamic>.from(e as Map)),
  ];
}

/// `GET /projects/:id/search` → `{results: [{path,line,column,text}],
/// truncated}`.
class FileSearchMatch {
  const FileSearchMatch({
    required this.path,
    required this.line,
    required this.column,
    required this.text,
  });

  final String path;
  final int line;
  final int column;
  final String text;

  factory FileSearchMatch.fromJson(Map<String, dynamic> json) => FileSearchMatch(
    path: (json['path'] ?? '').toString(),
    line: (json['line'] as num?)?.toInt() ?? 0,
    column: (json['column'] as num?)?.toInt() ?? 0,
    text: (json['text'] ?? '').toString(),
  );
}

class FileSearchResult {
  const FileSearchResult({required this.matches, required this.truncated});

  final List<FileSearchMatch> matches;
  final bool truncated;
}

FileSearchResult decodeSearchResult(dynamic data) {
  final map = data is Map ? data : const <String, dynamic>{};
  return FileSearchResult(
    matches: [
      for (final m in (map['results'] as List? ?? const []))
        FileSearchMatch.fromJson(Map<String, dynamic>.from(m as Map)),
    ],
    truncated: map['truncated'] == true,
  );
}

enum FileTreeViewMode { simple, compact, detailed }

const kFileTreeViewModeKey = 'file_tree_view_mode';
const kDefaultFileTreeViewMode = FileTreeViewMode.detailed;

FileTreeViewMode parseFileTreeViewMode(Object? raw) =>
    FileTreeViewMode.values.asNameMap()[raw] ?? kDefaultFileTreeViewMode;

/// A row in the rendered tree: the node plus its indent depth.
class FlatNode {
  const FlatNode(this.node, this.depth);

  final FileTreeNode node;
  final int depth;
}

/// Depth-first flatten of only the expanded directories — the list the tree
/// view actually renders (useExpandedDirectories parity).
List<FlatNode> flattenVisible(List<FileTreeNode> roots, Set<String> expanded) {
  final out = <FlatNode>[];
  void visit(List<FileTreeNode> nodes, int depth) {
    for (final n in nodes) {
      out.add(FlatNode(n, depth));
      if (n.isDirectory && expanded.contains(n.path) && n.children.isNotEmpty) {
        visit(n.children, depth + 1);
      }
    }
  }

  visit(roots, 0);
  return out;
}

/// Name-substring filter keeping ancestor directories of matches
/// (filterFileTree parity).
List<FileTreeNode> filterFileTree(List<FileTreeNode> items, String query) {
  final q = query.toLowerCase();
  return [
    for (final item in items)
      if (item.name.toLowerCase().contains(q) ||
          (item.isDirectory && filterFileTree(item.children, q).isNotEmpty))
        item.isDirectory ? item.copyWith(children: filterFileTree(item.children, q)) : item,
  ];
}

/// Keeps files modified after [since] plus the directories that still hold
/// them (filterFileTreeByModified parity — the old tree defaults to this).
List<FileTreeNode> filterFileTreeByModified(List<FileTreeNode> items, DateTime since) {
  final sinceMs = since.millisecondsSinceEpoch;
  return [
    for (final item in items)
      if (_modifiedMs(item) >= sinceMs ||
          (item.isDirectory && filterFileTreeByModified(item.children, since).isNotEmpty))
        item.isDirectory
            ? item.copyWith(children: filterFileTreeByModified(item.children, since))
            : item,
  ];
}

int _modifiedMs(FileTreeNode node) =>
    DateTime.tryParse(node.modified ?? '')?.millisecondsSinceEpoch ?? 0;

/// All directory paths inside a filtered subtree — auto-expanded during
/// filter so matches are visible (collectExpandedDirectoryPaths parity).
Set<String> collectExpandedDirectoryPaths(List<FileTreeNode> items) {
  final paths = <String>{};
  void visit(List<FileTreeNode> nodes) {
    for (final n in nodes) {
      if (n.isDirectory && n.children.isNotEmpty) {
        paths.add(n.path);
        visit(n.children);
      }
    }
  }

  visit(items);
  return paths;
}

String formatFileSize(int bytes) {
  if (bytes <= 0) {
    return '0 B';
  }
  const sizes = ['B', 'KB', 'MB', 'GB'];
  var value = bytes.toDouble();
  var index = 0;
  while (value >= 1024 && index < sizes.length - 1) {
    value /= 1024;
    index++;
  }
  final text = value.toStringAsFixed(1).replaceAll('.0', '');
  return '$text ${sizes[index]}';
}

/// Short relative timestamp ("now", "5m", "3h", "2d", else date) —
/// formatRelativeTime parity without i18n plural rules.
String formatModified(String? iso) {
  if (iso == null || iso.isEmpty) {
    return '-';
  }
  final past = DateTime.tryParse(iso)?.toLocal();
  if (past == null) {
    return '-';
  }
  final seconds = DateTime.now().difference(past).inSeconds;
  if (seconds < 60) {
    return 'now';
  }
  if (seconds < 3600) {
    return '${seconds ~/ 60}m';
  }
  if (seconds < 86400) {
    return '${seconds ~/ 3600}h';
  }
  if (seconds < 2592000) {
    return '${seconds ~/ 86400}d';
  }
  return '${past.year}-${past.month.toString().padLeft(2, '0')}-'
      '${past.day.toString().padLeft(2, '0')}';
}

const imageFileExtensions = {'png', 'jpg', 'jpeg', 'gif', 'svg', 'webp', 'ico', 'bmp'};

bool isImageFile(String name) {
  final dot = name.lastIndexOf('.');
  if (dot < 0) {
    return false;
  }
  return imageFileExtensions.contains(name.substring(dot + 1).toLowerCase());
}
