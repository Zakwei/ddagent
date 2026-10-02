import assert from 'node:assert/strict';
import { spawn } from 'node:child_process';
import { mkdtemp, mkdir, readFile, writeFile } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import {
  applyUnifiedPrefix,
  buildUnifiedPrefix,
  claudeGlobalSkillsDir,
  ensureClaudeMirror,
  installClaudeHook,
  isClaudeHookInstalled,
  isOpencodeDcpEnabled,
  readUnifiedRules,
  uninstallClaudeHook,
  unifiedGlobalSkillsDir,
  UNIFIED_HYGIENE_BLOCK,
} from '../services/unified-hub.service.js';

const withTempHome = async (run: (home: string) => Promise<void>): Promise<void> => {
  const home = await mkdtemp(path.join(os.tmpdir(), 'unified-test-'));
  const original = os.homedir;
  (os as unknown as { homedir: () => string }).homedir = () => home;
  try {
    await run(home);
  } finally {
    (os as unknown as { homedir: () => string }).homedir = original;
  }
};

test('rules disabled via DDAGENT_UNIFIED_RULES=0', async () => {
  process.env.DDAGENT_UNIFIED_RULES = '0';
  try {
    assert.equal(await buildUnifiedPrefix(), null);
    assert.equal(await applyUnifiedPrefix('hello'), 'hello');
  } finally {
    delete process.env.DDAGENT_UNIFIED_RULES;
  }
});

test('prefix aggregates workspace AGENTS.md plus hygiene block', async () => {
  await withTempHome(async (home) => {
    const workspace = await mkdtemp(path.join(os.tmpdir(), 'unified-ws-'));
    await writeFile(path.join(workspace, 'AGENTS.md'), '# Rules\nRespond briefly.\n', 'utf8');

    const { sources, text } = await readUnifiedRules(workspace);
    assert.equal(sources.length, 2);
    assert.ok(sources[0]?.present);
    assert.equal(sources[1]?.path, path.join(home, '.agents', 'AGENTS.md'));
    assert.match(text, /Respond briefly/);

    const prefix = await buildUnifiedPrefix(workspace);
    assert.ok(prefix?.startsWith('<unified-rules>'));
    assert.match(prefix ?? '', /Respond briefly/);
    assert.match(prefix ?? '', /Do not paste full tool outputs/);
    assert.equal(await applyUnifiedPrefix('do it', workspace), `${prefix}do it`);
  });
});

test('hygiene block is always on even without rule files', async () => {
  await withTempHome(async () => {
    const prefix = await buildUnifiedPrefix('/nonexistent-workspace');
    assert.ok(prefix);
    assert.match(prefix ?? '', /unified-hygiene/);
    assert.equal(UNIFIED_HYGIENE_BLOCK.includes('unified-hygiene'), true);
  });
});

test('claude mirror is a symlink created only when absent', async () => {
  await withTempHome(async () => {
    const first = await ensureClaudeMirror();
    assert.equal(first.mirrored, true);
    assert.equal(first.target, unifiedGlobalSkillsDir());

    const second = await ensureClaudeMirror();
    assert.equal(second.mirrored, false);

    const { readlink } = await import('node:fs/promises');
    assert.equal(await readlink(claudeGlobalSkillsDir()), unifiedGlobalSkillsDir());
  });
});

test('existing real claude skills dir is left alone', async () => {
  await withTempHome(async () => {
    await mkdir(claudeGlobalSkillsDir(), { recursive: true });
    await writeFile(path.join(claudeGlobalSkillsDir(), 'SKILL.md'), '# mine\n', 'utf8');
    const result = await ensureClaudeMirror();
    assert.equal(result.mirrored, false);
    assert.equal(await readFile(path.join(claudeGlobalSkillsDir(), 'SKILL.md'), 'utf8'), '# mine\n');
  });
});

test('claude hook install/uninstall round-trips without touching other hooks', async () => {
  await withTempHome(async (home) => {
    const settingsPath = path.join(home, '.claude', 'settings.json');
    await mkdir(path.dirname(settingsPath), { recursive: true });
    await writeFile(
      settingsPath,
      JSON.stringify({ hooks: { SessionStart: [{ matcher: '', hooks: [{ type: 'command', command: 'echo hi' }] }] } }),
      'utf8',
    );

    const installed = await installClaudeHook();
    assert.equal(installed.installed, true);
    assert.equal((await isClaudeHookInstalled()).installed, true);

    const again = await installClaudeHook();
    assert.equal(again.installed, false);

    const removed = await uninstallClaudeHook();
    assert.equal(removed.removed, true);
    assert.equal((await isClaudeHookInstalled()).installed, false);

    const settings = JSON.parse(await readFile(settingsPath, 'utf8')) as {
      hooks: { SessionStart: Array<{ hooks: Array<{ command: string }> }> };
    };
    assert.equal(settings.hooks.SessionStart.length, 1);
    assert.equal(settings.hooks.SessionStart[0]?.hooks[0]?.command, 'echo hi');
  });
});

test('opencode DCP detection reports absent config as disabled', async () => {
  await withTempHome(async () => {
    const result = await isOpencodeDcpEnabled();
    assert.equal(result.enabled, false);
  });
});

test('opencode DCP detection finds a dcp plugin entry', async () => {
  await withTempHome(async (home) => {
    const configDir = path.join(home, '.config', 'opencode');
    await mkdir(configDir, { recursive: true });
    await writeFile(path.join(configDir, 'opencode.jsonc'), '{ "plugin": ["@tarquinen/opencode-dcp"] }', 'utf8');
    const result = await isOpencodeDcpEnabled();
    assert.equal(result.enabled, true);
  });
});

test('session-start hook prunes repeated errors and exits 0 on garbage', async () => {
  const script = path.join(process.cwd(), 'scripts', 'unified-hooks', 'claude-session-start.mjs');
  // NOTE: child_process.execFile({ input }) hangs in this repo's wrapped-node
  // environment (verified by experiment), so the hook is driven via spawn with
  // an explicit stdin write+end. Ambient NODE_OPTIONS (signal shield) is
  // stripped so inherited --require hooks cannot keep the child alive.
  const runHook = (input: string): Promise<{ stdout: string; exitCode: number | null }> =>
    new Promise((resolve, reject) => {
      const child = spawn(process.execPath, [script], { env: { ...process.env, NODE_OPTIONS: '' } });
      let stdout = '';
      const timer = setTimeout(() => {
        child.kill();
        reject(new Error('hook script timed out'));
      }, 15000);
      child.stdout.on('data', (chunk) => {
        stdout += chunk;
      });
      child.on('error', (error) => {
        clearTimeout(timer);
        reject(error);
      });
      child.on('close', (exitCode) => {
        clearTimeout(timer);
        resolve({ stdout, exitCode });
      });
      child.stdin.write(input);
      child.stdin.end();
    });
  const transcript = [
    'tool:Read result: ok',
    'Error: boom failed',
    'Error: boom failed',
    'Error: boom failed',
    'Error: boom failed',
    'tool:Read result: newer ok',
  ];
  const pruned = await runHook(JSON.stringify({ transcript }));
  assert.equal(pruned.exitCode, 0);
  const payload = JSON.parse(pruned.stdout) as { additionalContext: string };
  assert.match(payload.additionalContext, /unified-context-prune/);
  assert.match(payload.additionalContext, /repeated 4x/);

  const garbage = await runHook('not json');
  assert.equal(garbage.exitCode, 0);
  assert.equal(garbage.stdout, '');
});
