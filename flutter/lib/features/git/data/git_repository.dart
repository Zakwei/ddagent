import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// /api/git — status/diff/stage-hunks/commit/branches/commits/checkpoints/
/// remote ops/discard/init (28 endpoints; bodies are repo-scoped maps).
class GitRepository {
  const GitRepository(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> _g(String path, Map<String, dynamic> query) =>
      apiCall(
        () => _dio.get<dynamic>('/api/git$path', queryParameters: query),
        (d) => d as Map<String, dynamic>,
      );

  Future<Map<String, dynamic>> _p(String path, Map<String, dynamic> body) =>
      apiCall(
        () => _dio.post<dynamic>('/api/git$path', data: body),
        (d) => d is Map<String, dynamic> ? d : {'ok': true},
      );

  Future<Map<String, dynamic>> status(String project) =>
      _g('/status', {'project': project});
  Future<Map<String, dynamic>> diff(String project, {String? filePath}) =>
      _g('/diff', {'project': project, 'file': ?filePath});

  /// Server resolves `project` (id) → repo path itself; `file` is the
  /// project-relative path. Returns {currentContent, oldContent, isDeleted,
  /// isUntracked}.
  Future<Map<String, dynamic>> fileWithDiff(
    String projectId,
    String filePath,
  ) => _g('/file-with-diff', {'project': projectId, 'file': filePath});
  Future<Map<String, dynamic>> branches(String project) =>
      _g('/branches', {'project': project});
  Future<Map<String, dynamic>> commits(String project, {int? limit}) =>
      _g('/commits', {'project': project, 'limit': ?limit});
  Future<Map<String, dynamic>> commitDiff(String project, String sha) =>
      _g('/commit-diff', {'project': project, 'commit': sha});
  Future<Map<String, dynamic>> remoteStatus(String project) =>
      _g('/remote-status', {'project': project});
  Future<Map<String, dynamic>> checkpoints(String project) =>
      _g('/checkpoint/list', {'project': project});

  Future<Map<String, dynamic>> stage(String project, List<String> files) =>
      _p('/stage', {'project': project, 'files': files});
  Future<Map<String, dynamic>> unstage(
    String project,
    List<String> files,
  ) => _p('/unstage', {'project': project, 'files': files});
  Future<Map<String, dynamic>> stageHunks(
    String project,
    String filePath,
    List<Map<String, dynamic>> hunks,
  ) => _p('/stage-hunks', {
    'project': project,
    'filePath': filePath,
    'hunks': hunks,
  });
  Future<Map<String, dynamic>> unstageHunks(
    String project,
    String filePath,
    List<Map<String, dynamic>> hunks,
  ) => _p('/unstage-hunks', {
    'project': project,
    'filePath': filePath,
    'hunks': hunks,
  });
  Future<Map<String, dynamic>> commit(
    String project,
    String message,
    List<String> files,
  ) => _p('/commit', {
    'project': project,
    'message': message,
    'files': files,
  });
  Future<Map<String, dynamic>> generateCommitMessage(
    String project,
    List<String> files,
  ) => _p('/generate-commit-message', {
    'project': project,
    'files': files,
  });
  Future<Map<String, dynamic>> checkout(String project, String branch) =>
      _p('/checkout', {'project': project, 'branch': branch});
  Future<Map<String, dynamic>> createBranch(
    String project,
    String branch,
  ) => _p('/create-branch', {'project': project, 'branch': branch});
  Future<Map<String, dynamic>> deleteBranch(
    String project,
    String branch,
  ) => _p('/delete-branch', {'project': project, 'branch': branch});

  /// Single file — restores tracked changes or deletes untracked files.
  Future<Map<String, dynamic>> discard(String projectId, String filePath) =>
      _p('/discard', {'project': projectId, 'file': filePath});
  Future<Map<String, dynamic>> deleteUntracked(
    String projectId,
    String filePath,
  ) => _p('/delete-untracked', {'project': projectId, 'file': filePath});
  Future<Map<String, dynamic>> revertLocalCommit(
    String project,
    String sha,
  ) => _p('/revert-local-commit', {'project': project});
  Future<Map<String, dynamic>> fetch(String project) =>
      _p('/fetch', {'project': project});
  Future<Map<String, dynamic>> pull(String project) =>
      _p('/pull', {'project': project});
  Future<Map<String, dynamic>> push(String project) =>
      _p('/push', {'project': project});
  Future<Map<String, dynamic>> publish(String project) =>
      _p('/publish', {'project': project});
  Future<Map<String, dynamic>> init(String project) =>
      _p('/init', {'project': project});
  Future<Map<String, dynamic>> initialCommit(String project) =>
      _p('/initial-commit', {'project': project});
  Future<Map<String, dynamic>> checkpoint(String project) =>
      _p('/checkpoint', {'project': project});
  Future<Map<String, dynamic>> checkpointRestore(
    String project,
    String checkpointId,
  ) => _p('/checkpoint/restore', {
    'project': project,
    'ref': checkpointId,
  });
}

final gitRepositoryProvider = Provider<GitRepository>(
  (ref) => GitRepository(ref.watch(dioProvider)),
);
