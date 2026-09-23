import { useCallback, useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { ChevronDown, ChevronRight } from 'lucide-react';

import { cn } from '../../../lib/utils';
import { useWebSocket } from '../../../contexts/WebSocketContext';
import { api } from '../../../utils/api';
import type { ActivityEvent, CollabUser, KanbanApiResponse } from '../types';

function relativeTime(value: string): string {
  const timestamp = new Date(value).getTime();
  if (!Number.isFinite(timestamp)) return '';
  const seconds = Math.max(0, Math.floor((Date.now() - timestamp) / 1000));
  if (seconds < 60) return 'just now';
  const minutes = Math.floor(seconds / 60);
  if (minutes < 60) return `${minutes}m ago`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `${hours}h ago`;
  return `${Math.floor(hours / 24)}d ago`;
}

type ActivityFeedProps = {
  projectId: string;
  users: CollabUser[];
};

/**
 * Collapsible per-project activity feed. Fetches on expand and refreshes on
 * every `kanban-card-*` broadcast so card actions appear live while the
 * section is open.
 */
export default function ActivityFeed({ projectId, users }: ActivityFeedProps) {
  const { t } = useTranslation('tasks');
  const { subscribe } = useWebSocket();
  const [expanded, setExpanded] = useState(false);
  const [events, setEvents] = useState<ActivityEvent[]>([]);

  const load = useCallback(async () => {
    try {
      const response = await api.collab.activity(projectId);
      const payload = (await response.json()) as KanbanApiResponse<{ events: ActivityEvent[] }>;
      if (response.ok && payload.success !== false) {
        setEvents(Array.isArray(payload.data?.events) ? payload.data.events : []);
      }
    } catch {
      // The feed is auxiliary UI — a failed fetch leaves the last list in place.
    }
  }, [projectId]);

  useEffect(() => {
    if (expanded) void load();
  }, [expanded, load]);

  useEffect(
    () =>
      subscribe((event) => {
        if (!expanded || !projectId) return;
        if (typeof event.type === 'string' && event.type.startsWith('kanban-') && event.projectId === projectId) {
          void load();
        }
      }),
    [subscribe, expanded, projectId, load],
  );

  const userName = (userId: number | null): string | null =>
    userId === null ? null : (users.find((user) => user.id === userId)?.displayName ?? `#${userId}`);

  return (
    <div className="border-t border-border/60">
      <button
        type="button"
        onClick={() => setExpanded((previous) => !previous)}
        className="flex w-full items-center gap-1.5 px-4 py-2 text-xs font-medium text-muted-foreground transition-colors hover:text-foreground"
        aria-expanded={expanded}
      >
        {expanded ? <ChevronDown className="h-3.5 w-3.5" /> : <ChevronRight className="h-3.5 w-3.5" />}
        {t('board.activity.title', { defaultValue: 'Activity' })}
      </button>

      {expanded && (
        <ul className="max-h-48 space-y-1.5 overflow-y-auto px-4 pb-3">
          {events.length === 0 && (
            <li className="text-xs text-muted-foreground">
              {t('board.activity.empty', { defaultValue: 'No activity yet' })}
            </li>
          )}
          {events.map((event) => (
            <li key={event.id} className="flex items-baseline gap-2 text-xs">
              <span className="flex-shrink-0 text-muted-foreground">{relativeTime(event.createdAt)}</span>
              <span className={cn('min-w-0 flex-1 truncate text-foreground/90')}>
                {userName(event.userId) && (
                  <span className="font-medium">{userName(event.userId)}: </span>
                )}
                {event.summary}
              </span>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
