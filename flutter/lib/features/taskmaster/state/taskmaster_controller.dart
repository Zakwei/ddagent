import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_models.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _priorityRank = {'high': 0, 'medium': 1, 'low': 2};

enum TaskSort { position, priority, status, title }

class TaskmasterState {
  const TaskmasterState({
    this.projectId = '',
    this.config,
    this.tasks = const [],
    this.currentTag = 'master',
    this.tasksByStatus = const {},
    this.hasTasksFile = true,
    this.prdFiles = const [],
    this.prdTemplates = const [],
    this.prdFileName,
    this.prdContent = '',
    this.statusFilter,
    this.priorityFilter,
    this.searchQuery = '',
    this.sort = TaskSort.position,
    this.loading = false,
    this.busy = false,
    this.error,
  });

  final String projectId;
  final TaskmasterConfig? config;
  final List<TaskmasterTask> tasks;
  final String currentTag;
  final Map<String, int> tasksByStatus;
  final bool hasTasksFile;
  final List<TaskmasterPrdFile> prdFiles;
  final List<TaskmasterPrdTemplate> prdTemplates;
  final String? prdFileName;
  final String prdContent;
  final String? statusFilter;
  final String? priorityFilter;
  final String searchQuery;
  final TaskSort sort;
  final bool loading;
  final bool busy;
  final String? error;

  bool get isReady => config?.isReady ?? false;

  /// Filtered + sorted view of [tasks] used by the board/list UI.
  List<TaskmasterTask> get filteredTasks {
    var list = tasks;
    if (statusFilter != null) {
      list = list.where((t) => t.status == statusFilter).toList();
    }
    if (priorityFilter != null) {
      list = list.where((t) => t.priority == priorityFilter).toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list
          .where(
            (t) =>
                t.title.toLowerCase().contains(q) ||
                t.description.toLowerCase().contains(q) ||
                t.idText.contains(q),
          )
          .toList();
    }
    int rank(String p) => _priorityRank[p] ?? 1;
    list.sort(switch (sort) {
      TaskSort.priority =>
        (a, b) => rank(a.priority).compareTo(rank(b.priority)) != 0
            ? rank(a.priority).compareTo(rank(b.priority))
            : _idCmp(a, b),
      TaskSort.status => (a, b) => a.status.compareTo(b.status),
      TaskSort.title => (a, b) => a.title.compareTo(b.title),
      TaskSort.position => _idCmp,
    });
    return list;
  }

  static int _idCmp(TaskmasterTask a, TaskmasterTask b) {
    final an = num.tryParse(a.idText);
    final bn = num.tryParse(b.idText);
    if (an != null && bn != null) return an.compareTo(bn);
    return a.idText.compareTo(b.idText);
  }

  /// Taskmaster semantics: the lowest-id pending task whose dependencies are
  /// all done. High priority wins ties (the CLI ranks the same way).
  TaskmasterTask? get nextTask {
    final done = {for (final t in tasks.where((t) => t.isDone)) t.idText};
    final candidates = tasks
        .where(
          (t) =>
              t.status == 'pending' &&
              t.dependencies.every((d) => done.contains('$d')),
        )
        .toList();
    if (candidates.isEmpty) return null;
    candidates.sort((a, b) {
      final r = (_priorityRank[a.priority] ?? 1).compareTo(
        _priorityRank[b.priority] ?? 1,
      );
      return r != 0 ? r : _idCmp(a, b);
    });
    return candidates.first;
  }

  TaskmasterState copyWith({
    String? projectId,
    TaskmasterConfig? Function()? config,
    List<TaskmasterTask>? tasks,
    String? currentTag,
    Map<String, int>? tasksByStatus,
    bool? hasTasksFile,
    List<TaskmasterPrdFile>? prdFiles,
    List<TaskmasterPrdTemplate>? prdTemplates,
    String? Function()? prdFileName,
    String? prdContent,
    String? Function()? statusFilter,
    String? Function()? priorityFilter,
    String? searchQuery,
    TaskSort? sort,
    bool? loading,
    bool? busy,
    String? Function()? error,
  }) => TaskmasterState(
    projectId: projectId ?? this.projectId,
    config: config != null ? config() : this.config,
    tasks: tasks ?? this.tasks,
    currentTag: currentTag ?? this.currentTag,
    tasksByStatus: tasksByStatus ?? this.tasksByStatus,
    hasTasksFile: hasTasksFile ?? this.hasTasksFile,
    prdFiles: prdFiles ?? this.prdFiles,
    prdTemplates: prdTemplates ?? this.prdTemplates,
    prdFileName: prdFileName != null ? prdFileName() : this.prdFileName,
    prdContent: prdContent ?? this.prdContent,
    statusFilter: statusFilter != null ? statusFilter() : this.statusFilter,
    priorityFilter: priorityFilter != null
        ? priorityFilter()
        : this.priorityFilter,
    searchQuery: searchQuery ?? this.searchQuery,
    sort: sort ?? this.sort,
    loading: loading ?? this.loading,
    busy: busy ?? this.busy,
    error: error != null ? error() : this.error,
  );
}

class TaskmasterController extends Notifier<TaskmasterState> {
  StreamSubscription<ServerEvent>? _eventsSub;

  TaskmasterRepository get _repo => ref.read(taskmasterRepositoryProvider);
  String get _pid => state.projectId;

  @override
  TaskmasterState build() {
    _eventsSub = ref.read(chatChannelProvider).events.listen(handleServerEvent);
    ref.onDispose(() => unawaited(_eventsSub?.cancel()));
    return const TaskmasterState();
  }

  /// taskmaster broadcasts are unscoped — filter by projectId and refetch
  /// (the frame's tasksData is the raw tasks.json; the REST endpoint already
  /// normalizes tagged/legacy formats so we reuse it).
  void handleServerEvent(ServerEvent e) {
    if (e.kind != 'taskmaster-tasks-updated' &&
        e.kind != 'tasks-updated' &&
        e.kind != 'taskmaster-project-updated') {
      return;
    }
    final pid = e.raw['projectId'] as String?;
    if (state.projectId.isEmpty || (pid != null && pid != state.projectId)) {
      return;
    }
    unawaited(refreshTasks());
  }

  void clearError() => state = state.copyWith(error: () => null);

  /// First load for a project: installation status + tasks + PRDs + templates.
  Future<void> load(String projectId) async {
    state = state.copyWith(
      projectId: projectId,
      loading: true,
      error: () => null,
    );
    try {
      final status = await _repo.installationStatus();
      if (!ref.mounted) return;
      state = state.copyWith(config: () => TaskmasterConfig.fromJson(status));
    } on AppError catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(
        loading: false,
        config: () => const TaskmasterConfig(),
        error: () => e.message,
      );
      return;
    }
    await refreshTasks();
    // PRD list + templates are best-effort — they only gate the PRD editor.
    unawaited(refreshPrds());
    unawaited(refreshTemplates());
    if (ref.mounted) state = state.copyWith(loading: false);
  }

  Future<void> refreshTasks() async {
    final pid = _pid;
    if (pid.isEmpty) return;
    try {
      final res = await _repo.tasks(pid);
      if (!ref.mounted || state.projectId != pid) return;
      final s = TaskmasterStatus.fromJson(res);
      state = state.copyWith(
        tasks: s.tasks,
        currentTag: s.currentTag,
        tasksByStatus: s.tasksByStatus,
        hasTasksFile: s.hasTasksFile,
      );
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.message);
    }
  }

  Future<void> refreshPrds() async {
    try {
      final list = await _repo.prdList(_pid);
      if (!ref.mounted) return;
      state = state.copyWith(
        prdFiles: [for (final p in list) TaskmasterPrdFile.fromJson(p)],
      );
    } on AppError catch (_) {}
  }

  Future<void> refreshTemplates() async {
    try {
      final list = await _repo.prdTemplates();
      if (!ref.mounted) return;
      state = state.copyWith(
        prdTemplates: [for (final t in list) TaskmasterPrdTemplate.fromJson(t)],
      );
    } on AppError catch (_) {}
  }

  // ─── Filters ───────────────────────────────────────────────────────────

  void setStatusFilter(String? v) =>
      state = state.copyWith(statusFilter: () => v);
  void setPriorityFilter(String? v) =>
      state = state.copyWith(priorityFilter: () => v);
  void setSearchQuery(String v) => state = state.copyWith(searchQuery: v);
  void setSort(TaskSort v) => state = state.copyWith(sort: v);

  // ─── Mutations ─────────────────────────────────────────────────────────

  Future<bool> _mutate(
    Future<void> Function() op, {
    bool refresh = true,
  }) async {
    if (state.busy) return false;
    state = state.copyWith(busy: true, error: () => null);
    try {
      await op();
      if (!ref.mounted) return true;
      state = state.copyWith(busy: false);
      if (refresh) unawaited(refreshTasks());
      return true;
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, error: () => e.message);
      }
      return false;
    } on Object catch (e) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, error: () => e.toString());
      }
      return false;
    }
  }

  Future<bool> init() => _mutate(() => _repo.init(_pid));

  Future<bool> createTask(Map<String, dynamic> body) =>
      _mutate(() => _repo.addTask(_pid, body));

  /// Editable fields: title, description, details, testStrategy, priority,
  /// status, dependencies — everything `update-task` accepts.
  Future<bool> updateTask(String taskId, Map<String, dynamic> updates) =>
      _mutate(() => _repo.updateTask(_pid, taskId, updates));

  Future<bool> setTaskStatus(String taskId, String status) =>
      updateTask(taskId, {'status': status});

  Future<bool> deleteTask(String taskId) =>
      _mutate(() => _repo.deleteTask(_pid, taskId));

  // ─── PRD editor + parse ────────────────────────────────────────────────

  Future<void> openPrd(String fileName) async {
    try {
      final res = await _repo.prdFile(_pid, fileName);
      if (!ref.mounted) return;
      state = state.copyWith(
        prdFileName: () => fileName,
        prdContent: (res['content'] ?? '').toString(),
      );
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.message);
    }
  }

  void setPrdContent(String content) =>
      state = state.copyWith(prdContent: content);

  /// Save the PRD editor buffer (new or existing file).
  Future<bool> savePrd(String fileName) => _mutate(
    () => _repo.createPrd(_pid, {
      'fileName': fileName,
      'content': state.prdContent,
    }),
    refresh: false,
  );

  /// Convert the current PRD into generated tasks.
  Future<bool> parsePrd({
    String? fileName,
    int? numTasks,
    bool append = false,
  }) => _mutate(() async {
    await _repo.parsePrd(
      _pid,
      fileName: fileName ?? state.prdFileName,
      numTasks: numTasks,
      append: append,
    );
  });

  Future<bool> applyTemplate(String templateId, {String? fileName}) => _mutate(
    () => _repo.applyTemplate(_pid, {
      'templateId': templateId,
      'fileName': ?fileName,
    }),
    refresh: false,
  );
}

final taskmasterProvider =
    NotifierProvider<TaskmasterController, TaskmasterState>(
      TaskmasterController.new,
    );
