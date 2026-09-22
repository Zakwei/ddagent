#!/usr/bin/env node
/**
 * Fetches win32-x64 native binaries into the staged desktop app so that
 * `electron-builder --win nsis` can produce a Windows installer from Linux.
 *
 * Invoked by prepare-desktop-app.js only when DDAGENT_DESKTOP_TARGET=win32 is
 * set (the desktop:dist:win npm script) while running on a non-Windows host.
 *
 * Why this exists: electron-builder's npmRebuild runs @electron/rebuild to
 * recompile native modules for the Electron ABI, but node-gyp cannot
 * cross-compile linux -> win32 ("node-gyp does not support cross-compiling").
 * With npmRebuild disabled for this target the stage must ship prebuilt
 * binaries instead:
 *   - better-sqlite3: per-ABI prebuilds are published on its GitHub releases;
 *     the backend resolves them via bin/<platform>-<arch>-<abi>/ (see
 *     server/shared/utils.ts resolveSqliteNativeBinding).
 *   - bcrypt / node-pty: N-API prebuilds for win32 already ship inside their
 *     npm tarballs (node-gyp-build picks prebuilds/<platform>-<arch>/
 *     automatically) — no work needed.
 *   - @vscode/ripgrep: rg.exe comes from microsoft/ripgrep-prebuilt releases;
 *     the package computes the same asset name in lib/postinstall.js.
 *   - Provider CLIs (@anthropic-ai/claude-agent-sdk-*, @openai/codex-*):
 *     per-platform packages declared as optionalDependencies of the SDK
 *     packages. The win32-x64 entry of each family is fetched via npm pack
 *     and staged under the alias name the SDK resolves at runtime.
 *   - @nut-tree-fork/libnut-win32: already staged — its package.json "os"
 *     lists linux too, so the host filter keeps it.
 *
 * Additionally ensures a working Wine toolset: NSIS produces the uninstaller
 * by running the freshly built installer.exe once, which electron-builder does
 * through Wine on non-Windows hosts. The bundled electron-builder-binaries
 * wine@1.0.1 tarball is broken on Linux (it ships no x86_64-windows PE
 * builtins, so wineboot dies with c0000135 on ntdll.dll), so we download a
 * portable Kron4ek WoW64 Wine build into ~/.cache/ddagent-wine-toolset — the
 * desktop:dist:win script exports ELECTRON_BUILDER_WINE_TOOLSET_DIR pointing
 * at it, which electron-builder prefers over its own toolset.
 *
 * Downloads are cached under ~/.cache/ddagent-win32-natives.
 */

import { execFile } from 'node:child_process';
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import { promisify } from 'node:util';

const execFileAsync = promisify(execFile);

const CACHE_DIR = path.join(os.homedir(), '.cache', 'ddagent-win32-natives');
const WIN32_SUFFIX = /-win32-x64$/;

// Portable Wine used for the NSIS uninstaller-generation step. WoW64 build:
// runs both 32- and 64-bit PE without needing 32-bit system libs on the host.
// Pinned for reproducibility — bump deliberately.
const WINE_VERSION = '11.18';
const WINE_TOOLSET_DIR = path.join(os.homedir(), '.cache', 'ddagent-wine-toolset');

async function pathExists(filePath) {
  try {
    await fs.access(filePath);
    return true;
  } catch {
    return false;
  }
}

async function readJson(filePath) {
  return JSON.parse(await fs.readFile(filePath, 'utf8'));
}

async function run(cmd, args, options = {}) {
  const { stdout } = await execFileAsync(cmd, args, {
    maxBuffer: 64 * 1024 * 1024,
    ...options,
  });
  return stdout;
}

/**
 * Downloads `url` to the cache dir (skipping when already fetched) and
 * returns the cached file path.
 */
async function download(url, fileName) {
  const dest = path.join(CACHE_DIR, fileName);
  if (await pathExists(dest)) {
    console.log(`  cached: ${fileName}`);
    return dest;
  }
  console.log(`  downloading ${url}`);
  await fs.mkdir(CACHE_DIR, { recursive: true });
  await run('curl', ['-fSL', '--retry', '3', '-o', dest, url]);
  return dest;
}

/**
 * The Electron ABI (process.versions.modules) the packaged binary must match.
 * The repo's node-abi version may lag behind the pinned Electron, so ask the
 * Electron binary itself — ELECTRON_RUN_AS_NODE makes it behave like node.
 * Falls back to the ABI suffix of an already-present bin/ prebuild dir (a
 * previous @electron/rebuild output copied into the stage).
 */
async function detectElectronAbi(rootDir, stageDir) {
  const electronBin = path.join(rootDir, 'node_modules', 'electron', 'dist', 'electron');
  if (await pathExists(electronBin)) {
    try {
      const out = await run(electronBin, ['-p', 'process.versions.modules'], {
        env: { ...process.env, ELECTRON_RUN_AS_NODE: '1' },
      });
      const abi = out.trim();
      if (/^\d+$/.test(abi)) return abi;
    } catch {
      // fall through to the bin/ dir heuristic
    }
  }
  const binDir = path.join(stageDir, 'node_modules', 'better-sqlite3', 'bin');
  for (const entry of await fs.readdir(binDir).catch(() => [])) {
    const match = entry.match(/-(\d+)$/);
    if (match) return match[1];
  }
  throw new Error('Could not determine the Electron ABI version for the win32 prebuilds.');
}

/**
 * better-sqlite3 ships per-runtime prebuilds on GitHub releases, e.g.
 * better-sqlite3-v12.11.1-electron-v139-win32-x64.tar.gz containing
 * build/Release/better_sqlite3.node. The backend's resolveSqliteNativeBinding
 * looks for bin/win32-x64-<abi>/better-sqlite3.node.
 */
async function stageBetterSqlite3(stageDir, electronAbi) {
  const pkgDir = path.join(stageDir, 'node_modules', 'better-sqlite3');
  const { version } = await readJson(path.join(pkgDir, 'package.json'));
  const targetDir = path.join(pkgDir, 'bin', `win32-x64-${electronAbi}`);
  const target = path.join(targetDir, 'better-sqlite3.node');
  if (await pathExists(target)) {
    console.log(`  better-sqlite3: bin/win32-x64-${electronAbi}/better-sqlite3.node already staged`);
    return;
  }

  const url = `https://github.com/JoshuaWise/better-sqlite3/releases/download/v${version}/better-sqlite3-v${version}-electron-v${electronAbi}-win32-x64.tar.gz`;
  const archive = await download(url, `better-sqlite3-v${version}-electron-v${electronAbi}-win32-x64.tar.gz`);

  const extractDir = await fs.mkdtemp(path.join(os.tmpdir(), 'bs3-win32-'));
  await run('tar', ['-xzf', archive, '-C', extractDir, 'build/Release/better_sqlite3.node']);
  await fs.mkdir(targetDir, { recursive: true });
  await fs.copyFile(path.join(extractDir, 'build', 'Release', 'better_sqlite3.node'), target);
  await fs.rm(extractDir, { recursive: true, force: true });
  const { size } = await fs.stat(target);
  console.log(`  better-sqlite3: staged bin/win32-x64-${electronAbi}/better-sqlite3.node (${size} bytes)`);
}

/**
 * @vscode/ripgrep exposes rgPath = bin/rg(.exe); its postinstall downloads
 * ripgrep-<version>-<target>.zip from microsoft/ripgrep-prebuilt releases.
 * Read the pinned VERSION constant from the staged postinstall so this stays
 * in sync on upgrades. Target triple for win32-x64: x86_64-pc-windows-msvc.
 */
async function stageRipgrep(stageDir) {
  const pkgDir = path.join(stageDir, 'node_modules', '@vscode', 'ripgrep');
  const target = path.join(pkgDir, 'bin', 'rg.exe');
  if (await pathExists(target)) {
    console.log('  @vscode/ripgrep: bin/rg.exe already staged');
    return;
  }

  const postinstall = await fs.readFile(path.join(pkgDir, 'lib', 'postinstall.js'), 'utf8');
  const version = postinstall.match(/const VERSION = '([^']+)'/)?.[1];
  if (!version) {
    throw new Error('Could not parse the ripgrep VERSION pinned in @vscode/ripgrep postinstall.js');
  }

  const url = `https://github.com/microsoft/ripgrep-prebuilt/releases/download/${version}/ripgrep-${version}-x86_64-pc-windows-msvc.zip`;
  const archive = await download(url, `ripgrep-${version}-x86_64-pc-windows-msvc.zip`);

  const extractDir = await fs.mkdtemp(path.join(os.tmpdir(), 'rg-win32-'));
  await run('unzip', ['-o', archive, 'rg.exe', '-d', extractDir]);
  await fs.mkdir(path.join(pkgDir, 'bin'), { recursive: true });
  await fs.copyFile(path.join(extractDir, 'rg.exe'), target);
  await fs.rm(extractDir, { recursive: true, force: true });
  const { size } = await fs.stat(target);
  console.log(`  @vscode/ripgrep: staged bin/rg.exe ${version} (${size} bytes)`);
}

/**
 * Returns the names of all top-level packages staged under
 * `stageDir/node_modules` (including scoped names).
 */
async function listStagedPackages(stageDir) {
  const nmDir = path.join(stageDir, 'node_modules');
  const names = [];
  for (const entry of await fs.readdir(nmDir, { withFileTypes: true })) {
    if (!entry.isDirectory() || entry.name.startsWith('.')) continue;
    if (entry.name.startsWith('@')) {
      for (const scoped of await fs.readdir(path.join(nmDir, entry.name), { withFileTypes: true })) {
        if (scoped.isDirectory()) names.push(`${entry.name}/${scoped.name}`);
      }
    } else {
      names.push(entry.name);
    }
  }
  return names;
}

/**
 * Finds every optionalDependencies/dependencies key ending in `-win32-x64`
 * declared by any staged package and fetches the matching npm package into
 * the stage under that (possibly aliased) name.
 *
 * Two declaration shapes exist in the wild:
 *   "@anthropic-ai/claude-agent-sdk-win32-x64": "0.3.165"      -> pack key@version
 *   "@openai/codex-win32-x64": "npm:@openai/codex@0.146.0-win32-x64" -> pack the alias target
 * The runtime resolution only depends on the directory name under
 * node_modules, which is the dependency KEY in both cases.
 */
async function stageWin32PlatformPackages(stageDir) {
  const wanted = new Map(); // install name -> npm pack spec
  for (const name of await listStagedPackages(stageDir)) {
    let pkg;
    try {
      pkg = await readJson(path.join(stageDir, 'node_modules', name, 'package.json'));
    } catch {
      continue;
    }
    for (const deps of [pkg.optionalDependencies, pkg.dependencies]) {
      for (const [depName, spec] of Object.entries(deps || {})) {
        if (!WIN32_SUFFIX.test(depName)) continue;
        if (await pathExists(path.join(stageDir, 'node_modules', depName))) continue;
        const packSpec = spec.startsWith('npm:') ? spec.slice(4) : `${depName}@${spec}`;
        if (!wanted.has(depName)) wanted.set(depName, packSpec);
      }
    }
  }

  const staged = [];
  for (const [installName, packSpec] of wanted) {
    const packDir = await fs.mkdtemp(path.join(os.tmpdir(), 'win32-pack-'));
    try {
      const out = await run('npm', ['pack', packSpec, '--pack-destination', packDir], { cwd: stageDir });
      const tgz = out.trim().split('\n').pop();
      const tarball = path.join(packDir, tgz);
      if (!(await pathExists(tarball))) {
        throw new Error(`npm pack did not produce ${tgz} for ${packSpec}`);
      }
      const extractDir = path.join(packDir, 'extract');
      await fs.mkdir(extractDir);
      await run('tar', ['-xzf', tarball, '-C', extractDir]);
      const targetDir = path.join(stageDir, 'node_modules', ...installName.split('/'));
      await fs.mkdir(path.dirname(targetDir), { recursive: true });
      await fs.rm(targetDir, { recursive: true, force: true });
      await fs.cp(path.join(extractDir, 'package'), targetDir, { recursive: true });

      // Sanity: a platform package must carry actual binaries.
      const contents = await fs.readdir(targetDir, { recursive: true });
      const binaries = contents.filter((f) => /\.(exe|node|dll)$/.test(f));
      console.log(`  ${installName}: staged ${packSpec} (${binaries.length} binaries: ${binaries.slice(0, 5).join(', ')}${binaries.length > 5 ? ', ...' : ''})`);
      if (binaries.length === 0) {
        console.warn(`  WARNING: ${installName} contains no .exe/.node/.dll files — provider may degrade on Windows`);
      }
      staged.push(installName);
    } finally {
      await fs.rm(packDir, { recursive: true, force: true });
    }
  }
  return staged;
}

/**
 * Downloads a portable Kron4ek Wine build and shapes it into what
 * electron-builder's wine toolset expects (bin/wine + lib/ + a wine-home dir
 * it uses as WINEPREFIX). Needed because NSIS generates the uninstaller by
 * executing the just-built installer.exe, which electron-builder runs through
 * Wine off-Windows — and its own downloadable wine@1.0.1 bundle is broken on
 * Linux (no PE builtins shipped, wineboot fails loading ntdll.dll).
 *
 * Idempotent: skips when bin/wine already exists and answers --version.
 */
async function ensureWineToolset() {
  const wineBin = path.join(WINE_TOOLSET_DIR, 'bin', 'wine');
  const wineHome = path.join(WINE_TOOLSET_DIR, 'wine-home');
  if (await pathExists(wineBin)) {
    try {
      await run(wineBin, ['--version']);
      return;
    } catch {
      // broken/partial download — re-extract
      await fs.rm(WINE_TOOLSET_DIR, { recursive: true, force: true });
    }
  }

  const fileName = `wine-${WINE_VERSION}-amd64-wow64.tar.xz`;
  const archive = await download(
    `https://github.com/Kron4ek/Wine-Builds/releases/download/${WINE_VERSION}/${fileName}`,
    fileName,
  );

  const extractDir = await fs.mkdtemp(path.join(os.tmpdir(), 'wine-toolset-'));
  await run('tar', ['-xJf', archive, '-C', extractDir]);
  const extracted = path.join(extractDir, `wine-${WINE_VERSION}-amd64-wow64`);
  if (!(await pathExists(path.join(extracted, 'bin', 'wine')))) {
    throw new Error(`Wine tarball ${fileName} did not contain bin/wine`);
  }
  await fs.rm(WINE_TOOLSET_DIR, { recursive: true, force: true });
  await fs.mkdir(path.dirname(WINE_TOOLSET_DIR), { recursive: true });
  await fs.cp(extracted, WINE_TOOLSET_DIR, { recursive: true });
  await fs.rm(extractDir, { recursive: true, force: true });
  await fs.mkdir(wineHome, { recursive: true });
  const version = (await run(wineBin, ['--version'])).trim();
  console.log(`  wine toolset: ${version} at ${WINE_TOOLSET_DIR}`);
}

/**
 * @returns {Promise<string[]>} names of win32 platform packages staged into
 * node_modules — the caller declares them as optionalDependencies in the
 * staged package.json so electron-builder's module collector ships them.
 */
export async function fetchWin32Natives({ stageDir, rootDir }) {
  console.log('Fetching win32-x64 native binaries for cross-platform packaging...');
  const electronAbi = await detectElectronAbi(rootDir, stageDir);
  console.log(`  Electron ABI: ${electronAbi}`);
  await stageBetterSqlite3(stageDir, electronAbi);
  await stageRipgrep(stageDir);
  const staged = await stageWin32PlatformPackages(stageDir);
  if (process.platform === 'linux') {
    await ensureWineToolset();
  }
  return staged;
}

export { WINE_TOOLSET_DIR };

// Direct run for debugging: node scripts/release/fetch-win32-natives.mjs <stageDir>
if (process.argv[1] && import.meta.url === `file://${path.resolve(process.argv[1])}`) {
  const stageDir = path.resolve(process.argv[2] || '.desktop-build/desktop-app');
  const rootDir = path.resolve(stageDir, '..', '..');
  const staged = await fetchWin32Natives({ stageDir, rootDir });
  console.log(`Staged win32 platform packages: ${staged.join(', ') || '(none)'}`);
}
