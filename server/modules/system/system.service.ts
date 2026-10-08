import crypto from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';
import { Readable } from 'node:stream';
import { pipeline } from 'node:stream/promises';
import zlib from 'node:zlib';

type SystemUpdateCommandResult = {
  exitCode: number | null;
  output: string;
  errorOutput: string;
};

type SystemUpdateDependencies = {
  appRoot: string;
  homeDirectory: string;
  installMode: 'git' | 'npm' | 'bundle';
  isPlatform: boolean;
  environment: NodeJS.ProcessEnv;
  githubTokens: {
    getActiveGithubToken(userId: number): string | null;
  };
  runShellCommand(
    command: string,
    workingDirectory: string,
    environment: NodeJS.ProcessEnv,
    onOutput: (output: string) => void,
    onErrorOutput: (errorOutput: string) => void,
  ): Promise<SystemUpdateCommandResult>;
  logInfo(message: string, detail?: string): void;
  logError(message: string, detail?: string): void;
  /** Host platform/arch — picks the release tarball (defaults: this process). */
  platform?: NodeJS.Platform;
  arch?: string;
  /**
   * A launcher or service manager restarts the process when it exits with
   * [RESTART_EXIT_CODE] — systemd (INVOCATION_ID) or the bundled start
   * script (DDAGENT_SUPERVISED). Without one an update needs a manual restart.
   */
  isSupervised?: boolean;
  /** Version of the running code; an update to the same version is a no-op. */
  currentVersion?: string | null;
  /**
   * Directory this installation serves the web client from (the
   * scripts/serve-flutter-web.cjs host), or null when it hosts none.
   */
  webDirectory?: string | null;
  /** `process.versions.modules` of the running Node.js (injectable for tests). */
  nodeModulesVersion?: string;
  /** Streams a URL to a file; injectable for tests. */
  downloadFile?(url: string, destination: string, headers: Record<string, string>): Promise<void>;
};

/**
 * Exit code that asks the supervising launcher to start the server again
 * (EX_TEMPFAIL). Non-zero on purpose: systemd units with
 * `Restart=on-failure` restart on it too.
 */
export const RESTART_EXIT_CODE = 75;

/** What `POST /api/system/update` would do on this installation. */
type ServerUpdateMethod = 'git-branch' | 'git-tag' | 'bundle' | 'platform';

/**
 * Build artifacts the deployment launcher restores from the patch mirror on
 * every start. `source` is relative to the app root; `mirrorName` is the file
 * name inside the mirror directory. Only files the launcher actually reads
 * belong here — the legacy `dist/` client bundle is gone (the Flutter client is
 * served separately), and mirroring it made every git update fail once the
 * directory disappeared.
 */
const MIRRORED_PROVIDER_FILES = [
  {
    source: 'dist-server/server/modules/providers/list/claude/claude-runtime.provider.js',
    mirrorName: 'claude-runtime.provider.js',
  },
  {
    source: 'dist-server/server/modules/providers/list/devin/devin-sessions.provider.js',
    mirrorName: 'devin-sessions.provider.js',
  },
] as const;

/**
 * Creates the update workflow used by the system module and its focused tests.
 * Runtime-specific process spawning stays behind the injected command adapter.
 */
export function createSystemUpdateService(dependencies: SystemUpdateDependencies) {
  // The launcher on this deployment restores a patch mirror over dist/ on every
  // start, so after a git update the mirror must be synced or the next restart
  // reverts the client. `DDAGENT_PATCH_DIR` overrides the conventional
  // `<repo>/.ddagent-patch` sibling location.
  const patchMirrorDirectory = dependencies.environment.DDAGENT_PATCH_DIR
    ?? path.join(dependencies.appRoot, '..', '.ddagent-patch');

  return {
    /** Selects and executes the correct update workflow for this installation. */
    async updateSystem(userId = 0) {
      const method = resolveServerUpdateMethod(dependencies);
      if (method === null) {
        return {
          success: false as const,
          error: 'This server was installed in a way that cannot update itself — reinstall it with install.sh or a release tarball.',
        };
      }
      if (method === 'bundle') {
        return updateBundle(dependencies, userId);
      }

      let updateCommand: string;
      if (method === 'platform') {
        updateCommand = 'npm run update:platform';
      } else if (method === 'git-tag') {
        // install.sh checks out a release tag (detached HEAD), where `git pull`
        // has nothing to follow — move to the newest release tag instead.
        const release = toRelease(dependencies, await githubApi(dependencies, userId, '/releases/latest'));
        if (!release) {
          return { success: false as const, error: 'Could not look up the latest release on GitHub.' };
        }
        const tag = release.tagName;
        if (!/^v?[0-9A-Za-z.+-]+$/.test(tag)) {
          return { success: false as const, error: `Unexpected release tag: ${tag}` };
        }
        updateCommand = `git fetch --depth 1 --force origin tag ${tag} && git checkout --detach --force ${tag}`
          + ' && npm ci && npm run build && npm prune --omit=dev';
      } else {
        // `git pull` follows the checked-out branch's upstream — hardcoding
        // `main` breaks forks whose default branch has another name.
        updateCommand = 'git pull && npm install && npm run build';
      }
      const workingDirectory = dependencies.appRoot;

      dependencies.logInfo('Starting system update from directory:', workingDirectory);

      const runOptions = [
        workingDirectory,
        dependencies.environment,
        (output: string) => dependencies.logInfo('Update output:', output),
        (errorOutput: string) => dependencies.logError('Update error:', errorOutput),
      ] as const;

      try {
        const result = await dependencies.runShellCommand(updateCommand, ...runOptions);

        if (result.exitCode !== 0) {
          return {
            success: false as const,
            error: 'Update command failed',
            output: result.output,
            errorOutput: result.errorOutput,
          };
        }

        if (dependencies.installMode === 'git' && fs.existsSync(patchMirrorDirectory)) {
          // Copy sources only when they exist — the same guard the launcher
          // applies when it restores them, so a missing artifact cannot fail
          // an otherwise successful update.
          const syncCommand = MIRRORED_PROVIDER_FILES
            .filter(({ source }) => fs.existsSync(path.join(dependencies.appRoot, source)))
            .map(({ source, mirrorName }) =>
              `cp "${source}" "${path.join(patchMirrorDirectory, mirrorName)}"`)
            .join(' && ');
          if (syncCommand) {
            const sync = await dependencies.runShellCommand(syncCommand, ...runOptions);
            if (sync.exitCode !== 0) {
              return {
                success: false as const,
                error: 'Patch mirror sync failed',
                output: sync.output,
                errorOutput: sync.errorOutput,
              };
            }
          }
        }

        // Keep a web client hosted by this installation on the same release.
        // Its failure must not hide the successful server update.
        const web = dependencies.webDirectory
          ? await updateWebClient(dependencies, userId)
          : null;

        return {
          success: true as const,
          output: result.output || 'Update completed successfully',
          message: 'Update completed. Please restart the server to apply changes.',
          ...(web && !web.success ? { webError: web.error } : {}),
        };
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        dependencies.logError('Update process error:', message);
        return {
          success: false as const,
          error: message,
        };
      }
    },

    /** Updates only the web client this installation hosts. */
    async updateWebClient(userId = 0) {
      return updateWebClient(dependencies, userId);
    },

    /**
     * What this installation can update from the UI: the server (and how),
     * whether a restart happens on its own, and the hosted web client.
     */
    getUpdateInfo() {
      const method = resolveServerUpdateMethod(dependencies);
      return {
        installMode: dependencies.installMode,
        server: {
          canUpdate: method !== null,
          method,
          supervised: Boolean(dependencies.isSupervised),
        },
        web: {
          hosted: Boolean(dependencies.webDirectory),
          version: dependencies.webDirectory ? readWebClientVersion(dependencies.webDirectory) : null,
        },
      };
    },

    /**
     * Newest GitHub release for the update channel. Goes through the server so
     * the user's stored GitHub token can be attached — the releases API returns
     * 404 on private repos for anonymous callers, which is why the frontend
     * cannot check directly.
     */
    async getLatestRelease(userId: number) {
      const data = await githubApi(dependencies, userId, '/releases/latest');
      const release = toRelease(dependencies, data);
      return { release };
    },

    /** Recent releases for the Settings changelog, newest first. */
    async listReleases(userId: number, limit = 10) {
      const data = await githubApi(dependencies, userId, `/releases?per_page=${limit}`);
      const releases = Array.isArray(data)
        ? data
            .map((entry) => toRelease(dependencies, entry))
            .filter((entry): entry is NonNullable<typeof entry> => entry !== null)
        : [];
      return { releases };
    },
  };
}

type GitHubReleasePayload = {
  tag_name?: string;
  name?: string;
  body?: string;
  html_url?: string;
  published_at?: string;
  assets?: GitHubReleaseAssetPayload[];
};

/** One release asset as returned by the GitHub releases API. */
type GitHubReleaseAssetPayload = {
  name?: string;
  browser_download_url?: string;
  size?: number;
};

/**
 * Release asset exposed to clients. The Android client matches `name` against
 * its build flavor to find the APK it can install; `downloadUrl` is the direct
 * GitHub asset URL.
 */
type GitHubReleaseAsset = {
  name: string;
  downloadUrl: string;
  size: number | null;
};

/** Normalizes the assets array, dropping entries without a name or URL. */
function toReleaseAssets(assets: GitHubReleaseAssetPayload[] | undefined): GitHubReleaseAsset[] {
  if (!Array.isArray(assets)) {
    return [];
  }
  const mapped: GitHubReleaseAsset[] = [];
  for (const asset of assets) {
    const name = typeof asset?.name === 'string' ? asset.name : '';
    const downloadUrl = typeof asset?.browser_download_url === 'string' ? asset.browser_download_url : '';
    if (!name || !downloadUrl) {
      continue;
    }
    mapped.push({ name, downloadUrl, size: typeof asset.size === 'number' ? asset.size : null });
  }
  return mapped;
}

/**
 * Authenticated GitHub releases API call for the update channel repo. Returns
 * null on any failure so release UI degrades to "no data" instead of an error.
 */
async function githubApi(
  dependencies: SystemUpdateDependencies,
  userId: number,
  path: string,
): Promise<unknown> {
  const repo = dependencies.environment.DDAGENT_RELEASES_REPO || 'Zakwei/ddagent';
  const token = dependencies.githubTokens.getActiveGithubToken(userId);
  try {
    const response = await fetch(`https://api.github.com/repos/${repo}${path}`, {
      headers: {
        Accept: 'application/vnd.github+json',
        'User-Agent': 'ddagent-update-check',
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
      },
    });
    return response.ok ? await response.json() : null;
  } catch (error) {
    dependencies.logError('GitHub release check failed:', error instanceof Error ? error.message : String(error));
    return null;
  }
}

/** Normalizes one GitHub release payload; null when it carries no tag. */
function toRelease(dependencies: SystemUpdateDependencies, data: unknown) {
  const release = data as GitHubReleasePayload | null;
  if (!release?.tag_name) {
    return null;
  }
  const repo = dependencies.environment.DDAGENT_RELEASES_REPO || 'Zakwei/ddagent';
  return {
    tagName: release.tag_name,
    name: release.name || release.tag_name,
    body: release.body || '',
    htmlUrl: release.html_url || `https://github.com/${repo}/releases/latest`,
    publishedAt: release.published_at,
    assets: toReleaseAssets(release.assets),
  };
}

/**
 * Picks how this installation updates itself, or null when it can't:
 * a git checkout follows its branch or, on a detached release tag
 * (install.sh), moves to the newest tag; release tarballs download the next
 * tarball; a checkout without git metadata has nothing to update from.
 */
function resolveServerUpdateMethod(dependencies: SystemUpdateDependencies): ServerUpdateMethod | null {
  if (dependencies.installMode === 'bundle') return 'bundle';
  if (dependencies.isPlatform && dependencies.installMode !== 'git') return 'platform';
  if (dependencies.installMode !== 'git') return null;
  try {
    const head = fs.readFileSync(path.join(dependencies.appRoot, '.git', 'HEAD'), 'utf8');
    return head.startsWith('ref:') ? 'git-branch' : 'git-tag';
  } catch {
    return 'git-branch';
  }
}

/** Release tarball platform key, as scripts/release/build-server-bundle.js names it. */
function bundlePlatformKey(dependencies: SystemUpdateDependencies): string {
  const platform = dependencies.platform ?? process.platform;
  const arch = (dependencies.arch ?? process.arch) === 'arm64' ? 'arm64' : 'x64';
  const os = platform === 'darwin' ? 'mac' : platform === 'win32' ? 'win' : 'linux';
  return `${os}-${arch}`;
}

function compareVersions(a: string, b: string): number {
  const parse = (value: string) => value.replace(/^v/, '').split(/[.+-]/).slice(0, 3).map((part) => Number(part) || 0);
  const [left, right] = [parse(a), parse(b)];
  for (let index = 0; index < 3; index += 1) {
    if (left[index] !== right[index]) return (left[index] ?? 0) - (right[index] ?? 0);
  }
  return 0;
}

async function defaultDownloadFile(url: string, destination: string, headers: Record<string, string>) {
  const response = await fetch(url, { headers, redirect: 'follow' });
  if (!response.ok || !response.body) {
    throw new Error(`Download failed (HTTP ${response.status}): ${url}`);
  }
  await pipeline(Readable.fromWeb(response.body as never), fs.createWriteStream(destination));
}

function downloadHeaders(dependencies: SystemUpdateDependencies, userId: number): Record<string, string> {
  const token = dependencies.githubTokens.getActiveGithubToken(userId);
  return {
    'User-Agent': 'ddagent-updater',
    ...(token ? { Authorization: `Bearer ${token}` } : {}),
  };
}

/**
 * Release-tarball update: downloads this platform's tarball for the newest
 * release, checks it against its `.sha256`, and unpacks it into `.update/next`
 * next to the running install. Nothing running is touched — the bundled
 * launcher applies it (scripts/apply-update.cjs) before the next start, when
 * no file is locked by the live process (Windows can't replace loaded
 * native modules).
 */
async function updateBundle(dependencies: SystemUpdateDependencies, userId: number) {
  const release = toRelease(dependencies, await githubApi(dependencies, userId, '/releases/latest'));
  if (!release) {
    return { success: false as const, error: 'Could not look up the latest release on GitHub.' };
  }
  const version = release.tagName.replace(/^v/, '');
  if (dependencies.currentVersion && compareVersions(version, dependencies.currentVersion) <= 0) {
    return { success: true as const, upToDate: true, message: `Already on the latest release (v${version}).` };
  }
  const assetName = `ddagent-server-${version}-${bundlePlatformKey(dependencies)}.tar.gz`;
  const asset = release.assets.find((entry) => entry.name === assetName);
  const checksum = release.assets.find((entry) => entry.name === `${assetName}.sha256`);
  if (!asset) {
    return { success: false as const, error: `Release v${version} has no ${assetName}.` };
  }

  const download = dependencies.downloadFile ?? defaultDownloadFile;
  const headers = downloadHeaders(dependencies, userId);
  const updateDirectory = path.join(dependencies.appRoot, '.update');
  const nextDirectory = path.join(updateDirectory, 'next');
  const archive = path.join(updateDirectory, assetName);
  try {
    fs.rmSync(updateDirectory, { recursive: true, force: true });
    fs.mkdirSync(nextDirectory, { recursive: true });
    dependencies.logInfo('Downloading server update:', asset.downloadUrl);
    await download(asset.downloadUrl, archive, headers);
    if (checksum) {
      const checksumFile = `${archive}.sha256`;
      await download(checksum.downloadUrl, checksumFile, headers);
      const expected = fs.readFileSync(checksumFile, 'utf8').trim().split(/\s+/)[0]?.toLowerCase();
      const actual = crypto.createHash('sha256').update(fs.readFileSync(archive)).digest('hex');
      if (!expected || expected !== actual) {
        throw new Error(`Checksum mismatch for ${assetName}.`);
      }
    }
    const extract = await dependencies.runShellCommand(
      `tar -xzf "${archive}" -C "${nextDirectory}"`,
      updateDirectory,
      dependencies.environment,
      (output) => dependencies.logInfo('Update output:', output),
      (errorOutput) => dependencies.logError('Update error:', errorOutput),
    );
    if (extract.exitCode !== 0) {
      throw new Error(`Could not unpack ${assetName}: ${extract.errorOutput || extract.output}`);
    }
    if (!fs.existsSync(path.join(nextDirectory, 'dist-server', 'server', 'index.js'))) {
      throw new Error(`${assetName} does not contain a ddagent server.`);
    }
    assertSameNodeAbi(nextDirectory, version, dependencies.nodeModulesVersion ?? process.versions.modules);
    fs.rmSync(archive, { force: true });
    fs.writeFileSync(path.join(updateDirectory, 'ready'), `${version}\n`);
  } catch (error) {
    fs.rmSync(updateDirectory, { recursive: true, force: true });
    const message = error instanceof Error ? error.message : String(error);
    dependencies.logError('Server update failed:', message);
    return { success: false as const, error: message };
  }

  const web = dependencies.webDirectory ? await updateWebClient(dependencies, userId) : null;
  return {
    success: true as const,
    staged: true,
    message: `Update v${version} downloaded — it is applied when the server restarts.`,
    ...(web && !web.success ? { webError: web.error } : {}),
  };
}

// Node.js ABI release tarballs were built for before `.installed.json`
// recorded it: CI builds them on Node.js 22.
const LEGACY_BUNDLE_NODE_MODULES = '127';

/**
 * Refuses a release tarball whose native modules were built for another
 * Node.js ABI than the one running this server — installing it would leave a
 * server that cannot start (better-sqlite3 fails to load).
 */
function assertSameNodeAbi(bundleDirectory: string, version: string, runningAbi: string): void {
  let bundleAbi = LEGACY_BUNDLE_NODE_MODULES;
  let bundleNode = '22';
  try {
    const meta = JSON.parse(fs.readFileSync(path.join(bundleDirectory, '.installed.json'), 'utf8')) as {
      node?: unknown;
      nodeModules?: unknown;
    };
    if (typeof meta.nodeModules === 'string') bundleAbi = meta.nodeModules;
    if (typeof meta.node === 'string') bundleNode = meta.node.split('.')[0] ?? bundleNode;
  } catch {
    // No metadata — a legacy tarball, built on Node.js 22.
  }
  if (bundleAbi !== runningAbi) {
    throw new Error(
      `Release v${version} is built for Node.js ${bundleNode}, but this server runs Node.js `
        + `${process.versions.node.split('.')[0]}. Switch the server to Node.js ${bundleNode} and update again, `
        + 'or reinstall it with install.sh, which builds for the installed Node.js.',
    );
  }
}

/**
 * Replaces the hosted web client with the newest release's web zip: unpacks
 * into a sibling directory, then swaps it in with two renames so the host
 * (which reads files per request) never serves a half-written build.
 */
async function updateWebClient(dependencies: SystemUpdateDependencies, userId: number) {
  const webDirectory = dependencies.webDirectory;
  if (!webDirectory) {
    return { success: false as const, error: 'This server does not host the web client.' };
  }
  const release = toRelease(dependencies, await githubApi(dependencies, userId, '/releases/latest'));
  if (!release) {
    return { success: false as const, error: 'Could not look up the latest release on GitHub.' };
  }
  const assetName = `ddagent-flutter-web-${release.tagName}.zip`;
  const asset = release.assets.find((entry) => entry.name === assetName);
  if (!asset) {
    return { success: false as const, error: `Release ${release.tagName} has no ${assetName}.` };
  }
  const download = dependencies.downloadFile ?? defaultDownloadFile;
  const archive = `${webDirectory}.download.zip`;
  const nextDirectory = `${webDirectory}.next`;
  const previousDirectory = `${webDirectory}.previous`;
  try {
    fs.rmSync(nextDirectory, { recursive: true, force: true });
    fs.rmSync(previousDirectory, { recursive: true, force: true });
    await download(asset.downloadUrl, archive, downloadHeaders(dependencies, userId));
    extractZip(archive, nextDirectory);
    if (!fs.existsSync(path.join(nextDirectory, 'index.html'))) {
      throw new Error(`${assetName} does not contain a web client.`);
    }
    if (fs.existsSync(webDirectory)) fs.renameSync(webDirectory, previousDirectory);
    fs.renameSync(nextDirectory, webDirectory);
    fs.rmSync(previousDirectory, { recursive: true, force: true });
    return { success: true as const, version: release.tagName.replace(/^v/, '') };
  } catch (error) {
    // Put the old build back if the swap got halfway.
    if (!fs.existsSync(webDirectory) && fs.existsSync(previousDirectory)) {
      fs.renameSync(previousDirectory, webDirectory);
    }
    fs.rmSync(nextDirectory, { recursive: true, force: true });
    const message = error instanceof Error ? error.message : String(error);
    dependencies.logError('Web client update failed:', message);
    return { success: false as const, error: message };
  } finally {
    fs.rmSync(archive, { force: true });
  }
}

/** Version from the Flutter web build's `version.json`, or null. */
function readWebClientVersion(webDirectory: string): string | null {
  try {
    const data = JSON.parse(fs.readFileSync(path.join(webDirectory, 'version.json'), 'utf8')) as { version?: unknown };
    return typeof data.version === 'string' ? data.version : null;
  } catch {
    return null;
  }
}

/**
 * Minimal ZIP reader for the release web zip (stored or deflated entries, no
 * ZIP64) — GNU tar can't read zips and `unzip` isn't on every host. Rejects
 * entries that would land outside [destination].
 */
export function extractZip(archive: string, destination: string): void {
  const data = fs.readFileSync(archive);
  let end = data.length - 22;
  while (end >= 0 && data.readUInt32LE(end) !== 0x06054b50) end -= 1;
  if (end < 0) throw new Error('Not a zip archive.');
  const entries = data.readUInt16LE(end + 10);
  let offset = data.readUInt32LE(end + 16);
  const root = path.resolve(destination);
  fs.mkdirSync(root, { recursive: true });
  for (let index = 0; index < entries; index += 1) {
    if (data.readUInt32LE(offset) !== 0x02014b50) throw new Error('Corrupt zip central directory.');
    const method = data.readUInt16LE(offset + 10);
    const compressedSize = data.readUInt32LE(offset + 20);
    const nameLength = data.readUInt16LE(offset + 28);
    const extraLength = data.readUInt16LE(offset + 30);
    const commentLength = data.readUInt16LE(offset + 32);
    const localHeader = data.readUInt32LE(offset + 42);
    const name = data.toString('utf8', offset + 46, offset + 46 + nameLength);
    offset += 46 + nameLength + extraLength + commentLength;

    const target = path.resolve(root, name);
    if (target !== root && !target.startsWith(root + path.sep)) {
      throw new Error(`Zip entry escapes the target directory: ${name}`);
    }
    if (name.endsWith('/')) {
      fs.mkdirSync(target, { recursive: true });
      continue;
    }
    const start = localHeader + 30 + data.readUInt16LE(localHeader + 26) + data.readUInt16LE(localHeader + 28);
    const raw = data.subarray(start, start + compressedSize);
    const content = method === 0 ? raw : method === 8 ? zlib.inflateRawSync(raw) : null;
    if (!content) throw new Error(`Unsupported zip compression method ${method} for ${name}.`);
    fs.mkdirSync(path.dirname(target), { recursive: true });
    fs.writeFileSync(target, content);
  }
}
