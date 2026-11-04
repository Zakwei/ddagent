import 'package:ddagent_app/core/utils/path_utils.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';

// Pure helpers behind the VS Code-style explorer: compact-folder rows,
// keyboard navigation targets, reveal ancestors and git decorations.

/// One rendered explorer row. With compact folders a chain of directories
/// that each hold a single sub-directory collapses into one row labelled
/// `a/b/c`; [node] is the last directory of that chain (its children are
/// what the row expands to) and [chain] lists every directory in it.
class ExplorerRow {
  const ExplorerRow({
    required this.node,
    required this.depth,
    required this.label,
    this.chain = const [],
  });

  final FileTreeNode node;
  final int depth;
  final String label;
  final List<FileTreeNode> chain;

  String get path => node.path;
}

/// Depth-first rows of the expanded part of the tree. [compactFolders]
/// mirrors VS Code's `explorer.compactFolders` (on by default).
List<ExplorerRow> buildExplorerRows(
  List<FileTreeNode> roots,
  Set<String> expanded, {
  bool compactFolders = true,
}) {
  final out = <ExplorerRow>[];
  void visit(List<FileTreeNode> nodes, int depth) {
    for (final n in nodes) {
      if (!n.isDirectory) {
        out.add(ExplorerRow(node: n, depth: depth, label: n.name));
        continue;
      }
      final chain = <FileTreeNode>[n];
      if (compactFolders) {
        var last = n;
        while (last.children.length == 1 && last.children.first.isDirectory) {
          last = last.children.first;
          chain.add(last);
        }
      }
      final last = chain.last;
      out.add(
        ExplorerRow(
          node: last,
          depth: depth,
          label: chain.map((c) => c.name).join('/'),
          chain: chain,
        ),
      );
      if (expanded.contains(last.path) && last.children.isNotEmpty) {
        visit(last.children, depth + 1);
      }
    }
  }

  visit(roots, 0);
  return out;
}

/// Index of the row that owns row [index] (the nearest row above with a
/// smaller depth), or -1 at the top level.
int explorerParentIndex(List<ExplorerRow> rows, int index) {
  if (index <= 0 || index >= rows.length) {
    return -1;
  }
  final depth = rows[index].depth;
  for (var i = index - 1; i >= 0; i--) {
    if (rows[i].depth < depth) {
      return i;
    }
  }
  return -1;
}

/// Every directory above [path] up to (not including) [root] — what has to
/// be expanded so the row for [path] is visible. Without [root] it walks to
/// the filesystem root (`/`, `C:\`, UNC).
List<String> explorerAncestors(String path, {String? root}) {
  final out = <String>[];
  var dir = pathDirname(path);
  while (dir.length > 1 && dir != root && dir != path) {
    out.add(dir);
    final next = pathDirname(dir);
    if (next == dir) {
      break;
    }
    dir = next;
  }
  return out;
}

/// Directory that holds the project's top-level entries, derived from the
/// tree itself so it always matches the paths the server sends.
String? explorerProjectRoot(List<FileTreeNode> roots) =>
    roots.isEmpty ? null : pathDirname(roots.first.path);

/// [path] relative to [root] with `/` separators, or null when outside.
String? explorerRelativePath(String path, String root) {
  final p = path.replaceAll(r'\', '/');
  var r = root.replaceAll(r'\', '/');
  if (r.endsWith('/')) {
    r = r.substring(0, r.length - 1);
  }
  if (p == r) {
    return '';
  }
  return p.startsWith('$r/') ? p.substring(r.length + 1) : null;
}

/// Joins a child [name] onto [dir] using the separator [dir] already uses.
String explorerJoin(String dir, String name) {
  final sep = dir.contains(r'\') && !dir.contains('/') ? r'\' : '/';
  return dir.endsWith(sep) ? '$dir$name' : '$dir$sep$name';
}

/// VS Code SCM decoration kinds, in display priority order.
enum GitDecoration { deleted, untracked, added, modified }

extension GitDecorationBadge on GitDecoration {
  String get letter => switch (this) {
    GitDecoration.deleted => 'D',
    GitDecoration.untracked => 'U',
    GitDecoration.added => 'A',
    GitDecoration.modified => 'M',
  };
}

/// Git status of the project mapped onto explorer paths. Git reports paths
/// relative to the repository root, which may sit above the project root, so
/// each one is matched against the project-relative paths by dropping
/// leading segments until it lands inside the project.
class GitDecorations {
  GitDecorations._(this._files, this._dirs, this._untrackedDirs);

  static final empty = GitDecorations._(const {}, const {}, const []);

  final Map<String, GitDecoration> _files;
  final Map<String, GitDecoration> _dirs;
  final List<String> _untrackedDirs;

  bool get isEmpty => _files.isEmpty && _untrackedDirs.isEmpty;

  /// [status] is the `/api/git/status` body; [projectPaths] the
  /// project-relative paths present in the tree (used to resolve repo-root
  /// prefixes).
  factory GitDecorations.fromStatus(Map<String, dynamic>? status, Set<String> projectPaths) {
    if (status == null) {
      return empty;
    }
    final files = <String, GitDecoration>{};
    final untrackedDirs = <String>[];

    String? resolve(String raw) {
      var p = raw.replaceAll(r'\', '/');
      while (true) {
        final bare = p.endsWith('/') ? p.substring(0, p.length - 1) : p;
        if (projectPaths.contains(bare)) {
          return p;
        }
        final slash = p.indexOf('/');
        if (slash < 0 || slash == p.length - 1) {
          // Not in the loaded tree (deleted file, depth limit): keep the
          // repo-relative path — correct whenever project root == repo root.
          return raw.replaceAll(r'\', '/');
        }
        p = p.substring(slash + 1);
      }
    }

    void put(String key, GitDecoration kind) {
      for (final e in status[key] as List? ?? const []) {
        final p = resolve(e.toString());
        if (p == null || p.isEmpty) {
          continue;
        }
        if (p.endsWith('/')) {
          untrackedDirs.add(p);
          continue;
        }
        final prev = files[p];
        if (prev == null || kind.index < prev.index) {
          files[p] = kind;
        }
      }
    }

    put('staged', GitDecoration.modified);
    put('modified', GitDecoration.modified);
    put('added', GitDecoration.added);
    put('untracked', GitDecoration.untracked);
    put('deleted', GitDecoration.deleted);

    final dirs = <String, GitDecoration>{};
    void bubble(String path, GitDecoration kind) {
      var slash = path.lastIndexOf('/');
      while (slash > 0) {
        final dir = path.substring(0, slash);
        final prev = dirs[dir];
        if (prev == null || kind.index < prev.index) {
          dirs[dir] = kind;
        }
        slash = dir.lastIndexOf('/');
      }
    }

    files.forEach(bubble);
    for (final d in untrackedDirs) {
      bubble(d.substring(0, d.length - 1), GitDecoration.untracked);
    }
    return GitDecorations._(files, dirs, untrackedDirs);
  }

  /// Decoration of the project-relative [relPath]. Folders report the most
  /// significant change among their descendants.
  GitDecoration? of(String relPath, {required bool isDirectory}) {
    for (final d in _untrackedDirs) {
      if ('$relPath/'.startsWith(d)) {
        return GitDecoration.untracked;
      }
    }
    return isDirectory ? _dirs[relPath] : _files[relPath];
  }
}

/// All project-relative paths in the loaded tree.
Set<String> explorerRelativePaths(List<FileTreeNode> roots, String root) {
  final out = <String>{};
  void visit(List<FileTreeNode> nodes) {
    for (final n in nodes) {
      final rel = explorerRelativePath(n.path, root);
      if (rel != null) {
        out.add(rel);
      }
      visit(n.children);
    }
  }

  visit(roots);
  return out;
}

/// The node at [path] in the loaded tree, or null.
FileTreeNode? findExplorerNode(List<FileTreeNode> roots, String path) {
  for (final n in roots) {
    if (n.path == path) {
      return n;
    }
    if (n.isDirectory && path.startsWith(n.path) && path.length > n.path.length) {
      final hit = findExplorerNode(n.children, path);
      if (hit != null) {
        return hit;
      }
    }
  }
  return null;
}

/// Names already used inside [dirPath] (`''` = project root) — VS Code
/// refuses a new or renamed entry that collides with a sibling.
Set<String> explorerSiblingNames(List<FileTreeNode> roots, String dirPath) {
  final children = dirPath.isEmpty ? roots : findExplorerNode(roots, dirPath)?.children;
  return {for (final c in children ?? const <FileTreeNode>[]) c.name.toLowerCase()};
}
