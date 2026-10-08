#!/usr/bin/env node
import crypto from 'node:crypto';
import { createReadStream } from 'node:fs';
import fs from 'node:fs/promises';
import path from 'node:path';
import { spawn } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const rootDir = path.resolve(__dirname, '..', '..');
const packageJson = JSON.parse(
  await fs.readFile(path.join(rootDir, 'package.json'), 'utf8'),
);

function mapArch(arch = process.arch) {
  return arch === 'arm64' ? 'arm64' : 'x64';
}

function mapPlatform(platform = process.platform) {
  if (platform === 'darwin') return 'mac';
  if (platform === 'win32') return 'win';
  return 'linux';
}

function run(command, args, options = {}) {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, {
      stdio: 'inherit',
      shell: process.platform === 'win32',
      ...options,
    });
    child.once('error', reject);
    child.once('exit', (code) => {
      if (code === 0) resolve();
      else reject(new Error(`${command} ${args.join(' ')} exited with code ${code}`));
    });
  });
}

async function pathExists(filePath) {
  try {
    await fs.access(filePath);
    return true;
  } catch {
    return false;
  }
}

async function copyRequired(stageDir, relativePath) {
  const from = path.join(rootDir, relativePath);
  if (!(await pathExists(from))) {
    throw new Error(`Required server bundle input is missing: ${relativePath}`);
  }
  await fs.cp(from, path.join(stageDir, relativePath), { recursive: true });
}

async function copyIfExists(stageDir, relativePath) {
  const from = path.join(rootDir, relativePath);
  if (!(await pathExists(from))) return;
  await fs.cp(from, path.join(stageDir, relativePath), { recursive: true });
}

async function writeServerPackageJson(stageDir) {
  const stagedPackageJson = {
    ...packageJson,
    scripts: {
      ...(packageJson.scripts || {}),
    },
  };
  // The bundle stage is not a git checkout with dev dependencies, so lifecycle
  // scripts such as Husky prepare must not run there. Dependency install scripts
  // still run; native modules need them to build for the target ABI.
  delete stagedPackageJson.scripts.postinstall;
  delete stagedPackageJson.scripts.prepare;
  delete stagedPackageJson.scripts.prepublishOnly;
  await fs.writeFile(
    path.join(stageDir, 'package.json'),
    `${JSON.stringify(stagedPackageJson, null, 2)}\n`,
    'utf8',
  );
}

// Self-hosted launchers let users start the bundle under plain Node.js
// without knowing the server entrypoint path.
async function writeStandaloneLaunchers(stageDir) {
  const startShPath = path.join(stageDir, 'start.sh');
  // The whole script is one { ... } block: sh parses it completely before
  // running it, so an update that replaces files next to it can never make
  // the shell read half-old, half-new lines. The loop restarts the server
  // when it exits with 75 (restart/update from the UI) and applies a staged
  // update first (scripts/apply-update.cjs).
  await fs.writeFile(
    startShPath,
    [
      '#!/bin/sh',
      '# Self-hosted DDAgent server — serves the API/WS that the DDAgent client',
      '# connects to. Node.js 22+ required.',
      '# Env: SERVER_PORT (default 3001), HOST (default 0.0.0.0). Optional .env file here.',
      '{',
      'cd "$(dirname "$0")" || exit 1',
      'export DDAGENT_SUPERVISED=1',
      'while :; do',
      '  applied=',
      '  [ -f .update/ready ] && node scripts/apply-update.cjs && applied=1',
      '  started=$(date +%s)',
      '  node dist-server/server/index.js "$@"',
      '  code=$?',
      '  [ "$code" -eq 75 ] && continue',
      '  # An update that cannot even start: restore the previous version and run it.',
      '  if [ -n "$applied" ] && [ "$code" -ne 0 ] && [ $(( $(date +%s) - started )) -lt 120 ] \\',
      '    && node scripts/apply-update.cjs --rollback; then continue; fi',
      '  exit "$code"',
      'done',
      '}',
      '',
    ].join('\n'),
    'utf8',
  );
  await fs.chmod(startShPath, 0o755);
  // cmd.exe needs CRLF; build it explicitly so a LF-only git checkout of this
  // script cannot silently produce a broken batch file.
  await fs.writeFile(
    path.join(stageDir, 'start.bat'),
    [
      '@echo off',
      'rem Self-hosted DDAgent server. Node.js 22+ required. Env: SERVER_PORT, HOST.',
      'rem Restarts on exit code 75 (restart/update from the UI), applying a staged update first.',
      'setlocal',
      'cd /d "%~dp0"',
      'set DDAGENT_SUPERVISED=1',
      ':loop',
      'set APPLIED=',
      'if exist ".update\\ready" node "scripts\\apply-update.cjs" && set APPLIED=1',
      'node "dist-server\\server\\index.js" %*',
      'set CODE=%ERRORLEVEL%',
      'if "%CODE%"=="75" goto loop',
      'rem An update that cannot even start: restore the previous version and run it.',
      'if defined APPLIED if not "%CODE%"=="0" node "scripts\\apply-update.cjs" --rollback && goto loop',
      'exit /b %CODE%',
      '',
    ].join('\r\n'),
    'utf8',
  );
}

function sha256(filePath) {
  return new Promise((resolve, reject) => {
    const hash = crypto.createHash('sha256');
    const stream = createReadStream(filePath);
    stream.on('data', (chunk) => hash.update(chunk));
    stream.on('end', () => resolve(hash.digest('hex')));
    stream.on('error', reject);
  });
}

// Self-hosted bundle that users run under plain Node.js.
const platform = mapPlatform(process.env.DDAGENT_BUNDLE_PLATFORM || process.platform);
const arch = mapArch(process.env.DDAGENT_BUNDLE_ARCH || process.arch);
const version = packageJson.version;
const bundleName = `ddagent-server-${version}-${platform}-${arch}.tar.gz`;
const bundleRoot = path.join(rootDir, 'release', 'server');
const stageDir = path.join(bundleRoot, `.stage-${version}-${platform}-${arch}`);
const archivePath = path.join(bundleRoot, bundleName);

await fs.rm(stageDir, { recursive: true, force: true });
await fs.mkdir(stageDir, { recursive: true });
await fs.mkdir(bundleRoot, { recursive: true });

console.log(`Building server bundle ${bundleName}...`);

await copyRequired(stageDir, 'dist-server');
await copyRequired(stageDir, 'public');
await copyRequired(stageDir, 'shared');
await copyRequired(stageDir, 'package-lock.json');
await copyIfExists(stageDir, 'scripts/fix-node-pty.js');
await copyRequired(stageDir, 'scripts/apply-update.cjs');
await copyIfExists(stageDir, 'LICENSE');
await copyIfExists(stageDir, 'THIRD_PARTY_NOTICES.md');
await writeServerPackageJson(stageDir);
await writeStandaloneLaunchers(stageDir);

console.log('Installing production server dependencies into bundle stage...');
await run('npm', ['ci', '--omit=dev'], {
  cwd: stageDir,
  env: {
    ...process.env,
    npm_config_audit: 'false',
    npm_config_fund: 'false',
  },
});

if (await pathExists(path.join(stageDir, 'scripts', 'fix-node-pty.js'))) {
  await run(process.execPath, ['scripts/fix-node-pty.js'], { cwd: stageDir });
}

await fs.writeFile(
  path.join(stageDir, '.installed.json'),
  JSON.stringify({
    version,
    platform,
    arch,
    builtAt: new Date().toISOString(),
    // Native modules (better-sqlite3, node-pty) only load on this Node.js ABI;
    // a self-update checks it before installing the bundle.
    node: process.versions.node,
    nodeModules: process.versions.modules,
  }, null, 2),
  'utf8',
);

await fs.rm(archivePath, { force: true });
const tarArgs = process.platform === 'win32'
  ? ['-czf', archivePath, '-C', stageDir, '.']
  : ['-czf', archivePath, '-C', stageDir, '.'];
await run('tar', tarArgs);

const digest = await sha256(archivePath);
const checksumPath = `${archivePath}.sha256`;
await fs.writeFile(checksumPath, `${digest}  ${bundleName}\n`, 'utf8');
await fs.rm(stageDir, { recursive: true, force: true });

const size = (await fs.stat(archivePath)).size / 1024 / 1024;
console.log(`Wrote ${path.relative(rootDir, archivePath)} (${size.toFixed(1)} MB)`);
console.log(`Wrote ${path.relative(rootDir, checksumPath)}`);
