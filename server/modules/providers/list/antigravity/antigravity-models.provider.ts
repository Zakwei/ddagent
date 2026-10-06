import type { IProviderModels } from '@/shared/interfaces.js';
import type {
  AnyRecord,
  ProviderCurrentActiveModel,
  ProviderModelOption,
  ProviderModelsDefinition,
} from '@/shared/types.js';
import {
  buildDefaultProviderCurrentActiveModel,
  createRefreshingCache,
  execCliFile,
  PROVIDER_MODEL_CACHE_TTL_MS,
  readFileTail,
  readObjectRecord,
  readOptionalString,
  resolveAntigravityExecutable,
} from '@/shared/utils.js';
import { sessionsDb } from '@/modules/database/index.js';

import { findAntigravityTranscriptPath } from './antigravity-sessions.provider.js';

type AntigravityExecFile = (
  file: string,
  args: string[],
  options: { encoding: 'utf8'; timeout: number; maxBuffer: number },
) => Promise<{ stdout: string; stderr: string }>;

const ANTIGRAVITY_MODEL_LIST_TIMEOUT_MS = 15_000;

/**
 * Reasoning-effort tiers `agy --effort` accepts (`low|medium|high|max`,
 * verified against agy 1.2.14). `default` omits the flag and defers to the
 * CLI's own per-model setting.
 */
const ANTIGRAVITY_EFFORT: ProviderModelOption['effort'] = {
  default: 'default',
  values: [
    { value: 'default', description: 'Provider default for the model' },
    { value: 'low', description: 'Low reasoning effort' },
    { value: 'medium', description: 'Medium reasoning effort' },
    { value: 'high', description: 'High reasoning effort' },
    { value: 'max', description: 'Maximum reasoning effort' },
  ],
};

/**
 * Static fallback catalog served while the CLI is unreachable or uninstalled.
 * Mirrors `agy models` output from agy 1.2.14 (Google Antigravity default plan).
 */
const ANTIGRAVITY_PREDEFINED_MODELS: ProviderModelsDefinition = {
  OPTIONS: [
    {
      value: 'gemini-3.8-flash-high',
      label: 'gemini-3.8-flash-high',
      description: 'Gemini 3.8 Flash (High)',
      tier: 'paid',
      effort: ANTIGRAVITY_EFFORT,
    },
    {
      value: 'gemini-3.8-flash-medium',
      label: 'gemini-3.8-flash-medium',
      description: 'Gemini 3.8 Flash (Medium)',
      tier: 'paid',
      effort: ANTIGRAVITY_EFFORT,
    },
    {
      value: 'gemini-3.1-pro-high',
      label: 'gemini-3.1-pro-high',
      description: 'Gemini 3.1 Pro (High)',
      tier: 'paid',
      effort: ANTIGRAVITY_EFFORT,
    },
    {
      value: 'claude-sonnet-4-6',
      label: 'claude-sonnet-4-6',
      description: 'Claude Sonnet 4.6 (Thinking)',
      tier: 'paid',
      effort: ANTIGRAVITY_EFFORT,
    },
    {
      value: 'claude-opus-4-6-thinking',
      label: 'claude-opus-4-6-thinking',
      description: 'Claude Opus 4.6 (Thinking)',
      tier: 'paid',
      effort: ANTIGRAVITY_EFFORT,
    },
  ],
  DEFAULT: 'gemini-3.8-flash-high',
};

/**
 * One `agy models` row: `<model-id><TAB><label>` (tab-separated, e.g.
 * `gemini-3.8-flash-high\tGemini 3.8 Flash (High)`). Non-tab lines such as the
 * "Fetching available models..." header never match.
 */
const MODEL_ROW_PATTERN = /^([A-Za-z0-9][\w.:/-]*)\t+(.+)$/;

/**
 * Splits `agy models` output into catalog options. The list carries no
 * default marker, so the first row wins as DEFAULT (the CLI orders it as the
 * recommended tier of the latest Flash model).
 */
export function parseAntigravityModelList(stdout: string): ProviderModelsDefinition | null {
  const options: ProviderModelOption[] = [];

  for (const line of stdout.split(/\r?\n/)) {
    const match = MODEL_ROW_PATTERN.exec(line.trimEnd());
    if (!match) {
      continue;
    }
    const id = match[1];
    const label = match[2].trim();
    options.push({
      value: id,
      label: id,
      description: label,
      tier: /free/i.test(label) || /-free$/i.test(id) ? 'free' : 'paid',
      effort: ANTIGRAVITY_EFFORT,
    });
  }

  if (options.length === 0) {
    return null;
  }

  return {
    OPTIONS: options,
    DEFAULT: options[0].value,
  };
}

/** Loads the live Antigravity model catalog via `agy models`. */
const loadAntigravityModels = async (
  deps: { execFile?: AntigravityExecFile } = {},
): Promise<ProviderModelsDefinition> => {
  const executable = resolveAntigravityExecutable();
  if (!executable) {
    throw new Error('Antigravity CLI is not installed.');
  }
  const run = deps.execFile ?? execCliFile;
  const { stdout } = await run(executable, ['models'], {
    encoding: 'utf8',
    timeout: ANTIGRAVITY_MODEL_LIST_TIMEOUT_MS,
    maxBuffer: 4 * 1024 * 1024,
  });

  const parsed = parseAntigravityModelList(stdout);
  if (!parsed) {
    throw new Error('Antigravity returned an empty model list.');
  }
  return parsed;
};

/**
 * Reads the last model recorded in a session's mirror transcript — the
 * runtime stamps `type:"session"` headers and assistant `message` rows with
 * the model id it launched with. Newest entry wins scanning from the tail.
 */
async function readTranscriptModel(transcriptPath: string): Promise<string | undefined> {
  const tail = await readFileTail(transcriptPath, 512 * 1024);
  const lines = tail.trim().split('\n');
  for (let index = lines.length - 1; index >= 0; index -= 1) {
    let entry: AnyRecord | null = null;
    try {
      entry = JSON.parse(lines[index]) as AnyRecord;
    } catch {
      continue;
    }
    if (entry?.type === 'message' && readObjectRecord(entry.message)?.role === 'assistant') {
      const model = readOptionalString(entry.model);
      if (model) {
        return model;
      }
    }
    if (entry?.type === 'session') {
      const model = readOptionalString(entry.model);
      if (model) {
        return model;
      }
    }
  }
  return undefined;
}

/** Provider registry model adapter for Antigravity, backed by `agy models`. */
export class AntigravityProviderModels implements IProviderModels {
  private readonly deps: { execFile?: AntigravityExecFile };

  private readonly catalogCache = createRefreshingCache(
    () => loadAntigravityModels(this.deps),
    PROVIDER_MODEL_CACHE_TTL_MS,
    ANTIGRAVITY_PREDEFINED_MODELS,
  );

  constructor(deps: { execFile?: AntigravityExecFile } = {}) {
    this.deps = deps;
  }

  async getSupportedModels(forceRefresh?: boolean): Promise<ProviderModelsDefinition> {
    return this.catalogCache.get(forceRefresh);
  }

  async getCurrentActiveModel(sessionId?: string): Promise<ProviderCurrentActiveModel> {
    const fallback = () => buildDefaultProviderCurrentActiveModel(
      this.catalogCache.peek() ?? ANTIGRAVITY_PREDEFINED_MODELS,
    );

    if (!sessionId?.trim()) {
      return fallback();
    }

    const providerSessionId = sessionsDb.getSessionById(sessionId)?.provider_session_id ?? sessionId;
    try {
      const transcriptPath = await findAntigravityTranscriptPath(sessionId, providerSessionId);
      const model = transcriptPath ? await readTranscriptModel(transcriptPath) : undefined;
      return model ? { model } : fallback();
    } catch {
      return fallback();
    }
  }
}
