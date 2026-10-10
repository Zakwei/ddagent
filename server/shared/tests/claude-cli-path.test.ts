import assert from 'node:assert/strict';
import test from 'node:test';

import {
  claudeCliInvocation,
  resolveClaudeCodeExecutablePath,
  type ResolveClaudeCodeExecutablePathDependencies,
} from '@/shared/claude-cli-path.js';

test('resolveClaudeCodeExecutablePath resolves the npm Claude wrapper to its native exe on Windows', () => {
  const wrapperDir = 'C:\\nvm4w\\nodejs';
  const nativePath = `${wrapperDir}\\node_modules\\@anthropic-ai\\claude-code\\bin\\claude.exe`;
  const execFileSync =
    (() => `${wrapperDir}\\claude\r\n${wrapperDir}\\claude.cmd\r\n`) as unknown as ResolveClaudeCodeExecutablePathDependencies['execFileSync'];
  const readFileSync = (() => '') as unknown as ResolveClaudeCodeExecutablePathDependencies['readFileSync'];

  const resolved = resolveClaudeCodeExecutablePath('claude', {
    platform: 'win32',
    execFileSync,
    existsSync: (candidate) => candidate === nativePath,
    readFileSync,
  });

  assert.equal(resolved, nativePath);
});

test('resolveClaudeCodeExecutablePath keeps an explicit JavaScript launcher path unchanged', () => {
  const scriptPath = 'C:\\tools\\claude.js';

  const resolved = resolveClaudeCodeExecutablePath(scriptPath, {
    platform: 'win32',
  });

  assert.equal(resolved, scriptPath);
});

test('resolveClaudeCodeExecutablePath can parse a wrapper file path containing letters r and n before claude.exe', () => {
  const wrapperPath = 'C:\\tools\\claude';
  const nativePath = 'C:\\tools\\custom\\bin\\node_modules\\@anthropic-ai\\claude-code\\bin\\claude.exe';
  const readFileSync = (() => `exec "$basedir/custom/bin/node_modules/@anthropic-ai/claude-code/bin/claude.exe" "$@"`) as unknown as ResolveClaudeCodeExecutablePathDependencies['readFileSync'];

  const resolved = resolveClaudeCodeExecutablePath(wrapperPath, {
    platform: 'win32',
    existsSync: (candidate) => candidate === nativePath,
    readFileSync,
  });

  assert.equal(resolved, nativePath);
});

test('resolveClaudeCodeExecutablePath falls back to the configured command when PATH lookup fails', () => {
  const execFileSync = (() => {
    throw new Error('not found');
  }) as unknown as ResolveClaudeCodeExecutablePathDependencies['execFileSync'];

  const resolved = resolveClaudeCodeExecutablePath('claude', {
    platform: 'win32',
    execFileSync,
  });

  assert.equal(resolved, 'claude');
});

test('claudeCliInvocation runs a JavaScript launcher through node instead of opening it', () => {
  // A configured `CLAUDE_CLI_PATH=…\claude-ddagent.mjs`: spawned directly,
  // Windows hands the script to its file association (an editor/"open with").
  assert.deepEqual(claudeCliInvocation('C:\\Users\\me\\bin\\claude-ddagent.mjs', ['--version']), {
    command: process.execPath,
    args: ['C:\\Users\\me\\bin\\claude-ddagent.mjs', '--version'],
  });
  assert.deepEqual(claudeCliInvocation('/opt/claude/cli.js', ['--version']).command, process.execPath);
  assert.deepEqual(claudeCliInvocation('claude', ['--version']), { command: 'claude', args: ['--version'] });
  assert.deepEqual(claudeCliInvocation('C:\\x\\claude.exe', []), { command: 'C:\\x\\claude.exe', args: [] });
});
