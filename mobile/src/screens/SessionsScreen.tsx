import React, { useCallback, useEffect, useState } from 'react';
import {
  ActivityIndicator,
  Alert,
  FlatList,
  Modal,
  RefreshControl,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import { useNavigation, useRoute } from '@react-navigation/native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { MessageSquare, TerminalSquare, Plus, Archive } from 'lucide-react-native';
import { api } from '~shared/utils/api';
import { useTheme } from '../theme';
import { useWebSocket } from '../contexts/WebSocketContext';
import { ActionSheet, ActionSheetItem } from '../components/ActionSheet';

interface Session {
  id: string;
  summary?: string;
  title?: string;
  status?: string;
  projectId?: string;
  projectPath?: string;
  isRunning?: boolean;
  updatedAt?: string;
  provider?: string;
  messageCount?: number;
  lastViewedAt?: string | null;
}

export default function SessionsScreen() {
  const { colors } = useTheme();
  const insets = useSafeAreaInsets();
  const navigation = useNavigation<any>();
  const route = useRoute<any>();
  const { projectId, projectPath } = route.params;
  const { subscribe } = useWebSocket();
  const [sessions, setSessions] = useState<Session[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [renameTarget, setRenameTarget] = useState<Session | null>(null);
  const [renameText, setRenameText] = useState('');
  const [showArchived, setShowArchived] = useState(false);
  const [providerPicker, setProviderPicker] = useState<string[] | null>(null);
  const [sheet, setSheet] = useState<{ title?: string; items: ActionSheetItem[] } | null>(null);

  const openNewSession = useCallback(
    (provider: string) => {
      setProviderPicker(null);
      navigation.navigate('Chat', { newSession: true, projectPath, projectId, provider });
    },
    [navigation, projectPath, projectId],
  );

  const startNewSession = useCallback(async () => {
    const fallback = sessions[0]?.provider ?? 'claude';
    try {
      const res = await api.get('/providers/capabilities');
      const body = await res.json().catch(() => null);
      const list: string[] = (body?.data?.providers ?? [])
        .map((p: { provider?: string }) => p.provider)
        .filter((p: string | undefined): p is string => Boolean(p));
      if (list.length === 0) return openNewSession(fallback);
      if (list.length === 1) return openNewSession(list[0]);
      setProviderPicker(list);
    } catch {
      openNewSession(fallback);
    }
  }, [sessions, openNewSession]);

  useEffect(() => {
    navigation.setOptions({
      headerRight: () => (
        <View style={{ flexDirection: 'row', gap: 14 }}>
          <TouchableOpacity onPress={() => setShowArchived((v) => !v)} hitSlop={8}>
            <Archive size={20} color={showArchived ? colors.primary : colors.mutedForeground} />
          </TouchableOpacity>
          <TouchableOpacity onPress={() => void startNewSession()} hitSlop={8}>
            <Plus size={22} color={colors.primary} />
          </TouchableOpacity>
        </View>
      ),
    });
  }, [navigation, colors, showArchived, projectPath, projectId, sessions, startNewSession]);

  const load = useCallback(async () => {
    try {
      if (showArchived) {
        const res = await api.getArchivedSessions();
        if (res.ok) {
          const data = await res.json();
          const all: Session[] = Array.isArray(data) ? data : data?.sessions ?? [];
          // The endpoint is global — scope the list back to this project or
          // every project's archived sessions pile into this view.
          setSessions(all.filter((s) => !s.projectId || s.projectId === projectId || s.projectPath === projectPath));
        }
      } else {
        const res = await api.projectSessions(projectId, { limit: 50 });
        if (res.ok) {
          const data = await res.json();
          setSessions(Array.isArray(data) ? data : data?.sessions ?? []);
        }
      }
    } catch (err) {
      console.error('sessions load failed:', err);
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  }, [projectId, projectPath, showArchived]);

  useEffect(() => {
    load();
  }, [load]);

  useEffect(
    () =>
      subscribe((event) => {
        if (event?.kind === 'session_upserted' || event?.kind === 'websocket_reconnected') load();
      }),
    [subscribe, load],
  );

  const sessionActions = (s: Session) => {
    const title = s.summary || s.title || 'Session';
    if (showArchived) {
      setSheet({
        title,
        items: [
          { label: 'Restore', onPress: () => api.restoreSession(s.id).then(load).catch(() => {}) },
          { label: 'Delete permanently', destructive: true, onPress: () => api.deleteSession(s.id, true).then(load).catch(() => {}) },
        ],
      });
      return;
    }
    setSheet({
      title,
      items: [
        {
          label: 'Rename',
          onPress: () => {
            setRenameText(s.summary || s.title || '');
            setRenameTarget(s);
          },
        },
        {
          label: 'Archive',
          onPress: () =>
            api.deleteSession(s.id).then(load).catch(() => {}),
        },
        {
          label: 'Delete permanently',
          destructive: true,
          onPress: () =>
            Alert.alert('Delete session?', 'Removes the session and its transcript.', [
              { text: 'Cancel', style: 'cancel' },
              {
                text: 'Delete',
                style: 'destructive',
                onPress: () => api.deleteSession(s.id, true).then(load).catch(() => {}),
              },
            ]),
        },
      ],
    });
  };

  const submitRename = async () => {
    const target = renameTarget;
    const summary = renameText.trim();
    setRenameTarget(null);
    if (!target || !summary) return;
    setSessions((prev) => prev.map((s) => (s.id === target.id ? { ...s, summary } : s)));
    try {
      await api.renameSession(target.id, summary);
    } catch {
      load();
    }
  };

  if (loading) {
    return (
      <View style={{ flex: 1, backgroundColor: colors.background, alignItems: 'center', justifyContent: 'center' }}>
        <ActivityIndicator color={colors.primary} size="large" />
      </View>
    );
  }

  return (
    <View style={{ flex: 1, backgroundColor: colors.background }}>
      <FlatList
        data={sessions}
        keyExtractor={(item) => String(item.id)}
        refreshControl={<RefreshControl refreshing={refreshing} onRefresh={() => { setRefreshing(true); load(); }} tintColor={colors.primary} />}
        contentContainerStyle={{ padding: 12, paddingBottom: 12 + insets.bottom }}
        ListEmptyComponent={
          <Text style={{ color: colors.mutedForeground, textAlign: 'center', marginTop: 48 }}>No sessions</Text>
        }
        renderItem={({ item }) => (
          <TouchableOpacity
            onPress={() => navigation.navigate('Chat', { sessionId: item.id, title: item.summary || item.title, provider: item.provider })}
            onLongPress={() => sessionActions(item)}
            style={{ backgroundColor: colors.card, borderColor: colors.border, borderWidth: 1, borderRadius: 10, padding: 14, marginBottom: 8 }}
          >
            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
              <MessageSquare color={colors.mutedForeground} size={18} />
              <View style={{ flex: 1, marginLeft: 10 }}>
                <Text style={{ color: colors.foreground, fontWeight: '500' }} numberOfLines={2}>
                  {item.summary || item.title || `Session ${item.id}`}
                </Text>
                <Text style={{ color: colors.mutedForeground, fontSize: 11, marginTop: 2 }} numberOfLines={1}>
                  {[item.provider, item.updatedAt ? new Date(item.updatedAt).toLocaleString() : null].filter(Boolean).join(' · ')}
                </Text>
              </View>
              {!!item.messageCount && (
                <Text style={{ color: colors.mutedForeground, fontSize: 11, marginLeft: 6 }}>{item.messageCount}</Text>
              )}
              {item.isRunning && <View style={{ width: 8, height: 8, borderRadius: 4, backgroundColor: colors.primary, marginLeft: 8 }} />}
            </View>
            <View style={{ flexDirection: 'row', marginTop: 10, gap: 10 }}>
              <TouchableOpacity
                onPress={() => navigation.navigate('Chat', { sessionId: item.id, title: item.summary || item.title, provider: item.provider })}
                style={{ backgroundColor: colors.secondary, borderRadius: 6, paddingHorizontal: 12, paddingVertical: 6, flexDirection: 'row', alignItems: 'center' }}
              >
                <MessageSquare color={colors.secondaryForeground} size={14} />
                <Text style={{ color: colors.secondaryForeground, fontSize: 12, marginLeft: 6 }}>Chat</Text>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={() => navigation.navigate('Terminal', { sessionId: item.id })}
                style={{ backgroundColor: colors.secondary, borderRadius: 6, paddingHorizontal: 12, paddingVertical: 6, flexDirection: 'row', alignItems: 'center' }}
              >
                <TerminalSquare color={colors.secondaryForeground} size={14} />
                <Text style={{ color: colors.secondaryForeground, fontSize: 12, marginLeft: 6 }}>Terminal</Text>
              </TouchableOpacity>
            </View>
          </TouchableOpacity>
        )}
      />

      <ActionSheet visible={sheet !== null} title={sheet?.title} items={sheet?.items ?? []} onClose={() => setSheet(null)} />
      <Modal visible={!!renameTarget} transparent animationType="fade" onRequestClose={() => setRenameTarget(null)}>
        <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', alignItems: 'center', justifyContent: 'center', padding: 24 }}>
          <View style={{ backgroundColor: colors.card, borderRadius: 12, padding: 20, width: '100%' }}>
            <Text style={{ color: colors.foreground, fontWeight: '600', marginBottom: 12 }}>Rename session</Text>
            <TextInput
              value={renameText}
              onChangeText={setRenameText}
              autoFocus
              style={{ backgroundColor: colors.background, color: colors.foreground, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10, marginBottom: 16 }}
            />
            <View style={{ flexDirection: 'row', justifyContent: 'flex-end', gap: 12 }}>
              <TouchableOpacity onPress={() => setRenameTarget(null)}>
                <Text style={{ color: colors.mutedForeground, padding: 8 }}>Cancel</Text>
              </TouchableOpacity>
              <TouchableOpacity onPress={submitRename}>
                <Text style={{ color: colors.primary, fontWeight: '600', padding: 8 }}>Save</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>

      {/* Provider choice for a new session — the web app prompts the same
          way; capabilities come from GET /api/providers/capabilities. */}
      <Modal visible={!!providerPicker} transparent animationType="fade" onRequestClose={() => setProviderPicker(null)}>
        <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', alignItems: 'center', justifyContent: 'center', padding: 24 }}>
          <View style={{ backgroundColor: colors.card, borderRadius: 12, padding: 20, width: '100%' }}>
            <Text style={{ color: colors.foreground, fontWeight: '600', marginBottom: 12 }}>New session — provider</Text>
            {(providerPicker ?? []).map((p) => (
              <TouchableOpacity
                key={p}
                onPress={() => openNewSession(p)}
                style={{ paddingVertical: 12, borderBottomWidth: 1, borderBottomColor: colors.border }}
              >
                <Text style={{ color: colors.foreground, fontSize: 15 }}>{p}</Text>
              </TouchableOpacity>
            ))}
            <TouchableOpacity onPress={() => setProviderPicker(null)} style={{ alignSelf: 'flex-end', marginTop: 12 }}>
              <Text style={{ color: colors.mutedForeground, padding: 8 }}>Cancel</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Modal>
    </View>
  );
}
