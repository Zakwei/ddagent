import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { closeConnection, initializeDatabase, mcpTokensDb } from '@/modules/database/index.js';
import { providerMcpService } from '@/modules/providers/index.js';
import { AppError } from '@/shared/utils.js';

import { installDdagentMcpServer } from '../mcp-install.service.js';

const patchHomeDir = (nextHomeDir: string) => {
  const original = os.homedir;
  (os as unknown as { homedir: () => string }).homedir = () => nextHomeDir;
  return () => {
    (os as unknown as { homedir: () => string }).homedir = original;
  };
};

async function withIsolatedEnv(runTest: (home: string) => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempRoot = await fs.mkdtemp(path.join(os.tmpdir(), 'mcp-install-'));
  closeConnection();
  process.env.DATABASE_PATH = path.join(tempRoot, 'auth.db');
  await initializeDatabase();

  const restoreHome = patchHomeDir(tempRoot);
  try {
    await runTest(tempRoot);
  } finally {
    restoreHome();
    closeConnection();
    if (previousDatabasePath === undefined) {
      delete process.env.DATABASE_PATH;
    } else {
      process.env.DATABASE_PATH = previousDatabasePath;
    }
    await fs.rm(tempRoot, { recursive: true, force: true });
  }
}

const activeTokens = () => mcpTokensDb.list().filter((token) => !token.revoked);

test('installs a ddagent HTTP MCP server with a bearer token on selected providers', async () => {
  await withIsolatedEnv(async (home) => {
    const result = await installDdagentMcpServer({
      providers: ['claude'],
      url: 'http://127.0.0.1:9999/mcp',
      scope: 'write',
    });

    assert.equal(result.url, 'http://127.0.0.1:9999/mcp');
    assert.equal(result.serverName, 'ddagent');
    assert.equal(result.scope, 'write');
    assert.deepEqual(result.results, [{ provider: 'claude', created: true }]);

    const config = JSON.parse(await fs.readFile(path.join(home, '.claude.json'), 'utf8')) as {
      mcpServers?: Record<string, { url?: string; headers?: Record<string, string> }>;
    };
    const entry = config.mcpServers?.ddagent;
    assert.equal(entry?.url, 'http://127.0.0.1:9999/mcp');
    assert.match(entry?.headers?.Authorization ?? '', /^Bearer mcp_/);

    const tokens = activeTokens();
    assert.equal(tokens.length, 1);
    assert.equal(tokens[0]?.label, 'ddagent-mcp');
    assert.equal(tokens[0]?.scope, 'write');
  });
});

test('reinstalling reuses a single token and refreshes the config', async () => {
  await withIsolatedEnv(async (home) => {
    await installDdagentMcpServer({ providers: ['claude'], url: 'http://127.0.0.1:9999/mcp' });
    const first = activeTokens();
    assert.equal(first.length, 1);

    await installDdagentMcpServer({ providers: ['claude'], url: 'http://127.0.0.1:9999/mcp' });
    const second = activeTokens();
    // The previous install token is revoked; exactly one stays active.
    assert.equal(second.length, 1);
    assert.notEqual(first[0]?.id, second[0]?.id);
    assert.equal(mcpTokensDb.list().length, 2);

    const config = JSON.parse(await fs.readFile(path.join(home, '.claude.json'), 'utf8')) as {
      mcpServers?: Record<string, { headers?: Record<string, string> }>;
    };
    assert.match(config.mcpServers?.ddagent?.headers?.Authorization ?? '', /^Bearer mcp_/);
  });
});

test('rejects an unknown provider', async () => {
  await withIsolatedEnv(async () => {
    await assert.rejects(
      () => installDdagentMcpServer({ providers: ['not-a-provider'] }),
      (error: unknown) => error instanceof AppError && error.code === 'UNKNOWN_PROVIDER',
    );
  });
});

test('defaults to every registered provider', async () => {
  await withIsolatedEnv(async () => {
    const registered = providerMcpService.listProviderIds();
    assert.ok(registered.length > 0);
    const result = await installDdagentMcpServer({});
    assert.equal(result.results.length, registered.length);
  });
});
