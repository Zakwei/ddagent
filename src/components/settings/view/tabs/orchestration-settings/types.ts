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
  | 'gate'
  | 'report';

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
 * Mid-run autonomy gate for the supervised loop (`planner.mode === 'auto'`).
 * `off` = fully autonomous; `per-step` parks on every supervisor decision;
 * `every-n` parks after each batch that pushes the completed-step count past
 * a multiple of `interval`.
 */
export type OrchestratorCheckpoint = {
  mode: 'off' | 'per-step' | 'every-n';
  /** Completed steps between pauses in `every-n` mode; ignored otherwise. */
  interval: number;
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
    /**
     * Pool candidate id used for plan generation/classification calls.
     * @deprecated The supervised loop routes goals/decision calls through
     * `rules.plan`; kept only so old stored configs still validate.
     */
    candidateId: string;
    mode: 'auto' | 'template' | 'off';
    /** When true the goals/plan card waits for explicit confirm before running. */
    requireConfirm: boolean;
    /** Checkpoint policy for the supervised loop (auto mode only). */
    checkpoint: OrchestratorCheckpoint;
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
    /** Hard cap on supervisor decision rounds in the supervised loop (auto mode). */
    maxSupervisorIterations: number;
    /** Exponential backoff base slept between same-lane retries. */
    retryBackoffBaseMs: number;
    /** Same-lane retry count per failure class before failover/cooldown. */
    retry: Record<'rate_limit' | 'quota' | 'auth' | 'timeout' | 'transient', number>;
  };
};

// 'gate' is deliberately absent: gate steps run a deterministic command, so
// they have no candidate lane and the rules-lane UI must not list them.
// 'report' routes like 'plan': it picks the cheap model that writes the final
// run report and is never a plan step.
export const ORCHESTRATOR_TASK_TYPES: OrchestratorTaskType[] = [
  'plan',
  'quick',
  'research',
  'docs',
  'code',
  'code-hard',
  'test',
  'review',
  'report',
];

export const ORCHESTRATOR_CHECKPOINT_MODES = ['off', 'per-step', 'every-n'] as const;
export type OrchestratorCheckpointMode = (typeof ORCHESTRATOR_CHECKPOINT_MODES)[number];

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
  { id: 'commandcode', label: 'Command Code' },
  { id: 'devin', label: 'Devin' },
];

export const ORCHESTRATOR_PLANNER_MODES = ['auto', 'template', 'off'] as const;
export type OrchestratorPlannerMode = (typeof ORCHESTRATOR_PLANNER_MODES)[number];
