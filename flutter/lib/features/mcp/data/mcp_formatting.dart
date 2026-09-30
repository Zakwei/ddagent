import 'dart:convert';

import 'package:ddagent_app/features/mcp/data/mcp_constants.dart';
import 'package:ddagent_app/features/mcp/data/mcp_models.dart';

/// MCP form/payload helpers — port of `src/components/mcp/utils/mcpFormatting.ts`.

/// Thrown when a form/JSON payload can't be built — the dialog renders
/// [message] inline (web throws `Error` into `submitError`).
class McpPayloadException implements Exception {
  const McpPayloadException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// `{A: 'x'}` → `"A=x\nB=y"` for the multiline env/headers fields.
String formatKeyValueLines(Map<String, String> value) =>
    value.entries.map((e) => '${e.key}=${e.value}').join('\n');

/// `"A=x\nB=y"` → `{A: 'x'}` — everything after the first `=` is the value.
Map<String, String> parseKeyValueLines(String value) {
  final result = <String, String>{};
  for (final line in value.split('\n')) {
    final sep = line.indexOf('=');
    final key = (sep < 0 ? line : line.substring(0, sep)).trim();
    if (key.isEmpty) continue;
    result[key] = (sep < 0 ? '' : line.substring(sep + 1)).trim();
  }
  return result;
}

/// `"a\nb\n"` → `['a', 'b']` — blank lines dropped.
List<String> parseListLines(String value) => [
  for (final line in value.split('\n'))
    if (line.trim().isNotEmpty) line.trim(),
];

/// `maskSecret` — secret display in the server list (`ab****yz`, `****`).
String maskSecret(Object? value) {
  final v = '${value ?? ''}';
  if (v.length <= 4) return '****';
  return '${v.substring(0, 2)}****${v.substring(v.length - 2)}';
}

/// Server list ordering — user → project → local, then project display name,
/// then server name (`sortServers` in useMcpServers.ts).
List<McpServer> sortMcpServers(List<McpServer> servers) {
  const scopeOrder = {McpScope.user: 0, McpScope.project: 1, McpScope.local: 2};
  return [...servers]..sort((a, b) {
    final scopeDelta = scopeOrder[a.scope]! - scopeOrder[b.scope]!;
    if (scopeDelta != 0) return scopeDelta;
    final projectDelta = (a.projectDisplayName ?? '').compareTo(
      b.projectDisplayName ?? '',
    );
    if (projectDelta != 0) return projectDelta;
    return a.name.compareTo(b.name);
  });
}

/// Module-cache key — `provider:path1|path2` over sorted project paths.
String mcpCacheKey(String provider, List<McpProjectTarget> targets) {
  final paths = [for (final t in targets) t.path]..sort();
  return '$provider:${paths.join('|')}';
}

String? _readString(Object? value) {
  if (value is! String) return null;
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

List<String>? _readStringList(Object? value) => value is List
    ? [
        for (final e in value)
          if (e is String) e,
      ]
    : null;

Map<String, String>? _readStringMap(Object? value) {
  if (value is! Map) return null;
  final result = <String, String>{
    for (final e in value.entries)
      if (e.value is String) '${e.key}': e.value as String,
  };
  return result.isEmpty ? null : result;
}

void _assertSupportedTransport(
  String provider,
  McpTransport transport,
  List<McpTransport>? supportedTransports,
  String Function(McpTransport transport)? unsupportedTransportMessage,
) {
  final supported = supportedTransports ?? mcpSupportedTransports(provider);
  if (supported.contains(transport)) return;
  throw McpPayloadException(
    unsupportedTransportMessage?.call(transport) ??
        '$provider does not support ${transport.wire} MCP servers',
  );
}

/// `createMcpPayloadFromForm` / `parseJsonMcpPayload` — builds the POST body
/// for `/api/providers/{provider}/mcp/servers` (and `/global`). Fields the
/// web leaves `undefined` are simply absent from the returned map.
Map<String, dynamic> buildMcpPayload({
  required String provider,
  required String name,
  required McpScope scope,
  required McpTransport transport,
  String workspacePath = '',
  String command = '',
  List<String> args = const [],
  Map<String, String> env = const {},
  String cwd = '',
  String url = '',
  Map<String, String> headers = const {},
  List<String> envVars = const [],
  String bearerTokenEnvVar = '',
  Map<String, String> envHttpHeaders = const {},
  McpImportMode importMode = McpImportMode.form,
  String jsonInput = '',
  List<McpTransport>? supportedTransports,
  bool? supportsWorkingDirectory,
  bool? includeProviderSpecificFields,
  String Function(McpTransport transport)? unsupportedTransportMessage,
}) {
  final supportsCwd =
      supportsWorkingDirectory ??
      kMcpSupportsWorkingDirectory[provider] ??
      false;
  final includeFields = includeProviderSpecificFields ?? provider == 'codex';

  Map<String, dynamic> base() => {
    'name': name.trim(),
    'scope': scope.wire,
    if (scope != McpScope.user && workspacePath.isNotEmpty)
      'workspacePath': workspacePath,
  };

  if (importMode == McpImportMode.json) {
    final parsed = jsonDecode(jsonInput);
    if (parsed is! Map) {
      throw const McpPayloadException('JSON configuration must be an object');
    }
    final transportInput =
        _readString(parsed['transport']) ?? _readString(parsed['type']);
    final parsedTransport = McpTransport.parse(transportInput);
    if (parsedTransport == null) {
      throw const McpPayloadException('Missing required field: type');
    }
    _assertSupportedTransport(
      provider,
      parsedTransport,
      supportedTransports,
      unsupportedTransportMessage,
    );
    if (parsedTransport == McpTransport.stdio &&
        _readString(parsed['command']) == null) {
      throw const McpPayloadException('stdio type requires a command field');
    }
    if ((parsedTransport == McpTransport.http ||
            parsedTransport == McpTransport.sse) &&
        _readString(parsed['url']) == null) {
      throw McpPayloadException(
        '${parsedTransport.wire} type requires a url field',
      );
    }
    // `undefined` fields in the web payload are dropped by JSON.stringify —
    // removeWhere mirrors that (`args`/`env`/`headers` default to {} / [] and
    // stay present).
    return <String, dynamic>{
      ...base(),
      'transport': parsedTransport.wire,
      'command': _readString(parsed['command']),
      'args': _readStringList(parsed['args']) ?? [],
      'env': _readStringMap(parsed['env']) ?? {},
      if (supportsCwd) 'cwd': _readString(parsed['cwd']),
      'url': _readString(parsed['url']),
      'headers':
          _readStringMap(parsed['headers'] ?? parsed['http_headers']) ?? {},
      if (includeFields) ...{
        'envVars':
            _readStringList(parsed['envVars'] ?? parsed['env_vars']) ?? [],
        'bearerTokenEnvVar': _readString(
          parsed['bearerTokenEnvVar'] ?? parsed['bearer_token_env_var'],
        ),
        'envHttpHeaders':
            _readStringMap(
              parsed['envHttpHeaders'] ?? parsed['env_http_headers'],
            ) ??
            {},
      },
    }..removeWhere((_, v) => v == null);
  }

  _assertSupportedTransport(
    provider,
    transport,
    supportedTransports,
    unsupportedTransportMessage,
  );
  return {
    ...base(),
    'transport': transport.wire,
    if (transport == McpTransport.stdio) ...{
      'command': command.trim(),
      'args': args,
    },
    'env': env,
    if (supportsCwd && cwd.trim().isNotEmpty) 'cwd': cwd.trim(),
    if (transport != McpTransport.stdio) ...{
      'url': url.trim(),
      'headers': headers,
    },
    if (includeFields) ...{
      'envVars': envVars,
      if (bearerTokenEnvVar.trim().isNotEmpty)
        'bearerTokenEnvVar': bearerTokenEnvVar.trim(),
      'envHttpHeaders': envHttpHeaders,
    },
  };
}
