import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// /api/orchestrator — config, session fan-out, plan confirmation,
/// resume/continue.
class OrchestratorRepository {
  const OrchestratorRepository(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> config() => apiCall(
    () => _dio.get<dynamic>('/api/orchestrator/config'),
    (d) => d as Map<String, dynamic>,
  );

  Future<void> saveConfig(Map<String, dynamic> body) =>
      apiCall(() => _dio.put<dynamic>('/api/orchestrator/config', data: body), (_) {});

  /// Creates one Auto (orchestrator) session — body needs `projectPath` and
  /// `provider: 'orchestrator'`; optional `initialMessage`.
  Future<Map<String, dynamic>> createSession(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/orchestrator/sessions', data: body),
    (d) => d as Map<String, dynamic>,
  );

  /// Parent session id for an orchestrated session (`null` when it's a root).
  Future<String?> parentSession(String sessionId) => apiCall(
    () => _dio.get<dynamic>('/api/orchestrator/sessions/$sessionId/parent'),
    (d) {
      if (d is! Map) return null;
      final id = d['parentSessionId'];
      if (id != null) return id.toString();
      // Legacy shape: {parent: {sessionId}}.
      final parent = d['parent'];
      if (parent is Map) return parent['sessionId']?.toString();
      return null;
    },
  );

  /// Confirms a generated plan (gates session creation server-side).
  Future<Map<String, dynamic>> confirmPlan(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/orchestrator/plan/confirm', data: body),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> resume(String sessionId, Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/orchestrator/sessions/$sessionId/resume', data: body),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> continueSession(String sessionId, Map<String, dynamic> body) =>
      apiCall(
        () => _dio.post<dynamic>('/api/orchestrator/sessions/$sessionId/continue', data: body),
        (d) => d as Map<String, dynamic>,
      );
}

final orchestratorRepositoryProvider = Provider<OrchestratorRepository>(
  (ref) => OrchestratorRepository(ref.watch(dioProvider)),
);
