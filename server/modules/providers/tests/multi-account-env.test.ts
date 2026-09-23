import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import path from 'node:path';
import test from 'node:test';
import { fileURLToPath } from 'node:url';

// NOTE: the providers barrel must evaluate before the direct runtime imports —
// importing claude-runtime first makes the registry → provider → runtime cycle
// resolve with claudeRuntime still in TDZ.
import '@/modules/providers/index.js';
import { mapCliOptionsToSDK } from '@/modules/providers/list/claude/claude-runtime.provider.js';
import { serverKeyFor } from '@/modules/providers/list/opencode/opencode-server.manager.js';

const TEST_DIR = path.dirname(fileURLToPath(import.meta.url));

const readRuntimeSource = (relativePath: string): Promise<string> =>
  readFile(path.join(TEST_DIR, '..', 'list', relativePath), 'utf8');

/**
 * Multi-account matrix: a session bound to a provider_accounts row carries its
 * env overrides in options.env; every provider runtime must merge them into
 * the child environment so the CLI/SDK sees the isolated credential dir.
 */

test('claude: options.env lands in sdkOptions.env (CLAUDE_CONFIG_DIR isolation)', () => {
  const sdkOptions = mapCliOptionsToSDK({
    cwd: '/tmp/project',
    env: { CLAUDE_CONFIG_DIR: '/tmp/isolated' },
  }) as { env: Record<string, string> };
  assert.equal(sdkOptions.env.CLAUDE_CONFIG_DIR, '/tmp/isolated');
  // Baseline vars survive the merge.
  assert.ok(sdkOptions.env.CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS);
});

test('codex: runtime forwards options.env through providerChildEnv into Codex()', async () => {
  const source = await readRuntimeSource('codex/codex-runtime.provider.js');
  assert.match(source, /new Codex\(\{\s*env: providerChildEnv\(options\.env/);
});

test('cursor: spawn env merges options.env', async () => {
  const source = await readRuntimeSource('cursor/cursor-runtime.provider.js');
  assert.match(source, /env: providerChildEnv\(options\.env/);
});

test('devin: createDevinProcess merges extraEnv into providerChildEnv', async () => {
  const source = await readRuntimeSource('devin/devin-runtime.provider.js');
  assert.match(source, /providerChildEnv\(extraEnv/);
  assert.equal(
    (source.match(/createDevinProcess\([^)]*options\.env/g) ?? []).length >= 2,
    true,
    'both spawn sites (initial + stalled-restart) forward options.env',
  );
});

test('opencode: account env keys the serve-instance cache', () => {
  const dir = '/tmp/proj';
  assert.equal(serverKeyFor(dir), serverKeyFor(dir, {}), 'empty overrides share the ambient server');
  assert.notEqual(
    serverKeyFor(dir, { XDG_CONFIG_HOME: '/tmp/a' }),
    serverKeyFor(dir, { XDG_CONFIG_HOME: '/tmp/b' }),
    'different accounts get different servers',
  );
  assert.notEqual(serverKeyFor(dir), serverKeyFor(dir, { XDG_CONFIG_HOME: '/tmp/a' }));
});

test('opencode: runtime passes options.env to ensureServer', async () => {
  const source = await readRuntimeSource('opencode/opencode-runtime.provider.ts');
  assert.match(source, /ensureServer\(workingDir, envOverrides\)/);
});
