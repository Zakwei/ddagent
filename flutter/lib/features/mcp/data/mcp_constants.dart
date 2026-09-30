import 'package:ddagent_app/features/mcp/data/mcp_models.dart';

/// MCP constants — port of `src/components/mcp/constants.ts`.

/// Provider display names (`MCP_PROVIDER_NAMES`).
const kMcpProviderNames = <String, String>{
  'claude': 'Claude',
  'cursor': 'Cursor',
  'codex': 'Codex',
  'opencode': 'OpenCode',
  'devin': 'Devin',
  'orchestrator': 'Auto',
};

/// Provider ids shown in the MCP provider selector — the Agents settings
/// `VISIBLE_AGENTS` set (orchestrator configures no MCP servers).
const kMcpProviders = ['claude', 'cursor', 'codex', 'opencode', 'devin'];

/// `MCP_SUPPORTED_SCOPES` — which scopes each provider's config supports.
const kMcpSupportedScopes = <String, List<McpScope>>{
  'claude': [McpScope.user, McpScope.project, McpScope.local],
  'cursor': [McpScope.user, McpScope.project],
  'codex': [McpScope.user, McpScope.project],
  'opencode': [McpScope.user, McpScope.project],
  'devin': [McpScope.user],
  'orchestrator': [McpScope.user],
};

/// `MCP_SUPPORTED_TRANSPORTS`.
const kMcpSupportedTransports = <String, List<McpTransport>>{
  'claude': [McpTransport.stdio, McpTransport.http, McpTransport.sse],
  'cursor': [McpTransport.stdio, McpTransport.http],
  'codex': [McpTransport.stdio, McpTransport.http],
  'opencode': [McpTransport.stdio, McpTransport.http],
  'devin': [McpTransport.stdio, McpTransport.http, McpTransport.sse],
  'orchestrator': [McpTransport.stdio],
};

/// `MCP_GLOBAL_SUPPORTED_SCOPES` — "add to every provider" form limits.
const kMcpGlobalScopes = [McpScope.user, McpScope.project];

/// `MCP_GLOBAL_SUPPORTED_TRANSPORTS`.
const kMcpGlobalTransports = [McpTransport.stdio, McpTransport.http];

/// `MCP_SUPPORTS_WORKING_DIRECTORY` — only Codex accepts a `cwd` field.
const kMcpSupportsWorkingDirectory = <String, bool>{
  'claude': false,
  'cursor': false,
  'codex': true,
  'opencode': false,
  'devin': false,
  'orchestrator': false,
};

List<McpScope> mcpSupportedScopes(String provider) =>
    kMcpSupportedScopes[provider] ?? const [McpScope.user];

List<McpTransport> mcpSupportedTransports(String provider) =>
    kMcpSupportedTransports[provider] ?? const [McpTransport.stdio];

String mcpProviderName(String provider) =>
    kMcpProviderNames[provider] ?? provider;
