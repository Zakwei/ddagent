import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/git/data/git_models.dart';
import 'package:ddagent_app/features/git/data/git_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GitState {
  const GitState({
    this.projectId,
    this.status,
    this.branches = const GitBranches(),
    this.commits = const [],
    this.checkpoints = const [],
    this.remoteStatus = const GitRemoteStatus(),
    this.loading = false,
    this.busy = false,
    this.error,
  });

  final String? projectId;
  final GitStatus? status;
  final GitBranches branches;
  final List<GitCommit> commits;
  final List<GitCheckpoint> checkpoints;
  final GitRemoteStatus remoteStatus;

  /// First load in flight; [busy] marks mutations (stage/commit/push…).
  final bool loading;
  final bool busy;

  /// Last operation error surfaced to the UI (dialog/toast).
  final String? error;

  bool get notGitRepository => status?.notGitRepository == true;
  bool get hasCommits => status?.hasCommits == true;

  GitState copyWith({
    String? projectId,
    GitStatus? Function()? status,
    GitBranches? branches,
    List<GitCommit>? commits,
    List<GitCheckpoint>? checkpoints,
    GitRemoteStatus? remoteStatus,
    bool? loading,
    bool? busy,
    String? Function()? error,
  }) => GitState(
    projectId: projectId ?? this.projectId,
    status: status != null ? status() : this.status,
    branches: branches ?? this.branches,
    commits: commits ?? this.commits,
    checkpoints: checkpoints ?? this.checkpoints,
    remoteStatus: remoteStatus ?? this.remoteStatus,
    loading: loading ?? this.loading,
    busy: busy ?? this.busy,
    error: error != null ? error() : this.error,
  );
}

/// Git panel state (T23): status + staging + hunks, commits, branches,
/// remote ops, destructive discard, checkpoints and `git init`. Mutations
/// set [GitState.busy] and refresh afterwards so the panel mirrors the
/// real index — never optimistic.
class GitController extends Notifier<GitState> {
  GitRepository get _repo => ref.read(gitRepositoryProvider);

  @override
  GitState build() => const GitState();

  String get _pid {
    final pid = state.projectId;
    if (pid == null) throw StateError('no project selected');
    return pid;
  }

  void selectProject(String? projectId) {
    if (projectId == state.projectId) return;
    state = GitState(projectId: projectId, loading: projectId != null);
    if (projectId != null) unawaited(refresh());
  }

  /// Full reload — status first (it decides the not-git/init path), the
  /// rest best-effort so one failing call doesn't blank the panel.
  Future<void> refresh() async {
    final pid = state.projectId;
    if (pid == null) return;
    state = state.copyWith(loading: true, error: () => null);
    try {
      final raw = await _repo.status(pid);
      if (!ref.mounted || state.projectId != pid) return;
      state = state.copyWith(status: () => GitStatus.fromJson(raw));
    } on AppError catch (e) {
      if (!ref.mounted || state.projectId != pid) return;
      if (_isNotGit(e)) {
        state = state.copyWith(
          status: () => const GitStatus(notGitRepository: true),
          loading: false,
        );
        return;
      }
      state = state.copyWith(loading: false, error: () => e.message);
      return;
    }
    if (!ref.mounted || state.projectId != pid) return;
    state = state.copyWith(loading: false);
    await Future.wait([
      _loadBranches(pid),
      _loadCommits(pid),
      _loadCheckpoints(pid),
      _loadRemoteStatus(pid),
    ]);
  }

  /// Server marks non-repos with 400 'Not a git repository' (flat string
  /// error — the code/envelope shape isn't used by this module).
  static bool _isNotGit(AppError e) =>
      e is ServerError && e.message.toLowerCase().contains('not a git');

  Future<void> _loadBranches(String pid) async {
    try {
      final res = await _repo.branches(pid);
      if (ref.mounted) {
        state = state.copyWith(branches: GitBranches.fromJson(res));
      }
    } on AppError catch (_) {}
  }

  Future<void> _loadCommits(String pid, {int? limit}) async {
    try {
      final res = await _repo.commits(pid, limit: limit);
      if (ref.mounted) {
        state = state.copyWith(
          commits: [
            for (final c in res['commits'] as List? ?? const [])
              if (c is Map) GitCommit.fromJson(Map<String, dynamic>.from(c)),
          ],
        );
      }
    } on AppError catch (_) {}
  }

  Future<void> _loadCheckpoints(String pid) async {
    try {
      final res = await _repo.checkpoints(pid);
      if (ref.mounted) {
        state = state.copyWith(
          checkpoints: [
            for (final c in res['checkpoints'] as List? ?? const [])
              if (c is Map) GitCheckpoint.fromJson(Map<String, dynamic>.from(c)),
          ],
        );
      }
    } on AppError catch (_) {}
  }

  Future<void> _loadRemoteStatus(String pid) async {
    try {
      final res = await _repo.remoteStatus(pid);
      if (ref.mounted) {
        state = state.copyWith(
          remoteStatus: GitRemoteStatus.fromJson(res),
        );
      }
    } on AppError catch (_) {}
  }

  /// Runs a mutation under the busy flag, refreshes on success, surfaces
  /// the server message on failure. Returns false when it failed.
  Future<bool> _mutate(Future<void> Function() op) async {
    if (state.busy) return false;
    state = state.copyWith(busy: true, error: () => null);
    try {
      await op();
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

  // ─── Staging ─────────────────────────────────────────────────────────

  Future<bool> stage(List<String> files) =>
      _mutate(() => _repo.stage(_pid, files));
  Future<bool> unstage(List<String> files) =>
      _mutate(() => _repo.unstage(_pid, files));
  Future<bool> stageAll() =>
      _mutate(() => _repo.stage(_pid, [...?state.status?.unstaged, ...?state.status?.untracked]));
  Future<bool> unstageAll() =>
      _mutate(() => _repo.unstage(_pid, [...?state.status?.staged]));

  Future<bool> stageHunks(String filePath, List<Map<String, dynamic>> hunks) =>
      _mutate(() => _repo.stageHunks(_pid, filePath, hunks));
  Future<bool> unstageHunks(String filePath, List<Map<String, dynamic>> hunks) =>
      _mutate(() => _repo.unstageHunks(_pid, filePath, hunks));

  // ─── Commits ─────────────────────────────────────────────────────────

  Future<bool> commit(String message, List<String> files) =>
      _mutate(() => _repo.commit(_pid, message, files));
  Future<bool> initialCommit() =>
      _mutate(() => _repo.initialCommit(_pid));

  /// AI-generated commit message — returns the text (not a mutation).
  Future<String?> generateCommitMessage(List<String> files) async {
    try {
      final res = await _repo.generateCommitMessage(_pid, files);
      return (res['message'] ?? res['commitMessage'] ?? res['text'])?.toString();
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.message);
      return null;
    }
  }

  // ─── Branches ────────────────────────────────────────────────────────

  Future<bool> checkout(String branch) =>
      _mutate(() => _repo.checkout(_pid, branch));
  Future<bool> createBranch(String branch) =>
      _mutate(() => _repo.createBranch(_pid, branch));
  Future<bool> deleteBranch(String branch) =>
      _mutate(() => _repo.deleteBranch(_pid, branch));

  // ─── Remote ──────────────────────────────────────────────────────────

  Future<bool> fetch() => _mutate(() => _repo.fetch(_pid));
  Future<bool> pull() => _mutate(() => _repo.pull(_pid));
  Future<bool> push() => _mutate(() => _repo.push(_pid));
  Future<bool> publish() => _mutate(() => _repo.publish(_pid));

  // ─── Destructive ─────────────────────────────────────────────────────

  Future<bool> discard(String filePath) =>
      _mutate(() => _repo.discard(_pid, filePath));
  Future<bool> deleteUntracked(String filePath) =>
      _mutate(() => _repo.deleteUntracked(_pid, filePath));

  // ─── Checkpoints ─────────────────────────────────────────────────────

  Future<bool> createCheckpoint({String? label}) =>
      _mutate(() => _repo.checkpoint(_pid, label: label));
  Future<bool> restoreCheckpoint(String ref) =>
      _mutate(() => _repo.checkpointRestore(_pid, ref));
  Future<bool> revertLocalCommit() =>
      _mutate(() => _repo.revertLocalCommit(_pid, ''));

  // ─── Init ────────────────────────────────────────────────────────────

  Future<bool> init() => _mutate(() => _repo.init(_pid));
}

final gitProvider = NotifierProvider<GitController, GitState>(
  GitController.new,
);
