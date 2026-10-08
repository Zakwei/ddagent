import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/features/mcp/data/mcp_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// MCP API — mirrors the fetch calls in `useMcpServers.ts` +
/// `McpServerTokens.tsx`:
/// - `GET/POST /api/providers/{provider}/mcp/servers` (+ `scope`,
///   `workspacePath` params)
/// - `DELETE /api/providers/{provider}/mcp/servers/{name}`
/// - `POST /api/providers/mcp/servers/global`
/// - `GET/POST/DELETE /api/mcp/tokens[/{id}]` (DDAgent's own MCP endpoint)
class McpRepository {
  const McpRepository(this._dio);

  final Dio _dio;

  /// Servers of one [scope]; [project] targets a workspace file for the
  /// project/local scopes (`?scope=..&workspacePath=..`).
  Future<List<McpServer>> servers(String provider, McpScope scope, {McpProjectTarget? project}) =>
      apiCall(
        () => _dio.get<dynamic>(
          '/api/providers/$provider/mcp/servers',
          queryParameters: {
            'scope': scope.wire,
            if (project != null && project.path.isNotEmpty) 'workspacePath': project.path,
          },
        ),
        (d) => [
          for (final s in (d as Map<String, dynamic>)['servers'] as List? ?? const [])
            McpServer.fromApi(
              provider,
              scope,
              Map<String, dynamic>.from(s as Map),
              project: project,
            ),
        ],
      );

  /// Upsert — `POST /api/providers/{provider}/mcp/servers`.
  Future<void> upsert(String provider, Map<String, dynamic> payload) => apiCall(
    () => _dio.post<dynamic>('/api/providers/$provider/mcp/servers', data: payload),
    (_) {},
  );

  /// `DELETE /api/providers/{provider}/mcp/servers/{name}` — scope and
  /// workspacePath params identify which config file loses the entry.
  Future<void> delete(String provider, McpServer server) => apiCall(
    () => _dio.delete<dynamic>(
      '/api/providers/$provider/mcp/servers/'
      '${Uri.encodeComponent(server.name)}',
      queryParameters: {
        'scope': server.scope.wire,
        if (server.workspacePath?.isNotEmpty ?? false) 'workspacePath': server.workspacePath,
      },
    ),
    (_) {},
  );

  /// `POST /api/providers/mcp/servers/global` — writes one config into every
  /// provider; per-provider outcomes come back in `results`.
  Future<List<GlobalMcpResult>> saveGlobal(Map<String, dynamic> payload) => apiCall(
    () => _dio.post<dynamic>('/api/providers/mcp/servers/global', data: payload),
    (d) => [
      for (final r in (d as Map<String, dynamic>)['results'] as List? ?? const [])
        GlobalMcpResult.fromJson(Map<String, dynamic>.from(r as Map)),
    ],
  );

  // --- DDAgent MCP endpoint tokens (`/api/mcp/tokens`) ---

  Future<List<McpToken>> tokens() => apiCall(
    () => _dio.get<dynamic>('/api/mcp/tokens'),
    (d) => [
      for (final t in (d as Map<String, dynamic>)['tokens'] as List? ?? const [])
        McpToken.fromJson(Map<String, dynamic>.from(t as Map)),
    ],
  );

  /// Returns the plaintext token — shown exactly once after creation.
  Future<String?> createToken({required String label, required String scope}) => apiCall(
    () => _dio.post<dynamic>('/api/mcp/tokens', data: {'label': label, 'scope': scope}),
    (d) => (d as Map<String, dynamic>)['token'] as String?,
  );

  Future<void> revokeToken(String id) =>
      apiCall(() => _dio.delete<dynamic>('/api/mcp/tokens/${Uri.encodeComponent(id)}'), (_) {});

  /// `POST /api/mcp/install` — installs the DDAgent MCP server (pointing at
  /// `/mcp` with a bearer token) into provider CLIs. Empty/omitted [providers]
  /// installs on every provider; returns the per-provider outcomes.
  Future<List<GlobalMcpResult>> installDdagent({List<String>? providers, String scope = 'write'}) =>
      apiCall(
        () => _dio.post<dynamic>(
          '/api/mcp/install',
          data: {
            if (providers != null && providers.isNotEmpty) 'providers': providers,
            'scope': scope,
          },
        ),
        (d) => [
          for (final r in (d as Map<String, dynamic>)['results'] as List? ?? const [])
            GlobalMcpResult.fromJson(Map<String, dynamic>.from(r as Map)),
        ],
      );
}

final mcpRepositoryProvider = Provider<McpRepository>(
  (ref) => McpRepository(ref.watch(dioProvider)),
);
