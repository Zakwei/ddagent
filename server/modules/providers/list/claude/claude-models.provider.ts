import { readFile } from 'node:fs/promises';
import os from 'node:os';

import { query } from '@anthropic-ai/claude-agent-sdk';
import type { ModelInfo, SDKUserMessage } from '@anthropic-ai/claude-agent-sdk';

import { sessionsDb } from '@/modules/database/index.js';
import type { IProviderModels } from '@/shared/interfaces.js';
import type {
  ProviderCurrentActiveModel,
  ProviderModelOption,
  ProviderModelsDefinition,
} from '@/shared/types.js';
import {
  buildDefaultProviderCurrentActiveModel,
  createRefreshingCache,
  PROVIDER_MODEL_CACHE_TTL_MS,
  providerChildEnv,
} from '@/shared/utils.js';
import { resolveClaudeCodeExecutablePath } from '@/shared/index.js';

/**
 * Static fallback catalog served until the live CLI catalog loads, and whenever
 * it cannot be reached (CLI missing, logged out, probe timed out) — the same
 * fallback role `COMMAND_CODE_PREDEFINED_MODELS` plays for Command Code.
 *
 * Also consumed by the Claude runtime provider to validate reasoning-effort
 * values when no live catalog is available yet.
 */
export const CLAUDE_PREDEFINED_MODELS: ProviderModelsDefinition = {
  OPTIONS: [
    {
      value: 'default',
      label: 'Default (recommended)',
      description: 'Use the recommended model for your Claude account and deployment.',
      effort: {
        default: 'high',
        values: [
          { value: 'low' },
          { value: 'medium' },
          { value: 'high' },
          { value: 'max' },
        ],
      },
    },
    {
      value: 'best',
      label: 'Best available',
      description: 'Use Fable 5 when available, otherwise the latest Opus model.',
      effort: {
        default: 'high',
        values: [
          { value: 'low' },
          { value: 'medium' },
          { value: 'high' },
          { value: 'xhigh' },
          { value: 'max' },
        ],
      },
    },
    {
      value: 'fable',
      label: 'Fable 5',
      description: 'Most capable Claude model for the hardest, longest-running tasks.',
      effort: {
        default: 'high',
        values: [
          { value: 'low' },
          { value: 'medium' },
          { value: 'high' },
          { value: 'xhigh' },
          { value: 'max' },
        ],
      },
    },
    {
      value: 'sonnet',
      label: 'Sonnet',
      description: 'Latest Sonnet model for everyday coding tasks.',
      effort: {
        default: 'high',
        values: [
          { value: 'low' },
          { value: 'medium' },
          { value: 'high' },
          { value: 'xhigh' },
          { value: 'max' },
        ],
      },
    },
    {
      value: 'sonnet[1m]',
      label: 'Sonnet (1M context)',
      description: 'Latest Sonnet model with a 1M context window.',
      effort: {
        default: 'high',
        values: [
          { value: 'low' },
          { value: 'medium' },
          { value: 'high' },
          { value: 'xhigh' },
          { value: 'max' },
        ],
      },
    },
    {
      value: 'opus',
      label: 'Opus',
      description: 'Latest Opus model for complex reasoning and coding tasks.',
      effort: {
        default: 'high',
        values: [
          { value: 'low' },
          { value: 'medium' },
          { value: 'high' },
          { value: 'xhigh' },
          { value: 'max' },
        ],
      },
    },
    {
      value: 'opus[1m]',
      label: 'Opus (1M context)',
      description: 'Latest Opus model with a 1M context window.',
      effort: {
        default: 'high',
        values: [
          { value: 'low' },
          { value: 'medium' },
          { value: 'high' },
          { value: 'xhigh' },
          { value: 'max' },
        ],
      },
    },
    {
      value: 'haiku',
      label: 'Haiku',
      description: 'Fast and efficient Claude model for simple tasks.',
    },
    {
      value: 'opusplan',
      label: 'Opus Plan',
      description: 'Use Opus while planning, then switch to Sonnet for execution.',
      effort: {
        default: 'high',
        values: [
          { value: 'low' },
          { value: 'medium' },
          { value: 'high' },
          { value: 'xhigh' },
          { value: 'max' },
        ],
      },
    },
  ],
  DEFAULT: 'default',
};

type ClaudeInitEvent = {
  sessionId?: string;
  session_id?: string;
  type?: string;
  subtype?: string;
  model?: string;
  message?: {
    content?: unknown;
    model?: string;
  };
};

const ANSI_PATTERN = new RegExp(
  '[\\u001B\\u009B][[\\]()#;?]*(?:'
  + '(?:[0-9]{1,4}(?:;[0-9]{0,4})*)?[0-9A-ORZcf-nqry=><]'
  + '|(?:[\\dA-PR-TZcf-ntqry=><~]))',
  'g',
);

const extractClaudeEventModel = (event: ClaudeInitEvent, sessionId: string): string | null => {
  const eventSessionId = event.sessionId ?? event.session_id;
  if (eventSessionId && eventSessionId !== sessionId) {
    return null;
  }

  const contentModel = extractClaudeModelFromMessageContent(event.message?.content);
  if (contentModel) {
    return contentModel;
  }

  const directModel = event.model?.trim();
  if (directModel) {
    return directModel;
  }

  const messageModel = event.message?.model?.trim();
  return messageModel || null;
};

const stripAnsi = (value: string): string => value.replace(ANSI_PATTERN, '');

const extractTaggedContent = (content: string, tagName: string): string | null => {
  const escapedTagName = tagName.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const match = new RegExp(`<${escapedTagName}>([\\s\\S]*?)<\\/${escapedTagName}>`).exec(content);
  return match ? match[1] : null;
};

const extractClaudeModelFromTextContent = (content: string): string | null => {
  const localCommandStdout = extractTaggedContent(content, 'local-command-stdout');
  if (localCommandStdout !== null) {
    const cleanedStdout = stripAnsi(localCommandStdout).replace(/\s+/g, ' ').trim();
    const changedModel = /(?:set|changed|switched)\s+model\s+to\s+(.+?)\.?$/i.exec(cleanedStdout);
    if (changedModel?.[1]?.trim()) {
      return changedModel[1].trim();
    }
  }

  const modelTag = extractTaggedContent(content, 'model')?.trim();
  return modelTag || null;
};

const extractClaudeModelFromMessageContent = (content: unknown): string | null => {
  if (typeof content === 'string') {
    return extractClaudeModelFromTextContent(content);
  }

  if (!Array.isArray(content)) {
    return null;
  }

  for (const part of content) {
    if (!part || typeof part !== 'object' || !('text' in part) || typeof part.text !== 'string') {
      continue;
    }

    const model = extractClaudeModelFromTextContent(part.text);
    if (model) {
      return model;
    }
  }

  return null;
};

const readClaudeSessionModelFromJsonl = async (
  sessionId: string,
  jsonlPath: string,
): Promise<ProviderCurrentActiveModel | null> => {
  const content = await readFile(jsonlPath, 'utf8');
  const lines = content
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter(Boolean);

  for (let index = lines.length - 1; index >= 0; index -= 1) {
    try {
      const event = JSON.parse(lines[index]) as ClaudeInitEvent;
      const model = extractClaudeEventModel(event, sessionId);
      if (model) {
        return { model };
      }
    } catch {
      // Skip malformed JSONL lines that can happen during concurrent writes.
    }
  }

  return null;
};

const CLAUDE_MODEL_LIST_TIMEOUT_MS = 20_000;

/**
 * Catalog id Claude Code uses for "whatever this account should run by
 * default". It is a real selectable option, so it also makes the best
 * `DEFAULT` when the CLI reports it.
 */
const CLAUDE_DEFAULT_MODEL_VALUE = 'default';

/** Effort level the picker pre-selects when a model exposes several. */
const CLAUDE_PREFERRED_EFFORT = 'high';

const toClaudeModelOption = (model: ModelInfo): ProviderModelOption => {
  const effortLevels = model.supportsEffort ? model.supportedEffortLevels ?? [] : [];
  const option: ProviderModelOption = {
    value: model.value,
    label: model.displayName?.trim() || model.value,
  };

  const description = model.description?.trim();
  if (description) {
    option.description = description;
  }

  if (effortLevels.length > 0) {
    option.effort = {
      default: effortLevels.includes(CLAUDE_PREFERRED_EFFORT)
        ? CLAUDE_PREFERRED_EFFORT
        : effortLevels[effortLevels.length - 1],
      values: effortLevels.map((value) => ({ value })),
    };
  }

  return option;
};

/**
 * Converts the CLI's `initialize` model list into the catalog shape the model
 * picker consumes. Exported for the Claude models tests, which assert the
 * mapping without spawning the CLI.
 */
export const buildClaudeModelsDefinition = (
  models: ModelInfo[],
): ProviderModelsDefinition | null => {
  const options = models
    .filter((model) => typeof model?.value === 'string' && model.value.trim().length > 0)
    .map(toClaudeModelOption);

  if (options.length === 0) {
    return null;
  }

  const hasDefaultOption = options.some((option) => option.value === CLAUDE_DEFAULT_MODEL_VALUE);
  return {
    OPTIONS: options,
    DEFAULT: hasDefaultOption ? CLAUDE_DEFAULT_MODEL_VALUE : options[0].value,
  };
};

/**
 * Loads the live Claude catalog from the CLI.
 *
 * The SDK answers `supportedModels()` straight from the control-protocol
 * `initialize` response, so the probe runs in streaming-input mode and never
 * yields a message: the CLI hands over the catalog without starting a turn,
 * which is why this no longer writes a stray session transcript the way the
 * old `prompt: 'Get supported models'` call did. `cwd` points at the temp dir
 * so nothing is attributed to whichever workspace triggered the refresh.
 */
const loadClaudeModels = async (): Promise<ProviderModelsDefinition> => {
  const abortController = new AbortController();
  let releaseInput = (): void => {};
  const inputClosed = new Promise<void>((resolve) => {
    releaseInput = resolve;
  });

  async function* idleInput(): AsyncGenerator<SDKUserMessage> {
    await inputClosed;
  }

  const queryInstance = query({
    prompt: idleInput(),
    options: {
      cwd: os.tmpdir(),
      env: providerChildEnv(),
      pathToClaudeCodeExecutable: resolveClaudeCodeExecutablePath(process.env.CLAUDE_CLI_PATH),
      abortController,
    },
  });

  let timeoutHandle: NodeJS.Timeout | undefined;
  try {
    const models = await Promise.race([
      queryInstance.supportedModels(),
      new Promise<never>((_resolve, reject) => {
        timeoutHandle = setTimeout(
          () => reject(new Error('Claude CLI did not report its model list in time.')),
          CLAUDE_MODEL_LIST_TIMEOUT_MS,
        );
      }),
    ]);

    const definition = buildClaudeModelsDefinition(models);
    if (!definition) {
      throw new Error('Claude CLI returned an empty model list.');
    }
    return definition;
  } finally {
    if (timeoutHandle) {
      clearTimeout(timeoutHandle);
    }
    releaseInput();
    abortController.abort();
    try {
      queryInstance.close();
    } catch {
      // The CLI may already be gone when the probe failed; nothing to tear down.
    }
  }
};

export class ClaudeProviderModels implements IProviderModels {
  private readonly catalogCache = createRefreshingCache(
    loadClaudeModels,
    PROVIDER_MODEL_CACHE_TTL_MS,
    CLAUDE_PREDEFINED_MODELS,
  );

  async getSupportedModels(forceRefresh?: boolean): Promise<ProviderModelsDefinition> {
    return this.catalogCache.get(forceRefresh);
  }

  async getCurrentActiveModel(sessionId?: string): Promise<ProviderCurrentActiveModel> {
    const fallback = (): ProviderCurrentActiveModel => buildDefaultProviderCurrentActiveModel(
      this.catalogCache.peek() ?? CLAUDE_PREDEFINED_MODELS,
    );

    if (!sessionId?.trim()) {
      return fallback();
    }

    try {
      const jsonlPath = sessionsDb.getSessionById(sessionId)?.jsonl_path;
      const activeModel = jsonlPath
        ? await readClaudeSessionModelFromJsonl(sessionId, jsonlPath)
        : null;
      if (activeModel?.model) {
        return activeModel;
      }
    } catch {
      // Fall through to the provider default when the session-backed lookup fails.
    }

    return fallback();
  }
}
