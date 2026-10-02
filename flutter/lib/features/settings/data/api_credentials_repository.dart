import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String _str(Object? v) => v?.toString() ?? '';
String? _strOrNull(Object? v) => v?.toString();

bool _isActive(Object? v) => v == true || v == 1;

/// One API key row from `GET /api/settings/api-keys` — the server returns
/// snake_case (`key_name`, `api_key` already masked, `is_active` 0/1).
class ApiKeyEntry {
  const ApiKeyEntry({
    required this.id,
    required this.name,
    required this.maskedKey,
    this.createdAt,
    this.lastUsed,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String maskedKey;
  final String? createdAt;
  final String? lastUsed;
  final bool isActive;

  static ApiKeyEntry fromJson(Map<String, dynamic> j) => ApiKeyEntry(
    id: _str(j['id']),
    name: _str(j['key_name'] ?? j['keyName']),
    maskedKey: _str(j['api_key'] ?? j['apiKey']),
    createdAt: _strOrNull(j['created_at'] ?? j['createdAt']),
    lastUsed: _strOrNull(j['last_used'] ?? j['lastUsed']),
    isActive: _isActive(j['is_active'] ?? j['isActive'] ?? true),
  );
}

/// Freshly created key — returned once by POST /api/settings/api-keys as
/// `{apiKey: {id, keyName, apiKey}}` (camelCase, full secret).
class CreatedApiKey {
  const CreatedApiKey({required this.id, required this.name, required this.key});

  final String id;
  final String name;
  final String key;

  static CreatedApiKey fromJson(Map<String, dynamic> j) => CreatedApiKey(
    id: _str(j['id']),
    name: _str(j['keyName'] ?? j['key_name']),
    key: _str(j['apiKey'] ?? j['api_key']),
  );
}

/// One stored credential (GitHub token) — server never returns the value.
class GithubCredentialEntry {
  const GithubCredentialEntry({
    required this.id,
    required this.name,
    this.description,
    this.createdAt,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String? description;
  final String? createdAt;
  final bool isActive;

  static GithubCredentialEntry fromJson(Map<String, dynamic> j) => GithubCredentialEntry(
    id: _str(j['id'] ?? j['credentialId']),
    name: _str(j['credential_name'] ?? j['credentialName']),
    description: _strOrNull(j['description']),
    createdAt: _strOrNull(j['created_at'] ?? j['createdAt']),
    isActive: _isActive(j['is_active'] ?? j['isActive'] ?? true),
  );
}

/// `/api/settings` api-keys + `?type=github_token` credentials — the web
/// `useCredentialsSettings` endpoints. (The generic `settings_repository.dart`
/// models predate the real server shapes; this one matches them.)
class ApiCredentialsRepository {
  const ApiCredentialsRepository(this._dio);

  final Dio _dio;

  Future<List<ApiKeyEntry>> apiKeys() =>
      apiCall(() => _dio.get<dynamic>('/api/settings/api-keys'), (d) {
        final list = (d as Map<String, dynamic>)['apiKeys'] as List? ?? const [];
        return [for (final k in list) ApiKeyEntry.fromJson(k as Map<String, dynamic>)];
      });

  /// Creates a key; the full secret is returned only in this response.
  Future<CreatedApiKey?> createApiKey(String keyName) =>
      apiCall(() => _dio.post<dynamic>('/api/settings/api-keys', data: {'keyName': keyName}), (d) {
        final raw = (d as Map<String, dynamic>)['apiKey'];
        return raw is Map<String, dynamic> ? CreatedApiKey.fromJson(raw) : null;
      });

  Future<void> deleteApiKey(String keyId) =>
      apiCall(() => _dio.delete<dynamic>('/api/settings/api-keys/$keyId'), (_) {});

  /// Server requires the target state in the body (`isActive` bool).
  Future<void> toggleApiKey(String keyId, bool isActive) => apiCall(
    () => _dio.patch<dynamic>('/api/settings/api-keys/$keyId/toggle', data: {'isActive': isActive}),
    (_) {},
  );

  Future<List<GithubCredentialEntry>> githubCredentials() => apiCall(
    () => _dio.get<dynamic>('/api/settings/credentials', queryParameters: {'type': 'github_token'}),
    (d) {
      final list = (d as Map<String, dynamic>)['credentials'] as List? ?? const [];
      return [for (final c in list) GithubCredentialEntry.fromJson(c as Map<String, dynamic>)];
    },
  );

  Future<void> createGithubCredential({
    required String name,
    required String token,
    String description = '',
  }) => apiCall(
    () => _dio.post<dynamic>(
      '/api/settings/credentials',
      data: {
        'credentialName': name,
        'credentialType': 'github_token',
        'credentialValue': token,
        'description': description,
      },
    ),
    (_) {},
  );

  Future<void> deleteCredential(String credentialId) =>
      apiCall(() => _dio.delete<dynamic>('/api/settings/credentials/$credentialId'), (_) {});

  Future<void> toggleCredential(String credentialId, bool isActive) => apiCall(
    () => _dio.patch<dynamic>(
      '/api/settings/credentials/$credentialId/toggle',
      data: {'isActive': isActive},
    ),
    (_) {},
  );
}

final apiCredentialsRepositoryProvider = Provider<ApiCredentialsRepository>(
  (ref) => ApiCredentialsRepository(ref.watch(dioProvider)),
);
