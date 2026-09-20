import type { Tone } from '../tone';

type SparklineProps = {
  points: number[];
  tone: Tone;
  className?: string;
};

/** Stroke/fill colour per status tone. */
const SPARK_STROKE: Record<Tone, string> = {
  safe: 'stroke-emerald-500 fill-emerald-500',
  watch: 'stroke-amber-500 fill-amber-500',
  danger: 'stroke-red-500 fill-red-500',
  neutral: 'stroke-zinc-500 fill-zinc-500',
  info: 'stroke-sky-500 fill-sky-500',
};

/**
 * Minimal inline SVG sparkline for quota history.
 *
 * A chart library would be a heavy dependency for one polyline; this keeps the
 * bundle flat and renders identically for any number of points. Returns a flat
 * midline when there is not enough history to draw.
 */
export default function Sparkline({ points, tone, className }: SparklineProps) {
  const width = 100;
  const height = 24;

  if (points.length < 2) {
    return (
      <svg viewBox={`0 0 ${width} ${height}`} preserveAspectRatio="none" className={className}>
        <line x1="0" y1={height / 2} x2={width} y2={height / 2} className="stroke-border" strokeWidth="1" />
      </svg>
    );
  }

  const step = width / (points.length - 1);
  const path = points
    .map((value, index) => {
      const x = index * step;
      const y = height - (Math.min(100, Math.max(0, value)) / 100) * height;
      return `${index === 0 ? 'M' : 'L'}${x.toFixed(2)},${y.toFixed(2)}`;
    })
    .join(' ');

  return (
    <svg viewBox={`0 0 ${width} ${height}`} preserveAspectRatio="none" className={className}>
      <path d={`${path} L${width},${height} L0,${height} Z`} className={SPARK_STROKE[tone]} opacity="0.15" />
      <path d={path} className={SPARK_STROKE[tone]} fill="none" strokeWidth="1.5" vectorEffect="non-scaling-stroke" />
    </svg>
  );
}
