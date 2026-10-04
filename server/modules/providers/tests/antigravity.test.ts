import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { AntigravityProviderAuth } from '@/modules/providers/list/antigravity/antigravity-auth.provider.js';
import { AntigravityMcpProvider } from '@/modules/providers/list/antigravity/antigravity-mcp.provider.js';
import { parseAntigravityModelList } from '@/modules/providers/list/antigravity/antigravity-models.provider.js';
import { readAntigravityTranscript } from '@/modules/providers/list/antigravity/antigravity-sessions.provider.js';
import { resolveAntigravityExecutable } from '@/shared/utils.js';

const patchHomeDir = (nextHomeDir: string) => {
  const original = os.homedir;
  (os as any).homedir = () => nextHomeDir;
  return () => {
    (os as any).homedir = original;
  };
};

const readJson = async (filePath: string): Promise<Record<string, unknown>> => {
  const content = await fs.readFile(filePath, 'utf8');
  return JSON.parse(content) as Record<string, unknown>;
};

test('resolveAntigravityExecutable picks the first working documented alias', () => {
  const seen: string[] = [];
  const spawnSync = (command: string) => {
    seen.push(command);
    return command === 'antigravity-cli' ? { status: 0 } : { status: 1 };
  };
  assert.equal(resolveAntigravityExecutable(spawnSync), 'antigravity-cli');
  assert.equal(seen.length, 2); // agy failed, antigravity-cli answered

  const none = resolveAntigravityExecutable(() => ({ status: 1 }));
  assert.equal(none, null);
});

test('AntigravityProviderAuth surfaces the Google email stored in the id_token', { concurrency: false }, async () => {
  const tempRoot = await fs.mkdtemp(path.join(os.tmpdir(), 'agy-auth-'));
  const restoreHomeDir = patchHomeDir(tempRoot);
  const previousKey = process.env.GEMINI_API_KEY;
  delete process.env.GEMINI_API_KEY;
  try {
    const dir = path.join(tempRoot, '.gemini', 'antigravity-cli');
    await fs.mkdir(dir, { recursive: true });
    const idToken = `h.${Buffer.from(JSON.stringify({ email: 'ambient@example.com' })).toString('base64url')}.s`;
    const tokenPath = path.join(dir, 'antigravity-oauth-token');
    await fs.writeFile(
      tokenPath,
      JSON.stringify({ token: { access_token: 'x' }, id_token: idToken }),
    );

    const auth = new AntigravityProviderAuth();
    const status = await auth.getStatus();
    assert.equal(status.authenticated, true);
    assert.equal(status.email, 'ambient@example.com');

    // A credential file without a decodable id_token keeps the generic label
    // rather than failing the status check.
    await fs.writeFile(tokenPath, JSON.stringify({ token: { access_token: 'x' } }));
    assert.equal((await auth.getStatus()).email, 'Google account');
  } finally {
    restoreHomeDir();
    if (previousKey === undefined) delete process.env.GEMINI_API_KEY;
    else process.env.GEMINI_API_KEY = previousKey;
    await fs.rm(tempRoot, { recursive: true, force: true });
  }
});

test('parseAntigravityModelList parses the tab-separated `agy models` output', () => {
  const stdout = [
    'Fetching available models...',
    'gemini-3.8-flash-high\tGemini 3.8 Flash (High)',
    'gemini-3.8-flash-medium\tGemini 3.8 Flash (Medium)',
    'gemini-3.8-flash-low\tGemini 3.8 Flash (Low)',
    'gemini-3.1-pro-high\tGemini 3.1 Pro (High)',
    'claude-sonnet-4-6\tClaude Sonnet 4.6 (Thinking)',
    'gpt-oss-120b-medium\tGPT-OSS 120B (Medium)',
    '',
  ].join('\n');

  const catalog = parseAntigravityModelList(stdout);
  assert.ok(catalog);
  assert.equal(catalog.DEFAULT, 'gemini-3.8-flash-high');
  assert.deepEqual(
    catalog.OPTIONS.map((option) => option.value),
    [
      'gemini-3.8-flash-high',
      'gemini-3.8-flash-medium',
      'gemini-3.8-flash-low',
      'gemini-3.1-pro-high',
      'claude-sonnet-4-6',
      'gpt-oss-120b-medium',
    ],
  );
  assert.equal(catalog.OPTIONS[0].description, 'Gemini 3.8 Flash (High)');
  // Every model carries the CLI's low|medium|high|max effort selector.
  assert.deepEqual(
    catalog.OPTIONS[0].effort?.values.map((v) => v.value),
    ['default', 'low', 'medium', 'high', 'max'],
  );
});

test('parseAntigravityModelList returns null on empty output', () => {
  assert.equal(parseAntigravityModelList(''), null);
  assert.equal(parseAntigravityModelList('Fetching available models...\n'), null);
});

test('readAntigravityTranscript parses mirror rows and skips torn lines', async () => {
  const tempRoot = await fs.mkdtemp(path.join(os.tmpdir(), 'agy-transcript-'));
  try {
    const filePath = path.join(tempRoot, 'conv-9.jsonl');
    await fs.writeFile(filePath, [
      JSON.stringify({ type: 'session', id: 'conv-9', cwd: '/tmp/ws' }),
      JSON.stringify({ type: 'message', id: 'm1', message: { role: 'user', content: [{ type: 'text', text: 'hi' }] } }),
      '{"type":"message","id":"m2","broken":',
      JSON.stringify({ type: 'message', id: 'm3', model: 'gemini-3.8-flash-high', usage: { inputTokens: 5, outputTokens: 2, totalTokens: 7 }, message: { role: 'assistant', content: [{ type: 'text', text: 'hello' }] } }),
    ].join('\n'));

    const entries = await readAntigravityTranscript(filePath);
    assert.equal(entries.length, 3);
    assert.equal(entries[0].type, 'session');
    assert.equal(entries[1].id, 'm1');
    assert.equal(entries[2].model, 'gemini-3.8-flash-high');
  } finally {
    await fs.rm(tempRoot, { recursive: true, force: true });
  }
});

test('antigravity MCP provider round-trips stdio/http servers in the user config', { concurrency: false }, async () => {
  const tempRoot = await fs.mkdtemp(path.join(os.tmpdir(), 'llm-mcp-antigravity-'));
  const workspacePath = path.join(tempRoot, 'workspace');
  await fs.mkdir(workspacePath, { recursive: true });
  const restoreHomeDir = patchHomeDir(tempRoot);
  try {
    const provider = new AntigravityMcpProvider();

    await provider.upsertServer({
      name: 'echo',
      scope: 'user',
      transport: 'stdio',
      command: 'npx',
      args: ['echo-server'],
      workspacePath,
    });
    await provider.upsertServer({
      name: 'remote',
      scope: 'user',
      transport: 'http',
      url: 'https://example.com/mcp',
      headers: { Authorization: 'Bearer T' },
      workspacePath,
    });

    // All scopes collapse to the single user-global mcp_config.json; http
    // servers persist under Antigravity's own `serverUrl` key.
    const config = await readJson(path.join(tempRoot, '.gemini', 'config', 'mcp_config.json'));
    const servers = config.mcpServers as Record<string, any>;
    assert.equal(servers.echo.command, 'npx');
    assert.equal(servers.echo.disabled, false);
    assert.equal(servers.remote.serverUrl, 'https://example.com/mcp');
    assert.equal(servers.remote.headers.Authorization, 'Bearer T');

    const scoped = await provider.listServers({ workspacePath });
    assert.ok(scoped.user.some((s) => s.name === 'echo'));
    assert.ok(scoped.user.some((s) => s.name === 'remote' && s.url === 'https://example.com/mcp'));

    // project/local scopes are not supported by `agy mcp` — reject them.
    await assert.rejects(
      provider.upsertServer({
        name: 'bad',
        scope: 'project',
        transport: 'stdio',
        command: 'x',
        workspacePath,
      }),
    );
    // sse is not a transport this CLI accepts.
    await assert.rejects(
      provider.upsertServer({
        name: 'bad2',
        scope: 'user',
        transport: 'sse',
        url: 'https://example.com/sse',
        workspacePath,
      }),
    );
  } finally {
    restoreHomeDir();
    await fs.rm(tempRoot, { recursive: true, force: true });
  }
});
