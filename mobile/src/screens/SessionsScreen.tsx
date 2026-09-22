import React, { useCallback, useEffect, useState } from 'react';
import { ActivityIndicator, FlatList, RefreshControl, Text, TouchableOpacity, View } from 'react-native';
import { useNavigation, useRoute } from '@react-navigation/native';
import { MessageSquare, TerminalSquare } from 'lucide-react-native';
import { api } from '~shared/utils/api';
import { useTheme } from '../theme';
import { useWebSocket } from '../contexts/WebSocketContext';

interface Session {
  id: string;
  summary?: string;
  title?: string;
  status?: string;
  isRunning?: boolean;
  updatedAt?: string;
  provider?: string;
}

export default function SessionsScreen() {
  const { colors } = useTheme();
  const navigation = useNavigation<any>();
  const route = useRoute<any>();
  const { projectId } = route.params;
  const { subscribe } = useWebSocket();
  const [sessions, setSessions] = useState<Session[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  const load = useCallback(async () => {
    try {
      const res = await api.projectSessions(projectId, { limit: 50 });
      if (res.ok) {
        const data = await res.json();
        setSessions(Array.isArray(data) ? data : data?.sessions ?? []);
      }
    } catch (err) {
      console.error('sessions load failed:', err);
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  }, [projectId]);

  useEffect(() => {
    load();
  }, [load]);

  useEffect(
    () =>
      subscribe((event) => {
        if (event?.type === 'session_upserted' || event?.type === 'websocket_reconnected') load();
      }),
    [subscribe, load],
  );

  if (loading) {
    return (
      <View style={{ flex: 1, backgroundColor: colors.background, alignItems: 'center', justifyContent: 'center' }}>
        <ActivityIndicator color={colors.primary} size="large" />
      </View>
    );
  }

  return (
    <FlatList
      style={{ flex: 1, backgroundColor: colors.background }}
      data={sessions}
      keyExtractor={(item) => String(item.id)}
      refreshControl={<RefreshControl refreshing={refreshing} onRefresh={() => { setRefreshing(true); load(); }} tintColor={colors.primary} />}
      contentContainerStyle={{ padding: 12 }}
      ListEmptyComponent={
        <Text style={{ color: colors.mutedForeground, textAlign: 'center', marginTop: 48 }}>No sessions</Text>
      }
      renderItem={({ item }) => (
        <View style={{ backgroundColor: colors.card, borderColor: colors.border, borderWidth: 1, borderRadius: 10, padding: 14, marginBottom: 8 }}>
          <TouchableOpacity onPress={() => navigation.navigate('Chat', { sessionId: item.id, title: item.summary || item.title })} style={{ flexDirection: 'row', alignItems: 'center' }}>
            <MessageSquare color={colors.mutedForeground} size={18} />
            <Text style={{ flex: 1, marginLeft: 10, color: colors.foreground, fontWeight: '500' }} numberOfLines={2}>
              {item.summary || item.title || `Session ${item.id}`}
            </Text>
            {item.isRunning && <View style={{ width: 8, height: 8, borderRadius: 4, backgroundColor: colors.primary, marginLeft: 8 }} />}
          </TouchableOpacity>
          <View style={{ flexDirection: 'row', marginTop: 10, gap: 10 }}>
            <TouchableOpacity
              onPress={() => navigation.navigate('Chat', { sessionId: item.id, title: item.summary || item.title })}
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
        </View>
      )}
    />
  );
}
