import { randomUUID } from 'node:crypto';
import os from 'node:os';
import path from 'node:path';

import { providerAccountsDb, sessionsDb, type ProviderAccount } from '@/modules/database/index.js';
import { providerTokenUsageService } from '@/modules/providers/index.js';
import type { LLMProvider } from '@/shared/types.js';
import { AppError } from '@/shared/utils.js';

const ENV_KEY_PATTERN = /^[A-Za-z_][A-Za-z0-9_]*$/;
const MAX_ENV_KEYS = 50;
const MAX_ENV_VALUE_LENGTH = 4096;
const LABEL_MAX_LENGTH = 80;

/**
 * Where a provider CLI keeps its credentials: the env var(s) that point it at
 * an isolated config directory. Used as the suggested `envOverrides` when a
 * new account row does not bring its own.
 *
 * - claude: CLAUDE_CONFIG_DIR replaces ~/.claude entirely (credentials + settings).
 * - codex: CODEX_HOME replaces ~/.codex (auth.json lives there).
 * - cursor/opencode/devin: XDG_CONFIG_HOME (+XDG_DATA_HOME for opencode's
 *   auth store under ~/.local/share) relocates the whole per-user config tree.
 */
function buildAccountEnvPreset(provider: LLMProvider, accountId: string): Record<string, string> {
  const base = path.join(os.homedir(), '.ddagent', 'accounts', accountId);
  switch (provider) {
    case 'claude':
      return { CLAUDE_CONFIG_DIR: path.join(base, 'claude') };
    case 'codex':
      return { CODEX_HOME: path.join(base, 'codex') };
    case 'opencode':
      return {
        XDG_CONFIG_HOME: path.join(base, 'config'),
        XDG_DATA_HOME: path.join(base, 'data'),
      };
    case 'cursor':
    case 'devin':
    default:
      return { XDG_CONFIG_HOME: path.join(base, 'config') };
  }
}

/**
 * Validates a client-supplied env override map. Keys must be POSIX env names;
 * values are bounded strings. Anything else is a 400 — the map lands verbatim
 * in a child process environment.
 */
function validateEnvOverrides(input: unknown): Record<string, string> {
  if (input === undefined || input === null) {
    return {};
  }
  if (typeof input !== 'object' || Array.isArray(input)) {
    throw new AppError('envOverrides must be an object of KEY: "value" pairs.', {
      code: 'INVALID_ENV_OVERRIDES',
      statusCode: 400,
    });
  }
  const entries = Object.entries(input as Record<string, unknown>);
  if (entries.length > MAX_ENV_KEYS) {
    throw new AppError(`envOverrides may contain at most ${MAX_ENV_KEYS} keys.`, {
      code: 'INVALID_ENV_OVERRIDES',
      statusCode: 400,
    });
  }
  const out: Record<string, string> = {};
  for (const [key, value] of entries) {
    if (!ENV_KEY_PATTERN.test(key)) {
      throw new AppError(`Invalid env var name "${key}".`, {
        code: 'INVALID_ENV_OVERRIDES',
        statusCode: 400,
      });
    }
    if (typeof value !== 'string' || value.length > MAX_ENV_VALUE_LENGTH) {
      throw new AppError(`Env var "${key}" must be a string of at most ${MAX_ENV_VALUE_LENGTH} chars.`, {
        code: 'INVALID_ENV_OVERRIDES',
        statusCode: 400,
      });
    }
    out[key] = value;
  }
  return out;
}

function validateLabel(input: unknown): string {
  const label = typeof input === 'string' ? input.trim() : '';
  if (!label || label.length > LABEL_MAX_LENGTH) {
    throw new AppError(`label is required (1-${LABEL_MAX_LENGTH} chars).`, {
      code: 'INVALID_LABEL',
      statusCode: 400,
    });
  }
  return label;
}

export type AccountTokenUsage = {
  sessionCount: number;
  inputTokens: number;
  outputTokens: number;
  totalTokens: number;
  costUsd: number | null;
  /** Sessions whose usage could not be read (transcript missing/unsupported). */
  sessionsWithoutUsage: number;
};

export const providerAccountsService = {
  list(provider?: string): ProviderAccount[] {
    return providerAccountsDb.list(provider);
  },

  create(input: {
    provider: LLMProvider;
    label: unknown;
    envOverrides?: unknown;
    isDefault?: unknown;
  }): ProviderAccount {
    const id = randomUUID();
    const envOverrides =
      input.envOverrides !== undefined
        ? validateEnvOverrides(input.envOverrides)
        : buildAccountEnvPreset(input.provider, id);
    return providerAccountsDb.create({
      id,
      provider: input.provider,
      label: validateLabel(input.label),
      envOverrides,
      isDefault: input.isDefault === true,
    });
  },

  update(
    id: string,
    patch: { label?: unknown; envOverrides?: unknown; isDefault?: unknown },
  ): ProviderAccount {
    const clean: { label?: string; envOverrides?: Record<string, string>; isDefault?: boolean } = {};
    if (patch.label !== undefined) clean.label = validateLabel(patch.label);
    if (patch.envOverrides !== undefined) clean.envOverrides = validateEnvOverrides(patch.envOverrides);
    if (patch.isDefault !== undefined) clean.isDefault = patch.isDefault === true;
    const updated = providerAccountsDb.update(id, clean);
    if (!updated) {
      throw new AppError('Account not found.', { code: 'ACCOUNT_NOT_FOUND', statusCode: 404 });
    }
    return updated;
  },

  /** Removing an account does not delete sessions — they fall back to ambient env. */
  remove(id: string): void {
    if (!providerAccountsDb.remove(id)) {
      throw new AppError('Account not found.', { code: 'ACCOUNT_NOT_FOUND', statusCode: 404 });
    }
  },

  /**
   * Sums transcript token usage over every session launched under this
   * account. Sessions whose provider can't report usage (cursor, missing
   * transcript) are counted in sessionsWithoutUsage instead of failing.
   */
  async getAccountUsage(id: string): Promise<AccountTokenUsage> {
    const account = providerAccountsDb.get(id);
    if (!account) {
      throw new AppError('Account not found.', { code: 'ACCOUNT_NOT_FOUND', statusCode: 404 });
    }
    const sessions = sessionsDb.listSessionsByAccount(id);
    const usage: AccountTokenUsage = {
      sessionCount: sessions.length,
      inputTokens: 0,
      outputTokens: 0,
      totalTokens: 0,
      costUsd: null,
      sessionsWithoutUsage: 0,
    };
    for (const session of sessions) {
      try {
        const result = await providerTokenUsageService.getSessionTokenUsage(session.session_id);
        if (result.unsupported) {
          usage.sessionsWithoutUsage += 1;
          continue;
        }
        usage.inputTokens += result.inputTokens ?? 0;
        usage.outputTokens += result.outputTokens ?? 0;
        usage.totalTokens += result.used ?? 0;
        if (typeof result.costUsd === 'number') {
          usage.costUsd = (usage.costUsd ?? 0) + result.costUsd;
        }
      } catch {
        usage.sessionsWithoutUsage += 1;
      }
    }
    return usage;
  },
};
