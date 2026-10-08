import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';

import spawn from 'cross-spawn';
import type { Router } from 'express';

import { githubTokensDb } from '../database/index.js';

import { createSystemRouter } from './system.routes.js';
import { createSystemUpdateService } from './system.service.js';

type SystemModuleOptions = {
  appRoot: string;
  installMode: 'git' | 'npm' | 'bundle';
  isPlatform: boolean;
  /** Version of the running code (package.json at startup). */
  runningVersion?: string | null;
};

/**
 * Web client directory this installation hosts: `DDAGENT_WEB_DIR`, else the
 * build that scripts/serve-flutter-web.cjs serves from a source checkout.
 */
function resolveWebDirectory(appRoot: string): string | null {
  const configured = process.env.DDAGENT_WEB_DIR;
  if (configured) return path.resolve(configured);
  const sourceBuild = path.join(appRoot, 'flutter', 'build', 'web');
  return fs.existsSync(path.join(sourceBuild, 'index.html')) ? sourceBuild : null;
}

function runShellCommand(
  command: string,
  workingDirectory: string,
  environment: NodeJS.ProcessEnv,
  onOutput: (output: string) => void,
  onErrorOutput: (errorOutput: string) => void,
): Promise<{ exitCode: number | null; output: string; errorOutput: string }> {
  return new Promise((resolve, reject) => {
    // The update commands are plain `git`/`npm` invocations — `cmd /c` covers
    // them on Windows where `sh` does not exist.
    const [shell, shellArgs] = process.platform === 'win32'
      ? ['cmd.exe', ['/d', '/s', '/c', command]]
      : ['sh', ['-c', command]];
    const childProcess = spawn(shell, shellArgs, {
      cwd: workingDirectory,
      env: environment,
    });
    let output = '';
    let errorOutput = '';

    childProcess.stdout?.on('data', (data: Buffer) => {
      const text = data.toString();
      output += text;
      onOutput(text);
    });
    childProcess.stderr?.on('data', (data: Buffer) => {
      const text = data.toString();
      errorOutput += text;
      onErrorOutput(text);
    });
    childProcess.once('error', reject);
    childProcess.once('close', (exitCode) => {
      resolve({ exitCode, output, errorOutput });
    });
  });
}

/**
 * Builds the authenticated system router for the server entrypoint using the
 * installation details it already resolves for health and startup metadata.
 */
export function createSystemModule(options: SystemModuleOptions): Router {
  const { runningVersion, ...installation } = options;
  const systemUpdateService = createSystemUpdateService({
    ...installation,
    currentVersion: runningVersion ?? null,
    isSupervised: Boolean(process.env.INVOCATION_ID || process.env.DDAGENT_SUPERVISED),
    webDirectory: resolveWebDirectory(options.appRoot),
    githubTokens: githubTokensDb,
    homeDirectory: os.homedir(),
    environment: process.env,
    runShellCommand,
    logInfo: (message, detail) => console.log(message, detail ?? ''),
    logError: (message, detail) => console.error(message, detail ?? ''),
  });

  // After a release-tarball update the launcher keeps the replaced version in
  // `.update-previous` to roll back a release that cannot start. Once this
  // process has run for a while the update is good — free the space.
  if (options.installMode === 'bundle') {
    setTimeout(() => {
      fs.rm(path.join(options.appRoot, '.update-previous'), { recursive: true, force: true }, () => {});
    }, 5 * 60 * 1000).unref();
  }

  return createSystemRouter(systemUpdateService);
}
