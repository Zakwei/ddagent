import { createHash, randomBytes, randomUUID } from 'node:crypto';

import { appConfigDb, mcpTokensDb } from '@/modules/database/index.js';
import { providerMcpService } from '@/modules/providers/index.js';
import type { LLMProvider } from '@/shared/types.js';
import { AppError } from '@/shared/utils.js';

/**
 * Installs DDAgent's own MCP endpoint into provider CLIs.
 *
 * Consumers: the MCP token router (`POST /api/mcp/install`), driven from the
 * client's MCP screen and the onboarding flow. For each selected provider it
 * writes a `ddagent` HTTP MCP server entry (user scope) whose URL points at
 * `/mcp` and whose bearer token is a single reusable `ddagent-mcp` token — so
 * every configured agent can call the `knowledge_*` tools.
 *
 * One install token is kept: reinstalling revokes the previous one (its id is
 * remembered in `app_config`) before creating the next, so repeated installs do
 * not accumulate tokens. The plaintext token is only ever written into provider
 * configs, never returned to the client.
 */

const INSTALL_TOKEN_LABEL = 'ddagent-mcp';
const INSTALL_TOKEN_KEY = 'mcp_install_token_id';
const DEFAULT_SERVER_NAME = 'ddagent';

const hashToken = (plainToken: string): string =>
  createHash('sha256').update(plainToken).digest('hex');

export type DdagentMcpInstallResult = {
  url: string;
  serverName: string;
  scope: 'read' | 'write';
  results: Array<{ provider: LLMProvider; created: boolean; error?: string }>;
};

/**
 * Installs (or refreshes) the DDAgent MCP server on the chosen providers.
 *
 * `providers` omitted/empty = every registered provider. `url` defaults to the
 * local server; callers on a remote client should pass the reachable base URL.
 * Provider writes are best-effort: a provider that cannot store the entry is
 * reported in `results` instead of failing the whole install.
 */
export async function installDdagentMcpServer(input: {
  providers?: unknown;
  url?: unknown;
  scope?: unknown;
  serverName?: unknown;
}): Promise<DdagentMcpInstallResult> {
  const allProviders = providerMcpService.listProviderIds();
  const requested = Array.isArray(input.providers)
    ? input.providers.map((value) => String(value))
    : [];
  const providers = requested.length > 0 ? requested : allProviders;

  const unknownProviders = providers.filter((provider) => !allProviders.includes(provider as LLMProvider));
  if (unknownProviders.length > 0) {
    throw new AppError(`Unknown provider(s): ${unknownProviders.join(', ')}`, {
      code: 'UNKNOWN_PROVIDER',
      statusCode: 400,
    });
  }

  const scope: 'read' | 'write' = input.scope === 'read' ? 'read' : 'write';
  const serverName =
    typeof input.serverName === 'string' && input.serverName.trim()
      ? input.serverName.trim()
      : DEFAULT_SERVER_NAME;
  const url =
    typeof input.url === 'string' && input.url.trim()
      ? input.url.trim()
      : `http://127.0.0.1:${process.env.SERVER_PORT || '10087'}/mcp`;

  // Keep exactly one install token: drop the previous one first.
  const previousTokenId = appConfigDb.get(INSTALL_TOKEN_KEY);
  if (previousTokenId) {
    try {
      mcpTokensDb.revoke(previousTokenId);
    } catch {
      // Already gone — a stale id must not block a reinstall.
    }
  }

  const plainToken = `mcp_${randomBytes(32).toString('base64url')}`;
  const record = mcpTokensDb.create({
    id: randomUUID(),
    label: INSTALL_TOKEN_LABEL,
    tokenHash: hashToken(plainToken),
    scope,
  });
  appConfigDb.set(INSTALL_TOKEN_KEY, record.id);

  const results: DdagentMcpInstallResult['results'] = [];
  for (const provider of providers) {
    try {
      await providerMcpService.upsertProviderMcpServer(provider, {
        name: serverName,
        transport: 'http',
        scope: 'user',
        url,
        headers: { Authorization: `Bearer ${plainToken}` },
      });
      results.push({ provider: provider as LLMProvider, created: true });
    } catch (error) {
      results.push({
        provider: provider as LLMProvider,
        created: false,
        error: error instanceof Error ? error.message : 'Unknown error',
      });
    }
  }

  return { url, serverName, scope, results };
}
