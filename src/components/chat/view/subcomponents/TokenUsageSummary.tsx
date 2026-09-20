import { ActivityIcon } from 'lucide-react';
import { cn } from '../../../../lib/utils';

type TokenUsageSummaryProps = {
  usage: Record<string, unknown> | null;
  onClick?: () => void;
  provider?: string;
  model?: string;
  className?: string;
};

export const formatTokenCount = (value: number) => {
  if (!Number.isFinite(value) || value <= 0) {
    return '0';
  }

  if (value >= 1_000_000) {
    return `${(value / 1_000_000).toFixed(value >= 10_000_000 ? 0 : 1)}M`;
  }

  if (value >= 10_000) {
    return `${Math.round(value / 1_000)}K`;
  }

  if (value >= 1_000) {
    return `${(value / 1_000).toFixed(1)}K`;
  }

  return value.toLocaleString();
};

export const readUsageNumber = (value: unknown) => {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : 0;
};

export const getUsedTokens = (usage: Record<string, unknown> | null | undefined): number => {
  if (!usage) return 0;
  const breakdown =
    usage?.breakdown && typeof usage.breakdown === 'object'
      ? usage.breakdown as Record<string, unknown>
      : null;

  const outputTokens = readUsageNumber(usage?.outputTokens ?? breakdown?.output);
  return readUsageNumber(usage?.used) || readUsageNumber(usage?.inputTokens) + outputTokens;
};

export default function TokenUsageSummary({ usage, onClick, className }: TokenUsageSummaryProps) {
  const isUnsupported = usage?.unsupported === true;
  const breakdown =
    usage?.breakdown && typeof usage.breakdown === 'object'
      ? usage.breakdown as Record<string, unknown>
      : null;

  const outputTokens = readUsageNumber(usage?.outputTokens ?? breakdown?.output);
  const usedTokens = readUsageNumber(usage?.used) || readUsageNumber(usage?.inputTokens) + outputTokens;

  // Cache reads/writes are reported separately from fresh input. Some sources
  // fold cache into `inputTokens`, so subtract it when the breakdown is absent
  // to avoid showing a cache-heavy session as a huge fresh prompt.
  const cacheReadTokens = readUsageNumber(
    usage?.cacheReadTokens ??
      usage?.cache_read_input_tokens ??
      usage?.cacheReadInputTokens ??
      breakdown?.cacheRead,
  );
  const cacheCreationTokens = readUsageNumber(
    usage?.cacheCreationTokens ??
      usage?.cache_creation_input_tokens ??
      usage?.cacheCreationInputTokens ??
      breakdown?.cacheCreation,
  );
  const cacheTokens = cacheReadTokens + cacheCreationTokens;
  const reportedInput = readUsageNumber(usage?.inputTokens ?? breakdown?.input);
  const inputTokens = breakdown
    ? reportedInput
    : Math.max(0, reportedInput - cacheTokens);

  // Context budget: how full the model's context window is right now. Only
  // meaningful when the provider reports a total window size.
  const totalTokens = readUsageNumber(usage?.total);
  const contextPercent =
    !isUnsupported && totalTokens > 0 ? Math.min(100, Math.round((usedTokens / totalTokens) * 100)) : null;
  const barColor =
    contextPercent === null
      ? ''
      : contextPercent >= 85
        ? 'bg-red-500'
        : contextPercent >= 60
          ? 'bg-amber-500'
          : 'bg-emerald-500';

  const breakdownTitle = isUnsupported
    ? (typeof usage?.message === 'string' ? usage.message : 'Token usage not available')
    : [
        `${usedTokens.toLocaleString()} tokens used`,
        totalTokens > 0 ? `context ${contextPercent}% of ${totalTokens.toLocaleString()}` : null,
        `input ${inputTokens.toLocaleString()}`,
        cacheTokens > 0
          ? `cache read ${cacheReadTokens.toLocaleString()} · write ${cacheCreationTokens.toLocaleString()}`
          : null,
        `output ${outputTokens.toLocaleString()}`,
      ]
        .filter(Boolean)
        .join(' · ');

  return (
    <button
      type="button"
      onClick={onClick}
      className={cn(
        'inline-flex h-8 items-center gap-1.5 rounded-lg border border-border/70 bg-background/70 px-2 text-xs text-muted-foreground shadow-sm transition-colors hover:border-primary/25 hover:text-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 sm:gap-2 sm:px-2.5',
        className
      )}
      title={breakdownTitle}
      aria-label="Show token usage"
    >
      <span className="grid h-5 w-5 place-items-center rounded-md bg-primary/10 text-primary">
        <ActivityIcon className="h-3.5 w-3.5" />
      </span>
      <span className="font-medium text-foreground">{isUnsupported ? 'N/A' : formatTokenCount(usedTokens)}</span>
      <span className="hidden text-muted-foreground/70 sm:inline">tokens</span>
      {cacheTokens > 0 && (
        <span className="hidden text-muted-foreground/70 sm:inline">· {formatTokenCount(cacheTokens)} cache</span>
      )}
      {contextPercent !== null && (
        <span className="ml-0.5 hidden h-1.5 w-12 overflow-hidden rounded-full bg-muted sm:block">
          <span className={`block h-full rounded-full ${barColor}`} style={{ width: `${contextPercent}%` }} />
        </span>
      )}
    </button>
  );
}
