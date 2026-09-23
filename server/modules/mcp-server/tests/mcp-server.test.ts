import assert from 'node:assert/strict';
import { createHash } from 'node:crypto';
import { once } from 'node:events';
import { mkdtemp, rm } from 'node:fs/promises';
import type { AddressInfo } from 'node:net';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import express, {
  type NextFunction,
  type Request,
  type Response,
} from 'express';

import {
  closeConnection,
  getConnection,
  initializeDatabase,
  kanbanCardsDb,
  mcpTokensDb,
  MCP_TOKENS_TABLE_SCHEMA_SQL,
  queuedMessagesDb,
  sessionsDb,
} from '@/modules/database/index.js';
import { chatRunRegistry, connectedClients } from '@/modules/websocket/index.js';
import { AppError } from '@/shared/utils.js';

import { mcpRouter, mcpTokensRouter } from '../index.js';

const sha256 = (value: string) => createHash('sha256').update(value).digest('hex');

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'mcp-server-'));
  const databasePath = path.join(tempDirectory, 'auth.db');

  closeConnection();
  process.env.DATABASE_PATH = databasePath;
  await initializeDatabase();
  // The coordinator wires MCP_TOKENS_TABLE_SCHEMA_SQL into schema/migrations;
  // until then the test creates the table itself on the isolated database.
  getConnection().exec(MCP_TOKENS_TABLE_SCHEMA_SQL);
  // A parallel change adds kanban_cards.assignee_user_id and the repository
  // already SELECTs it, but its migration may not be wired yet — create the
  // column when missing so create_task works on a fresh schema.
  const kanbanColumns = (
    getConnection().prepare('PRAGMA table_info(kanban_cards)').all() as { name: string }[]
  ).map((column) => column.name);
  if (!kanbanColumns.includes('assignee_user_id')) {
    getConnection().exec('ALTER TABLE kanban_cards ADD COLUMN assignee_user_id INTEGER');
  }

  try {
    await runTest();
  } finally {
    connectedClients.clear();
    chatRunRegistry.clearAll();
    closeConnection();
    if (previousDatabasePath === undefined) {
      delete process.env.DATABASE_PATH;
    } else {
      process.env.DATABASE_PATH = previousDatabasePath;
    }
    await rm(tempDirectory, { recursive: true, force: true });
  }
}

function buildApp(): express.Express {
  const app = express();
  app.use(express.json());
  app.use('/mcp', mcpRouter);
  app.use('/api/mcp', mcpTokensRouter);
  app.use((error: unknown, _req: Request, res: Response, _next: NextFunction) => {
    if (error instanceof AppError) {
      res.status(error.statusCode).json({
        success: false,
        error: { code: error.code, message: error.message },
      });
      return;
    }
    res.status(500).json({ success: false, error: { code: 'INTERNAL_ERROR' } });
  });
  return app;
}

async function withServer(
  app: express.Express,
  run: (baseUrl: string) => Promise<void>,
): Promise<void> {
  const server = app.listen(0, '127.0.0.1');
  await once(server, 'listening');
  try {
    const { port } = server.address() as AddressInfo;
    await run(`http://127.0.0.1:${port}`);
  } finally {
    server.close();
  }
}

type JsonRpcBody = {
  id?: number | string | null;
  result?: {
    tools?: Array<{ name: string }>;
    protocolVersion?: string;
    capabilities?: { tools?: unknown };
    serverInfo?: { name?: string; version?: string };
    content?: Array<{ type: string; text: string }>;
    isError?: boolean;
  };
  error?: { code: number; message: string };
};

async function rpc(
  baseUrl: string,
  token: string | null,
  method: string,
  params?: unknown,
  id: number | string = 1,
): Promise<{ status: number; body: JsonRpcBody }> {
  const headers: Record<string, string> = { 'Content-Type': 'application/json' };
  if (token) headers.Authorization = `Bearer ${token}`;
  const response = await fetch(`${baseUrl}/mcp`, {
    method: 'POST',
    headers,
    body: JSON.stringify({ jsonrpc: '2.0', id, method, params }),
  });
  const body = (await response.json()) as JsonRpcBody;
  return { status: response.status, body };
}

/** Reads the tool-level JSON text payload out of a successful tools/call result. */
function toolPayload<T>(body: JsonRpcBody): T {
  const text = body.result?.content?.[0]?.text;
  assert.ok(typeof text === 'string', 'tools/call must return a text content block');
  return JSON.parse(text) as T;
}

test('initialize handshake returns protocol version and server info', async () => {
  await withIsolatedDatabase(async () => {
    mcpTokensDb.create({ id: 'tok-w', label: 'writer', tokenHash: sha256('write-secret'), scope: 'write' });
    await withServer(buildApp(), async (baseUrl) => {
      const { status, body } = await rpc(baseUrl, 'write-secret', 'initialize', {
        protocolVersion: '2024-11-05',
        capabilities: {},
        clientInfo: { name: 'test-client', version: '0' },
      });
      assert.equal(status, 200);
      assert.equal(body.id, 1);
      assert.equal(body.result?.protocolVersion, '2024-11-05');
      assert.equal(body.result?.serverInfo?.name, 'ddagent');
      assert.ok(body.result?.serverInfo?.version);
      assert.ok(body.result?.capabilities?.tools !== undefined);
    });
  });
});

test('tools/list exposes the ddagent tool catalog', async () => {
  await withIsolatedDatabase(async () => {
    mcpTokensDb.create({ id: 'tok-w', label: 'writer', tokenHash: sha256('write-secret'), scope: 'write' });
    await withServer(buildApp(), async (baseUrl) => {
      const { status, body } = await rpc(baseUrl, 'write-secret', 'tools/list');
      assert.equal(status, 200);
      const names = (body.result?.tools ?? []).map((tool) => tool.name).sort();
      assert.deepEqual(names, [
        'create_task',
        'create_worktree',
        'get_status',
        'list_sessions',
        'send_message',
      ]);
    });
  });
});

test('bearer auth: missing or unknown tokens are rejected with 401', async () => {
  await withIsolatedDatabase(async () => {
    await withServer(buildApp(), async (baseUrl) => {
      const noAuth = await rpc(baseUrl, null, 'ping');
      assert.equal(noAuth.status, 401);

      const badToken = await rpc(baseUrl, 'mcp_not_a_real_token', 'ping');
      assert.equal(badToken.status, 401);

      const response = await fetch(`${baseUrl}/mcp`, {
        method: 'GET',
        headers: { Authorization: 'Bearer mcp_not_a_real_token' },
      });
      assert.equal(response.status, 401);
    });
  });
});

test('scope enforcement: read token lists sessions but cannot create_task', async () => {
  await withIsolatedDatabase(async () => {
    mcpTokensDb.create({ id: 'tok-r', label: 'reader', tokenHash: sha256('read-secret'), scope: 'read' });
    mcpTokensDb.create({ id: 'tok-w', label: 'writer', tokenHash: sha256('write-secret'), scope: 'write' });
    sessionsDb.createAppSession('sess-1', 'claude', '/tmp/mcp-proj', 'demo');

    await withServer(buildApp(), async (baseUrl) => {
      // read scope: list_sessions works.
      const listed = await rpc(baseUrl, 'read-secret', 'tools/call', {
        name: 'list_sessions',
        arguments: { limit: 5 },
      });
      assert.equal(listed.status, 200);
      assert.equal(listed.body.result?.isError, undefined);
      const listPayload = toolPayload<{ sessions: Array<{ sessionId: string }>; total: number }>(listed.body);
      assert.ok(listPayload.sessions.some((s) => s.sessionId === 'sess-1'));

      // read scope: get_status works too.
      const status = await rpc(baseUrl, 'read-secret', 'tools/call', { name: 'get_status' });
      const statusPayload = toolPayload<{ runningSessions: number; projects: number }>(status.body);
      assert.equal(statusPayload.runningSessions, 0);
      assert.equal(statusPayload.projects, 1);

      // read scope: write tool is refused as a tool-level error.
      const denied = await rpc(baseUrl, 'read-secret', 'tools/call', {
        name: 'create_task',
        arguments: { projectId: 'p1', prompt: 'nope' },
      });
      assert.equal(denied.status, 200);
      assert.equal(denied.body.result?.isError, true);
      assert.match(denied.body.result?.content?.[0]?.text ?? '', /write/);

      // write scope: create_task lands a card in 'ready'.
      const created = await rpc(baseUrl, 'write-secret', 'tools/call', {
        name: 'create_task',
        arguments: { projectId: 'proj-mcp', prompt: 'line one\nline two details' },
      });
      assert.equal(created.status, 200);
      assert.equal(created.body.result?.isError, undefined);
      const card = toolPayload<{ cardId: string; status: string; description: string }>(created.body);
      assert.equal(card.status, 'ready');
      assert.equal(card.description, 'line one\nline two details');
      assert.equal(kanbanCardsDb.getById(card.cardId)?.status, 'ready');
    });
  });
});

test('token admin: plaintext returned once, only sha256 hash stored, revoke kills access', async () => {
  await withIsolatedDatabase(async () => {
    await withServer(buildApp(), async (baseUrl) => {
      const created = await fetch(`${baseUrl}/api/mcp/tokens`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ label: 'claude-desktop', scope: 'read' }),
      });
      assert.equal(created.status, 201);
      const createdBody = (await created.json()) as {
        data: { token: string; record: { id: string; scope: string } };
      };
      const { token, record } = createdBody.data;
      assert.ok(token.startsWith('mcp_'));
      assert.equal(record.scope, 'read');
      assert.equal('token_hash' in record, false, 'public record must not expose the hash');

      // The stored row holds the sha256 digest, never the plaintext.
      const row = getConnection()
        .prepare('SELECT token_hash FROM mcp_client_tokens WHERE id = ?')
        .get(record.id) as { token_hash: string };
      assert.notEqual(row.token_hash, token);
      assert.equal(row.token_hash, sha256(token));

      // The issued token authenticates immediately.
      const ping = await rpc(baseUrl, token, 'ping');
      assert.equal(ping.status, 200);
      assert.deepEqual(ping.body.result, {});

      // Invalid admin input is rejected.
      const badScope = await fetch(`${baseUrl}/api/mcp/tokens`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ label: 'x', scope: 'admin' }),
      });
      assert.equal(badScope.status, 400);

      // Revoke → the same token stops working.
      const revoked = await fetch(`${baseUrl}/api/mcp/tokens/${record.id}`, { method: 'DELETE' });
      assert.equal(revoked.status, 200);
      const afterRevoke = await rpc(baseUrl, token, 'ping');
      assert.equal(afterRevoke.status, 401);
    });
  });
});

test('send_message enqueues into the persisted outbound queue', async () => {
  await withIsolatedDatabase(async () => {
    mcpTokensDb.create({ id: 'tok-w', label: 'writer', tokenHash: sha256('write-secret'), scope: 'write' });

    await withServer(buildApp(), async (baseUrl) => {
      const sent = await rpc(baseUrl, 'write-secret', 'tools/call', {
        name: 'send_message',
        arguments: { sessionId: 'mcp-target-session', message: 'hello from mcp' },
      });
      assert.equal(sent.status, 200);
      assert.equal(sent.body.result?.isError, undefined);

      const message = toolPayload<{ id: number; sessionId: string; content: string }>(sent.body);
      assert.equal(message.sessionId, 'mcp-target-session');
      assert.equal(message.content, 'hello from mcp');

      // The session id is unknown so the async drain marks it failed — the
      // assertion is that the row was durably enqueued with the payload.
      const stored = queuedMessagesDb.getById(message.id);
      assert.ok(stored);
      assert.equal(stored.sessionId, 'mcp-target-session');
      assert.equal(stored.content, 'hello from mcp');
    });
  });
});

test('notifications get 202 and unknown methods return -32601', async () => {
  await withIsolatedDatabase(async () => {
    mcpTokensDb.create({ id: 'tok-w', label: 'writer', tokenHash: sha256('write-secret'), scope: 'write' });

    await withServer(buildApp(), async (baseUrl) => {
      const notification = await fetch(`${baseUrl}/mcp`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: 'Bearer write-secret',
        },
        body: JSON.stringify({ jsonrpc: '2.0', method: 'notifications/initialized' }),
      });
      assert.equal(notification.status, 202);

      const unknown = await rpc(baseUrl, 'write-secret', 'bogus/method');
      assert.equal(unknown.status, 200);
      assert.equal(unknown.body.error?.code, -32601);

      const unknownTool = await rpc(baseUrl, 'write-secret', 'tools/call', {
        name: 'does_not_exist',
        arguments: {},
      });
      assert.equal(unknownTool.body.error?.code, -32602);
    });
  });
});

test('GET /mcp returns server info for authenticated probes', async () => {
  await withIsolatedDatabase(async () => {
    mcpTokensDb.create({ id: 'tok-r', label: 'reader', tokenHash: sha256('read-secret'), scope: 'read' });
    await withServer(buildApp(), async (baseUrl) => {
      const response = await fetch(`${baseUrl}/mcp`, {
        headers: { Authorization: 'Bearer read-secret' },
      });
      assert.equal(response.status, 200);
      const info = (await response.json()) as { name: string; protocolVersion: string };
      assert.equal(info.name, 'ddagent');
      assert.equal(info.protocolVersion, '2024-11-05');
    });
  });
});
