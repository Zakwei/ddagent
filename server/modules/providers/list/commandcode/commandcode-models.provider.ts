import { execFile } from 'node:child_process';
import { promisify } from 'node:util';

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
  PROVIDER_MODEL_CACHE_TTL_MS,
  readFileTail,
  readObjectRecord,
  readOptionalString,
  resolveCommandCodeExecutable,
} from '@/shared/utils.js';
import { sessionsDb } from '@/modules/database/index.js';

import { findCommandCodeTranscriptPath } from './commandcode-sessions.provider.js';

const execFileAsync = promisify(execFile);

type CommandCodeExecFile = (
  file: string,
  args: string[],
  options: { encoding: 'utf8'; timeout: number; maxBuffer: number },
) => Promise<{ stdout: string; stderr: string }>;

const COMMAND_CODE_MODEL_LIST_TIMEOUT_MS = 15_000;

/**
 * Static fallback catalog served while the CLI is unreachable or uninstalled —
 * the same fallback role `OPENCODE_PREDEFINED_MODELS` plays for OpenCode.
 * Command Code's bundled catalog (v1.74) defaults to deepseek/deepseek-v4-flash.
 */
const COMMAND_CODE_PREDEFINED_MODELS: ProviderModelsDefinition = {
  OPTIONS: [
    {
      value: 'deepseek/deepseek-v4-flash',
      label: 'deepseek-v4-flash',
      description: 'Fast hybrid-attention reasoning',
      tier: 'paid',
    },
    {
      value: 'deepseek/deepseek-v4-pro',
      label: 'deepseek-v4-pro',
      description: 'Hybrid-attention long-context reasoning',
      tier: 'paid',
    },
    {
      value: 'claude-sonnet-5-5',
      label: 'claude-sonnet-5-5',
      description: 'Best combo of speed & intelligence',
      tier: 'paid',
    },
    {
      value: 'gpt-6-astra',
      label: 'gpt-6-astra',
      description: 'Most capable OpenAI model for demanding reasoning & agents',
      tier: 'paid',
    },
  ],
  DEFAULT: 'deepseek/deepseek-v4-flash',
};

/**
 * One `cmd --list-models` row: `<model-id><2+ spaces><description>`. Section
 * headers ("Open Source", "Anthropic") and the trailing "Pass the full id…"
 * footer never match that shape.
 */
const MODEL_ROW_PATTERN = /^([A-Za-z0-9][\w./:-]*)\s{2,}(\S.*)$/;

function isFreeCommandCodeModel(id: string, description: string): boolean {
  return /^FREE\b/.test(description) || /:free$/i.test(id) || /-free$/i.test(id);
}

/**
 * Splits `cmd --list-models` output into catalog options. Output is
 * human-readable (no JSON flag), so this is a best-effort table parse: the
 * `(default)` marker picks DEFAULT, `FREE` markers set the free tier, and
 * everything after the docs footer (e.g. headless-only "Decision models") is
 * excluded.
 */
export function parseCommandCodeModelList(stdout: string): ProviderModelsDefinition | null {
  const options: ProviderModelOption[] = [];
  let defaultModel: string | undefined;

  for (const line of stdout.split(/\r?\n/)) {
    const trimmed = line.trimEnd();
    if (/^Pass the full id/i.test(trimmed) || /^Docs:/i.test(trimmed)) {
      break;
    }
    const match = MODEL_ROW_PATTERN.exec(trimmed);
    if (!match) {
      continue;
    }
    const id = match[1];
    let description = match[2].trim();
    if (/\(default\)\s*$/i.test(description)) {
      defaultModel = id;
      description = description.replace(/\s*\(default\)\s*$/i, '').trim();
    }
    options.push({
      value: id,
      label: id.split('/').pop() ?? id,
      description,
      tier: isFreeCommandCodeModel(id, description) ? 'free' : 'paid',
    });
  }

  if (options.length === 0) {
    return null;
  }

  return {
    OPTIONS: options,
    DEFAULT: defaultModel ?? options[0].value,
  };
}

/** Loads the live Command Code model catalog via `<cli> --list-models`. */
const loadCommandCodeModels = async (
  deps: { execFile?: CommandCodeExecFile } = {},
): Promise<ProviderModelsDefinition> => {
  const executable = resolveCommandCodeExecutable();
  if (!executable) {
    throw new Error('Command Code CLI is not installed.');
  }
  const run = deps.execFile ?? execFileAsync;
  const { stdout } = await run(executable, ['--list-models'], {
    encoding: 'utf8',
    timeout: COMMAND_CODE_MODEL_LIST_TIMEOUT_MS,
    maxBuffer: 4 * 1024 * 1024,
  });

  const parsed = parseCommandCodeModelList(stdout);
  if (!parsed) {
    throw new Error('Command Code returned an empty model list.');
  }
  return parsed;
};

/**
 * Reads the last model recorded in a session transcript — assistant `message`
 * entries carry `model`, `model_change` entries carry `model`. Returns the
 * newest one found scanning from the file tail backwards.
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
    if (entry?.type === 'model_change') {
      const model = readOptionalString(entry.model);
      if (model) {
        return model;
      }
    }
    if (entry?.type === 'message' && readObjectRecord(entry.message)?.role === 'assistant') {
      const model = readOptionalString(entry.model);
      if (model) {
        return model;
      }
    }
  }
  return undefined;
}

/** Provider registry model adapter for Command Code, backed by the CLI catalog. */
export class CommandCodeProviderModels implements IProviderModels {
  private readonly deps: { execFile?: CommandCodeExecFile };

  private readonly catalogCache = createRefreshingCache(
    () => loadCommandCodeModels(this.deps),
    PROVIDER_MODEL_CACHE_TTL_MS,
    COMMAND_CODE_PREDEFINED_MODELS,
  );

  constructor(deps: { execFile?: CommandCodeExecFile } = {}) {
    this.deps = deps;
  }

  async getSupportedModels(forceRefresh?: boolean): Promise<ProviderModelsDefinition> {
    return this.catalogCache.get(forceRefresh);
  }

  async getCurrentActiveModel(sessionId?: string): Promise<ProviderCurrentActiveModel> {
    const fallback = () => buildDefaultProviderCurrentActiveModel(
      this.catalogCache.peek() ?? COMMAND_CODE_PREDEFINED_MODELS,
    );

    if (!sessionId?.trim()) {
      return fallback();
    }

    const providerSessionId = sessionsDb.getSessionById(sessionId)?.provider_session_id ?? sessionId;
    try {
      const transcriptPath = await findCommandCodeTranscriptPath(sessionId, providerSessionId);
      const model = transcriptPath ? await readTranscriptModel(transcriptPath) : undefined;
      return model ? { model } : fallback();
    } catch {
      return fallback();
    }
  }
}
