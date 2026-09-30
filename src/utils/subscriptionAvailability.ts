import type { LLMProvider } from '../types/app';
import type { QuotaSnapshot, QuotaWindowKind } from '../components/quota/types';

export type UsageWindow = { status: string; percent: number; resetsAt: string | null; kind?: QuotaWindowKind };
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
          account.windows.map((w) => [w.label, { status: w.status, percent: w.percent, resetsAt: w.resetsAt, kind: w.kind }]),
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

// Okna limitów w kolejności: 5h/dzienny/tygodniowy/miesięczny — kolejność segmentów w badge.
export const PERIOD_KINDS: QuotaWindowKind[] = ['session', 'daily', 'weekly', 'monthly'];

// Krótkie oznaczenie okna w badge (5h/D/W/M).
export const PERIOD_LETTER: Partial<Record<QuotaWindowKind, string>> = {
  session: '5h',
  daily: 'D',
  weekly: 'W',
  monthly: 'M',
};

export type PeriodSegment = { kind: QuotaWindowKind; percent: number; resetsAt: string | null };

/**
 * Zwraca obecne okna okresowe w kolejności PERIOD_KINDS, z ich procentem.
 * Okna bez rozpoznanego `kind` (np. etykiety „5h") są pomijane.
 */
export const sectionPeriodWindows = (
  windows: SubscriptionInfo['windows'],
  filter?: (label: string) => boolean,
): PeriodSegment[] => {
  const byKind = new Map<QuotaWindowKind, { percent: number; resetsAt: string | null }>();
  for (const [label, w] of Object.entries(windows ?? {})) {
    if (w.kind && PERIOD_KINDS.includes(w.kind) && (!filter || filter(label))) {
      byKind.set(w.kind, { percent: w.percent, resetsAt: w.resetsAt });
    }
  }
  return PERIOD_KINDS.filter((kind) => byKind.has(kind)).map((kind) => ({ kind, ...byKind.get(kind)! }));
};

// Pełna długość okna okresowego — do liczenia, ile czasu zostało do resetu.
export const PERIOD_DURATION_MS: Partial<Record<QuotaWindowKind, number>> = {
  session: 5 * 60 * 60 * 1000,
  daily: 24 * 60 * 60 * 1000,
  weekly: 7 * 24 * 60 * 60 * 1000,
  monthly: 30 * 24 * 60 * 60 * 1000,
};

/**
 * Ile procent czasu okna zostało do jego resetu (100% = tuż po resecie,
 * 0% = tuż przed). `null`, gdy brakuje `resetsAt` albo nie znamy długości okna.
 */
export const timeRemainingPercent = (
  kind: QuotaWindowKind,
  resetsAt: string | null,
  now: number = Date.now(),
): number | null => {
  const total = PERIOD_DURATION_MS[kind];
  const resetMs = Date.parse(resetsAt ?? '');
  if (!total || !Number.isFinite(resetMs)) return null;
  const remaining = resetMs - now;
  if (remaining <= 0) return 0;
  return Math.max(0, Math.min(100, (remaining / total) * 100));
};

// Progi „za mało czasu do resetu" (% pozostałego czasu): ≤25% pomarańcz, ≤10% czerwony.
export const TIME_WATCH_PERCENT = 25;
export const TIME_DANGER_PERCENT = 10;

export type TimeTone = 'ok' | 'warn' | 'critical';

/** Kolor pigułki zależny od pozostałego czasu okna, nie od zużycia. */
export const timeToneFor = (remainingPercent: number | null): TimeTone =>
  remainingPercent === null
    ? 'ok'
    : remainingPercent <= TIME_DANGER_PERCENT
      ? 'critical'
      : remainingPercent <= TIME_WATCH_PERCENT
        ? 'warn'
        : 'ok';
