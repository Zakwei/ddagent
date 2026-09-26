import type { LLMProvider } from '../types/app';
import type { QuotaSnapshot } from '../components/quota/types';

export type UsageWindow = { status: string; percent: number; resetsAt: string | null };
export type SubscriptionInfo = { plan: string; windows?: Record<string, UsageWindow>; error?: string };
export type UsageResponse = Record<string, SubscriptionInfo | undefined>;

/**
 * Maps the `/api/quota` snapshot onto the per-section shape the model pickers
 * filter on. An account counts as subscribed only when its last sync was
 * `active`; `inactive`/`error` mark the section unavailable like the old
 * plugin's `error` field did.
 */
export const usageFromQuotaSnapshot = (snapshot: QuotaSnapshot): UsageResponse =>
  Object.fromEntries(
    snapshot.accounts.map((account) => [
      account.provider,
      {
        plan: account.plan,
        error: account.status === 'active' ? undefined : (account.syncError ?? 'no subscription'),
        windows: Object.fromEntries(
          account.windows.map((w) => [w.label, { status: w.status, percent: w.percent, resetsAt: w.resetsAt }]),
        ),
      },
    ]),
  );

/**
 * Which subscription sections can back a provider. A provider is offered only
 * when at least one of its sections is subscribed; `claude`/`cursor`/`codex`
 * have no section of their own, so they disappear once a snapshot exists.
 */
export const PROVIDER_SECTIONS: Record<LLMProvider, string[]> = {
  claude: [],
  cursor: [],
  codex: [],
  opencode: ['opencode', 'commandcode', 'gemini'],
  devin: ['devin'],
  // Auto delegates to whichever subscription the router picks; the devin
  // section stands in as the availability signal for offering it at all.
  orchestrator: ['devin'],
};

// provider/model id (np. "google/antigravity-gemini-3.8-flash") → sekcja /usage
// 'byok' = custom provider skonfigurowany w opencode własnym kluczem API —
// nie jest objęty żadną sekcją subskrypcji, więc musi zostać dostępny zawsze.
export const sectionForModel = (model?: string | null): string | null => {
  if (!model) return null;
  const m = model.toLowerCase();
  if (m.startsWith('google/') || m.includes('antigravity')) return 'gemini';
  if (m.startsWith('commandcode/')) return 'commandcode';
  if (m.startsWith('opencode/') || m.startsWith('opencode-go/')) return 'opencode';
  if (m.startsWith('nvidia/')) return 'byok';
  return null;
};

export const isActiveSection = (usage: UsageResponse | null, section: string): boolean => {
  if (section === 'byok') return true;
  const subscription = usage?.[section];
  return Boolean(subscription && !subscription.error);
};

/**
 * A snapshot is unknown (quota endpoint down, first paint) → filter nothing.
 * Free-tier models also bypass section gating: they only need the provider's
 * auth, not a subscription (e.g. OpenCode Zen free works without Go).
 */
export const isModelAvailableIn = (
  usage: UsageResponse | null,
  provider: LLMProvider,
  model?: string | null,
  tier?: 'free' | 'paid' | null,
): boolean => !usage || tier === 'free' || isActiveSection(usage, sectionForModel(model) ?? provider);

export const isProviderAvailableIn = (
  usage: UsageResponse | null,
  provider: LLMProvider,
): boolean => !usage || PROVIDER_SECTIONS[provider].some((section) => isActiveSection(usage, section));
