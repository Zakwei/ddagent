import { useTranslation } from 'react-i18next';

import { cn } from '../../../lib/utils';
import type { PresenceRosterEntry } from '../types';

const AVATAR_COLORS = [
  'bg-sky-500',
  'bg-emerald-500',
  'bg-amber-500',
  'bg-rose-500',
  'bg-violet-500',
  'bg-cyan-600',
];

function initials(name: string): string {
  const parts = name.trim().split(/\s+/).filter(Boolean);
  if (parts.length === 0) return '?';
  if (parts.length === 1) return parts[0].slice(0, 2).toUpperCase();
  return `${parts[0][0]}${parts[1][0]}`.toUpperCase();
}

function viewingLabel(entry: PresenceRosterEntry): string {
  if (!entry.viewing) return '';
  return ` · ${entry.viewing.kind}`;
}

/**
 * Stacked initials of everyone currently present on the shared board. The
 * roster comes from the server-side `presence-roster` broadcast; hovering an
 * avatar reveals the username and what they are viewing.
 */
export default function PresenceAvatars({ roster }: { roster: PresenceRosterEntry[] }) {
  const { t } = useTranslation('tasks');
  if (roster.length === 0) return null;

  return (
    <div
      className="flex items-center"
      role="list"
      aria-label={t('board.presence.online', { count: roster.length, defaultValue: '{{count}} online' })}
    >
      {roster.map((entry, index) => (
        <span
          key={String(entry.userId)}
          role="listitem"
          title={`${entry.username}${viewingLabel(entry)}`}
          className={cn(
            'flex h-6 w-6 items-center justify-center rounded-full border-2 border-background text-[10px] font-semibold text-white',
            AVATAR_COLORS[index % AVATAR_COLORS.length],
            index > 0 && '-ml-1.5',
          )}
        >
          {initials(entry.username)}
        </span>
      ))}
    </div>
  );
}
