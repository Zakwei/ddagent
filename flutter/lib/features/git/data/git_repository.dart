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
      _g('/status', {'projectPath': projectPath});
  Future<Map<String, dynamic>> diff(String projectPath, {String? filePath}) =>
      _g('/diff', {'projectPath': projectPath, 'filePath': ?filePath});

  /// Server resolves `project` (id) → repo path itself; `file` is the
  /// project-relative path. Returns {currentContent, oldContent, isDeleted,
  /// isUntracked}.
  Future<Map<String, dynamic>> fileWithDiff(
    String projectId,
    String filePath,
  ) => _g('/file-with-diff', {'project': projectId, 'file': filePath});
  Future<Map<String, dynamic>> branches(String projectPath) =>
      _g('/branches', {'projectPath': projectPath});
  Future<Map<String, dynamic>> commits(String projectPath, {int? limit}) =>
      _g('/commits', {'projectPath': projectPath, 'limit': ?limit});
  Future<Map<String, dynamic>> commitDiff(String projectPath, String sha) =>
      _g('/commit-diff', {'projectPath': projectPath, 'sha': sha});
  Future<Map<String, dynamic>> remoteStatus(String projectPath) =>
      _g('/remote-status', {'projectPath': projectPath});
  Future<Map<String, dynamic>> checkpoints(String projectPath) =>
      _g('/checkpoint/list', {'projectPath': projectPath});

  Future<Map<String, dynamic>> stage(String projectPath, List<String> files) =>
      _p('/stage', {'projectPath': projectPath, 'files': files});
  Future<Map<String, dynamic>> unstage(
    String projectPath,
    List<String> files,
  ) => _p('/unstage', {'projectPath': projectPath, 'files': files});
  Future<Map<String, dynamic>> stageHunks(
    String projectPath,
    String filePath,
    List<Map<String, dynamic>> hunks,
  ) => _p('/stage-hunks', {
    'projectPath': projectPath,
    'filePath': filePath,
    'hunks': hunks,
  });
  Future<Map<String, dynamic>> unstageHunks(
    String projectPath,
    String filePath,
    List<Map<String, dynamic>> hunks,
  ) => _p('/unstage-hunks', {
    'projectPath': projectPath,
    'filePath': filePath,
    'hunks': hunks,
  });
  Future<Map<String, dynamic>> commit(String projectPath, String message) =>
      _p('/commit', {'projectPath': projectPath, 'message': message});
  Future<Map<String, dynamic>> generateCommitMessage(String projectPath) =>
      _p('/generate-commit-message', {'projectPath': projectPath});
  Future<Map<String, dynamic>> checkout(String projectPath, String branch) =>
      _p('/checkout', {'projectPath': projectPath, 'branch': branch});
  Future<Map<String, dynamic>> createBranch(
    String projectPath,
    String branch,
  ) => _p('/create-branch', {'projectPath': projectPath, 'branch': branch});
  Future<Map<String, dynamic>> deleteBranch(
    String projectPath,
    String branch,
  ) => _p('/delete-branch', {'projectPath': projectPath, 'branch': branch});

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
  ) => _p('/revert-local-commit', {'projectPath': projectPath, 'sha': sha});
  Future<Map<String, dynamic>> fetch(String projectPath) =>
      _p('/fetch', {'projectPath': projectPath});
  Future<Map<String, dynamic>> pull(String projectPath) =>
      _p('/pull', {'projectPath': projectPath});
  Future<Map<String, dynamic>> push(String projectPath) =>
      _p('/push', {'projectPath': projectPath});
  Future<Map<String, dynamic>> publish(String projectPath) =>
      _p('/publish', {'projectPath': projectPath});
  Future<Map<String, dynamic>> init(String projectPath) =>
      _p('/init', {'projectPath': projectPath});
  Future<Map<String, dynamic>> initialCommit(String projectPath) =>
      _p('/initial-commit', {'projectPath': projectPath});
  Future<Map<String, dynamic>> checkpoint(String projectPath) =>
      _p('/checkpoint', {'projectPath': projectPath});
  Future<Map<String, dynamic>> checkpointRestore(
    String projectPath,
    String checkpointId,
  ) => _p('/checkpoint/restore', {
    'projectPath': projectPath,
    'checkpointId': checkpointId,
  });
}

final gitRepositoryProvider = Provider<GitRepository>(
  (ref) => GitRepository(ref.watch(dioProvider)),
);
