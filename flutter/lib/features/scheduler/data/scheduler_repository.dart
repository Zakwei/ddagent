import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// /api/schedules — CRUD, cron preview (GET ?cron=), run-now, run history.
class SchedulerRepository {
  const SchedulerRepository(this._dio);

  final Dio _dio;

  Future<List<Map<String, dynamic>>> list() =>
      apiCall(() => _dio.get<dynamic>('/api/schedules'), (d) {
        final inner =
            (d as Map<String, dynamic>)['data'] as Map<String, dynamic>? ?? d;
        final list = inner['schedules'] as List? ?? const [];
        return [for (final s in list) s as Map<String, dynamic>];
      });

  /// Cron expression → `{cron, nextRunAt}`.
  Future<Map<String, dynamic>> preview(String cron) => apiCall(
    () => _dio.get<dynamic>(
      '/api/schedules/preview',
      queryParameters: {'cron': cron},
    ),
    (d) => (d as Map<String, dynamic>)['data'] as Map<String, dynamic>? ?? d,
  );

  Future<Map<String, dynamic>> create(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/schedules', data: body),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> body) =>
      apiCall(
        () => _dio.patch<dynamic>('/api/schedules/$id', data: body),
        (d) => d as Map<String, dynamic>,
      );

  Future<void> delete(String id) =>
      apiCall(() => _dio.delete<dynamic>('/api/schedules/$id'), (_) {});

  Future<Map<String, dynamic>> runNow(String id) => apiCall(
    () => _dio.post<dynamic>('/api/schedules/$id/run-now'),
    (d) => d as Map<String, dynamic>,
  );

  Future<List<Map<String, dynamic>>> runs(String id) =>
      apiCall(() => _dio.get<dynamic>('/api/schedules/$id/runs'), (d) {
        final inner =
            (d as Map<String, dynamic>)['data'] as Map<String, dynamic>? ?? d;
        final list = inner['runs'] as List? ?? const [];
        return [for (final r in list) r as Map<String, dynamic>];
      });
}

final schedulerRepositoryProvider = Provider<SchedulerRepository>(
  (ref) => SchedulerRepository(ref.watch(dioProvider)),
);
