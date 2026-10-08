import assert from 'node:assert/strict';
import crypto from 'node:crypto';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { createSystemUpdateService, extractZip } from '../system.service.js';

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

test('git updates sync the launcher patch mirror for the provider overrides', async () => {
  const appRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-app-'));
  const patchDir = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-patch-'));
  try {
    for (const source of [
      'dist-server/server/modules/providers/list/claude/claude-runtime.provider.js',
      'dist-server/server/modules/providers/list/devin/devin-sessions.provider.js',
    ]) {
      fs.mkdirSync(path.dirname(path.join(appRoot, source)), { recursive: true });
      fs.writeFileSync(path.join(appRoot, source), '// built provider');
    }
    const calls: unknown[][] = [];
    const dependencies = createDependencies({
      appRoot,
      environment: { DDAGENT_PATCH_DIR: patchDir },
      runShellCommand: async (command, workingDirectory) => {
        calls.push([command, workingDirectory]);
        return { exitCode: 0, output: '', errorOutput: '' };
      },
    });
    const service = createSystemUpdateService(dependencies);

    const result = await service.updateSystem();

    assert.equal(calls.length, 2);
    const syncCommand = String(calls[1][0]);
    assert.match(syncCommand, /claude-runtime\.provider\.js/);
    assert.match(syncCommand, /devin-sessions\.provider\.js/);
    // The removed React client bundle must never be mirrored again.
    assert.doesNotMatch(syncCommand, /dist\/\./);
    assert.equal(result.success, true);
  } finally {
    fs.rmSync(appRoot, { recursive: true, force: true });
    fs.rmSync(patchDir, { recursive: true, force: true });
  }
});

test('git updates skip the patch mirror when no provider artifact was built', async () => {
  const appRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-app-'));
  const patchDir = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-patch-'));
  try {
    const calls: unknown[][] = [];
    const dependencies = createDependencies({
      appRoot,
      environment: { DDAGENT_PATCH_DIR: patchDir },
      runShellCommand: async (command, workingDirectory) => {
        calls.push([command, workingDirectory]);
        return { exitCode: 0, output: '', errorOutput: '' };
      },
    });
    const service = createSystemUpdateService(dependencies);

    const result = await service.updateSystem();

    assert.equal(calls.length, 1);
    assert.equal(result.success, true);
  } finally {
    fs.rmSync(appRoot, { recursive: true, force: true });
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

test('a checkout without git metadata reports it cannot update itself', async () => {
  const calls: unknown[] = [];
  const service = createSystemUpdateService(createDependencies({
    installMode: 'npm',
    runShellCommand: async (command) => {
      calls.push(command);
      return { exitCode: 0, output: '', errorOutput: '' };
    },
  }));

  const result = await service.updateSystem();

  assert.equal(result.success, false);
  assert.match((result as { error: string }).error, /cannot update itself/);
  assert.equal(calls.length, 0);
  assert.equal(service.getUpdateInfo().server.canUpdate, false);
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
      assets: [
        {
          name: 'ddagent-flutter-android-v0.5.1.apk',
          browser_download_url: 'https://example.test/android.apk',
          size: 1234,
        },
        // Dropped: no download URL.
        { name: 'ddagent-server-linux.tar.gz' },
      ],
    }), { status: 200 });
  };
  try {
    const service = createSystemUpdateService(createDependencies({
      githubTokens: { getActiveGithubToken: () => 'secret-token' },
    }));

    const { release } = await service.getLatestRelease(7);

    assert.equal(release?.tagName, 'v0.5.1');
    assert.equal(release?.htmlUrl, 'https://example.test/release');
    assert.deepEqual(release?.assets, [{
      name: 'ddagent-flutter-android-v0.5.1.apk',
      downloadUrl: 'https://example.test/android.apk',
      size: 1234,
    }]);
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

test('listReleases normalizes the GitHub release list', async () => {
  const originalFetch = globalThis.fetch;
  globalThis.fetch = async () => new Response(JSON.stringify([
    { tag_name: 'v0.5.3', name: 'v0.5.3', body: 'notes', html_url: 'https://example.test/3', published_at: '2026-01-02T00:00:00Z' },
    { tag_name: 'v0.5.2', name: null, body: null, html_url: null, published_at: null },
    { name: 'no-tag-entry' },
  ]), { status: 200 });
  try {
    const service = createSystemUpdateService(createDependencies());

    const { releases } = await service.listReleases(1);

    assert.equal(releases.length, 2);
    assert.equal(releases[0].tagName, 'v0.5.3');
    assert.equal(releases[0].body, 'notes');
    assert.equal(releases[1].name, 'v0.5.2'); // name falls back to the tag
    assert.equal(releases[1].body, '');
  } finally {
    globalThis.fetch = originalFetch;
  }
});

// --- install.sh checkouts, release tarballs and the hosted web client -------

function releaseFetch(assets: { name: string }[], tag = 'v9.9.9'): typeof fetch {
  return (async () => new Response(JSON.stringify({
    tag_name: tag,
    assets: assets.map((asset) => ({ ...asset, browser_download_url: `https://dl/${asset.name}` })),
  }), { status: 200 })) as typeof fetch;
}

async function withFetch<T>(fake: typeof fetch, run: () => Promise<T>): Promise<T> {
  const original = globalThis.fetch;
  globalThis.fetch = fake;
  try {
    return await run();
  } finally {
    globalThis.fetch = original;
  }
}

/** Stored-entry zip (no compression) — enough for the extractor under test. */
function storedZip(files: Record<string, string>): Buffer {
  const locals: Buffer[] = [];
  const centrals: Buffer[] = [];
  let offset = 0;
  for (const [name, text] of Object.entries(files)) {
    const nameBytes = Buffer.from(name);
    const body = Buffer.from(text);
    const local = Buffer.alloc(30);
    local.writeUInt32LE(0x04034b50, 0);
    local.writeUInt32LE(body.length, 18);
    local.writeUInt32LE(body.length, 22);
    local.writeUInt16LE(nameBytes.length, 26);
    const central = Buffer.alloc(46);
    central.writeUInt32LE(0x02014b50, 0);
    central.writeUInt32LE(body.length, 20);
    central.writeUInt32LE(body.length, 24);
    central.writeUInt16LE(nameBytes.length, 28);
    central.writeUInt32LE(offset, 42);
    locals.push(local, nameBytes, body);
    centrals.push(central, nameBytes);
    offset += 30 + nameBytes.length + body.length;
  }
  const directory = Buffer.concat(centrals);
  const end = Buffer.alloc(22);
  end.writeUInt32LE(0x06054b50, 0);
  end.writeUInt16LE(Object.keys(files).length, 8);
  end.writeUInt16LE(Object.keys(files).length, 10);
  end.writeUInt32LE(directory.length, 12);
  end.writeUInt32LE(offset, 16);
  return Buffer.concat([...locals, directory, end]);
}

test('install.sh checkouts (detached release tag) move to the newest release tag', async () => {
  const appRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-tag-'));
  try {
    fs.mkdirSync(path.join(appRoot, '.git'));
    fs.writeFileSync(path.join(appRoot, '.git', 'HEAD'), '27ce0671482caea65b6011421f384389e75f4133\n');
    const commands: string[] = [];
    const service = createSystemUpdateService(createDependencies({
      appRoot,
      runShellCommand: async (command) => {
        commands.push(command);
        return { exitCode: 0, output: '', errorOutput: '' };
      },
    }));

    assert.equal(service.getUpdateInfo().server.method, 'git-tag');
    const result = await withFetch(releaseFetch([]), () => service.updateSystem());

    assert.equal(result.success, true);
    assert.deepEqual(commands, [
      'git fetch --depth 1 --force origin tag v9.9.9 && git checkout --detach --force v9.9.9'
        + ' && npm ci && npm run build && npm prune --omit=dev',
    ]);
  } finally {
    fs.rmSync(appRoot, { recursive: true, force: true });
  }
});

test('release tarballs stage the verified next release for the launcher to apply', async () => {
  const appRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-bundle-'));
  try {
    const tarball = 'ddagent-server-9.9.9-linux-x64.tar.gz';
    const payload = Buffer.from('tarball bytes');
    const digest = crypto.createHash('sha256').update(payload).digest('hex');
    const service = createSystemUpdateService(createDependencies({
      appRoot,
      installMode: 'bundle',
      platform: 'linux',
      arch: 'x64',
      currentVersion: '0.8.12',
      nodeModulesVersion: '127',
      downloadFile: async (url, destination) => {
        fs.writeFileSync(destination, url.endsWith('.sha256') ? `${digest}  ${tarball}\n` : payload);
      },
      // Stand-in for `tar -xzf`: lay out what a release tarball contains.
      runShellCommand: async (command) => {
        const target = /-C "([^"]+)"/.exec(command)![1]!;
        fs.mkdirSync(path.join(target, 'dist-server', 'server'), { recursive: true });
        fs.writeFileSync(path.join(target, 'dist-server', 'server', 'index.js'), '// next');
        return { exitCode: 0, output: '', errorOutput: '' };
      },
    }));

    const result = await withFetch(
      releaseFetch([{ name: tarball }, { name: `${tarball}.sha256` }]),
      () => service.updateSystem(),
    );

    assert.equal(result.success, true);
    assert.equal(fs.readFileSync(path.join(appRoot, '.update', 'ready'), 'utf8').trim(), '9.9.9');
    assert.ok(fs.existsSync(path.join(appRoot, '.update', 'next', 'dist-server', 'server', 'index.js')));
    assert.equal(fs.existsSync(path.join(appRoot, '.update', tarball)), false);
  } finally {
    fs.rmSync(appRoot, { recursive: true, force: true });
  }
});

test('release tarballs reject a download whose checksum does not match', async () => {
  const appRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-bundle-'));
  try {
    const tarball = 'ddagent-server-9.9.9-win-x64.tar.gz';
    const service = createSystemUpdateService(createDependencies({
      appRoot,
      installMode: 'bundle',
      platform: 'win32',
      arch: 'x64',
      downloadFile: async (url, destination) => {
        fs.writeFileSync(destination, url.endsWith('.sha256') ? `${'0'.repeat(64)}  ${tarball}` : 'tampered');
      },
    }));

    const result = await withFetch(
      releaseFetch([{ name: tarball }, { name: `${tarball}.sha256` }]),
      () => service.updateSystem(),
    );

    assert.equal(result.success, false);
    assert.match((result as { error: string }).error, /Checksum mismatch/);
    assert.equal(fs.existsSync(path.join(appRoot, '.update')), false);
  } finally {
    fs.rmSync(appRoot, { recursive: true, force: true });
  }
});

test('a tarball already on the latest release has nothing to update', async () => {
  const service = createSystemUpdateService(createDependencies({
    installMode: 'bundle',
    currentVersion: '9.9.9',
  }));
  const result = await withFetch(releaseFetch([]), () => service.updateSystem());
  assert.equal(result.success, true);
  assert.equal((result as { upToDate?: boolean }).upToDate, true);
});

test('the hosted web client is swapped for the release web zip', async () => {
  const parent = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-web-'));
  const webDirectory = path.join(parent, 'web');
  try {
    fs.mkdirSync(webDirectory);
    fs.writeFileSync(path.join(webDirectory, 'index.html'), 'old');
    fs.writeFileSync(path.join(webDirectory, 'version.json'), '{"version":"0.8.12"}');
    const service = createSystemUpdateService(createDependencies({
      webDirectory,
      downloadFile: async (_url, destination) => {
        fs.writeFileSync(destination, storedZip({
          'index.html': 'new',
          'version.json': '{"version":"9.9.9"}',
          'assets/app.js': 'js',
        }));
      },
    }));

    assert.deepEqual(service.getUpdateInfo().web, { hosted: true, version: '0.8.12' });
    const result = await withFetch(
      releaseFetch([{ name: 'ddagent-flutter-web-v9.9.9.zip' }]),
      () => service.updateWebClient(),
    );

    assert.equal(result.success, true);
    assert.equal(fs.readFileSync(path.join(webDirectory, 'index.html'), 'utf8'), 'new');
    assert.equal(fs.readFileSync(path.join(webDirectory, 'assets', 'app.js'), 'utf8'), 'js');
    assert.deepEqual(service.getUpdateInfo().web, { hosted: true, version: '9.9.9' });
    assert.deepEqual(fs.readdirSync(parent), ['web']);
  } finally {
    fs.rmSync(parent, { recursive: true, force: true });
  }
});

test('zip entries cannot escape the target directory', () => {
  const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-zip-'));
  try {
    const archive = path.join(directory, 'evil.zip');
    fs.writeFileSync(archive, storedZip({ '../escaped.txt': 'x' }));
    assert.throws(() => extractZip(archive, path.join(directory, 'out')), /escapes/);
    assert.equal(fs.existsSync(path.join(directory, 'escaped.txt')), false);
  } finally {
    fs.rmSync(directory, { recursive: true, force: true });
  }
});

test('a tarball built for another Node.js is refused before it can break the server', async () => {
  const appRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-bundle-'));
  try {
    const tarball = 'ddagent-server-9.9.9-linux-x64.tar.gz';
    const service = createSystemUpdateService(createDependencies({
      appRoot,
      installMode: 'bundle',
      platform: 'linux',
      arch: 'x64',
      nodeModulesVersion: '137', // Node.js 24
      downloadFile: async (_url, destination) => fs.writeFileSync(destination, 'bytes'),
      runShellCommand: async (command) => {
        const target = /-C "([^"]+)"/.exec(command)![1]!;
        fs.mkdirSync(path.join(target, 'dist-server', 'server'), { recursive: true });
        fs.writeFileSync(path.join(target, 'dist-server', 'server', 'index.js'), '// next');
        fs.writeFileSync(path.join(target, '.installed.json'), '{"node":"22.11.0","nodeModules":"127"}');
        return { exitCode: 0, output: '', errorOutput: '' };
      },
    }));

    const result = await withFetch(releaseFetch([{ name: tarball }]), () => service.updateSystem());

    assert.equal(result.success, false);
    assert.match((result as { error: string }).error, /built for Node\.js 22/);
    assert.equal(fs.existsSync(path.join(appRoot, '.update')), false);
  } finally {
    fs.rmSync(appRoot, { recursive: true, force: true });
  }
});
