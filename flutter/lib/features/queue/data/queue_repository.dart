import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// /api/queue + /api/sessions/:id/inbox — server-side outbound message queue
/// (survives refresh/device switch) and the agent inbox.
class QueueRepository {
  const QueueRepository(this._dio);

  final Dio _dio;

  Future<List<Map<String, dynamic>>> list(String sessionId) => apiCall(
    () => _dio.get<dynamic>('/api/queue', queryParameters: {'sessionId': sessionId}),
    (d) {
      final list = d is List ? d : (d as Map<String, dynamic>)['messages'] as List? ?? const [];
      return [for (final m in list) m as Map<String, dynamic>];
    },
  );

  Future<Map<String, dynamic>> enqueue(
    String sessionId, {
    required String content,
    Map<String, dynamic>? options,
  }) => apiCall(
    () => _dio.post<dynamic>(
      '/api/queue',
      data: {'sessionId': sessionId, 'content': content, 'options': ?options},
    ),
    (d) => d as Map<String, dynamic>,
  );

  /// Per-session results: `{'sessionId': ..., 'ok': bool, 'error'?: ...}` —
  /// the UI shows which targets rejected the message.
  Future<List<Map<String, dynamic>>> broadcast(
    List<String> sessionIds,
    String content, {
    Map<String, dynamic>? options,
  }) => apiCall(
    () => _dio.post<dynamic>(
      '/api/queue/broadcast',
      data: {'sessionIds': sessionIds, 'content': content, 'options': ?options},
    ),
    (d) => [
      for (final r in (d as Map<String, dynamic>)['results'] as List? ?? const [])
        r as Map<String, dynamic>,
    ],
  );

  /// Moves one queued message to the front of its session's queue so it is
  /// the next turn sent — it never interrupts the turn already running.
  Future<void> sendNow(String id) =>
      apiCall(() => _dio.post<dynamic>('/api/queue/$id/send-now'), (_) {});

  Future<void> delete(String id) => apiCall(() => _dio.delete<dynamic>('/api/queue/$id'), (_) {});

  /// Push text into a session's queue from another session/tool.
  Future<void> inbox(String sessionId, String text, {String? source}) => apiCall(
    () => _dio.post<dynamic>(
      '/api/sessions/$sessionId/inbox',
      data: {'text': text, 'source': ?source},
    ),
    (_) {},
  );
}

final queueRepositoryProvider = Provider<QueueRepository>(
  (ref) => QueueRepository(ref.watch(dioProvider)),
);
