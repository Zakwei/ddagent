import { useMemo, useState } from 'react';
import { TrendingUp } from 'lucide-react';

import { cn } from '../../../lib/utils';
import { EmptyState } from '../../../shared/view/ui';
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
  const formatValue = series === 'tokens' ? formatTokens : formatCost;
  const max = Math.max(1, ...values);
  const step = values.length > 1 ? (width - padding * 2) / (values.length - 1) : 0;
  const points = values.map((value, index) => ({
    x: padding + index * step,
    y: height - padding - (value / max) * (height - padding * 2),
    trend: trend[index],
  }));
  const path = points
    .map(({ x, y }, index) => `${index === 0 ? 'M' : 'L'}${x.toFixed(2)},${y.toFixed(2)}`)
    .join(' ');

  const tooltipText = (point: UsageTrendPoint) =>
    `${point.date} · ${formatTokens(point.tokensTotal)} tokens · ${formatCost(point.costUsd)}`;


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
        <EmptyState size="sm" icon={TrendingUp} title="Not enough data for a trend." />
      ) : (
        <div className="flex items-stretch gap-2">
          {/* Y-axis scale: labels centered on the top/middle/zero guides —
              the guides sit at padding/height-ratio offsets inside the svg. */}
          <div className="relative h-40 w-12 text-right text-[10px] tabular-nums text-muted-foreground">
            {[max, max / 2, 0].map((value, index) => (
              <span
                key={value}
                className="absolute right-0 -translate-y-1/2"
                style={{ top: `${([padding, height / 2, height - padding][index] / height) * 100}%` }}
              >
                {formatValue(value)}
              </span>
            ))}
          </div>
          <div className="min-w-0 flex-1">
          <svg viewBox={`0 0 ${width} ${height}`} className="h-40 w-full" preserveAspectRatio="none">
            {[padding, height / 2, height - padding].map((y) => (
              <line
                key={y}
                x1={padding}
                x2={width - padding}
                y1={y}
                y2={y}
                className="stroke-border"
                strokeDasharray="4 4"
                vectorEffect="non-scaling-stroke"
              />
            ))}
            <path
              d={`${path} L${width - padding},${height - padding} L${padding},${height - padding} Z`}
              className="fill-sky-500/15"
            />
            <path d={path} className="stroke-sky-500" fill="none" strokeWidth="2" vectorEffect="non-scaling-stroke" />
            {points.map(({ x, y, trend: point }) => (
              <g key={point.date}>
                <circle cx={x} cy={y} r={3} className="fill-sky-500" />
                {/* Fat invisible hit circle so the hover tooltip is easy to reach. */}
                <circle cx={x} cy={y} r={12} fill="transparent">
                  <title>{tooltipText(point)}</title>
                </circle>
              </g>
            ))}
          </svg>
          <div className="mt-1 flex justify-between text-[10px] tabular-nums text-muted-foreground">
            {trend
              .filter((_, index) => trend.length <= 12 || index % Math.ceil(trend.length / 10) === 0)
              .map((point) => (
                <span key={point.date} title={tooltipText(point)}>
                  {formatDayLabel(point.date)}
                </span>
              ))}
          </div>
          </div>
        </div>
      )}
    </div>
  );
}
