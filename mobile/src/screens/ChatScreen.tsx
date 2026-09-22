import React, { useCallback, useEffect, useRef, useState } from 'react';
import {
  ActivityIndicator,
  Alert,
  FlatList,
  KeyboardAvoidingView,
  Modal,
  Platform,
  Share,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import { useNavigation, useRoute } from '@react-navigation/native';
import Markdown from 'react-native-markdown-display';
import * as Haptics from 'expo-haptics';
import { Send, Wrench, ChevronDown, ChevronRight, Zap, X, ShieldAlert, Check, Square, Paperclip } from 'lucide-react-native';
import * as Clipboard from 'expo-clipboard';
import * as ImagePicker from 'expo-image-picker';
import { api, getStoredAuthToken } from '~shared/utils/api';
import { WebView } from 'react-native-webview';
import { useTheme } from '../theme';
import { useWebSocket } from '../contexts/WebSocketContext';
import { getServerUrlSync } from '../lib/server-config';
import { ChatMessage, ToolCall, messagesFromResponse, parseItem } from '../lib/chat-messages';

interface QueuedItem {
  id: string;
  content?: string;
}

interface PermissionRequest {
  requestId: string;
  toolName: string;
  input?: unknown;
}

/** Pending permission_request frames → Allow/Deny banner above the composer. */
function PermissionBanner({
  requests,
  colors,
  onDecision,
}: {
  requests: PermissionRequest[];
  colors: any;
  onDecision: (ids: string[], decision: { allow: boolean; message?: string }) => void;
}) {
  if (requests.length === 0) return null;
  const allIds = requests.map((r) => r.requestId);
  return (
    <View style={{ borderTopWidth: 1, borderTopColor: colors.border, backgroundColor: colors.card, padding: 10 }}>
      {requests.length > 1 && (
        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginBottom: 8 }}>
          <Text style={{ color: colors.foreground, fontSize: 12, fontWeight: '600' }}>{requests.length} queued</Text>
          <View style={{ flexDirection: 'row', gap: 12 }}>
            <TouchableOpacity onPress={() => onDecision(allIds, { allow: false, message: 'User denied all tool use' })}>
              <Text style={{ color: colors.destructive, fontWeight: '600' }}>Reject all</Text>
            </TouchableOpacity>
            <TouchableOpacity onPress={() => onDecision(allIds, { allow: true })}>
              <Text style={{ color: '#16a34a', fontWeight: '600' }}>Allow all</Text>
            </TouchableOpacity>
          </View>
        </View>
      )}
      {requests.map((r) => (
        <View
          key={r.requestId}
          style={{
            backgroundColor: colors.background,
            borderColor: colors.border,
            borderWidth: 1,
            borderRadius: 10,
            padding: 10,
            marginBottom: 6,
          }}
        >
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6, marginBottom: 4 }}>
            <ShieldAlert size={15} color="#f59e0b" />
            <Text style={{ color: colors.foreground, fontWeight: '600', fontSize: 13 }}>Permission required</Text>
            <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{r.toolName}</Text>
          </View>
          {r.input != null && (
            <Text style={{ color: colors.mutedForeground, fontSize: 11, fontFamily: 'monospace' }} numberOfLines={3}>
              {typeof r.input === 'string' ? r.input : JSON.stringify(r.input)}
            </Text>
          )}
          <View style={{ flexDirection: 'row', gap: 10, marginTop: 8 }}>
            <TouchableOpacity
              onPress={() => onDecision([r.requestId], { allow: false, message: 'User denied tool use' })}
              style={{ flex: 1, borderColor: colors.destructive, borderWidth: 1, borderRadius: 8, paddingVertical: 8, alignItems: 'center' }}
            >
              <View style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
                <X size={14} color={colors.destructive} />
                <Text style={{ color: colors.destructive, fontWeight: '600', fontSize: 13 }}>Deny</Text>
              </View>
            </TouchableOpacity>
            <TouchableOpacity
              onPress={() => onDecision([r.requestId], { allow: true })}
              style={{ flex: 1, backgroundColor: '#16a34a', borderRadius: 8, paddingVertical: 8, alignItems: 'center' }}
            >
              <View style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
                <Check size={14} color="#fff" />
                <Text style={{ color: '#fff', fontWeight: '600', fontSize: 13 }}>Allow</Text>
              </View>
            </TouchableOpacity>
          </View>
        </View>
      ))}
    </View>
  );
}

/** ```mermaid fence → /island/mermaid WebView; tap opens it fullscreen. */
function MermaidBlock({ code, colors }: { code: string; colors: any }) {
  const [expanded, setExpanded] = useState(false);
  const uri = (() => {
    const base = getServerUrlSync();
    const token = getStoredAuthToken();
    if (!base || !token) return null;
    const b64 = btoa(unescape(encodeURIComponent(code))).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
    return `${base}/island/mermaid?code=${b64}&token=${encodeURIComponent(token)}`;
  })();

  if (!uri) return null;
  const diagram = (
    <WebView
      source={{ uri }}
      style={{ flex: 1, backgroundColor: 'transparent' }}
      scrollEnabled={expanded}
      setSupportMultipleWindows={false}
    />
  );
  return (
    <>
      <TouchableOpacity activeOpacity={0.85} onPress={() => setExpanded(true)}>
        <View style={{ height: 240, borderRadius: 8, borderWidth: 1, borderColor: colors.border, overflow: 'hidden', marginVertical: 6 }}>
          {diagram}
        </View>
      </TouchableOpacity>
      <Modal visible={expanded} animationType="fade" onRequestClose={() => setExpanded(false)}>
        <View style={{ flex: 1, backgroundColor: colors.background }}>
          {expanded ? diagram : null}
          <TouchableOpacity
            onPress={() => setExpanded(false)}
            style={{ position: 'absolute', top: 48, right: 16, padding: 10, backgroundColor: colors.card, borderRadius: 20 }}
          >
            <X size={20} color={colors.foreground} />
          </TouchableOpacity>
        </View>
      </Modal>
    </>
  );
}

/** markdown rules: mermaid fences go to the island, everything else default. */
const markdownRules = (colors: any) => ({
  fence: (node: any) => {
    const lang = (node.sourceInfo ?? '').trim().split(/\s+/)[0];
    if (lang === 'mermaid') {
      return <MermaidBlock key={node.key} code={node.content} colors={colors} />;
    }
    return (
      <View
        key={node.key}
        style={{ backgroundColor: colors.card, borderRadius: 8, padding: 10, borderWidth: 1, borderColor: colors.border, marginVertical: 4 }}
      >
        <Text style={{ color: colors.foreground, fontFamily: Platform.OS === 'ios' ? 'Menlo' : 'monospace', fontSize: 13 }}>
          {node.content}
        </Text>
      </View>
    );
  },
});

function ToolRow({ tool, colors }: { tool: ToolCall; colors: any }) {
  const [open, setOpen] = useState(false);
  return (
    <TouchableOpacity
      onPress={() => tool.detail && setOpen(!open)}
      style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: colors.card, borderColor: colors.border, borderWidth: 1, borderRadius: 8, padding: 8, marginBottom: 4 }}
    >
      <Wrench size={13} color={colors.mutedForeground} />
      <Text style={{ color: colors.mutedForeground, fontSize: 12, marginLeft: 6, flex: 1 }} numberOfLines={1}>
        {tool.name}
      </Text>
      {tool.detail ? (
        open ? <ChevronDown size={13} color={colors.mutedForeground} /> : <ChevronRight size={13} color={colors.mutedForeground} />
      ) : null}
      {open && !!tool.detail && (
        <Text style={{ color: colors.mutedForeground, fontSize: 11, fontFamily: 'monospace', marginTop: 6 }}>{tool.detail}</Text>
      )}
    </TouchableOpacity>
  );
}

function QueueBar({ sessionId, colors, reloadKey }: { sessionId?: string; colors: any; reloadKey: number }) {
  const [items, setItems] = useState<QueuedItem[]>([]);
  const { subscribe } = useWebSocket();

  const load = useCallback(async () => {
    if (!sessionId) return;
    try {
      const res = await api.queue.list(sessionId);
      if (res.ok) {
        const data = await res.json();
        const list = Array.isArray(data) ? data : data?.data?.messages ?? data?.messages ?? data?.items ?? [];
        setItems(list);
      }
    } catch {
      /* queue endpoint optional */
    }
  }, [sessionId]);

  useEffect(() => {
    load();
  }, [load, reloadKey]);

  // The server broadcasts queue snapshots on enqueue/send-now/remove —
  // consume them directly instead of refetching.
  useEffect(
    () =>
      subscribe((event) => {
        if (event?.type === 'queued-messages-updated' && event.sessionId === sessionId) {
          setItems(Array.isArray(event.messages) ? event.messages : []);
        }
      }),
    [subscribe, sessionId],
  );

  if (items.length === 0) return null;

  return (
    <View style={{ borderTopWidth: 1, borderTopColor: colors.border, backgroundColor: colors.card, paddingHorizontal: 10, paddingVertical: 6 }}>
      {items.map((q, i) => (
        <View key={q.id ?? i} style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 4 }}>
          <Text style={{ flex: 1, color: colors.mutedForeground, fontSize: 12 }} numberOfLines={1}>
            {q.content ?? 'queued message'}
          </Text>
          <TouchableOpacity
            onPress={() => api.queue.sendNow(q.id).then(load).catch(() => {})}
            style={{ padding: 6 }}
            hitSlop={6}
          >
            <Zap size={14} color={colors.primary} />
          </TouchableOpacity>
          <TouchableOpacity onPress={() => api.queue.remove(q.id).then(load).catch(() => {})} style={{ padding: 6 }} hitSlop={6}>
            <X size={14} color={colors.mutedForeground} />
          </TouchableOpacity>
        </View>
      ))}
    </View>
  );
}

export default function ChatScreen() {
  const { colors } = useTheme();
  const route = useRoute<any>();
  const navigation = useNavigation<any>();
  // newSession → draft mode: first send POSTs /api/providers/sessions with
  // the message, then we swap params to the real sessionId.
  const { sessionId, newSession, projectPath: paramPath, provider: paramProvider } = route.params as {
    sessionId?: string;
    newSession?: boolean;
    projectPath?: string;
    provider?: string;
  };
  const { projectId: paramProjectId } = route.params as { projectId?: string };
  const [resolved, setResolved] = useState<{ provider?: string; projectPath?: string; projectId?: string }>({});
  const provider = paramProvider ?? resolved.provider;
  const projectPath = paramPath ?? resolved.projectPath;
  const projectId = paramProjectId ?? resolved.projectId;
  const { subscribe, sendMessage, isConnected } = useWebSocket();
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [loading, setLoading] = useState(true);
  const [draft, setDraft] = useState('');
  const [sending, setSending] = useState(false);
  const [running, setRunning] = useState(false);
  const [permissionMode, setPermissionMode] = useState<'default' | 'acceptEdits' | 'plan' | 'bypassPermissions'>('default');
  const [model, setModel] = useState<string | null>(null);
  const [models, setModels] = useState<{ value: string; label: string }[]>([]);
  const [modelModal, setModelModal] = useState(false);
  const [slashCommands, setSlashCommands] = useState<{ name: string; description?: string; path?: string }[]>([]);
  const [pendingAttachments, setPendingAttachments] = useState<{ uri: string; name: string; mimeType: string }[]>([]);
  const [mentionFiles, setMentionFiles] = useState<string[]>([]);
  const [queueKey, setQueueKey] = useState(0);
  const listRef = useRef<FlatList<ChatMessage>>(null);
  // Live WS items can carry duplicate or missing ids (tool_use shares call ids,
  // text events have none) — a counter keeps FlatList keys unique.
  const liveSeq = useRef(0);
  const [pendingPermissions, setPendingPermissions] = useState<PermissionRequest[]>([]);
  const [hasMore, setHasMore] = useState(false);
  const [loadingOlder, setLoadingOlder] = useState(false);
  // Raw history items fetched so far — pagination offset counts raw rows,
  // not rendered messages (tool_results fold into tool_use rows).
  const rawCountRef = useRef(0);

  const parseRaw = useCallback((raw: any[]): ChatMessage[] => {
    const msgs: ChatMessage[] = [];
    for (const m of raw) {
      const p = parseItem(m);
      // Fold tool_result payloads into their tool_use row instead of
      // rendering a second row per call.
      if (m.kind === 'tool_result' && p.tools[0]) {
        const toolId = String(m.toolId ?? '');
        const target = msgs.findLast((x) => x.tools.some((t) => t.id === toolId));
        const tool = target?.tools.find((t) => t.id === toolId);
        if (tool) {
          tool.status = m.isError ? 'error' : 'done';
          tool.detail = [tool.detail, p.tools[0].detail].filter(Boolean).join('\n→ ');
          continue;
        }
      }
      if (p.skip || (p.text.trim().length === 0 && p.tools.length === 0)) continue;
      msgs.push({
        id: String(m.id ?? m.uuid ?? `hist-${msgs.length}`),
        role: p.role,
        text: p.text,
        tools: p.tools,
        timestamp: m.timestamp ?? m.createdAt,
      });
    }
    return msgs;
  }, []);

  const load = useCallback(async () => {
    if (!sessionId) {
      setLoading(false);
      return;
    }
    try {
      const res = await api.unifiedSessionMessages(sessionId, 'claude', { limit: 100 } as never);
      if (res.ok) {
        const data = await res.json();
        const raw = messagesFromResponse(data);
        rawCountRef.current = raw.length;
        setMessages(parseRaw(raw));
        setHasMore(Boolean(data?.data?.hasMore ?? data?.hasMore));
      }
    } catch (err) {
      console.error('messages load failed:', err);
    } finally {
      setLoading(false);
    }
  }, [sessionId, parseRaw]);

  const loadOlder = useCallback(async () => {
    if (loadingOlder || !hasMore) return;
    setLoadingOlder(true);
    try {
      // offset counts raw items back from the newest end.
      const res = await api.unifiedSessionMessages(sessionId!, 'claude', { limit: 100, offset: rawCountRef.current } as never);
      if (res.ok) {
        const data = await res.json();
        const raw = messagesFromResponse(data);
        rawCountRef.current += raw.length;
        setMessages((prev) => [...parseRaw(raw), ...prev]);
        setHasMore(Boolean(data?.data?.hasMore ?? data?.hasMore));
      }
    } finally {
      setLoadingOlder(false);
    }
  }, [loadingOlder, hasMore, sessionId, parseRaw]);

  useEffect(() => {
    load();
  }, [load]);

  // Deltas only flow after a per-session chat.subscribe — send it whenever the
  // socket (re)connects, mirroring useChatSessionState on web.
  useEffect(() => {
    if (!isConnected || !sessionId) return;
    sendMessage({ type: 'chat.subscribe', sessions: [{ sessionId, lastSeq: 0 }] });
  }, [isConnected, sendMessage, sessionId]);

  // Mark viewed once the session is open. Also resolves provider/projectPath
  // when they weren't passed as nav params (e.g. deep link).
  useEffect(() => {
    if (!sessionId) return;
    api.markSessionViewed(sessionId).catch(() => {});
    if (paramProvider && paramPath) return;
    api
      .sessionDetails(sessionId)
      .then((r) => (r.ok ? r.json() : null))
      .then((d) => {
        if (d?.data) {
          setResolved({
            provider: d.data.provider,
            projectPath: d.data.project?.path,
            projectId: d.data.project?.projectId,
          });
        }
      })
      .catch(() => {});
  }, [sessionId, paramProvider, paramPath]);

  // Composer state: model catalog + the session's currently-active model.
  useEffect(() => {
    if (!sessionId || !provider) return;
    let alive = true;
    (async () => {
      try {
        const [catRes, activeRes] = await Promise.all([
          api.get(`/providers/${provider}/models`),
          api.get(`/providers/${provider}/sessions/${sessionId}/active-model`),
        ]);
        if (!alive) return;
        if (catRes.ok) {
          const body = await catRes.json();
          const opts = body?.data?.models?.OPTIONS ?? body?.data?.models?.options ?? [];
          setModels(opts.map((m: any) => ({ value: String(m.value), label: String(m.label ?? m.value) })));
        }
        if (activeRes.ok) {
          const body = await activeRes.json();
          if (body?.data?.model) setModel(String(body.data.model));
        }
      } catch {
        /* model endpoints optional */
      }
    })();
    return () => {
      alive = false;
    };
  }, [sessionId, provider]);

  // Slash commands for the current project (built-in + custom; provider skills
  // are merged on web too but kept simple here).
  useEffect(() => {
    if (!projectPath) return;
    api
      .post('/commands/list', { projectPath })
      .then((r) => (r.ok ? r.json() : null))
      .then((d) => {
        if (!d) return;
        setSlashCommands([...(d.builtIn ?? d.data?.builtIn ?? []), ...(d.custom ?? d.data?.custom ?? [])]);
      })
      .catch(() => {});
  }, [projectPath]);

  // @-mention file list — flattened once per project, filtered on the draft.
  useEffect(() => {
    if (!projectId) return;
    api
      .getMentionableFiles(projectId)
      .then((r) => (r.ok ? r.json() : null))
      .then((tree) => {
        if (!Array.isArray(tree)) return;
        const paths: string[] = [];
        const walk = (nodes: any[], prefix: string) => {
          for (const n of nodes) {
            const p = prefix ? `${prefix}/${n.name}` : n.name;
            if (n.type === 'directory' && Array.isArray(n.children)) walk(n.children, p);
            else if (n.type !== 'directory') paths.push(n.path ?? p);
          }
        };
        walk(tree, '');
        setMentionFiles(paths);
      })
      .catch(() => {});
  }, [projectId]);

  const pickImage = async () => {
    const res = await ImagePicker.launchImageLibraryAsync({ mediaTypes: ['images'], quality: 0.8 });
    if (res.canceled) return;
    setPendingAttachments((prev) => [
      ...prev,
      ...res.assets.map((a) => ({
        uri: a.uri,
        name: a.fileName ?? `image-${Date.now()}.jpg`,
        mimeType: a.mimeType ?? 'image/jpeg',
      })),
    ]);
  };

  const pickModel = async (value: string) => {
    setModel(value);
    setModelModal(false);
    if (sessionId && provider) {
      try {
        await api.put(`/providers/${provider}/sessions/${sessionId}/active-model`, { model: value });
      } catch (err) {
        console.error('set model failed:', err);
      }
    }
  };

  useEffect(
    () =>
      subscribe((event) => {
        if (!event || !sessionId) return;
        // `queued-messages-updated` is handled by QueueBar; reconnect marker
        // uses `kind` (same field as server frames).
        if (event.kind === 'websocket_reconnected') {
          load();
          setQueueKey((k) => k + 1);
          return;
        }
        if (event.sessionId !== sessionId) return;

        const finalizeStreams = () => {
          setRunning(false);
          setMessages((prev) => prev.map((m) => (m.isStreaming ? { ...m, isStreaming: false } : m)));
        };

        switch (event.kind) {
          case 'stream_delta':
          case 'thought_delta': {
            const delta = typeof event.content === 'string' ? event.content : '';
            if (!delta) return;
            setRunning(true);
            const role = event.kind === 'thought_delta' ? 'thinking' : 'assistant';
            setMessages((prev) => {
              const last = prev[prev.length - 1];
              if (last?.isStreaming && last.role === role) {
                const copy = [...prev];
                copy[copy.length - 1] = { ...last, text: last.text + delta };
                return copy;
              }
              return [...prev, { id: `live-${role}-${liveSeq.current++}`, role, text: delta, tools: [], isStreaming: true }];
            });
            return;
          }
          case 'stream_replace': {
            const text = typeof event.content === 'string' ? event.content : '';
            setMessages((prev) => {
              const idx = prev.findLastIndex((m) => m.isStreaming && m.role === 'assistant');
              if (idx < 0) return prev;
              const copy = [...prev];
              copy[idx] = { ...copy[idx], text };
              return copy;
            });
            return;
          }
          case 'stream_end':
            finalizeStreams();
            return;
          case 'permission_request': {
            const requestId = event.requestId;
            if (typeof requestId !== 'string' || !requestId) return;
            void Haptics.notificationAsync(Haptics.NotificationFeedbackType.Warning);
            setPendingPermissions((prev) =>
              prev.some((r) => r.requestId === requestId)
                ? prev
                : [...prev, { requestId, toolName: String(event.toolName ?? 'UnknownTool'), input: event.input }],
            );
            return;
          }
          case 'permission_cancelled': {
            const requestId = event.requestId;
            if (typeof requestId === 'string') {
              setPendingPermissions((prev) => prev.filter((r) => r.requestId !== requestId));
            }
            return;
          }
          case 'complete':
          case 'session_upserted':
            finalizeStreams();
            load();
            setQueueKey((k) => k + 1);
            return;
          case 'tool_use':
          case 'tool_result':
          case 'text': {
            // Live non-stream items: merge tool_result into its tool_use row,
            // otherwise append — matches the load() normalization.
            setRunning(true);
            const p = parseItem(event);
            if (p.skip) return;
            if (event.kind === 'tool_result' && p.tools[0]) {
              const toolId = String(event.toolId ?? '');
              setMessages((prev) => {
                const idx = prev.findLastIndex((x) => x.tools.some((t) => t.id === toolId));
                if (idx < 0) return prev;
                const copy = [...prev];
                const tools = copy[idx].tools.map((t) =>
                  t.id === toolId
                    ? { ...t, status: event.isError ? 'error' : 'done', detail: [t.detail, p.tools[0].detail].filter(Boolean).join('\n→ ') }
                    : t,
                );
                copy[idx] = { ...copy[idx], tools };
                return copy;
              });
              return;
            }
            setMessages((prev) => [
              ...prev,
              {
                id: `live-${event.kind}-${liveSeq.current++}`,
                role: p.role,
                text: p.text,
                tools: p.tools,
                timestamp: event.timestamp,
              },
            ]);
            return;
          }
          default:
            return;
        }
      }),
    [subscribe, sessionId, load],
  );

  const handlePermissionDecision = useCallback(
    (ids: string[], decision: { allow: boolean; message?: string }) => {
      for (const requestId of ids) {
        sendMessage({
          type: 'chat.permission-response',
          requestId,
          allow: decision.allow,
          message: decision.message,
        });
      }
      setPendingPermissions((prev) => prev.filter((r) => !ids.includes(r.requestId)));
    },
    [sendMessage],
  );

  const send = async () => {
    const content = draft.trim();
    if (!content || sending) return;
    void Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    setSending(true);
    setDraft('');
    try {
      // Slash command dispatch — matches /api/commands/execute on web.
      const slash = content.match(/^\/(\S+)\s*(.*)$/);
      const cmd = slash && slashCommands.find((c) => c.name === `/${slash[1]}` || c.name === slash[1]);
      if (cmd && sessionId) {
        await api.post('/commands/execute', {
          commandName: cmd.name,
          commandPath: cmd.path,
          args: slash![2] ? slash![2].trim().split(/\s+/) : [],
          context: { projectPath, sessionId, provider, model },
        });
        setQueueKey((k) => k + 1);
        return;
      }
      if (newSession && !sessionId) {
        // Draft mode: server creates the session and kicks off the turn from
        // initialMessage; then we bind this screen to the returned id so the
        // subscribe effect picks up deltas.
        const res = await api.post('/providers/sessions', {
          provider: provider ?? 'claude',
          projectPath,
          initialMessage: content,
        });
        if (!res.ok) throw new Error(`create session failed (${res.status})`);
        const body = await res.json();
        const newId = body?.data?.sessionId;
        if (!newId) throw new Error('create session returned no id');
        navigation.setParams({
          sessionId: newId,
          newSession: undefined,
          title: body?.data?.sessionName || content.slice(0, 50),
        });
        setMessages([{ id: `local-${Date.now()}`, role: 'user', text: content, tools: [], timestamp: Date.now() }]);
      } else {
        // Upload pending attachments first — the returned descriptors ride
        // along in options.attachments, same as the web composer.
        let attachments: unknown[] = [];
        if (pendingAttachments.length > 0) {
          const form = new FormData();
          for (const a of pendingAttachments) {
            form.append('files', { uri: a.uri, name: a.name, type: a.mimeType } as never);
          }
          const up = await api.post('/assets/files', form);
          if (!up.ok) throw new Error(`upload failed (${up.status})`);
          const upBody = await up.json();
          attachments = Array.isArray(upBody?.attachments) ? upBody.attachments : [];
          setPendingAttachments([]);
        }
        setMessages((prev) => [...prev, { id: `local-${Date.now()}`, role: 'user', text: content, tools: [], timestamp: Date.now() }]);
        await api.queue.enqueue(sessionId, {
          content,
          options: { permissionMode, ...(model ? { model } : {}), attachments },
        });
      }
      setQueueKey((k) => k + 1);
    } catch (err) {
      console.error('send failed:', err);
      Alert.alert('Send failed', err instanceof Error ? err.message : String(err));
    } finally {
      setSending(false);
    }
  };

  const renderMessage = ({ item }: { item: ChatMessage }) => {
    const isUser = item.role === 'user';
    if (item.role === 'thinking') {
      return (
        <View style={{ marginBottom: 8, opacity: 0.6 }}>
          <Text style={{ color: colors.mutedForeground, fontStyle: 'italic', fontSize: 13 }} numberOfLines={3}>
            {item.text}
          </Text>
        </View>
      );
    }
    const messageActions = () => {
      const text = item.text.trim();
      if (!text) return;
      Alert.alert('Message', undefined, [
        { text: 'Copy', onPress: () => void Clipboard.setStringAsync(text) },
        { text: 'Share', onPress: () => void Share.share({ message: text }) },
        { text: 'Cancel', style: 'cancel' },
      ]);
    };
    return (
      <TouchableOpacity
        activeOpacity={0.9}
        onLongPress={messageActions}
        style={{
          alignSelf: isUser ? 'flex-end' : 'stretch',
          maxWidth: isUser ? '85%' : '100%',
          backgroundColor: isUser ? colors.primary : 'transparent',
          borderRadius: 12,
          paddingHorizontal: isUser ? 12 : 4,
          paddingVertical: 8,
          marginBottom: 8,
        }}
      >
        {item.tools.map((t) => (
          <ToolRow key={t.id} tool={t} colors={colors} />
        ))}
        {item.text.trim().length > 0 &&
          (isUser ? (
            <Text style={{ color: colors.primaryForeground }}>{item.text}</Text>
          ) : (
            <Markdown
              rules={markdownRules(colors) as any}
              style={{
                body: { color: colors.foreground, fontSize: 15 },
                code_inline: { backgroundColor: colors.muted, color: colors.foreground, borderRadius: 4 },
                code_block: { backgroundColor: colors.card, color: colors.foreground, borderRadius: 8, padding: 10, borderWidth: 1, borderColor: colors.border },
                fence: { backgroundColor: colors.card, color: colors.foreground, borderRadius: 8, padding: 10, borderWidth: 1, borderColor: colors.border },
                link: { color: colors.primary },
                heading1: { color: colors.foreground },
                heading2: { color: colors.foreground },
                heading3: { color: colors.foreground },
                blockquote: { backgroundColor: colors.muted, borderLeftColor: colors.border, paddingHorizontal: 10 },
                list_item: { color: colors.foreground },
              }}
            >
              {item.text}
            </Markdown>
          ))}
        {item.isStreaming && <ActivityIndicator size="small" color={colors.primary} style={{ marginTop: 4, alignSelf: 'flex-start' }} />}
      </TouchableOpacity>
    );
  };

  return (
    <KeyboardAvoidingView
      style={{ flex: 1, backgroundColor: colors.background }}
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}
      keyboardVerticalOffset={Platform.OS === 'ios' ? 90 : 0}
    >
      {loading ? (
        <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
          <ActivityIndicator color={colors.primary} size="large" />
        </View>
      ) : (
        <FlatList
          ref={listRef}
          data={messages}
          keyExtractor={(item) => item.id}
          renderItem={renderMessage}
          contentContainerStyle={{ padding: 12, paddingBottom: 8 }}
          onContentSizeChange={() => listRef.current?.scrollToEnd({ animated: false })}
          ListHeaderComponent={
            hasMore ? (
              <TouchableOpacity onPress={loadOlder} disabled={loadingOlder} style={{ alignSelf: 'center', paddingVertical: 8, paddingHorizontal: 16, marginBottom: 8, backgroundColor: colors.card, borderRadius: 8, borderWidth: 1, borderColor: colors.border }}>
                {loadingOlder ? <ActivityIndicator size="small" color={colors.primary} /> : <Text style={{ color: colors.primary, fontSize: 13 }}>Load older messages</Text>}
              </TouchableOpacity>
            ) : null
          }
          ListEmptyComponent={
            <Text style={{ color: colors.mutedForeground, textAlign: 'center', marginTop: 48 }}>
              No messages yet — send the first one
            </Text>
          }
        />
      )}
      <PermissionBanner requests={pendingPermissions} colors={colors} onDecision={handlePermissionDecision} />
      <QueueBar sessionId={sessionId} colors={colors} reloadKey={queueKey} />
      {(() => {
        const m = draft.match(/@([\w./-]*)$/);
        if (!m || mentionFiles.length === 0) return null;
        const q = m[1].toLowerCase();
        const matches = mentionFiles.filter((p) => p.toLowerCase().includes(q)).slice(0, 8);
        if (matches.length === 0) return null;
        return (
          <View style={{ backgroundColor: colors.card, borderTopWidth: 1, borderTopColor: colors.border, maxHeight: 200 }}>
            <FlatList
              keyboardShouldPersistTaps="handled"
              data={matches}
              keyExtractor={(p) => p}
              renderItem={({ item: p }) => (
                <TouchableOpacity
                  onPress={() => setDraft((d) => d.replace(/@[\w./-]*$/, `@${p} `))}
                  style={{ paddingVertical: 10, paddingHorizontal: 14, borderBottomWidth: 1, borderBottomColor: colors.border }}
                >
                  <Text style={{ color: colors.foreground, fontSize: 13 }} numberOfLines={1}>{p}</Text>
                </TouchableOpacity>
              )}
            />
          </View>
        );
      })()}
      {draft.startsWith('/') && slashCommands.length > 0 && (
        <View style={{ backgroundColor: colors.card, borderTopWidth: 1, borderTopColor: colors.border, maxHeight: 200 }}>
          <FlatList
            keyboardShouldPersistTaps="handled"
            data={slashCommands.filter((c) => c.name.replace(/^\//, '').startsWith(draft.slice(1).split(/\s/)[0]))}
            keyExtractor={(c) => c.name}
            renderItem={({ item: c }) => (
              <TouchableOpacity
                onPress={() => setDraft(c.name.startsWith('/') ? `${c.name} ` : `/${c.name} `)}
                style={{ paddingVertical: 10, paddingHorizontal: 14, borderBottomWidth: 1, borderBottomColor: colors.border }}
              >
                <Text style={{ color: colors.primary, fontWeight: '500', fontSize: 13 }}>
                  {c.name.startsWith('/') ? c.name : `/${c.name}`}
                </Text>
                {!!c.description && (
                  <Text style={{ color: colors.mutedForeground, fontSize: 12, marginTop: 2 }} numberOfLines={1}>
                    {c.description}
                  </Text>
                )}
              </TouchableOpacity>
            )}
          />
        </View>
      )}
      <View style={{ flexDirection: 'row', gap: 8, paddingHorizontal: 10, paddingTop: 8, backgroundColor: colors.card, borderTopWidth: 1, borderTopColor: colors.border }}>
        {models.length > 0 && (
          <TouchableOpacity
            onPress={() => setModelModal(true)}
            style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: colors.secondary, borderRadius: 12, paddingHorizontal: 10, paddingVertical: 4 }}
          >
            <Text style={{ color: colors.secondaryForeground, fontSize: 12 }}>{models.find((m) => m.value === model)?.label ?? model ?? 'Model'}</Text>
            <ChevronDown size={12} color={colors.secondaryForeground} />
          </TouchableOpacity>
        )}
        <TouchableOpacity
          onPress={() => {
            const order = ['default', 'acceptEdits', 'plan', 'bypassPermissions'] as const;
            setPermissionMode((m) => order[(order.indexOf(m) + 1) % order.length]);
          }}
          style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: permissionMode === 'default' ? colors.secondary : colors.primary, borderRadius: 12, paddingHorizontal: 10, paddingVertical: 4 }}
        >
          <Text style={{ color: permissionMode === 'default' ? colors.secondaryForeground : colors.primaryForeground, fontSize: 12 }}>
            {permissionMode}
          </Text>
        </TouchableOpacity>
        {running && (
          <TouchableOpacity
            onPress={() => sessionId && sendMessage({ type: 'chat.abort', sessionId })}
            style={{ marginLeft: 'auto', flexDirection: 'row', alignItems: 'center', backgroundColor: colors.destructive, borderRadius: 12, paddingHorizontal: 10, paddingVertical: 4 }}
          >
            <Square size={11} color="#fff" fill="#fff" />
            <Text style={{ color: '#fff', fontSize: 12, marginLeft: 4 }}>Stop</Text>
          </TouchableOpacity>
        )}
      </View>
      {pendingAttachments.length > 0 && (
        <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 6, paddingHorizontal: 10, paddingTop: 6, backgroundColor: colors.card }}>
          {pendingAttachments.map((a, i) => (
            <View key={`${a.uri}-${i}`} style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: colors.secondary, borderRadius: 8, paddingHorizontal: 8, paddingVertical: 4 }}>
              <Text style={{ color: colors.secondaryForeground, fontSize: 11 }} numberOfLines={1}>{a.name}</Text>
              <TouchableOpacity onPress={() => setPendingAttachments((prev) => prev.filter((_, j) => j !== i))} hitSlop={6} style={{ marginLeft: 4 }}>
                <X size={12} color={colors.secondaryForeground} />
              </TouchableOpacity>
            </View>
          ))}
        </View>
      )}
      <View
        style={{
          flexDirection: 'row',
          alignItems: 'flex-end',
          padding: 10,
          gap: 8,
          backgroundColor: colors.card,
        }}
      >
        <TouchableOpacity onPress={() => void pickImage()} style={{ padding: 10 }} hitSlop={6}>
          <Paperclip color={colors.mutedForeground} size={18} />
        </TouchableOpacity>
        <TextInput
          value={draft}
          onChangeText={setDraft}
          placeholder={isConnected ? 'Message…' : 'Reconnecting…'}
          placeholderTextColor={colors.mutedForeground}
          multiline
          style={{
            flex: 1,
            backgroundColor: colors.background,
            color: colors.foreground,
            borderColor: colors.border,
            borderWidth: 1,
            borderRadius: 10,
            paddingHorizontal: 12,
            paddingTop: 10,
            paddingBottom: 10,
            maxHeight: 120,
          }}
        />
        <TouchableOpacity
          onPress={send}
          disabled={!draft.trim() || sending}
          style={{ backgroundColor: colors.primary, borderRadius: 10, padding: 12, opacity: !draft.trim() || sending ? 0.5 : 1 }}
        >
          <Send color={colors.primaryForeground} size={18} />
        </TouchableOpacity>
      </View>
      <Modal visible={modelModal} transparent animationType="fade" onRequestClose={() => setModelModal(false)}>
        <TouchableOpacity style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', padding: 24 }} activeOpacity={1} onPress={() => setModelModal(false)}>
          <View style={{ backgroundColor: colors.card, borderRadius: 12, padding: 8, maxHeight: 400 }}>
            <Text style={{ color: colors.foreground, fontWeight: '600', padding: 12 }}>Model</Text>
            <FlatList
              data={models}
              keyExtractor={(m) => m.value}
              renderItem={({ item: m }) => (
                <TouchableOpacity
                  onPress={() => void pickModel(m.value)}
                  style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 10, paddingHorizontal: 12, borderRadius: 8, backgroundColor: m.value === model ? colors.secondary : 'transparent' }}
                >
                  <Text style={{ flex: 1, color: colors.foreground, fontSize: 14 }}>{m.label}</Text>
                  {m.value === model && <Check size={16} color={colors.primary} />}
                </TouchableOpacity>
              )}
            />
          </View>
        </TouchableOpacity>
      </Modal>
    </KeyboardAvoidingView>
  );
}
