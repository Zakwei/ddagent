import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// /api/mini-orchestrator — config and session creation for the two-role
/// mini orchestrator (thinker + worker), a lighter sibling of /api/orchestrator.
class MiniOrchestratorRepository {
  const MiniOrchestratorRepository(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> config() => apiCall(
    () => _dio.get<dynamic>('/api/mini-orchestrator/config'),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> saveConfig(Map<String, dynamic> body) => apiCall(
    () => _dio.put<dynamic>('/api/mini-orchestrator/config', data: {'config': body}),
    (d) => d as Map<String, dynamic>,
  );

  /// Creates one mini-orchestrated session — body needs `projectPath`; optional
  /// `initialMessage`.
  Future<Map<String, dynamic>> createSession(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/mini-orchestrator/sessions', data: body),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> confirmPlan(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/mini-orchestrator/plan/confirm', data: body),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> resume(String sessionId, Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/mini-orchestrator/sessions/$sessionId/resume', data: body),
    (d) => d as Map<String, dynamic>,
  );
}

final miniOrchestratorRepositoryProvider = Provider<MiniOrchestratorRepository>(
  (ref) => MiniOrchestratorRepository(ref.watch(dioProvider)),
);
