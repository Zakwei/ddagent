import { providerRegistry } from '@/modules/providers/provider.registry.js';
import { readOptionalString, type LLMProvider, type ProviderAuthStatus } from '@/shared/index.js';

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
    };
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
