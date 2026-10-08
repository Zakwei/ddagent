import { readFile, rm } from 'node:fs/promises';
import path from 'node:path';

import spawn from 'cross-spawn';

import {
  cachedCliIdentity,
  devinConfigDir,
  devinDataDir,
  providerChildEnv,
  readCliField,
  readObjectRecord,
  readOptionalString,
} from '@/shared/index.js';
import type { IProviderAuth, ProviderAuthStatus } from '@/shared/index.js';

const DEVIN_IDENTITY_TIMEOUT_MS = 5_000;

type DevinCredentialsStatus = Pick<ProviderAuthStatus, 'authenticated' | 'email' | 'method' | 'error'>;

const readTomlValue = (content: string, key: string): string | undefined => {
  const regex = new RegExp(`^${key}\\s*=\\s*"([^"]*)"`, 'm');
  const match = content.match(regex);
  return match ? match[1].trim() : undefined;
};

/** Used by the providers module to report Devin credentials without exposing keys. */
export class DevinProviderAuth implements IProviderAuth {
  /**
   * Checks whether the Devin CLI is available to the server process.
   */
  private checkInstalled(): boolean {
    try {
      const result = spawn.sync('devin', ['--version'], { stdio: 'ignore', timeout: 5000, env: providerChildEnv() });
      return !result.error && result.status === 0;
    } catch {
      return false;
    }
  }

  /**
   * Returns Devin CLI installation and credential status.
   */
  async getStatus(): Promise<ProviderAuthStatus> {
    const installed = this.checkInstalled();

    if (!installed) {
      return {
        installed,
        provider: 'devin',
        authenticated: false,
        email: null,
        method: null,
        error: 'Devin CLI not found',
      };
    }

    const credentials = await this.checkCredentials();

    return {
      installed,
      provider: 'devin',
      authenticated: credentials.authenticated,
      email: credentials.email
        ?? (credentials.authenticated ? this.cliIdentity() : null),
      method: credentials.method,
      error: credentials.authenticated ? undefined : credentials.error,
    };
  }

  /**
   * Best-effort account name from `devin auth status`: `Email`, else `Name`.
   * The credential files hold only keys and an org id, so they cannot name the
   * account. `cachedCliIdentity` memoizes this network probe; any failure,
   * missing CLI or unexpected output yields no identity.
   */
  private cliIdentity(): string | null {
    return cachedCliIdentity('devin', () => {
      const result = spawn.sync('devin', ['auth', 'status'], {
        encoding: 'utf8',
        timeout: DEVIN_IDENTITY_TIMEOUT_MS,
      });
      if (result.error || result.status !== 0 || typeof result.stdout !== 'string') {
        return null;
      }
      return readCliField(result.stdout, 'Email') ?? readCliField(result.stdout, 'Name');
    });
  }

  /**
   * Removes Devin's `credentials.toml` so the next status check reports
   * unauthenticated. Keys injected through the environment cannot be cleared
   * here. Consumed by the settings "Log out" action via IProviderAuth.logout.
   */
  async logout(): Promise<void> {
    await rm(path.join(devinDataDir(), 'credentials.toml'), { force: true });
  }

  /**
   * Reads Devin credential files and falls back to environment API keys.
   */
  private async checkCredentials(): Promise<DevinCredentialsStatus> {
    try {
      const credentialsPath = path.join(devinDataDir(), 'credentials.toml');
      const content = await readFile(credentialsPath, 'utf8');
      const apiKey = readTomlValue(content, 'windsurf_api_key');
      if (apiKey) {
        return {
          authenticated: true,
          email: null,
          method: 'credentials_file',
        };
      }
    } catch (error) {
      if ((error as NodeJS.ErrnoException).code !== 'ENOENT') {
        return {
          authenticated: false,
          email: null,
          method: null,
          error: 'Failed to read Devin credentials',
        };
      }
    }

    const envKey = process.env.WINDSURF_API_KEY?.trim() || process.env.DEVIN_API_KEY?.trim();
    if (envKey) {
      return {
        authenticated: true,
        email: null,
        method: 'environment',
      };
    }

    try {
      const configPath = path.join(devinConfigDir(), 'config.json');
      const content = await readFile(configPath, 'utf8');
      const config = readObjectRecord(JSON.parse(content)) ?? {};
      const devinConfig = readObjectRecord(config.devin);
      const key = readOptionalString(devinConfig?.windsurf_api_key ?? devinConfig?.api_key);
      if (key) {
        return {
          authenticated: true,
          email: null,
          method: 'config_file',
        };
      }
    } catch (error) {
      if ((error as NodeJS.ErrnoException).code !== 'ENOENT') {
        return {
          authenticated: false,
          email: null,
          method: null,
          error: 'Failed to read Devin config',
        };
      }
    }

    return {
      authenticated: false,
      email: null,
      method: null,
      error: 'Devin credentials not found. Configure WINDSURF_API_KEY or run devin login.',
    };
  }
}
