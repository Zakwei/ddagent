import { execFile } from 'node:child_process';
import { promisify } from 'node:util';
import path from 'node:path';

import type { IProviderAuth } from '@/shared/interfaces.js';
import type { ProviderAuthStatus } from '@/shared/types.js';
import {
  commandCodeDir,
  readJsonConfig,
  readObjectRecord,
  readOptionalString,
  resolveCommandCodeExecutable,
} from '@/shared/utils.js';

const execFileAsync = promisify(execFile);

const COMMAND_CODE_VERSION_TIMEOUT_MS = 5_000;

type CommandCodeCredentialsStatus = {
  authenticated: boolean;
  email: string | null;
  method: string | null;
  error?: string;
};

export class CommandCodeProviderAuth implements IProviderAuth {
  /**
   * Reads the CLI version through the resolved executable. `--version` prints
   * the bare version (e.g. `1.74.0`); a non-zero exit or ENOENT means the CLI
   * is not usable by the server process.
   */
  private async readVersion(executable: string): Promise<string | null> {
    try {
      const { stdout } = await execFileAsync(executable, ['--version'], {
        encoding: 'utf8',
        timeout: COMMAND_CODE_VERSION_TIMEOUT_MS,
      });
      return readOptionalString(stdout.trim()) ?? null;
    } catch {
      return null;
    }
  }

  /**
   * Returns Command Code CLI installation and credential status.
   */
  async getStatus(): Promise<ProviderAuthStatus> {
    const executable = resolveCommandCodeExecutable();
    const installed = executable !== null;
    const credentials = await this.checkCredentials();

    return {
      installed,
      provider: 'commandcode',
      authenticated: credentials.authenticated,
      email: credentials.email,
      method: credentials.method,
      error: credentials.authenticated ? undefined : credentials.error || 'Not authenticated',
    };
  }

  /**
   * Reads Command Code's auth store (`~/.commandcode/auth.json`, written by
   * `cmd login` as `{apiKey, userId, userName, keyName, authenticatedAt}`) and
   * falls back to the `COMMAND_CODE_API_KEY` env var the CLI also honors.
   * Deliberately offline: `cmd whoami`/`cmd status` hit the network and would
   * stall status polling on a cold connection.
   */
  private async checkCredentials(): Promise<CommandCodeCredentialsStatus> {
    if (process.env.COMMAND_CODE_API_KEY?.trim()) {
      return {
        authenticated: true,
        email: 'COMMAND_CODE_API_KEY',
        method: 'environment',
      };
    }

    try {
      const authPath = path.join(commandCodeDir(), 'auth.json');
      const auth = await readJsonConfig(authPath);
      const apiKey = readOptionalString(auth.apiKey);
      if (apiKey) {
        const userName = readOptionalString(auth.userName);
        return {
          authenticated: true,
          email: userName || 'Command Code account',
          method: 'credentials_file',
        };
      }

      // A providers.json-style file can hold per-upstream keys without a
      // Command Code account key — report what is actually there.
      const hasProviderKey = Object.values(auth).some(
        (value) => readObjectRecord(value)?.apiKey,
      );
      if (hasProviderKey) {
        return {
          authenticated: true,
          email: 'provider credentials',
          method: 'credentials_file',
        };
      }
    } catch (error) {
      const code = (error as NodeJS.ErrnoException).code;
      if (code !== 'ENOENT') {
        return {
          authenticated: false,
          email: null,
          method: null,
          error: error instanceof Error ? error.message : 'Failed to read Command Code auth',
        };
      }
    }

    return {
      authenticated: false,
      email: null,
      method: null,
      error: 'Command Code not configured — run `cmd login`',
    };
  }
}
