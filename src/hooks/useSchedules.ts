import { useCallback, useEffect, useState } from 'react';

import { authenticatedFetch } from '../utils/api';

export type Schedule = {
  id: string;
  projectId: string;
  provider: string;
  cron: string;
  prompt: string;
  useWorktree: boolean;
  catchUp: boolean;
  enabled: boolean;
  failCount: number;
  lastRunAt: string | null;
  nextRunAt: string | null;
  createdAt: string;
};

export type ScheduleRun = {
  id: string;
  scheduleId: string;
  sessionId: string | null;
  status: 'fired' | 'skipped' | 'failed' | 'completed';
  error: string | null;
  startedAt: string;
  finishedAt: string | null;
};

type ListBody = { data?: { schedules?: Schedule[] } };
type RunsBody = { data?: { runs?: ScheduleRun[] } };
type PreviewBody = { data?: { nextRunAt?: string | null } };

/** CRUD + run-now + history for `/api/schedules`. */
export function useSchedules() {
  const [schedules, setSchedules] = useState<Schedule[]>([]);
  const [loading, setLoading] = useState(false);

  const refresh = useCallback(async () => {
    setLoading(true);
    try {
      const response = await authenticatedFetch('/api/schedules');
      const body = (await response.json().catch(() => ({}))) as ListBody;
      setSchedules(Array.isArray(body?.data?.schedules) ? body.data.schedules : []);
    } catch {
      setSchedules([]);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    void refresh();
  }, [refresh]);

  const create = useCallback(
    async (input: Omit<Schedule, 'id' | 'failCount' | 'lastRunAt' | 'nextRunAt' | 'createdAt'>) => {
      const response = await authenticatedFetch('/api/schedules', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(input),
      });
      if (!response.ok) {
        const body = await response.json().catch(() => ({}));
        throw new Error(body?.error?.message ?? `HTTP ${response.status}`);
      }
      await refresh();
    },
    [refresh],
  );

  const update = useCallback(
    async (id: string, patch: Partial<Schedule>) => {
      const response = await authenticatedFetch(`/api/schedules/${id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(patch),
      });
      if (!response.ok) {
        const body = await response.json().catch(() => ({}));
        throw new Error(body?.error?.message ?? `HTTP ${response.status}`);
      }
      await refresh();
    },
    [refresh],
  );

  const remove = useCallback(
    async (id: string) => {
      await authenticatedFetch(`/api/schedules/${id}`, { method: 'DELETE' });
      await refresh();
    },
    [refresh],
  );

  const runNow = useCallback(
    async (id: string) => {
      await authenticatedFetch(`/api/schedules/${id}/run-now`, { method: 'POST' });
      await refresh();
    },
    [refresh],
  );

  const listRuns = useCallback(async (id: string): Promise<ScheduleRun[]> => {
    const response = await authenticatedFetch(`/api/schedules/${id}/runs`);
    const body = (await response.json().catch(() => ({}))) as RunsBody;
    return Array.isArray(body?.data?.runs) ? body.data.runs : [];
  }, []);

  const previewCron = useCallback(async (cron: string): Promise<string | null> => {
    const response = await authenticatedFetch(`/api/schedules/preview?cron=${encodeURIComponent(cron)}`);
    if (!response.ok) return null;
    const body = (await response.json().catch(() => ({}))) as PreviewBody;
    return body?.data?.nextRunAt ?? null;
  }, []);

  return { schedules, loading, refresh, create, update, remove, runNow, listRuns, previewCron };
}
