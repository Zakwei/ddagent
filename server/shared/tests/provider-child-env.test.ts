import assert from 'node:assert/strict';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import {
  devinConfigDir,
  devinDataDir,
  powerShellArgs,
  providerChildEnv,
} from '@/shared/utils.js';

test('providerChildEnv appends the user-local bin to PATH', () => {
  const env = providerChildEnv({}, { PATH: '/usr/bin' });
  const expected = ['/usr/bin', path.join(os.homedir(), '.local', 'bin')].join(path.delimiter);
  assert.equal(env.PATH, expected);
});

// Windows env keys are case-insensitive and process.env uses the `Path`
// casing. Writing a separate `PATH` key would shadow `Path` in the child's
// env block and leave it without the real PATH — `spawn devin ENOENT` on
// every bare command. The existing key must be reused instead of duplicated.
test('providerChildEnv reuses the existing PATH key casing instead of adding a case-variant duplicate', () => {
  const env = providerChildEnv({}, { Path: 'C:\\Tools' });
  const pathKeys = Object.keys(env).filter((key) => key.toUpperCase() === 'PATH');
  assert.deepEqual(pathKeys, ['Path']);
  assert.ok(env.Path?.includes('C:\\Tools'));
  assert.ok(env.Path?.includes(path.join(os.homedir(), '.local', 'bin')));
});

test('providerChildEnv creates PATH when absent', () => {
  const env = providerChildEnv({}, {});
  assert.ok(env.PATH?.includes(path.join(os.homedir(), '.local', 'bin')));
});

test('providerChildEnv keeps explicit overrides and defaults TASK_MASTER_TOOLS', () => {
  const env = providerChildEnv({ PATH: '/custom' }, { PATH: '/usr/bin' });
  assert.equal(env.PATH, '/custom');
  assert.equal(env.TASK_MASTER_TOOLS, 'standard');
});

test('powerShellArgs bypasses the execution policy and runs interactively without a command', () => {
  assert.deepEqual(powerShellArgs('claude'), [
    '-NoLogo', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', 'claude',
  ]);
  assert.deepEqual(powerShellArgs(''), ['-NoLogo', '-ExecutionPolicy', 'Bypass']);
});

if (process.platform === 'win32') {
  test('devin dirs point into %APPDATA%\\devin on Windows', () => {
    const roaming = process.env.APPDATA ?? path.join(os.homedir(), 'AppData', 'Roaming');
    assert.equal(devinDataDir(), path.join(roaming, 'devin'));
    assert.equal(devinConfigDir(), path.join(roaming, 'devin'));
  });
} else {
  test('devin dirs keep the XDG layout off Windows', () => {
    assert.equal(devinDataDir(), path.join(os.homedir(), '.local', 'share', 'devin'));
    assert.equal(devinConfigDir(), path.join(os.homedir(), '.config', 'devin'));
  });
}

test('providerChildEnv appends npm/pnpm global bins and the node dir on Windows', () => {
  const env = providerChildEnv(
    {},
    { Path: 'C:\\Windows', APPDATA: 'C:\\Users\\u\\AppData\\Roaming', LOCALAPPDATA: 'C:\\Users\\u\\AppData\\Local' },
    'win32',
  );
  const entries = env.Path?.split(';') ?? [];
  assert.equal(entries[0], 'C:\\Windows');
  assert.ok(entries.includes('C:\\Users\\u\\AppData\\Roaming\\npm'));
  assert.ok(entries.includes('C:\\Users\\u\\AppData\\Local\\pnpm'));
  assert.ok(entries.includes(path.win32.dirname(process.execPath)));
});

test('providerChildEnv skips Windows dirs already on PATH regardless of case', () => {
  const env = providerChildEnv({}, { Path: 'c:\\users\\u\\appdata\\roaming\\NPM', APPDATA: 'C:\\Users\\u\\AppData\\Roaming' }, 'win32');
  const npmEntries = (env.Path?.split(';') ?? []).filter((entry) => entry.toLowerCase().endsWith('\\npm'));
  assert.equal(npmEntries.length, 1);
});
