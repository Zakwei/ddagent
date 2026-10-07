import { appConfigDb } from '@/modules/database/index.js';
import type {
  LLMProvider,
  MiniOrchestratorConfig,
  MiniOrchestratorRole,
  OrchestratorCandidate,
  OrchestratorCostTier,
  OrchestratorTaskType,
} from '@/shared/types.js';
import { AppError } from '@/shared/utils.js';

const CONFIG_KEY = 'mini-orchestrator:config';

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

const ROLES: MiniOrchestratorRole[] = ['thinker', 'worker'];

const PROVIDERS: LLMProvider[] = [
  'claude',
  'cursor',
  'codex',
  'opencode',
  'commandcode',
  'antigravity',
  'devin',
];
const TIERS: OrchestratorCostTier[] = ['free', 'cheap', 'mid', 'premium'];

/**
 * Default per-task role assignment. The thinker (non-flash) covers reasoning
 * work — planning, research, hard code and review; the worker (flash) does the
 * mechanical execution and summarization. Users override per task type in
 * Settings → Mini orchestration.
 */
const DEFAULT_ROLES: Record<OrchestratorTaskType, MiniOrchestratorRole> = {
  plan: 'thinker',
  quick: 'worker',
  research: 'thinker',
  docs: 'worker',
  code: 'worker',
  'code-hard': 'thinker',
  test: 'worker',
  review: 'thinker',
  gate: 'worker',
  report: 'worker',
};

function candidate(
  id: string,
  model: string,
  tier: OrchestratorCostTier,
  label: string,
  provider: LLMProvider = 'devin',
): OrchestratorCandidate {
  return {
    id,
    provider,
    model,
    effort: null,
    accountId: null,
    fallbackAccountIds: [],
    tier,
    label,
  };
}

/**
 * Seeded mini-orchestrator defaults: GLM-5.3 (non-flash) thinks, GLM-5.3 Flash
 * works — both on the Devin subscription (effort is encoded in the model uid).
 */
function defaultConfig(): MiniOrchestratorConfig {
  return {
    enabled: true,
    thinker: [candidate('glm53-high', 'glm-5-3-high', 'mid', 'GLM-5.3 High')],
    worker: [candidate('glm53f-high', 'glm-5-3-flash-high', 'cheap', 'GLM-5.3 Flash High')],
    roles: { ...DEFAULT_ROLES },
    planner: { mode: 'auto', requireConfirm: false },
    execution: { maxParallel: 2, maxSteps: 12, stepTimeoutMs: 30 * 60_000, runTimeoutMs: 0 },
  };
}

function invalid(message: string): never {
  throw new AppError(message, { code: 'MINI_ORCHESTRATOR_CONFIG_INVALID', statusCode: 400 });
}

function readCandidate(value: unknown, path: string): OrchestratorCandidate {
  if (!value || typeof value !== 'object' || Array.isArray(value)) {
    invalid(`${path} must be an object`);
  }
  const raw = value as Record<string, unknown>;
  const id = typeof raw.id === 'string' ? raw.id.trim() : '';
  const model = typeof raw.model === 'string' ? raw.model.trim() : '';
  if (!id) invalid(`${path}.id is required`);
  if (!model) invalid(`${path}.model is required`);
  if (!PROVIDERS.includes(raw.provider as LLMProvider)) {
    invalid(`${path}.provider must be one of: ${PROVIDERS.join(', ')}`);
  }
  if (!TIERS.includes(raw.tier as OrchestratorCostTier)) {
    invalid(`${path}.tier must be one of: ${TIERS.join(', ')}`);
  }
  const effort = raw.effort === null || raw.effort === undefined ? null : String(raw.effort).trim();
  const accountId =
    raw.accountId === null || raw.accountId === undefined ? null : String(raw.accountId).trim();
  const fallbackAccountIds = Array.isArray(raw.fallbackAccountIds)
    ? raw.fallbackAccountIds
        .map((entry) => String(entry).trim())
        .filter((entry, index, all) => entry.length > 0 && entry !== accountId && all.indexOf(entry) === index)
    : [];
  return {
    id,
    provider: raw.provider as LLMProvider,
    model,
    effort: effort || null,
    accountId: accountId || null,
    fallbackAccountIds,
    tier: raw.tier as OrchestratorCostTier,
    label: typeof raw.label === 'string' && raw.label.trim() ? raw.label.trim() : model,
  };
}

function readRoleList(value: unknown, path: string): OrchestratorCandidate[] {
  if (!Array.isArray(value) || value.length === 0) {
    invalid(`${path} must be a non-empty array`);
  }
  return value.map((entry, index) => readCandidate(entry, `${path}[${index}]`));
}

/**
 * Structural validation of a client-supplied mini-orchestrator config. Model
 * existence against live provider catalogs is intentionally NOT checked here —
 * the engine filters unavailable candidates at dispatch, and provider model
 * lists may be unreachable when settings are edited.
 */
export function validateMiniOrchestratorConfig(value: unknown): MiniOrchestratorConfig {
  if (!value || typeof value !== 'object' || Array.isArray(value)) {
    invalid('config must be an object');
  }
  const raw = value as Record<string, unknown>;

  const thinker = readRoleList(raw.thinker, 'thinker');
  const worker = readRoleList(raw.worker, 'worker');
  const ids = [...thinker, ...worker].map((entry) => entry.id);
  if (new Set(ids).size !== ids.length) invalid('candidate ids must be unique across thinker and worker');

  const rolesRaw = (raw.roles ?? {}) as Record<string, unknown>;
  if (typeof rolesRaw !== 'object' || rolesRaw === null || Array.isArray(rolesRaw)) {
    invalid('roles must be an object');
  }
  const roles = {} as Record<OrchestratorTaskType, MiniOrchestratorRole>;
  for (const type of TASK_TYPES) {
    const rawRole = rolesRaw[type];
    if (rawRole === undefined || rawRole === null) {
      roles[type] = DEFAULT_ROLES[type];
      continue;
    }
    if (!ROLES.includes(rawRole as MiniOrchestratorRole)) {
      invalid(`roles.${type} must be thinker|worker`);
    }
    roles[type] = rawRole as MiniOrchestratorRole;
  }

  const plannerRaw = (raw.planner ?? {}) as Record<string, unknown>;
  const mode = plannerRaw.mode ?? 'auto';
  if (mode !== 'auto' && mode !== 'off') {
    invalid('planner.mode must be auto|off');
  }

  const executionRaw = (raw.execution ?? {}) as Record<string, unknown>;
  const maxParallel = Number(executionRaw.maxParallel ?? 2);
  if (!Number.isInteger(maxParallel) || maxParallel < 1 || maxParallel > 4) {
    invalid('execution.maxParallel must be an integer 1..4');
  }
  const maxSteps = Number(executionRaw.maxSteps ?? 12);
  if (!Number.isInteger(maxSteps) || maxSteps < 1 || maxSteps > 50) {
    invalid('execution.maxSteps must be an integer 1..50');
  }
  const nonNegativeMs = (value: unknown, name: string): number => {
    const num = Number(value ?? 0);
    if (!Number.isFinite(num) || num < 0) invalid(`execution.${name} must be a number >= 0`);
    return num;
  };

  return {
    enabled: raw.enabled !== false,
    thinker,
    worker,
    roles,
    planner: { mode, requireConfirm: plannerRaw.requireConfirm === true },
    execution: {
      maxParallel,
      maxSteps,
      stepTimeoutMs: nonNegativeMs(executionRaw.stepTimeoutMs ?? 30 * 60_000, 'stepTimeoutMs'),
      runTimeoutMs: nonNegativeMs(executionRaw.runTimeoutMs ?? 0, 'runTimeoutMs'),
    },
  };
}

export type MiniOrchestratorConfigService = {
  get(): MiniOrchestratorConfig;
  put(value: unknown): MiniOrchestratorConfig;
};

/**
 * Config store backed by appConfigDb (`mini-orchestrator:config`), following the
 * `orchestrator:config` precedent. A missing or corrupt value falls back to the
 * seeded default rather than failing reads.
 */
export function createMiniOrchestratorConfigService(
  store: Pick<typeof appConfigDb, 'get' | 'set'> = appConfigDb,
): MiniOrchestratorConfigService {
  return {
    get(): MiniOrchestratorConfig {
      const raw = store.get(CONFIG_KEY);
      if (!raw) return defaultConfig();
      try {
        return validateMiniOrchestratorConfig(JSON.parse(raw));
      } catch (error) {
        console.warn('[MiniOrchestrator] Stored config invalid, serving defaults:', error);
        return defaultConfig();
      }
    },
    put(value: unknown): MiniOrchestratorConfig {
      const config = validateMiniOrchestratorConfig(value);
      store.set(CONFIG_KEY, JSON.stringify(config));
      return config;
    },
  };
}
