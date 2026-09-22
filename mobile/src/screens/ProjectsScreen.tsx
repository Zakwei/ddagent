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
import { useNavigation } from '@react-navigation/native';
import Fuse from 'fuse.js';
import { Star, FolderGit2, ChevronRight, Plus } from 'lucide-react-native';
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
  const [creating, setCreating] = useState(false);
  const [newName, setNewName] = useState('');
  const [newPath, setNewPath] = useState('');
  const [createError, setCreateError] = useState<string | null>(null);
  const [renameTarget, setRenameTarget] = useState<Project | null>(null);
  const [renameText, setRenameText] = useState('');

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

  useEffect(
    () =>
      subscribe((event) => {
        if (typeof event?.kind === 'string' && /session_|project_/i.test(event.kind)) load();
      }),
    [subscribe, load],
  );

  const toggleStar = async (p: Project) => {
    setProjects((prev) => prev.map((x) => (x.id === p.id ? { ...x, isStarred: !x.isStarred } : x)));
    try {
      await api.toggleProjectStar(p.id);
    } catch {
      load();
    }
  };

  const projectActions = (p: Project) => {
    Alert.alert(p.displayName || p.name || 'Project', undefined, [
      {
        text: 'Rename',
        onPress: () => {
          setRenameText(p.displayName || p.name || '');
          setRenameTarget(p);
        },
      },
      {
        text: 'Archive',
        onPress: () => api.deleteProject(p.id).then(load).catch(() => {}),
      },
      {
        text: 'Delete permanently',
        style: 'destructive',
        onPress: () =>
          Alert.alert('Delete project?', 'Removes the project and its sessions.', [
            { text: 'Cancel', style: 'cancel' },
            {
              text: 'Delete',
              style: 'destructive',
              onPress: () => api.deleteProject(p.id, true).then(load).catch(() => {}),
            },
          ]),
      },
      { text: 'Cancel', style: 'cancel' },
    ]);
  };

  const submitRename = async () => {
    const target = renameTarget;
    const displayName = renameText.trim();
    setRenameTarget(null);
    if (!target || !displayName) return;
    setProjects((prev) => prev.map((p) => (p.id === target.id ? { ...p, displayName } : p)));
    try {
      await api.renameProject(target.id, displayName);
    } catch {
      load();
    }
  };

  const submitCreate = async () => {
    const path = newPath.trim();
    if (!path) {
      setCreateError('Path is required');
      return;
    }
    setCreateError(null);
    try {
      const res = await api.createProject({ path, displayName: newName.trim() || undefined });
      if (!res.ok) {
        const payload = await res.json().catch(() => null);
        setCreateError(payload?.error || `http-${res.status}`);
        return;
      }
      setCreating(false);
      setNewName('');
      setNewPath('');
      load();
    } catch (err) {
      setCreateError(err instanceof Error ? err.message : 'failed');
    }
  };

  const filtered = query
    ? new Fuse(projects, { keys: ['displayName', 'name', 'path'], threshold: 0.4 }).search(query).map((r) => r.item)
    : projects;

  const sorted = [...filtered].sort((a, b) => Number(b.isStarred ?? false) - Number(a.isStarred ?? false));

  if (loading) {
    return (
      <View style={{ flex: 1, backgroundColor: colors.background, alignItems: 'center', justifyContent: 'center' }}>
        <ActivityIndicator color={colors.primary} size="large" />
      </View>
    );
  }

  return (
    <View style={{ flex: 1, backgroundColor: colors.background }}>
      <View style={{ padding: 12, flexDirection: 'row', gap: 8, alignItems: 'center' }}>
        <TextInput
          value={query}
          onChangeText={setQuery}
          placeholder="Search projects…"
          placeholderTextColor={colors.mutedForeground}
          style={{ flex: 1, backgroundColor: colors.card, color: colors.foreground, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10 }}
        />
        <TouchableOpacity onPress={() => setCreating(true)} style={{ backgroundColor: colors.primary, borderRadius: 8, padding: 11 }}>
          <Plus color={colors.primaryForeground} size={18} />
        </TouchableOpacity>
      </View>
      <Text style={{ color: isConnected ? colors.mutedForeground : colors.destructive, fontSize: 12, paddingHorizontal: 12, paddingBottom: 6 }}>
        {isConnected ? 'connected' : 'reconnecting…'}
      </Text>
      <FlatList
        data={sorted}
        keyExtractor={(item) => String(item.id)}
        refreshControl={<RefreshControl refreshing={refreshing} onRefresh={() => { setRefreshing(true); load(); }} tintColor={colors.primary} />}
        contentContainerStyle={{ paddingHorizontal: 12, paddingBottom: 24 }}
        ListEmptyComponent={
          <Text style={{ color: colors.mutedForeground, textAlign: 'center', marginTop: 48 }}>No projects yet</Text>
        }
        renderItem={({ item }) => (
          <TouchableOpacity
            onPress={() => navigation.navigate('Sessions', { projectId: item.id, projectName: item.displayName || item.name })}
            onLongPress={() => projectActions(item)}
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

      {/* New project */}
      <Modal visible={creating} transparent animationType="fade" onRequestClose={() => setCreating(false)}>
        <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', alignItems: 'center', justifyContent: 'center', padding: 24 }}>
          <View style={{ backgroundColor: colors.card, borderRadius: 12, padding: 20, width: '100%' }}>
            <Text style={{ color: colors.foreground, fontWeight: '600', marginBottom: 12 }}>New project</Text>
            <TextInput
              value={newName}
              onChangeText={setNewName}
              placeholder="Display name (optional)"
              placeholderTextColor={colors.mutedForeground}
              style={{ backgroundColor: colors.background, color: colors.foreground, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10, marginBottom: 10 }}
            />
            <TextInput
              value={newPath}
              onChangeText={setNewPath}
              placeholder="/path/on/server"
              placeholderTextColor={colors.mutedForeground}
              autoCapitalize="none"
              autoCorrect={false}
              style={{ backgroundColor: colors.background, color: colors.foreground, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10, marginBottom: 10 }}
            />
            {createError && <Text style={{ color: colors.destructive, marginBottom: 10 }}>{createError}</Text>}
            <View style={{ flexDirection: 'row', justifyContent: 'flex-end', gap: 12 }}>
              <TouchableOpacity onPress={() => setCreating(false)}>
                <Text style={{ color: colors.mutedForeground, padding: 8 }}>Cancel</Text>
              </TouchableOpacity>
              <TouchableOpacity onPress={submitCreate}>
                <Text style={{ color: colors.primary, fontWeight: '600', padding: 8 }}>Create</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>

      {/* Rename project */}
      <Modal visible={!!renameTarget} transparent animationType="fade" onRequestClose={() => setRenameTarget(null)}>
        <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', alignItems: 'center', justifyContent: 'center', padding: 24 }}>
          <View style={{ backgroundColor: colors.card, borderRadius: 12, padding: 20, width: '100%' }}>
            <Text style={{ color: colors.foreground, fontWeight: '600', marginBottom: 12 }}>Rename project</Text>
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
    </View>
  );
}
