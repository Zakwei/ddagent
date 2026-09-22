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

async function copyNodeModule(packageName) {
  const parts = packageName.split('/');
  const source = path.join(rootDir, 'node_modules', ...parts);
  if (!(await pathExists(source))) return false;

  const target = path.join(stageDir, 'node_modules', ...parts);
  await fs.mkdir(path.dirname(target), { recursive: true });
  await fs.cp(source, target, { recursive: true });
  return true;
}

function buildDesktopPackageJson(copiedOptionalDependencies) {
  return {
    name: `${packageJson.name}-desktop`,
    version: packageJson.version,
    productName: packageJson.productName,
    description: `${packageJson.productName} desktop shell`,
    author: packageJson.author,
    license: packageJson.license,
    type: 'module',
    main: 'electron/main.js',
    dependencies: {
      ws: packageJson.dependencies.ws,
      // Native modules — must be declared here so @electron/rebuild's module
      // walker (npmRebuild) finds them and rebuilds them for the Electron ABI.
      'better-sqlite3': packageJson.dependencies['better-sqlite3'],
      'node-pty': packageJson.dependencies['node-pty'],
    },
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
      mac: packageJson.build.mac,
      win: packageJson.build.win,
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

const copiedRuntimeDependencies = [];
for (const name of ['ws', 'better-sqlite3', 'node-pty']) {
  if (await copyNodeModule(name)) {
    copiedRuntimeDependencies.push(name);
  } else {
    throw new Error(`Required desktop dependency is missing from node_modules: ${name}`);
  }
}

const copiedOptionalDependencies = {};
for (const [name, version] of Object.entries(packageJson.optionalDependencies || {})) {
  if (await copyNodeModule(name)) {
    copiedOptionalDependencies[name] = version;
  }
}

for (const name of [
  // better-sqlite3 runtime deps (bindings loads the .node; file-uri-to-path
  // is bindings' only dep). prebuild-install is left out — the Electron-ABI
  // rebuild resolves it from the repo's own node_modules at build time.
  'bindings',
  'file-uri-to-path',
  // node-pty needs nothing extra here: its only declared dep, node-addon-api,
  // is a header-only build tool that lives nested inside
  // node-pty/node_modules and is copied along with the package itself.
  '@nut-tree-fork/default-clipboard-provider',
  '@nut-tree-fork/libnut',
  '@nut-tree-fork/provider-interfaces',
  '@nut-tree-fork/shared',
  'jimp',
  'node-abort-controller',
  'temp',
]) {
  await copyNodeModule(name);
}

await fs.writeFile(
  path.join(stageDir, 'package.json'),
  `${JSON.stringify(buildDesktopPackageJson(copiedOptionalDependencies), null, 2)}\n`,
  'utf8',
);

console.log(`Prepared thin desktop app at ${path.relative(rootDir, stageDir)}`);
console.log(`Runtime dependencies: ${copiedRuntimeDependencies.join(', ')}`);
if (Object.keys(copiedOptionalDependencies).length) {
  console.log(`Optional dependencies: ${Object.keys(copiedOptionalDependencies).join(', ')}`);
}
