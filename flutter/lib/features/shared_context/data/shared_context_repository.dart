import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// /api/shared-context — per-project shared context document (GET/PUT by
/// projectId).
class SharedContextRepository {
  const SharedContextRepository(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> get(String projectId) => apiCall(
    () => _dio.get<dynamic>('/api/shared-context', queryParameters: {'projectId': projectId}),
    (d) => d as Map<String, dynamic>,
  );

  Future<void> put(String projectId, String content) => apiCall(
    () => _dio.put<dynamic>(
      '/api/shared-context',
      data: {'projectId': projectId, 'content': content},
    ),
    (_) {},
  );
}

final sharedContextRepositoryProvider = Provider<SharedContextRepository>(
  (ref) => SharedContextRepository(ref.watch(dioProvider)),
);
