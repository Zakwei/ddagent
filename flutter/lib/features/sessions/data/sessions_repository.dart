import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sessions_repository.freezed.dart';
part 'sessions_repository.g.dart';

/// Session list/detail row — field names follow the API (session.id in the
/// web UI maps to [sessionId] here for clarity). Provider-specific extras
/// stay in [raw].
@Freezed(toJson: false)
abstract class Session with _$Session {
  const factory Session({
    required String sessionId,
    String? provider,
    String? providerSessionId,
    String? summary,
    String? projectPath,
    String? lastActivity,
    String? createdAt,
    @Default(false) bool isArchived,
    @Default(false) bool isRunning,
    @JsonKey(includeFromJson: false, includeToJson: false) @Default({}) Map<String, dynamic> raw,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

  /// API-tolerant parse: `id` alias, int bools, raw row preserved.
  static Session fromApi(Map<String, dynamic> json) {
    return Session.fromJson({
      ...json,
      'sessionId': json['sessionId'] ?? json['id'],
      'isArchived': json['isArchived'] == true || json['isArchived'] == 1,
      'isRunning': json['isRunning'] == true || json['isRunning'] == 1,
    }).copyWith(raw: json);
  }
}

@Freezed(toJson: false)
abstract class SessionsPage with _$SessionsPage {
  const factory SessionsPage({
    @Default([]) List<Session> sessions,
    @Default(false) bool hasMore,
    @Default(0) int total,
  }) = _SessionsPage;

  factory SessionsPage.fromJson(Map<String, dynamic> json) => _$SessionsPageFromJson({
    ...json,
    'hasMore': (json['sessionMeta'] as Map?)?['hasMore'] ?? json['hasMore'] ?? false,
    'total': (json['sessionMeta'] as Map?)?['total'] ?? json['total'] ?? 0,
  });
}

/// /api/providers + /api/providers/sessions — session CRUD/paging plus
/// provider metadata (models, skills, MCP servers, capabilities).
class SessionsRepository {
  const SessionsRepository(this._dio);

  final Dio _dio;

  List<Session> _sessionList(dynamic d) {
    final list = d is List ? d : (d as Map<String, dynamic>)['sessions'] as List? ?? const [];
    return [for (final s in list) Session.fromApi(s as Map<String, dynamic>)];
  }

  /// Allocates a session id — must be called BEFORE chat.send (the WS turn
  /// attaches to this id).
  Future<Session> createSession(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/providers/sessions', data: body),
    (d) => Session.fromApi((d as Map<String, dynamic>)['session'] as Map<String, dynamic>? ?? d),
  );

  Future<List<Session>> running() =>
      apiCall(() => _dio.get<dynamic>('/api/providers/sessions/running'), _sessionList);

  Future<List<Session>> archived() =>
      apiCall(() => _dio.get<dynamic>('/api/providers/sessions/archived'), _sessionList);

  Future<SessionsPage> recent({int limit = 40, int offset = 0}) => apiCall(
    () => _dio.get<dynamic>(
      '/api/providers/sessions/recent',
      queryParameters: {'limit': limit, 'offset': offset},
    ),
    // FromJson bypass would skip the `id` alias — map rows via _sessionList.
    (d) => d is List
        ? SessionsPage(sessions: _sessionList(d))
        : SessionsPage(
            sessions: _sessionList(d),
            hasMore:
                ((d as Map<String, dynamic>)['sessionMeta'] as Map?)?['hasMore'] as bool? ??
                (d['hasMore'] as bool? ?? false),
            total:
                ((d['sessionMeta'] as Map?)?['total'] as num?)?.toInt() ??
                (d['total'] as num?)?.toInt() ??
                0,
          ),
  );

  Future<Session> details(String sessionId) => apiCall(
    () => _dio.get<dynamic>('/api/providers/sessions/$sessionId'),
    (d) => Session.fromApi((d as Map<String, dynamic>)['session'] as Map<String, dynamic>? ?? d),
  );

  /// Unified persisted-messages endpoint; provider/project resolved server-side.
  Future<Map<String, dynamic>> messages(String sessionId, {int? limit, int offset = 0}) => apiCall(
    () => _dio.get<dynamic>(
      '/api/providers/sessions/$sessionId/messages',
      queryParameters: {'limit': ?limit, 'offset': offset},
    ),
    (d) => d as Map<String, dynamic>,
  );

  Future<String?> providerSessionId(String sessionId) => apiCall(
    () => _dio.get<dynamic>('/api/providers/sessions/$sessionId/provider-id'),
    (d) => (d as Map<String, dynamic>)['providerSessionId'] as String?,
  );

  Future<List<Map<String, dynamic>>> changedFiles(String sessionId) => apiCall(
    () => _dio.get<dynamic>('/api/providers/sessions/$sessionId/changed-files'),
    (d) => [
      for (final f in (d as Map<String, dynamic>)['files'] as List? ?? const [])
        f as Map<String, dynamic>,
    ],
  );

  Future<Map<String, dynamic>> tokenUsage(String sessionId) => apiCall(
    () => _dio.get<dynamic>('/api/providers/sessions/$sessionId/token-usage'),
    (d) => d as Map<String, dynamic>,
  );

  Future<void> markViewed(String sessionId) =>
      apiCall(() => _dio.post<dynamic>('/api/providers/sessions/$sessionId/viewed'), (_) {});

  Future<void> rename(String sessionId, String summary) => apiCall(
    () => _dio.put<dynamic>('/api/providers/sessions/$sessionId', data: {'summary': summary}),
    (_) {},
  );

  Future<void> changeWorkspace(String sessionId, String projectPath) => apiCall(
    () => _dio.put<dynamic>(
      '/api/providers/sessions/$sessionId/workspace',
      data: {'projectPath': projectPath},
    ),
    (_) {},
  );

  Future<void> restore(String sessionId) =>
      apiCall(() => _dio.post<dynamic>('/api/providers/sessions/$sessionId/restore'), (_) {});

  /// Archive by default; `hardDelete` => `?force=true` (row + transcript).
  Future<void> delete(String sessionId, {bool hardDelete = false}) => apiCall(
    () => _dio.delete<dynamic>(
      '/api/providers/sessions/$sessionId',
      queryParameters: hardDelete ? {'force': 'true'} : null,
    ),
    (_) {},
  );

  // --- provider metadata ---

  Future<Map<String, dynamic>> authStatus(String provider) => apiCall(
    () => _dio.get<dynamic>('/api/providers/$provider/auth/status'),
    (d) => d as Map<String, dynamic>,
  );

  Future<List<Map<String, dynamic>>> models(String provider) => apiCall(
    () => _dio.get<dynamic>('/api/providers/$provider/models'),
    (d) => d is List
        ? [for (final m in d) m as Map<String, dynamic>]
        : [
            for (final m in (d as Map<String, dynamic>)['models'] as List? ?? const [])
              m as Map<String, dynamic>,
          ],
  );

  Future<Map<String, dynamic>> addModel(String provider, Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/providers/$provider/models', data: body),
    (d) => d as Map<String, dynamic>,
  );

  Future<void> updateModel(String provider, String recordId, Map<String, dynamic> body) => apiCall(
    () => _dio.patch<dynamic>('/api/providers/$provider/models/$recordId', data: body),
    (_) {},
  );

  Future<void> deleteModel(String provider, String recordId) =>
      apiCall(() => _dio.delete<dynamic>('/api/providers/$provider/models/$recordId'), (_) {});

  Future<Map<String, dynamic>> activeModel(String provider, String sessionId) => apiCall(
    () => _dio.get<dynamic>('/api/providers/$provider/sessions/$sessionId/active-model'),
    (d) => d as Map<String, dynamic>,
  );

  Future<void> setActiveModel(String provider, String sessionId, String modelId) => apiCall(
    () => _dio.post<dynamic>(
      '/api/providers/$provider/sessions/$sessionId/active-model',
      data: {'modelId': modelId},
    ),
    (_) {},
  );

  Future<void> setActiveEffort(String provider, String sessionId, String effort) => apiCall(
    () => _dio.post<dynamic>(
      '/api/providers/$provider/sessions/$sessionId/active-effort',
      data: {'effort': effort},
    ),
    (_) {},
  );

  Future<List<Map<String, dynamic>>> skills(String provider) => apiCall(
    () => _dio.get<dynamic>('/api/providers/$provider/skills'),
    (d) => d is List
        ? [for (final s in d) s as Map<String, dynamic>]
        : [
            for (final s in (d as Map<String, dynamic>)['skills'] as List? ?? const [])
              s as Map<String, dynamic>,
          ],
  );

  Future<Map<String, dynamic>> addSkill(String provider, Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/providers/$provider/skills', data: body),
    (d) => d as Map<String, dynamic>,
  );

  Future<void> deleteSkill(String provider, String directoryName) =>
      apiCall(() => _dio.delete<dynamic>('/api/providers/$provider/skills/$directoryName'), (_) {});

  Future<List<Map<String, dynamic>>> mcpServers(String provider) => apiCall(
    () => _dio.get<dynamic>('/api/providers/$provider/mcp/servers'),
    (d) => d is List
        ? [for (final s in d) s as Map<String, dynamic>]
        : [
            for (final s in (d as Map<String, dynamic>)['servers'] as List? ?? const [])
              s as Map<String, dynamic>,
          ],
  );

  Future<void> addMcpServer(String provider, Map<String, dynamic> body) =>
      apiCall(() => _dio.post<dynamic>('/api/providers/$provider/mcp/servers', data: body), (_) {});

  Future<void> deleteMcpServer(String provider, String name) =>
      apiCall(() => _dio.delete<dynamic>('/api/providers/$provider/mcp/servers/$name'), (_) {});

  Future<void> addGlobalMcpServer(Map<String, dynamic> body) =>
      apiCall(() => _dio.post<dynamic>('/api/providers/mcp/servers/global', data: body), (_) {});

  Future<Map<String, dynamic>> capabilities([String? provider]) => apiCall(
    () => _dio.get<dynamic>(
      provider == null ? '/api/providers/capabilities' : '/api/providers/$provider/capabilities',
    ),
    (d) => d as Map<String, dynamic>,
  );

  /// Full-text session search is SSE (text/event-stream), not a decoded list.
  /// Returns the stream URL for the SSE transport (T6); append
  /// `&token=<jwt>` (AuthTokenStore.tokenQueryParam) before connecting.
  String searchSessionsUrl(String baseUrl, String query, {int limit = 50}) {
    return Uri.parse('$baseUrl/api/providers/search/sessions')
        .replace(queryParameters: {'q': query, 'limit': '$limit'})
        .toString();
  }
}

/// View helpers over the loosely-typed [raw] row (provider-specific fields
/// that aren't worth a schema bump).
extension SessionView on Session {
  String get displayTitle =>
      (raw['summary'] ?? raw['title'] ?? summary ?? 'Session $sessionId').toString();

  String? get projectId => raw['projectId'] as String?;

  int get messageCount => (raw['messageCount'] as num?)?.toInt() ?? 0;

  String? get updatedAt => (raw['updatedAt'] ?? raw['lastActivity']) as String?;

  String? get lastViewedAt => raw['lastViewedAt'] as String?;

  /// Mobile parity: unread = not running and (never viewed or activity after
  /// the last view).
  bool get isUnread {
    if (isRunning) return false;
    final viewed = lastViewedAt;
    final activity = lastActivity;
    if (viewed == null) return activity != null;
    if (activity == null) return false;
    final v = DateTime.tryParse(viewed);
    final a = DateTime.tryParse(activity);
    return v != null && a != null && v.isBefore(a);
  }
}

final sessionsRepositoryProvider = Provider<SessionsRepository>(
  (ref) => SessionsRepository(ref.watch(dioProvider)),
);
