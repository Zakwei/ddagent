import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/features/knowledge/data/knowledge_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Knowledge API — CRUD for memories/rules/skills/personal info plus tags,
/// connections, search, stats, graph, history, scan and export/import.
/// Empty/unset filters are dropped from the query string (no `?x=` noise).
class KnowledgeRepository {
  const KnowledgeRepository(this._dio);

  final Dio _dio;

  /// `GET /api/knowledge/memories` — global rows included when [includeGlobal].
  Future<List<KbMemory>> memories({
    String? projectId,
    bool includeGlobal = false,
    String? priority,
    String? tag,
    String? memoryType,
  }) => apiCall(
    () => _dio.get<dynamic>(
      '/api/knowledge/memories',
      queryParameters: {
        if (projectId != null && projectId.isNotEmpty) 'projectId': projectId,
        if (includeGlobal) 'includeGlobal': 'true',
        if (priority != null && priority.isNotEmpty) 'priority': priority,
        if (tag != null && tag.isNotEmpty) 'tag': tag,
        if (memoryType != null && memoryType.isNotEmpty) 'memoryType': memoryType,
      },
    ),
    (d) => [
      for (final m in (d as Map<String, dynamic>)['memories'] as List? ?? const [])
        KbMemory.fromJson(m as Map<String, dynamic>),
    ],
  );

  /// `GET /api/knowledge/rules` — [enabledOnly] filters disabled rules out.
  Future<List<KbRule>> rules({
    String? projectId,
    bool includeGlobal = false,
    bool enabledOnly = false,
    String? priority,
  }) => apiCall(
    () => _dio.get<dynamic>(
      '/api/knowledge/rules',
      queryParameters: {
        if (projectId != null && projectId.isNotEmpty) 'projectId': projectId,
        if (includeGlobal) 'includeGlobal': 'true',
        if (enabledOnly) 'enabledOnly': 'true',
        if (priority != null && priority.isNotEmpty) 'priority': priority,
      },
    ),
    (d) => [
      for (final r in (d as Map<String, dynamic>)['rules'] as List? ?? const [])
        KbRule.fromJson(r as Map<String, dynamic>),
    ],
  );

  /// `GET /api/knowledge/skills`.
  Future<List<KbSkill>> skills({String? category}) => apiCall(
    () => _dio.get<dynamic>(
      '/api/knowledge/skills',
      queryParameters: {if (category != null && category.isNotEmpty) 'category': category},
    ),
    (d) => [
      for (final s in (d as Map<String, dynamic>)['skills'] as List? ?? const [])
        KbSkill.fromJson(s as Map<String, dynamic>),
    ],
  );

  /// `GET /api/knowledge/personal` — keyed personal-information rows.
  Future<List<KbPersonal>> personal() => apiCall(
    () => _dio.get<dynamic>('/api/knowledge/personal'),
    (d) => [
      for (final p in (d as Map<String, dynamic>)['personal'] as List? ?? const [])
        KbPersonal.fromJson(p as Map<String, dynamic>),
    ],
  );

  /// `GET /api/knowledge/tags` — tags with usage counts.
  Future<List<KbTag>> tags() => apiCall(
    () => _dio.get<dynamic>('/api/knowledge/tags'),
    (d) => [
      for (final t in (d as Map<String, dynamic>)['tags'] as List? ?? const [])
        KbTag.fromJson(t as Map<String, dynamic>),
    ],
  );

  /// `GET /api/knowledge/connections` — all edges, or those of one [entityId].
  Future<List<KbConnection>> connections({String? entityId}) => apiCall(
    () => _dio.get<dynamic>(
      '/api/knowledge/connections',
      queryParameters: {if (entityId != null && entityId.isNotEmpty) 'entityId': entityId},
    ),
    (d) => [
      for (final c in (d as Map<String, dynamic>)['connections'] as List? ?? const [])
        KbConnection.fromJson(c as Map<String, dynamic>),
    ],
  );

  /// `GET /api/knowledge/search?q=` — [entityType] narrows to one entity kind.
  Future<List<KbSearchResult>> search(String query, {String? entityType, String? projectId}) =>
      apiCall(
        () => _dio.get<dynamic>(
          '/api/knowledge/search',
          queryParameters: {
            if (query.isNotEmpty) 'q': query,
            if (entityType != null && entityType.isNotEmpty) 'type': entityType,
            if (projectId != null && projectId.isNotEmpty) 'projectId': projectId,
          },
        ),
        (d) => [
          for (final r in (d as Map<String, dynamic>)['results'] as List? ?? const [])
            KbSearchResult.fromJson(r as Map<String, dynamic>),
        ],
      );

  /// `GET /api/knowledge/stats` — entity counters for the dashboard.
  Future<KbStats> stats() => apiCall(
    () => _dio.get<dynamic>('/api/knowledge/stats'),
    (d) => KbStats.fromJson(d as Map<String, dynamic>),
  );

  /// `GET /api/knowledge/context` — preview of the `<knowledge>` block injected
  /// into a session's first turn (markdown + estimated tokens + budget).
  Future<Map<String, dynamic>> contextPreview(String? projectId) => apiCall(
    () => _dio.get<dynamic>(
      '/api/knowledge/context',
      queryParameters: {if (projectId != null && projectId.isNotEmpty) 'projectId': projectId},
    ),
    (d) => d as Map<String, dynamic>,
  );

  /// `GET /api/knowledge/graph` — [entityTypes] is sent as `types=a,b,c`.
  Future<KbGraph> graph({String? projectId, List<String>? entityTypes}) => apiCall(
    () => _dio.get<dynamic>(
      '/api/knowledge/graph',
      queryParameters: {
        if (projectId != null && projectId.isNotEmpty) 'projectId': projectId,
        if (entityTypes != null && entityTypes.isNotEmpty) 'types': entityTypes.join(','),
      },
    ),
    (d) {
      final map = d as Map<String, dynamic>;
      return KbGraph.fromJson(map['graph'] as Map<String, dynamic>? ?? map);
    },
  );

  /// `GET /api/knowledge/history` — write history for one entity or kind.
  Future<List<KbHistoryEntry>> history({String? entityType, String? entityId}) => apiCall(
    () => _dio.get<dynamic>(
      '/api/knowledge/history',
      queryParameters: {
        if (entityType != null && entityType.isNotEmpty) 'entityType': entityType,
        if (entityId != null && entityId.isNotEmpty) 'entityId': entityId,
      },
    ),
    (d) => [
      for (final h in (d as Map<String, dynamic>)['history'] as List? ?? const [])
        KbHistoryEntry.fromJson(h as Map<String, dynamic>),
    ],
  );

  // --- mutations ---

  /// `POST /api/knowledge/memories`.
  Future<KbMemory> createMemory(Map<String, dynamic> body) =>
      apiCall(() => _dio.post<dynamic>('/api/knowledge/memories', data: body), (d) {
        final map = d as Map<String, dynamic>;
        return KbMemory.fromJson(map['memory'] as Map<String, dynamic>? ?? map);
      });

  /// `PATCH /api/knowledge/memories/{id}`.
  Future<KbMemory> updateMemory(String id, Map<String, dynamic> body) => apiCall(
    () => _dio.patch<dynamic>('/api/knowledge/memories/${Uri.encodeComponent(id)}', data: body),
    (d) {
      final map = d as Map<String, dynamic>;
      return KbMemory.fromJson(map['memory'] as Map<String, dynamic>? ?? map);
    },
  );

  /// `DELETE /api/knowledge/memories/{id}`.
  Future<void> deleteMemory(String id) => apiCall(
    () => _dio.delete<dynamic>('/api/knowledge/memories/${Uri.encodeComponent(id)}'),
    (_) {},
  );

  /// `POST /api/knowledge/rules`.
  Future<KbRule> createRule(Map<String, dynamic> body) =>
      apiCall(() => _dio.post<dynamic>('/api/knowledge/rules', data: body), (d) {
        final map = d as Map<String, dynamic>;
        return KbRule.fromJson(map['rule'] as Map<String, dynamic>? ?? map);
      });

  /// `PATCH /api/knowledge/rules/{id}`.
  Future<KbRule> updateRule(String id, Map<String, dynamic> body) => apiCall(
    () => _dio.patch<dynamic>('/api/knowledge/rules/${Uri.encodeComponent(id)}', data: body),
    (d) {
      final map = d as Map<String, dynamic>;
      return KbRule.fromJson(map['rule'] as Map<String, dynamic>? ?? map);
    },
  );

  /// `DELETE /api/knowledge/rules/{id}`.
  Future<void> deleteRule(String id) => apiCall(
    () => _dio.delete<dynamic>('/api/knowledge/rules/${Uri.encodeComponent(id)}'),
    (_) {},
  );

  /// `POST /api/knowledge/skills`.
  Future<KbSkill> createSkill(Map<String, dynamic> body) =>
      apiCall(() => _dio.post<dynamic>('/api/knowledge/skills', data: body), (d) {
        final map = d as Map<String, dynamic>;
        return KbSkill.fromJson(map['skill'] as Map<String, dynamic>? ?? map);
      });

  /// `PATCH /api/knowledge/skills/{id}`.
  Future<KbSkill> updateSkill(String id, Map<String, dynamic> body) => apiCall(
    () => _dio.patch<dynamic>('/api/knowledge/skills/${Uri.encodeComponent(id)}', data: body),
    (d) {
      final map = d as Map<String, dynamic>;
      return KbSkill.fromJson(map['skill'] as Map<String, dynamic>? ?? map);
    },
  );

  /// `DELETE /api/knowledge/skills/{id}`.
  Future<void> deleteSkill(String id) => apiCall(
    () => _dio.delete<dynamic>('/api/knowledge/skills/${Uri.encodeComponent(id)}'),
    (_) {},
  );

  /// `POST /api/knowledge/personal` — server returns `personalInformation`.
  Future<KbPersonal> createPersonal(Map<String, dynamic> body) =>
      apiCall(() => _dio.post<dynamic>('/api/knowledge/personal', data: body), (d) {
        final map = d as Map<String, dynamic>;
        return KbPersonal.fromJson(map['personalInformation'] as Map<String, dynamic>? ?? map);
      });

  /// `PATCH /api/knowledge/personal/{id}` — server returns `personalInformation`.
  Future<KbPersonal> updatePersonal(String id, Map<String, dynamic> body) => apiCall(
    () => _dio.patch<dynamic>('/api/knowledge/personal/${Uri.encodeComponent(id)}', data: body),
    (d) {
      final map = d as Map<String, dynamic>;
      return KbPersonal.fromJson(map['personalInformation'] as Map<String, dynamic>? ?? map);
    },
  );

  /// `DELETE /api/knowledge/personal/{id}`.
  Future<void> deletePersonal(String id) => apiCall(
    () => _dio.delete<dynamic>('/api/knowledge/personal/${Uri.encodeComponent(id)}'),
    (_) {},
  );

  /// `POST /api/knowledge/connections` — link two entities.
  Future<KbConnection> createConnection(Map<String, dynamic> body) =>
      apiCall(() => _dio.post<dynamic>('/api/knowledge/connections', data: body), (d) {
        final map = d as Map<String, dynamic>;
        return KbConnection.fromJson(map['connection'] as Map<String, dynamic>? ?? map);
      });

  /// `DELETE /api/knowledge/connections/{id}`.
  Future<void> deleteConnection(String id) => apiCall(
    () => _dio.delete<dynamic>('/api/knowledge/connections/${Uri.encodeComponent(id)}'),
    (_) {},
  );

  /// `DELETE /api/knowledge/tags/{id}` — drops the tag from every entity.
  Future<void> deleteTag(int id) =>
      apiCall(() => _dio.delete<dynamic>('/api/knowledge/tags/$id'), (_) {});

  /// `POST /api/knowledge/scan` — re-import the project's knowledge files.
  Future<KnowledgeScanResult> scan(String projectId) => apiCall(
    () => _dio.post<dynamic>('/api/knowledge/scan', data: {'projectId': projectId}),
    (d) => KnowledgeScanResult.fromJson(d as Map<String, dynamic>),
  );

  /// `POST /api/knowledge/migrate` — scans projects and reports/merges
  /// duplicate entities and/or promotes rules. Dry run by default; only
  /// [dedupe]/[promoteRules] with `dryRun: false` write anything.
  Future<Map<String, dynamic>> migrate({
    List<String>? projectIds,
    bool dryRun = true,
    bool dedupe = false,
    bool promoteRules = false,
  }) => apiCall(
    () => _dio.post<dynamic>(
      '/api/knowledge/migrate',
      data: {
        if (projectIds != null && projectIds.isNotEmpty) 'projectIds': projectIds,
        'dryRun': dryRun,
        if (dedupe) 'dedupe': true,
        if (promoteRules) 'promoteRules': true,
      },
    ),
    (d) => d as Map<String, dynamic>,
  );

  /// `POST /api/knowledge/import-skills` — imports global/default agent skills
  /// (user/system/plugin) into the knowledge base. Dry run by default.
  Future<Map<String, dynamic>> importAgentSkills({List<String>? providers, bool dryRun = true}) =>
      apiCall(
        () => _dio.post<dynamic>(
          '/api/knowledge/import-skills',
          data: {
            if (providers != null && providers.isNotEmpty) 'providers': providers,
            'dryRun': dryRun,
          },
        ),
        (d) => d as Map<String, dynamic>,
      );

  /// `GET /api/knowledge/export` — full snapshot, passed back to [importAll].
  Future<Map<String, dynamic>> exportAll() =>
      apiCall(() => _dio.get<dynamic>('/api/knowledge/export'), (d) => d as Map<String, dynamic>);

  /// `POST /api/knowledge/import` — returns the `imported` counters.
  Future<Map<String, dynamic>> importAll(Map<String, dynamic> payload) => apiCall(
    () => _dio.post<dynamic>('/api/knowledge/import', data: payload),
    (d) => (d as Map<String, dynamic>)['imported'] as Map<String, dynamic>? ?? const {},
  );
}

final knowledgeRepositoryProvider = Provider<KnowledgeRepository>(
  (ref) => KnowledgeRepository(ref.watch(dioProvider)),
);
