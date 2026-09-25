import React, { useEffect, useRef, useState } from 'react';
import { ActivityIndicator as RNIndicator, AppState, Text, TouchableOpacity, View } from 'react-native';
import { Gauge, Square } from 'lucide-react-native';

import { api } from '~shared/utils/api';
import type { ThemeColors } from '../theme';
import { usageFromQuotaSnapshot } from '../lib/model-menu';
import {
  activityLabel,
  formatElapsed,
  formatTokenCount,
  quotaBadgeFor,
  tokenBreakdown,
  type QuotaBadgeInfo,
} from '../lib/usage';
import { useTasksSettings } from '../contexts/TasksSettingsContext';

const SPINNER_FRAMES = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];

function BrailleSpinner({ color }: { color: string }) {
  const [frame, setFrame] = useState(0);
  useEffect(() => {
    const timer = setInterval(() => setFrame((v) => (v + 1) % SPINNER_FRAMES.length), 80);
    return () => clearInterval(timer);
  }, []);
  return <Text style={{ color, fontFamily: 'Menlo', fontSize: 13 }}>{SPINNER_FRAMES[frame]}</Text>;
}

/** opencode-style banner: ✻ provider · model · project path · context bar. */
export function ContextBanner({
  colors,
  providerLabel,
  model,
  projectPath,
  usage,
}: {
  colors: ThemeColors;
  providerLabel: string;
  model: string | null;
  projectPath?: string;
  usage: { used: number; total: number } | null;
}) {
  const breakdown = tokenBreakdown(usage as Record<string, unknown> | null);
  const percent = breakdown?.contextPercent ?? null;
  return (
    <View
      style={{
        flexDirection: 'row',
        alignItems: 'center',
        gap: 6,
        paddingHorizontal: 12,
        paddingVertical: 5,
        borderBottomWidth: 1,
        borderBottomColor: colors.border,
        backgroundColor: colors.card,
      }}
    >
      <Text style={{ color: colors.primary, fontSize: 11, fontWeight: '600' }}>{`✻ ${providerLabel}`}</Text>
      <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>·</Text>
      <Text style={{ color: colors.foreground, fontSize: 11, flexShrink: 1 }} numberOfLines={1}>{model ?? 'Model'}</Text>
      {!!projectPath && (
        <>
          <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>·</Text>
          <Text style={{ color: colors.mutedForeground, fontSize: 11, flexShrink: 1 }} numberOfLines={1}>{projectPath}</Text>
        </>
      )}
      {percent !== null && breakdown && (
        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
          <View style={{ width: 44, height: 5, borderRadius: 3, overflow: 'hidden', backgroundColor: colors.muted }}>
            <View style={{ width: `${percent}%`, height: '100%', backgroundColor: breakdown.barColor }} />
          </View>
          <Text style={{ color: colors.mutedForeground, fontSize: 10 }}>{`${percent}%`}</Text>
          <Text style={{ color: colors.mutedForeground, fontSize: 10 }}>{formatTokenCount(breakdown.total)}</Text>
        </View>
      )}
    </View>
  );
}

/** Subscription-usage pill; polls /quota every 5 min. Null when no matching section. */
export function QuotaBadge({ colors, provider, model }: { colors: ThemeColors; provider?: string; model?: string | null }) {
  const [info, setInfo] = useState<QuotaBadgeInfo | null>(null);
  const [failed, setFailed] = useState(false);

  useEffect(() => {
    let cancelled = false;
    const load = async () => {
      try {
        const res = await api.get('/quota');
        if (!res.ok) throw new Error(String(res.status));
        const payload = await res.json();
        const snap = payload?.data?.snapshot ?? payload?.data ?? payload?.snapshot ?? payload;
        if (!snap?.accounts) throw new Error('empty quota response');
        if (!cancelled) {
          setInfo(
            quotaBadgeFor(usageFromQuotaSnapshot(snap), provider, model, {
              watch: snap.overview?.watchThreshold ?? 75,
              danger: snap.overview?.dangerThreshold ?? 90,
            }),
          );
          setFailed(false);
        }
      } catch {
        if (!cancelled) setFailed(true);
      }
    };
    void load();
    const id = setInterval(load, 5 * 60 * 1000);
    return () => {
      cancelled = true;
      clearInterval(id);
    };
  }, [provider, model]);

  if (failed || !info) return null;
  const tint = info.percent === null ? colors.mutedForeground : info.tone === 'critical' ? '#ef4444' : info.tone === 'warn' ? '#f59e0b' : colors.primary;
  return (
    <View style={{ flexDirection: 'row', alignItems: 'center', gap: 3, borderRadius: 8, paddingHorizontal: 6, paddingVertical: 2, backgroundColor: colors.muted }}>
      <Gauge size={12} color={tint} />
      <Text style={{ color: tint, fontSize: 11, fontWeight: '600' }}>{info.percent === null ? '—' : `${info.percent}%`}</Text>
    </View>
  );
}

type TaskState = { id: string; title: string; status: string } | null;

/** Poll the active TaskMaster task while a turn runs (10s). */
function useActiveTask(projectId: string | undefined, enabled: boolean): TaskState {
  const [task, setTask] = useState<TaskState>(null);
  useEffect(() => {
    if (!projectId || !enabled) {
      setTask(null);
      return;
    }
    let cancelled = false;
    const load = async () => {
      try {
        const res = await api.get(`/taskmaster/tasks/${encodeURIComponent(projectId)}`);
        if (!res.ok) throw new Error(String(res.status));
        const data = await res.json();
        const tasks: { id?: string | number; title?: string; status?: string }[] = data.tasks ?? [];
        const active =
          tasks.find((t) => t.status === 'in-progress' || t.status === 'in_progress') ?? tasks.find((t) => t.status === 'pending');
        if (!cancelled) {
          setTask(active ? { id: String(active.id ?? '?'), title: active.title ?? '', status: active.status ?? 'pending' } : null);
        }
      } catch {
        if (!cancelled) setTask(null);
      }
    };
    void load();
    const timer = setInterval(load, 10_000);
    return () => {
      cancelled = true;
      clearInterval(timer);
    };
  }, [projectId, enabled]);
  return task;
}

/** Inline activity tab: spinner + rotating label + elapsed + Stop. */
export function ActivityBanner({
  colors,
  running,
  startedAt,
  statusText,
  canInterrupt,
  onAbort,
  projectId,
}: {
  colors: ThemeColors;
  running: boolean;
  startedAt: number | null;
  statusText?: string | null;
  canInterrupt: boolean;
  onAbort: () => void;
  projectId?: string;
}) {
  const [elapsed, setElapsed] = useState(0);
  const { isTaskMasterInstalled, tasksEnabled } = useTasksSettings();
  const activeTask = useActiveTask(projectId, running && Boolean(tasksEnabled && isTaskMasterInstalled));

  useEffect(() => {
    if (startedAt === null) {
      setElapsed(0);
      return;
    }
    const update = () => setElapsed(Math.max(0, Math.floor((Date.now() - startedAt) / 1000)));
    update();
    const timer = setInterval(update, 1000);
    return () => clearInterval(timer);
  }, [startedAt]);

  if (!running) return null;
  const label = activityLabel(statusText, elapsed);
  return (
    <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingHorizontal: 12, paddingVertical: 6, borderBottomWidth: 1, borderBottomColor: colors.border, backgroundColor: colors.card }}>
      <BrailleSpinner color={colors.primary} />
      <Text style={{ color: colors.foreground, fontSize: 12, fontWeight: '500' }} numberOfLines={1}>{`${label}…`}</Text>
      <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{formatElapsed(elapsed)}</Text>
      {!!activeTask && (
        <Text style={{ color: colors.mutedForeground, fontSize: 10, flexShrink: 1 }} numberOfLines={1}>
          {`Task #${activeTask.id} ${activeTask.title}`}
        </Text>
      )}
      <View style={{ flex: 1 }} />
      {canInterrupt && (
        <TouchableOpacity onPress={onAbort} style={{ flexDirection: 'row', alignItems: 'center', gap: 4, paddingHorizontal: 8, paddingVertical: 3, borderRadius: 8, backgroundColor: colors.secondary }}>
          <Square size={10} color={colors.destructive} fill={colors.destructive} />
          <Text style={{ color: colors.destructive, fontSize: 11 }}>Stop</Text>
        </TouchableOpacity>
      )}
    </View>
  );
}

/** AppState-driven resync + watchdog + reconnect subscription helper. */
export function useActivityResync({
  enabled,
  sessionId,
  isProcessing,
  reconnect,
}: {
  enabled: boolean;
  sessionId: string | null;
  isProcessing: boolean;
  reconnect: (sessionId: string) => void;
}) {
  const reconnectRef = useRef(reconnect);
  reconnectRef.current = reconnect;

  // AppState resync: returning to foreground re-subscribes + refreshes tail.
  useEffect(() => {
    if (!enabled || !sessionId) return;
    const sub = AppState.addEventListener('change', (state) => {
      if (state === 'active') reconnectRef.current(sessionId);
    });
    return () => sub.remove();
  }, [enabled, sessionId]);

  // Watchdog while a turn is running: catch terminal events missed on suspend.
  useEffect(() => {
    if (!enabled || !sessionId || !isProcessing) return;
    const timer = setInterval(() => reconnectRef.current(sessionId), 10_000);
    return () => clearInterval(timer);
  }, [enabled, sessionId, isProcessing]);
}

export { RNIndicator as ActivitySpinner };
