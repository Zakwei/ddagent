import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// /api/notifications — endpoints CRUD, channel config/test, telegram chats,
/// approval responses.
class NotificationsRepository {
  const NotificationsRepository(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> endpoints() => apiCall(
    () => _dio.get<dynamic>('/api/notifications/endpoints'),
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

  Future<List<Map<String, dynamic>>> telegramChats() => apiCall(
    () => _dio.get<dynamic>('/api/notifications/channels/telegram/chats'),
    (d) => d is List
        ? [for (final c in d) c as Map<String, dynamic>]
        : [
            for (final c in (d as Map<String, dynamic>)['chats'] as List? ?? const [])
              c as Map<String, dynamic>,
          ],
  );

  /// Approve/reject a pending approval request.
  Future<void> respondToApproval(String requestId, Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/notifications/approvals/$requestId', data: body),
    (_) {},
  );
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => NotificationsRepository(ref.watch(dioProvider)),
);
