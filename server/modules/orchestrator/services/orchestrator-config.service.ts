import { appConfigDb } from '@/modules/database/index.js';
import type {
  LLMProvider,
  OrchestratorCandidate,
  OrchestratorCheckpoint,
  OrchestratorConfig,
  OrchestratorCostTier,
  OrchestratorFailureClass,
  OrchestratorRetryBudget,
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
  'gate',
  'report',
];

const PROVIDERS: LLMProvider[] = ['claude', 'cursor', 'codex', 'opencode', 'commandcode', 'antigravity', 'devin'];
const TIERS: OrchestratorCostTier[] = ['free', 'cheap', 'mid', 'premium'];

const candidate = (
  id: string,
  model: string,
  tier: OrchestratorCostTier,
  label: string,
  provider: LLMProvider = 'devin',
): OrchestratorCandidate => ({
  id,
  provider,
  model,
  effort: null,
  accountId: null,
  tier,
  label,
});

/**
 * Default pool seeded from the owner's subscriptions (Oct 2026):
 * - Devin/Windsurf (`devin models list`): SWE-2 variants are
 *   subscription-bundled (free) and first-class here; GLM-5.3 Flash /
 *   DeepSeek V4.1 Flash are the cheap workhorses; Gemini flashes cover
 *   mid/premium research and review.
 * - Codex CLI rides the ChatGPT Plus plan: gpt-6-luna (cheap), gpt-6.1-sol
 *   (mid workhorse), gpt-6-astra (premium frontier). Its quota section is
 *   `codex` and reports real windows.
 * - Antigravity CLI (`agy`) rides the Gemini subscription — Claude/GPT
 *   models draw the 'Claude and GPT models' bucket, `gemini-*` the
 *   'Gemini Models' one. Named provider accounts can add a second lane
 *   per model (failover when one account's quota is spent).
 * - CommandCode CLI (`cmd`) rides the CommandCode plan.
 * - OpenCode CLI carries only the always-on lanes: `nvidia/*` is BYOK and
 *   `opencode/*` is the Zen free tier. The router bills each to its own
 *   quota section.
 *
 * Rule order = Antigravity subscription first (the owner's Gemini plan is
 * the main workhorse — its Claude/GPT pool for code-hard/review, Gemini
 * flash for the cheap lanes), then Devin lanes (SWE-2 free first — the
 * free lane rides the paid Devin subscription — paid GLM/DeepSeek
 * after), then Codex (ChatGPT Plus), and CommandCode paid as the final
 * fallback.
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
      // Antigravity CLI lanes — dedicated `agy` provider on the Gemini plan
      // (ambient account; a named provider account adds a failover lane).
      candidate('agy-gem38f', 'gemini-3.8-flash-medium', 'mid', 'Gemini 3.8 Flash (Antigravity)', 'antigravity'),
      // Antigravity's second pool ('Claude and GPT models') — Anthropic
      // models with their own quota, billed separately from Gemini Models.
      candidate('agy-sonnet', 'claude-sonnet-4-6', 'mid', 'Claude Sonnet 4.6 (Antigravity)', 'antigravity'),
      candidate('agy-opus', 'claude-opus-4-6-thinking', 'premium', 'Claude Opus 4.6 Thinking (Antigravity)', 'antigravity'),
      candidate('agy-gem31p', 'gemini-3.1-pro-high', 'premium', 'Gemini 3.1 Pro (Antigravity)', 'antigravity'),
      // OpenCode lanes — only models that need no plugin-provided provider
      // (the antigravity/commandcode plugins were removed from opencode).
      candidate('oc-zen-pickle', 'opencode/big-pickle', 'free', 'OpenCode Zen Free', 'opencode'),
      candidate('oc-nv-glm53f', 'nvidia/z-ai/glm-5.3-flash', 'free', 'GLM-5.3 Flash (NVIDIA BYOK)', 'opencode'),
      // CommandCode CLI lanes — dedicated `cmd` provider on the CommandCode plan.
      candidate('cc-ds41f', 'deepseek/deepseek-v4.1-flash', 'mid', 'DeepSeek V4.1 Flash (CommandCode)', 'commandcode'),
      candidate('cc-sonnet5', 'claude-sonnet-5', 'mid', 'Claude Sonnet 5 (CommandCode)', 'commandcode'),
      // Codex lanes — the owner's ChatGPT Plus plan (codex quota section).
      { ...candidate('cx-luna', 'gpt-6-luna', 'cheap', 'GPT-6 Luna (ChatGPT Plus)', 'codex'), effort: 'low' },
      { ...candidate('cx-sol', 'gpt-6.1-sol', 'mid', 'GPT-6.1 Sol (ChatGPT Plus)', 'codex'), effort: 'medium' },
      { ...candidate('cx-astra', 'gpt-6-astra', 'premium', 'GPT-6 Astra (ChatGPT Plus)', 'codex'), effort: 'high' },
    ],
    rules: {
      // Smart-first: the supervisor lane writes goals and every per-batch
      // decision — this is where the strongest models belong.
      plan: ['agy-opus', 'agy-sonnet', 'cx-astra', 'swe2-max', 'g35f-high'],
      quick: ['agy-gem38f', 'ds41f-high', 'glm53f-low', 'cx-luna', 'oc-zen-pickle', 'cc-ds41f'],
      research: ['agy-gem38f', 'agy-gem31p', 'g38f-med', 'cx-sol', 'glm53f-high', 'cc-ds41f'],
      docs: ['agy-gem38f', 'glm53f-high', 'ds41f-high', 'cx-luna', 'cc-ds41f'],
      code: ['agy-sonnet', 'swe2-med', 'cx-sol', 'agy-gem38f', 'glm53-low', 'ds41f-max', 'swe2-high', 'cc-sonnet5', 'cc-ds41f'],
      'code-hard': ['agy-opus', 'agy-sonnet', 'cx-astra', 'swe2-high', 'glm53-high', 'g35f-med', 'cc-sonnet5', 'cc-ds41f'],
      test: ['agy-gem38f', 'ds41f-max', 'glm53f-high', 'oc-nv-glm53f', 'cx-luna', 'swe2-med', 'cc-ds41f'],
      review: ['agy-opus', 'agy-sonnet', 'cx-astra', 'swe2-max', 'glm53-max', 'g35f-high', 'cc-sonnet5', 'cc-ds41f'],
      // Gate steps execute a shell command deterministically — no lane.
      gate: [],
      // The final run report is a summarization job — cheapest lanes first.
      report: ['oc-zen-pickle', 'glm53f-low', 'ds41f-high', 'cx-luna', 'agy-gem38f'],
    },
    planner: {
      candidateId: 'agy-gem38f',
      mode: 'auto',
      requireConfirm: false,
      checkpoint: { mode: 'off', interval: 5 },
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
      maxAttempts: 10,
      stepTimeoutMs: 30 * 60_000,
      runTimeoutMs: 0,
      maxSupervisorIterations: 25,
      retryBackoffBaseMs: 10_000,
      retry: { rate_limit: 2, quota: 0, auth: 0, timeout: 0, transient: 0 },
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
  // Deprecated field: an empty candidateId is fine (supervised mode routes
  // through rules.plan), but a non-empty one must still name a pool member.
  const candidateId = typeof plannerRaw.candidateId === 'string' ? plannerRaw.candidateId : '';
  if (candidateId && !poolIds.has(candidateId)) {
    invalid('planner.candidateId must reference a pool candidate');
  }

  const checkpointRaw = (plannerRaw.checkpoint ?? {}) as Record<string, unknown>;
  const checkpointMode = checkpointRaw.mode ?? 'off';
  if (checkpointMode !== 'off' && checkpointMode !== 'per-step' && checkpointMode !== 'every-n') {
    invalid('planner.checkpoint.mode must be off|per-step|every-n');
  }
  const checkpointInterval = Number(checkpointRaw.interval ?? 5);
  if (!Number.isInteger(checkpointInterval) || checkpointInterval < 1 || checkpointInterval > 50) {
    invalid('planner.checkpoint.interval must be an integer 1..50');
  }
  const checkpoint: OrchestratorCheckpoint = {
    mode: checkpointMode as OrchestratorCheckpoint['mode'],
    interval: checkpointInterval,
  };
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

  const nonNegativeMs = (value: unknown, name: string): number => {
    const num = Number(value ?? 0);
    if (!Number.isFinite(num) || num < 0) invalid(`execution.${name} must be a number >= 0`);
    return num;
  };
  const maxAttempts = Number(executionRaw.maxAttempts ?? 10);
  if (!Number.isInteger(maxAttempts) || maxAttempts < 1 || maxAttempts > 50) {
    invalid('execution.maxAttempts must be an integer 1..50');
  }
  const retryBackoffBaseMs = nonNegativeMs(executionRaw.retryBackoffBaseMs ?? 10_000, 'retryBackoffBaseMs');
  const stepTimeoutMs = nonNegativeMs(executionRaw.stepTimeoutMs ?? 30 * 60_000, 'stepTimeoutMs');
  const runTimeoutMs = nonNegativeMs(executionRaw.runTimeoutMs ?? 0, 'runTimeoutMs');
  const maxSupervisorIterations = Number(executionRaw.maxSupervisorIterations ?? 25);
  if (!Number.isInteger(maxSupervisorIterations) || maxSupervisorIterations < 1 || maxSupervisorIterations > 100) {
    invalid('execution.maxSupervisorIterations must be an integer 1..100');
  }

  const retryRaw = (executionRaw.retry ?? {}) as Record<string, unknown>;
  if (typeof retryRaw !== 'object' || retryRaw === null || Array.isArray(retryRaw)) {
    invalid('execution.retry must be an object');
  }
  const retry = { rate_limit: 2, quota: 0, auth: 0, timeout: 0, transient: 0 } as OrchestratorRetryBudget;
  for (const key of Object.keys(retry) as OrchestratorFailureClass[]) {
    const value = Number(retryRaw[key] ?? retry[key]);
    if (!Number.isInteger(value) || value < 0 || value > 5) {
      invalid(`execution.retry.${key} must be an integer 0..5`);
    }
    retry[key] = value;
  }

  return {
    enabled: raw.enabled !== false,
    pool,
    rules,
    planner: { candidateId, mode, templates, requireConfirm: plannerRaw.requireConfirm === true, checkpoint },
    execution: { maxParallel, maxFixLoops, useWorktree, onNoCandidate, maxAttempts, stepTimeoutMs, runTimeoutMs, maxSupervisorIterations, retryBackoffBaseMs, retry },
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
