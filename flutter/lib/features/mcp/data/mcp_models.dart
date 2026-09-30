/// MCP models — port of `src/components/mcp/types.ts`. Provider is kept as a
/// plain `String` (the API's LLMProvider ids are open-ended; `orchestrator`
/// exists in the constants maps even though no UI tab selects it).
library;

/// MCP config scope — `user` writes the provider's user config, `project` and
/// `local` (Claude-only) write per-workspace files.
enum McpScope {
  user('user'),
  local('local'),
  project('project');

  const McpScope(this.wire);

  /// Wire name — identical to the enum name today, kept for one decode point.
  final String wire;

  static McpScope? parse(Object? value) => switch (value) {
    'user' => McpScope.user,
    'local' => McpScope.local,
    'project' => McpScope.project,
    _ => null,
  };
}

/// MCP transport — `stdio` runs a command, `http`/`sse` connect to a URL.
enum McpTransport {
  stdio('stdio'),
  http('http'),
  sse('sse');

  const McpTransport(this.wire);

  final String wire;

  static McpTransport? parse(Object? value) => switch (value) {
    'stdio' => McpTransport.stdio,
    'http' => McpTransport.http,
    'sse' => McpTransport.sse,
    _ => null,
  };

  /// Display label — `stdio → STDIO`, `sse → SSE` (form dropdown parity).
  String get label => wire.toUpperCase();
}

/// Add-server input mode — manual fields vs pasted JSON (`importMode` in the
/// web form state).
enum McpImportMode { form, json }

/// One project as an MCP scope target — `{name: projectId, displayName,
/// path}` where `path` is `fullPath || path` (web `ProjectTarget`).
class McpProjectTarget {
  const McpProjectTarget({
    required this.name,
    required this.displayName,
    required this.path,
  });

  /// Stable identifier — the DB `projectId`.
  final String name;
  final String displayName;

  /// Workspace path sent as `workspacePath` in scoped API calls.
  final String path;
}

/// One configured MCP server — port of `ProviderMcpServer` plus the
/// `normalizeServer` defaults the web hook applies to API rows.
class McpServer {
  const McpServer({
    required this.provider,
    required this.name,
    required this.scope,
    required this.transport,
    this.command,
    this.args = const [],
    this.env = const {},
    this.cwd,
    this.url,
    this.headers = const {},
    this.envVars = const [],
    this.bearerTokenEnvVar,
    this.envHttpHeaders = const {},
    this.workspacePath,
    this.projectName,
    this.projectDisplayName,
  });

  final String provider;
  final String name;
  final McpScope scope;
  final McpTransport transport;
  final String? command;
  final List<String> args;
  final Map<String, String> env;
  final String? cwd;
  final String? url;
  final Map<String, String> headers;

  /// Codex-only: env var *names* the stdio server may read.
  final List<String> envVars;

  /// Codex-only: env var holding the bearer token for http servers.
  final String? bearerTokenEnvVar;
  final Map<String, String> envHttpHeaders;
  final String? workspacePath;
  final String? projectName;
  final String? projectDisplayName;

  /// Servers prefixed `ddagent-` are written/removed by ddagent feature
  /// toggles (e.g. the Browser tab) — shown read-only so users don't edit
  /// them out of sync with the feature.
  bool get isManaged => name.startsWith('ddagent-');

  /// Dedupe/merge key — `provider:scope:workspacePath|global:name`.
  String get identity =>
      '$provider:${scope.wire}:'
      '${(workspacePath?.isNotEmpty ?? false) ? workspacePath : 'global'}:$name';

  /// `normalizeServer` — fills defaults, resolves the effective transport
  /// (servers carrying a `url` but no transport are http) and stamps the
  /// project target's path/name/displayName onto the row.
  factory McpServer.fromApi(
    String provider,
    McpScope scope,
    Map<String, dynamic> json, {
    McpProjectTarget? project,
  }) {
    final url = json['url'] as String?;
    return McpServer(
      provider: provider,
      name: '${json['name'] ?? ''}',
      scope: McpScope.parse(json['scope']) ?? scope,
      transport:
          McpTransport.parse(json['transport']) ??
          (url != null ? McpTransport.http : McpTransport.stdio),
      command: json['command'] as String?,
      args: _stringList(json['args']),
      env: _stringMap(json['env']),
      cwd: json['cwd'] as String?,
      url: url,
      headers: _stringMap(json['headers']),
      envVars: _stringList(json['envVars']),
      bearerTokenEnvVar: json['bearerTokenEnvVar'] as String?,
      envHttpHeaders: _stringMap(json['envHttpHeaders']),
      workspacePath: (project?.path.isNotEmpty ?? false)
          ? project!.path
          : json['workspacePath'] as String?,
      projectName: (project?.name.isNotEmpty ?? false)
          ? project!.name
          : json['projectName'] as String?,
      projectDisplayName: (project?.displayName.isNotEmpty ?? false)
          ? project!.displayName
          : json['projectDisplayName'] as String?,
    );
  }

  static List<String> _stringList(Object? value) => value is List
      ? [
          for (final e in value)
            if (e is String) e,
        ]
      : const [];

  static Map<String, String> _stringMap(Object? value) => value is Map
      ? {
          for (final e in value.entries)
            if (e.value is String) '${e.key}': e.value as String,
        }
      : const {};
}

/// Bearer token for ddagent's own MCP endpoint (`POST /mcp`) —
/// `McpServerTokens.tsx` row shape.
class McpToken {
  const McpToken({
    required this.id,
    required this.label,
    required this.scope,
    this.createdAt,
    this.lastUsedAt,
  });

  final String id;
  final String label;

  /// `read` or `write`.
  final String scope;
  final String? createdAt;
  final String? lastUsedAt;

  factory McpToken.fromJson(Map<String, dynamic> json) => McpToken(
    id: '${json['id'] ?? ''}',
    label: '${json['label'] ?? ''}',
    scope: '${json['scope'] ?? 'read'}',
    createdAt: json['createdAt'] as String?,
    lastUsedAt: json['lastUsedAt'] as String?,
  );
}

/// One per-provider outcome from `POST /api/providers/mcp/servers/global`.
class GlobalMcpResult {
  const GlobalMcpResult({
    required this.provider,
    required this.created,
    this.error,
  });

  final String provider;
  final bool created;
  final String? error;

  factory GlobalMcpResult.fromJson(Map<String, dynamic> json) =>
      GlobalMcpResult(
        provider: '${json['provider'] ?? ''}',
        created: json['created'] == true,
        error: json['error'] as String?,
      );
}
