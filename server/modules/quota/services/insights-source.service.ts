import fs from 'node:fs';
import path from 'node:path';

import Database from 'better-sqlite3';

import type { UsageTotals } from '@/shared/types.js';

/** One analytics session row as read from the external tokboard database. */
export type InsightSession = {
  source: string;
  sourceId: string;
  title: string;
  agent: string;
  model: string;
  subscription: string;
  provider: string;
  tokensInput: number;
  tokensOutput: number;
  tokensReasoning: number;
  tokensCacheRead: number;
  tokensCacheWrite: number;
  apiCalls: number;
  costUsd: number;
  startedAt: number | null;
  endedAt: number | null;
};

/** Per-million-token prices in USD for one model. */
export type ModelPrice = {
  input: number;
  output: number;
  cacheRead: number;
};

/**
 * Read surface for the external token analytics store plus its price table.
 *
 * The reader is isolated behind this contract so the usage service can be
 * unit-tested with plain arrays and never touches SQLite or the filesystem.
 * `available` is false when the store is missing, which the API reports as the
 * snapshot's `source` instead of failing the request.
 */
export type InsightSource = {
  available: boolean;
  path: string | null;
  loadSessions(): InsightSession[];
  priceFor(model: string): ModelPrice | null;
};

/**
 * Default analytics store location.
 *
 * tokboard lives next to the workspace rather than inside this repo, so it is
 * looked up under `/workspace/tokboard` first and can be redirected with
 * `TOKBOARD_DB_PATH` when the layout differs.
 */
const WORKSPACE_TOKBOARD_DB = path.join('/workspace', 'tokboard', 'tokboard.db');

function resolveStorePath(): { db: string; pricing: string } {
  const configured = process.env.TOKBOARD_DB_PATH?.trim();
  const db = configured ? path.resolve(configured) : WORKSPACE_TOKBOARD_DB;
  const configuredPricing = process.env.TOKBOARD_PRICING_PATH?.trim();
  const pricing = configuredPricing
    ? path.resolve(configuredPricing)
    : path.join(path.dirname(db), 'pricing.json');
  return { db, pricing };
}

type SessionRow = {
  source: string | null;
  source_id: string | null;
  title: string | null;
  agent: string | null;
  model: string | null;
  subscription: string | null;
  provider: string | null;
  tokens_input: number | null;
  tokens_output: number | null;
  tokens_reasoning: number | null;
  tokens_cache_read: number | null;
  tokens_cache_write: number | null;
  api_calls: number | null;
  cost: number | null;
  started_at: number | null;
  ended_at: number | null;
};

const asNumber = (value: unknown): number =>
  typeof value === 'number' && Number.isFinite(value) ? value : 0;

const asText = (value: unknown): string => (typeof value === 'string' ? value : '');

function mapSession(row: SessionRow): InsightSession {
  return {
    source: asText(row.source),
    sourceId: asText(row.source_id),
    title: asText(row.title),
    agent: asText(row.agent),
    model: asText(row.model) || 'unknown',
    subscription: asText(row.subscription),
    provider: asText(row.provider),
    tokensInput: asNumber(row.tokens_input),
    tokensOutput: asNumber(row.tokens_output),
    tokensReasoning: asNumber(row.tokens_reasoning),
    tokensCacheRead: asNumber(row.tokens_cache_read),
    tokensCacheWrite: asNumber(row.tokens_cache_write),
    apiCalls: asNumber(row.api_calls),
    costUsd: asNumber(row.cost),
    startedAt: typeof row.started_at === 'number' ? row.started_at : null,
    endedAt: typeof row.ended_at === 'number' ? row.ended_at : null,
  };
}

/** Parses tokboard's `{ "<model>": { in, out, cache } }` price table. */
function parsePricing(raw: string): Map<string, ModelPrice> {
  const table = new Map<string, ModelPrice>();
  let parsed: unknown;
  try {
    parsed = JSON.parse(raw);
  } catch {
    return table;
  }
  if (typeof parsed !== 'object' || parsed === null) {
    return table;
  }

  for (const [model, value] of Object.entries(parsed as Record<string, unknown>)) {
    if (typeof value !== 'object' || value === null) {
      continue;
    }
    const entry = value as Record<string, unknown>;
    table.set(model, {
      input: asNumber(entry.in),
      output: asNumber(entry.out),
      cacheRead: asNumber(entry.cache),
    });
  }
  return table;
}

/**
 * Creates the production reader over the external tokboard analytics store.
 *
 * The SQLite file is opened read-only per call and closed immediately: the
 * collector process owns that database, so holding a connection would only
 * risk locking it. Any failure degrades to an unavailable source rather than
 * throwing, which keeps the Usage and Overview screens usable.
 */
export function createInsightSource(overrides?: {
  storePath?: string;
  pricingPath?: string;
  loadRows?: () => SessionRow[];
  readFile?: (path: string) => string;
}): InsightSource {
  const resolved = overrides?.storePath
    ? { db: overrides.storePath, pricing: overrides.pricingPath ?? path.join(path.dirname(overrides.storePath), 'pricing.json') }
    : resolveStorePath();
  const readFile = overrides?.readFile ?? ((filePath: string) => fs.readFileSync(filePath, 'utf8'));

  const available = overrides?.loadRows
    ? true
    : fs.existsSync(resolved.db);

  let pricingCache: Map<string, ModelPrice> | null = null;

  function loadRows(): SessionRow[] {
    if (overrides?.loadRows) {
      return overrides.loadRows();
    }
    const db = new Database(resolved.db, { readonly: true, fileMustExist: true });
    try {
      return db
        .prepare(
          `SELECT source, source_id, title, agent, model, subscription, provider,
                  tokens_input, tokens_output, tokens_reasoning, tokens_cache_read,
                  tokens_cache_write, api_calls, cost, started_at, ended_at
           FROM sessions`,
        )
        .all() as SessionRow[];
    } finally {
      db.close();
    }
  }

  return {
    available,
    path: resolved.db,
    loadSessions() {
      if (!available) {
        return [];
      }
      try {
        return loadRows().map(mapSession);
      } catch {
        // A missing or locked store must not take down the API.
        return [];
      }
    },
    priceFor(model) {
      if (pricingCache === null) {
        try {
          pricingCache = parsePricing(readFile(resolved.pricing));
        } catch {
          pricingCache = new Map();
        }
      }
      return pricingCache.get(model) ?? null;
    },
  };
}

/** Sums one session row into an accumulator, keeping token totals consistent. */
export function addSessionTotals(target: UsageTotals, session: InsightSession): void {
  target.tokensInput += session.tokensInput;
  target.tokensOutput += session.tokensOutput;
  target.tokensReasoning += session.tokensReasoning;
  target.tokensCacheRead += session.tokensCacheRead;
  target.tokensCacheWrite += session.tokensCacheWrite;
  target.tokensTotal +=
    session.tokensInput +
    session.tokensOutput +
    session.tokensReasoning +
    session.tokensCacheRead +
    session.tokensCacheWrite;
  target.apiCalls += session.apiCalls;
  target.costUsd += session.costUsd;
  target.sessions += 1;
}
