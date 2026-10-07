import assert from 'node:assert/strict';
import { mkdir, mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { ClaudeProviderAuth } from '@/modules/providers/list/claude/claude-auth.provider.js';

// checkCredentials() is private, but unlike getStatus() it never shells out to the
// `claude` CLI — it only reads env vars and ~/.claude files. Calling it directly
// (TypeScript's `private` has no runtime effect) tests the priority order without
// depending on `claude` being installed in the test environment.
type CheckCredentialsResult = {
  authenticated: boolean;
  email: string | null;
  method: string | null;
  error?: string;
};

const checkCredentials = (auth: ClaudeProviderAuth): Promise<CheckCredentialsResult> =>
  (auth as unknown as { checkCredentials: () => Promise<CheckCredentialsResult> }).checkCredentials();

const ENV_KEYS = [
  'CLAUDE_CONFIG_DIR',
  'CLAUDE_CODE_OAUTH_TOKEN',
  'ANTHROPIC_API_KEY',
  'ANTHROPIC_AUTH_TOKEN',
] as const;

const withEnv = async (
  overrides: Partial<Record<(typeof ENV_KEYS)[number], string>>,
  fn: () => Promise<void>,
) => {
  const original: Partial<Record<(typeof ENV_KEYS)[number], string>> = {};
  for (const key of ENV_KEYS) {
    original[key] = process.env[key];
    const value = overrides[key];
    if (value === undefined) {
      delete process.env[key];
    } else {
      process.env[key] = value;
    }
  }
  try {
    await fn();
  } finally {
    for (const key of ENV_KEYS) {
      if (original[key] === undefined) {
        delete process.env[key];
      } else {
        process.env[key] = original[key];
      }
    }
  }
};

const withTempHome = async (fn: (homeDir: string) => Promise<void>) => {
  const homeDir = await mkdtemp(path.join(os.tmpdir(), 'claude-auth-test-'));
  const originalHome = process.env.HOME;
  process.env.HOME = homeDir;
  try {
    await fn(homeDir);
  } finally {
    if (originalHome === undefined) {
      delete process.env.HOME;
    } else {
      process.env.HOME = originalHome;
    }
    await rm(homeDir, { recursive: true, force: true });
  }
};

const writeCredentialsFile = async (homeDir: string, body: unknown) => {
  const claudeDir = path.join(homeDir, '.claude');
  await mkdir(claudeDir, { recursive: true });
  await writeFile(path.join(claudeDir, '.credentials.json'), JSON.stringify(body));
};

const writeSettingsFile = async (homeDir: string, env: Record<string, string>) => {
  const claudeDir = path.join(homeDir, '.claude');
  await mkdir(claudeDir, { recursive: true });
  await writeFile(path.join(claudeDir, 'settings.json'), JSON.stringify({ env }));
};

test('checkCredentials: CLAUDE_CODE_OAUTH_TOKEN set is authenticated via environment, even with a stale credentials file', async () => {
  await withTempHome(async (homeDir) => {
    await writeCredentialsFile(homeDir, {
      claudeAiOauth: { accessToken: 'stale-token', expiresAt: 1_000_000_000_000 }, // long expired
    });

    await withEnv({ CLAUDE_CODE_OAUTH_TOKEN: 'test-oauth-token' }, async () => {
      const status = await checkCredentials(new ClaudeProviderAuth());
      assert.equal(status.authenticated, true);
      assert.equal(status.method, 'environment');
    });
  });
});

test('checkCredentials: CLAUDE_CODE_OAUTH_TOKEN configured via settings.json env block is authenticated via environment', async () => {
  await withTempHome(async (homeDir) => {
    await writeSettingsFile(homeDir, { CLAUDE_CODE_OAUTH_TOKEN: 'test-oauth-token-from-settings' });
    await writeCredentialsFile(homeDir, {
      claudeAiOauth: { accessToken: 'stale-token', expiresAt: 1_000_000_000_000 }, // long expired
    });

    await withEnv({}, async () => {
      const status = await checkCredentials(new ClaudeProviderAuth());
      assert.equal(status.authenticated, true);
      assert.equal(status.method, 'environment');
    });
  });
});

test('checkCredentials: no CLAUDE_CODE_OAUTH_TOKEN, valid credentials file falls back to credentials_file', async () => {
  await withTempHome(async (homeDir) => {
    await writeCredentialsFile(homeDir, {
      claudeAiOauth: { accessToken: 'valid-token', expiresAt: Date.now() + 60 * 60 * 1000 },
      email: 'someone@example.com',
    });

    await withEnv({}, async () => {
      const status = await checkCredentials(new ClaudeProviderAuth());
      assert.equal(status.authenticated, true);
      assert.equal(status.method, 'credentials_file');
      assert.equal(status.email, 'someone@example.com');
    });
  });
});

test('checkCredentials: no CLAUDE_CODE_OAUTH_TOKEN, expired credentials file reports not authenticated', async () => {
  await withTempHome(async (homeDir) => {
    await writeCredentialsFile(homeDir, {
      claudeAiOauth: { accessToken: 'stale-token', expiresAt: 1_000_000_000_000 },
    });

    await withEnv({}, async () => {
      const status = await checkCredentials(new ClaudeProviderAuth());
      assert.equal(status.authenticated, false);
      assert.match(status.error ?? '', /expired/i);
    });
  });
});

test('checkCredentials: ANTHROPIC_API_KEY takes precedence over CLAUDE_CODE_OAUTH_TOKEN', async () => {
  await withTempHome(async () => {
    await withEnv(
      { ANTHROPIC_API_KEY: 'test-api-key', CLAUDE_CODE_OAUTH_TOKEN: 'test-oauth-token' },
      async () => {
        const status = await checkCredentials(new ClaudeProviderAuth());
        assert.equal(status.authenticated, true);
        assert.equal(status.method, 'api_key');
      },
    );
  });
});

test('logout removes the credentials file and credential env keys, preserving preferences', async () => {
  await withTempHome(async (homeDir) => {
    await writeCredentialsFile(homeDir, {
      claudeAiOauth: { accessToken: 'valid-token', expiresAt: Date.now() + 60 * 60 * 1000 },
    });
    const claudeDir = path.join(homeDir, '.claude');
    await writeFile(path.join(claudeDir, 'settings.json'), JSON.stringify({
      env: {
        ANTHROPIC_AUTH_TOKEN: 'proxy-token',
        ANTHROPIC_API_KEY: 'proxy-token',
        CLAUDE_CODE_OAUTH_TOKEN: 'oauth-token',
        ANTHROPIC_MODEL: 'sonnet',
      },
      theme: 'dark',
    }));

    await withEnv({}, async () => {
      const auth = new ClaudeProviderAuth();
      await auth.logout();

      const status = await checkCredentials(auth);
      assert.equal(status.authenticated, false);

      await assert.rejects(readFile(path.join(claudeDir, '.credentials.json'), 'utf8'), { code: 'ENOENT' });

      const settings = JSON.parse(await readFile(path.join(claudeDir, 'settings.json'), 'utf8'));
      assert.deepEqual(settings.env, { ANTHROPIC_MODEL: 'sonnet' });
      assert.equal(settings.theme, 'dark');
    });
  });
});

test('logout targets CLAUDE_CONFIG_DIR when configured', async () => {
  await withTempHome(async (homeDir) => {
    const isolatedDir = path.join(homeDir, 'isolated-claude');
    await mkdir(isolatedDir, { recursive: true });
    await writeFile(
      path.join(isolatedDir, '.credentials.json'),
      JSON.stringify({ claudeAiOauth: { accessToken: 'valid-token' } }),
    );

    await withEnv({ CLAUDE_CONFIG_DIR: isolatedDir }, async () => {
      await new ClaudeProviderAuth().logout();
      await assert.rejects(readFile(path.join(isolatedDir, '.credentials.json'), 'utf8'), { code: 'ENOENT' });
    });
  });
});

test('logout tolerates missing credentials and malformed settings', async () => {
  await withTempHome(async (homeDir) => {
    const claudeDir = path.join(homeDir, '.claude');
    await mkdir(claudeDir, { recursive: true });
    await writeFile(path.join(claudeDir, 'settings.json'), '{ not json');

    await withEnv({}, async () => {
      await new ClaudeProviderAuth().logout();
      assert.equal(await readFile(path.join(claudeDir, 'settings.json'), 'utf8'), '{ not json');
    });
  });
});
