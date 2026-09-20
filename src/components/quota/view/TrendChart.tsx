import { useMemo, useState } from 'react';

import { cn } from '../../../lib/utils';
import { formatCost, formatDayLabel, formatTokens } from '../format';
import type { UsageTrendPoint } from '../types';

type TrendChartProps = {
  trend: UsageTrendPoint[];
  className?: string;
};

type Series = 'tokens' | 'cost';

/**
 * Daily token/cost trend drawn as a filled line chart in plain SVG.
 *
 * Series toggle keeps the chart to one scale at a time — tokens and euros are
 * different units, and the spec warns against mixing token counts with cost in
 * a single reading. Values are shown on hover via an HTML title so no tooltip
 * layer is needed.
 */
export default function TrendChart({ trend, className }: TrendChartProps) {
  const [series, setSeries] = useState<Series>('tokens');
  const [hidden, setHidden] = useState(false);

  const width = 600;
  const height = 160;
  const padding = 8;

  const values = useMemo(
    () => trend.map((point) => (series === 'tokens' ? point.tokensTotal : point.costUsd)),
    [trend, series],
  );
  const max = Math.max(1, ...values);
  const step = values.length > 1 ? (width - padding * 2) / (values.length - 1) : 0;
  const path = values
    .map((value, index) => {
      const x = padding + index * step;
      const y = height - padding - (value / max) * (height - padding * 2);
      return `${index === 0 ? 'M' : 'L'}${x.toFixed(2)},${y.toFixed(2)}`;
    })
    .join(' ');


  return (
    <div className={cn('space-y-2', className)}>
      <div className="flex items-center justify-between gap-2">
        <div className="flex items-center gap-1">
          <button
            type="button"
            onClick={() => setSeries('tokens')}
            className={cn(
              'rounded-md px-2 py-1 text-xs font-medium transition-colors',
              series === 'tokens' ? 'bg-muted text-foreground' : 'text-muted-foreground hover:text-foreground',
            )}
          >
            Tokens
          </button>
          <button
            type="button"
            onClick={() => setSeries('cost')}
            className={cn(
              'rounded-md px-2 py-1 text-xs font-medium transition-colors',
              series === 'cost' ? 'bg-muted text-foreground' : 'text-muted-foreground hover:text-foreground',
            )}
          >
            Cost
          </button>
        </div>
        <button
          type="button"
          onClick={() => setHidden((value) => !value)}
          className="text-[11px] text-muted-foreground hover:text-foreground"
        >
          {hidden ? 'Show' : 'Hide'}
        </button>
      </div>

      {hidden ? null : trend.length < 2 ? (
        <p className="py-8 text-center text-xs text-muted-foreground">Not enough data for a trend.</p>
      ) : (
        <svg viewBox={`0 0 ${width} ${height}`} className="h-40 w-full" preserveAspectRatio="none">
          <path
            d={`${path} L${width - padding},${height - padding} L${padding},${height - padding} Z`}
            className="fill-sky-500/15"
          />
          <path d={path} className="stroke-sky-500" fill="none" strokeWidth="2" vectorEffect="non-scaling-stroke" />
        </svg>
      )}

      {!hidden && trend.length >= 2 && (
        <div className="flex justify-between text-[10px] tabular-nums text-muted-foreground">
          {trend
            .filter((_, index) => trend.length <= 12 || index % Math.ceil(trend.length / 10) === 0)
            .map((point) => (
              <span key={point.date} title={`${point.date} · ${formatTokens(point.tokensTotal)} tokens · ${formatCost(point.costUsd)}`}>
                {formatDayLabel(point.date)}
              </span>
            ))}
        </div>
      )}
    </div>
  );
}
