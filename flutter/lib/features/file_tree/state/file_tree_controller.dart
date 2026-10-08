import 'dart:convert';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_repository.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Immutable screen state for the file tree (useFileTreeData +
/// useExpandedDirectories parity — children arrive inline with each node, so
/// "expansion" is client-side over the depth-10 payload).
class FileTreeState {
  const FileTreeState({
    this.projectId,
    this.roots = const [],
    this.expanded = const {},
    this.loading = false,
    this.error,
    this.uploading = false,
  });

  final String? projectId;
  final List<FileTreeNode> roots;

  /// Expanded directory paths (server `path` is the stable id).
  final Set<String> expanded;
  final bool loading;
  final String? error;
  final bool uploading;

  List<FlatNode> get visible => flattenVisible(roots, expanded);

  FileTreeState copyWith({
    String? projectId,
    List<FileTreeNode>? roots,
    Set<String>? expanded,
    bool? loading,
    String? Function()? error,
    bool? uploading,
  }) => FileTreeState(
    projectId: projectId ?? this.projectId,
    roots: roots ?? this.roots,
    expanded: expanded ?? this.expanded,
    loading: loading ?? this.loading,
    error: error != null ? error() : this.error,
    uploading: uploading ?? this.uploading,
  );
}

class FileTreeController extends Notifier<FileTreeState> {
  FileTreeRepository get _repo => ref.read(fileTreeRepositoryProvider);

  @override
  FileTreeState build() => const FileTreeState();

  /// Switch the displayed project; no-op when unchanged. Triggers a fetch.
  void selectProject(String? projectId) {
    if (projectId == state.projectId) {
      return;
    }
    state = FileTreeState(projectId: projectId, loading: projectId != null);
    if (projectId != null) {
      _load();
    }
  }

  Future<void> refresh() => _load();

  Future<void> _load() async {
    final projectId = state.projectId;
    if (projectId == null) {
      return;
    }
    state = state.copyWith(loading: true, error: () => null);
    try {
      final roots = await _repo.listFiles(
        projectId,
        respectGitignore: ref.read(fileTreeRespectGitignoreProvider),
      );
      if (state.projectId != projectId) {
        return; // switched projects mid-flight
      }
      state = state.copyWith(roots: roots, loading: false, error: () => null);
    } on AppError catch (e) {
      if (state.projectId != projectId) {
        return;
      }
      state = state.copyWith(loading: false, error: () => e.message);
    }
  }

  void toggleDirectory(String path) {
    final next = {...state.expanded};
    if (!next.remove(path)) {
      next.add(path);
    }
    state = state.copyWith(expanded: next);
  }

  void expandDirectories(Iterable<String> paths) {
    if (paths.isEmpty) {
      return;
    }
    state = state.copyWith(expanded: {...state.expanded, ...paths});
  }

  void collapseAll() => state = state.copyWith(expanded: const {});

  /// Operations below return an error message or null on success; each
  /// refreshes the tree so the affected directory re-renders.
  Future<String?> createEntry({
    required String parentPath,
    required String type,
    required String name,
  }) => _mutate(() async {
    await _repo.createFile(state.projectId!, path: parentPath, type: type, name: name);
  }, expandPath: parentPath);

  Future<String?> renameEntry({required String oldPath, required String newName}) =>
      _mutate(() => _repo.renameFile(state.projectId!, oldPath: oldPath, newName: newName));

  Future<String?> deleteEntry({required String path, required String type}) =>
      _mutate(() => _repo.deleteFile(state.projectId!, path: path, type: type));

  /// Uploads picked files into [targetPath] (multer `files` field +
  /// `targetPath`/`relativePaths`/`requestedFileCount` form fields).
  Future<String?> uploadFiles(String targetPath, List<({String name, List<int> bytes})> files) =>
      _mutate(
        () async {
          final form = FormData.fromMap({
            'files': [for (final f in files) MultipartFile.fromBytes(f.bytes, filename: f.name)],
            'targetPath': targetPath,
            'relativePaths': jsonEncode([for (final f in files) f.name]),
            'requestedFileCount': '${files.length}',
          });
          await _repo.upload(state.projectId!, form);
        },
        expandPath: targetPath,
        uploading: true,
      );

  Future<String?> _mutate(
    Future<void> Function() op, {
    String? expandPath,
    bool uploading = false,
  }) async {
    if (state.projectId == null) {
      return t.kanban.empty.noProject;
    }
    if (uploading) {
      state = state.copyWith(uploading: true);
    }
    try {
      await op();
    } on AppError catch (e) {
      if (uploading) {
        state = state.copyWith(uploading: false);
      }
      return e.message;
    }
    if (expandPath != null) {
      expandDirectories([expandPath]);
    }
    await _load();
    if (uploading) {
      state = state.copyWith(uploading: false);
    }
    return null;
  }
}

final fileTreeProvider = NotifierProvider<FileTreeController, FileTreeState>(
  FileTreeController.new,
);

/// Simple/compact/detailed rows — persisted in the shared `settings` Hive
/// box (useFileTreeViewMode + localStorage parity).
class FileTreeViewModeController extends Notifier<FileTreeViewMode> {
  @override
  FileTreeViewMode build() => readFileTreeViewMode();

  void set(FileTreeViewMode mode) {
    state = mode;
    persistFileTreeViewMode(mode);
  }
}

const _viewModeBox = 'settings';

/// "Recent only" — the old tree hides files older than 7 days by default
/// (FILE_TREE_RECENT_ONLY_STORAGE_KEY, localStorage default `true`).
const kFileTreeRecentOnlyKey = 'file_tree_recent_only';
const kDefaultFileTreeRecentOnly = true;
const kFileTreeRecentWindow = Duration(days: 7);

bool readFileTreeRecentOnly() {
  if (!Hive.isBoxOpen(_viewModeBox)) {
    return kDefaultFileTreeRecentOnly;
  }
  return Hive.box<dynamic>(_viewModeBox).get(kFileTreeRecentOnlyKey) as bool? ??
      kDefaultFileTreeRecentOnly;
}

void persistFileTreeRecentOnly(bool value) {
  if (Hive.isBoxOpen(_viewModeBox)) {
    Hive.box<dynamic>(_viewModeBox).put(kFileTreeRecentOnlyKey, value);
  }
}

class FileTreeRecentOnlyController extends Notifier<bool> {
  @override
  bool build() => readFileTreeRecentOnly();

  void toggle() {
    state = !state;
    persistFileTreeRecentOnly(state);
  }
}

final fileTreeRecentOnlyProvider = NotifierProvider<FileTreeRecentOnlyController, bool>(
  FileTreeRecentOnlyController.new,
);

/// "Respect gitignore" — the tree hides entries matched by the project's
/// `.gitignore` by default; the toolbar switch flips it to reveal them
/// (`respectGitignore=false` on `/projects/:id/files`).
const kFileTreeRespectGitignoreKey = 'file_tree_respect_gitignore';
const kDefaultFileTreeRespectGitignore = true;

bool readFileTreeRespectGitignore() {
  if (!Hive.isBoxOpen(_viewModeBox)) {
    return kDefaultFileTreeRespectGitignore;
  }
  return Hive.box<dynamic>(_viewModeBox).get(kFileTreeRespectGitignoreKey) as bool? ??
      kDefaultFileTreeRespectGitignore;
}

void persistFileTreeRespectGitignore(bool value) {
  if (Hive.isBoxOpen(_viewModeBox)) {
    Hive.box<dynamic>(_viewModeBox).put(kFileTreeRespectGitignoreKey, value);
  }
}

class FileTreeRespectGitignoreController extends Notifier<bool> {
  @override
  bool build() => readFileTreeRespectGitignore();

  void toggle() {
    state = !state;
    persistFileTreeRespectGitignore(state);
  }
}

final fileTreeRespectGitignoreProvider = NotifierProvider<FileTreeRespectGitignoreController, bool>(
  FileTreeRespectGitignoreController.new,
);

/// Extracted so persistence is testable without a Riverpod container.
FileTreeViewMode readFileTreeViewMode() {
  if (!Hive.isBoxOpen(_viewModeBox)) {
    return kDefaultFileTreeViewMode;
  }
  return parseFileTreeViewMode(Hive.box<dynamic>(_viewModeBox).get(kFileTreeViewModeKey));
}

void persistFileTreeViewMode(FileTreeViewMode mode) {
  if (Hive.isBoxOpen(_viewModeBox)) {
    Hive.box<dynamic>(_viewModeBox).put(kFileTreeViewModeKey, mode.name);
  }
}

final fileTreeViewModeProvider = NotifierProvider<FileTreeViewModeController, FileTreeViewMode>(
  FileTreeViewModeController.new,
);

/// Screen-local context of the Files tab that must outlive the route: the
/// search query, the file shown in the side pane, and the tree scroll offset.
/// The ShellRoute rebuilds [FileTreeScreen] on every tab switch, so without
/// this the opened pane and position reset when the user leaves and returns.
class FileTreeUiState {
  const FileTreeUiState({
    this.query = '',
    this.openProjectId,
    this.openPath,
    this.scrollOffset = 0,
  });

  final String query;
  final String? openProjectId;
  final String? openPath;
  final double scrollOffset;

  FileTreeUiState copyWith({
    String? query,
    String? Function()? openProjectId,
    String? Function()? openPath,
    double? scrollOffset,
  }) => FileTreeUiState(
    query: query ?? this.query,
    openProjectId: openProjectId != null ? openProjectId() : this.openProjectId,
    openPath: openPath != null ? openPath() : this.openPath,
    scrollOffset: scrollOffset ?? this.scrollOffset,
  );
}

class FileTreeUiController extends Notifier<FileTreeUiState> {
  @override
  FileTreeUiState build() => const FileTreeUiState();

  void setQuery(String query) => state = state.copyWith(query: query);

  void openFile(String projectId, String path) =>
      state = state.copyWith(openProjectId: () => projectId, openPath: () => path);

  void closeFile() => state = state.copyWith(openProjectId: () => null, openPath: () => null);

  void setScrollOffset(double offset) => state = state.copyWith(scrollOffset: offset);
}

final fileTreeUiProvider = NotifierProvider<FileTreeUiController, FileTreeUiState>(
  FileTreeUiController.new,
);
