import { execFile } from 'node:child_process';
import { promisify } from 'node:util';

import { sessionsDb } from '@/modules/database/index.js';
import type { IProviderModels } from '@/shared/interfaces.js';
import type {
  ProviderCurrentActiveModel,
  ProviderModelOption,
  ProviderModelsDefinition,
} from '@/shared/types.js';
import {
  buildDefaultProviderCurrentActiveModel,
  getOpenCodeDatabasePath,
  openSqliteReadonlyDatabase,
  readObjectRecord,
  readOptionalString,
} from '@/shared/utils.js';

const execFileAsync = promisify(execFile);

const MODEL_CACHE_TTL_MS = 60_000;
const OPENCODE_MODEL_LIST_TIMEOUT_MS = 30_000;

/**
 * Curated OpenCode catalog shipped as immutable ddagent defaults.
 *
 * OpenCode routes by `<providerID>/<modelID>`, so this list mirrors the
 * providers `opencode models --verbose` reports: the OpenCode Zen gateway plus
 * the Anthropic and OpenAI providers OpenCode can address directly with the
 * user's own credentials.
 */
export const OPENCODE_PREDEFINED_MODELS: ProviderModelsDefinition = {
  OPTIONS: [
    { value: 'opencode/big-pickle', label: 'Big Pickle', description: 'OpenCode Zen · Free' },
    { value: 'opencode/ling-3.0-flash-fin-free', label: 'Ling 3.0 Flash Fin Free', description: 'OpenCode Zen · Free' },
    { value: 'opencode/mimo-v2.5-free', label: 'MiMo-V2.5 Free', description: 'OpenCode Zen · Free' },
    { value: 'opencode/muse-spark-1.2-contributor-free', label: 'Muse Spark 1.2 Free', description: 'OpenCode Zen · Free' },
    { value: 'opencode/nemotron-3-ultra-free', label: 'Nemotron 3 Ultra Free', description: 'OpenCode Zen · Free' },
    { value: 'opencode/nemotron-3.5-lightning-free', label: 'Nemotron 3.5 Lightning Free', description: 'OpenCode Zen · Free' },
    { value: 'anthropic/claude-opus-5', label: 'Claude Opus 5', description: 'Anthropic' },
    { value: 'anthropic/claude-opus-5-fast', label: 'Claude Opus 5 Fast', description: 'Anthropic' },
    { value: 'anthropic/claude-fable-5', label: 'Claude Fable 5', description: 'Anthropic' },
    { value: 'anthropic/claude-sonnet-5', label: 'Claude Sonnet 5', description: 'Anthropic' },
    { value: 'anthropic/claude-opus-4-8', label: 'Claude Opus 4.8', description: 'Anthropic' },
    { value: 'anthropic/claude-opus-4-8-fast', label: 'Claude Opus 4.8 Fast', description: 'Anthropic' },
    { value: 'anthropic/claude-opus-4-7', label: 'Claude Opus 4.7', description: 'Anthropic' },
    { value: 'anthropic/claude-opus-4-7-fast', label: 'Claude Opus 4.7 Fast', description: 'Anthropic' },
    { value: 'anthropic/claude-opus-4-6', label: 'Claude Opus 4.6', description: 'Anthropic' },
    { value: 'anthropic/claude-opus-4-6-fast', label: 'Claude Opus 4.6 Fast', description: 'Anthropic' },
    { value: 'anthropic/claude-opus-4-5', label: 'Claude Opus 4.5 (latest)', description: 'Anthropic' },
    { value: 'anthropic/claude-opus-4-5-20251101', label: 'Claude Opus 4.5', description: 'Anthropic' },
    { value: 'anthropic/claude-sonnet-4-6', label: 'Claude Sonnet 4.6', description: 'Anthropic' },
    { value: 'anthropic/claude-sonnet-4-5', label: 'Claude Sonnet 4.5 (latest)', description: 'Anthropic' },
    { value: 'anthropic/claude-sonnet-4-5-20250929', label: 'Claude Sonnet 4.5', description: 'Anthropic' },
    { value: 'anthropic/claude-haiku-4-5', label: 'Claude Haiku 4.5 (latest)', description: 'Anthropic' },
    { value: 'anthropic/claude-haiku-4-5-20251001', label: 'Claude Haiku 4.5', description: 'Anthropic' },
    { value: 'openai/gpt-5.6', label: 'GPT-5.6', description: 'OpenAI' },
    { value: 'openai/gpt-5.6-fast', label: 'GPT-5.6 Fast', description: 'OpenAI' },
    { value: 'openai/gpt-5.6-pro', label: 'GPT-5.6 Pro', description: 'OpenAI' },
    { value: 'openai/gpt-5.6-sol', label: 'GPT-5.6 Sol', description: 'OpenAI' },
    { value: 'openai/gpt-5.6-sol-fast', label: 'GPT-5.6 Sol Fast', description: 'OpenAI' },
    { value: 'openai/gpt-5.6-sol-pro', label: 'GPT-5.6 Sol Pro', description: 'OpenAI' },
    { value: 'openai/gpt-5.6-terra', label: 'GPT-5.6 Terra', description: 'OpenAI' },
    { value: 'openai/gpt-5.6-terra-fast', label: 'GPT-5.6 Terra Fast', description: 'OpenAI' },
    { value: 'openai/gpt-5.6-terra-pro', label: 'GPT-5.6 Terra Pro', description: 'OpenAI' },
    { value: 'openai/gpt-5.6-luna', label: 'GPT-5.6 Luna', description: 'OpenAI' },
    { value: 'openai/gpt-5.6-luna-fast', label: 'GPT-5.6 Luna Fast', description: 'OpenAI' },
    { value: 'openai/gpt-5.6-luna-pro', label: 'GPT-5.6 Luna Pro', description: 'OpenAI' },
    { value: 'openai/gpt-5.5', label: 'GPT-5.5', description: 'OpenAI' },
    { value: 'openai/gpt-5.5-fast', label: 'GPT-5.5 Fast', description: 'OpenAI' },
    { value: 'openai/gpt-5.4', label: 'GPT-5.4', description: 'OpenAI' },
    { value: 'openai/gpt-5.4-fast', label: 'GPT-5.4 Fast', description: 'OpenAI' },
    { value: 'openai/gpt-5.4-mini', label: 'GPT-5.4 mini', description: 'OpenAI' },
    { value: 'openai/gpt-5.4-mini-fast', label: 'GPT-5.4 mini Fast', description: 'OpenAI' },
    { value: 'openai/gpt-5.3-codex-spark', label: 'GPT-5.3 Codex Spark', description: 'OpenAI' },
  ],
  DEFAULT: 'opencode/big-pickle',
};

const parseOpenCodeSessionModelValue = (rawModel: unknown): string | null => {
  if (typeof rawModel === 'string') {
    const trimmed = rawModel.trim();
    if (!trimmed) {
      return null;
    }

    try {
      return parseOpenCodeSessionModelValue(JSON.parse(trimmed));
    } catch {
      return trimmed;
    }
  }

  const record = readObjectRecord(rawModel);
  if (!record) {
    return null;
  }

  return readOptionalString(record.id)
    ?? readOptionalString(record.model)
    ?? readOptionalString(record.name)
    ?? readOptionalString(record.value)
    ?? null;
};

// ---------------------------
//----------------- OPENCODE DYNAMIC MODEL DISCOVERY ------------

type OpenCodeExecFile = (
  file: string,
  args: string[],
  options: { encoding?: string; timeout?: number; maxBuffer?: number },
) => Promise<{ stdout: string; stderr: string }>;

const PROVIDER_DISPLAY_NAMES: Record<string, string> = {
  opencode: 'OpenCode',
  'opencode-go': 'OpenCode Go',
  anthropic: 'Anthropic',
  openai: 'OpenAI',
  google: 'Google',
  nvidia: 'NVIDIA',
};

const getProviderDisplayName = (providerId: string): string => (
  PROVIDER_DISPLAY_NAMES[providerId]
  ?? (providerId ? `${providerId[0].toUpperCase()}${providerId.slice(1)}` : 'Unknown')
);

const readNumber = (value: unknown): number | undefined => {
  if (typeof value === 'number' && Number.isFinite(value)) {
    return value;
  }
  if (typeof value === 'string') {
    const parsed = Number(value);
    if (!Number.isNaN(parsed)) {
      return parsed;
    }
  }
  return undefined;
};

const isFreeFromCost = (cost: unknown): boolean => {
  if (!cost || typeof cost !== 'object') {
    return false;
  }
  const record = cost as Record<string, unknown>;
  const input = readNumber(record.input) ?? 0;
  const output = readNumber(record.output) ?? 0;
  const cache = record.cache && typeof record.cache === 'object'
    ? record.cache as Record<string, unknown>
    : {};
  const cacheRead = readNumber(cache.read) ?? 0;
  const cacheWrite = readNumber(cache.write) ?? 0;
  return input === 0 && output === 0 && cacheRead === 0 && cacheWrite === 0;
};

const readVariantDescription = (variant: unknown): string | undefined => {
  if (!variant || typeof variant !== 'object') {
    return undefined;
  }
  const record = variant as Record<string, unknown>;
  const direct =
    readOptionalString(record.reasoningEffort)
    ?? readOptionalString(record.effort)
    ?? readOptionalString(record.thinkingLevel);
  if (direct) {
    return direct;
  }
  if (record.thinkingConfig && typeof record.thinkingConfig === 'object') {
    const thinkingConfig = record.thinkingConfig as Record<string, unknown>;
    return readOptionalString(thinkingConfig.thinkingLevel) ?? undefined;
  }
  return undefined;
};

const parseEffortFromVariants = (variants: unknown): ProviderModelOption['effort'] => {
  if (!variants || typeof variants !== 'object') {
    return undefined;
  }
  const record = variants as Record<string, unknown>;
  const keys = Object.keys(record).filter((key) => record[key] !== undefined);
  if (keys.length === 0) {
    return undefined;
  }

  const values = keys.map((key) => ({
    value: key,
    description: readVariantDescription(record[key]),
  }));

  const defaultEffort = values.find((option) => option.value === 'medium')
    ?? values[0];

  return {
    default: defaultEffort.value,
    values,
  };
};

/**
 * Splits `opencode models --verbose` output into discrete JSON blocks.
 *
 * The CLI prints one model id per line, followed by a pretty-printed JSON
 * object. The id line is unindented and contains a slash; every JSON line is
 * indented until the closing `}`.
 */
const parseOpenCodeVerboseOutput = (stdout: string): ProviderModelOption[] => {
  const text = stdout.trim();
  if (!text) {
    return [];
  }

  const modelPattern = /^(?<id>[^\s{}\n][^\n]*\/[^\n]*)\n(?<json>\{[\s\S]*?\n\})(?=(\n[^\s{}\n]|$))/gm;
  const matches = [...text.matchAll(modelPattern)];

  return matches.map((match) => {
    const id = match.groups?.id ?? '';
    const raw = match.groups?.json ?? '{}';
    let parsed: Record<string, unknown> = {};
    try {
      parsed = JSON.parse(raw) as Record<string, unknown>;
    } catch {
      // If the JSON is malformed, still surface the model id with minimal data.
    }

    const providerId = readOptionalString(parsed.providerID) ?? id.split('/')[0] ?? 'opencode';
    const label = readOptionalString(parsed.name) ?? id.split('/')[1] ?? id;
    const limit = parsed.limit && typeof parsed.limit === 'object'
      ? parsed.limit as Record<string, unknown>
      : {};
    const context = readNumber(limit.context);
    const isAntigravity = id.toLowerCase().includes('antigravity')
      || providerId.toLowerCase().includes('antigravity')
      || label.toLowerCase().includes('antigravity');
    // NVIDIA Build is a free BYOK catalog; its verbose JSON carries no `cost`.
    const tier = (!isAntigravity && (providerId === 'nvidia' || isFreeFromCost(parsed.cost)) ? 'free' : 'paid') as 'free' | 'paid';
    const effort = parseEffortFromVariants(parsed.variants);

    return {
      value: id,
      label,
      description: getProviderDisplayName(providerId),
      context,
      tier,
      effort,
    };
  }).filter((option) => option.value && option.label);
};

/** Loads and caches the live OpenCode model catalog from the OpenCode CLI. */
const loadOpenCodeModels = async (
  deps: { execFile?: OpenCodeExecFile } = {},
  forceRefresh = false,
  currentCache: ProviderModelsDefinition | null = null,
  cacheAt = 0,
): Promise<ProviderModelsDefinition> => {
  if (!forceRefresh && currentCache && Date.now() - cacheAt < MODEL_CACHE_TTL_MS) {
    return currentCache;
  }

  const run = deps.execFile ?? execFileAsync;

  try {
    const { stdout } = await run(
      'opencode',
      ['models', '--verbose'],
      {
        encoding: 'utf8',
        timeout: OPENCODE_MODEL_LIST_TIMEOUT_MS,
        maxBuffer: 16 * 1024 * 1024,
      },
    );

    const options = parseOpenCodeVerboseOutput(stdout);
    if (options.length === 0) {
      throw new Error('OpenCode returned an empty model list.');
    }

    const DEFAULT = options.some((option) => option.value === 'opencode/big-pickle')
      ? 'opencode/big-pickle'
      : options[0].value;

    return {
      OPTIONS: options,
      DEFAULT,
    };
  } catch (error) {
    console.error('[OpenCodeProviderModels] Failed to load live model catalog:', error);
    // Fall through to the last good cache or the source-controlled defaults.
    return currentCache ?? OPENCODE_PREDEFINED_MODELS;
  }
};

type OpenCodeProviderModelsDependencies = {
  execFile?: OpenCodeExecFile;
};

/** Provider registry model adapter for OpenCode, now backed by the OpenCode CLI. */
export class OpenCodeProviderModels implements IProviderModels {
  private readonly deps: OpenCodeProviderModelsDependencies;

  private cache: ProviderModelsDefinition | null = null;
  private cacheAt = 0;
  private loadPromise: Promise<ProviderModelsDefinition> | null = null;

  constructor(deps: OpenCodeProviderModelsDependencies = {}) {
    this.deps = deps;
  }

  async getSupportedModels(forceRefresh?: boolean): Promise<ProviderModelsDefinition> {
    if (forceRefresh) {
      this.cache = null;
      this.loadPromise = null;
    }

    if (this.cache && Date.now() - this.cacheAt < MODEL_CACHE_TTL_MS) {
      return this.cache;
    }

    if (this.loadPromise) {
      return this.loadPromise;
    }

    this.loadPromise = loadOpenCodeModels(this.deps, false, this.cache, this.cacheAt)
      .then((models) => {
        this.cache = models;
        this.cacheAt = Date.now();
        return models;
      })
      .finally(() => {
        this.loadPromise = null;
      });

    return this.loadPromise;
  }

  async getCurrentActiveModel(sessionId?: string): Promise<ProviderCurrentActiveModel> {
    if (!sessionId?.trim()) {
      return buildDefaultProviderCurrentActiveModel(
        this.cache ?? OPENCODE_PREDEFINED_MODELS,
      );
    }

    // OpenCode's `session` table is keyed by its own session id, so the stable
    // app id has to be translated first; sessions discovered on disk store the
    // provider id in both columns and resolve to themselves.
    const providerSessionId = sessionsDb.getSessionById(sessionId)?.provider_session_id ?? sessionId;

    try {
      const dbPath = getOpenCodeDatabasePath();
      const db = openSqliteReadonlyDatabase(dbPath);

      try {
        const row = db.prepare(`
          SELECT
            s.id AS sessionId,
            s.model AS model,
            s.agent AS agent,
            s.directory AS directory,
            s.time_updated AS timeUpdated,
            s.time_created AS timeCreated
          FROM session s
          WHERE s.id = ?
          ORDER BY COALESCE(s.time_updated, s.time_created, 0) DESC
          LIMIT 1
        `).get(providerSessionId) as {
          sessionId?: string;
          model?: unknown;
          agent?: string | null;
          directory?: string | null;
          timeUpdated?: number | null;
          timeCreated?: number | null;
        } | undefined;

        const model = parseOpenCodeSessionModelValue(row?.model);
        if (model) {
          return {
            model,
          };
        }
      } finally {
        db.close();
      }
    } catch {
      // Fall through to the curated default when OpenCode session lookup fails.
    }

    return buildDefaultProviderCurrentActiveModel(
      this.cache ?? OPENCODE_PREDEFINED_MODELS,
    );
  }
}
