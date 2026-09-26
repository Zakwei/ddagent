// Native port of the web `BrowserUsePanel` — monitor for agent
// Playwright/Chromium sessions. REST polling only (no WS/SSE in web either);
// screenshots arrive as base64 data URLs on each session object.
import { useCallback, useEffect, useMemo, useState } from 'react';
import {
  ActivityIndicator,
  Image,
  Modal,
  ScrollView,
  Text,
  TouchableOpacity,
  useWindowDimensions,
  View,
} from 'react-native';
import {
  Maximize2,
  MonitorPlay,
  RefreshCw,
  Square,
  Trash2,
  X,
} from 'lucide-react-native';
import { api } from '~shared/utils/api';
import { useTheme } from '../theme';
import {
  BROWSER_USE_POLL_MS,
  cursorPercent,
  formatAction,
  formatRelativeTime,
  getDomain,
  needsBrowserBinaries,
  parseBrowserUseSessions,
  parseBrowserUseStatus,
  runtimeLabelKey,
  sessionLabel,
  statusTone,
  type BrowserUseSession,
  type BrowserUseStatus,
  type StatusTone,
} from '../lib/browser-use';
import { Toast, useToast } from './Toast';

const MONO = 'Menlo';

const TONE_HEX: Record<StatusTone, string> = {
  ready: '#16a34a',
  busy: '#2563eb',
  stopped: '#6b7280',
  error: '#dc2626',
  neutral: '#6b7280',
};

export default function BrowserSessionsPane({ isVisible }: { isVisible: boolean }) {
  const { colors } = useTheme();
  const { width } = useWindowDimensions();
  const { toast, show: showToast } = useToast();
  const [status, setStatus] = useState<BrowserUseStatus | null>(null);
  const [sessions, setSessions] = useState<BrowserUseSession[]>([]);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [isBusy, setIsBusy] = useState(false);
  const [isInstalling, setIsInstalling] = useState(false);
  const [fullscreen, setFullscreen] = useState(false);
  const [confirmDelete, setConfirmDelete] = useState<BrowserUseSession | null>(null);
  const [error, setError] = useState<string | null>(null);

  const selected = useMemo(
    () => sessions.find((s) => s.id === selectedId) ?? sessions[0] ?? null,
    [sessions, selectedId],
  );
  const activeCount = sessions.filter((s) => s.status === 'ready').length;
  const showSide = width >= 720;

  const refresh = useCallback(async () => {
    setIsLoading(true);
    try {
      const [statusRes, sessionsRes] = await Promise.all([
        api.get('/browser-use/status'),
        api.get('/browser-use/sessions'),
      ]);
      setStatus(parseBrowserUseStatus(statusRes));
      setSessions(parseBrowserUseSessions(sessionsRes));
      setError(null);
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Failed to load browser sessions');
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    if (!isVisible) return;
    void refresh();
    const timer = setInterval(() => void refresh(), BROWSER_USE_POLL_MS);
    return () => clearInterval(timer);
  }, [isVisible, refresh]);

  const run = useCallback(
    async (fn: () => Promise<unknown>, okMsg?: string) => {
      setIsBusy(true);
      try {
        await fn();
        if (okMsg) showToast(okMsg);
        await refresh();
      } catch (e) {
        showToast(e instanceof Error ? e.message : 'Action failed', 'error');
      } finally {
        setIsBusy(false);
      }
    },
    [refresh, showToast],
  );

  const stopSession = useCallback(
    (id: string) => run(() => api.post(`/browser-use/sessions/${id}/stop`), 'Session stopped'),
    [run],
  );
  const deleteSession = useCallback(
    (id: string) => run(() => api.delete(`/browser-use/sessions/${id}`), 'Session deleted'),
    [run],
  );
  const installRuntime = useCallback(async () => {
    setIsInstalling(true);
    try {
      await api.post('/browser-use/runtime/install');
      showToast('Runtime installed');
      await refresh();
    } catch (e) {
      showToast(e instanceof Error ? e.message : 'Install failed', 'error');
    } finally {
      setIsInstalling(false);
    }
  }, [refresh, showToast]);

  const runtimeLabel = useMemo(() => {
    const key = runtimeLabelKey(status);
    switch (key) {
      case 'disabled':
        return 'Disabled';
      case 'installing':
        return 'Installing…';
      case 'ready':
        return 'Ready';
      default:
        return 'Setup required';
    }
  }, [status]);

  const renderSurface = (session: BrowserUseSession, tall: boolean) => {
    const pct = cursorPercent(session.cursor, session.viewport);
    return (
      <View
        style={{
          height: tall ? undefined : 360,
          flexGrow: tall ? 1 : 0,
          backgroundColor: '#000',
          borderRadius: 8,
          overflow: 'hidden',
          alignItems: 'center',
          justifyContent: 'center',
        }}
      >
        {session.screenshotDataUrl ? (
          <>
            <Image
              source={{ uri: session.screenshotDataUrl }}
              resizeMode="contain"
              style={{ width: '100%', height: '100%' }}
            />
            {pct ? (
              <View
                pointerEvents="none"
                style={{
                  position: 'absolute',
                  left: `${pct.left}%`,
                  top: `${pct.top}%`,
                  width: 16,
                  height: 16,
                  marginLeft: -8,
                  marginTop: -8,
                  borderRadius: 8,
                  borderWidth: 2,
                  borderColor: '#f59e0b',
                  backgroundColor: 'rgba(245,158,11,0.35)',
                }}
              />
            ) : null}
          </>
        ) : (
          <View style={{ alignItems: 'center', padding: 24 }}>
            <MonitorPlay size={32} color="#9ca3af" />
            <Text style={{ color: '#9ca3af', marginTop: 8, fontSize: 13 }}>
              Waiting for screenshot
            </Text>
          </View>
        )}
      </View>
    );
  };

  const renderEmpty = () => {
    const needs = needsBrowserBinaries(status);
    const enabled = status?.enabled === true;
    return (
      <View
        style={{
          borderWidth: 1,
          borderColor: colors.border,
          borderStyle: 'dashed',
          borderRadius: 10,
          padding: 24,
          alignItems: 'center',
          marginTop: 12,
        }}
      >
        <MonitorPlay size={36} color={colors.mutedForeground} />
        <Text style={{ color: colors.foreground, fontWeight: '600', marginTop: 12, fontSize: 15 }}>
          {enabled ? 'No browser sessions' : 'Browser use is disabled'}
        </Text>
        <Text
          style={{
            color: colors.mutedForeground,
            fontSize: 13,
            textAlign: 'center',
            marginTop: 6,
            lineHeight: 19,
          }}
        >
          {enabled
            ? 'Sessions appear here when the agent opens a browser.'
            : 'Enable browser use in Settings to let the agent drive a browser.'}
        </Text>
        {needs ? (
          <TouchableOpacity
            onPress={() => void installRuntime()}
            disabled={isInstalling}
            style={{
              marginTop: 14,
              backgroundColor: colors.primary,
              paddingHorizontal: 16,
              paddingVertical: 10,
              borderRadius: 8,
              flexDirection: 'row',
              alignItems: 'center',
              gap: 8,
            }}
          >
            {isInstalling ? (
              <ActivityIndicator size="small" color={colors.primaryForeground} />
            ) : null}
            <Text style={{ color: colors.primaryForeground, fontWeight: '600', fontSize: 13 }}>
              {isInstalling ? 'Installing…' : 'Install runtime'}
            </Text>
          </TouchableOpacity>
        ) : null}
      </View>
    );
  };

  return (
    <View style={{ flex: 1, backgroundColor: colors.background, opacity: isBusy ? 0.7 : 1 }}>
      <View
        style={{
          flexDirection: 'row',
          alignItems: 'center',
          gap: 8,
          paddingHorizontal: 12,
          paddingVertical: 10,
          borderBottomWidth: 1,
          borderBottomColor: colors.border,
        }}
      >
        <MonitorPlay size={18} color={colors.foreground} />
        <Text style={{ color: colors.foreground, fontWeight: '700', fontSize: 15, flex: 1 }}>
          Browser use
        </Text>
        <View
          style={{
            backgroundColor: TONE_HEX[statusTone(runtimeLabelKey(status) === 'ready' ? 'ready' : 'neutral')] + '22',
            paddingHorizontal: 8,
            paddingVertical: 3,
            borderRadius: 6,
          }}
        >
          <Text
            style={{
              color: TONE_HEX[statusTone(runtimeLabelKey(status) === 'ready' ? 'ready' : 'neutral')],
              fontSize: 11,
              fontWeight: '600',
            }}
          >
            {runtimeLabel}
          </Text>
        </View>
        <TouchableOpacity onPress={() => void refresh()} disabled={isLoading}>
          {isLoading ? (
            <ActivityIndicator size="small" color={colors.mutedForeground} />
          ) : (
            <RefreshCw size={18} color={colors.mutedForeground} />
          )}
        </TouchableOpacity>
      </View>

      {error ? (
        <View style={{ backgroundColor: colors.destructive + '22', margin: 12, padding: 10, borderRadius: 8 }}>
          <Text style={{ color: colors.destructive, fontSize: 13 }}>{error}</Text>
        </View>
      ) : null}

      <ScrollView contentContainerStyle={{ padding: 12, paddingBottom: 32 }}>
        {/* Session strip */}
        {sessions.length > 1 ? (
          <ScrollView horizontal showsHorizontalScrollIndicator={false} style={{ marginBottom: 10 }}>
            <View style={{ flexDirection: 'row', gap: 8 }}>
              {sessions.map((s) => {
                const isSel = selected?.id === s.id;
                return (
                  <TouchableOpacity
                    key={s.id}
                    onPress={() => setSelectedId(s.id)}
                    style={{
                      flexDirection: 'row',
                      alignItems: 'center',
                      gap: 6,
                      paddingHorizontal: 10,
                      paddingVertical: 6,
                      borderRadius: 8,
                      borderWidth: 1,
                      borderColor: isSel ? colors.primary : colors.border,
                      backgroundColor: isSel ? colors.accent : colors.card,
                    }}
                  >
                    <View
                      style={{
                        width: 6,
                        height: 6,
                        borderRadius: 3,
                        backgroundColor: TONE_HEX[statusTone(s.status)],
                      }}
                    />
                    <Text
                      numberOfLines={1}
                      style={{ color: isSel ? colors.foreground : colors.mutedForeground, fontSize: 12, maxWidth: 140 }}
                    >
                      {sessionLabel(s)}
                    </Text>
                  </TouchableOpacity>
                );
              })}
            </View>
          </ScrollView>
        ) : null}

        <View style={{ flexDirection: 'row', alignItems: 'center', marginBottom: 8 }}>
          <Text style={{ color: colors.mutedForeground, fontSize: 12, flex: 1 }}>
            {activeCount} active / {sessions.length} total
          </Text>
          {selected?.updatedAt ? (
            <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>
              Updated {(() => {
                const rel = formatRelativeTime(selected.updatedAt);
                return rel ? `${rel.count > 0 ? rel.count : ''}${relativeWord(rel.key)}` : '—';
              })()}
            </Text>
          ) : null}
        </View>

        {sessions.length === 0 ? (
          renderEmpty()
        ) : selected ? (
          <>
            <View
              style={{
                borderWidth: 1,
                borderColor: colors.border,
                borderRadius: 10,
                backgroundColor: colors.card,
                overflow: 'hidden',
              }}
            >
              <View
                style={{
                  flexDirection: 'row',
                  alignItems: 'center',
                  gap: 6,
                  paddingHorizontal: 10,
                  paddingVertical: 8,
                  borderBottomWidth: 1,
                  borderBottomColor: colors.border,
                }}
              >
                <View
                  style={{
                    width: 7,
                    height: 7,
                    borderRadius: 4,
                    backgroundColor: TONE_HEX[statusTone(selected.status)],
                  }}
                />
                <Text style={{ color: colors.foreground, fontWeight: '600', fontSize: 13, flexShrink: 1 }} numberOfLines={1}>
                  {sessionLabel(selected)}
                </Text>
                {selected.url ? (
                  <Text numberOfLines={1} style={{ color: colors.primary, fontSize: 11, flexShrink: 1, fontFamily: MONO }}>
                    {getDomain(selected.url)}
                  </Text>
                ) : null}
                <View style={{ flex: 1 }} />
                <TouchableOpacity onPress={() => setFullscreen(true)} style={{ padding: 4 }}>
                  <Maximize2 size={16} color={colors.mutedForeground} />
                </TouchableOpacity>
                {selected.status === 'ready' ? (
                  <TouchableOpacity onPress={() => void stopSession(selected.id)} style={{ padding: 4 }}>
                    <Square size={15} color={colors.mutedForeground} />
                  </TouchableOpacity>
                ) : null}
                <TouchableOpacity onPress={() => setConfirmDelete(selected)} style={{ padding: 4 }}>
                  <Trash2 size={16} color={colors.destructive} />
                </TouchableOpacity>
              </View>
              <View style={{ padding: 8 }}>
                {renderSurface(selected, false)}
              </View>
              {selected.lastAction ? (
                <Text
                  style={{
                    color: colors.mutedForeground,
                    fontSize: 11,
                    paddingHorizontal: 10,
                    paddingBottom: 8,
                  }}
                  numberOfLines={1}
                >
                  {formatAction(selected.lastAction)}
                </Text>
              ) : null}
            </View>

            {showSide ? null : (
              <View style={{ marginTop: 12, gap: 6 }}>
                <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>STATUS</Text>
                <Text style={{ color: colors.foreground, fontSize: 13 }}>{selected.status}</Text>
                {selected.profile ? (
                  <>
                    <Text style={{ color: colors.mutedForeground, fontSize: 11, marginTop: 6 }}>PROFILE</Text>
                    <Text style={{ color: colors.foreground, fontSize: 13 }}>{selected.profile}</Text>
                  </>
                ) : null}
              </View>
            )}

            {sessions.length > 1 ? (
              <View style={{ marginTop: 16 }}>
                <Text style={{ color: colors.mutedForeground, fontSize: 11, marginBottom: 6 }}>
                  SESSIONS · {activeCount}/{sessions.length}
                </Text>
                {sessions.map((s) => (
                  <TouchableOpacity
                    key={s.id}
                    onPress={() => setSelectedId(s.id)}
                    style={{
                      flexDirection: 'row',
                      alignItems: 'center',
                      gap: 8,
                      paddingVertical: 8,
                      borderBottomWidth: 1,
                      borderBottomColor: colors.border,
                    }}
                  >
                    <View
                      style={{ width: 7, height: 7, borderRadius: 4, backgroundColor: TONE_HEX[statusTone(s.status)] }}
                    />
                    <Text numberOfLines={1} style={{ color: colors.foreground, fontSize: 13, flex: 1 }}>
                      {sessionLabel(s)}
                    </Text>
                    <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{s.status}</Text>
                  </TouchableOpacity>
                ))}
              </View>
            ) : null}
          </>
        ) : null}
      </ScrollView>

      <Modal visible={fullscreen} animationType="fade" onRequestClose={() => setFullscreen(false)}>
        <View style={{ flex: 1, backgroundColor: '#000', paddingTop: 40 }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', paddingHorizontal: 12, paddingBottom: 8 }}>
            <Text style={{ color: '#fff', fontWeight: '600', flex: 1 }} numberOfLines={1}>
              {selected ? sessionLabel(selected) : ''}
            </Text>
            <TouchableOpacity onPress={() => setFullscreen(false)} style={{ padding: 6 }}>
              <X size={20} color="#fff" />
            </TouchableOpacity>
          </View>
          <View style={{ flex: 1 }}>{selected ? renderSurface(selected, true) : null}</View>
        </View>
      </Modal>

      <Modal
        visible={confirmDelete !== null}
        transparent
        animationType="fade"
        onRequestClose={() => setConfirmDelete(null)}
      >
        <View
          style={{
            flex: 1,
            backgroundColor: 'rgba(0,0,0,0.5)',
            alignItems: 'center',
            justifyContent: 'center',
            padding: 24,
          }}
        >
          <View style={{ backgroundColor: colors.card, borderRadius: 12, padding: 20, width: '100%', maxWidth: 360 }}>
            <Text style={{ color: colors.foreground, fontWeight: '700', fontSize: 16 }}>Delete session?</Text>
            <Text style={{ color: colors.mutedForeground, fontSize: 13, marginTop: 8 }}>
              {confirmDelete ? sessionLabel(confirmDelete) : ''} will be closed and removed.
            </Text>
            <View style={{ flexDirection: 'row', justifyContent: 'flex-end', gap: 10, marginTop: 18 }}>
              <TouchableOpacity onPress={() => setConfirmDelete(null)} style={{ paddingVertical: 8, paddingHorizontal: 12 }}>
                <Text style={{ color: colors.mutedForeground, fontWeight: '600' }}>Cancel</Text>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={() => {
                  const id = confirmDelete?.id;
                  setConfirmDelete(null);
                  if (id) void deleteSession(id);
                }}
                style={{
                  backgroundColor: colors.destructive,
                  paddingVertical: 8,
                  paddingHorizontal: 14,
                  borderRadius: 8,
                }}
              >
                <Text style={{ color: colors.destructiveForeground, fontWeight: '600' }}>Delete</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>

      {toast ? <Toast toast={toast} /> : null}
    </View>
  );
}

function relativeWord(key: string): string {
  switch (key) {
    case 'relative.justNow':
      return 'just now';
    case 'relative.secondsAgo':
      return 's ago';
    case 'relative.minutesAgo':
      return 'm ago';
    case 'relative.hoursAgo':
      return 'h ago';
    case 'relative.daysAgo':
      return 'd ago';
    default:
      return '';
  }
}
