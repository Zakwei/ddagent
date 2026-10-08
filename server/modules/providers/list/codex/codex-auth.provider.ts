import { readFile, rm } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';

import spawn from 'cross-spawn';

import type { IProviderAuth, ProviderAuthStatus } from '@/shared/index.js';
import { idTokenEmail, providerChildEnv, readObjectRecord, readOptionalString } from '@/shared/index.js';

type CodexCredentialsStatus = {
  authenticated: boolean;
  email: string | null;
  method: string | null;
  error?: string;
};

/** Used by the providers module to expose safe, current Codex login status. */
export class CodexProviderAuth implements IProviderAuth {
  /**
   * Checks whether Codex is available to the server runtime.
   */
  private checkInstalled(): boolean {
    try {
      // cross-spawn reports ENOENT via `result.error` instead of throwing.
      const result = spawn.sync('codex', ['--version'], { stdio: 'ignore', timeout: 5000, env: providerChildEnv() });
      return !result.error && result.status === 0;
    } catch {
      return false;
    }
  }

  /**
   * Returns Codex SDK availability and credential status.
   */
  async getStatus(): Promise<ProviderAuthStatus> {
    const installed = this.checkInstalled();
    const credentials = await this.checkCredentials();

    return {
      installed,
      provider: 'codex',
      authenticated: credentials.authenticated,
      email: credentials.email,
      method: credentials.method,
      error: credentials.authenticated ? undefined : credentials.error || 'Not authenticated',
    };
  }

  /**
   * Directory holding Codex's `auth.json`. `CODEX_HOME` replaces `~/.codex` —
   * the same env var provider accounts use to isolate their credential store.
   */
  private codexHome(): string {
    const configured = process.env.CODEX_HOME?.trim();
    return configured && configured.length > 0 ? configured : path.join(os.homedir(), '.codex');
  }

  /**
   * Removes Codex's login store so the next status check reports unauthenticated.
   * Credentials injected through the environment cannot be cleared here.
   * Consumed by the settings "Log out" action via IProviderAuth.logout.
   */
  async logout(): Promise<void> {
    await rm(path.join(this.codexHome(), 'auth.json'), { force: true });
  }

  /**
   * Reads Codex auth.json and checks OAuth tokens or an API key fallback.
   */
  private async checkCredentials(): Promise<CodexCredentialsStatus> {
    try {
      const authPath = path.join(this.codexHome(), 'auth.json');
      const content = await readFile(authPath, 'utf8');
      const auth = readObjectRecord(JSON.parse(content)) ?? {};
      const tokens = readObjectRecord(auth.tokens) ?? {};
      const idToken = readOptionalString(tokens.id_token);
      const accessToken = readOptionalString(tokens.access_token);

      if (accessToken || readOptionalString(tokens.refresh_token)) {
        return {
          authenticated: true,
          email: idToken ? idTokenEmail(idToken) : null,
          method: 'credentials_file',
        };
      }

      if (readOptionalString(auth.OPENAI_API_KEY)) {
        return { authenticated: true, email: null, method: 'api_key' };
      }

      return { authenticated: false, email: null, method: null, error: 'No valid tokens found' };
    } catch (error) {
      const code = (error as NodeJS.ErrnoException).code;
      return {
        authenticated: false,
        email: null,
        method: null,
        error: code === 'ENOENT' ? 'Codex not configured' : 'Failed to read Codex auth',
      };
    }
  }

}
