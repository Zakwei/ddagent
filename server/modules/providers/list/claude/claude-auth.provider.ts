import { readFile, rm, writeFile } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';

import spawn from 'cross-spawn';

import { resolveClaudeCodeExecutablePath, readObjectRecord, readOptionalString } from '@/shared/index.js';
import type { IProviderAuth, ProviderAuthStatus } from '@/shared/index.js';

type ClaudeCredentialsStatus = {
  authenticated: boolean;
  email: string | null;
  method: string | null;
  error?: string;
};

/** Env keys in `settings.json` that carry login material rather than preferences. */
const CLAUDE_CREDENTIAL_ENV_KEYS = [
  'ANTHROPIC_AUTH_TOKEN',
  'ANTHROPIC_API_KEY',
  'CLAUDE_CODE_OAUTH_TOKEN',
] as const;

const hasErrorCode = (error: unknown, code: string): boolean => (
  error instanceof Error && 'code' in error && error.code === code
);

/** Used by the providers module to expose safe, current Claude login status. */
export class ClaudeProviderAuth implements IProviderAuth {
  /**
   * Checks whether the Claude Code CLI is available on this host.
   */
  private checkInstalled(): boolean {
    const cliPath = resolveClaudeCodeExecutablePath(process.env.CLAUDE_CLI_PATH);
    try {
      spawn.sync(cliPath, ['--version'], { stdio: 'ignore', timeout: 5000 });
      return true;
    } catch {
      return false;
    }
  }

  /**
   * Returns Claude installation and credential status using Claude Code's auth priority.
   */
  async getStatus(): Promise<ProviderAuthStatus> {
    const installed = this.checkInstalled();

    if (!installed) {
      return {
        installed,
        provider: 'claude',
        authenticated: false,
        email: null,
        method: null,
        error: 'Claude Code CLI is not installed',
      };
    }

    const credentials = await this.checkCredentials();

    return {
      installed,
      provider: 'claude',
      authenticated: credentials.authenticated,
      email: credentials.authenticated ? credentials.email : null,
      method: credentials.method,
      error: credentials.authenticated ? undefined : credentials.error || 'Not authenticated',
    };
  }

  /**
   * Directory holding Claude Code's credentials and settings. `CLAUDE_CONFIG_DIR`
   * replaces `~/.claude` entirely — the same env var provider accounts use to
   * isolate their credential store.
   */
  private claudeDir(): string {
    const configured = process.env.CLAUDE_CONFIG_DIR?.trim();
    return configured && configured.length > 0 ? configured : path.join(os.homedir(), '.claude');
  }

  /**
   * Reads Claude settings env values that the CLI can use even when the server process env is empty.
   */
  private async loadSettingsEnv(): Promise<Record<string, unknown>> {
    try {
      const content = await readFile(path.join(this.claudeDir(), 'settings.json'), 'utf8');
      const settings = readObjectRecord(JSON.parse(content));
      return readObjectRecord(settings?.env) ?? {};
    } catch {
      return {};
    }
  }

  /**
   * Clears Claude's stored login: removes the OAuth credentials file and strips
   * the credential env keys from `settings.json` (preferences are preserved).
   *
   * Credentials supplied through the server process environment cannot be
   * removed here — status keeps reporting them until the deployment stops
   * exporting them. Consumed by the settings "Log out" action via
   * IProviderAuth.logout.
   */
  async logout(): Promise<void> {
    const dir = this.claudeDir();
    await rm(path.join(dir, '.credentials.json'), { force: true });
    await this.clearSettingsCredentials(path.join(dir, 'settings.json'));
  }

  /**
   * Removes credential env keys from a Claude `settings.json`, preserving every
   * other key and leaving a malformed/missing file untouched.
   */
  private async clearSettingsCredentials(settingsPath: string): Promise<void> {
    let raw: string;
    try {
      raw = await readFile(settingsPath, 'utf8');
    } catch {
      return;
    }

    let settings: Record<string, unknown>;
    try {
      settings = JSON.parse(raw) as Record<string, unknown>;
    } catch {
      return;
    }

    const env = readObjectRecord(settings.env);
    if (!env) {
      return;
    }

    let changed = false;
    for (const key of CLAUDE_CREDENTIAL_ENV_KEYS) {
      if (key in env) {
        delete env[key];
        changed = true;
      }
    }

    if (changed) {
      await writeFile(settingsPath, `${JSON.stringify({ ...settings, env }, null, 2)}\n`);
    }
  }

  /**
   * Checks Claude credentials in the same priority order used by Claude Code.
   */
  private async checkCredentials(): Promise<ClaudeCredentialsStatus> {
    const missingCredentialsError = 'Claude CLI is not authenticated. Run claude /login or configure ANTHROPIC_API_KEY.';

    if (process.env.ANTHROPIC_AUTH_TOKEN?.trim()) {
      return { authenticated: true, email: null, method: 'api_key' };
    }

    if (process.env.ANTHROPIC_API_KEY?.trim()) {
      return { authenticated: true, email: null, method: 'api_key' };
    }

    const settingsEnv = await this.loadSettingsEnv();
    if (readOptionalString(settingsEnv.ANTHROPIC_API_KEY)) {
      return { authenticated: true, email: null, method: 'api_key' };
    }

    if (readOptionalString(settingsEnv.ANTHROPIC_AUTH_TOKEN)) {
      return { authenticated: true, email: null, method: 'api_key' };
    }

    if (process.env.CLAUDE_CODE_OAUTH_TOKEN?.trim()) {
      return { authenticated: true, email: null, method: 'environment' };
    }

    if (readOptionalString(settingsEnv.CLAUDE_CODE_OAUTH_TOKEN)) {
      return { authenticated: true, email: null, method: 'environment' };
    }

    try {
      const credPath = path.join(this.claudeDir(), '.credentials.json');
      const content = await readFile(credPath, 'utf8');
      const creds = readObjectRecord(JSON.parse(content)) ?? {};
      const oauth = readObjectRecord(creds.claudeAiOauth);
      const accessToken = readOptionalString(oauth?.accessToken);

      if (accessToken) {
        const expiresAt = typeof oauth?.expiresAt === 'number' ? oauth.expiresAt : undefined;
        const email = readOptionalString(creds.email) ?? readOptionalString(creds.user) ?? null;
        if (!expiresAt || Date.now() < expiresAt) {
          return {
            authenticated: true,
            email,
            method: 'credentials_file',
          };
        }

        return {
          authenticated: false,
          email: null,
          method: null,
          error: 'Claude login has expired. Run claude /login again.',
        };
      }

      return {
        authenticated: false,
        email: null,
        method: null,
        error: missingCredentialsError,
      };
    } catch (error) {
      let errorMessage = 'Unable to read Claude credentials. Run claude /login again.';

      if (hasErrorCode(error, 'ENOENT')) {
        errorMessage = missingCredentialsError;
      } else if (error instanceof SyntaxError) {
        errorMessage = 'Claude credentials are unreadable. Run claude /login again.';
      }

      return {
        authenticated: false,
        email: null,
        method: null,
        error: errorMessage,
      };
    }
  }
}
