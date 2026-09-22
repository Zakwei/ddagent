#!/usr/bin/env node
import { readFileSync } from 'node:fs';
import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const rootDir = path.resolve(__dirname, '..', '..');
const stageDir = path.join(rootDir, '.desktop-build', 'desktop-app');

const packageJson = JSON.parse(
  await fs.readFile(path.join(rootDir, 'package.json'), 'utf8'),
);

function getElectronVersion() {
  try {
    return JSON.parse(
      readFileSync(path.join(rootDir, 'node_modules', 'electron', 'package.json'), 'utf8'),
    ).version;
  } catch {
    try {
      return JSON.parse(
        readFileSync(path.join(rootDir, 'package-lock.json'), 'utf8'),
      ).packages['node_modules/electron'].version;
    } catch {
      throw new Error('Could not resolve an exact Electron version for desktop packaging.');
    }
  }
}

async function pathExists(filePath) {
  try {
    await fs.access(filePath);
    return true;
  } catch {
    return false;
  }
}

async function copyRequired(relativePath) {
  const from = path.join(rootDir, relativePath);
  const to = path.join(stageDir, relativePath);
  if (!(await pathExists(from))) {
    throw new Error(`Required desktop build input is missing: ${relativePath}`);
  }
  await fs.cp(from, to, { recursive: true });
}

async function copyIfExists(relativePath) {
  const from = path.join(rootDir, relativePath);
  if (!(await pathExists(from))) return false;
  await fs.cp(from, path.join(stageDir, relativePath), { recursive: true });
  return true;
}

// Every bare specifier the compiled backend (dist-server) can require() or
// import at runtime — verified against `grep -rohE "(from|import|require)
// ..." dist-server`. Each must be declared in the staged package.json:
// electron-builder's module collector only follows entries listed there
// (plus the transitives it can then see inside the staged node_modules).
//
// Deliberately absent:
//   - playwright — browser-use/browser-view require() it inside try/catch and
//     degrade to an "Install Playwright and Chromium" hint when absent. The
//     package alone is useless without its browser binary, which playwright's
//     postinstall downloads outside node_modules, so the feature cannot work
//     packaged either way. Remote browser sessions stay a web-install feature.
//   - sharp — only imported by electron/scripts/generate-macos-icon.js, a
//     build-time icon tool that never runs inside the packaged app.
const SERVER_RUNTIME_DEPENDENCIES = [
  '@anthropic-ai/claude-agent-sdk',
  '@iarna/toml',
  '@octokit/rest',
  '@openai/codex-sdk',
  '@vscode/ripgrep',
  'bcrypt',
  'better-sqlite3',
  'chokidar',
  'cors',
  'cross-spawn',
  'express',
  'firebase-admin',
  'gray-matter',
  'ignore',
  'jsonwebtoken',
  'mime-types',
  'msedge-tts',
  'multer',
  'node-pty',
  'web-push',
  'ws',
];

const repoNodeModules = path.join(rootDir, 'node_modules');

// npm only installs a package when its os/cpu/libc constraints match the
// build host; mirror that so foreign-platform vendored binaries
// (@anthropic-ai/claude-agent-sdk-*, @openai/codex-*, @nut-tree-fork/libnut-*)
// are never staged. libc is linux-only (glibc vs musl); Electron itself only
// ships glibc builds anyway.
const HOST_LIBC = process.platform === 'linux'
  ? (process.report?.getReport?.()?.header?.glibcVersionRuntime ? 'glibc' : 'musl')
  : null;

function matchesHostPlatform(pkg) {
  const { os, cpu, libc } = pkg;
  if (Array.isArray(os) && os.length > 0 && !os.includes(process.platform)) return false;
  if (Array.isArray(cpu) && cpu.length > 0 && !cpu.includes(process.arch)) return false;
  if (HOST_LIBC && Array.isArray(libc) && libc.length > 0 && !libc.includes(HOST_LIBC)) return false;
  return true;
}

async function readPackageJson(packageDir) {
  try {
    return JSON.parse(await fs.readFile(path.join(packageDir, 'package.json'), 'utf8'));
  } catch {
    return null;
  }
}

// Resolves a specifier the way Node does: requiring package's own
// node_modules first, then every ancestor up to the filesystem root. Returns
// the package directory or null when the package is not installed.
async function resolvePackageDir(name, fromDir) {
  let dir = path.resolve(fromDir);
  while (true) {
    const candidate = path.join(dir, 'node_modules', name, 'package.json');
    if (await pathExists(candidate)) return path.dirname(candidate);
    const parent = path.dirname(dir);
    if (parent === dir) return null;
    dir = parent;
  }
}

/**
 * Walks the production dependency graph of `seedNames`: each package's
 * dependencies + optionalDependencies + peerDependencies. Packages that
 * resolve to a top-level dir under repo node_modules must be copied into the
 * stage — packages found nested inside a parent's node_modules ride along
 * with that parent's copy.
 *
 * Returns { modules, peerOnly } where `peerOnly` holds the top-level packages
 * that are reachable ONLY through peer edges. electron-builder's collectors
 * (npm list and manual traversal alike) do not follow peerDependencies, so
 * those have to be declared as direct dependencies in the staged package.json
 * to end up in the package — e.g. claude-agent-sdk's peers
 * @anthropic-ai/sdk, @modelcontextprotocol/sdk and zod.
 */
async function collectRuntimeDependencyClosure(seedNames) {
  const visited = new Map(); // resolved packageDir -> 'hard' | 'peer'
  const topLevel = new Map(); // install name -> { dir, edge }
  const queue = seedNames.map((name) => ({ name, fromDir: rootDir, edge: 'hard' }));

  while (queue.length > 0) {
    const { name, fromDir, edge } = queue.shift();
    const packageDir = await resolvePackageDir(name, fromDir);
    if (!packageDir) continue; // optional dep or peer that is not installed

    const prevEdge = visited.get(packageDir);
    if (prevEdge === 'hard' || (prevEdge === 'peer' && edge === 'peer')) continue;
    visited.set(packageDir, edge);
    if (prevEdge === 'peer') continue; // upgraded to hard; children already queued

    const pkg = await readPackageJson(packageDir);
    if (!pkg || !matchesHostPlatform(pkg)) continue;

    // Top-level when the resolved dir is repo node_modules/<name> itself —
    // dirname() alone misfires on scoped names (@scope/pkg nests one deeper).
    if (path.relative(repoNodeModules, packageDir) === name) {
      const existing = topLevel.get(name);
      topLevel.set(name, { dir: packageDir, edge: existing?.edge === 'hard' ? 'hard' : edge });
    }

    for (const depName of Object.keys(pkg.dependencies || {})) {
      queue.push({ name: depName, fromDir: packageDir, edge: 'hard' });
    }
    for (const depName of Object.keys(pkg.optionalDependencies || {})) {
      queue.push({ name: depName, fromDir: packageDir, edge: 'hard' });
    }
    for (const depName of Object.keys(pkg.peerDependencies || {})) {
      queue.push({ name: depName, fromDir: packageDir, edge: 'peer' });
    }
  }

  const peerOnly = [...topLevel.entries()]
    .filter(([, info]) => info.edge === 'peer')
    .map(([name]) => name);
  return { modules: topLevel, peerOnly };
}

async function copyNodeModule(packageName) {
  const parts = packageName.split('/');
  const source = path.join(rootDir, 'node_modules', ...parts);
  if (!(await pathExists(source))) return false;

  const target = path.join(stageDir, 'node_modules', ...parts);
  await fs.mkdir(path.dirname(target), { recursive: true });
  await fs.cp(source, target, { recursive: true });
  return true;
}

// Provider SDKs vendor their CLI binaries in per-platform packages
// (~230-460MB each). The closure walk above already stages only host-matching
// variants; these patterns additionally strip foreign variants if they still
// resolve on the build host (e.g. when npm installed both linux-x64 glibc and
// musl). Kept per-platform so mac/win builds stay equally slim.
const FOREIGN_PLATFORM_BINARY_EXCLUDES = {
  linux: [
    '!**/node_modules/@anthropic-ai/claude-agent-sdk-{darwin,win32}-*/**',
    ...(HOST_LIBC === 'glibc'
      ? ['!**/node_modules/@anthropic-ai/claude-agent-sdk-*-musl/**']
      : []),
    '!**/node_modules/@openai/codex-{darwin,win32}-*/**',
  ],
  mac: [
    '!**/node_modules/@anthropic-ai/claude-agent-sdk-{linux,win32}-*/**',
    '!**/node_modules/@openai/codex-{linux,win32}-*/**',
  ],
  win: [
    '!**/node_modules/@anthropic-ai/claude-agent-sdk-{darwin,linux}-*/**',
    '!**/node_modules/@openai/codex-{darwin,linux}-*/**',
  ],
};

function withPlatformFiles(platformConfig, patterns) {
  return {
    ...(platformConfig || {}),
    files: [...(platformConfig?.files || []), ...patterns],
  };
}

function buildDesktopPackageJson(copiedOptionalDependencies, peerOnlyDependencies) {
  const dependencies = {};
  // Pin to the same range as the root package.json; '*' for peer-only
  // additions that are not declared there (any installed version is fine —
  // the collector takes what it finds on disk either way).
  for (const name of [...SERVER_RUNTIME_DEPENDENCIES, ...peerOnlyDependencies].sort()) {
    dependencies[name] = packageJson.dependencies?.[name] ?? '*';
  }
  return {
    name: `${packageJson.name}-desktop`,
    version: packageJson.version,
    productName: packageJson.productName,
    // Lets Linux desktop environments associate running windows with the
    // generated .desktop entry (StartupWMClass); paired with
    // linux.syncDesktopName in the build config.
    desktopName: packageJson.productName,
    description: `${packageJson.productName} desktop shell`,
    author: packageJson.author,
    license: packageJson.license,
    // Required by fpm-based Linux targets (deb/rpm) for the package homepage.
    homepage: packageJson.homepage,
    type: 'module',
    main: 'electron/main.js',
    // Native modules (better-sqlite3, node-pty, bcrypt) must stay declared
    // here so @electron/rebuild's module walker (npmRebuild) finds them and
    // rebuilds them for the Electron ABI.
    dependencies,
    optionalDependencies: copiedOptionalDependencies,
    build: {
      appId: packageJson.build.appId,
      productName: packageJson.build.productName,
      asar: packageJson.build.asar,
      artifactName: packageJson.build.artifactName,
      electronVersion: getElectronVersion(),
      // Default is true; pinned explicitly because the native modules' .node
      // binaries must be rebuilt from the host Node ABI to the Electron ABI on
      // every package run — silently skipping this ships broken binaries.
      npmRebuild: true,
      directories: {
        output: '../../release/desktop',
      },
      extraMetadata: {
        main: 'electron/main.js',
      },
      files: [
        'electron/**',
        'public/**',
        'dist/**',
        'dist-server/**',
        'node_modules/**',
        'package.json',
      ],
      protocols: packageJson.build.protocols,
      mac: withPlatformFiles(packageJson.build.mac, FOREIGN_PLATFORM_BINARY_EXCLUDES.mac),
      win: withPlatformFiles(packageJson.build.win, FOREIGN_PLATFORM_BINARY_EXCLUDES.win),
      linux: withPlatformFiles(packageJson.build.linux, FOREIGN_PLATFORM_BINARY_EXCLUDES.linux),
      nsis: packageJson.build.nsis,
    },
  };
}

await fs.rm(stageDir, { recursive: true, force: true });
await fs.mkdir(stageDir, { recursive: true });

await copyRequired('electron');
await copyRequired('dist');
// Compiled backend for the embedded in-process mode: embeddedBackend.js
// resolves <resources>/app/dist-server in the packaged app (appRoot is the
// parent of electron/), which the 'dist-server/**' files entry above ships.
// The compiled output is self-contained — server/tsconfig.json has rootDir
// ".." so repo-root shared/ is emitted into dist-server/shared/ and nothing
// outside dist-server is imported at runtime. Requires a prior
// `npm run build:server` (desktop:pack/desktop:dist:* run `npm run build`).
await copyRequired('dist-server');
await copyRequired('public');

// Stage the server's full runtime dependency closure. The collector npm uses
// to enumerate modules (`npm list` in the stage dir, or the traversal
// fallback) only reports what is physically present here, so every package —
// not just the top-level specifiers — has to land in this node_modules.
// Transitives resolve nested-first then upward into the repo's node_modules,
// matching what npm installed.
const optionalDependencyNames = Object.keys(packageJson.optionalDependencies || {});
const seedNames = [...SERVER_RUNTIME_DEPENDENCIES, ...optionalDependencyNames];
const { modules: runtimeModules, peerOnly } = await collectRuntimeDependencyClosure(seedNames);

const missing = seedNames.filter((name) => !runtimeModules.has(name));
if (missing.length > 0) {
  throw new Error(`Required desktop dependencies are missing from node_modules: ${missing.join(', ')}`);
}

for (const name of runtimeModules.keys()) {
  await copyNodeModule(name);
}

const copiedOptionalDependencies = {};
for (const [name, version] of Object.entries(packageJson.optionalDependencies || {})) {
  if (runtimeModules.has(name)) {
    copiedOptionalDependencies[name] = version;
  }
}

await fs.writeFile(
  path.join(stageDir, 'package.json'),
  `${JSON.stringify(buildDesktopPackageJson(copiedOptionalDependencies, peerOnly), null, 2)}\n`,
  'utf8',
);

console.log(`Prepared thin desktop app at ${path.relative(rootDir, stageDir)}`);
console.log(`Staged ${runtimeModules.size} packages (${seedNames.length} top-level runtime dependencies).`);
if (peerOnly.length > 0) {
  console.log(`Peer dependencies promoted to staged deps: ${peerOnly.join(', ')}`);
}
if (Object.keys(copiedOptionalDependencies).length) {
  console.log(`Optional dependencies: ${Object.keys(copiedOptionalDependencies).join(', ')}`);
}
