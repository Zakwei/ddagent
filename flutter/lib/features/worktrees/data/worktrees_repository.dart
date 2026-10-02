import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/worktrees/data/worktrees_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// /api/worktrees — list/create/open/merge/status/config/run/stop/remove.
class WorktreesRepository {
  const WorktreesRepository(this._dio);

  final Dio _dio;

  Future<WorktreeListData> list(String projectId) => apiCall(
    () => _dio.get<dynamic>('/api/worktrees/', queryParameters: {'project': projectId}),
    (d) => WorktreeListData.fromJson(d as Map<String, dynamic>),
  );

  Future<WorktreeScriptsStatus> status(String projectId) => apiCall(
    () => _dio.get<dynamic>('/api/worktrees/status', queryParameters: {'project': projectId}),
    (d) => WorktreeScriptsStatus.fromJson(d as Map<String, dynamic>),
  );

  Future<WorktreeScriptsConfig> saveConfig(
    String projectId, {
    String? setup,
    String? run,
    int? runPort,
  }) => apiCall(
    () => _dio.put<dynamic>(
      '/api/worktrees/config',
      data: {'project': projectId, 'setup': setup, 'run': run, 'runPort': runPort},
    ),
    (d) => WorktreeScriptsConfig.fromJson(d as Map<String, dynamic>),
  );

  Future<Project> create(String projectId, String branch, {String? baseBranch}) => apiCall(
    () => _dio.post<dynamic>(
      '/api/worktrees/create',
      data: {'project': projectId, 'branch': branch, 'baseBranch': ?baseBranch},
    ),
    (d) {
      final map = d as Map<String, dynamic>;
      final projectData = map['project'] as Map<String, dynamic>? ?? map;
      return Project.fromJson(projectData);
    },
  );

  Future<Project> open(String projectId, String worktreePath) => apiCall(
    () => _dio.post<dynamic>(
      '/api/worktrees/open',
      data: {'project': projectId, 'worktreePath': worktreePath},
    ),
    (d) {
      final map = d as Map<String, dynamic>;
      final projectData = map['project'] as Map<String, dynamic>? ?? map;
      return Project.fromJson(projectData);
    },
  );

  Future<MergeWorktreeResult> merge(
    String projectId,
    String worktreePath, {
    bool squash = false,
    String? message,
    bool removeAfterMerge = false,
  }) => apiCall(
    () => _dio.post<dynamic>(
      '/api/worktrees/merge',
      data: {
        'project': projectId,
        'worktreePath': worktreePath,
        'squash': squash,
        'message': ?message,
        'removeAfterMerge': removeAfterMerge,
      },
    ),
    (d) => MergeWorktreeResult.fromJson(d as Map<String, dynamic>),
  );

  Future<WorktreeRunRuntime> run(String targetProjectId) => apiCall(
    () => _dio.post<dynamic>('/api/worktrees/$targetProjectId/run'),
    (d) => WorktreeRunRuntime.fromJson(d as Map<String, dynamic>),
  );

  Future<WorktreeRunRuntime> stop(String targetProjectId) => apiCall(
    () => _dio.post<dynamic>('/api/worktrees/$targetProjectId/stop'),
    (d) => WorktreeRunRuntime.fromJson(d as Map<String, dynamic>),
  );

  Future<RemoveWorktreeResult> remove(
    String projectId,
    String worktreePath, {
    bool force = false,
    bool deleteBranch = false,
  }) => apiCall(
    () => _dio.post<dynamic>(
      '/api/worktrees/remove',
      data: {
        'project': projectId,
        'worktreePath': worktreePath,
        'force': force,
        'deleteBranch': deleteBranch,
      },
    ),
    (d) => RemoveWorktreeResult.fromJson(d as Map<String, dynamic>),
  );
}

final worktreesRepositoryProvider = Provider<WorktreesRepository>(
  (ref) => WorktreesRepository(ref.watch(dioProvider)),
);
