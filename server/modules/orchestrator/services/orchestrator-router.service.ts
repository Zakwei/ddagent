import type {
  LLMProvider,
  OrchestratorCandidate,
  OrchestratorConfig,
  OrchestratorRoutingDecision,
  OrchestratorTaskType,
  QuotaAccount,
} from '@/shared/types.js';

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

const TASK_TYPES: OrchestratorTaskType[] = [
  'plan',
  'quick',
  'research',
  'docs',
  'code',
  'code-hard',
  'test',
  'review',
  'gate',
];

/**
 * Slash-prefix → task type. An explicit prefix in the composer always wins
 * over keyword heuristics.
 */
const SLASH_TYPES: Record<string, OrchestratorTaskType> = {
  plan: 'plan',
  quick: 'quick',
  ask: 'quick',
  research: 'research',
  docs: 'docs',
  code: 'code',
  test: 'test',
  review: 'review',
};

const KEYWORD_RULES: Array<[OrchestratorTaskType, RegExp]> = [
  ['review', /\b(review|przegląd|audyt|audit|sprawdź|check)\b/i],
  ['research', /\b(research|find out|explore|investigate|search|poszukaj|research)\b/i],
  ['docs', /\b(document|docs|dokumentacj|readme|changelog|opisz)\b/i],
  ['test', /\b(test|tests|coverage|napraw test|fix test)\b/i],
  [
    'code-hard',
    /\b(refactor|rearchitect|migrat|rewrite|przepisz|przenieś|przebuduj)\b/i,
  ],
  ['code', /\b(implement|fix|add|create|build|napraw|dodaj|zrobić|zrób|napisz|zmień)\b/i],
];

/**
 * Classifies one user message into a task type. Order of precedence: explicit
 * `taskType` hint from the composer chip → `/type` slash prefix → keyword
 * heuristics → `quick` (the cheapest lane is the safe default for chatter).
 */
export function classifyTaskType(
  content: string,
  hint?: string | null,
): OrchestratorTaskType {
  // `gate` is excluded on purpose: it executes the prompt as a shell command,
  // so it may only originate from a plan/template — never from a hint that
  // would turn raw user text into a command.
  if (hint && hint !== 'gate' && TASK_TYPES.includes(hint as OrchestratorTaskType)) {
    return hint as OrchestratorTaskType;
  }
  const trimmed = content.trim();
  const slash = trimmed.match(/^\/([a-z-]+)\s/i);
  if (slash && SLASH_TYPES[slash[1].toLowerCase()]) {
    return SLASH_TYPES[slash[1].toLowerCase()];
  }
  for (const [type, pattern] of KEYWORD_RULES) {
    if (pattern.test(trimmed)) return type;
  }
  return 'quick';
}

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
  if (candidate.provider !== 'opencode') return { section: candidate.provider };
  const m = candidate.model.toLowerCase();
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
 * fail-open, like an account absent from the snapshot.
 */
function isSectionExhausted(
  section: string,
  accounts: QuotaAccount[] | null,
  label?: RegExp,
): boolean {
  if (!accounts) return false;
  const account = accounts.find((entry) => entry.provider === section);
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
    if (section !== 'byok' && isSectionExhausted(section, deps.availability.accounts, label)) {
      rejected.push(`${candidate.id}: ${section} quota exhausted`);
      return { ok: false, reason: 'quota exhausted' };
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
          alternatives: viableList.slice(1).map((c) => c.id),
        },
      };
    },
  };
}
