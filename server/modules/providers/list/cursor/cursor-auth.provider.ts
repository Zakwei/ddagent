import spawn from 'cross-spawn';

import { execCliFile, providerChildEnv } from '@/shared/index.js';
import type { IProviderAuth, ProviderAuthStatus } from '@/shared/index.js';

type CursorLoginStatus = {
  authenticated: boolean;
  email: string | null;
  method: string | null;
  error?: string;
};

/** Used by the providers module to expose safe, current Cursor login status. */
export class CursorProviderAuth implements IProviderAuth {
  /**
   * Checks whether the cursor-agent CLI is available on this host.
   */
  private checkInstalled(): boolean {
    try {
      // cross-spawn reports ENOENT via `result.error` instead of throwing.
      const result = spawn.sync('cursor-agent', ['--version'], {
        stdio: 'ignore',
        timeout: 5000,
        env: providerChildEnv(),
      });
      return !result.error && result.status === 0;
    } catch {
      return false;
    }
  }

  /**
   * Returns Cursor CLI installation and login status.
   */
  async getStatus(): Promise<ProviderAuthStatus> {
    const installed = this.checkInstalled();

    if (!installed) {
      return {
        installed,
        provider: 'cursor',
        authenticated: false,
        email: null,
        method: null,
        error: 'Cursor CLI is not installed',
      };
    }

    const login = await this.checkCursorLogin();

    return {
      installed,
      provider: 'cursor',
      authenticated: login.authenticated,
      email: login.email,
      method: login.method,
      error: login.authenticated ? undefined : login.error || 'Not logged in',
    };
  }

  /**
   * Signs the cursor-agent CLI out (`cursor-agent logout`), which clears its
   * stored login. Consumed by the settings "Log out" action via
   * IProviderAuth.logout.
   */
  async logout(): Promise<void> {
    await execCliFile('cursor-agent', ['logout'], { encoding: 'utf8', timeout: 15_000, env: providerChildEnv() });
  }

  /**
   * Runs cursor-agent status and parses the login marker from stdout.
   */
  private checkCursorLogin(): Promise<CursorLoginStatus> {
    return new Promise((resolve) => {
      let processCompleted = false;
      let childProcess: ReturnType<typeof spawn> | undefined;

      const timeout = setTimeout(() => {
        if (!processCompleted) {
          processCompleted = true;
          childProcess?.kill();
          resolve({
            authenticated: false,
            email: null,
            method: null,
            error: 'Command timeout',
          });
        }
      }, 5000);

      try {
        childProcess = spawn('cursor-agent', ['status'], { env: providerChildEnv() });
      } catch {
        clearTimeout(timeout);
        processCompleted = true;
        resolve({
          authenticated: false,
          email: null,
          method: null,
          error: 'Cursor CLI not found or not installed',
        });
        return;
      }

      let stdout = '';

      childProcess.stdout?.on('data', (data: Buffer) => {
        stdout += data.toString();
      });

      // Drain diagnostics without returning potentially sensitive CLI output.
      childProcess.stderr?.resume();

      childProcess.on('close', (code) => {
        if (processCompleted) {
          return;
        }
        processCompleted = true;
        clearTimeout(timeout);

        if (code === 0) {
          const emailMatch = stdout.match(/Logged in as ([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})/i);
          if (emailMatch?.[1]) {
            resolve({ authenticated: true, email: emailMatch[1], method: 'cli' });
            return;
          }

          if (stdout.includes('Logged in')) {
            resolve({ authenticated: true, email: null, method: 'cli' });
            return;
          }

          resolve({ authenticated: false, email: null, method: null, error: 'Not logged in' });
          return;
        }

        resolve({ authenticated: false, email: null, method: null, error: 'Not logged in' });
      });

      childProcess.on('error', () => {
        if (processCompleted) {
          return;
        }
        processCompleted = true;
        clearTimeout(timeout);

        resolve({
          authenticated: false,
          email: null,
          method: null,
          error: 'Cursor CLI not found or not installed',
        });
      });
    });
  }
}
