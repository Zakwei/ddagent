import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';

import { Shimmer } from '../../../../shared/view/ui';
import type { SessionActivity } from '../../../../hooks/useSessionProtection';
import { authenticatedFetch } from '../../../../utils/api';

type ActivityIndicatorProps = {
  activity: SessionActivity | null;
  onAbort?: () => void;
  isInputFocused?: boolean;
  projectId?: string;
};

const ACTION_KEYS = [
  'claudeStatus.actions.thinking',
  'claudeStatus.actions.processing',
  'claudeStatus.actions.analyzing',
  'claudeStatus.actions.working',
  'claudeStatus.actions.computing',
  'claudeStatus.actions.reasoning',
];
const DEFAULT_ACTION_WORDS = ['Thinking', 'Processing', 'Analyzing', 'Working', 'Computing', 'Reasoning'];
const EXIT_ANIMATION_MS = 220;
const TASKS_POLL_MS = 10_000;

// opencode TUI SPINNER_FRAMES, advanced every 80ms.
const SPINNER_FRAMES = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];

function Spinner() {
  const [frame, setFrame] = useState(0);
  useEffect(() => {
    const timer = setInterval(() => setFrame((value) => (value + 1) % SPINNER_FRAMES.length), 80);
    return () => clearInterval(timer);
  }, []);
  return (
    <span className="oc-spinner" aria-hidden>
      {SPINNER_FRAMES[frame]}
    </span>
  );
}

type TaskMasterTask = { id?: number | string; title?: string; status?: string };

type TaskState = { id: string; title: string; status: string } | null;

const useActiveTask = (projectId: string | undefined, enabled: boolean): TaskState => {
  const [task, setTask] = useState<TaskState>(null);

  useEffect(() => {
    if (!projectId || !enabled) {
      setTask(null);
      return;
    }
    let cancelled = false;
    const load = async () => {
      try {
        const res = await authenticatedFetch(`/api/taskmaster/tasks/${encodeURIComponent(projectId)}`);
        if (!res.ok) throw new Error(String(res.status));
        const data = (await res.json()) as { tasks?: TaskMasterTask[] };
        const tasks = data.tasks ?? [];
        const active = tasks.find((taskItem) => taskItem.status === 'in-progress' || taskItem.status === 'in_progress')
          ?? tasks.find((taskItem) => taskItem.status === 'pending');
        if (!cancelled) {
          setTask(active ? {
            id: String(active.id ?? '?'),
            title: active.title ?? '',
            status: active.status ?? 'pending',
          } : null);
        }
      } catch {
        if (!cancelled) setTask(null);
      }
    };
    void load();
    const timer = setInterval(load, TASKS_POLL_MS);
    return () => { cancelled = true; clearInterval(timer); };
  }, [projectId, enabled]);

  return task;
};

/**
 * Minimal response-in-progress indicator, in the spirit of the inline status
 * lines in Claude Code / Codex / OpenCode: a shimmering activity label, the
 * elapsed time, and an interrupt affordance. Rendered only while the viewed
 * session has an entry in the processing map; it disappears the instant that
 * entry is removed.
 */
export default function ActivityIndicator({ activity, onAbort, isInputFocused = false, projectId }: ActivityIndicatorProps) {
  const { t } = useTranslation('chat');
  const [renderedActivity, setRenderedActivity] = useState<SessionActivity | null>(activity);
  const [isExiting, setIsExiting] = useState(false);
  const startedAt = renderedActivity?.startedAt ?? null;
  const [elapsedSeconds, setElapsedSeconds] = useState(0);
  // Poll TaskMaster only while the indicator is on screen; when it returns
  // null there is no task row to update anyway.
  const activeTask = useActiveTask(projectId, Boolean(renderedActivity));

  useEffect(() => {
    if (activity) {
      setRenderedActivity(activity);
      setIsExiting(false);
      return;
    }

    if (!renderedActivity) return;

    setIsExiting(true);
    const timer = setTimeout(() => {
      setRenderedActivity(null);
      setIsExiting(false);
    }, EXIT_ANIMATION_MS);

    return () => clearTimeout(timer);
  }, [activity, renderedActivity]);

  useEffect(() => {
    if (startedAt === null) return;
    const update = () => setElapsedSeconds(Math.max(0, Math.floor((Date.now() - startedAt) / 1000)));
    update();
    const timer = setInterval(update, 1000);
    return () => clearInterval(timer);
  }, [startedAt]);

  if (!renderedActivity) return null;

  const actionWords = ACTION_KEYS.map((key, i) => t(key, { defaultValue: DEFAULT_ACTION_WORDS[i] }));
  const label = (renderedActivity.statusText || actionWords[Math.floor(elapsedSeconds / 4) % actionWords.length])
    .replace(/\.+$/, '');

  const minutes = Math.floor(elapsedSeconds / 60);
  const seconds = elapsedSeconds % 60;
  const elapsedLabel = minutes < 1
    ? t('claudeStatus.elapsed.seconds', { count: seconds, defaultValue: '{{count}}s' })
    : t('claudeStatus.elapsed.minutesSeconds', { minutes, seconds, defaultValue: '{{minutes}}m {{seconds}}s' });
  // Height lives on each tab instead of the shared class so the collapsed
  // mobile status line can drop below 32px (h-7) while desktop keeps h-8.
  const tabSurfaceClassName = [
    'chat-activity-tab inline-flex items-center rounded-b-none rounded-t-lg border border-b-0 bg-card px-3 text-xs transition-all duration-200',
    isInputFocused
      ? 'border-primary/30 shadow-[0_-1px_2px_hsl(var(--foreground)/0.08),1px_0_2px_hsl(var(--foreground)/0.06),-1px_0_2px_hsl(var(--foreground)/0.06)]'
      : 'border-border/50 shadow-[0_-1px_1px_hsl(var(--foreground)/0.04),1px_0_1px_hsl(var(--foreground)/0.03),-1px_0_1px_hsl(var(--foreground)/0.03)]',
  ].join(' ');

  return (
    <div
      className={`pointer-events-none bg-transparent ${
        isExiting ? 'chat-activity-exit' : 'chat-activity-enter'
      }`}
    >
      {/* Desktop-only task banner; on mobile the task is folded into the
          status line below so banner + pill stay under 32px total. */}
      {activeTask && (
        <div className="mb-1.5 hidden items-center justify-end sm:flex">
          <div className={`${tabSurfaceClassName} h-auto min-h-7 gap-1.5 py-1 text-[10px] font-medium`}>
            <span className="text-muted-foreground/60">Task</span>
            <span className="text-foreground">#{activeTask.id}</span>
            <span className="max-w-56 truncate text-muted-foreground/70">{activeTask.title}</span>
            <span className={activeTask.status.startsWith('in') ? 'text-primary' : 'text-muted-foreground/50'}>
              {activeTask.status}
            </span>
          </div>
        </div>
      )}
      <div className="flex items-end justify-between gap-2">
        <div className={`${tabSurfaceClassName} h-7 min-w-0 flex-1 gap-1.5 sm:h-8 sm:flex-initial sm:gap-2`}>
          <Spinner />
          <Shimmer className="min-w-0 truncate font-medium">{`${label}…`}</Shimmer>
          <span className="shrink-0 tabular-nums text-muted-foreground/60">{elapsedLabel}</span>
          {activeTask && (
            <span className="flex min-w-0 items-center gap-1 border-l border-border/40 pl-1.5 text-[10px] font-medium sm:hidden">
              <span className="shrink-0 text-muted-foreground/60">Task</span>
              <span className="shrink-0 text-foreground">#{activeTask.id}</span>
              <span className="truncate text-muted-foreground/70">{activeTask.title}</span>
            </span>
          )}
        </div>

        {renderedActivity.canInterrupt && onAbort && (
          <button
            type="button"
            onClick={onAbort}
            className={`${tabSurfaceClassName} pointer-events-auto h-7 shrink-0 gap-1.5 text-muted-foreground hover:bg-card hover:text-destructive sm:h-8`}
            aria-label={t('claudeStatus.stop', { defaultValue: 'Stop' })}
          >
            <svg className="h-2.5 w-2.5 fill-current" viewBox="0 0 24 24" aria-hidden>
              <rect x="5" y="5" width="14" height="14" rx="2" />
            </svg>
            <span>{t('claudeStatus.stop', { defaultValue: 'Stop' })}</span>
            <kbd className="hidden rounded border border-border/60 px-1 text-[10px] text-muted-foreground/70 sm:inline-block">
              esc
            </kbd>
          </button>
        )}
      </div>
    </div>
  );
}
