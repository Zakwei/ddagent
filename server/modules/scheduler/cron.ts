/**
 * Minimal 5-field cron matcher: `min hour day-of-month month day-of-week`.
 * Supports `*`, `*\/n`, `a`, `a-b`, `a-b/n`, and comma lists — the subset the
 * UI exposes. Month and day-of-week names are not supported on purpose.
 */

const FIELD_BOUNDS = [
  { min: 0, max: 59 }, // minute
  { min: 0, max: 23 }, // hour
  { min: 1, max: 31 }, // day of month
  { min: 1, max: 12 }, // month
  { min: 0, max: 7 }, // day of week (0 and 7 are Sunday)
] as const;

function parseField(field: string, index: number): Set<number> | null {
  const { min, max } = FIELD_BOUNDS[index];
  const values = new Set<number>();

  for (const part of field.split(',')) {
    const stepMatch = part.match(/^(.+)\/(\d+)$/);
    const rangePart = stepMatch ? stepMatch[1] : part;
    const step = stepMatch ? Number(stepMatch[2]) : 1;
    if (!Number.isInteger(step) || step < 1) return null;

    let lo: number;
    let hi: number;
    if (rangePart === '*') {
      lo = min;
      hi = max;
    } else {
      const rangeMatch = rangePart.match(/^(\d+)(?:-(\d+))?$/);
      if (!rangeMatch) return null;
      lo = Number(rangeMatch[1]);
      hi = rangeMatch[2] !== undefined ? Number(rangeMatch[2]) : lo;
      if (stepMatch && rangeMatch[2] === undefined) hi = max; // `a/n` means a-max step n
    }
    if (lo < min || hi > max || lo > hi) return null;

    for (let value = lo; value <= hi; value += step) {
      values.add(index === 4 && value === 7 ? 0 : value);
    }
  }
  return values.size > 0 ? values : null;
}

/** Parses a cron expression into per-field value sets, or null when invalid. */
export function parseCron(expr: string): Set<number>[] | null {
  const fields = expr.trim().split(/\s+/);
  if (fields.length !== 5) return null;
  const parsed = fields.map((field, index) => parseField(field, index));
  return parsed.every((set): set is Set<number> => set !== null) ? parsed : null;
}

export function matchesCron(parsed: Set<number>[], date: Date): boolean {
  const [minutes, hours, dom, months, dow] = parsed;
  if (!minutes.has(date.getMinutes())) return false;
  if (!hours.has(date.getHours())) return false;
  if (!months.has(date.getMonth() + 1)) return false;

  // Standard cron quirk: when BOTH dom and dow are restricted they OR,
  // otherwise both must match.
  const domRestricted = dom.size < 31;
  const dowRestricted = dow.size < 7;
  const domMatch = dom.has(date.getDate());
  const dowMatch = dow.has(date.getDay());
  if (domRestricted && dowRestricted) {
    return domMatch || dowMatch;
  }
  return domMatch && dowMatch;
}

const MINUTE_MS = 60_000;
const MAX_SCAN_MINUTES = 366 * 24 * 60; // covers Feb 29 schedules

/**
 * The next minute boundary matching `expr` strictly after `from`, or null when
 * nothing matches within a year (e.g. `0 0 31 2 *`).
 */
export function nextCronTime(expr: string, from: Date): Date | null {
  const parsed = parseCron(expr);
  if (!parsed) return null;

  let candidate = new Date(Math.floor(from.getTime() / MINUTE_MS) * MINUTE_MS + MINUTE_MS);
  for (let i = 0; i < MAX_SCAN_MINUTES; i += 1) {
    if (matchesCron(parsed, candidate)) return candidate;
    candidate = new Date(candidate.getTime() + MINUTE_MS);
  }
  return null;
}
