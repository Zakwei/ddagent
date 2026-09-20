import fsSync, { type Dirent } from 'node:fs';
import fsp from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';

import { sessionsDb } from '@/modules/database/index.js';
import type { AnyRecord } from '@/shared/types.js';
import { AppError, getOpenCodeDatabasePath, openSqliteReadonlyDatabase } from '@/shared/utils.js';

type SessionRow = NonNullable<ReturnType<typeof sessionsDb.getSessionById>>;

type ProviderTokenUsageServiceDependencies = {
  getSessionById: (sessionId: string) => SessionRow | null | undefined;
  getHomeDirectory: () => string;
  getOpenCodeDatabasePath: () => string;
  fileExists: (filePath: string) => boolean;
  readDirectory: (directoryPath: string) => Promise<Dirent[]>;
  readTextFile: (filePath: string) => Promise<string>;
  getClaudeContextWindow: () => string | undefined;
};

type TokenUsageResult = {
  used: number;
  total?: number;
  inputTokens: number;
  outputTokens: number;
  cacheReadTokens?: number;
  cacheCreationTokens?: number;
  cacheTokens?: number;
  /**
   * Provider-reported cost in USD for the session, when the provider stores it
   * (currently OpenCode). Absent for providers that only expose token counts,
   * in which case the client falls back to its own price-table estimate.
   */
  costUsd?: number;
  breakdown: {
    input: number;
    output: number;
    cacheRead?: number;
    cacheCreation?: number;
  };
  unsupported?: boolean;
  message?: string;
};

type OpenCodeTokenRow = {
  inputTokens: number | null;
  outputTokens: number | null;
  reasoningTokens: number | null;
  cacheReadTokens: number | null;
  cacheWriteTokens: number | null;
  costUsd: number | null;
};

const defaultDependencies: ProviderTokenUsageServiceDependencies = {
  getSessionById: (sessionId) => sessionsDb.getSessionById(sessionId),
  getHomeDirectory: () => os.homedir(),
  getOpenCodeDatabasePath,
  fileExists: (filePath) => fsSync.existsSync(filePath),
  readDirectory: (directoryPath) => fsp.readdir(directoryPath, { withFileTypes: true }),
  readTextFile: (filePath) => fsp.readFile(filePath, 'utf8'),
  getClaudeContextWindow: () => process.env.CONTEXT_WINDOW,
};

function readUsageNumber(value: unknown): number {
  const parsedValue = Number(value);
  return Number.isFinite(parsedValue) ? parsedValue : 0;
}

async function findCodexSessionFile(
  directoryPath: string,
  providerSessionId: string,
  dependencies: ProviderTokenUsageServiceDependencies,
): Promise<string | null> {
  let entries: Dirent[];
  try {
    entries = await dependencies.readDirectory(directoryPath);
  } catch {
    // Codex session folders are date-partitioned and can disappear while a
    // cleanup is running. An unreadable branch is simply not a match.
    return null;
  }

  for (const entry of entries) {
    const entryPath = path.join(directoryPath, entry.name);
    if (entry.isDirectory()) {
      const nestedMatch = await findCodexSessionFile(entryPath, providerSessionId, dependencies);
      if (nestedMatch) {
        return nestedMatch;
      }
      continue;
    }

    if (entry.name.includes(providerSessionId) && entry.name.endsWith('.jsonl')) {
      return entryPath;
    }
  }

  return null;
}

function readCodexTokenUsage(fileContent: string): TokenUsageResult {
  let inputTokens = 0;
  let outputTokens = 0;
  let cacheReadTokens = 0;
  let totalTokens = 0;
  let contextWindow = 200_000;
  const lines = fileContent.trim().split('\n');

  for (let index = lines.length - 1; index >= 0; index -= 1) {
    try {
      const entry = JSON.parse(lines[index]) as AnyRecord;
      const tokenInfo = entry.type === 'event_msg' && entry.payload?.type === 'token_count'
        ? entry.payload.info
        : null;
      if (!tokenInfo) {
        continue;
      }

      if (tokenInfo.total_token_usage) {
        const reportedInput = readUsageNumber(tokenInfo.total_token_usage.input_tokens);
        cacheReadTokens = readUsageNumber(
          tokenInfo.total_token_usage.cached_input_tokens
            ?? tokenInfo.total_token_usage.cache_read_input_tokens,
        );
        // Codex folds cached input into `input_tokens`; report the direct
        // (uncached) portion so cache reads are not counted as fresh input.
        inputTokens = Math.max(0, reportedInput - cacheReadTokens);
        outputTokens = readUsageNumber(tokenInfo.total_token_usage.output_tokens);
        totalTokens = readUsageNumber(tokenInfo.total_token_usage.total_tokens)
          || inputTokens + cacheReadTokens + outputTokens;
      }
      contextWindow = readUsageNumber(tokenInfo.model_context_window) || contextWindow;
      break;
    } catch {
      // A provider may be writing the last JSONL line while this read happens.
    }
  }

  return {
    used: totalTokens,
    total: contextWindow,
    inputTokens,
    outputTokens,
    cacheReadTokens,
    breakdown: { input: inputTokens, output: outputTokens, cacheRead: cacheReadTokens },
  };
}

function readClaudeTokenUsage(fileContent: string, configuredContextWindow: string | undefined): TokenUsageResult {
  let inputTokens = 0;
  let outputTokens = 0;
  let cacheReadTokens = 0;
  let cacheCreationTokens = 0;
  const lines = fileContent.trim().split('\n');

  for (let index = lines.length - 1; index >= 0; index -= 1) {
    try {
      const entry = JSON.parse(lines[index]) as AnyRecord;
      const usage = entry.type === 'assistant' ? entry.message?.usage : null;
      if (!usage) {
        continue;
      }

      const directInputTokens = readUsageNumber(usage.input_tokens ?? usage.inputTokens);
      cacheReadTokens = readUsageNumber(
        usage.cache_read_input_tokens ?? usage.cacheReadInputTokens ?? usage.cacheReadTokens,
      );
      cacheCreationTokens = readUsageNumber(
        usage.cache_creation_input_tokens
          ?? usage.cacheCreationInputTokens
          ?? usage.cacheCreationTokens,
      );
      // Claude reports the direct prompt tokens separately from cache reads and
      // cache writes. Keep them apart so a cache-heavy session does not look
      // like a huge fresh input; the caller sums them for the context budget.
      inputTokens = directInputTokens;
      outputTokens = readUsageNumber(usage.output_tokens ?? usage.outputTokens);
      break;
    } catch {
      // Skip malformed lines without discarding usage from earlier messages.
    }
  }

  const parsedContextWindow = Number.parseInt(configuredContextWindow ?? '', 10);
  const contextWindow = Number.isFinite(parsedContextWindow) ? parsedContextWindow : 160_000;
  const cacheTokens = cacheReadTokens + cacheCreationTokens;

  return {
    used: inputTokens + cacheReadTokens + cacheCreationTokens + outputTokens,
    total: contextWindow,
    inputTokens,
    outputTokens,
    cacheReadTokens,
    cacheCreationTokens,
    cacheTokens,
    breakdown: {
      input: inputTokens,
      output: outputTokens,
      cacheRead: cacheReadTokens,
      cacheCreation: cacheCreationTokens,
    },
  };
}

function readOpenCodeTokenUsage(databasePath: string, providerSessionId: string): TokenUsageResult {
  const database = openSqliteReadonlyDatabase(databasePath);
  try {
    const columns = database.prepare('PRAGMA table_info(session)').all() as Array<{ name: string }>;
    const columnNames = new Set(columns.map((column) => column.name));
    const requiredColumns = [
      'tokens_input',
      'tokens_output',
      'tokens_reasoning',
      'tokens_cache_read',
      'tokens_cache_write',
    ];

    if (!requiredColumns.every((column) => columnNames.has(column))) {
      return {
        used: 0,
        inputTokens: 0,
        outputTokens: 0,
        breakdown: { input: 0, output: 0 },
        unsupported: true,
        message: 'Token usage tracking is not available in this OpenCode database schema',
      };
    }

    const hasCostColumn = columnNames.has('cost');
    const row = database.prepare(`
      SELECT
        tokens_input AS inputTokens,
        tokens_output AS outputTokens,
        tokens_reasoning AS reasoningTokens,
        tokens_cache_read AS cacheReadTokens,
        tokens_cache_write AS cacheWriteTokens
        ${hasCostColumn ? ', cost AS costUsd' : ', NULL AS costUsd'}
      FROM session
      WHERE id = ?
    `).get(providerSessionId) as OpenCodeTokenRow | undefined;

    if (!row) {
      throw new AppError('OpenCode session was not found.', {
        code: 'OPENCODE_SESSION_NOT_FOUND',
        statusCode: 404,
      });
    }

    // Keep direct prompt tokens separate from cache reads/writes so a
    // cache-heavy session is not reported as a large fresh input.
    const inputTokens = readUsageNumber(row.inputTokens);
    const outputTokens = readUsageNumber(row.outputTokens);
    const cacheReadTokens = readUsageNumber(row.cacheReadTokens);
    const cacheCreationTokens = readUsageNumber(row.cacheWriteTokens);
    const costUsd = readUsageNumber(row.costUsd);
    const used = inputTokens
      + outputTokens
      + readUsageNumber(row.reasoningTokens)
      + cacheReadTokens
      + cacheCreationTokens;

    return {
      used,
      inputTokens,
      outputTokens,
      cacheReadTokens,
      cacheCreationTokens,
      cacheTokens: cacheReadTokens + cacheCreationTokens,
      ...(costUsd > 0 ? { costUsd } : {}),
      breakdown: {
        input: inputTokens,
        output: outputTokens,
        cacheRead: cacheReadTokens,
        cacheCreation: cacheCreationTokens,
      },
    };
  } finally {
    database.close();
  }
}

function readDevinTokenUsage(fileContent: string): TokenUsageResult {
  const lines = fileContent.trim().split('\n');

  for (let index = lines.length - 1; index >= 0; index -= 1) {
    try {
      const entry = JSON.parse(lines[index]) as AnyRecord;
      const tokenBudget = entry.kind === 'status' && entry.text === 'token_budget'
        ? entry.tokenBudget
        : null;
      if (!tokenBudget || typeof tokenBudget !== 'object') {
        continue;
      }

      const inputTokens = readUsageNumber(tokenBudget.inputTokens)
        || readUsageNumber(tokenBudget.breakdown?.input);
      const outputTokens = readUsageNumber(tokenBudget.outputTokens)
        || readUsageNumber(tokenBudget.breakdown?.output);
      const used = readUsageNumber(tokenBudget.used) || inputTokens + outputTokens;
      if (used === 0 && inputTokens === 0 && outputTokens === 0) {
        // An all-zero snapshot carries no budget; keep looking for an older one.
        continue;
      }

      return {
        used,
        total: readUsageNumber(tokenBudget.total),
        inputTokens,
        outputTokens,
        breakdown: { input: inputTokens, output: outputTokens },
      };
    } catch {
      // Skip malformed lines without discarding usage from earlier snapshots.
    }
  }

  // The runtime only appends a snapshot once Devin reports one; an idle session
  // that never did simply has no usage to show yet.
  return {
    used: 0,
    total: 0,
    inputTokens: 0,
    outputTokens: 0,
    breakdown: { input: 0, output: 0 },
    unsupported: true,
    message: 'No token budget snapshot was recorded in the Devin transcript',
  };
}

/**
 * Creates the provider token-usage service used by the provider routes. The
 * provider test suite supplies isolated filesystem and session dependencies so
 * every calculator can be exercised without touching a developer's real data.
 */
export function createProviderTokenUsageService(
  dependencyOverrides: Partial<ProviderTokenUsageServiceDependencies> = {},
) {
  const dependencies = { ...defaultDependencies, ...dependencyOverrides };

  return {
    /**
     * Resolves all provider-specific storage details from one app-facing
     * session id, then returns the latest usage snapshot for that provider.
     */
    async getSessionTokenUsage(sessionId: string): Promise<TokenUsageResult> {
      const session = dependencies.getSessionById(sessionId);
      if (!session) {
        throw new AppError(`Session "${sessionId}" was not found.`, {
          code: 'SESSION_NOT_FOUND',
          statusCode: 404,
        });
      }

      const providerSessionId = session.provider_session_id || sessionId;

      if (session.provider === 'cursor') {
        return {
          used: 0,
          total: 0,
          inputTokens: 0,
          outputTokens: 0,
          breakdown: { input: 0, output: 0 },
          unsupported: true,
          message: 'Token usage tracking not available for Cursor sessions',
        };
      }

      if (session.provider === 'opencode') {
        const databasePath = dependencies.getOpenCodeDatabasePath();
        if (!dependencies.fileExists(databasePath)) {
          throw new AppError('OpenCode database was not found.', {
            code: 'OPENCODE_DATABASE_NOT_FOUND',
            statusCode: 404,
          });
        }

        return readOpenCodeTokenUsage(databasePath, providerSessionId);
      }

      if (session.provider === 'codex') {
        const indexedFilePath = session.jsonl_path && dependencies.fileExists(session.jsonl_path)
          ? session.jsonl_path
          : null;
        const sessionFilePath = indexedFilePath ?? await findCodexSessionFile(
          path.join(dependencies.getHomeDirectory(), '.codex', 'sessions'),
          providerSessionId,
          dependencies,
        );

        if (!sessionFilePath) {
          throw new AppError(`Codex session file for "${sessionId}" was not found.`, {
            code: 'CODEX_SESSION_FILE_NOT_FOUND',
            statusCode: 404,
          });
        }

        const fileContent = await dependencies.readTextFile(sessionFilePath);
        return readCodexTokenUsage(fileContent);
      }

      if (session.provider === 'devin') {
        // Devin persists each token-budget snapshot into the session transcript,
        // so the last one survives an idle session or a page reload.
        let sessionFilePath = session.jsonl_path;
        if (!sessionFilePath) {
          if (!session.project_path) {
            throw new AppError(`Devin transcript for "${sessionId}" was not found.`, {
              code: 'DEVIN_TRANSCRIPT_NOT_FOUND',
              statusCode: 404,
            });
          }

          const projectDirectory = path.join(session.project_path, '.ddagent', 'devin');
          sessionFilePath = path.join(projectDirectory, `${providerSessionId}.jsonl`);

          const relativePath = path.relative(path.resolve(projectDirectory), path.resolve(sessionFilePath));
          if (relativePath.startsWith('..') || path.isAbsolute(relativePath)) {
            throw new AppError('Resolved session path is invalid.', {
              code: 'INVALID_SESSION_PATH',
              statusCode: 400,
            });
          }
        }

        if (!dependencies.fileExists(sessionFilePath)) {
          throw new AppError(`Devin transcript for "${sessionId}" was not found.`, {
            code: 'DEVIN_TRANSCRIPT_NOT_FOUND',
            statusCode: 404,
          });
        }

        return readDevinTokenUsage(await dependencies.readTextFile(sessionFilePath));
      }

      let sessionFilePath = session.jsonl_path;
      if (!sessionFilePath) {
        if (!session.project_path) {
          throw new AppError(`Session file for "${sessionId}" was not found.`, {
            code: 'SESSION_FILE_NOT_FOUND',
            statusCode: 404,
          });
        }

        const encodedProjectPath = session.project_path.replace(/[^a-zA-Z0-9-]/g, '-');
        const projectDirectory = path.join(
          dependencies.getHomeDirectory(),
          '.claude',
          'projects',
          encodedProjectPath,
        );
        sessionFilePath = path.join(projectDirectory, `${providerSessionId}.jsonl`);

        const relativePath = path.relative(path.resolve(projectDirectory), path.resolve(sessionFilePath));
        if (relativePath.startsWith('..') || path.isAbsolute(relativePath)) {
          throw new AppError('Resolved session path is invalid.', {
            code: 'INVALID_SESSION_PATH',
            statusCode: 400,
          });
        }
      }

      if (!dependencies.fileExists(sessionFilePath)) {
        throw new AppError(`Session file for "${sessionId}" was not found.`, {
          code: 'SESSION_FILE_NOT_FOUND',
          statusCode: 404,
        });
      }

      const fileContent = await dependencies.readTextFile(sessionFilePath);
      return readClaudeTokenUsage(fileContent, dependencies.getClaudeContextWindow());
    },
  };
}

/**
 * Used by the provider routes to serve token usage from only an app session id.
 */
export const providerTokenUsageService = createProviderTokenUsageService();
