/**
 * Client-side model pricing table used to turn token counts into an approximate
 * USD cost. Providers do not report cost, so this is a best-effort estimate
 * based on published per-million-token rates; unknown models return null so the
 * UI can fall back to "—" instead of showing a wrong number.
 */

export type TokenCostInput = {
  model?: string | null;
  inputTokens?: number;
  outputTokens?: number;
  cacheReadTokens?: number;
  cacheCreationTokens?: number;
};

type ModelPrice = {
  /** USD per 1M input tokens. */
  input: number;
  /** USD per 1M output tokens. */
  output: number;
  /** USD per 1M cache-read tokens; defaults to 0.1x input when omitted. */
  cacheRead?: number;
};

const PER_MILLION = 1_000_000;

// Matched by substring against the lowercased model id, most specific first.
const MODEL_PRICES: Array<{ match: string; price: ModelPrice }> = [
  { match: 'opus', price: { input: 15, output: 75 } },
  { match: 'sonnet', price: { input: 3, output: 15 } },
  { match: 'haiku', price: { input: 0.8, output: 4 } },
  { match: 'gpt-5', price: { input: 1.25, output: 10 } },
  { match: 'gpt-4o-mini', price: { input: 0.15, output: 0.6 } },
  { match: 'gpt-4o', price: { input: 2.5, output: 10 } },
  { match: 'o3', price: { input: 2, output: 8 } },
  { match: 'gemini-2.5-pro', price: { input: 1.25, output: 10 } },
  { match: 'gemini-2.5-flash', price: { input: 0.3, output: 2.5 } },
  { match: 'grok-4', price: { input: 3, output: 15 } },
  { match: 'deepseek', price: { input: 0.28, output: 0.42 } },
];

export const getModelPrice = (model?: string | null): ModelPrice | null => {
  if (!model) {
    return null;
  }
  const normalized = model.toLowerCase();
  const entry = MODEL_PRICES.find((candidate) => normalized.includes(candidate.match));
  return entry ? entry.price : null;
};

/**
 * Estimates USD cost from token counts. Returns `null` when the model is
 * unknown (no published rate) or when no tokens were supplied.
 */
export const estimateCostUsd = ({ model, inputTokens, outputTokens, cacheReadTokens, cacheCreationTokens }: TokenCostInput): number | null => {
  const price = getModelPrice(model);
  if (!price) {
    return null;
  }

  const input = Number.isFinite(inputTokens) ? Number(inputTokens) : 0;
  const output = Number.isFinite(outputTokens) ? Number(outputTokens) : 0;
  const cacheRead = Number.isFinite(cacheReadTokens) ? Number(cacheReadTokens) : 0;
  const cacheCreation = Number.isFinite(cacheCreationTokens) ? Number(cacheCreationTokens) : 0;
  const cacheRate = price.cacheRead ?? price.input * 0.1;

  if (input === 0 && output === 0 && cacheRead === 0 && cacheCreation === 0) {
    return null;
  }

  // Cache reads are billed at the cheap cache rate; cache writes are billed
  // slightly above the base input rate (~1.25x on most providers).
  return (
    input * price.input
    + output * price.output
    + cacheRead * cacheRate
    + cacheCreation * price.input * 1.25
  ) / PER_MILLION;
};

/** Formats a USD amount for compact display (e.g. `$0.12`, `$1.05`, `<$0.001`). */
export const formatCostUsd = (value: number | null): string => {
  if (value === null || !Number.isFinite(value)) {
    return '—';
  }
  if (value > 0 && value < 0.001) {
    return '<$0.001';
  }
  if (value >= 100) {
    return `$${value.toFixed(0)}`;
  }
  return `$${value.toFixed(value >= 1 ? 2 : 3)}`;
};
