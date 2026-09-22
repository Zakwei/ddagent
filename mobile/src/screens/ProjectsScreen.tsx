import React, { useCallback, useEffect, useState } from 'react';
import { ActivityIndicator, FlatList, RefreshControl, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import Fuse from 'fuse.js';
import { Star, FolderGit2, ChevronRight } from 'lucide-react-native';
import { api } from '~shared/utils/api';
import { useTheme } from '../theme';
import { useWebSocket } from '../contexts/WebSocketContext';

interface Project {
  id: string;
  displayName?: string;
  name?: string;
  path?: string;
  isStarred?: boolean;
  sessionCount?: number;
  runningCount?: number;
}

export default function ProjectsScreen() {
  const { colors } = useTheme();
  const navigation = useNavigation<any>();
  const { subscribe, isConnected } = useWebSocket();
  const [projects, setProjects] = useState<Project[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [query, setQuery] = useState('');

  const load = useCallback(async () => {
    try {
      const res = await api.projects();
      if (res.ok) {
        const data = await res.json();
        setProjects(Array.isArray(data) ? data : data?.projects ?? []);
      }
    } catch (err) {
      console.error('projects load failed:', err);
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  // Live updates: a session/project change on the server re-fetches the list.
  useEffect(
    () =>
      subscribe((event) => {
        if (typeof event?.type === 'string' && /session_|project_/i.test(event.type)) load();
      }),
    [subscribe, load],
  );

  const toggleStar = async (p: Project) => {
    setProjects((prev) =>
      prev.map((x) => (x.id === p.id ? { ...x, isStarred: !x.isStarred } : x)),
    );
    try {
      await api.toggleProjectStar(p.id);
    } catch {
      load();
    }
  };

  const filtered = query
    ? new Fuse(projects, { keys: ['displayName', 'name', 'path'], threshold: 0.4 })
        .search(query)
        .map((r) => r.item)
    : projects;

  const sorted = [...filtered].sort(
    (a, b) => Number(b.isStarred ?? false) - Number(a.isStarred ?? false),
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
      <View style={{ padding: 12 }}>
        <TextInput
          value={query}
          onChangeText={setQuery}
          placeholder="Search projects…"
          placeholderTextColor={colors.mutedForeground}
          style={{ backgroundColor: colors.card, color: colors.foreground, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10 }}
        />
        <Text style={{ color: isConnected ? colors.mutedForeground : colors.destructive, fontSize: 12, marginTop: 6 }}>
          {isConnected ? 'connected' : 'reconnecting…'}
        </Text>
      </View>
      <FlatList
        data={sorted}
        keyExtractor={(item) => String(item.id)}
        refreshControl={<RefreshControl refreshing={refreshing} onRefresh={() => { setRefreshing(true); load(); }} tintColor={colors.primary} />}
        contentContainerStyle={{ paddingHorizontal: 12, paddingBottom: 24 }}
        ListEmptyComponent={
          <Text style={{ color: colors.mutedForeground, textAlign: 'center', marginTop: 48 }}>
            No projects yet
          </Text>
        }
        renderItem={({ item }) => (
          <TouchableOpacity
            onPress={() => navigation.navigate('Sessions', { projectId: item.id, projectName: item.displayName || item.name })}
            style={{ backgroundColor: colors.card, borderColor: colors.border, borderWidth: 1, borderRadius: 10, padding: 14, marginBottom: 8, flexDirection: 'row', alignItems: 'center' }}
          >
            <FolderGit2 color={colors.mutedForeground} size={20} />
            <View style={{ flex: 1, marginLeft: 12 }}>
              <Text style={{ color: colors.foreground, fontWeight: '600' }} numberOfLines={1}>
                {item.displayName || item.name || 'Project'}
              </Text>
              {!!item.path && (
                <Text style={{ color: colors.mutedForeground, fontSize: 12 }} numberOfLines={1}>
                  {item.path}
                </Text>
              )}
            </View>
            {!!item.runningCount && (
              <View style={{ backgroundColor: colors.primary, borderRadius: 10, paddingHorizontal: 8, paddingVertical: 2, marginRight: 8 }}>
                <Text style={{ color: colors.primaryForeground, fontSize: 11 }}>{item.runningCount}</Text>
              </View>
            )}
            <TouchableOpacity onPress={() => toggleStar(item)} hitSlop={8} style={{ padding: 4 }}>
              <Star color={item.isStarred ? colors.primary : colors.mutedForeground} size={18} fill={item.isStarred ? colors.primary : 'transparent'} />
            </TouchableOpacity>
            <ChevronRight color={colors.mutedForeground} size={18} />
          </TouchableOpacity>
        )}
      />
    </View>
  );
}
