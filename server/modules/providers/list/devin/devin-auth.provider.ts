import { readFile } from 'node:fs/promises';
import path from 'node:path';

import spawn from 'cross-spawn';

import { devinConfigDir, devinDataDir, readObjectRecord, readOptionalString } from '@/shared/index.js';
import type { IProviderAuth, ProviderAuthStatus } from '@/shared/index.js';

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
      const result = spawn.sync('devin', ['--version'], { stdio: 'ignore', timeout: 5000 });
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
      email: credentials.email,
      method: credentials.method,
      error: credentials.authenticated ? undefined : credentials.error,
    };
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
