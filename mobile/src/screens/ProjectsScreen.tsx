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
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import Fuse from 'fuse.js';
import { Star, FolderGit2, ChevronRight, Plus } from 'lucide-react-native';
import { api } from '~shared/utils/api';
import { useTheme } from '../theme';
import { useWebSocket } from '../contexts/WebSocketContext';
import { ActionSheet, ActionSheetItem } from '../components/ActionSheet';
import { Toast, useToast } from '../components/Toast';
import ProjectWizardModal from '../components/ProjectWizard';
import { useProviderSettings } from '../lib/provider-settings-store';
import { sortProjectList } from '../lib/appearance-settings';

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
  const insets = useSafeAreaInsets();
  const navigation = useNavigation<any>();
  const { subscribe, isConnected } = useWebSocket();
  const [projects, setProjects] = useState<Project[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [query, setQuery] = useState('');
  const [creating, setCreating] = useState(false);
  const [renameTarget, setRenameTarget] = useState<Project | null>(null);
  const [renameText, setRenameText] = useState('');
  const [sheet, setSheet] = useState<{ title?: string; items: ActionSheetItem[] } | null>(null);
  const { toast, show: showToast } = useToast();
  const { claude } = useProviderSettings();

  const load = useCallback(async () => {
    try {
      const res = await api.projects();
      if (res.ok) {
        const data = await res.json();
        const raw: any[] = Array.isArray(data) ? data : data?.data?.projects ?? data?.projects ?? [];
        // API returns projectId, not id — normalize so keys/actions/navigation work.
        setProjects(raw.map((p) => ({ ...p, id: p.id ?? p.projectId })));
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
      showToast('Failed to update star', 'error');
      load();
    }
  };

  const projectActions = (p: Project) => {
    setSheet({
      title: p.displayName || p.name || 'Project',
      items: [
        {
          label: 'Rename',
          onPress: () => {
            setRenameText(p.displayName || p.name || '');
            setRenameTarget(p);
          },
        },
        {
          label: 'Archive',
          onPress: () => api.deleteProject(p.id).then(() => { showToast('Project archived'); load(); }).catch(() => showToast('Failed to archive project', 'error')),
        },
        {
          label: 'Delete permanently',
          destructive: true,
          onPress: () =>
            Alert.alert('Delete project?', 'Removes the project and its sessions.', [
              { text: 'Cancel', style: 'cancel' },
              {
                text: 'Delete',
                style: 'destructive',
                onPress: () => api.deleteProject(p.id, true).then(() => { showToast('Project deleted'); load(); }).catch(() => showToast('Failed to delete project', 'error')),
              },
            ]),
        },
      ],
    });
  };

  const submitRename = async () => {
    const target = renameTarget;
    const displayName = renameText.trim();
    setRenameTarget(null);
    if (!target || !displayName) return;
    setProjects((prev) => prev.map((p) => (p.id === target.id ? { ...p, displayName } : p)));
    try {
      await api.renameProject(target.id, displayName);
      showToast('Project renamed');
    } catch {
      showToast('Failed to rename project', 'error');
      load();
    }
  };

  const filtered = query
    ? new Fuse(projects, { keys: ['displayName', 'name', 'path'], threshold: 0.4 }).search(query).map((r) => r.item)
    : projects;

  const sorted = sortProjectList(filtered, claude.projectSortOrder === 'date' ? 'date' : 'name');

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
        contentContainerStyle={{ paddingHorizontal: 12, paddingBottom: 24 + insets.bottom }}
        ListEmptyComponent={
          <Text style={{ color: colors.mutedForeground, textAlign: 'center', marginTop: 48 }}>No projects yet</Text>
        }
        renderItem={({ item }) => (
          <TouchableOpacity
            onPress={() => navigation.navigate('Sessions', { projectId: item.id, projectName: item.displayName || item.name, projectPath: item.path })}
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

      <ActionSheet visible={sheet !== null} title={sheet?.title} items={sheet?.items ?? []} onClose={() => setSheet(null)} />
      <ProjectWizardModal visible={creating} onClose={() => setCreating(false)} onCreated={() => { showToast('Project created'); load(); }} />

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
      {toast && <Toast toast={toast} />}
    </View>
  );
}
