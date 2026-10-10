import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';

import { appConfigDb, providerAccountsDb, sessionsDb, type ProviderAccount } from '@/modules/database/index.js';
import type { LLMProvider, QuotaAccount, QuotaWindow } from '@/shared/types.js';

/** app_config key holding the per-provider auto-switch preference (`{ providers: { claude: true } }`). */
const FAILOVER_SETTINGS_KEY = 'provider_accounts.failover';

/** How long a limit hit with no parseable reset time keeps an account out of rotation. */
const USAGE_LIMIT_COOLDOWN_MS = 60 * 60 * 1000;

/** Plain request throttling (HTTP 429, "too many requests") clears much sooner. */
const RATE_LIMIT_COOLDOWN_MS = 15 * 60 * 1000;

/** Error text that means the account itself ran out (subscription/quota windows). */
const USAGE_LIMIT_ERROR_PATTERN =
  /usage limit|hit your (usage )?limit|(usage|5-hour|weekly|daily|monthly|session|plan|subscription|credit) limit (reached|exceeded)|exceeded your (current )?(quota|usage)|quota (exceeded|exhausted)|resource.?exhausted|out of (credits|quota)|insufficient (credits|quota)/i;

/** Error text that means request throttling: still worth moving off the account, but briefly. */
const RATE_LIMIT_ERROR_PATTERN = /rate.?limit|too many requests|\b429\b/i;

/**
 * Some CLIs (Claude Code) report the limit as the assistant's reply instead of
 * an error, so plain text is matched too — but only short messages that
 * START with the CLI's own limit banner, never a model answer that merely
 * talks about limits.
 */
const USAGE_LIMIT_TEXT_PATTERN =
  /^\s*(claude ai usage limit reached|you['’]?ve (hit|reached) your ((usage|session|weekly|daily|5-hour|opus|sonnet) )?limit|[\w -]{0,24}limit reached\s*[·∙|]|api error: 429\b)/i;

const MAX_LIMIT_TEXT_LENGTH = 400;

/** Automatic "continue" turns allowed per session within CONTINUATION_WINDOW_MS (loop guard). */
const MAX_AUTO_CONTINUATIONS = 3;
const CONTINUATION_WINDOW_MS = 60 * 60 * 1000;

/** Options that belong to the interrupted turn only and must not ride into the continuation. */
const TURN_ONLY_OPTION_KEYS = ['attachments', 'images', 'files', 'inboxSource', 'accountId'];

type AccountFailoverSettings = {
  /** Move a session to another account of the same provider when its account hits a limit. */
  autoSwitchOnLimit: boolean;
};

/** Stored shape: each agent opts in separately; absent means off. */
type StoredFailoverSettings = { providers?: Record<string, boolean> };

/** A limit reading pulled from one runtime event. */
type UsageLimitHit = {
  /** When the provider says the limit lifts, or null when the text names no time. */
  resetAt: number | null;
  /** Throttling rather than an exhausted subscription window. */
  transient: boolean;
};

/** One completed account move; `null` ids mean the provider's ambient login. */
type AccountSwitch = {
  /** `limit`: the account ran out; `near-limit`: it moved early, on the provider's warning. */
  reason: 'limit' | 'near-limit';
  fromAccountId: string | null;
  fromLabel: string;
  toAccountId: string | null;
  toLabel: string;
};

/** The session a turn is about to run (or just ran) for. */
type SessionTurnInput = {
  sessionId: string;
  provider: LLMProvider;
  accountId: string | null;
  providerSessionId: string | null;
  model: string | null;
};

type CarryOverInput = {
  provider: LLMProvider;
  providerSessionId: string;
  fromEnv: Record<string, string>;
  toEnv: Record<string, string>;
};

type AccountFailoverDependencies = {
  store: { get(key: string): string | null; set(key: string, value: string): void };
  listAccounts(provider: LLMProvider): ProviderAccount[];
  setSessionAccount(sessionId: string, accountId: string | null): void;
  /** Latest quota sweep without forcing a provider read; null before the first sweep. */
  readQuotaAccounts(): Promise<QuotaAccount[] | null>;
  /** Asks for a fresh quota sweep after a limit hit (fire-and-forget). */
  refreshQuota(): void;
  /**
   * Copies the provider-native conversation into the target account's store
   * so the next turn can resume it. Returns false when the provider cannot
   * carry a conversation over (the session then stays on its account).
   */
  carryOverConversation(input: CarryOverInput): boolean;
  /**
   * Queues a follow-up turn for the session (sent as soon as it is idle).
   * Resolves false when it was not queued — e.g. the user already has
   * messages waiting, which resume the work on their own.
   */
  queueContinuation(input: ContinuationInput): Promise<boolean>;
  now(): number;
};

type ContinuationInput = {
  sessionId: string;
  userId: string | number | null;
  content: string;
  options: Record<string, unknown>;
};

/** Quota snapshot section a provider's account readings are filed under. */
function quotaSectionFor(provider: LLMProvider): string {
  return provider === 'antigravity' ? 'gemini' : provider;
}

/**
 * Whether a quota window constrains the session's model. Model-scoped windows
 * ("Opus · Weekly") only bind that model; the Antigravity pools split
 * Claude/GPT from Gemini models. Everything else is account-wide.
 */
function windowAppliesToModel(window: QuotaWindow, model: string): boolean {
  const normalizedModel = model.toLowerCase();
  const scoped = window.label.split(/\s*·\s*/);
  if (scoped.length > 1) {
    return normalizedModel.length > 0 && normalizedModel.includes(scoped[0].trim().toLowerCase());
  }
  if (/claude and gpt/i.test(window.label)) return /claude|gpt/.test(normalizedModel);
  if (/gemini models/i.test(window.label)) return !/claude|gpt/.test(normalizedModel);
  return true;
}

function isWindowExhausted(window: QuotaWindow): boolean {
  return window.remainingPercent <= 0 || window.status === 'exceeded';
}

/** Account's quota reading for this provider, or undefined when the sweep has none. */
function quotaEntryFor(
  accounts: QuotaAccount[] | null,
  provider: LLMProvider,
  accountId: string | null,
): QuotaAccount | undefined {
  const section = quotaSectionFor(provider);
  return accounts?.find(
    (entry) => entry.provider === section && (entry.accountId ?? null) === accountId,
  );
}

/** Root of a CLI's config store under one account's env (ambient when unset). */
function configRoot(envKey: string, env: Record<string, string>, fallbackDir: string): string {
  const configured = env[envKey]?.trim() || process.env[envKey]?.trim();
  return configured ? configured : path.join(os.homedir(), fallbackDir);
}

/** Finds `<root>/<one subdir>/<name>` — Claude files transcripts per encoded cwd. */
function findInSubdirectories(root: string, name: string): string | null {
  let entries: fs.Dirent[];
  try {
    entries = fs.readdirSync(root, { withFileTypes: true });
  } catch {
    return null;
  }
  for (const entry of entries) {
    if (!entry.isDirectory()) continue;
    const candidate = path.join(root, entry.name, name);
    if (fs.existsSync(candidate)) return candidate;
  }
  return null;
}

/** Depth-limited search for a Codex rollout file (`sessions/YYYY/MM/DD/rollout-…-<id>.jsonl`). */
function findCodexRollout(directory: string, providerSessionId: string, depth: number): string | null {
  let entries: fs.Dirent[];
  try {
    entries = fs.readdirSync(directory, { withFileTypes: true });
  } catch {
    return null;
  }
  for (const entry of entries) {
    const entryPath = path.join(directory, entry.name);
    if (entry.isFile() && entry.name.startsWith('rollout-') && entry.name.endsWith(`${providerSessionId}.jsonl`)) {
      return entryPath;
    }
    if (entry.isDirectory() && depth > 0) {
      const found = findCodexRollout(entryPath, providerSessionId, depth - 1);
      if (found) return found;
    }
  }
  return null;
}

/** Copies `source` (a file or directory) to the same relative spot under another root. */
function copyRelative(source: string, fromRoot: string, toRoot: string): void {
  const target = path.join(toRoot, path.relative(fromRoot, source));
  fs.mkdirSync(path.dirname(target), { recursive: true });
  fs.cpSync(source, target, { recursive: true, force: true });
}

/**
 * Production carry-over. Claude and Codex keep each conversation as files in
 * the account's config dir, so the session's transcript (plus Claude's
 * per-session sidecar dir: subagents, tool results) is copied across and the
 * CLI resumes it by id. Other providers hold conversations in opaque
 * per-account stores (sqlite, server state) and cannot move.
 *
 * Exported for the provider-accounts tests, which run it against temp dirs.
 */
export function carryOverConversationOnDisk(input: CarryOverInput): boolean {
  const { provider, providerSessionId, fromEnv, toEnv } = input;
  try {
    if (provider === 'claude') {
      const fromRoot = configRoot('CLAUDE_CONFIG_DIR', fromEnv, '.claude');
      const toRoot = configRoot('CLAUDE_CONFIG_DIR', toEnv, '.claude');
      if (path.resolve(fromRoot) === path.resolve(toRoot)) return true;
      const transcript = findInSubdirectories(path.join(fromRoot, 'projects'), `${providerSessionId}.jsonl`);
      if (!transcript) return false;
      copyRelative(transcript, fromRoot, toRoot);
      const sidecar = transcript.slice(0, -'.jsonl'.length);
      if (fs.existsSync(sidecar)) copyRelative(sidecar, fromRoot, toRoot);
      return true;
    }
    if (provider === 'codex') {
      const fromRoot = configRoot('CODEX_HOME', fromEnv, '.codex');
      const toRoot = configRoot('CODEX_HOME', toEnv, '.codex');
      if (path.resolve(fromRoot) === path.resolve(toRoot)) return true;
      const rollout = findCodexRollout(path.join(fromRoot, 'sessions'), providerSessionId, 4);
      if (!rollout) return false;
      copyRelative(rollout, fromRoot, toRoot);
      return true;
    }
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    console.warn('[account-failover] could not carry the conversation over', { provider, error: message });
  }
  return false;
}

/**
 * Used below for the production instance and by the provider-accounts tests
 * with injected stores, quota and clock.
 *
 * Auto-switch keeps a session running when its provider account hits a usage
 * limit: before each turn the session's account is checked against the quota
 * sweep and against limit errors seen at runtime, and an exhausted account is
 * swapped for another account OF THE SAME PROVIDER with headroom — never for
 * a different agent. The user's manual pick is overridden only while it is
 * exhausted, and only when the user enabled the setting for that agent.
 */
export function createAccountFailoverService(dependencies: AccountFailoverDependencies) {
  /** `${provider}:${accountId}` → epoch ms until which a runtime limit hit benches the account. */
  const limitedUntil = new Map<string, number>();
  const limitKey = (provider: LLMProvider, accountId: string | null) => `${provider}:${accountId ?? ''}`;
  /** Same key → epoch ms until which the provider warned the account is close to its limit. */
  const nearLimitUntil = new Map<string, number>();
  /** sessionId → epoch ms of its recent automatic continuations. */
  const continuations = new Map<string, number[]>();

  /** Whether `marks` benches the account right now; expired marks are dropped. */
  function isMarked(marks: Map<string, number>, provider: LLMProvider, accountId: string | null): boolean {
    const key = limitKey(provider, accountId);
    const until = marks.get(key);
    if (until === undefined) return false;
    if (until > dependencies.now()) return true;
    marks.delete(key);
    return false;
  }

  const isMarkedLimited = (provider: LLMProvider, accountId: string | null) =>
    isMarked(limitedUntil, provider, accountId);
  const isMarkedNearLimit = (provider: LLMProvider, accountId: string | null) =>
    isMarked(nearLimitUntil, provider, accountId);

  function readStored(): Record<string, boolean> {
    try {
      const raw = dependencies.store.get(FAILOVER_SETTINGS_KEY);
      const parsed = raw ? (JSON.parse(raw) as StoredFailoverSettings) : {};
      return parsed.providers && typeof parsed.providers === 'object' ? parsed.providers : {};
    } catch {
      return {};
    }
  }

  /** One agent's preference — each agent's accounts opt in on their own. */
  function getSettings(provider: LLMProvider): AccountFailoverSettings {
    return { autoSwitchOnLimit: readStored()[provider] === true };
  }

  /**
   * Exhausted per the quota sweep: an `inactive` plan, or a window binding the
   * session's model with no headroom. Unknown (no reading, sync error) is not
   * exhausted — the turn runs and a real limit error decides.
   */
  function isQuotaExhausted(entry: QuotaAccount | undefined, model: string): boolean {
    if (!entry || entry.status === 'error') return false;
    if (entry.status === 'inactive') return true;
    return entry.windows.some((window) => windowAppliesToModel(window, model) && isWindowExhausted(window));
  }

  /** Highest usage over the windows binding the model — lower is a better target. */
  function usedPercent(entry: QuotaAccount, model: string): number {
    const percents = entry.windows
      .filter((window) => windowAppliesToModel(window, model))
      .map((window) => window.percent);
    return percents.length > 0 ? Math.max(...percents) : 0;
  }

  /**
   * Next account to move the session to, best headroom first. Every option
   * must be a confirmed, working login of the same provider (an active quota
   * reading) — except before the first quota sweep, when configured account
   * rows are tried in their saved order (default first). Accounts the
   * provider warned about are a last resort, and skipped entirely for an
   * early (`near-limit`) move — trading one warned account for another only
   * ping-pongs the session.
   */
  function pickTarget(
    provider: LLMProvider,
    currentAccountId: string | null,
    model: string,
    quota: QuotaAccount[] | null,
    reason: AccountSwitch['reason'],
  ): { accountId: string | null; label: string; env: Record<string, string> } | null {
    const fresh = pickTargetAmong(provider, currentAccountId, model, quota, false);
    if (fresh || reason === 'near-limit') return fresh;
    return pickTargetAmong(provider, currentAccountId, model, quota, true);
  }

  function pickTargetAmong(
    provider: LLMProvider,
    currentAccountId: string | null,
    model: string,
    quota: QuotaAccount[] | null,
    includeNearLimit: boolean,
  ): { accountId: string | null; label: string; env: Record<string, string> } | null {
    const rows = dependencies.listAccounts(provider);
    const options: Array<{ accountId: string | null; label: string; env: Record<string, string> }> = [
      { accountId: null, label: '', env: {} },
      ...rows.map((row) => ({ accountId: row.id, label: row.label, env: row.envOverrides })),
    ].filter((option) => option.accountId !== currentAccountId
      && !isMarkedLimited(provider, option.accountId)
      && (includeNearLimit || !isMarkedNearLimit(provider, option.accountId)));

    if (!quota) {
      const rowOptions = options.filter((option) => option.accountId !== null);
      rowOptions.sort((a, b) => Number(rows.find((row) => row.id === b.accountId)?.isDefault ?? false)
        - Number(rows.find((row) => row.id === a.accountId)?.isDefault ?? false));
      return rowOptions[0] ?? null;
    }

    const ranked = options
      .map((option) => ({ option, entry: quotaEntryFor(quota, provider, option.accountId) }))
      .filter((candidate): candidate is { option: typeof options[number]; entry: QuotaAccount } =>
        candidate.entry !== undefined
        && candidate.entry.status === 'active'
        && !isQuotaExhausted(candidate.entry, model))
      .sort((a, b) => usedPercent(a.entry, model) - usedPercent(b.entry, model));
    if (ranked.length === 0) return null;
    const best = ranked[0];
    return { ...best.option, label: best.option.label || best.entry.accountLabel || best.entry.accountEmail };
  }

  /** Label of the account a session is leaving, for the user-facing notice. */
  function labelOf(provider: LLMProvider, accountId: string | null, quota: QuotaAccount[] | null): string {
    if (accountId) {
      const row = dependencies.listAccounts(provider).find((candidate) => candidate.id === accountId);
      if (row) return row.label;
    }
    const entry = quotaEntryFor(quota, provider, accountId);
    return entry?.accountLabel || entry?.accountEmail || '';
  }

  /** Moves the session to `target`, carrying its conversation over first. */
  function switchSession(
    input: SessionTurnInput,
    target: { accountId: string | null; label: string; env: Record<string, string> },
    quota: QuotaAccount[] | null,
    reason: AccountSwitch['reason'],
  ): AccountSwitch | null {
    if (input.providerSessionId) {
      const fromEnv = input.accountId
        ? dependencies.listAccounts(input.provider).find((row) => row.id === input.accountId)?.envOverrides ?? {}
        : {};
      const carried = dependencies.carryOverConversation({
        provider: input.provider,
        providerSessionId: input.providerSessionId,
        fromEnv,
        toEnv: target.env,
      });
      if (!carried) return null;
    }
    dependencies.setSessionAccount(input.sessionId, target.accountId);
    return {
      reason,
      fromAccountId: input.accountId,
      fromLabel: labelOf(input.provider, input.accountId, quota),
      toAccountId: target.accountId,
      toLabel: target.label,
    };
  }

  return {
    getSettings,

    updateSettings(provider: LLMProvider, patch: Partial<AccountFailoverSettings>): AccountFailoverSettings {
      if (typeof patch.autoSwitchOnLimit === 'boolean') {
        const stored: StoredFailoverSettings = {
          providers: { ...readStored(), [provider]: patch.autoSwitchOnLimit },
        };
        dependencies.store.set(FAILOVER_SETTINGS_KEY, JSON.stringify(stored));
      }
      return getSettings(provider);
    },

    /**
     * Reads a usage/rate-limit hit out of one runtime event, or null. `error`
     * events match broadly; `text` events only when they are a short CLI
     * limit banner (see USAGE_LIMIT_TEXT_PATTERN).
     */
    detectLimit(kind: string | undefined, text: string): UsageLimitHit | null {
      if (!text) return null;
      let transient = false;
      if (kind === 'error') {
        if (USAGE_LIMIT_ERROR_PATTERN.test(text)) transient = false;
        else if (RATE_LIMIT_ERROR_PATTERN.test(text)) transient = true;
        else return null;
      } else if (kind === 'text') {
        if (text.length > MAX_LIMIT_TEXT_LENGTH || !USAGE_LIMIT_TEXT_PATTERN.test(text)) return null;
      } else {
        return null;
      }
      // Claude Code: "Claude AI usage limit reached|1760000000" (epoch seconds).
      const epoch = /\|(\d{10})\b/.exec(text);
      return { resetAt: epoch ? Number(epoch[1]) * 1000 : null, transient };
    },

    /**
     * Pre-turn check. Returns the switch it made, or null when the session
     * keeps its account (setting off, account has headroom, no other account
     * with headroom, or the conversation cannot move). An account the
     * provider warned is close to its limit is left early — before it runs
     * out mid-turn — but only for an account without a warning of its own,
     * and only when `allowEarlySwitch` (the caller withholds it while the
     * session's process still runs background work a new process would cut).
     */
    async prepareTurnAccount(
      input: SessionTurnInput,
      { allowEarlySwitch = true }: { allowEarlySwitch?: boolean } = {},
    ): Promise<AccountSwitch | null> {
      if (!getSettings(input.provider).autoSwitchOnLimit) return null;
      const model = input.model ?? '';
      const quota = await dependencies.readQuotaAccounts();
      const exhausted = isMarkedLimited(input.provider, input.accountId)
        || isQuotaExhausted(quotaEntryFor(quota, input.provider, input.accountId), model);
      const reason: AccountSwitch['reason'] | null = exhausted
        ? 'limit'
        : allowEarlySwitch && isMarkedNearLimit(input.provider, input.accountId) ? 'near-limit' : null;
      if (!reason) return null;
      const target = pickTarget(input.provider, input.accountId, model, quota, reason);
      return target ? switchSession(input, target, quota, reason) : null;
    },

    /**
     * Records the provider's warning that an account is close to its limit
     * (Claude's `allowed_warning`), until the window resets or a cooldown
     * passes. The session moves at its next turn (see prepareTurnAccount).
     */
    reportLimitWarning(input: SessionTurnInput, resetAt: number | null): void {
      const now = dependencies.now();
      nearLimitUntil.set(
        limitKey(input.provider, input.accountId),
        resetAt && resetAt > now ? resetAt : now + USAGE_LIMIT_COOLDOWN_MS,
      );
    },

    /**
     * Records a runtime limit hit so the account sits out until its reset
     * (or a cooldown), refreshes quota, and — when auto-switch is on — moves
     * the session right away so the next turn already runs elsewhere.
     */
    async reportLimitHit(input: SessionTurnInput, hit: UsageLimitHit): Promise<AccountSwitch | null> {
      const now = dependencies.now();
      const until = hit.resetAt && hit.resetAt > now
        ? hit.resetAt
        : now + (hit.transient ? RATE_LIMIT_COOLDOWN_MS : USAGE_LIMIT_COOLDOWN_MS);
      limitedUntil.set(limitKey(input.provider, input.accountId), until);
      dependencies.refreshQuota();
      if (!getSettings(input.provider).autoSwitchOnLimit) return null;
      const quota = await dependencies.readQuotaAccounts();
      const target = pickTarget(input.provider, input.accountId, input.model ?? '', quota, 'limit');
      return target ? switchSession(input, target, quota, 'limit') : null;
    },

    /**
     * After a limit cut a turn short and the session moved accounts, queues a
     * "continue" turn so the work resumes on the new account without the user
     * re-sending. Capped per session (MAX_AUTO_CONTINUATIONS per window) so a
     * misdetected limit can never loop; a turn the user aborted is never
     * continued (the caller checks that). Returns whether a turn was queued.
     */
    async continueAfterSwitch(input: {
      sessionId: string;
      userId: string | number | null;
      options: Record<string, unknown>;
      change: AccountSwitch;
    }): Promise<boolean> {
      const now = dependencies.now();
      const recent = (continuations.get(input.sessionId) ?? []).filter((at) => now - at < CONTINUATION_WINDOW_MS);
      if (recent.length >= MAX_AUTO_CONTINUATIONS) {
        continuations.set(input.sessionId, recent);
        return false;
      }
      const options = { ...input.options };
      for (const key of TURN_ONLY_OPTION_KEYS) delete options[key];
      const from = input.change.fromLabel || 'default login';
      const to = input.change.toLabel || 'default login';
      const queued = await dependencies.queueContinuation({
        sessionId: input.sessionId,
        userId: input.userId,
        content: `[ddagent] The previous turn was cut off by the usage limit on account "${from}". `
          + `The session now runs on account "${to}". Continue exactly where you left off — `
          + 'redo any tool calls or subagents that failed because of the limit.',
        options: { ...options, inboxSource: 'auto-continue' },
      });
      if (queued) recent.push(now);
      continuations.set(input.sessionId, recent);
      return queued;
    },
  };
}

/**
 * Production instance — used by the provider-accounts routes (settings) and,
 * through the barrel, by the websocket chat dispatcher (per-turn checks). Quota is imported lazily: the quota module pulls in
 * the websocket layer, which dispatches chat turns through this service.
 */
export const accountFailoverService = createAccountFailoverService({
  store: appConfigDb,
  listAccounts: (provider) => providerAccountsDb.list(provider),
  setSessionAccount: (sessionId, accountId) => sessionsDb.setSessionAccount(sessionId, accountId),
  readQuotaAccounts: async () => {
    const { quotaService } = await import('@/modules/quota/index.js');
    return quotaService.peekAccounts();
  },
  refreshQuota: () => {
    void import('@/modules/quota/index.js')
      .then(({ quotaService }) => quotaService.getSnapshot(true))
      .catch((error: unknown) => console.error('[account-failover] quota refresh failed:', error));
  },
  carryOverConversation: carryOverConversationOnDisk,
  // Lazy for the same reason as quota: the queue dispatches through the
  // websocket chat layer, which imports this service.
  queueContinuation: async ({ sessionId, userId, content, options }) => {
    const { queuedMessagesService } = await import('@/modules/queued-messages/index.js');
    if (queuedMessagesService.list(sessionId).some((message) => message.status === 'queued')) return false;
    queuedMessagesService.enqueue({ sessionId, userId, content, options });
    return true;
  },
  now: () => Date.now(),
});
