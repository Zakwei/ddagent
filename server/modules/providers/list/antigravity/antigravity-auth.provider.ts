import { execFile } from 'node:child_process';
import { promises as fs } from 'node:fs';
import path from 'node:path';
import { promisify } from 'node:util';

import type { IProviderAuth, ProviderAuthStatus } from '@/shared/index.js';
import {
  antigravityCredentialEmail,
  antigravityDir,
  readObjectRecord,
  readOptionalString,
  resolveAntigravityExecutable,
} from '@/shared/index.js';

const execFileAsync = promisify(execFile);

const ANTIGRAVITY_VERSION_TIMEOUT_MS = 5_000;

type AntigravityCredentialsStatus = {
  authenticated: boolean;
  email: string | null;
  method: string | null;
  error?: string;
};

/** Used by the providers module to expose safe, current Antigravity login status. */
export class AntigravityProviderAuth implements IProviderAuth {
  /**
   * Reads the CLI version through the resolved executable (`agy --version`
   * prints the bare version, e.g. `1.2.14`); a non-zero exit or ENOENT means
   * the CLI is not usable by the server process.
   */
  private async readVersion(executable: string): Promise<string | null> {
    try {
      const { stdout } = await execFileAsync(executable, ['--version'], {
        encoding: 'utf8',
        timeout: ANTIGRAVITY_VERSION_TIMEOUT_MS,
      });
      const trimmed = stdout.trim();
      return trimmed.length > 0 ? trimmed.split(/\r?\n/, 1)[0] : null;
    } catch {
      return null;
    }
  }

  /**
   * Returns Antigravity CLI installation and credential status.
   */
  async getStatus(): Promise<ProviderAuthStatus> {
    const executable = resolveAntigravityExecutable();
    const installed = executable !== null;
    const credentials = await this.checkCredentials();

    return {
      installed,
      provider: 'antigravity',
      authenticated: credentials.authenticated,
      email: credentials.email,
      method: credentials.method,
      error: credentials.authenticated ? undefined : credentials.error || 'Not authenticated',
    };
  }

  /**
   * Detects Antigravity credentials offline: the CLI writes an OAuth token
   * file at `~/.gemini/antigravity-cli/antigravity-oauth-token` after a
   * successful sign-in (Google account via system keyring/flow), and headless
   * runs can also authenticate with the `GEMINI_API_KEY` env var. Deliberately
   * offline — `agy` has no `status`/`whoami` subcommand and any authenticated
   * probe would hit the network on every status poll.
   */
  private async checkCredentials(): Promise<AntigravityCredentialsStatus> {
    if (process.env.GEMINI_API_KEY?.trim()) {
      return {
        authenticated: true,
        email: null,
        method: 'environment',
      };
    }

    try {
      // Match the Gemini quota adapter's native token shape. An id_token alone
      // is identity metadata and must not preserve a login after token removal.
      const text = await fs.readFile(
        path.join(antigravityDir(), 'antigravity-oauth-token'),
        'utf8',
      );
      const credentials = readObjectRecord(JSON.parse(text));
      const token = readObjectRecord(credentials?.token);
      if (credentials && (readOptionalString(token?.access_token) || readOptionalString(token?.refresh_token))) {
        return {
          authenticated: true,
          email: antigravityCredentialEmail(credentials),
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
          error: 'Failed to read Antigravity auth',
        };
      }
    }

    return {
      authenticated: false,
      email: null,
      method: null,
      error: 'Antigravity not configured — run `agy` to sign in or set GEMINI_API_KEY',
    };
  }
}
