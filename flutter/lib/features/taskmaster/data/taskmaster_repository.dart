import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// /api/taskmaster — installation/mcp status, tasks, PRD CRUD + templates,
/// init/add/update/delete/parse-prd/apply-template. Payloads stay as maps —
/// task shapes come straight from tasks.json and evolve per version.
class TaskmasterRepository {
  const TaskmasterRepository(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> installationStatus() => apiCall(
    () => _dio.get<dynamic>('/api/taskmaster/installation-status'),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> mcpStatus() => apiCall(
    () => _dio.get<dynamic>('/api/taskmaster/mcp-status'),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> tasks(String projectId) => apiCall(
    () => _dio.get<dynamic>('/api/taskmaster/tasks/$projectId'),
    (d) => d as Map<String, dynamic>,
  );

  Future<List<Map<String, dynamic>>> prdList(String projectId) => apiCall(
    () => _dio.get<dynamic>('/api/taskmaster/prd/$projectId'),
    (d) => d is List
        ? [for (final p in d) p as Map<String, dynamic>]
        : [
            for (final p in (d as Map<String, dynamic>)['files'] as List? ?? const [])
              p as Map<String, dynamic>,
          ],
  );

  Future<Map<String, dynamic>> createPrd(String projectId, Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/taskmaster/prd/$projectId', data: body),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> prdFile(String projectId, String fileName) => apiCall(
    () => _dio.get<dynamic>('/api/taskmaster/prd/$projectId/$fileName'),
    (d) => d as Map<String, dynamic>,
  );

  Future<void> init(String projectId) =>
      apiCall(() => _dio.post<dynamic>('/api/taskmaster/init/$projectId'), (_) {});

  Future<Map<String, dynamic>> addTask(String projectId, Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/taskmaster/add-task/$projectId', data: body),
    (d) => d as Map<String, dynamic>,
  );

  Future<void> updateTask(String projectId, String taskId, Map<String, dynamic> updates) => apiCall(
    () => _dio.put<dynamic>('/api/taskmaster/update-task/$projectId/$taskId', data: updates),
    (_) {},
  );

  Future<void> deleteTask(String projectId, String taskId) =>
      apiCall(() => _dio.delete<dynamic>('/api/taskmaster/delete-task/$projectId/$taskId'), (_) {});

  Future<Map<String, dynamic>> parsePrd(
    String projectId, {
    String? fileName,
    int? numTasks,
    bool? append,
  }) => apiCall(
    () => _dio.post<dynamic>(
      '/api/taskmaster/parse-prd/$projectId',
      data: {'fileName': fileName, 'numTasks': numTasks, 'append': append},
    ),
    (d) => d as Map<String, dynamic>,
  );

  Future<List<Map<String, dynamic>>> prdTemplates() => apiCall(
    () => _dio.get<dynamic>('/api/taskmaster/prd-templates'),
    (d) => d is List
        ? [for (final t in d) t as Map<String, dynamic>]
        : [
            for (final t in (d as Map<String, dynamic>)['templates'] as List? ?? const [])
              t as Map<String, dynamic>,
          ],
  );

  Future<Map<String, dynamic>> applyTemplate(String projectId, Map<String, dynamic> body) =>
      apiCall(
        () => _dio.post<dynamic>('/api/taskmaster/apply-template/$projectId', data: body),
        (d) => d as Map<String, dynamic>,
      );
}

final taskmasterRepositoryProvider = Provider<TaskmasterRepository>(
  (ref) => TaskmasterRepository(ref.watch(dioProvider)),
);
