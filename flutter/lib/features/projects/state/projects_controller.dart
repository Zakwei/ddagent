import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProjectsState {
  const ProjectsState({
    this.projects = const [],
    this.archived = const [],
    this.taskmaster = const {},
    this.loading = true,

    /// True while the server is synchronizing projects (GET /projects emits
    /// `loading_progress` frames on /ws, plus our own fetch).
    this.syncing = false,
    this.error,
  });

  final List<Project> projects;
  final List<Project> archived;

  /// projectId → `taskmaster` object when the project has TaskMaster installed.
  final Map<String, Map<String, dynamic>> taskmaster;
  final bool loading;
  final bool syncing;
  final String? error;

  ProjectsState copyWith({
    List<Project>? projects,
    List<Project>? archived,
    Map<String, Map<String, dynamic>>? taskmaster,
    bool? loading,
    bool? syncing,
    String? error,
  }) => ProjectsState(
    projects: projects ?? this.projects,
    archived: archived ?? this.archived,
    taskmaster: taskmaster ?? this.taskmaster,
    loading: loading ?? this.loading,
    syncing: syncing ?? this.syncing,
    error: error,
  );
}

/// Projects list + mutations — port of useProjectsState (list/archived,
/// star, rename, archive/restore/delete, taskmaster badges, legacy-star
/// migration, `loading_progress` sync indicator).
class ProjectsController extends Notifier<ProjectsState> {
  StreamSubscription<ServerEvent>? _eventsSub;
  Timer? _reloadDebounce;
  Timer? _progressTimer;
  bool _loaded = false;

  ProjectsRepository get _repo => ref.read(projectsRepositoryProvider);

  @override
  ProjectsState build() {
    _eventsSub?.cancel();
    _eventsSub = ref.read(chatChannelProvider).events.listen((e) {
      if (e.kind == 'loading_progress') {
        _progressTimer?.cancel();
        state = state.copyWith(syncing: true);
        if (e.raw['phase'] == 'complete') {
          // Keep the indicator visible briefly like the web client.
          _progressTimer = Timer(
            const Duration(milliseconds: 500),
            () => state = state.copyWith(syncing: false),
          );
        }
        return;
      }
      if (e.kind.startsWith('session_') || e.kind.startsWith('project_')) {
        // Debounced refetch — sidebar deltas are frequent during runs.
        _reloadDebounce?.cancel();
        _reloadDebounce = Timer(const Duration(milliseconds: 400), () => unawaited(load()));
      }
    });
    ref.onDispose(() {
      unawaited(_eventsSub?.cancel());
      _reloadDebounce?.cancel();
      _progressTimer?.cancel();
    });
    if (!_loaded) {
      _loaded = true;
      Future(load);
    }
    return const ProjectsState();
  }

  Future<void> load() async {
    state = state.copyWith(syncing: true);
    try {
      final results = await Future.wait([_repo.list(), _repo.archived()]);
      if (!ref.mounted) return;
      state = state.copyWith(
        projects: results[0],
        archived: results[1],
        loading: false,
        syncing: false,
      );
      unawaited(_loadTaskmasterBadges(results[0]));
      unawaited(_migrateLegacyStars());
    } on AppError catch (e) {
      state = state.copyWith(loading: false, syncing: false, error: e.message);
    }
  }

  /// TaskMaster badge per active project — failures are silent (badge just
  /// doesn't render).
  Future<void> _loadTaskmasterBadges(List<Project> projects) async {
    for (final p in projects) {
      try {
        final meta = await _repo.taskmaster(p.projectId);
        final tm = meta['taskmaster'];
        if (!ref.mounted) return;
        if (tm is Map && tm['hasTaskmaster'] == true) {
          state = state.copyWith(
            taskmaster: {...state.taskmaster, p.projectId: Map<String, dynamic>.from(tm)},
          );
        }
      } on AppError {
        // No badge.
      }
    }
  }

  /// One-time web parity: localStorage-era starred ids → server stars.
  Future<void> _migrateLegacyStars() async {
    if (!Hive.isBoxOpen('settings')) return;
    final box = Hive.box<dynamic>('settings');
    final legacy = (box.get('starredProjects') as List?)?.cast<String>();
    if (legacy == null || legacy.isEmpty) return;
    await box.delete('starredProjects');
    try {
      await _repo.migrateLegacyStars(legacy);
      if (!ref.mounted) return;
      await load();
    } on AppError {
      // Migration is best-effort.
    }
  }

  /// Optimistic star toggle; reload on failure.
  Future<void> toggleStar(String projectId) async {
    List<Project> flip(List<Project> l) => [
      for (final p in l)
        if (p.projectId == projectId) p.copyWith(isStarred: !p.isStarred) else p,
    ];
    state = state.copyWith(projects: flip(state.projects), archived: flip(state.archived));
    try {
      await _repo.toggleStar(projectId);
    } on AppError {
      await load();
    }
  }

  Future<String?> rename(String projectId, String displayName) =>
      _mutate(() => _repo.rename(projectId, displayName));

  Future<String?> archive(String projectId) => _mutate(() => _repo.delete(projectId));

  Future<String?> restore(String projectId) => _mutate(() => _repo.restore(projectId));

  Future<String?> hardDelete(String projectId) =>
      _mutate(() => _repo.delete(projectId, hardDelete: true));

  Future<String?> create(String path, {String? customName}) =>
      _mutate(() => _repo.create(path: path, customName: customName));

  Future<String?> _mutate(Future<dynamic> Function() call) async {
    try {
      await call();
      await load();
      return null;
    } on AppError catch (e) {
      return e.message;
    }
  }
}

final projectsProvider = NotifierProvider<ProjectsController, ProjectsState>(
  ProjectsController.new,
);

/// Lazy session page loader for the expanded project tile.
final projectSessionsProvider = FutureProvider.family<ProjectSessionsPage, (String, int, int)>(
  (ref, args) =>
      ref.watch(projectsRepositoryProvider).sessions(args.$1, limit: args.$2, offset: args.$3),
);
