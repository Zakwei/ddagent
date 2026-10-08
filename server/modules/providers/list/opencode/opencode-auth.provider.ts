import { readFile, rm } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';

import spawn from 'cross-spawn';

import type { IProviderAuth, ProviderAuthStatus } from '@/shared/index.js';
import { providerChildEnv, readObjectRecord, readOptionalString } from '@/shared/index.js';

type OpenCodeCredentialsStatus = {
  authenticated: boolean;
  email: string | null;
  method: string | null;
  error?: string;
};

const OPENCODE_ENV_CREDENTIAL_KEYS = [
  'ANTHROPIC_API_KEY',
  'OPENAI_API_KEY',
  'GOOGLE_GENERATIVE_AI_API_KEY',
  'GROQ_API_KEY',
  'OPENROUTER_API_KEY',
];

/** Used by the providers module to expose safe, current OpenCode login status. */
export class OpenCodeProviderAuth implements IProviderAuth {
  /**
   * Checks whether the OpenCode CLI is available to the server process.
   */
  private checkInstalled(): boolean {
    try {
      const result = spawn.sync('opencode', ['--version'], { stdio: 'ignore', timeout: 5000, env: providerChildEnv() });
      return !result.error && result.status === 0;
    } catch {
      return false;
    }
  }

  /**
   * Returns OpenCode CLI installation and credential status.
   */
  async getStatus(): Promise<ProviderAuthStatus> {
    const installed = this.checkInstalled();
    const credentials = await this.checkCredentials();

    return {
      installed,
      provider: 'opencode',
      authenticated: credentials.authenticated,
      email: credentials.email,
      method: credentials.method,
      error: credentials.authenticated ? undefined : credentials.error || 'Not authenticated',
    };
  }

  /**
   * Path to OpenCode's auth store. `XDG_DATA_HOME` replaces `~/.local/share`,
   * the same relocation provider accounts use to isolate the store.
   */
  private authStorePath(): string {
    const dataHome = process.env.XDG_DATA_HOME?.trim();
    const base = dataHome && dataHome.length > 0 ? dataHome : path.join(os.homedir(), '.local', 'share');
    return path.join(base, 'opencode', 'auth.json');
  }

  /**
   * Removes OpenCode's auth store so the next status check reports
   * unauthenticated. Credentials injected through the environment cannot be
   * cleared here. Consumed by the settings "Log out" action.
   */
  async logout(): Promise<void> {
    await rm(this.authStorePath(), { force: true });
  }

  /**
   * Reads OpenCode's auth store or falls back to provider API key environment variables.
   */
  private async checkCredentials(): Promise<OpenCodeCredentialsStatus> {
    try {
      const authPath = this.authStorePath();
      const content = await readFile(authPath, 'utf8');
      const auth = readObjectRecord(JSON.parse(content)) ?? {};

      for (const providerAuth of Object.values(auth)) {
        const providerRecord = readObjectRecord(providerAuth);
        if (!providerRecord) {
          continue;
        }

        // Metadata such as type/accountId must not keep a logged-out entry alive.
        const hasCredential = providerRecord.type === 'api'
          ? readOptionalString(providerRecord.key)
          : providerRecord.type === 'oauth'
            ? readOptionalString(providerRecord.access) ?? readOptionalString(providerRecord.refresh)
            : providerRecord.type === 'wellknown' && readOptionalString(providerRecord.token);
        if (hasCredential) {
          return {
            authenticated: true,
            email: null,
            method: 'credentials_file',
          };
        }
      }
    } catch (error) {
      const code = (error as NodeJS.ErrnoException).code;
      if (code !== 'ENOENT') {
        return {
          authenticated: false,
          email: null,
          method: null,
          error: 'Failed to read OpenCode auth',
        };
      }
    }

    const envCredential = OPENCODE_ENV_CREDENTIAL_KEYS.find((key) => process.env[key]?.trim());
    if (envCredential) {
      return {
        authenticated: true,
        email: null,
        method: 'environment',
      };
    }

    return {
      authenticated: false,
      email: null,
      method: null,
      error: 'OpenCode not configured',
    };
  }
}
