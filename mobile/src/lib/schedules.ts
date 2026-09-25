const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

export const SCHEDULE_PROVIDERS = ['claude', 'codex', 'cursor', 'opencode', 'devin'] as const;

export type ScheduleProvider = (typeof SCHEDULE_PROVIDERS)[number];

export const DEFAULT_CRON = '0 9 * * *';

export function formatScheduleTime(iso: string | null | undefined): string {
  if (!iso) return '';
  const date = new Date(iso);
  if (Number.isNaN(date.getTime())) return '';
  const hh = String(date.getHours()).padStart(2, '0');
  const mm = String(date.getMinutes()).padStart(2, '0');
  return `${MONTHS[date.getMonth()]} ${date.getDate()}, ${date.getFullYear()} ${hh}:${mm}`;
}

export function scheduleMetaLine(schedule: { cron: string; provider: string }, projectName: string): string {
  return `${schedule.cron} · ${projectName} · ${schedule.provider}`;
}

export function truncateSchedulePrompt(prompt: string, max = 120): string {
  const trimmed = prompt.replace(/\s+/g, ' ').trim();
  return trimmed.length > max ? `${trimmed.slice(0, max - 1)}…` : trimmed;
}
