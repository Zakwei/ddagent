import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import {
  ActivityIndicator,
  Linking,
  Modal,
  ScrollView,
  Text,
  TextInput,
  TouchableOpacity,
  useWindowDimensions,
  View,
} from 'react-native';
import { WebView, WebViewMessageEvent } from 'react-native-webview';
import {
  ArrowLeft,
  ArrowRight,
  ExternalLink,
  FileText,
  Globe,
  Loader2,
  Play,
  RefreshCw,
  RotateCw,
  Save,
  Square,
  X,
} from 'lucide-react-native';
import { getServerUrlSync } from '../lib/server-config';
import { getStoredAuthToken } from '~shared/utils/api';
import type { ThemeColors } from '../theme';
import {
  buildPreviewUrl,
  parsePreviewPorts,
  parseSharedContext,
  isSharedContextTooLarge,
  PREVIEW_POLL_MS,
  type ListeningPort,
} from '../lib/workspace-panes';

const MONO = 'Menlo';

// ---------------------------------------------------------------------------
// TerminalPane — WebView hosting the web xterm island (no native xterm)
// ---------------------------------------------------------------------------

export function TerminalPane({
  projectId,
  isActive,
  colors,
}: {
  projectId?: string | null;
  isActive?: boolean;
  colors: ThemeColors;
}) {
  const insets = { bottom: 0 };
  const uri = useMemo(() => {
    const base = getServerUrlSync();
    const token = getStoredAuthToken();
    if (!base || !token) return null;
    const q = new URLSearchParams();
    q.set('controls', '1');
    if (projectId) q.set('project', projectId);
    q.set('token', token);
    return `${base}/island/terminal?${q.toString()}`;
  }, [projectId]);

  if (!uri) {
    return (
      <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: colors.background }}>
        <Text style={{ color: colors.destructive }}>No server/token configured</Text>
      </View>
    );
  }
  return (
    <WebView
      source={{ uri }}
      style={{ flex: 1, backgroundColor: colors.background }}
      startInLoadingState
      renderLoading={() => (
        <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: colors.background }}>
          <ActivityIndicator color={colors.primary} size="large" />
        </View>
      )}
      androidLayerType="hardware"
      setSupportMultipleWindows={false}
    />
  );
}

// ---------------------------------------------------------------------------
// NotesPane — server-side shared-context markdown for the project
// ---------------------------------------------------------------------------

export function NotesPane({
  projectId,
  isActive,
  colors,
}: {
  projectId?: string | null;
  isActive?: boolean;
  colors: ThemeColors;
}) {
  const [content, setContent] = useState('');
  const [updatedAt, setUpdatedAt] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const loadedRef = useRef(false);

  useEffect(() => {
    if (!projectId || loadedRef.current) return;
    loadedRef.current = true;
    (async () => {
      try {
        const res = await fetch(`${getServerUrlSync()}/api/shared-context?project=${encodeURIComponent(projectId)}`, {
          headers: { Authorization: `Bearer ${getStoredAuthToken() ?? ''}` },
        });
        const json = await res.json();
        const parsed = parseSharedContext(json);
        setContent(parsed.content);
        setUpdatedAt(parsed.updatedAt);
      } catch (e) {
        setError(e instanceof Error ? e.message : 'Failed to load notes');
      }
    })();
  }, [projectId]);

  const save = useCallback(async () => {
    if (!projectId) return;
    if (isSharedContextTooLarge(content)) {
      setError('Shared notes exceed the 50 KB limit');
      return;
    }
    setSaving(true);
    setError(null);
    try {
      const res = await fetch(`${getServerUrlSync()}/api/shared-context`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${getStoredAuthToken() ?? ''}`,
        },
        body: JSON.stringify({ project: projectId, content }),
      });
      const json = await res.json();
      const parsed = parseSharedContext(json);
      setUpdatedAt(parsed.updatedAt);
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Failed to save notes');
    } finally {
      setSaving(false);
    }
  }, [projectId, content]);

  if (!projectId) {
    return (
      <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: colors.background, padding: 24 }}>
        <Text style={{ color: colors.mutedForeground, textAlign: 'center' }}>Select a project to edit shared notes</Text>
      </View>
    );
  }

  return (
    <View style={{ flex: 1, backgroundColor: colors.background }}>
      <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingHorizontal: 12, paddingVertical: 8, borderBottomWidth: 1, borderBottomColor: colors.border }}>
        <FileText size={14} color={colors.mutedForeground} />
        <Text style={{ flex: 1, color: colors.mutedForeground, fontSize: 11 }} numberOfLines={1}>
          {updatedAt ? `Updated ${updatedAt}` : 'Shared context for this project'}
        </Text>
        <TouchableOpacity onPress={save} disabled={saving} style={{ flexDirection: 'row', alignItems: 'center', gap: 6, backgroundColor: colors.primary, borderRadius: 6, paddingHorizontal: 10, paddingVertical: 6 }}>
          {saving ? <ActivityIndicator size="small" color={colors.primaryForeground} /> : <Save size={14} color={colors.primaryForeground} />}
          <Text style={{ color: colors.primaryForeground, fontSize: 12 }}>Save</Text>
        </TouchableOpacity>
      </View>
      {error ? <Text style={{ color: colors.destructive, fontSize: 12, paddingHorizontal: 12, paddingTop: 6 }}>{error}</Text> : null}
      <TextInput
        value={content}
        onChangeText={setContent}
        multiline
        textAlignVertical="top"
        placeholder="Project-wide notes prepended to the first message of every session…"
        placeholderTextColor={colors.mutedForeground}
        style={{ flex: 1, color: colors.foreground, fontFamily: MONO, fontSize: 13, padding: 12 }}
      />
    </View>
  );
}

// ---------------------------------------------------------------------------
// PreviewPane — dev-server port discovery + WebView preview
// ---------------------------------------------------------------------------

export function PreviewPane({
  projectId,
  projectPath,
  isActive,
  colors,
}: {
  projectId?: string | null;
  projectPath?: string | null;
  isActive?: boolean;
  colors: ThemeColors;
}) {
  const { width } = useWindowDimensions();
  const [ports, setPorts] = useState<ListeningPort[]>([]);
  const [selected, setSelected] = useState<number | null>(null);
  const [reloadTick, setReloadTick] = useState(0);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!projectPath) return;
    let cancelled = false;
    const load = async () => {
      try {
        const res = await fetch(
          `${getServerUrlSync()}/api/preview/ports?projectPath=${encodeURIComponent(projectPath)}`,
          { headers: { Authorization: `Bearer ${getStoredAuthToken() ?? ''}` } },
        );
        const json = await res.json();
        if (cancelled) return;
        const next = parsePreviewPorts(json);
        setPorts(next);
        setSelected((cur) => (cur != null && next.some((p) => p.port === cur) ? cur : next[0]?.port ?? null));
      } catch {
        if (!cancelled) setPorts([]);
      } finally {
        if (!cancelled) setLoading(false);
      }
    };
    void load();
    const timer = setInterval(load, PREVIEW_POLL_MS);
    return () => {
      cancelled = true;
      clearInterval(timer);
    };
  }, [projectPath]);

  const token = getStoredAuthToken();
  const previewBase = getServerUrlSync();
  const uri = selected != null && token && previewBase ? `${buildPreviewUrl(previewBase, selected, token)}&_t=${reloadTick}` : null;

  if (!projectPath) {
    return (
      <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: colors.background, padding: 24 }}>
        <Text style={{ color: colors.mutedForeground, textAlign: 'center' }}>Select a project to preview its dev server</Text>
      </View>
    );
  }

  return (
    <View style={{ flex: 1, backgroundColor: colors.background }}>
      <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingHorizontal: 10, paddingVertical: 6, borderBottomWidth: 1, borderBottomColor: colors.border }}>
        {loading && ports.length === 0 ? (
          <ActivityIndicator size="small" color={colors.mutedForeground} />
        ) : ports.length === 0 ? (
          <Text style={{ flex: 1, color: colors.mutedForeground, fontSize: 11 }}>No dev servers detected</Text>
        ) : (
          <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={{ gap: 6 }}>
            {ports.map((p) => (
              <TouchableOpacity
                key={p.port}
                onPress={() => setSelected(p.port)}
                style={{
                  borderRadius: 6,
                  paddingHorizontal: 8,
                  paddingVertical: 4,
                  backgroundColor: selected === p.port ? colors.primary : colors.muted,
                }}
              >
                <Text style={{ color: selected === p.port ? colors.primaryForeground : colors.mutedForeground, fontSize: 11, fontFamily: MONO }}>
                  :{p.port}
                </Text>
              </TouchableOpacity>
            ))}
          </ScrollView>
        )}
        <TouchableOpacity onPress={() => setReloadTick((t) => t + 1)} hitSlop={8}>
          <RefreshCw size={15} color={colors.mutedForeground} />
        </TouchableOpacity>
        {selected != null ? (
          <TouchableOpacity
            onPress={() => {
              const t = getStoredAuthToken();
              const b = getServerUrlSync();
              if (t && b) void Linking.openURL(buildPreviewUrl(b, selected, t));
            }}
            hitSlop={8}
          >
            <ExternalLink size={15} color={colors.mutedForeground} />
          </TouchableOpacity>
        ) : null}
      </View>
      {uri ? (
        <WebView key={`${selected}:${reloadTick}`} source={{ uri }} style={{ flex: 1, backgroundColor: colors.background }} startInLoadingState />
      ) : (
        <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
          <Text style={{ color: colors.mutedForeground }}>No preview available</Text>
        </View>
      )}
    </View>
  );
}

// ---------------------------------------------------------------------------
// BrowserPane — remote Chromium streamed over the /browser-view WebSocket
// ---------------------------------------------------------------------------

interface BrowserNav {
  url: string;
  title: string;
  canGoBack: boolean;
  canGoForward: boolean;
  loading: boolean;
}

const BROWSER_VIEW_HTML = `<!doctype html><html><head><meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1"><style>
html,body{margin:0;height:100%;background:#111;overflow:hidden}
img{width:100%;height:100%;object-fit:contain;display:block}
#ph{position:absolute;inset:0;display:flex;align-items:center;justify-content:center;color:#888;font:14px system-ui}
</style></head><body>
<div id="ph">Connecting…</div>
<img id="f" alt="" />
<script>
(function(){
  var img=document.getElementById('f'), ph=document.getElementById('ph');
  function post(m){ try{ window.ReactNativeWebView.postMessage(JSON.stringify(m)); }catch(e){} }
  img.addEventListener('load', function(){ ph.style.display='none'; });
  document.addEventListener('click', function(e){
    var x=e.clientX/window.innerWidth, y=e.clientY/window.innerHeight;
    post({__tap:x,y});
  }, true);
  window.__setFrame=function(data){ img.src='data:image/jpeg;base64,'+data; };
})();
</script></body></html>`;

function wsUrl(base: string, token: string): string {
  const b = base.replace(/^http/, 'ws').replace(/\/$/, '');
  return `${b}/browser-view?token=${encodeURIComponent(token)}`;
}

export function BrowserPane({
  url,
  isActive,
  colors,
  onUrlChange,
}: {
  url?: string | null;
  isActive?: boolean;
  colors: ThemeColors;
  onUrlChange?: (url: string) => void;
}) {
  const { width, height } = useWindowDimensions();
  const webRef = useRef<WebView>(null);
  const wsRef = useRef<WebSocket | null>(null);
  const retryRef = useRef(0);
  const mountedRef = useRef(true);
  const [address, setAddress] = useState(url ?? '');
  const [committed, setCommitted] = useState(url ?? '');
  const [nav, setNav] = useState<BrowserNav>({ url: url ?? '', title: '', canGoBack: false, canGoForward: false, loading: true });
  const [status, setStatus] = useState<'connecting' | 'ready' | 'error'>('connecting');
  const [error, setError] = useState<string | null>(null);

  const send = useCallback((msg: Record<string, unknown>) => {
    const ws = wsRef.current;
    if (ws && ws.readyState === WebSocket.OPEN) ws.send(JSON.stringify(msg));
  }, []);

  const connect = useCallback(() => {
    const base = getServerUrlSync();
    const token = getStoredAuthToken();
    if (!base || !token) {
      setStatus('error');
      setError('No server/token configured');
      return;
    }
    setStatus('connecting');
    const ws = new WebSocket(wsUrl(base, token));
    wsRef.current = ws;
    ws.onopen = () => {
      retryRef.current = 0;
      ws.send(JSON.stringify({ type: 'start', url: committed || undefined, width, height }));
      setStatus('ready');
      setError(null);
    };
    ws.onmessage = (ev) => {
      let msg: any;
      try {
        msg = JSON.parse(ev.data as string);
      } catch {
        return;
      }
      if (msg.type === 'frame' && typeof msg.data === 'string') {
        webRef.current?.injectJavaScript(`window.__setFrame(${JSON.stringify(msg.data)});true;`);
      } else if (msg.type === 'navigation') {
        setNav({
          url: msg.url ?? '',
          title: msg.title ?? '',
          canGoBack: Boolean(msg.canGoBack),
          canGoForward: Boolean(msg.canGoForward),
          loading: Boolean(msg.loading),
        });
        if (typeof msg.url === 'string') {
          setAddress(msg.url);
          onUrlChange?.(msg.url);
        }
      } else if (msg.type === 'error') {
        setStatus('error');
        setError(typeof msg.error === 'string' ? msg.error : 'Browser error');
      }
    };
    ws.onerror = () => {
      setStatus('error');
      setError('Connection error');
    };
    ws.onclose = () => {
      if (!mountedRef.current) return;
      const delay = Math.min(1000 * 2 ** retryRef.current, 10000);
      retryRef.current += 1;
      setTimeout(() => {
        if (mountedRef.current) connect();
      }, delay);
    };
  }, [committed, width, height, onUrlChange]);

  useEffect(() => {
    mountedRef.current = true;
    connect();
    return () => {
      mountedRef.current = false;
      send({ type: 'close' });
      try {
        wsRef.current?.close();
      } catch {
        /* ignore */
      }
      wsRef.current = null;
    };
  }, [connect, send]);

  // Report viewport changes to the server when this pane is active.
  useEffect(() => {
    if (isActive) send({ type: 'resize', width, height });
  }, [isActive, width, height, send]);

  const normalize = (input: string): string => {
    const trimmed = input.trim();
    if (!trimmed) return '';
    if (/^https?:\/\//i.test(trimmed)) return trimmed;
    return `https://${trimmed}`;
  };

  const go = () => {
    const next = normalize(address);
    if (!next) return;
    setCommitted(next);
    setNav((n) => ({ ...n, url: next, loading: true }));
    send({ type: 'navigate', url: next });
  };

  const onIslandMessage = (e: WebViewMessageEvent) => {
    try {
      const msg = JSON.parse(e.nativeEvent.data);
      if (typeof msg?.__tap === 'number') {
        const x = msg.__tap;
        const y = msg.y;
        send({ type: 'mouse', event: 'down', x, y, button: 'left' });
        send({ type: 'mouse', event: 'up', x, y, button: 'left' });
      }
    } catch {
      /* ignore */
    }
  };

  return (
    <View style={{ flex: 1, backgroundColor: colors.background }}>
      <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6, paddingHorizontal: 8, paddingVertical: 6, borderBottomWidth: 1, borderBottomColor: colors.border }}>
        <TouchableOpacity onPress={() => send({ type: 'back' })} disabled={!nav.canGoBack} hitSlop={6}>
          <ArrowLeft size={16} color={nav.canGoBack ? colors.foreground : colors.mutedForeground} />
        </TouchableOpacity>
        <TouchableOpacity onPress={() => send({ type: 'forward' })} disabled={!nav.canGoForward} hitSlop={6}>
          <ArrowRight size={16} color={nav.canGoForward ? colors.foreground : colors.mutedForeground} />
        </TouchableOpacity>
        <TouchableOpacity onPress={() => send({ type: nav.loading ? 'stop' : 'reload' })} hitSlop={6}>
          {nav.loading ? <X size={16} color={colors.foreground} /> : <RotateCw size={16} color={colors.foreground} />}
        </TouchableOpacity>
        <TextInput
          value={address}
          onChangeText={setAddress}
          onSubmitEditing={go}
          autoCapitalize="none"
          autoCorrect={false}
          keyboardType="url"
          returnKeyType="go"
          placeholder="Enter URL"
          placeholderTextColor={colors.mutedForeground}
          style={{ flex: 1, color: colors.foreground, backgroundColor: colors.card, borderWidth: 1, borderColor: colors.border, borderRadius: 6, paddingHorizontal: 8, paddingVertical: 5, fontSize: 12 }}
        />
        <TouchableOpacity onPress={() => nav.url && void Linking.openURL(nav.url)} hitSlop={6}>
          <ExternalLink size={16} color={colors.mutedForeground} />
        </TouchableOpacity>
      </View>
      {status === 'error' ? (
        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, padding: 8, backgroundColor: colors.card }}>
          <Text style={{ flex: 1, color: colors.destructive, fontSize: 12 }}>{error ?? 'Connection failed'}</Text>
          <TouchableOpacity onPress={connect} style={{ backgroundColor: colors.primary, borderRadius: 6, paddingHorizontal: 10, paddingVertical: 5 }}>
            <Text style={{ color: colors.primaryForeground, fontSize: 12 }}>Retry</Text>
          </TouchableOpacity>
        </View>
      ) : null}
      <WebView
        ref={webRef}
        source={{ html: BROWSER_VIEW_HTML }}
        originWhitelist={['*']}
        onMessage={onIslandMessage}
        style={{ flex: 1, backgroundColor: '#111' }}
        androidLayerType="hardware"
        setSupportMultipleWindows={false}
      />
    </View>
  );
}

// ---------------------------------------------------------------------------
// BroadcastDialog — enqueue one message into many sessions
// ---------------------------------------------------------------------------

export function BroadcastDialog({
  visible,
  colors,
  sessions,
  onClose,
  onSent,
}: {
  visible: boolean;
  colors: ThemeColors;
  sessions: { sessionId: string; title: string; projectName?: string | null; isArchived?: boolean }[];
  onClose: () => void;
  onSent: (results: { ok: number; failed: number }) => void;
}) {
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [message, setMessage] = useState('');
  const [sending, setSending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const candidates = useMemo(() => sessions.filter((s) => !s.isArchived), [sessions]);

  useEffect(() => {
    if (visible) {
      setSelected(new Set());
      setMessage('');
      setError(null);
    }
  }, [visible]);

  const toggle = (id: string) => {
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  const send = async () => {
    if (selected.size === 0 || !message.trim()) return;
    setSending(true);
    setError(null);
    try {
      const res = await fetch(`${getServerUrlSync()}/api/queue/broadcast`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${getStoredAuthToken() ?? ''}`,
        },
        body: JSON.stringify({ sessionIds: Array.from(selected), content: message.trim() }),
      });
      const json = await res.json();
      const { parseBroadcastResults } = await import('../lib/workspace-panes');
      const results = parseBroadcastResults(json);
      const ok = results.filter((r) => r.ok).length;
      const failed = results.filter((r) => !r.ok).length;
      onSent({ ok, failed });
      onClose();
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Broadcast failed');
    } finally {
      setSending(false);
    }
  };

  return (
    <Modal visible={visible} transparent animationType="fade" onRequestClose={onClose}>
      <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' }}>
        <View style={{ backgroundColor: colors.card, borderTopLeftRadius: 14, borderTopRightRadius: 14, maxHeight: '80%', padding: 16 }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', marginBottom: 10 }}>
            <Text style={{ flex: 1, color: colors.foreground, fontSize: 15, fontWeight: '600' }}>Broadcast to sessions</Text>
            <TouchableOpacity onPress={onClose} hitSlop={8}>
              <X size={18} color={colors.mutedForeground} />
            </TouchableOpacity>
          </View>
          {candidates.length === 0 ? (
            <Text style={{ color: colors.mutedForeground, paddingVertical: 12 }}>No sessions available</Text>
          ) : (
            <>
              <TouchableOpacity
                onPress={() => setSelected(selected.size === candidates.length ? new Set() : new Set(candidates.map((c) => c.sessionId)))}
                style={{ alignSelf: 'flex-start', marginBottom: 6 }}
              >
                <Text style={{ color: colors.primary, fontSize: 12 }}>Select all</Text>
              </TouchableOpacity>
              <ScrollView style={{ maxHeight: 220 }}>
                {candidates.map((s) => {
                  const on = selected.has(s.sessionId);
                  return (
                    <TouchableOpacity key={s.sessionId} onPress={() => toggle(s.sessionId)} style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingVertical: 8 }}>
                      <View style={{ width: 18, height: 18, borderRadius: 4, borderWidth: 1, borderColor: on ? colors.primary : colors.border, backgroundColor: on ? colors.primary : 'transparent', alignItems: 'center', justifyContent: 'center' }}>
                        {on ? <Text style={{ color: colors.primaryForeground, fontSize: 11 }}>✓</Text> : null}
                      </View>
                      <View style={{ flex: 1 }}>
                        <Text style={{ color: colors.foreground, fontSize: 13 }} numberOfLines={1}>{s.title}</Text>
                        {s.projectName ? <Text style={{ color: colors.mutedForeground, fontSize: 11 }} numberOfLines={1}>{s.projectName}</Text> : null}
                      </View>
                    </TouchableOpacity>
                  );
                })}
              </ScrollView>
            </>
          )}
          <TextInput
            value={message}
            onChangeText={setMessage}
            multiline
            placeholder="Message to send to each session…"
            placeholderTextColor={colors.mutedForeground}
            style={{ color: colors.foreground, borderWidth: 1, borderColor: colors.border, borderRadius: 8, padding: 10, minHeight: 72, marginTop: 10, textAlignVertical: 'top' }}
          />
          {error ? <Text style={{ color: colors.destructive, fontSize: 12, marginTop: 6 }}>{error}</Text> : null}
          <TouchableOpacity
            onPress={send}
            disabled={sending || selected.size === 0 || !message.trim()}
            style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 6, marginTop: 12, backgroundColor: selected.size === 0 || !message.trim() ? colors.muted : colors.primary, borderRadius: 8, paddingVertical: 12 }}
          >
            {sending ? <ActivityIndicator size="small" color={colors.primaryForeground} /> : <Play size={16} color={colors.primaryForeground} />}
            <Text style={{ color: colors.primaryForeground, fontWeight: '600' }}>{`Send to ${selected.size} session${selected.size === 1 ? '' : 's'}`}</Text>
          </TouchableOpacity>
        </View>
      </View>
    </Modal>
  );
}

// Re-exported for convenience in tests / other modules.
