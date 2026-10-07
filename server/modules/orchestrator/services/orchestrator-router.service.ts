import type {
  LLMProvider,
  OrchestratorCandidate,
  OrchestratorConfig,
  OrchestratorRoutingDecision,
  OrchestratorTaskType,
  QuotaAccount,
} from '@/shared/index.js';
import { classifyTaskType } from '@/shared/index.js';

/** Re-exported so existing router consumers/tests keep importing it from here. */
export { classifyTaskType };

/**
 * One row of per-provider subscription state the router filters on. Derived
 * from the quota snapshot's QuotaAccount list; `null` snapshot = unknown =
 * fail-open (same contract as the client useSubscriptionUsage hook).
 */
export type RouterAvailability = {
  isRuntimeAvailable(provider: LLMProvider): boolean;
  /** Accounts from the latest quota snapshot; null when never fetched. */
  accounts: QuotaAccount[] | null;
};

export type RouteResult =
  | { ok: true; decision: OrchestratorRoutingDecision; candidate: OrchestratorCandidate }
  | { ok: false; reason: string; alternatives: OrchestratorCandidate[] };

/**
 * Maps a candidate onto the quota check that actually bills it. OpenCode
 * routes several subscriptions through one provider id — `google/*` and
 * antigravity models draw from the Gemini plan, `commandcode/*` from
 * CommandCode, `nvidia/*` is BYOK with no subscription section at all.
 * Mirrors the client's `sectionForModel` in subscriptionAvailability.ts.
 *
 * Antigravity splits its plan into two pools surfaced as window labels:
 * 'Gemini Models' (`gemini-*` buckets) and 'Claude and GPT models'
 * (`3p-*` buckets). Claude/GPT antigravity models must only check the
 * non-gemini windows — the pools exhaust independently.
 */
function quotaCheckFor(candidate: OrchestratorCandidate): { section: string; label?: RegExp } {
  const m = candidate.model.toLowerCase();
  if (candidate.provider === 'antigravity') {
    return { section: 'gemini', label: /claude|gpt/i.test(m) ? /Claude and GPT/ : /Gemini Models/ };
  }
  if (candidate.provider === 'claude') {
    // Global windows always apply; a scoped weekly limit only applies to its model.
    const label = /sonnet/i.test(m) ? /^(5h|Weekly|Sonnet · Weekly)$/
      : /opus/i.test(m) ? /^(5h|Weekly|Opus · Weekly)$/
        : /fable/i.test(m) ? /^(5h|Weekly|Fable · Weekly)$/ : /^(5h|Weekly)$/;
    return { section: 'claude', label };
  }
  if (candidate.provider !== 'opencode') return { section: candidate.provider };
  if (m.startsWith('google/') || m.includes('antigravity')) {
    const label = /claude|gpt/i.test(m) ? /Claude and GPT/ : /Gemini Models/;
    return { section: 'gemini', label };
  }
  if (m.startsWith('commandcode/')) return { section: 'commandcode' };
  if (m.startsWith('nvidia/')) return { section: 'byok' };
  return { section: 'opencode' };
}

/**
 * A quota section counts as exhausted when its windows report no headroom
 * or an exceeded status. `label` narrows the check to a sub-pool (the two
 * Antigravity buckets); when it matches no windows the state is unknown —
 * fail-open, like an account absent from the snapshot. `accountId` scopes
 * the section to one provider_accounts row — a candidate pinned to account
 * A is unaffected by account B's exhaustion (old snapshots lack the field,
 * so both sides normalize to null).
 */
function isSectionExhausted(
  section: string,
  accounts: QuotaAccount[] | null,
  label?: RegExp,
  accountId?: string | null,
): boolean {
  if (!accounts) return false;
  const account = accounts.find(
    (entry) => entry.provider === section && (entry.accountId ?? null) === (accountId ?? null),
  );
  if (!account || account.status === 'error') return false;
  if (account.status === 'inactive') return true;
  const windows = label
    ? account.windows.filter((window) => label.test(window.label))
    : account.windows;
  if (windows.length === 0) return false;
  return windows.some(
    (window) => window.remainingPercent <= 0 || window.status === 'exceeded',
  );
}

export type OrchestratorRouter = {
  classify(content: string, hint?: string | null): OrchestratorTaskType;
  /**
   * `excluded` carries the run-scoped circuit-breaker set: candidate ids the
   * executor cooled down after quota/auth failures (or an exhausted
   * rate-limit budget) must not win again this run.
   */
  route(taskType: OrchestratorTaskType, excluded?: ReadonlySet<string>): RouteResult;
};

/**
 * Deterministic candidate picker. For a task type it walks the configured
 * rule list in order and returns the first candidate whose runtime is
 * available and whose provider account still has quota headroom. The whole
 * pool is user-configured — the router never invents candidates.
 */
export function createOrchestratorRouterService(deps: {
  getConfig(): OrchestratorConfig;
  availability: RouterAvailability;
}): OrchestratorRouter {
  function viable(
    candidate: OrchestratorCandidate,
    rejected: string[],
    excluded?: ReadonlySet<string>,
  ): { ok: boolean; reason?: string } {
    if (excluded?.has(candidate.id)) {
      rejected.push(`${candidate.id}: cooling down`);
      return { ok: false, reason: 'cooling down' };
    }
    if (!deps.availability.isRuntimeAvailable(candidate.provider)) {
      rejected.push(`${candidate.id}: runtime unavailable`);
      return { ok: false, reason: 'runtime unavailable' };
    }
    // Free lanes (SWE-2, zen/laguna free tiers) and own-keyed models draw no
    // subscription quota — the only thing that can stop them is a rate
    // limit, which the executor's retry loop absorbs.
    if (candidate.tier === 'free') return { ok: true };
    const { section, label } = quotaCheckFor(candidate);
    if (section !== 'byok') {
      // Redundant operation: the candidate stays viable while at least one of
      // its accounts (primary + ordered fallbacks) still has headroom — the
      // executor tries them in order and skips the exhausted ones.
      const accountIds: Array<string | null> = [candidate.accountId, ...candidate.fallbackAccountIds];
      const exhausted = accountIds.every((accountId) =>
        isSectionExhausted(section, deps.availability.accounts, label, accountId),
      );
      if (exhausted) {
        rejected.push(`${candidate.id}: ${section} quota exhausted`);
        return { ok: false, reason: 'quota exhausted' };
      }
    }
    return { ok: true };
  }

  return {
    classify: classifyTaskType,

    route(taskType: OrchestratorTaskType, excluded?: ReadonlySet<string>): RouteResult {
      const config = deps.getConfig();
      const orderedIds = config.rules[taskType] ?? [];
      const byId = new Map(config.pool.map((c) => [c.id, c]));
      const rejected: string[] = [];
      const viableList: OrchestratorCandidate[] = [];

      for (const id of orderedIds) {
        const cand = byId.get(id);
        if (!cand) {
          rejected.push(`${id}: not in pool`);
          continue;
        }
        const check = viable(cand, rejected, excluded);
        if (check.ok) {
          viableList.push(cand);
        }
      }

      const winner = viableList[0];
      if (!winner) {
        return {
          ok: false,
          reason:
            rejected.length === 0
              ? `No candidates configured for task type "${taskType}".`
              : `No viable candidate for "${taskType}": ${rejected.join('; ')}`,
          alternatives: [],
        };
      }

      const effort =
        winner.effort ??
        winner.model.match(/-(low|medium|high|max|xhigh|minimal|none)$/)?.[1] ??
        null;
      return {
        ok: true,
        candidate: winner,
        decision: {
          taskType,
          candidateId: winner.id,
          provider: winner.provider,
          model: winner.model,
          effort,
          reason:
            rejected.length === 0
              ? `${winner.label} — first candidate for ${taskType}`
              : `${winner.label} — earlier candidates skipped (${rejected.join('; ')})`,
          label: winner.label,
          rejected: [...rejected],
          alternatives: viableList.slice(1).map((c) => c.id),
        },
      };
    },
  };
}
