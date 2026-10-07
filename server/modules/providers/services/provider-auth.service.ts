import { providerRegistry } from '@/modules/providers/provider.registry.js';
import { readOptionalString, type LLMProvider, type ProviderAuthStatus } from '@/shared/index.js';
import { AppError } from '@/shared/utils.js';

/** Used by provider routes and runtime checks to obtain fresh, safe login state. */
export const providerAuthService = {
  /**
   * Resolves a provider and returns its installation/authentication status.
   */
  async getProviderAuthStatus(providerName: string): Promise<ProviderAuthStatus> {
    const provider = providerRegistry.resolveProvider(providerName);
    const status = await provider.auth.getStatus();
    // Explicit null replaces old client state, even if an adapter retains metadata.
    return {
      ...status,
      email: status.authenticated ? readOptionalString(status.email) ?? null : null,
      canLogout: typeof provider.auth.logout === 'function',
    };
  },

  /**
   * Clears a provider's stored credentials and returns the resulting status.
   *
   * Consumed by the settings "Log out" action. Providers that do not implement
   * `IProviderAuth.logout` (environment/keyring-only logins) are rejected so
   * the client can report that logout is unavailable instead of silently
   * reporting success.
   */
  async logoutProvider(providerName: string): Promise<ProviderAuthStatus> {
    const provider = providerRegistry.resolveProvider(providerName);
    if (typeof provider.auth.logout !== 'function') {
      throw new AppError(`Provider "${provider.id}" does not support logging out.`, {
        code: 'LOGOUT_UNSUPPORTED',
        statusCode: 501,
      });
    }
    await provider.auth.logout();
    return this.getProviderAuthStatus(providerName);
  },

  /**
   * Returns whether a provider runtime appears installed.
   * Falls back to true if status lookup itself fails so callers preserve the
   * original runtime error instead of replacing it with a status-check failure.
   */
  async isProviderInstalled(providerName: LLMProvider): Promise<boolean> {
    try {
      const status = await this.getProviderAuthStatus(providerName);
      return status.installed;
    } catch {
      return true;
    }
  },
};
