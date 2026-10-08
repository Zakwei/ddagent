import assert from 'node:assert/strict';
import { access, mkdir, mkdtemp, rm, writeFile } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { ClaudeProviderAuth } from '@/modules/providers/list/claude/claude-auth.provider.js';
import { CodexProviderAuth } from '@/modules/providers/list/codex/codex-auth.provider.js';
import { CursorProviderAuth } from '@/modules/providers/list/cursor/cursor-auth.provider.js';
import { DevinProviderAuth } from '@/modules/providers/list/devin/devin-auth.provider.js';
import { devinDataDir } from '@/shared/index.js';

/** Runs `fn` with an empty PATH and HOME so no provider CLI can be found. */
const withoutClis = async (fn: () => Promise<void>) => {
  const emptyDir = await mkdtemp(path.join(os.tmpdir(), 'provider-auth-install-'));
  const original = { PATH: process.env.PATH, HOME: process.env.HOME, CLAUDE_CLI_PATH: process.env.CLAUDE_CLI_PATH };
  process.env.PATH = emptyDir;
  process.env.HOME = emptyDir;
  process.env.CLAUDE_CLI_PATH = path.join(emptyDir, 'claude');
  try {
    await fn();
  } finally {
    for (const [key, value] of Object.entries(original)) {
      if (value === undefined) delete process.env[key];
      else process.env[key] = value;
    }
    await rm(emptyDir, { recursive: true, force: true });
  }
};

// cross-spawn's spawn.sync reports ENOENT through `result.error` instead of
// throwing, so a try/catch-only probe reported every missing CLI as installed.
for (const [name, auth] of [
  ['claude', new ClaudeProviderAuth()],
  ['codex', new CodexProviderAuth()],
  ['cursor', new CursorProviderAuth()],
] as const) {
  test(`${name} auth reports a missing CLI as not installed`, async () => {
    await withoutClis(async () => {
      const status = await auth.getStatus();
      assert.equal(status.installed, false);
    });
  });
}

test('devin logout removes credentials.toml from the Devin data dir', async () => {
  await withoutClis(async () => {
    const credentialsPath = path.join(devinDataDir(), 'credentials.toml');
    await mkdir(path.dirname(credentialsPath), { recursive: true });
    await writeFile(credentialsPath, 'windsurf_api_key = "k"\n');

    await new DevinProviderAuth().logout();

    await assert.rejects(access(credentialsPath), { code: 'ENOENT' });
    // A missing file is not an error.
    await new DevinProviderAuth().logout();
  });
});
