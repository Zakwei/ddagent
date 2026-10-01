// Orchestrator settings — mirrors web
// src/components/settings/view/tabs/orchestration-settings/types.ts and
// useOrchestratorConfig.ts. Config is a draft persisted via
// GET/PUT /api/orchestrator/config.
import { settingsGet as get, settingsSend as send, type AgentProvider, type ProviderAccountItem } from './settings-api';
import type { ProviderModelOption } from './model-menu';

export type OrchestratorTaskType =
  | 'plan'
  | 'quick'
  | 'research'
  | 'docs'
  | 'code'
  | 'code-hard'
  | 'test'
  | 'review'
  | 'report';

export type OrchestratorCostTier = 'free' | 'cheap' | 'mid' | 'premium';

export type OrchestratorCandidate = {
  id: string;
  provider: AgentProvider;
  model: string;
  effort: string | null;
  accountId: string | null;
  tier: OrchestratorCostTier;
  label: string;
};

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
  interval: number;
};

export type OrchestratorConfig = {
  enabled: boolean;
  pool: OrchestratorCandidate[];
  rules: Record<OrchestratorTaskType, string[]>;
  planner: {
    /** @deprecated Supervised loop routes through `rules.plan`; legacy only. */
    candidateId: string;
    mode: 'auto' | 'template' | 'off';
    requireConfirm: boolean;
    checkpoint: OrchestratorCheckpoint;
    templates: OrchestratorPipelineTemplate[];
  };
  execution: {
    maxParallel: number;
    maxFixLoops: number;
    useWorktree: boolean;
    onNoCandidate: 'ask' | 'skip';
    maxSupervisorIterations: number;
  };
};

// 'gate' stays absent: it runs a deterministic command, no candidate lane.
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

export const ORCHESTRATOR_COST_TIERS: OrchestratorCostTier[] = ['free', 'cheap', 'mid', 'premium'];

export const ORCHESTRATOR_PROVIDERS: { id: AgentProvider; label: string }[] = [
  { id: 'claude', label: 'Claude' },
  { id: 'cursor', label: 'Cursor' },
  { id: 'codex', label: 'Codex' },
  { id: 'opencode', label: 'OpenCode' },
  { id: 'devin', label: 'Devin' },
];

export const ORCHESTRATOR_PLANNER_MODES = ['auto', 'template', 'off'] as const;

export const ORCHESTRATOR_CHECKPOINT_MODES = ['off', 'per-step', 'every-n'] as const;
export type OrchestratorCheckpointMode = (typeof ORCHESTRATOR_CHECKPOINT_MODES)[number];

export async function loadOrchestratorConfig(): Promise<OrchestratorConfig> {
  const data = await get<{ config?: OrchestratorConfig }>('/orchestrator/config', 'Failed to load orchestration settings');
  if (!data.config) throw new Error('Failed to load orchestration settings');
  return data.config;
}

export async function saveOrchestratorConfig(config: OrchestratorConfig): Promise<OrchestratorConfig> {
  const data = await send<{ config?: OrchestratorConfig }>(
    'PUT',
    '/orchestrator/config',
    { config },
    'Failed to save orchestration settings',
  );
  if (!data.config) throw new Error('Failed to save orchestration settings');
  return data.config;
}

/** Best-effort per-provider model catalogs; a failing provider yields []. */
export async function loadModelCatalogs(): Promise<Partial<Record<AgentProvider, ProviderModelOption[]>>> {
  const entries = await Promise.all(
    ORCHESTRATOR_PROVIDERS.map(async ({ id }) => {
      try {
        const data = await get<{ models?: { OPTIONS?: ProviderModelOption[] } }>(
          `/providers/${id}/models`,
          'Failed to load models',
        );
        return [id, data.models?.OPTIONS ?? []] as const;
      } catch {
        return [id, []] as const;
      }
    }),
  );
  return Object.fromEntries(entries);
}

/** Best-effort accounts for every provider, grouped lookups happen in the tab. */
export async function loadProviderAccounts(): Promise<ProviderAccountItem[]> {
  const groups = await Promise.all(
    ORCHESTRATOR_PROVIDERS.map(async ({ id }) => {
      try {
        const data = await get<{ accounts?: ProviderAccountItem[] }>(
          `/provider-accounts?provider=${encodeURIComponent(id)}`,
          'Failed to load accounts',
        );
        return data.accounts ?? [];
      } catch {
        return [] as ProviderAccountItem[];
      }
    }),
  );
  return groups.flat();
}
