import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/worktrees/data/worktrees_models.dart';
import 'package:ddagent_app/features/worktrees/data/worktrees_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorktreesState {
  const WorktreesState({
    this.projectId,
    this.data,
    this.scriptsStatus,
    this.loading = true,
    this.busy = false,
    this.busyWorktreePath,
    this.error,
  });

  final String? projectId;
  final WorktreeListData? data;
  final WorktreeScriptsStatus? scriptsStatus;
  final bool loading;
  final bool busy;
  final String? busyWorktreePath;
  final String? error;

  List<WorktreeDescriptor> get worktrees => data?.worktrees ?? const [];
  String? get baseBranch => data?.baseBranch;

  WorktreeRuntimeInfo? runtimeFor(String worktreePath) => scriptsStatus?.runtimes[worktreePath];

  WorktreesState copyWith({
    String? Function()? projectId,
    WorktreeListData? Function()? data,
    WorktreeScriptsStatus? Function()? scriptsStatus,
    bool? loading,
    bool? busy,
    String? Function()? busyWorktreePath,
    String? Function()? error,
  }) => WorktreesState(
    projectId: projectId != null ? projectId() : this.projectId,
    data: data != null ? data() : this.data,
    scriptsStatus: scriptsStatus != null ? scriptsStatus() : this.scriptsStatus,
    loading: loading ?? this.loading,
    busy: busy ?? this.busy,
    busyWorktreePath: busyWorktreePath != null ? busyWorktreePath() : this.busyWorktreePath,
    error: error != null ? error() : this.error,
  );
}

class WorktreesController extends Notifier<WorktreesState> {
  WorktreesRepository get _repo => ref.read(worktreesRepositoryProvider);

  @override
  WorktreesState build() {
    return const WorktreesState(loading: false);
  }

  void selectProject(String? projectId) {
    if (state.projectId == projectId && (state.data != null || state.loading)) {
      return;
    }
    state = state.copyWith(
      projectId: () => projectId,
      data: () => null,
      scriptsStatus: () => null,
      loading: projectId != null,
      error: () => null,
    );
    if (projectId != null) {
      unawaited(refresh());
    }
  }

  void clearError() => state = state.copyWith(error: () => null);

  Future<void> refresh() async {
    final pid = state.projectId;
    if (pid == null) return;

    state = state.copyWith(loading: state.data == null, error: () => null);
    try {
      final (listData, statusData) = await (_repo.list(pid), _repo.status(pid)).wait;

      if (!ref.mounted || state.projectId != pid) return;
      state = state.copyWith(data: () => listData, scriptsStatus: () => statusData, loading: false);
    } on AppError catch (e) {
      if (ref.mounted && state.projectId == pid) {
        state = state.copyWith(loading: false, error: () => e.message);
      }
    } on Exception catch (e) {
      if (ref.mounted && state.projectId == pid) {
        state = state.copyWith(loading: false, error: () => e.toString());
      }
    }
  }

  Future<Project?> createWorktree(String branch, {String? baseBranch}) async {
    final pid = state.projectId;
    if (pid == null || state.busy) return null;

    state = state.copyWith(busy: true, error: () => null);
    try {
      final project = await _repo.create(pid, branch, baseBranch: baseBranch);
      if (!ref.mounted) return project;
      state = state.copyWith(busy: false);
      unawaited(refresh());
      return project;
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, error: () => e.message);
      }
      return null;
    }
  }

  Future<Project?> openWorktree(String worktreePath) async {
    final pid = state.projectId;
    if (pid == null || state.busy) return null;

    state = state.copyWith(busy: true, busyWorktreePath: () => worktreePath, error: () => null);
    try {
      final project = await _repo.open(pid, worktreePath);
      if (!ref.mounted) return project;
      state = state.copyWith(busy: false, busyWorktreePath: () => null);
      return project;
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, busyWorktreePath: () => null, error: () => e.message);
      }
      return null;
    }
  }

  Future<MergeWorktreeResult?> mergeWorktree(
    String worktreePath, {
    bool squash = false,
    String? message,
    bool removeAfterMerge = false,
  }) async {
    final pid = state.projectId;
    if (pid == null || state.busy) return null;

    state = state.copyWith(busy: true, busyWorktreePath: () => worktreePath, error: () => null);
    try {
      final result = await _repo.merge(
        pid,
        worktreePath,
        squash: squash,
        message: message,
        removeAfterMerge: removeAfterMerge,
      );
      if (!ref.mounted) return result;
      state = state.copyWith(busy: false, busyWorktreePath: () => null);
      unawaited(refresh());
      return result;
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, busyWorktreePath: () => null, error: () => e.message);
      }
      return null;
    }
  }

  Future<RemoveWorktreeResult?> removeWorktree(
    String worktreePath, {
    bool force = false,
    bool deleteBranch = false,
  }) async {
    final pid = state.projectId;
    if (pid == null || state.busy) return null;

    state = state.copyWith(busy: true, busyWorktreePath: () => worktreePath, error: () => null);
    try {
      final result = await _repo.remove(
        pid,
        worktreePath,
        force: force,
        deleteBranch: deleteBranch,
      );
      if (!ref.mounted) return result;
      state = state.copyWith(busy: false, busyWorktreePath: () => null);
      unawaited(refresh());
      return result;
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, busyWorktreePath: () => null, error: () => e.message);
      }
      return null;
    }
  }

  Future<bool> saveConfig({String? setup, String? run, int? runPort}) async {
    final pid = state.projectId;
    if (pid == null || state.busy) return false;

    state = state.copyWith(busy: true, error: () => null);
    try {
      await _repo.saveConfig(pid, setup: setup, run: run, runPort: runPort);
      if (!ref.mounted) return true;
      state = state.copyWith(busy: false);
      unawaited(refresh());
      return true;
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, error: () => e.message);
      }
      return false;
    }
  }

  Future<bool> runScript(String targetProjectId) async {
    if (state.busy) return false;
    state = state.copyWith(busy: true, error: () => null);
    try {
      await _repo.run(targetProjectId);
      if (!ref.mounted) return true;
      state = state.copyWith(busy: false);
      unawaited(refresh());
      return true;
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, error: () => e.message);
      }
      return false;
    }
  }

  Future<bool> stopScript(String targetProjectId) async {
    if (state.busy) return false;
    state = state.copyWith(busy: true, error: () => null);
    try {
      await _repo.stop(targetProjectId);
      if (!ref.mounted) return true;
      state = state.copyWith(busy: false);
      unawaited(refresh());
      return true;
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, error: () => e.message);
      }
      return false;
    }
  }
}

final worktreesProvider = NotifierProvider<WorktreesController, WorktreesState>(
  WorktreesController.new,
);
