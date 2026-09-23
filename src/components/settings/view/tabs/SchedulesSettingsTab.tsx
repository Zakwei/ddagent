import { useEffect, useMemo, useState } from 'react';
import { CalendarClock, Loader2, Play, Trash2 } from 'lucide-react';
import { useTranslation } from 'react-i18next';

import SettingsCard from '../SettingsCard';
import SettingsRow from '../SettingsRow';
import SettingsSection from '../SettingsSection';
import SettingsToggle from '../SettingsToggle';
import { Badge, Button, Dialog, DialogContent, DialogTitle, Input } from '../../../../shared/view/ui';
import { useSchedules, type Schedule, type ScheduleRun } from '../../../../hooks/useSchedules';
import { useUiPreferences } from '../../../../hooks/useUiPreferences';
import type { SettingsProject } from '../../types/types';

const PROVIDERS = ['claude', 'codex', 'cursor', 'opencode', 'devin'] as const;

type SchedulesSettingsTabProps = {
  projects?: SettingsProject[];
};

export default function SchedulesSettingsTab({ projects = [] }: SchedulesSettingsTabProps) {
  const { t } = useTranslation('settings');
  const { schedules, loading, create, update, remove, runNow, listRuns, previewCron } = useSchedules();
  const { preferences, setPreference } = useUiPreferences();

  const [dialogOpen, setDialogOpen] = useState(false);
  const [projectId, setProjectId] = useState('');
  const [provider, setProvider] = useState<string>('claude');
  const [cron, setCron] = useState('0 9 * * *');
  const [prompt, setPrompt] = useState('');
  const [useWorktree, setUseWorktree] = useState(false);
  const [catchUp, setCatchUp] = useState(false);
  const [cronPreview, setCronPreview] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const [runsById, setRunsById] = useState<Record<string, ScheduleRun[]>>({});

  const projectOptions = useMemo(
    () =>
      projects
        .filter((project): project is SettingsProject & { projectId: string } => Boolean(project.projectId))
        .map((project) => ({
          projectId: project.projectId,
          displayName: project.displayName || project.name || project.projectId,
        })),
    [projects],
  );

  const projectNameById = useMemo(() => {
    const map = new Map<string, string>();
    for (const project of projectOptions) map.set(project.projectId, project.displayName);
    return map;
  }, [projectOptions]);

  useEffect(() => {
    if (!dialogOpen) return;
    if (!projectId && projectOptions.length > 0) setProjectId(projectOptions[0].projectId);
  }, [dialogOpen, projectId, projectOptions]);

  useEffect(() => {
    let cancelled = false;
    const handle = setTimeout(() => {
      void previewCron(cron)
        .then((next) => {
          if (!cancelled) setCronPreview(next);
        })
        .catch(() => {
          if (!cancelled) setCronPreview(null);
        });
    }, 250);
    return () => {
      cancelled = true;
      clearTimeout(handle);
    };
  }, [cron, previewCron]);

  const submit = async () => {
    setBusy(true);
    setError(null);
    try {
      await create({ projectId, provider, cron, prompt, useWorktree, catchUp, enabled: true });
      setDialogOpen(false);
      setPrompt('');
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    } finally {
      setBusy(false);
    }
  };

  const toggleRuns = async (id: string) => {
    if (runsById[id]) {
      setRunsById((prev) => {
        const next = { ...prev };
        delete next[id];
        return next;
      });
      return;
    }
    const runs = await listRuns(id).catch(() => [] as ScheduleRun[]);
    setRunsById((prev) => ({ ...prev, [id]: runs }));
  };

  return (
    <div className="space-y-8">
      <SettingsSection
        title={t('schedules.title', { defaultValue: 'Schedules' })}
        description={t('schedules.description', {
          defaultValue: 'Recurring agent runs on a cron timetable. Runs fire unattended with permissions bypassed.',
        })}
      >
        <SettingsCard className="p-4">
          <SettingsRow
            label={t('schedules.preventSleep', { defaultValue: 'Prevent sleep while agents run' })}
            description={t('schedules.preventSleepHint', {
              defaultValue: 'Desktop keeps the display awake; in the browser a screen wake lock is used.',
            })}
          >
            <SettingsToggle
              checked={preferences.preventSleep}
              onChange={(value) => setPreference('preventSleep', value)}
              ariaLabel={t('schedules.preventSleep', { defaultValue: 'Prevent sleep while agents run' })}
            />
          </SettingsRow>
        </SettingsCard>

        <div className="mt-4 flex justify-end">
          <Button size="sm" onClick={() => setDialogOpen(true)}>
            {t('schedules.new', { defaultValue: 'New schedule' })}
          </Button>
        </div>

        {loading && schedules.length === 0 ? (
          <div className="mt-4 flex items-center gap-2 text-sm text-muted-foreground">
            <Loader2 className="h-4 w-4 animate-spin" />
            {t('schedules.loading', { defaultValue: 'Loading…' })}
          </div>
        ) : schedules.length === 0 ? (
          <div className="mt-4 rounded-xl border border-dashed p-6 text-center text-sm text-muted-foreground">
            {t('schedules.empty', { defaultValue: 'No schedules yet.' })}
          </div>
        ) : (
          <div className="mt-4 space-y-2">
            {schedules.map((schedule) => (
              <ScheduleRowItem
                key={schedule.id}
                schedule={schedule}
                projectName={projectNameById.get(schedule.projectId) ?? schedule.projectId}
                runs={runsById[schedule.id]}
                onToggleRuns={() => void toggleRuns(schedule.id)}
                onToggleEnabled={(enabled) => void update(schedule.id, { enabled })}
                onRunNow={() => void runNow(schedule.id)}
                onDelete={() => void remove(schedule.id)}
              />
            ))}
          </div>
        )}
      </SettingsSection>

      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent>
          <DialogTitle>{t('schedules.new', { defaultValue: 'New schedule' })}</DialogTitle>
          <div className="mt-4 space-y-3">
            <label className="block text-sm">
              <span className="mb-1 block text-muted-foreground">
                {t('schedules.project', { defaultValue: 'Project' })}
              </span>
              <select
                className="w-full rounded-md border bg-background px-2 py-1.5 text-sm"
                value={projectId}
                onChange={(event) => setProjectId(event.target.value)}
              >
                {projectOptions.map((project) => (
                  <option key={project.projectId} value={project.projectId}>
                    {project.displayName}
                  </option>
                ))}
              </select>
            </label>

            <label className="block text-sm">
              <span className="mb-1 block text-muted-foreground">
                {t('schedules.provider', { defaultValue: 'Provider' })}
              </span>
              <select
                className="w-full rounded-md border bg-background px-2 py-1.5 text-sm"
                value={provider}
                onChange={(event) => setProvider(event.target.value)}
              >
                {PROVIDERS.map((name) => (
                  <option key={name} value={name}>{name}</option>
                ))}
              </select>
            </label>

            <label className="block text-sm">
              <span className="mb-1 block text-muted-foreground">
                {t('schedules.cron', { defaultValue: 'Cron (min hour day month weekday)' })}
              </span>
              <Input value={cron} onChange={(event) => setCron(event.target.value)} placeholder="0 9 * * *" />
              <span className="mt-1 block text-xs text-muted-foreground">
                {cronPreview
                  ? t('schedules.nextRun', { defaultValue: 'Next run: {{time}}', time: new Date(cronPreview).toLocaleString() })
                  : t('schedules.cronInvalid', { defaultValue: 'No upcoming run for this expression' })}
              </span>
            </label>

            <label className="block text-sm">
              <span className="mb-1 block text-muted-foreground">
                {t('schedules.prompt', { defaultValue: 'Prompt' })}
              </span>
              <textarea
                className="w-full rounded-md border bg-background px-2 py-1.5 text-sm"
                rows={3}
                value={prompt}
                onChange={(event) => setPrompt(event.target.value)}
              />
            </label>

            <label className="flex items-center gap-2 text-sm">
              <input type="checkbox" checked={useWorktree} onChange={(event) => setUseWorktree(event.target.checked)} />
              {t('schedules.useWorktree', { defaultValue: 'Run in a fresh worktree' })}
            </label>
            <label className="flex items-center gap-2 text-sm">
              <input type="checkbox" checked={catchUp} onChange={(event) => setCatchUp(event.target.checked)} />
              {t('schedules.catchUp', { defaultValue: 'Catch up missed runs' })}
            </label>

            {error && <p className="text-sm text-destructive">{error}</p>}

            <div className="flex justify-end gap-2">
              <Button variant="ghost" size="sm" onClick={() => setDialogOpen(false)}>
                {t('common:actions.cancel', { defaultValue: 'Cancel' })}
              </Button>
              <Button size="sm" disabled={busy || !projectId || !prompt.trim() || !cronPreview} onClick={() => void submit()}>
                {busy && <Loader2 className="mr-1 h-3 w-3 animate-spin" />}
                {t('schedules.create', { defaultValue: 'Create' })}
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}

function ScheduleRowItem({
  schedule,
  projectName,
  runs,
  onToggleRuns,
  onToggleEnabled,
  onRunNow,
  onDelete,
}: {
  schedule: Schedule;
  projectName: string;
  runs?: ScheduleRun[];
  onToggleRuns: () => void;
  onToggleEnabled: (enabled: boolean) => void;
  onRunNow: () => void;
  onDelete: () => void;
}) {
  const { t } = useTranslation('settings');
  return (
    <div className="rounded-xl border p-3">
      <div className="flex items-center gap-2">
        <CalendarClock className="h-4 w-4 flex-shrink-0 text-muted-foreground" />
        <div className="min-w-0 flex-1">
          <div className="truncate text-sm font-medium">{schedule.prompt}</div>
          <div className="truncate text-xs text-muted-foreground">
            {schedule.cron} · {projectName} · {schedule.provider}
            {schedule.nextRunAt && schedule.enabled
              ? ` · ${t('schedules.next', { defaultValue: 'next' })} ${new Date(schedule.nextRunAt).toLocaleString()}`
              : ''}
          </div>
        </div>
        {schedule.failCount > 0 && (
          <Badge variant="secondary" className="text-destructive">
            {t('schedules.failures', { defaultValue: '{{count}} failures', count: schedule.failCount })}
          </Badge>
        )}
        {!schedule.enabled && (
          <Badge variant="secondary">{t('schedules.disabled', { defaultValue: 'disabled' })}</Badge>
        )}
        <Button variant="ghost" size="sm" onClick={onToggleRuns}>
          {t('schedules.history', { defaultValue: 'History' })}
        </Button>
        <Button variant="ghost" size="sm" onClick={onRunNow} title={t('schedules.runNow', { defaultValue: 'Run now' })}>
          <Play className="h-3.5 w-3.5" />
        </Button>
        <Button variant="ghost" size="sm" onClick={onDelete} title={t('schedules.delete', { defaultValue: 'Delete' })}>
          <Trash2 className="h-3.5 w-3.5" />
        </Button>
        <SettingsToggle
          checked={schedule.enabled}
          onChange={onToggleEnabled}
          ariaLabel={t('schedules.toggleSchedule', { defaultValue: 'Enable schedule' })}
        />
      </div>
      {runs && (
        <div className="mt-2 space-y-1 border-t pt-2">
          {runs.length === 0 && (
            <div className="text-xs text-muted-foreground">{t('schedules.noRuns', { defaultValue: 'No runs yet.' })}</div>
          )}
          {runs.map((run) => (
            <div key={run.id} className="flex items-center gap-2 text-xs text-muted-foreground">
              <span className="w-16 shrink-0 font-medium">{run.status}</span>
              <span>{new Date(run.startedAt).toLocaleString()}</span>
              {run.error && <span className="truncate text-destructive">{run.error}</span>}
              {run.sessionId && <span className="truncate">{run.sessionId.slice(0, 8)}</span>}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
