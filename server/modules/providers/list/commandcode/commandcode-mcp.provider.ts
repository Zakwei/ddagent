import path from 'node:path';

import { McpProvider } from '@/modules/providers/shared/mcp/mcp.provider.js';
import type { McpScope, ProviderMcpServer, UpsertProviderMcpServerInput } from '@/shared/types.js';
import {
  AppError,
  commandCodeDir,
  commandCodeProjectSlug,
  readJsonConfig,
  readObjectRecord,
  readOptionalString,
  readStringArray,
  readStringRecord,
  writeJsonConfig,
} from '@/shared/utils.js';

const COMMAND_CODE_USER_MCP_PATH = () => path.join(commandCodeDir(), 'mcp.json');

/**
 * Command Code stores MCP servers as `{mcpServers: {name: config}}` JSON:
 * user scope at `~/.commandcode/mcp.json`, project scope at
 * `<workspace>/.mcp.json` (checked in, shared), local scope at
 * `~/.commandcode/projects/<slug>/mcp.json` (this machine only, per the CLI's
 * documented precedence user < project < local). Each server carries
 * `transport` (`stdio`/`http`; SSE is not supported by this CLI), `command` +
 * `args` + `env` for stdio, `url` + `headers` for http, plus `enabled`.
 */
export class CommandCodeMcpProvider extends McpProvider {
  constructor() {
    super('commandcode', ['user', 'project', 'local'], ['stdio', 'http']);
  }

  private configPathFor(scope: McpScope, workspacePath: string): string {
    if (scope === 'user') {
      return COMMAND_CODE_USER_MCP_PATH();
    }
    if (scope === 'local') {
      return path.join(
        commandCodeDir(),
        'projects',
        commandCodeProjectSlug(workspacePath),
        'mcp.json',
      );
    }
    return path.join(workspacePath, '.mcp.json');
  }

  protected async readScopedServers(scope: McpScope, workspacePath: string): Promise<Record<string, unknown>> {
    const config = await readJsonConfig(this.configPathFor(scope, workspacePath));
    return readObjectRecord(config.mcpServers) ?? {};
  }

  protected async writeScopedServers(
    scope: McpScope,
    workspacePath: string,
    servers: Record<string, unknown>,
  ): Promise<void> {
    const filePath = this.configPathFor(scope, workspacePath);
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
        transport: 'stdio',
        enabled: true,
        command: input.command,
        args: input.args ?? [],
        ...(input.env ? { env: input.env } : {}),
        ...(input.cwd ? { cwd: input.cwd } : {}),
      };
    }

    if (!input.url?.trim()) {
      throw new AppError('url is required for http MCP servers.', {
        code: 'MCP_URL_REQUIRED',
        statusCode: 400,
      });
    }

    return {
      transport: 'http',
      enabled: true,
      url: input.url,
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

    const transport = readOptionalString(config.transport) ?? readOptionalString(config.type);
    const command = readOptionalString(config.command);
    const url = readOptionalString(config.url);

    if (transport === 'http' || (!transport && url)) {
      if (!url) {
        return null;
      }
      return {
        provider: 'commandcode',
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
        provider: 'commandcode',
        name,
        scope,
        transport: 'stdio',
        command,
        args: readStringArray(config.args),
        env: readStringRecord(config.env),
        cwd: readOptionalString(config.cwd),
      };
    }

    return null;
  }
}
