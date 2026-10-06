import { readFile } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';

import TOML from '@iarna/toml';

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
  readObjectRecord,
  readOptionalString,
} from '@/shared/utils.js';

type CodexExecFile = (
  file: string,
  args: string[],
  options: { encoding: 'utf8'; timeout: number; maxBuffer: number },
) => Promise<{ stdout: string; stderr: string }>;

const CODEX_MODEL_LIST_TIMEOUT_MS = 15_000;

const effortOf = (
  defaultEffort: string,
  values: string[],
): ProviderModelOption['effort'] => ({
  default: defaultEffort,
  values: values.map((value) => ({ value })),
});

/**
 * Static fallback catalog served while the CLI is unreachable or uninstalled —
 * the same fallback role `OPENCODE_PREDEFINED_MODELS` plays for OpenCode.
 * Mirrors `codex debug models` (visible entries, priority order).
 */
export const CODEX_PREDEFINED_MODELS: ProviderModelsDefinition = {
  OPTIONS: [
    {
      value: 'gpt-6.1-sol',
      label: 'GPT-6.1-Sol',
      description: 'Latest workhorse model for coding and everyday work.',
      effort: effortOf('low', ['low', 'medium', 'high', 'xhigh', 'max', 'ultra']),
    },
    {
      value: 'gpt-6-astra',
      label: 'GPT-6-Astra',
      description: 'Frontier intelligence for the most demanding work.',
      effort: effortOf('low', ['low', 'medium', 'high', 'xhigh', 'max', 'ultra']),
    },
    {
      value: 'gpt-6-sol',
      label: 'GPT-6-Sol',
      description: 'Previous generation workhorse model.',
      effort: effortOf('medium', ['low', 'medium', 'high', 'xhigh', 'max', 'ultra']),
    },
    {
      value: 'gpt-6-luna',
      label: 'GPT-6-Luna',
      description: 'Fast and affordable model for easier tasks.',
      effort: effortOf('medium', ['low', 'medium', 'high', 'xhigh', 'max']),
    },
    {
      value: 'gpt-5.6-sol',
      label: 'GPT-5.6-Sol',
      description: 'Older generation workhorse model.',
      effort: effortOf('low', ['low', 'medium', 'high', 'xhigh', 'max', 'ultra']),
    },
    {
      value: 'gpt-5.6-terra',
      label: 'GPT-5.6-Terra',
      description: 'Older balanced model for straightforward work.',
      effort: effortOf('medium', ['low', 'medium', 'high', 'xhigh', 'max', 'ultra']),
    },
    {
      value: 'gpt-5.6-luna',
      label: 'GPT-5.6-Luna',
      description: 'Older fast and efficient model.',
      effort: effortOf('medium', ['low', 'medium', 'high', 'xhigh', 'max']),
    },
    {
      value: 'gpt-5.5',
      label: 'GPT-5.5',
      description: 'Legacy coding model.',
      effort: effortOf('medium', ['low', 'medium', 'high', 'xhigh']),
    },
  ],
  DEFAULT: 'gpt-6.1-sol',
};

const readEffortValues = (model: AnyRecord): string[] => {
  const levels = Array.isArray(model.supported_reasoning_levels)
    ? model.supported_reasoning_levels
    : [];
  const values = levels
    .map((entry) => readOptionalString(readObjectRecord(entry)?.effort))
    .filter((value): value is string => !!value);
  return values.length > 0 ? [...new Set(values)] : ['low', 'medium', 'high', 'xhigh'];
};

/**
 * Splits `codex debug models` JSON output into a catalog definition.
 * Hidden entries (internal models like daybreak/auto-review) are skipped;
 * the lowest `priority` value wins as DEFAULT.
 */
export function parseCodexDebugModels(stdout: string): ProviderModelsDefinition | null {
  let parsed: AnyRecord | null = null;
  try {
    parsed = readObjectRecord(JSON.parse(stdout));
  } catch {
    return null;
  }
  const models = Array.isArray(parsed?.models) ? parsed.models : [];
  const options: Array<ProviderModelOption & { priority: number }> = [];

  for (const entry of models) {
    const model = readObjectRecord(entry);
    if (!model || model.visibility !== 'list') {
      continue;
    }
    const slug = readOptionalString(model.slug);
    if (!slug) {
      continue;
    }
    const values = readEffortValues(model);
    const defaultEffort = readOptionalString(model.default_reasoning_level)
      ?? values[0]
      ?? 'medium';
    options.push({
      value: slug,
      label: readOptionalString(model.display_name) ?? slug,
      description: readOptionalString(model.description),
      effort: effortOf(values.includes(defaultEffort) ? defaultEffort : values[0], values),
      priority: typeof model.priority === 'number' ? model.priority : Number.MAX_SAFE_INTEGER,
    });
  }

  if (options.length === 0) {
    return null;
  }

  options.sort((a, b) => a.priority - b.priority);
  return {
    OPTIONS: options.map(({ priority: _priority, ...option }) => option),
    DEFAULT: options[0].value,
  };
}

/** Loads the live Codex model catalog via `codex debug models`. */
const loadCodexModels = async (
  deps: { execFile?: CodexExecFile } = {},
): Promise<ProviderModelsDefinition> => {
  const run = deps.execFile ?? execCliFile;
  const { stdout } = await run('codex', ['debug', 'models'], {
    encoding: 'utf8',
    timeout: CODEX_MODEL_LIST_TIMEOUT_MS,
    maxBuffer: 16 * 1024 * 1024,
  });

  const parsed = parseCodexDebugModels(stdout);
  if (!parsed) {
    throw new Error('Codex returned an empty model list.');
  }
  return parsed;
};

const CODEX_CONFIG_PATH = path.join(os.homedir(), '.codex', 'config.toml');

/** Provider registry model adapter for Codex, backed by the CLI catalog. */
export class CodexProviderModels implements IProviderModels {
  private readonly deps: { execFile?: CodexExecFile };

  private readonly catalogCache = createRefreshingCache(
    () => loadCodexModels(this.deps),
    PROVIDER_MODEL_CACHE_TTL_MS,
    CODEX_PREDEFINED_MODELS,
  );

  constructor(deps: { execFile?: CodexExecFile } = {}) {
    this.deps = deps;
  }

  async getSupportedModels(forceRefresh?: boolean): Promise<ProviderModelsDefinition> {
    return this.catalogCache.get(forceRefresh);
  }

  async getCurrentActiveModel(): Promise<ProviderCurrentActiveModel> {
    const fallback = () => buildDefaultProviderCurrentActiveModel(
      this.catalogCache.peek() ?? CODEX_PREDEFINED_MODELS,
    );

    try {
      const raw = await readFile(CODEX_CONFIG_PATH, 'utf8');
      const parsed = readObjectRecord(TOML.parse(raw));
      const model = readOptionalString(parsed?.model);
      if (!model) {
        return fallback();
      }

      return {
        model,
      };
    } catch {
      return fallback();
    }
  }
}
