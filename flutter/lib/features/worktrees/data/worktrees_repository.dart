import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// /api/worktrees — list/create/open/merge/status/config/run/stop/remove.
class WorktreesRepository {
  const WorktreesRepository(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> list(String projectPath) => apiCall(
    () => _dio.get<dynamic>('/api/worktrees/', queryParameters: {'projectPath': projectPath}),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> status(String projectPath) => apiCall(
    () => _dio.get<dynamic>('/api/worktrees/status', queryParameters: {'projectPath': projectPath}),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> config(String projectPath, Map<String, dynamic> body) => apiCall(
    () => _dio.put<dynamic>('/api/worktrees/config', data: {'projectPath': projectPath, ...body}),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> create(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/worktrees/create', data: body),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> open(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/worktrees/open', data: body),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> merge(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/worktrees/merge', data: body),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> run(String id) =>
      apiCall(() => _dio.post<dynamic>('/api/worktrees/$id/run'), (d) => d as Map<String, dynamic>);

  Future<Map<String, dynamic>> stop(String id) => apiCall(
    () => _dio.post<dynamic>('/api/worktrees/$id/stop'),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> remove(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/worktrees/remove', data: body),
    (d) => d as Map<String, dynamic>,
  );
}

final worktreesRepositoryProvider = Provider<WorktreesRepository>(
  (ref) => WorktreesRepository(ref.watch(dioProvider)),
);
