import React, { useCallback, useEffect, useState } from 'react';
import { ActivityIndicator, FlatList, RefreshControl, Text, TouchableOpacity, View } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { MessageSquare } from 'lucide-react-native';
import { api } from '~shared/utils/api';
import { useTheme } from '../theme';
import { useWebSocket } from '../contexts/WebSocketContext';

interface RecentSession {
  id: string;
  sessionTitle?: string;
  summary?: string;
  title?: string;
  provider?: string;
  projectId?: string | null;
  projectDisplayName?: string;
  projectName?: string;
  lastActivity?: string;
  messageCount?: number;
}

/** Cross-project recent conversations — same data as the web sidebar. */
export default function RecentScreen() {
  const { colors } = useTheme();
  const navigation = useNavigation<any>();
  const { subscribe } = useWebSocket();
  const [sessions, setSessions] = useState<RecentSession[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  const load = useCallback(async () => {
    try {
      const res = await api.recentConversations({ limit: 40 });
      if (res.ok) {
        const data = await res.json();
        // Real envelope: { success, data: { conversations, total, hasMore } }
        const raw: any[] = Array.isArray(data) ? data : data?.data?.conversations ?? data?.conversations ?? [];
        setSessions(raw.map((s) => ({ ...s, id: s.id ?? s.sessionId })));
      }
    } catch (err) {
      console.error('recent sessions load failed:', err);
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  useEffect(
    () =>
      subscribe((event) => {
        if (event?.kind === 'session_upserted') load();
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
    <View style={{ flex: 1, backgroundColor: colors.background }}>
      <FlatList
        data={sessions}
        keyExtractor={(item) => String(item.id)}
        refreshControl={<RefreshControl refreshing={refreshing} onRefresh={() => { setRefreshing(true); load(); }} tintColor={colors.primary} />}
        contentContainerStyle={{ padding: 12 }}
        ListEmptyComponent={<Text style={{ color: colors.mutedForeground, textAlign: 'center', marginTop: 48 }}>No recent sessions</Text>}
        renderItem={({ item }) => (
          <TouchableOpacity
            onPress={() => navigation.navigate('Chat', { sessionId: item.id, title: item.sessionTitle || item.summary || item.title, provider: item.provider, projectId: item.projectId })}
            style={{ backgroundColor: colors.card, borderColor: colors.border, borderWidth: 1, borderRadius: 10, padding: 14, marginBottom: 8, flexDirection: 'row', alignItems: 'center' }}
          >
            <MessageSquare color={colors.mutedForeground} size={18} />
            <View style={{ flex: 1, marginLeft: 10 }}>
              <Text style={{ color: colors.foreground, fontWeight: '500' }} numberOfLines={1}>
                {item.sessionTitle || item.summary || item.title || `Session ${item.id}`}
              </Text>
              {(!!item.projectDisplayName || !!item.projectName) && (
                <Text style={{ color: colors.mutedForeground, fontSize: 12, marginTop: 2 }} numberOfLines={1}>
                  {item.projectDisplayName ?? item.projectName}
                </Text>
              )}
            </View>
          </TouchableOpacity>
        )}
      />
    </View>
  );
}
