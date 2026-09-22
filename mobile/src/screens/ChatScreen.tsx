import React, { useCallback, useEffect, useRef, useState } from 'react';
import {
  ActivityIndicator,
  FlatList,
  KeyboardAvoidingView,
  Platform,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import { useRoute } from '@react-navigation/native';
import Markdown from 'react-native-markdown-display';
import { Send, Wrench, ChevronDown, ChevronRight, Zap, X } from 'lucide-react-native';
import { api } from '~shared/utils/api';
import { useTheme } from '../theme';
import { useWebSocket } from '../contexts/WebSocketContext';
import { ChatMessage, ToolCall, messagesFromResponse, parseItem } from '../lib/chat-messages';

interface QueuedItem {
  id: string;
  content?: string;
}

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

function QueueBar({ sessionId, colors, reloadKey }: { sessionId: string; colors: any; reloadKey: number }) {
  const [items, setItems] = useState<QueuedItem[]>([]);
  const { subscribe } = useWebSocket();

  const load = useCallback(async () => {
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
      {items.map((q) => (
        <View key={q.id} style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 4 }}>
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
  const { sessionId } = route.params;
  const { subscribe, sendMessage, isConnected } = useWebSocket();
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [loading, setLoading] = useState(true);
  const [draft, setDraft] = useState('');
  const [sending, setSending] = useState(false);
  const [queueKey, setQueueKey] = useState(0);
  const listRef = useRef<FlatList<ChatMessage>>(null);

  const load = useCallback(async () => {
    try {
      const res = await api.unifiedSessionMessages(sessionId, 'claude', { limit: 100 } as never);
      if (res.ok) {
        const data = await res.json();
        const raw = messagesFromResponse(data);
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
            id: String(m.id ?? m.uuid ?? msgs.length),
            role: p.role,
            text: p.text,
            tools: p.tools,
            timestamp: m.timestamp ?? m.createdAt,
          });
        }
        setMessages(msgs);
      }
    } catch (err) {
      console.error('messages load failed:', err);
    } finally {
      setLoading(false);
    }
  }, [sessionId]);

  useEffect(() => {
    load();
  }, [load]);

  // Deltas only flow after a per-session chat.subscribe — send it whenever the
  // socket (re)connects, mirroring useChatSessionState on web.
  useEffect(() => {
    if (!isConnected) return;
    sendMessage({ type: 'chat.subscribe', sessions: [{ sessionId, lastSeq: 0 }] });
  }, [isConnected, sendMessage, sessionId]);

  useEffect(
    () =>
      subscribe((event) => {
        if (!event) return;
        // `queued-messages-updated` is handled by QueueBar; reconnect marker
        // uses `kind` (same field as server frames).
        if (event.kind === 'websocket_reconnected') {
          load();
          setQueueKey((k) => k + 1);
          return;
        }
        if (event.sessionId !== sessionId) return;

        const finalizeStreams = () =>
          setMessages((prev) => prev.map((m) => (m.isStreaming ? { ...m, isStreaming: false } : m)));

        switch (event.kind) {
          case 'stream_delta':
          case 'thought_delta': {
            const delta = typeof event.content === 'string' ? event.content : '';
            if (!delta) return;
            const role = event.kind === 'thought_delta' ? 'thinking' : 'assistant';
            setMessages((prev) => {
              const last = prev[prev.length - 1];
              if (last?.isStreaming && last.role === role) {
                const copy = [...prev];
                copy[copy.length - 1] = { ...last, text: last.text + delta };
                return copy;
              }
              return [...prev, { id: `live-${role}-${sessionId}`, role, text: delta, tools: [], isStreaming: true }];
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
                id: String(event.id ?? `live-${Date.now()}`),
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

  const send = async () => {
    const content = draft.trim();
    if (!content || sending) return;
    setSending(true);
    setDraft('');
    setMessages((prev) => [...prev, { id: `local-${Date.now()}`, role: 'user', text: content, tools: [], timestamp: Date.now() }]);
    try {
      await api.queue.enqueue(sessionId, { content });
      setQueueKey((k) => k + 1);
    } catch (err) {
      console.error('send failed:', err);
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
    return (
      <View
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
      </View>
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
          ListEmptyComponent={
            <Text style={{ color: colors.mutedForeground, textAlign: 'center', marginTop: 48 }}>
              No messages yet — send the first one
            </Text>
          }
        />
      )}
      <QueueBar sessionId={sessionId} colors={colors} reloadKey={queueKey} />
      <View
        style={{
          flexDirection: 'row',
          alignItems: 'flex-end',
          padding: 10,
          gap: 8,
          borderTopWidth: 1,
          borderTopColor: colors.border,
          backgroundColor: colors.card,
        }}
      >
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
    </KeyboardAvoidingView>
  );
}
