import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_repository.freezed.dart';
part 'settings_repository.g.dart';

@freezed
abstract class ApiKey with _$ApiKey {
  const factory ApiKey({
    String? id,
    String? name,
    String? prefix,
    String? createdAt,
    @Default(true) bool enabled,
  }) = _ApiKey;

  factory ApiKey.fromJson(Map<String, dynamic> json) => _$ApiKeyFromJson(json);
}

@freezed
abstract class Credential with _$Credential {
  const factory Credential({required String id, String? credentialName, String? credentialType}) =
      _Credential;

  factory Credential.fromJson(Map<String, dynamic> json) =>
      _$CredentialFromJson({...json, 'id': '${json['id'] ?? json['credentialId']}'});
}

/// /api/settings — api-keys + credentials CRUD, notification preferences,
/// Web Push (vapid key, subscribe/unsubscribe/test).
class SettingsRepository {
  const SettingsRepository(this._dio);

  final Dio _dio;

  // api-keys
  Future<List<ApiKey>> apiKeys() => apiCall(() => _dio.get<dynamic>('/api/settings/api-keys'), (d) {
    final list = d is List ? d : (d as Map<String, dynamic>)['apiKeys'] as List? ?? const [];
    return [for (final k in list) ApiKey.fromJson(k as Map<String, dynamic>)];
  });

  Future<Map<String, dynamic>> createApiKey(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/settings/api-keys', data: body),
    (d) => d as Map<String, dynamic>,
  );

  Future<void> deleteApiKey(String keyId) =>
      apiCall(() => _dio.delete<dynamic>('/api/settings/api-keys/$keyId'), (_) {});

  Future<void> toggleApiKey(String keyId) =>
      apiCall(() => _dio.patch<dynamic>('/api/settings/api-keys/$keyId/toggle'), (_) {});

  // credentials (secrets never leave the server)
  Future<List<Credential>> credentials() => apiCall(
    () => _dio.get<dynamic>('/api/settings/credentials'),
    (d) {
      final list = d is List ? d : (d as Map<String, dynamic>)['credentials'] as List? ?? const [];
      return [for (final c in list) Credential.fromJson(c as Map<String, dynamic>)];
    },
  );

  Future<Credential> createCredential(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/settings/credentials', data: body),
    (d) => Credential.fromJson(
      (d as Map<String, dynamic>)['credential'] as Map<String, dynamic>? ?? d,
    ),
  );

  Future<void> deleteCredential(String credentialId) =>
      apiCall(() => _dio.delete<dynamic>('/api/settings/credentials/$credentialId'), (_) {});

  Future<void> toggleCredential(String credentialId) =>
      apiCall(() => _dio.patch<dynamic>('/api/settings/credentials/$credentialId/toggle'), (_) {});

  // notification preferences
  Future<Map<String, dynamic>> notificationPreferences() => apiCall(
    () => _dio.get<dynamic>('/api/settings/notification-preferences'),
    (d) => d as Map<String, dynamic>,
  );

  Future<void> saveNotificationPreferences(Map<String, dynamic> body) => apiCall(
    () => _dio.put<dynamic>('/api/settings/notification-preferences', data: body),
    (_) {},
  );

  // web push
  Future<String?> vapidPublicKey() => apiCall(
    () => _dio.get<dynamic>('/api/settings/push/vapid-public-key'),
    (d) => (d as Map<String, dynamic>)['key'] as String? ?? d['publicKey'] as String?,
  );

  Future<void> pushSubscribe(Map<String, dynamic> subscription) =>
      apiCall(() => _dio.post<dynamic>('/api/settings/push/subscribe', data: subscription), (_) {});

  Future<void> pushUnsubscribe(Map<String, dynamic> subscription) => apiCall(
    () => _dio.post<dynamic>('/api/settings/push/unsubscribe', data: subscription),
    (_) {},
  );

  /// Sends a test push to every stored subscription; returns
  /// `{subscriptionCount, webPushConfigured, results:[{endpointHost, ok,
  /// statusCode, error}]}` — the payload the test summary needs.
  Future<Map<String, dynamic>> pushTest() =>
      apiCall(() => _dio.post<dynamic>('/api/settings/push/test'), (d) {
        if (d is Map<String, dynamic>) return d;
        return const <String, dynamic>{};
      });
}

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(dioProvider)),
);
