import React, { useCallback, useEffect, useState } from 'react';
import { ActivityIndicator, FlatList, RefreshControl, Text, TouchableOpacity, View } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { ChevronDown, ChevronRight, File, Folder } from 'lucide-react-native';
import { api } from '~shared/utils/api';
import { useTheme } from '../theme';

interface FileNode {
  name: string;
  path: string;
  type: 'file' | 'directory';
  children?: FileNode[];
}

/** Flatten the tree respecting expanded state. */
const flatten = (nodes: FileNode[], expanded: Set<string>, depth = 0): { node: FileNode; depth: number }[] => {
  const out: { node: FileNode; depth: number }[] = [];
  for (const n of nodes) {
    out.push({ node: n, depth });
    if (n.type === 'directory' && expanded.has(n.path) && n.children) {
      out.push(...flatten(n.children, expanded, depth + 1));
    }
  }
  return out;
};

interface ProjectItem {
  projectId?: string;
  id?: string;
  displayName?: string;
  path?: string;
}

export default function FileTreeScreen({ route }: any) {
  const { colors } = useTheme();
  const insets = useSafeAreaInsets();
  const navigation = useNavigation<any>();
  const [projectId, setProjectId] = useState<string | undefined>(route?.params?.projectId);
  const [projects, setProjects] = useState<ProjectItem[]>([]);
  const [tree, setTree] = useState<FileNode[]>([]);
  const [expanded, setExpanded] = useState<Set<string>>(new Set());
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async (pull = false) => {
    if (pull) setRefreshing(true);
    else setLoading(true);
    setError(null);
    if (!projectId) {
      // No project picked (drawer entry) — offer the project list instead of a dead end.
      try {
        const res = await api.projects();
        if (res.ok) {
          const data = await res.json();
          setProjects(Array.isArray(data) ? data : data?.data?.projects ?? data?.projects ?? []);
        }
      } catch {
        /* leave picker empty */
      }
      setLoading(false);
      setRefreshing(false);
      return;
    }
    try {
      const res = await api.getFiles(projectId);
      if (res.ok) {
        const data = await res.json();
        setTree(Array.isArray(data) ? data : data?.files ?? data?.tree ?? []);
      } else {
        setError(`http-${res.status}`);
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'load failed');
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  }, [projectId]);

  useEffect(() => {
    load();
  }, [load]);

  const toggle = (path: string) => {
    setExpanded((prev) => {
      const next = new Set(prev);
      if (next.has(path)) next.delete(path);
      else next.add(path);
      return next;
    });
  };

  const rows = flatten(tree, expanded);

  return (
    <View style={{ flex: 1, backgroundColor: colors.background }}>
      {loading ? (
        <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
          <ActivityIndicator color={colors.primary} size="large" />
        </View>
      ) : error ? (
        <Text style={{ color: colors.mutedForeground, textAlign: 'center', marginTop: 48 }}>{error}</Text>
      ) : !projectId ? (
        <FlatList
          data={projects}
          keyExtractor={(p) => String(p.projectId ?? p.id)}
          refreshControl={<RefreshControl refreshing={refreshing} onRefresh={() => load(true)} tintColor={colors.primary} />}
          contentContainerStyle={{ padding: 12, paddingBottom: 12 + insets.bottom }}
          renderItem={({ item }) => (
            <TouchableOpacity
              onPress={() => setProjectId(String(item.projectId ?? item.id))}
              style={{ backgroundColor: colors.card, borderColor: colors.border, borderWidth: 1, borderRadius: 10, padding: 14, marginBottom: 8 }}
            >
              <Text style={{ color: colors.foreground, fontWeight: '600' }}>{item.displayName ?? item.path}</Text>
            </TouchableOpacity>
          )}
          ListEmptyComponent={<Text style={{ color: colors.mutedForeground, textAlign: 'center', marginTop: 48 }}>No projects</Text>}
        />
      ) : (
        <FlatList
          data={rows}
          keyExtractor={({ node }) => node.path}
          refreshControl={<RefreshControl refreshing={refreshing} onRefresh={() => load(true)} tintColor={colors.primary} />}
          contentContainerStyle={{ padding: 12, paddingBottom: 12 + insets.bottom }}
          renderItem={({ item: { node, depth } }) => (
            <TouchableOpacity
              onPress={() =>
                node.type === 'directory'
                  ? toggle(node.path)
                  : navigation.navigate('Editor', { projectId, filePath: node.path })
              }
              style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 8, paddingLeft: depth * 16 }}
            >
              {node.type === 'directory' ? (
                <>
                  {expanded.has(node.path) ? <ChevronDown size={16} color={colors.mutedForeground} /> : <ChevronRight size={16} color={colors.mutedForeground} />}
                  <Folder size={16} color={colors.mutedForeground} style={{ marginLeft: 4 }} />
                </>
              ) : (
                <File size={16} color={colors.mutedForeground} style={{ marginLeft: 20 }} />
              )}
              <Text style={{ color: colors.foreground, marginLeft: 8 }} numberOfLines={1}>
                {node.name}
              </Text>
            </TouchableOpacity>
          )}
          ListEmptyComponent={
            <Text style={{ color: colors.mutedForeground, textAlign: 'center', marginTop: 48 }}>Empty</Text>
          }
        />
      )}
    </View>
  );
}
