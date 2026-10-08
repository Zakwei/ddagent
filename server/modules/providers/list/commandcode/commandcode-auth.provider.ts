import { rm } from 'node:fs/promises';
import path from 'node:path';

import spawn from 'cross-spawn';

import type { IProviderAuth, ProviderAuthStatus } from '@/shared/index.js';
import {
  cachedCliIdentity,
  commandCodeDir,
  execCliFile,
  providerChildEnv,
  readCliField,
  readJsonConfig,
  readObjectRecord,
  readOptionalString,
  resolveCommandCodeExecutable,
} from '@/shared/index.js';

const COMMAND_CODE_VERSION_TIMEOUT_MS = 5_000;
const COMMAND_CODE_IDENTITY_TIMEOUT_MS = 5_000;

type CommandCodeCredentialsStatus = {
  authenticated: boolean;
  email: string | null;
  method: string | null;
  error?: string;
};

/** Used by the providers module to expose safe, current CommandCode login status. */
export class CommandCodeProviderAuth implements IProviderAuth {
  /**
   * Reads the CLI version through the resolved executable. `--version` prints
   * the bare version (e.g. `1.74.0`); a non-zero exit or ENOENT means the CLI
   * is not usable by the server process.
   */
  private async readVersion(executable: string): Promise<string | null> {
    try {
      const { stdout } = await execCliFile(executable, ['--version'], {
        encoding: 'utf8',
        timeout: COMMAND_CODE_VERSION_TIMEOUT_MS,
        env: providerChildEnv(),
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
      email: credentials.email
        ?? (credentials.authenticated ? this.cliIdentity(executable) : null),
      method: credentials.method,
      error: credentials.authenticated ? undefined : credentials.error || 'Not authenticated',
    };
  }

  /**
   * Best-effort account name from `cmd whoami`: `Email`, else `Username`, else
   * `Name`. The auth store frequently holds only an API key (the case here), so
   * the offline store read cannot name the account. `cachedCliIdentity`
   * memoizes this network probe, and any failure or missing executable simply
   * yields no identity. Returns null when nothing usable is printed.
   */
  private cliIdentity(executable: string | null): string | null {
    if (!executable) {
      return null;
    }
    return cachedCliIdentity('commandcode', () => {
      const result = spawn.sync(executable, ['whoami'], {
        encoding: 'utf8',
        timeout: COMMAND_CODE_IDENTITY_TIMEOUT_MS,
      });
      if (result.error || result.status !== 0 || typeof result.stdout !== 'string') {
        return null;
      }
      return readCliField(result.stdout, 'Email')
        ?? readCliField(result.stdout, 'Username')
        ?? readCliField(result.stdout, 'Name');
    });
  }

  /**
   * Removes Command Code's auth store so the next status check reports
   * unauthenticated. Credentials injected through the environment cannot be
   * cleared here. Consumed by the settings "Log out" action.
   */
  async logout(): Promise<void> {
    await rm(path.join(commandCodeDir(), 'auth.json'), { force: true });
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
        email: null,
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
          email: userName ?? null,
          method: 'credentials_file',
        };
      }

      // A providers.json-style file can hold per-upstream keys without a
      // Command Code account key — report what is actually there.
      const hasProviderKey = Object.values(auth).some(
        (value) => readOptionalString(readObjectRecord(value)?.apiKey),
      );
      if (hasProviderKey) {
        return {
          authenticated: true,
          email: null,
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
          error: 'Failed to read Command Code auth',
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
