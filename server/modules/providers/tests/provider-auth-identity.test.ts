import assert from 'node:assert/strict';
import { chmod, mkdir, mkdtemp, rm, writeFile } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import spawn from 'cross-spawn';

import { AntigravityProviderAuth } from '@/modules/providers/list/antigravity/antigravity-auth.provider.js';
import { ClaudeProviderAuth } from '@/modules/providers/list/claude/claude-auth.provider.js';
import { CodexProviderAuth } from '@/modules/providers/list/codex/codex-auth.provider.js';
import { CommandCodeProviderAuth } from '@/modules/providers/list/commandcode/commandcode-auth.provider.js';
import { CursorProviderAuth } from '@/modules/providers/list/cursor/cursor-auth.provider.js';
import { DevinProviderAuth } from '@/modules/providers/list/devin/devin-auth.provider.js';
import { OpenCodeProviderAuth } from '@/modules/providers/list/opencode/opencode-auth.provider.js';
import type { IProviderAuth } from '@/shared/index.js';

const secret = 'test-secret-never-returned';
const email = 'account@example.com';
const idToken = `header.${Buffer.from(JSON.stringify({ email })).toString('base64url')}.signature`;
const envKeys = [
  'ANTHROPIC_AUTH_TOKEN', 'ANTHROPIC_API_KEY', 'CLAUDE_CODE_OAUTH_TOKEN',
  'COMMAND_CODE_API_KEY', 'GEMINI_API_KEY', 'WINDSURF_API_KEY', 'DEVIN_API_KEY',
  'OPENAI_API_KEY', 'GOOGLE_GENERATIVE_AI_API_KEY', 'GROQ_API_KEY', 'OPENROUTER_API_KEY',
];

// Every getStatus call reads synthetic credentials. No real CLI or account is used.
test('provider identities follow current credentials without retaining previous accounts', async (t) => {
  const directory = await mkdtemp(path.join(os.tmpdir(), 'provider-identity-'));
  t.mock.method(os, 'homedir', () => directory);
  t.mock.method(spawn, 'sync', () => ({ status: 0 }));
  const savedEnv = Object.fromEntries(envKeys.map((key) => [key, process.env[key]]));
  for (const key of envKeys) delete process.env[key];
  t.after(async () => {
    for (const [key, value] of Object.entries(savedEnv)) {
      if (value === undefined) delete process.env[key];
      else process.env[key] = value;
    }
    await rm(directory, { recursive: true, force: true });
  });

  const write = async (relativePath: string, value: unknown) => {
    const file = path.join(directory, relativePath);
    await mkdir(path.dirname(file), { recursive: true });
    await writeFile(file, JSON.stringify(value));
  };
  const check = async (auth: IProviderAuth, authenticated: boolean, identity: string | null) => {
    const status = await auth.getStatus();
    assert.equal(status.authenticated, authenticated);
    assert.equal(status.email, identity);
    assert.ok(!JSON.stringify(status).includes(secret));
    assert.ok(!JSON.stringify(status).includes(idToken));
  };

  const scenarios = [
    {
      name: 'Codex', auth: new CodexProviderAuth(), file: '.codex/auth.json',
      signedIn: { tokens: { access_token: secret, id_token: idToken } },
      anonymous: { tokens: { access_token: secret, id_token: 'malformed' } },
      signedOut: { tokens: { id_token: idToken } },
      identity: email,
    },
    {
      name: 'Claude', auth: new ClaudeProviderAuth(), file: '.claude/.credentials.json',
      signedIn: { claudeAiOauth: { accessToken: secret }, email: ` ${email} ` },
      anonymous: { claudeAiOauth: { accessToken: secret }, email: '   ' },
      signedOut: { email },
      identity: email,
    },
    {
      name: 'Command Code', auth: new CommandCodeProviderAuth(), file: '.commandcode/auth.json',
      signedIn: { apiKey: secret, userName: ' my-user ' },
      anonymous: { apiKey: secret, userName: '   ' },
      signedOut: { userName: 'my-user', userId: 'old-account' },
      identity: 'my-user',
    },
    {
      name: 'Antigravity/Gemini', auth: new AntigravityProviderAuth(), file: '.gemini/antigravity-cli/antigravity-oauth-token',
      signedIn: { token: { access_token: secret }, id_token: idToken },
      anonymous: { token: { access_token: secret }, id_token: 'malformed' },
      signedOut: { id_token: idToken },
      identity: email,
    },
  ];
  for (const scenario of scenarios) {
    await t.test(`${scenario.name}: identity, missing identity, logout, lost and malformed credentials`, async () => {
      await check(scenario.auth, false, null);
      await write(scenario.file, scenario.signedIn);
      await check(scenario.auth, true, scenario.identity);
      await write(scenario.file, scenario.anonymous);
      await check(scenario.auth, true, null);
      await write(scenario.file, scenario.signedIn);
      await check(scenario.auth, true, scenario.identity);
      await write(scenario.file, scenario.signedOut);
      await check(scenario.auth, false, null);
      await write(scenario.file, scenario.signedIn);
      await check(scenario.auth, true, scenario.identity);
      await rm(path.join(directory, scenario.file));
      await check(scenario.auth, false, null);
      await write(scenario.file, scenario.signedIn);
      await check(scenario.auth, true, scenario.identity);
      await writeFile(path.join(directory, scenario.file), `{"secret":"${secret}", broken`);
      await check(scenario.auth, false, null);
      await rm(path.join(directory, scenario.file));
    });
  }

  await t.test('Claude: expiration and each env/settings credential override clear a previous account', async () => {
    const auth = new ClaudeProviderAuth();
    for (const key of ['ANTHROPIC_API_KEY', 'ANTHROPIC_AUTH_TOKEN', 'CLAUDE_CODE_OAUTH_TOKEN']) {
      for (const source of ['environment', 'settings']) {
        await write('.claude/.credentials.json', { claudeAiOauth: { accessToken: secret }, email });
        await check(auth, true, email);
        if (source === 'environment') process.env[key] = secret;
        else await write('.claude/settings.json', { env: { [key]: secret } });
        await check(auth, true, null);
        delete process.env[key];
        await rm(path.join(directory, '.claude/settings.json'), { force: true });
      }
    }
    await write('.claude/.credentials.json', { claudeAiOauth: { accessToken: secret, expiresAt: 1 }, email });
    await check(auth, false, null);
    await rm(path.join(directory, '.claude/.credentials.json'));
  });

  await t.test('API keys replace account identities and are never displayed', async () => {
    for (const scenario of [scenarios[2], scenarios[3]]) {
      const key = scenario.name === 'Command Code' ? 'COMMAND_CODE_API_KEY' : 'GEMINI_API_KEY';
      await write(scenario.file, scenario.signedIn);
      await check(scenario.auth, true, scenario.identity);
      process.env[key] = secret;
      await check(scenario.auth, true, null);
      await rm(path.join(directory, scenario.file));
      delete process.env[key];
      await check(scenario.auth, false, null);
    }
    await write('.codex/auth.json', { OPENAI_API_KEY: secret });
    await check(new CodexProviderAuth(), true, null);
    await rm(path.join(directory, '.codex/auth.json'));
    await write('.commandcode/auth.json', { upstream: { apiKey: secret } });
    await check(new CommandCodeProviderAuth(), true, null);
    await write('.commandcode/auth.json', { upstream: { apiKey: ' ' } });
    await check(new CommandCodeProviderAuth(), false, null);
  });

  await t.test('OpenCode: upstream credentials provide no single account identity; metadata is not a login', async () => {
    const auth = new OpenCodeProviderAuth();
    const file = '.local/share/opencode/auth.json';
    await check(auth, false, null);
    for (const entry of [
      { type: 'api', key: secret },
      { type: 'oauth', access: secret, accountId: 'account-id' },
      { type: 'oauth', refresh: secret },
      { type: 'wellknown', key: 'env-name', token: secret },
    ]) {
      await write(file, { upstream: entry });
      await check(auth, true, null);
      await write(file, { upstream: { type: entry.type, accountId: 'old-account', email } });
      await check(auth, false, null);
    }
    await rm(path.join(directory, file));
    for (const key of ['ANTHROPIC_API_KEY', 'OPENAI_API_KEY', 'GOOGLE_GENERATIVE_AI_API_KEY', 'GROQ_API_KEY', 'OPENROUTER_API_KEY']) {
      process.env[key] = secret;
      await check(auth, true, null);
      delete process.env[key];
      await check(auth, false, null);
    }
    await write(file, { upstream: { type: 'api', key: secret } });
    await check(auth, true, null);
    await writeFile(path.join(directory, file), `{"secret":"${secret}", broken`);
    await check(auth, false, null);
  });

  await t.test('Devin: all credential sources return no identity and removal clears login', async () => {
    const auth = new DevinProviderAuth();
    const file = '.local/share/devin/credentials.toml';
    await check(auth, false, null);
    await mkdir(path.dirname(path.join(directory, file)), { recursive: true });
    await writeFile(path.join(directory, file), `windsurf_api_key = "${secret}"\n`);
    await check(auth, true, null);
    await rm(path.join(directory, file));
    await check(auth, false, null);
    for (const key of ['WINDSURF_API_KEY', 'DEVIN_API_KEY']) {
      process.env[key] = secret;
      await check(auth, true, null);
      delete process.env[key];
      await check(auth, false, null);
    }
    for (const key of ['windsurf_api_key', 'api_key']) {
      await write('.config/devin/config.json', { devin: { [key]: secret } });
      await check(auth, true, null);
      await write('.config/devin/config.json', { devin: { email } });
      await check(auth, false, null);
    }
    await writeFile(path.join(directory, '.config/devin/config.json'), `{"secret":"${secret}", broken`);
    await check(auth, false, null);
  });

  await t.test('Cursor: CLI identity is cleared by generic status, logout and failed status', async () => {
    const executable = path.join(directory, 'cursor-agent');
    const previousPath = process.env.PATH;
    process.env.PATH = `${directory}${path.delimiter}${previousPath ?? ''}`;
    try {
      const auth = new CursorProviderAuth();
      const reply = async (output: string, code = 0) => {
        await writeFile(executable, `#!/bin/sh\nprintf '%s' '${output}'\nexit ${code}\n`);
        await chmod(executable, 0o700);
      };
      await reply(`Logged in as ${email}`);
      await check(auth, true, email);
      await reply('Logged in');
      await check(auth, true, null);
      await reply(`Logged in as ${email}`);
      await check(auth, true, email);
      await reply('Not logged in');
      await check(auth, false, null);
      await reply(`Logged in as ${email}`);
      await check(auth, true, email);
      await reply(`${secret}: Logged in as ${email}`, 1);
      await check(auth, false, null);
    } finally {
      if (previousPath === undefined) delete process.env.PATH;
      else process.env.PATH = previousPath;
    }
  });
});
