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

  Future<Map<String, dynamic>> status(String projectPath) =>
      _g('/status', {'project': projectPath});
  Future<Map<String, dynamic>> diff(String projectPath, {String? filePath}) =>
      _g('/diff', {'project': projectPath, 'file': ?filePath});

  /// Server resolves `project` (id) → repo path itself; `file` is the
  /// project-relative path. Returns {currentContent, oldContent, isDeleted,
  /// isUntracked}.
  Future<Map<String, dynamic>> fileWithDiff(
    String projectId,
    String filePath,
  ) => _g('/file-with-diff', {'project': projectId, 'file': filePath});
  Future<Map<String, dynamic>> branches(String projectPath) =>
      _g('/branches', {'project': projectPath});
  Future<Map<String, dynamic>> commits(String projectPath, {int? limit}) =>
      _g('/commits', {'project': projectPath, 'limit': ?limit});
  Future<Map<String, dynamic>> commitDiff(String projectPath, String sha) =>
      _g('/commit-diff', {'project': projectPath, 'commit': sha});
  Future<Map<String, dynamic>> remoteStatus(String projectPath) =>
      _g('/remote-status', {'project': projectPath});
  Future<Map<String, dynamic>> checkpoints(String projectPath) =>
      _g('/checkpoint/list', {'project': projectPath});

  Future<Map<String, dynamic>> stage(String projectPath, List<String> files) =>
      _p('/stage', {'project': projectPath, 'files': files});
  Future<Map<String, dynamic>> unstage(
    String projectPath,
    List<String> files,
  ) => _p('/unstage', {'project': projectPath, 'files': files});
  Future<Map<String, dynamic>> stageHunks(
    String projectPath,
    String filePath,
    List<Map<String, dynamic>> hunks,
  ) => _p('/stage-hunks', {
    'project': projectPath,
    'filePath': filePath,
    'hunks': hunks,
  });
  Future<Map<String, dynamic>> unstageHunks(
    String projectPath,
    String filePath,
    List<Map<String, dynamic>> hunks,
  ) => _p('/unstage-hunks', {
    'project': projectPath,
    'filePath': filePath,
    'hunks': hunks,
  });
  Future<Map<String, dynamic>> commit(
    String projectPath,
    String message,
    List<String> files,
  ) => _p('/commit', {
    'project': projectPath,
    'message': message,
    'files': files,
  });
  Future<Map<String, dynamic>> generateCommitMessage(
    String projectPath,
    List<String> files,
  ) => _p('/generate-commit-message', {
    'project': projectPath,
    'files': files,
  });
  Future<Map<String, dynamic>> checkout(String projectPath, String branch) =>
      _p('/checkout', {'project': projectPath, 'branch': branch});
  Future<Map<String, dynamic>> createBranch(
    String projectPath,
    String branch,
  ) => _p('/create-branch', {'project': projectPath, 'branch': branch});
  Future<Map<String, dynamic>> deleteBranch(
    String projectPath,
    String branch,
  ) => _p('/delete-branch', {'project': projectPath, 'branch': branch});

  /// Single file — restores tracked changes or deletes untracked files.
  Future<Map<String, dynamic>> discard(String projectId, String filePath) =>
      _p('/discard', {'project': projectId, 'file': filePath});
  Future<Map<String, dynamic>> deleteUntracked(
    String projectId,
    String filePath,
  ) => _p('/delete-untracked', {'project': projectId, 'file': filePath});
  Future<Map<String, dynamic>> revertLocalCommit(
    String projectPath,
    String sha,
  ) => _p('/revert-local-commit', {'project': projectPath});
  Future<Map<String, dynamic>> fetch(String projectPath) =>
      _p('/fetch', {'project': projectPath});
  Future<Map<String, dynamic>> pull(String projectPath) =>
      _p('/pull', {'project': projectPath});
  Future<Map<String, dynamic>> push(String projectPath) =>
      _p('/push', {'project': projectPath});
  Future<Map<String, dynamic>> publish(String projectPath) =>
      _p('/publish', {'project': projectPath});
  Future<Map<String, dynamic>> init(String projectPath) =>
      _p('/init', {'project': projectPath});
  Future<Map<String, dynamic>> initialCommit(String projectPath) =>
      _p('/initial-commit', {'project': projectPath});
  Future<Map<String, dynamic>> checkpoint(String projectPath) =>
      _p('/checkpoint', {'project': projectPath});
  Future<Map<String, dynamic>> checkpointRestore(
    String projectPath,
    String checkpointId,
  ) => _p('/checkpoint/restore', {
    'project': projectPath,
    'ref': checkpointId,
  });
}

final gitRepositoryProvider = Provider<GitRepository>(
  (ref) => GitRepository(ref.watch(dioProvider)),
);
