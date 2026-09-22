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

interface ToolCall {
  id: string;
  name: string;
  status?: string;
  detail?: string;
}

interface ChatMessage {
  id: string;
  role: 'user' | 'assistant' | 'system' | string;
  text: string;
  tools: ToolCall[];
  timestamp?: number;
  isStreaming?: boolean;
}

interface QueuedItem {
  id: string;
  content?: string;
}

/** Extracts text + tool calls from a unified-session message payload. */
const parseMessage = (m: any): { text: string; tools: ToolCall[] } => {
  const tools: ToolCall[] = [];
  let text = '';
  const parts = m?.content ?? m?.message?.content ?? m?.parts;
  if (typeof m?.text === 'string') text = m.text;
  else if (typeof m?.content === 'string') text = m.content;
  else if (Array.isArray(parts)) {
    const texts: string[] = [];
    for (const p of parts) {
      if (typeof p === 'string') texts.push(p);
      else if (p?.type === 'text' || typeof p?.text === 'string') texts.push(p.text ?? '');
      else if (p?.type === 'tool_use' || p?.type === 'tool_result' || p?.name) {
        tools.push({
          id: String(p.id ?? `tool-${tools.length}`),
          name: p.name ?? p.tool_name ?? p.type ?? 'tool',
          status: p.type === 'tool_result' ? 'done' : p.status,
          detail: typeof p.input === 'object' ? JSON.stringify(p.input).slice(0, 400) : undefined,
        });
      }
    }
    text = texts.filter(Boolean).join('\n');
  }
  return { text, tools };
};

const extractRole = (m: any): string => m?.role ?? m?.message?.role ?? m?.type ?? 'assistant';

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

  const load = useCallback(async () => {
    try {
      const res = await api.queue.list(sessionId);
      if (res.ok) {
        const data = await res.json();
        setItems(Array.isArray(data) ? data : data?.items ?? []);
      }
    } catch {
      /* queue endpoint optional */
    }
  }, [sessionId]);

  useEffect(() => {
    load();
  }, [load, reloadKey]);

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
  const { subscribe, isConnected } = useWebSocket();
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
        const raw = Array.isArray(data) ? data : data?.messages ?? [];
        setMessages(
          raw
            .map((m: any, i: number) => {
              const { text, tools } = parseMessage(m);
              return {
                id: String(m.id ?? m.uuid ?? i),
                role: extractRole(m),
                text,
                tools,
                timestamp: m.timestamp ?? m.createdAt,
              };
            })
            .filter((m: ChatMessage) => m.text.trim().length > 0 || m.tools.length > 0),
        );
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

  useEffect(
    () =>
      subscribe((event) => {
        if (!event) return;
        if (event.type === 'websocket_reconnected') {
          load();
          setQueueKey((k) => k + 1);
          return;
        }
        if (event.sessionId !== sessionId) return;
        if (event.type === 'session_upserted' || event.type === 'turn_complete' || event.type === 'message_complete') {
          setMessages((prev) => prev.map((m) => (m.isStreaming ? { ...m, isStreaming: false } : m)));
          load();
          setQueueKey((k) => k + 1);
          return;
        }
        const delta = event.delta?.text ?? event.text ?? '';
        if (typeof delta === 'string' && delta.length > 0) {
          setMessages((prev) => {
            const last = prev[prev.length - 1];
            if (last?.isStreaming && last.role === 'assistant') {
              const copy = [...prev];
              copy[copy.length - 1] = { ...last, text: last.text + delta };
              return copy;
            }
            return [...prev, { id: `live-${Date.now()}`, role: 'assistant', text: delta, tools: [], isStreaming: true }];
          });
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
