import { appConfigDb } from '@/modules/database/index.js';
import type {
  LLMProvider,
  OrchestratorCandidate,
  OrchestratorConfig,
  OrchestratorCostTier,
  OrchestratorTaskType,
} from '@/shared/types.js';
import { AppError } from '@/shared/utils.js';

const CONFIG_KEY = 'orchestrator:config';

const TASK_TYPES: OrchestratorTaskType[] = [
  'plan',
  'quick',
  'research',
  'docs',
  'code',
  'code-hard',
  'test',
  'review',
];

const PROVIDERS: LLMProvider[] = ['claude', 'cursor', 'codex', 'opencode', 'devin'];
const TIERS: OrchestratorCostTier[] = ['free', 'cheap', 'mid', 'premium'];

const candidate = (
  id: string,
  model: string,
  tier: OrchestratorCostTier,
  label: string,
): OrchestratorCandidate => ({
  id,
  provider: 'devin',
  model,
  effort: null,
  accountId: null,
  tier,
  label,
});

/**
 * Default pool seeded from the owner's Devin/Windsurf subscription models
 * (`devin models list`, Sept 2026). SWE-2 variants are subscription-bundled
 * (free), GLM-5.3 Flash / DeepSeek V4.1 Flash are the cheap workhorses,
 * Gemini 3.8 Flash covers mid-cost research, Gemini 3.5 Flash is the
 * premium fallback kept for high-stakes review.
 */
function defaultConfig(): OrchestratorConfig {
  return {
    enabled: true,
    pool: [
      candidate('swe2-med', 'swe-2-medium', 'free', 'SWE-2 Medium'),
      candidate('swe2-high', 'swe-2-high', 'free', 'SWE-2 High'),
      candidate('swe2-max', 'swe-2-max', 'free', 'SWE-2 Max'),
      candidate('glm53f-low', 'glm-5-3-flash-low', 'cheap', 'GLM-5.3 Flash Low'),
      candidate('glm53f-high', 'glm-5-3-flash-high', 'cheap', 'GLM-5.3 Flash High'),
      candidate('glm53f-max', 'glm-5-3-flash-max', 'cheap', 'GLM-5.3 Flash Max'),
      candidate('ds41f-high', 'deepseek-v4-1-flash-high', 'cheap', 'DeepSeek V4.1 Flash High'),
      candidate('ds41f-max', 'deepseek-v4-1-flash-max', 'cheap', 'DeepSeek V4.1 Flash Max'),
      candidate('g38f-med', 'gemini-3-8-flash-medium', 'mid', 'Gemini 3.8 Flash Medium'),
      candidate('g38f-high', 'gemini-3-8-flash-high', 'mid', 'Gemini 3.8 Flash High'),
      candidate('glm53-low', 'glm-5-3-low', 'mid', 'GLM-5.3 Low'),
      candidate('glm53-high', 'glm-5-3-high', 'mid', 'GLM-5.3 High'),
      candidate('glm53-max', 'glm-5-3-max', 'mid', 'GLM-5.3 Max'),
      candidate('g35f-med', 'gemini-3-5-flash-medium', 'premium', 'Gemini 3.5 Flash Medium'),
      candidate('g35f-high', 'gemini-3-5-flash-high', 'premium', 'Gemini 3.5 Flash High'),
    ],
    rules: {
      plan: ['glm53f-low'],
      quick: ['ds41f-high', 'glm53f-low'],
      research: ['g38f-med', 'glm53f-high'],
      docs: ['glm53f-high', 'ds41f-high'],
      code: ['swe2-med', 'glm53-low', 'ds41f-max'],
      'code-hard': ['swe2-high', 'glm53-high', 'g35f-med'],
      test: ['ds41f-max', 'glm53f-high'],
      review: ['swe2-max', 'glm53-max', 'g35f-high'],
    },
    planner: {
      candidateId: 'glm53f-low',
      mode: 'auto',
      requireConfirm: false,
      templates: [
        { name: 'code_change', steps: ['code', 'test', 'review'] },
        { name: 'review_only', steps: ['review'] },
      ],
    },
    execution: {
      maxParallel: 2,
      maxFixLoops: 2,
      useWorktree: false,
      onNoCandidate: 'ask',
    },
  };
}

function invalid(message: string): never {
  throw new AppError(message, { code: 'ORCHESTRATOR_CONFIG_INVALID', statusCode: 400 });
}

function readCandidate(value: unknown, index: number): OrchestratorCandidate {
  if (!value || typeof value !== 'object' || Array.isArray(value)) {
    invalid(`pool[${index}] must be an object`);
  }
  const raw = value as Record<string, unknown>;
  const id = typeof raw.id === 'string' ? raw.id.trim() : '';
  const model = typeof raw.model === 'string' ? raw.model.trim() : '';
  if (!id) invalid(`pool[${index}].id is required`);
  if (!model) invalid(`pool[${index}].model is required`);
  if (!PROVIDERS.includes(raw.provider as LLMProvider)) {
    invalid(`pool[${index}].provider must be one of: ${PROVIDERS.join(', ')}`);
  }
  if (!TIERS.includes(raw.tier as OrchestratorCostTier)) {
    invalid(`pool[${index}].tier must be one of: ${TIERS.join(', ')}`);
  }
  const effort = raw.effort === null || raw.effort === undefined ? null : String(raw.effort).trim();
  const accountId =
    raw.accountId === null || raw.accountId === undefined ? null : String(raw.accountId).trim();
  return {
    id,
    provider: raw.provider as LLMProvider,
    model,
    effort: effort || null,
    accountId: accountId || null,
    tier: raw.tier as OrchestratorCostTier,
    label: typeof raw.label === 'string' && raw.label.trim() ? raw.label.trim() : model,
  };
}

/**
 * Structural validation of a client-supplied config. Model existence against
 * live provider catalogs is intentionally NOT checked here — the router
 * filters unavailable candidates at dispatch time, and provider model lists
 * may be unreachable when settings are edited.
 */
export function validateOrchestratorConfig(value: unknown): OrchestratorConfig {
  if (!value || typeof value !== 'object' || Array.isArray(value)) {
    invalid('config must be an object');
  }
  const raw = value as Record<string, unknown>;

  const poolRaw = Array.isArray(raw.pool) ? raw.pool : [];
  const pool = poolRaw.map(readCandidate);
  const poolIds = new Set(pool.map((c) => c.id));
  if (poolIds.size !== pool.length) invalid('pool ids must be unique');

  const rulesRaw = (raw.rules ?? {}) as Record<string, unknown>;
  const rules = {} as Record<OrchestratorTaskType, string[]>;
  for (const type of TASK_TYPES) {
    const list = rulesRaw[type];
    if (list === undefined) {
      rules[type] = [];
      continue;
    }
    if (!Array.isArray(list)) invalid(`rules.${type} must be an array`);
    rules[type] = list.map((entry) => {
      const id = String(entry);
      if (!poolIds.has(id)) invalid(`rules.${type} references unknown candidate "${id}"`);
      return id;
    });
  }

  const plannerRaw = (raw.planner ?? {}) as Record<string, unknown>;
  const candidateId = typeof plannerRaw.candidateId === 'string' ? plannerRaw.candidateId : '';
  if (!poolIds.has(candidateId)) invalid('planner.candidateId must reference a pool candidate');
  const mode = plannerRaw.mode;
  if (mode !== 'auto' && mode !== 'template' && mode !== 'off') {
    invalid('planner.mode must be auto|template|off');
  }
  const templatesRaw = Array.isArray(plannerRaw.templates) ? plannerRaw.templates : [];
  const templates = templatesRaw.map((entry, index) => {
    const t = entry as Record<string, unknown>;
    const steps = Array.isArray(t?.steps) ? t.steps.map(String) : [];
    for (const step of steps) {
      if (!TASK_TYPES.includes(step as OrchestratorTaskType)) {
        invalid(`planner.templates[${index}] uses unknown task type "${step}"`);
      }
    }
    return { name: String(t?.name ?? `template-${index}`), steps: steps as OrchestratorTaskType[] };
  });

  const executionRaw = (raw.execution ?? {}) as Record<string, unknown>;
  const maxParallel = Number(executionRaw.maxParallel ?? 2);
  const maxFixLoops = Number(executionRaw.maxFixLoops ?? 2);
  if (!Number.isInteger(maxParallel) || maxParallel < 1 || maxParallel > 8) {
    invalid('execution.maxParallel must be an integer 1..8');
  }
  if (!Number.isInteger(maxFixLoops) || maxFixLoops < 0 || maxFixLoops > 5) {
    invalid('execution.maxFixLoops must be an integer 0..5');
  }
  const onNoCandidate = executionRaw.onNoCandidate;
  if (onNoCandidate !== 'ask' && onNoCandidate !== 'skip') {
    invalid('execution.onNoCandidate must be ask|skip');
  }
  const useWorktree = executionRaw.useWorktree === true;

  return {
    enabled: raw.enabled !== false,
    pool,
    rules,
    planner: { candidateId, mode, templates, requireConfirm: plannerRaw.requireConfirm === true },
    execution: { maxParallel, maxFixLoops, useWorktree, onNoCandidate },
  };
}

export type OrchestratorConfigService = {
  get(): OrchestratorConfig;
  put(value: unknown): OrchestratorConfig;
};

/**
 * Config store backed by appConfigDb (`orchestrator:config`), following the
 * `kanban_board_config:<projectId>` precedent. A missing or corrupt value
 * falls back to the seeded default rather than failing reads.
 */
export function createOrchestratorConfigService(
  store: Pick<typeof appConfigDb, 'get' | 'set'> = appConfigDb,
): OrchestratorConfigService {
  return {
    get(): OrchestratorConfig {
      const raw = store.get(CONFIG_KEY);
      if (!raw) return defaultConfig();
      try {
        return validateOrchestratorConfig(JSON.parse(raw));
      } catch (error) {
        console.warn('[Orchestrator] Stored config invalid, serving defaults:', error);
        return defaultConfig();
      }
    },
    put(value: unknown): OrchestratorConfig {
      const config = validateOrchestratorConfig(value);
      store.set(CONFIG_KEY, JSON.stringify(config));
      return config;
    },
  };
}
