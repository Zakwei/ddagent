import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { createSystemUpdateService } from '../system.service.js';

type SystemUpdateDependencies = Parameters<typeof createSystemUpdateService>[0];

function createDependencies(
  overrides: Partial<SystemUpdateDependencies> = {},
): SystemUpdateDependencies {
  return {
    appRoot: '/app/ddagent',
    homeDirectory: '/home/ddagent',
    installMode: 'git',
    isPlatform: false,
    environment: { TEST_ENVIRONMENT: 'true' },
    githubTokens: { getActiveGithubToken: () => null },
    runShellCommand: async () => ({ exitCode: 0, output: 'updated', errorOutput: '' }),
    logInfo: () => undefined,
    logError: () => undefined,
    ...overrides,
  };
}

test('git installations update from the application root', async () => {
  const calls: unknown[][] = [];
  const dependencies = createDependencies({
    runShellCommand: async (command, workingDirectory, environment) => {
      calls.push([command, workingDirectory, environment]);
      return { exitCode: 0, output: 'git update complete', errorOutput: '' };
    },
  });
  const service = createSystemUpdateService(dependencies);

  const result = await service.updateSystem();

  assert.deepEqual(calls, [[
    'git pull && npm install && npm run build',
    '/app/ddagent',
    dependencies.environment,
  ]]);
  assert.deepEqual(result, {
    success: true,
    output: 'git update complete',
    message: 'Update completed. Please restart the server to apply changes.',
  });
});

test('git updates sync the launcher patch mirror when it exists', async () => {
  const patchDir = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-patch-'));
  try {
    const calls: unknown[][] = [];
    const dependencies = createDependencies({
      environment: { DDAGENT_PATCH_DIR: patchDir },
      runShellCommand: async (command, workingDirectory) => {
        calls.push([command, workingDirectory]);
        return { exitCode: 0, output: '', errorOutput: '' };
      },
    });
    const service = createSystemUpdateService(dependencies);

    const result = await service.updateSystem();

    assert.equal(calls.length, 2);
    assert.match(String(calls[1][0]), /cp -r dist\//);
    assert.match(String(calls[1][0]), /claude-runtime\.provider\.js/);
    assert.match(String(calls[1][0]), /devin-sessions\.provider\.js/);
    assert.equal(result.success, true);
  } finally {
    fs.rmSync(patchDir, { recursive: true, force: true });
  }
});

test('platform mode on a git checkout uses the git workflow', async () => {
  const calls: unknown[][] = [];
  const dependencies = createDependencies({
    isPlatform: true,
    runShellCommand: async (command, workingDirectory) => {
      calls.push([command, workingDirectory]);
      return { exitCode: 0, output: '', errorOutput: '' };
    },
  });
  const service = createSystemUpdateService(dependencies);

  await service.updateSystem();

  assert.deepEqual(calls, [[
    'git pull && npm install && npm run build',
    '/app/ddagent',
  ]]);
});

test('global npm installations update from the user home directory', async () => {
  const calls: unknown[][] = [];
  const dependencies = createDependencies({
    installMode: 'npm',
    runShellCommand: async (command, workingDirectory, environment) => {
      calls.push([command, workingDirectory, environment]);
      return { exitCode: 0, output: '', errorOutput: '' };
    },
  });
  const service = createSystemUpdateService(dependencies);

  const result = await service.updateSystem();

  assert.deepEqual(calls, [[
    'npm install -g @ddagent-ai/ddagent@latest',
    '/home/ddagent',
    dependencies.environment,
  ]]);
  assert.equal(result.output, 'Update completed successfully');
});

test('platform installations use the platform workflow regardless of install mode', async () => {
  const calls: unknown[][] = [];
  const dependencies = createDependencies({
    installMode: 'npm',
    isPlatform: true,
    runShellCommand: async (command, workingDirectory, environment) => {
      calls.push([command, workingDirectory, environment]);
      return { exitCode: 0, output: 'platform update complete', errorOutput: '' };
    },
  });
  const service = createSystemUpdateService(dependencies);

  await service.updateSystem();

  assert.deepEqual(calls, [[
    'npm run update:platform',
    '/app/ddagent',
    dependencies.environment,
  ]]);
});

test('failed update commands retain stdout and stderr for the existing API contract', async () => {
  const service = createSystemUpdateService(createDependencies({
    runShellCommand: async () => ({
      exitCode: 1,
      output: 'installing',
      errorOutput: 'npm failed',
    }),
  }));

  assert.deepEqual(await service.updateSystem(), {
    success: false,
    error: 'Update command failed',
    output: 'installing',
    errorOutput: 'npm failed',
  });
});

test('process startup errors retain their message for the existing API contract', async () => {
  const service = createSystemUpdateService(createDependencies({
    runShellCommand: async () => {
      throw new Error('spawn sh failed');
    },
  }));

  assert.deepEqual(await service.updateSystem(), {
    success: false,
    error: 'spawn sh failed',
  });
});

test('latest release attaches the stored GitHub token and normalizes fields', async () => {
  const requests: { url: unknown; init?: RequestInit }[] = [];
  const originalFetch = globalThis.fetch;
  globalThis.fetch = async (url, init) => {
    requests.push({ url, init });
    return new Response(JSON.stringify({
      tag_name: 'v0.5.1',
      name: 'v0.5.1',
      body: 'notes',
      html_url: 'https://example.test/release',
      published_at: '2026-01-01T00:00:00Z',
    }), { status: 200 });
  };
  try {
    const service = createSystemUpdateService(createDependencies({
      githubTokens: { getActiveGithubToken: () => 'secret-token' },
    }));

    const { release } = await service.getLatestRelease(7);

    assert.equal(release?.tagName, 'v0.5.1');
    assert.equal(release?.htmlUrl, 'https://example.test/release');
    const headers = requests[0].init?.headers as Record<string, string>;
    assert.equal(headers.Authorization, 'Bearer secret-token');
  } finally {
    globalThis.fetch = originalFetch;
  }
});

test('latest release is null when GitHub answers 404 (private repo, no token)', async () => {
  const originalFetch = globalThis.fetch;
  globalThis.fetch = async () => new Response('{}', { status: 404 });
  try {
    const service = createSystemUpdateService(createDependencies());

    assert.deepEqual(await service.getLatestRelease(0), { release: null });
  } finally {
    globalThis.fetch = originalFetch;
  }
});
