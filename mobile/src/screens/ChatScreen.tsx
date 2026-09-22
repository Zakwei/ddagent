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
import { Send } from 'lucide-react-native';
import { api } from '~shared/utils/api';
import { useTheme } from '../theme';
import { useWebSocket } from '../contexts/WebSocketContext';

interface ChatMessage {
  id: string;
  role: 'user' | 'assistant' | 'system' | string;
  text: string;
  timestamp?: number;
  isStreaming?: boolean;
}

/** Best-effort text extraction from a unified-session message payload. */
const extractText = (m: any): string => {
  if (!m) return '';
  if (typeof m.text === 'string') return m.text;
  if (typeof m.content === 'string') return m.content;
  const parts = m.content ?? m.message?.content ?? m.parts;
  if (Array.isArray(parts)) {
    return parts
      .map((p: any) => (typeof p === 'string' ? p : p?.text ?? ''))
      .filter(Boolean)
      .join('\n');
  }
  return '';
};

const extractRole = (m: any): string => m?.role ?? m?.message?.role ?? m?.type ?? 'assistant';

export default function ChatScreen() {
  const { colors } = useTheme();
  const route = useRoute<any>();
  const { sessionId } = route.params;
  const { subscribe, isConnected } = useWebSocket();
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [loading, setLoading] = useState(true);
  const [draft, setDraft] = useState('');
  const [sending, setSending] = useState(false);
  const listRef = useRef<FlatList<ChatMessage>>(null);

  const load = useCallback(async () => {
    try {
      const res = await api.unifiedSessionMessages(sessionId, 'claude', { limit: 100 } as never);
      if (res.ok) {
        const data = await res.json();
        const raw = Array.isArray(data) ? data : data?.messages ?? [];
        setMessages(
          raw.map((m: any, i: number) => ({
            id: String(m.id ?? m.uuid ?? i),
            role: extractRole(m),
            text: extractText(m),
            timestamp: m.timestamp ?? m.createdAt,
          })).filter((m: ChatMessage) => m.text.trim().length > 0),
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

  // Live stream: append streamed text for this session.
  useEffect(
    () =>
      subscribe((event) => {
        if (!event || event.sessionId !== sessionId) return;
        if (event.type === 'session_upserted' || event.type === 'websocket_reconnected') {
          load();
          return;
        }
        // Streamed deltas come in several shapes across providers; append any
        // text-bearing payload for this session.
        const delta = event.delta?.text ?? event.text ?? extractText(event.message ?? event.data);
        if (typeof delta === 'string' && delta.length > 0) {
          setMessages((prev) => {
            const last = prev[prev.length - 1];
            if (last?.isStreaming) {
              const copy = [...prev];
              copy[copy.length - 1] = { ...last, text: last.text + delta };
              return copy;
            }
            return [
              ...prev,
              { id: `live-${Date.now()}`, role: 'assistant', text: delta, isStreaming: true },
            ];
          });
        }
        if (event.type === 'turn_complete' || event.type === 'message_complete') {
          setMessages((prev) =>
            prev.map((m) => (m.isStreaming ? { ...m, isStreaming: false } : m)),
          );
          load();
        }
      }),
    [subscribe, sessionId, load],
  );

  const send = async () => {
    const content = draft.trim();
    if (!content || sending) return;
    setSending(true);
    setDraft('');
    setMessages((prev) => [
      ...prev,
      { id: `local-${Date.now()}`, role: 'user', text: content, timestamp: Date.now() },
    ]);
    try {
      await api.queue.enqueue(sessionId, { content });
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
        {isUser ? (
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
        )}
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
