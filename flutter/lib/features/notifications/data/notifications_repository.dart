import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `GET /channels/telegram/chats` payload — `detected` rows are raw
/// `{chatId, title, type, seenAt}`, `paired` rows `{endpointId, label,
/// enabled}` (see `sanitizeEndpoint` server-side).
class TelegramChats {
  const TelegramChats({this.detected = const [], this.paired = const []});

  final List<Map<String, dynamic>> detected;
  final List<Map<String, dynamic>> paired;
}

/// /api/notifications — endpoints CRUD, channel config/test, telegram chats,
/// approval responses.
class NotificationsRepository {
  const NotificationsRepository(this._dio);

  final Dio _dio;

  /// `GET /endpoints?channel=<channel>` — the channel param is required
  /// server-side (400 without it). Returns the raw `{endpoints: [...]}` map.
  Future<Map<String, dynamic>> endpoints({required String channel}) => apiCall(
    () => _dio.get<dynamic>('/api/notifications/endpoints', queryParameters: {'channel': channel}),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> addCurrentEndpoint(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/notifications/endpoints/current', data: body),
    (d) => d as Map<String, dynamic>,
  );

  Future<void> updateEndpoint(String channel, String endpointId, Map<String, dynamic> body) =>
      apiCall(
        () => _dio.patch<dynamic>('/api/notifications/endpoints/$channel/$endpointId', data: body),
        (_) {},
      );

  Future<void> deleteEndpoint(String channel, String endpointId) => apiCall(
    () => _dio.delete<dynamic>('/api/notifications/endpoints/$channel/$endpointId'),
    (_) {},
  );

  Future<Map<String, dynamic>> channelsConfig() => apiCall(
    () => _dio.get<dynamic>('/api/notifications/channels/config'),
    (d) => d as Map<String, dynamic>,
  );

  Future<void> saveChannelConfig(String channel, Map<String, dynamic> body) => apiCall(
    () => _dio.put<dynamic>('/api/notifications/channels/$channel/config', data: body),
    (_) {},
  );

  Future<Map<String, dynamic>> testChannel(String channel) => apiCall(
    () => _dio.post<dynamic>('/api/notifications/channels/$channel/test'),
    (d) => d as Map<String, dynamic>,
  );

  /// `GET /channels/telegram/chats` — `{detected: [...], paired: [...]}`:
  /// chats that recently messaged the bot plus already-paired endpoints.
  Future<TelegramChats> telegramChats() =>
      apiCall(() => _dio.get<dynamic>('/api/notifications/channels/telegram/chats'), (d) {
        final m = d as Map<String, dynamic>? ?? const {};
        List<Map<String, dynamic>> rows(String key) => [
          for (final c in m[key] as List? ?? const [])
            if (c is Map) Map<String, dynamic>.from(c),
        ];
        return TelegramChats(detected: rows('detected'), paired: rows('paired'));
      });

  /// Approve/reject a pending approval request.
  Future<void> respondToApproval(String requestId, Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/notifications/approvals/$requestId', data: body),
    (_) {},
  );
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => NotificationsRepository(ref.watch(dioProvider)),
);
