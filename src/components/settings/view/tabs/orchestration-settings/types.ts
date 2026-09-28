import type { LLMProvider } from '../../../../../types/app';

/**
 * Client mirror of the orchestrator config contract served by
 * `GET/PUT /api/orchestrator/config` (see server/shared/types.ts).
 * Kept local so this tab does not depend on server-only modules.
 */
export type OrchestratorTaskType =
  | 'plan'
  | 'quick'
  | 'research'
  | 'docs'
  | 'code'
  | 'code-hard'
  | 'test'
  | 'review'
  | 'gate';

/** Cost band of a pooled candidate; drives cheap-first ordering and UI badges. */
export type OrchestratorCostTier = 'free' | 'cheap' | 'mid' | 'premium';

/**
 * One selectable model endpoint in the orchestrator pool. `effort` carries the
 * provider's reasoning level; `accountId` pins a named provider account
 * (null = provider default environment).
 */
export type OrchestratorCandidate = {
  id: string;
  provider: LLMProvider;
  model: string;
  effort: string | null;
  accountId: string | null;
  tier: OrchestratorCostTier;
  label: string;
};

/** Named pipeline template: an ordered list of task types, no LLM planning. */
export type OrchestratorPipelineTemplate = {
  name: string;
  steps: OrchestratorTaskType[];
};

/**
 * `rules` maps each task type to an ordered list of pool candidate ids —
 * the first available candidate wins.
 */
export type OrchestratorConfig = {
  enabled: boolean;
  pool: OrchestratorCandidate[];
  rules: Record<OrchestratorTaskType, string[]>;
  planner: {
    /** Pool candidate id used for plan generation/classification calls. */
    candidateId: string;
    mode: 'auto' | 'template' | 'off';
    /** When true the plan card waits for explicit confirm before running. */
    requireConfirm: boolean;
    templates: OrchestratorPipelineTemplate[];
  };
  execution: {
    maxParallel: number;
    maxFixLoops: number;
    /** Run delegated steps in one shared git worktree per plan run. */
    useWorktree: boolean;
    /** Behaviour when every candidate in a rule is unavailable. */
    onNoCandidate: 'ask' | 'skip';
    /** Hard ceiling on total attempts for one step across lanes and retries. */
    maxAttempts: number;
    /** Per-attempt child-run timeout in ms; `0` disables. */
    stepTimeoutMs: number;
    /** Global plan-run timeout in ms; `0` disables. */
    runTimeoutMs: number;
    /** Exponential backoff base slept between same-lane retries. */
    retryBackoffBaseMs: number;
    /** Same-lane retry count per failure class before failover/cooldown. */
    retry: Record<'rate_limit' | 'quota' | 'auth' | 'timeout' | 'transient', number>;
  };
};

// 'gate' is deliberately absent: gate steps run a deterministic command, so
// they have no candidate lane and the rules-lane UI must not list them.
export const ORCHESTRATOR_TASK_TYPES: OrchestratorTaskType[] = [
  'plan',
  'quick',
  'research',
  'docs',
  'code',
  'code-hard',
  'test',
  'review',
];

export const ORCHESTRATOR_COST_TIERS: OrchestratorCostTier[] = [
  'free',
  'cheap',
  'mid',
  'premium',
];

export const ORCHESTRATOR_PROVIDERS: { id: LLMProvider; label: string }[] = [
  { id: 'claude', label: 'Claude' },
  { id: 'cursor', label: 'Cursor' },
  { id: 'codex', label: 'Codex' },
  { id: 'opencode', label: 'OpenCode' },
  { id: 'devin', label: 'Devin' },
];

export const ORCHESTRATOR_PLANNER_MODES = ['auto', 'template', 'off'] as const;
export type OrchestratorPlannerMode = (typeof ORCHESTRATOR_PLANNER_MODES)[number];
