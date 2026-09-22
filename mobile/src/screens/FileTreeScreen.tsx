import React, { useCallback, useEffect, useState } from 'react';
import { ActivityIndicator, FlatList, Text, TouchableOpacity, View } from 'react-native';
import { useNavigation } from '@react-navigation/native';
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

export default function FileTreeScreen({ route }: any) {
  const { colors } = useTheme();
  const navigation = useNavigation<any>();
  const projectId: string | undefined = route?.params?.projectId;
  const [tree, setTree] = useState<FileNode[]>([]);
  const [expanded, setExpanded] = useState<Set<string>>(new Set());
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async () => {
    if (!projectId) {
      setError('Open a project first (Projects → pick one)');
      setLoading(false);
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
      ) : (
        <FlatList
          data={rows}
          keyExtractor={({ node }) => node.path}
          contentContainerStyle={{ padding: 12 }}
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
