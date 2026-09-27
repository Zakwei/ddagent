import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// /api/scheduler — schedules CRUD, cron preview, run-now, run history.
class SchedulerRepository {
  const SchedulerRepository(this._dio);

  final Dio _dio;

  Future<List<Map<String, dynamic>>> list() =>
      apiCall(() => _dio.get<dynamic>('/api/scheduler'), (d) {
        final list = d is List ? d : (d as Map<String, dynamic>)['schedules'] as List? ?? const [];
        return [for (final s in list) s as Map<String, dynamic>];
      });

  /// Cron expression → next fire times.
  Future<Map<String, dynamic>> preview(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/scheduler/preview', data: body),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> create(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/scheduler', data: body),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> body) => apiCall(
    () => _dio.patch<dynamic>('/api/scheduler/$id', data: body),
    (d) => d as Map<String, dynamic>,
  );

  Future<void> delete(String id) =>
      apiCall(() => _dio.delete<dynamic>('/api/scheduler/$id'), (_) {});

  Future<Map<String, dynamic>> runNow(String id) => apiCall(
    () => _dio.post<dynamic>('/api/scheduler/$id/run-now'),
    (d) => d as Map<String, dynamic>,
  );

  Future<List<Map<String, dynamic>>> runs(String id) =>
      apiCall(() => _dio.get<dynamic>('/api/scheduler/$id/runs'), (d) {
        final list = d is List ? d : (d as Map<String, dynamic>)['runs'] as List? ?? const [];
        return [for (final r in list) r as Map<String, dynamic>];
      });
}

final schedulerRepositoryProvider = Provider<SchedulerRepository>(
  (ref) => SchedulerRepository(ref.watch(dioProvider)),
);
