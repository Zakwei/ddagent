/// Client-side model pricing table used to turn token counts into an
/// approximate USD cost (port of `src/utils/modelPricing.ts`). Providers do
/// not report cost, so this is a best-effort estimate from published
/// per-million-token rates; unknown models return null so the UI can fall
/// back to "—" instead of showing a wrong number.
library;

const _perMillion = 1000000;

class _ModelPrice {
  const _ModelPrice(this.input, this.output);

  /// USD per 1M input tokens.
  final double input;

  /// USD per 1M output tokens.
  final double output;
}

// Matched by substring against the lowercased model id, most specific first.
const _modelPrices = <String, _ModelPrice>{
  'opus': _ModelPrice(15, 75),
  'sonnet': _ModelPrice(3, 15),
  'haiku': _ModelPrice(0.8, 4),
  'gpt-5': _ModelPrice(1.25, 10),
  'gpt-4o-mini': _ModelPrice(0.15, 0.6),
  'gpt-4o': _ModelPrice(2.5, 10),
  'o3': _ModelPrice(2, 8),
  'gemini-2.5-pro': _ModelPrice(1.25, 10),
  'gemini-2.5-flash': _ModelPrice(0.3, 2.5),
  'grok-4': _ModelPrice(3, 15),
  'deepseek': _ModelPrice(0.28, 0.42),
};

_ModelPrice? _getModelPrice(String? model) {
  if (model == null) return null;
  final normalized = model.toLowerCase();
  for (final entry in _modelPrices.entries) {
    if (normalized.contains(entry.key)) return entry.value;
  }
  return null;
}

/// Estimates USD cost from token counts. Returns `null` when the model is
/// unknown (no published rate) or when no tokens were supplied.
double? estimateCostUsd({
  String? model,
  num inputTokens = 0,
  num outputTokens = 0,
  num cacheReadTokens = 0,
  num cacheCreationTokens = 0,
}) {
  final price = _getModelPrice(model);
  if (price == null) return null;

  // Web table has no cache-read overrides — the 0.1x-input default.
  final cacheRate = price.input * 0.1;
  if (inputTokens == 0 &&
      outputTokens == 0 &&
      cacheReadTokens == 0 &&
      cacheCreationTokens == 0) {
    return null;
  }

  // Cache reads are billed at the cheap cache rate; cache writes are billed
  // slightly above the base input rate (~1.25x on most providers).
  return (inputTokens * price.input +
          outputTokens * price.output +
          cacheReadTokens * cacheRate +
          cacheCreationTokens * price.input * 1.25) /
      _perMillion;
}

/// Formats a USD amount for compact display (e.g. `$0.12`, `$1.05`, `<$0.001`).
String formatCostUsd(double? value) {
  if (value == null || !value.isFinite) return '—';
  if (value > 0 && value < 0.001) return '<\$0.001';
  if (value >= 100) return '\$${value.toStringAsFixed(0)}';
  return '\$${value.toStringAsFixed(value >= 1 ? 2 : 3)}';
}
