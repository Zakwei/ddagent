import path from 'node:path';

import { McpProvider } from '@/modules/providers/shared/mcp/mcp.provider.js';
import type { McpScope, ProviderMcpServer, UpsertProviderMcpServerInput } from '@/shared/types.js';
import {
  AppError,
  antigravityConfigDir,
  readJsonConfig,
  readObjectRecord,
  readOptionalString,
  readStringArray,
  readStringRecord,
  writeJsonConfig,
} from '@/shared/utils.js';

const ANTIGRAVITY_MCP_PATH = () => path.join(antigravityConfigDir(), 'mcp_config.json');

/**
 * Antigravity stores MCP servers as `{mcpServers: {name: config}}` JSON at
 * `~/.gemini/config/mcp_config.json` — a single user-global scope (the CLI's
 * `agy mcp add` has no scope flag and always writes that file). `stdio`
 * servers carry `command` + `args` + `env`; `http` servers carry `serverUrl`
 * + `headers` (SSE is not offered by this CLI). `agy mcp enable|disable`
 * flips a `disabled` flag on the entry; `ProviderMcpServer` has no enabled
 * field, so disabled entries normalize identically and the CLI-side flag is
 * preserved untouched on write.
 */
export class AntigravityMcpProvider extends McpProvider {
  constructor() {
    super('antigravity', ['user'], ['stdio', 'http']);
  }

  protected async readScopedServers(_scope: McpScope, _workspacePath: string): Promise<Record<string, unknown>> {
    const config = await readJsonConfig(ANTIGRAVITY_MCP_PATH());
    return readObjectRecord(config.mcpServers) ?? {};
  }

  protected async writeScopedServers(
    _scope: McpScope,
    _workspacePath: string,
    servers: Record<string, unknown>,
  ): Promise<void> {
    const filePath = ANTIGRAVITY_MCP_PATH();
    const config: Record<string, unknown> = await readJsonConfig(filePath).catch(() => ({}));
    config.mcpServers = servers;
    await writeJsonConfig(filePath, config);
  }

  protected buildServerConfig(input: UpsertProviderMcpServerInput): Record<string, unknown> {
    if (input.transport === 'stdio') {
      if (!input.command?.trim()) {
        throw new AppError('command is required for stdio MCP servers.', {
          code: 'MCP_COMMAND_REQUIRED',
          statusCode: 400,
        });
      }

      return {
        command: input.command,
        args: input.args ?? [],
        disabled: false,
        ...(input.env ? { env: input.env } : {}),
      };
    }

    if (!input.url?.trim()) {
      throw new AppError('url is required for http MCP servers.', {
        code: 'MCP_URL_REQUIRED',
        statusCode: 400,
      });
    }

    return {
      serverUrl: input.url,
      disabled: false,
      ...(input.headers ? { headers: input.headers } : {}),
    };
  }

  protected normalizeServerConfig(
    scope: McpScope,
    name: string,
    rawConfig: unknown,
  ): ProviderMcpServer | null {
    const config = readObjectRecord(rawConfig);
    if (!config) {
      return null;
    }

    const command = readOptionalString(config.command);
    // Antigravity's own key is `serverUrl`; accept `url`/`httpUrl` for files
    // imported from other MCP configs.
    const url = readOptionalString(config.serverUrl)
      ?? readOptionalString(config.url)
      ?? readOptionalString(config.httpUrl);
    const transport = readOptionalString(config.transport) ?? readOptionalString(config.type);

    if (transport === 'http' || (!command && url)) {
      if (!url) {
        return null;
      }
      return {
        provider: 'antigravity',
        name,
        scope,
        transport: 'http',
        url,
        headers: readStringRecord(config.headers),
      };
    }

    if (transport === 'stdio' || command) {
      if (!command) {
        return null;
      }
      return {
        provider: 'antigravity',
        name,
        scope,
        transport: 'stdio',
        command,
        args: readStringArray(config.args),
        env: readStringRecord(config.env),
      };
    }

    return null;
  }
}
