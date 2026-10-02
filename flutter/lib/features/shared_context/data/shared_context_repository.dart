import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/features/shared_context/data/shared_context_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// /api/shared-context — per-project shared context document (GET/PUT by project).
class SharedContextRepository {
  const SharedContextRepository(this._dio);

  final Dio _dio;

  Future<SharedContextDocument> get(String projectId) => apiCall(
    () => _dio.get<dynamic>('/api/shared-context', queryParameters: {'project': projectId}),
    (d) => SharedContextDocument.fromJson(d as Map<String, dynamic>),
  );

  Future<SharedContextDocument> put(String projectId, String content) => apiCall(
    () =>
        _dio.put<dynamic>('/api/shared-context', data: {'project': projectId, 'content': content}),
    (d) => SharedContextDocument.fromJson(d as Map<String, dynamic>),
  );
}

final sharedContextRepositoryProvider = Provider<SharedContextRepository>(
  (ref) => SharedContextRepository(ref.watch(dioProvider)),
);
