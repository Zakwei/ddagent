import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'projects_repository.freezed.dart';
part 'projects_repository.g.dart';

/// Project API view — mirrors ProjectApiView / ArchivedProjectListItem.
/// `sessions` stay loosely typed here; the typed session model lives in
/// features/sessions (T5.5).
@freezed
abstract class Project with _$Project {
  const factory Project({
    required String projectId,
    required String path,
    required String displayName,
    String? fullPath,
    String? customName,
    @Default(false) bool isArchived,
    @Default(false) bool isStarred,
    @Default([]) List<Map<String, dynamic>> sessions,
    SessionMeta? sessionMeta,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
}

@freezed
abstract class SessionMeta with _$SessionMeta {
  const factory SessionMeta({@Default(false) bool hasMore, @Default(0) int total}) = _SessionMeta;

  factory SessionMeta.fromJson(Map<String, dynamic> json) => _$SessionMetaFromJson(json);
}

@freezed
abstract class ProjectSessionsPage with _$ProjectSessionsPage {
  const factory ProjectSessionsPage({
    required String projectId,
    @Default([]) List<Map<String, dynamic>> sessions,
    SessionMeta? sessionMeta,
  }) = _ProjectSessionsPage;

  factory ProjectSessionsPage.fromJson(Map<String, dynamic> json) =>
      _$ProjectSessionsPageFromJson(json);
}

/// /api/projects — CRUD, archive/star/restore/rename, sessions paging,
/// taskmaster metadata, clone-progress (SSE), legacy-star migration.
class ProjectsRepository {
  const ProjectsRepository(this._dio);

  final Dio _dio;

  List<Project> _projectList(dynamic d) {
    // GET / returns a bare list; /archived wraps in {success, data: {projects}}.
    if (d is Map<String, dynamic> && d['data'] is Map<String, dynamic>) {
      d = d['data'];
    }
    final list = d is List ? d : (d as Map<String, dynamic>)['projects'] as List? ?? const [];
    return [for (final p in list) Project.fromJson(p as Map<String, dynamic>)];
  }

  Future<List<Project>> list({bool skipSync = false, int? sessionsLimit, int? sessionsOffset}) =>
      apiCall(
        () => _dio.get<dynamic>(
          '/api/projects',
          queryParameters: {
            if (skipSync) 'skipSynchronization': '1',
            'sessionsLimit': ?sessionsLimit,
            'sessionsOffset': ?sessionsOffset,
          },
        ),
        _projectList,
      );

  Future<List<Project>> archived() =>
      apiCall(() => _dio.get<dynamic>('/api/projects/archived'), _projectList);

  Future<ProjectSessionsPage> sessions(String projectId, {int limit = 20, int offset = 0}) =>
      apiCall(
        () => _dio.get<dynamic>(
          '/api/projects/$projectId/sessions',
          queryParameters: {'limit': limit, 'offset': offset},
        ),
        (d) => ProjectSessionsPage.fromJson(d as Map<String, dynamic>),
      );

  /// Returns the project; rejects clone fields server-side (CLONE_NOT_SUPPORTED).
  Future<Project> create({required String path, String? customName}) => apiCall(
    () => _dio.post<dynamic>(
      '/api/projects/create-project',
      data: {'path': path, 'customName': customName},
    ),
    (d) => Project.fromJson((d as Map<String, dynamic>)['project'] as Map<String, dynamic>),
  );

  Future<void> rename(String projectId, String displayName) => apiCall(
    () => _dio.put<dynamic>('/api/projects/$projectId/rename', data: {'displayName': displayName}),
    (_) {},
  );

  Future<void> toggleStar(String projectId) =>
      apiCall(() => _dio.post<dynamic>('/api/projects/$projectId/toggle-star'), (_) {});

  Future<void> restore(String projectId) =>
      apiCall(() => _dio.post<dynamic>('/api/projects/$projectId/restore'), (_) {});

  /// Archive by default; `hardDelete` maps to `?force=true`.
  Future<void> delete(String projectId, {bool hardDelete = false}) => apiCall(
    () => _dio.delete<dynamic>(
      '/api/projects/$projectId',
      queryParameters: hardDelete ? {'force': 'true'} : null,
    ),
    (_) {},
  );

  /// TaskMaster metadata for the project (installation status, task counts).
  Future<Map<String, dynamic>> taskmaster(String projectId) => apiCall(
    () => _dio.get<dynamic>('/api/projects/$projectId/taskmaster'),
    (d) => d as Map<String, dynamic>,
  );

  /// SSE stream URL for clone progress. EventSource-capable transports must
  /// append `&token=<jwt>` (see AuthTokenStore.tokenQueryParam).
  String cloneProgressUrl(
    String baseUrl, {
    required String path,
    required String githubUrl,
    String? githubTokenId,
    String? newGithubToken,
  }) {
    final params = {
      'path': path,
      'githubUrl': githubUrl,
      'githubTokenId': ?githubTokenId,
      'newGithubToken': ?newGithubToken,
    };
    return Uri.parse('$baseUrl/api/projects/clone-progress')
        .replace(queryParameters: params)
        .toString();
  }

  /// One-time migration of localStorage-era starred projectIds into the DB.
  Future<int> migrateLegacyStars(List<String> projectIds) => apiCall(
    () =>
        _dio.post<dynamic>('/api/projects/migrate-legacy-stars', data: {'projectIds': projectIds}),
    (d) => ((d as Map<String, dynamic>)['updated'] as num?)?.toInt() ?? 0,
  );
}

final projectsRepositoryProvider = Provider<ProjectsRepository>(
  (ref) => ProjectsRepository(ref.watch(dioProvider)),
);
