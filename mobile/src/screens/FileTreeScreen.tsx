import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import {
  ActivityIndicator,
  FlatList,
  Image,
  Modal,
  RefreshControl,
  ScrollView,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import {
  CalendarClock,
  ChevronDown,
  ChevronRight,
  Columns3,
  Eye,
  File,
  FileCode,
  FileImage,
  FileJson,
  FileText,
  Folder,
  FolderOpen,
  List,
  Plus,
  RefreshCw,
  Search,
  TableProperties,
  Upload,
  X,
} from 'lucide-react-native';
import * as Clipboard from 'expo-clipboard';
import * as DocumentPicker from 'expo-document-picker';
import * as FileSystem from 'expo-file-system/legacy';
import * as Sharing from 'expo-sharing';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { api, getStoredAuthToken } from '~shared/utils/api';
import { useTheme } from '../theme';
import { getServerUrlSync } from '../lib/server-config';
import { ActionSheet, type ActionSheetItem } from '../components/ActionSheet';
import { Toast, useToast } from '../components/Toast';
import {
  FILE_SEARCH_DEBOUNCE_MS,
  FILE_SEARCH_LIMIT,
  FILE_TREE_RECENT_ONLY_KEY,
  FILE_TREE_RECENT_WINDOW_DAYS,
  FILE_TREE_VIEW_MODE_KEY,
  FILE_VIEW_MODES,
  baseName,
  collectDirectoryPaths,
  fileExtension,
  filterFileTreeByModified,
  filterFileTreeByName,
  flattenTree,
  formatFileSize,
  formatRelativeTime,
  isImageFile,
  parseSearchResults,
  validateFileName,
  type FileTreeNode,
  type FileViewMode,
  type SearchResult,
} from '../lib/file-tree';

interface ProjectItem {
  projectId?: string;
  id?: string;
  displayName?: string;
  path?: string;
}

function iconFor(node: FileTreeNode) {
  if (node.type === 'directory') return 'folder' as const;
  const ext = fileExtension(node.name);
  if (['png', 'jpg', 'jpeg', 'gif', 'svg', 'webp', 'ico', 'bmp'].includes(ext)) return 'image' as const;
  if (['json', 'jsonc'].includes(ext)) return 'json' as const;
  if (['ts', 'tsx', 'js', 'jsx', 'py', 'go', 'rs', 'java', 'c', 'cpp', 'rb', 'php', 'sh'].includes(ext)) return 'code' as const;
  return 'file' as const;
}

const VIEW_MODE_ICONS: Record<FileViewMode, typeof List> = {
  simple: List,
  compact: Eye,
  detailed: TableProperties,
};

export default function FileTreeScreen({ route }: any) {
  const { colors } = useTheme();
  const insets = useSafeAreaInsets();
  const navigation = useNavigation<any>();
  const { toast, show: showToast } = useToast();

  const [projectId, setProjectId] = useState<string | undefined>(route?.params?.projectId);
  const [projects, setProjects] = useState<ProjectItem[]>([]);
  const [tree, setTree] = useState<FileTreeNode[]>([]);
  const [expanded, setExpanded] = useState<Set<string>>(new Set());
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [viewMode, setViewMode] = useState<FileViewMode>('detailed');
  const [recentOnly, setRecentOnly] = useState(true);
  const [query, setQuery] = useState('');
  const [searchMode, setSearchMode] = useState<'name' | 'content'>('name');
  const [contentResults, setContentResults] = useState<SearchResult[] | null>(null);
  const [searching, setSearching] = useState(false);
  const [searchTruncated, setSearchTruncated] = useState(false);
  const [menuTarget, setMenuTarget] = useState<FileTreeNode | null>(null);
  const [createTarget, setCreateTarget] = useState<{ parent: string; type: 'file' | 'directory' } | null>(null);
  const [createName, setCreateName] = useState('');
  const [lightbox, setLightbox] = useState<FileTreeNode | null>(null);
  const [busy, setBusy] = useState(false);
  const [blankMenu, setBlankMenu] = useState(false);
  const [renameTarget, setRenameTarget] = useState<FileTreeNode | null>(null);
  const [renameName, setRenameName] = useState('');
  const [deleteTarget, setDeleteTarget] = useState<FileTreeNode | null>(null);
  const searchTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    AsyncStorage.getItem(FILE_TREE_VIEW_MODE_KEY).then((v) => {
      if (v && (FILE_VIEW_MODES as string[]).includes(v)) setViewMode(v as FileViewMode);
    });
    AsyncStorage.getItem(FILE_TREE_RECENT_ONLY_KEY).then((v) => {
      if (v === 'false') setRecentOnly(false);
    });
  }, []);

  const load = useCallback(async (pull = false) => {
    if (pull) setRefreshing(true);
    else setLoading(true);
    setError(null);
    if (!projectId) {
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
    void load();
  }, [load]);

  const setViewModePersist = (mode: FileViewMode) => {
    setViewMode(mode);
    void AsyncStorage.setItem(FILE_TREE_VIEW_MODE_KEY, mode);
  };

  const toggleRecentOnly = () => {
    const next = !recentOnly;
    setRecentOnly(next);
    void AsyncStorage.setItem(FILE_TREE_RECENT_ONLY_KEY, next ? 'true' : 'false');
  };

  // Content search (server-side, debounced).
  useEffect(() => {
    if (searchMode !== 'content' || !projectId) {
      setContentResults(null);
      return undefined;
    }
    const q = query.trim();
    if (!q) {
      setContentResults(null);
      return undefined;
    }
    if (searchTimer.current) clearTimeout(searchTimer.current);
    searchTimer.current = setTimeout(async () => {
      setSearching(true);
      try {
        const params = new URLSearchParams({ q, respectGitignore: 'true', limit: String(FILE_SEARCH_LIMIT), regex: 'false' });
        const res = await api.get(`/file-tree/projects/${projectId}/search?${params.toString()}`);
        if (res.ok) {
          const { results, truncated } = parseSearchResults(await res.json());
          setContentResults(results);
          setSearchTruncated(truncated);
        } else {
          setContentResults([]);
        }
      } catch {
        setContentResults([]);
      } finally {
        setSearching(false);
      }
    }, FILE_SEARCH_DEBOUNCE_MS);
    return () => {
      if (searchTimer.current) clearTimeout(searchTimer.current);
    };
  }, [query, searchMode, projectId]);

  const visibleTree = useMemo(() => {
    let nodes = tree;
    if (recentOnly) nodes = filterFileTreeByModified(nodes, FILE_TREE_RECENT_WINDOW_DAYS);
    if (searchMode === 'name' && query.trim()) nodes = filterFileTreeByName(nodes, query);
    return nodes;
  }, [tree, recentOnly, searchMode, query]);

  // Auto-expand directories when name-searching.
  useEffect(() => {
    if (searchMode === 'name' && query.trim()) {
      setExpanded(new Set(collectDirectoryPaths(visibleTree)));
    }
  }, [searchMode, query, visibleTree]);

  const rows = useMemo(
    () => (searchMode === 'content' ? [] : flattenTree(visibleTree, expanded)),
    [visibleTree, expanded, searchMode],
  );

  const toggle = (path: string) => {
    setExpanded((prev) => {
      const next = new Set(prev);
      if (next.has(path)) next.delete(path);
      else next.add(path);
      return next;
    });
  };

  const reopenEditor = (path: string) => navigation.navigate('Editor', { projectId, filePath: path });

  const refresh = () => load(true);

  const createItem = async () => {
    if (!createTarget) return;
    const name = createName.trim();
    const invalid = validateFileName(name);
    if (invalid) {
      showToast(invalid === 'empty' ? 'Name required' : invalid === 'dotsOnly' ? 'Invalid name' : invalid === 'reserved' ? 'Reserved name' : 'Invalid characters', 'error');
      return;
    }
    setBusy(true);
    try {
      const res = await api.createFile(projectId, { path: createTarget.parent, type: createTarget.type, name });
      if (!res.ok) throw new Error(`http-${res.status}`);
      showToast(createTarget.type === 'file' ? 'File created' : 'Folder created');
      if (createTarget.parent) setExpanded((p) => new Set(p).add(createTarget.parent));
      setCreateTarget(null);
      setCreateName('');
      await load();
    } catch {
      showToast('Create failed', 'error');
    } finally {
      setBusy(false);
    }
  };

  const renameItem = (node: FileTreeNode, newName: string) => {
    const invalid = validateFileName(newName);
    if (invalid) {
      showToast('Invalid name', 'error');
      return;
    }
    setBusy(true);
    api
      .renameFile(projectId, { oldPath: node.path, newName: newName.trim() })
      .then(async (res) => {
        if (!res.ok) throw new Error('rename');
        showToast('Renamed');
        await load();
      })
      .catch(() => showToast('Rename failed', 'error'))
      .finally(() => setBusy(false));
  };

  const deleteItem = (node: FileTreeNode) => {
    setBusy(true);
    api
      .deleteFile(projectId, { path: node.path, type: node.type })
      .then(async (res) => {
        if (!res.ok) throw new Error('delete');
        showToast(node.type === 'file' ? 'File deleted' : 'Folder deleted');
        await load();
      })
      .catch(() => showToast('Delete failed', 'error'))
      .finally(() => setBusy(false));
  };

  const downloadItem = async (node: FileTreeNode) => {
    if (node.type !== 'file') {
      showToast('Folder download unavailable', 'error');
      return;
    }
    setBusy(true);
    try {
      const token = getStoredAuthToken();
      const headers: Record<string, string> = token ? { Authorization: `Bearer ${token}` } : {};
      const target = `${FileSystem.cacheDirectory}${node.name}`;
      const res = await FileSystem.downloadAsync(
        `${getServerUrlSync()}/api/file-tree/projects/${projectId}/files/content?path=${encodeURIComponent(node.path)}`,
        target,
        { headers },
      );
      if (res.status !== 200) throw new Error('download');
      if (await Sharing.isAvailableAsync()) {
        await Sharing.shareAsync(res.uri);
      }
      showToast('Downloaded');
    } catch {
      showToast('Download failed', 'error');
    } finally {
      setBusy(false);
    }
  };

  const submitUpload = async (parent: string) => {
    try {
      const picked = await DocumentPicker.getDocumentAsync({ multiple: true, type: '*/*', copyToCacheDirectory: true });
      if (picked.canceled || !picked.assets?.length) return;
      setBusy(true);
      const form = new FormData();
      form.append('targetPath', parent || '');
      form.append('requestedFileCount', String(picked.assets.length));
      form.append('relativePaths', JSON.stringify(picked.assets.map((a) => a.name)));
      for (const asset of picked.assets) {
        form.append('files', { uri: asset.uri, name: asset.name, type: asset.mimeType ?? 'application/octet-stream' } as any);
      }
      const res = await api.uploadFiles(projectId, form);
      if (!res.ok) throw new Error('upload');
      showToast(`Uploaded ${picked.assets.length} file(s)`);
      if (parent) setExpanded((p) => new Set(p).add(parent));
      await load();
    } catch {
      showToast('Upload failed', 'error');
    } finally {
      setBusy(false);
    }
  };

  const beginCreate = (parent: string, type: 'file' | 'directory') => {
    setCreateTarget({ parent, type });
    setCreateName('');
  };

  const copyPath = async (node: FileTreeNode) => {
    try {
      await Clipboard.setStringAsync(node.path);
      showToast('Path copied');
    } catch {
      showToast('Copy failed', 'error');
    }
  };

  const menuItems = (): ActionSheetItem[] => {
    const node = menuTarget;
    if (!node) {
      return [
        { label: 'New File', onPress: () => beginCreate('', 'file') },
        { label: 'New Folder', onPress: () => beginCreate('', 'directory') },
        { label: 'Upload Files', onPress: () => void submitUpload('') },
        { label: 'Refresh', onPress: refresh },
      ];
    }
    if (node.type === 'directory') {
      return [
        { label: 'New File', onPress: () => beginCreate(node.path, 'file') },
        { label: 'New Folder', onPress: () => beginCreate(node.path, 'directory') },
        { label: 'Upload Files', onPress: () => void submitUpload(node.path) },
        { label: 'Rename', onPress: () => promptRename(node) },
        { label: 'Delete', destructive: true, onPress: () => confirmDelete(node) },
        { label: 'Copy Path', onPress: () => void copyPath(node) },
      ];
    }
    return [
      { label: 'Rename', onPress: () => promptRename(node) },
      { label: 'Delete', destructive: true, onPress: () => confirmDelete(node) },
      { label: 'Copy Path', onPress: () => void copyPath(node) },
      { label: 'Download', onPress: () => void downloadItem(node) },
    ];
  };

  const promptRename = (node: FileTreeNode) => {
    setRenameTarget(node);
    setRenameName(node.name);
  };
  const confirmDelete = (node: FileTreeNode) => {
    setDeleteTarget(node);
  };

  const onPressRow = (node: FileTreeNode) => {
    if (node.type === 'directory') toggle(node.path);
    else if (isImageFile(node.name) && projectId) setLightbox(node);
    else reopenEditor(node.path);
  };

  const iconColor = colors.mutedForeground;

  return (
    <View style={{ flex: 1, backgroundColor: colors.background }}>
      {projectId ? (
        <View style={{ borderBottomWidth: 1, borderBottomColor: colors.border, paddingHorizontal: 10, paddingVertical: 8, gap: 8 }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6 }}>
            <View style={{ flex: 1, flexDirection: 'row', alignItems: 'center', backgroundColor: colors.muted, borderRadius: 8, paddingHorizontal: 8 }}>
              <Search size={15} color={iconColor} />
              <TextInput
                value={query}
                onChangeText={setQuery}
                placeholder={searchMode === 'content' ? 'Search in files…' : 'Search files…'}
                placeholderTextColor={colors.mutedForeground}
                style={{ flex: 1, color: colors.foreground, paddingVertical: 8, paddingHorizontal: 6, fontSize: 14 }}
              />
              {query ? (
                <TouchableOpacity onPress={() => setQuery('')}>
                  <X size={15} color={iconColor} />
                </TouchableOpacity>
              ) : null}
            </View>
            <TouchableOpacity
              onPress={() => setSearchMode((m) => (m === 'name' ? 'content' : 'name'))}
              style={{ borderWidth: 1, borderColor: searchMode === 'content' ? colors.primary : colors.border, borderRadius: 8, paddingHorizontal: 8, paddingVertical: 7 }}
            >
              <Text style={{ color: searchMode === 'content' ? colors.primary : colors.foreground, fontSize: 11 }}>Content</Text>
            </TouchableOpacity>
          </View>
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6 }}>
            {FILE_VIEW_MODES.map((mode) => {
              const Icon = VIEW_MODE_ICONS[mode];
              const active = viewMode === mode;
              return (
                <TouchableOpacity
                  key={mode}
                  onPress={() => setViewModePersist(mode)}
                  style={{ padding: 6, borderRadius: 6, backgroundColor: active ? colors.muted : 'transparent' }}
                >
                  <Icon size={16} color={active ? colors.primary : iconColor} />
                </TouchableOpacity>
              );
            })}
            <View style={{ flex: 1 }} />
            <TouchableOpacity onPress={toggleRecentOnly} style={{ padding: 6, borderRadius: 6, backgroundColor: recentOnly ? colors.muted : 'transparent' }}>
              <CalendarClock size={16} color={recentOnly ? colors.primary : iconColor} />
            </TouchableOpacity>
            <TouchableOpacity onPress={() => setExpanded(new Set())} style={{ padding: 6 }}>
              <ChevronDown size={16} color={iconColor} />
            </TouchableOpacity>
            <TouchableOpacity onPress={refresh} style={{ padding: 6 }}>
              <RefreshCw size={16} color={iconColor} />
            </TouchableOpacity>
            <TouchableOpacity onPress={() => setBlankMenu(true)} style={{ padding: 6 }}>
              <Plus size={17} color={iconColor} />
            </TouchableOpacity>
          </View>
        </View>
      ) : null}

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
          refreshControl={<RefreshControl refreshing={refreshing} onRefresh={refresh} tintColor={colors.primary} />}
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
      ) : searchMode === 'content' ? (
        <ScrollView contentContainerStyle={{ padding: 12, paddingBottom: 12 + insets.bottom }}>
          {searching ? (
            <ActivityIndicator color={colors.primary} style={{ marginTop: 32 }} />
          ) : !contentResults || contentResults.length === 0 ? (
            <Text style={{ color: colors.mutedForeground, textAlign: 'center', marginTop: 48 }}>{query.trim() ? 'No results' : 'Type to search file contents'}</Text>
          ) : (
            <>
              {contentResults.map((r, idx) => (
                <TouchableOpacity
                  key={`${r.path}-${r.line}-${idx}`}
                  onPress={() => reopenEditor(r.path)}
                  style={{ paddingVertical: 8, borderBottomWidth: 1, borderBottomColor: colors.border }}
                >
                  <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6 }}>
                    <FileText size={14} color={iconColor} />
                    <Text style={{ color: colors.foreground, flex: 1 }} numberOfLines={1}>{r.path}</Text>
                    <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>:{r.line}</Text>
                  </View>
                  <Text style={{ color: colors.mutedForeground, fontSize: 12, marginTop: 2 }} numberOfLines={1}>{r.text}</Text>
                </TouchableOpacity>
              ))}
              {searchTruncated ? (
                <Text style={{ color: colors.mutedForeground, fontSize: 11, textAlign: 'center', marginTop: 8 }}>
                  {`Showing first ${FILE_SEARCH_LIMIT} results`}
                </Text>
              ) : null}
            </>
          )}
        </ScrollView>
      ) : (
        <FlatList
          data={rows}
          keyExtractor={({ node }) => node.path}
          refreshControl={<RefreshControl refreshing={refreshing} onRefresh={refresh} tintColor={colors.primary} />}
          contentContainerStyle={{ paddingBottom: 12 + insets.bottom }}
          ListHeaderComponent={
            viewMode === 'detailed' && rows.length > 0 ? (
              <View style={{ flexDirection: 'row', paddingHorizontal: 12, paddingVertical: 6, borderBottomWidth: 1, borderBottomColor: colors.border }}>
                <Text style={{ flex: 1, color: colors.mutedForeground, fontSize: 11 }}>Name</Text>
                <Text style={{ width: 70, color: colors.mutedForeground, fontSize: 11, textAlign: 'right' }}>Size</Text>
                <Text style={{ width: 90, color: colors.mutedForeground, fontSize: 11, textAlign: 'right' }}>Modified</Text>
              </View>
            ) : null
          }
          renderItem={({ item: { node, depth } }) => {
            const kind = iconFor(node);
            const isOpen = expanded.has(node.path);
            const Icon = kind === 'folder' ? (isOpen ? FolderOpen : Folder) : kind === 'image' ? FileImage : kind === 'json' ? FileJson : kind === 'code' ? FileCode : File;
            return (
              <TouchableOpacity
                onPress={() => onPressRow(node)}
                onLongPress={() => setMenuTarget(node)}
                style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 9, paddingHorizontal: 12, paddingLeft: 12 + depth * 16 }}
              >
                {node.type === 'directory' ? (
                  isOpen ? <ChevronDown size={15} color={iconColor} /> : <ChevronRight size={15} color={iconColor} />
                ) : (
                  <View style={{ width: 15 }} />
                )}
                <Icon size={16} color={kind === 'image' ? colors.primary : iconColor} style={{ marginLeft: 4 }} />
                <Text style={{ color: colors.foreground, marginLeft: 8, flex: 1 }} numberOfLines={1}>
                  {node.name}
                </Text>
                {viewMode === 'detailed' ? (
                  <>
                    <Text style={{ width: 70, color: colors.mutedForeground, fontSize: 11, textAlign: 'right' }}>
                      {node.type === 'file' ? formatFileSize(node.size) : ''}
                    </Text>
                    <Text style={{ width: 90, color: colors.mutedForeground, fontSize: 11, textAlign: 'right' }}>
                      {node.type === 'file' ? formatRelativeTime(node.modified) : ''}
                    </Text>
                  </>
                ) : viewMode === 'compact' && node.type === 'file' ? (
                  <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{formatFileSize(node.size)}</Text>
                ) : null}
              </TouchableOpacity>
            );
          }}
          ListEmptyComponent={
            <Text style={{ color: colors.mutedForeground, textAlign: 'center', marginTop: 48 }}>
              {query.trim() ? 'No matches found' : recentOnly ? 'No recent files' : 'Empty'}
            </Text>
          }
        />
      )}

      <ActionSheet visible={menuTarget !== null} title={menuTarget?.name} items={menuItems()} onClose={() => setMenuTarget(null)} />

      {/* Root menu button */}
      {projectId ? (
        <TouchableOpacity
          onPress={() => setBlankMenu(true)}
          style={{ position: 'absolute', right: 16, bottom: 16 + insets.bottom, backgroundColor: colors.primary, width: 48, height: 48, borderRadius: 24, alignItems: 'center', justifyContent: 'center' }}
        >
          <Plus size={22} color={colors.primaryForeground} />
        </TouchableOpacity>
      ) : null}

      <ActionSheet
        visible={blankMenu}
        title="Project root"
        items={[
          { label: 'New File', onPress: () => beginCreate('', 'file') },
          { label: 'New Folder', onPress: () => beginCreate('', 'directory') },
          { label: 'Upload Files', onPress: () => void submitUpload('') },
          { label: 'Refresh', onPress: refresh },
        ]}
        onClose={() => setBlankMenu(false)}
      />

      {busy ? (
        <View style={{ position: 'absolute', top: 0, left: 0, right: 0, bottom: 0, alignItems: 'center', justifyContent: 'center', backgroundColor: 'rgba(0,0,0,0.25)' }}>
          <ActivityIndicator color={colors.primary} size="large" />
        </View>
      ) : null}

      {/* Create modal */}
      <Modal visible={createTarget !== null} transparent animationType="fade" onRequestClose={() => setCreateTarget(null)}>
        <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', padding: 24 }}>
          <View style={{ backgroundColor: colors.card, borderRadius: 12, padding: 18, gap: 12 }}>
            <Text style={{ color: colors.foreground, fontWeight: '700', fontSize: 16 }}>
              {createTarget?.type === 'file' ? 'New File' : 'New Folder'}
            </Text>
            <TextInput
              value={createName}
              onChangeText={setCreateName}
              autoFocus
              placeholder={createTarget?.type === 'file' ? 'untitled.txt' : 'new-folder'}
              placeholderTextColor={colors.mutedForeground}
              style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 8, paddingHorizontal: 10, paddingVertical: 8, color: colors.foreground }}
            />
            <View style={{ flexDirection: 'row', justifyContent: 'flex-end', gap: 10 }}>
              <TouchableOpacity onPress={() => setCreateTarget(null)}>
                <Text style={{ color: colors.mutedForeground, paddingVertical: 8 }}>Cancel</Text>
              </TouchableOpacity>
              <TouchableOpacity onPress={() => void createItem()} style={{ backgroundColor: colors.primary, borderRadius: 8, paddingHorizontal: 16, paddingVertical: 8 }}>
                <Text style={{ color: colors.primaryForeground, fontWeight: '600' }}>Create</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>

      {/* Rename modal */}
      <Modal visible={renameTarget !== null} transparent animationType="fade" onRequestClose={() => setRenameTarget(null)}>
        <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', padding: 24 }}>
          <View style={{ backgroundColor: colors.card, borderRadius: 12, padding: 18, gap: 12 }}>
            <Text style={{ color: colors.foreground, fontWeight: '700', fontSize: 16 }}>Rename</Text>
            <TextInput
              value={renameName}
              onChangeText={setRenameName}
              autoFocus
              style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 8, paddingHorizontal: 10, paddingVertical: 8, color: colors.foreground }}
            />
            <View style={{ flexDirection: 'row', justifyContent: 'flex-end', gap: 10 }}>
              <TouchableOpacity onPress={() => setRenameTarget(null)}>
                <Text style={{ color: colors.mutedForeground, paddingVertical: 8 }}>Cancel</Text>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={() => {
                  const target = renameTarget;
                  const name = renameName;
                  setRenameTarget(null);
                  if (target) renameItem(target, name);
                }}
                style={{ backgroundColor: colors.primary, borderRadius: 8, paddingHorizontal: 16, paddingVertical: 8 }}
              >
                <Text style={{ color: colors.primaryForeground, fontWeight: '600' }}>Rename</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>

      {/* Delete confirm */}
      <Modal visible={deleteTarget !== null} transparent animationType="fade" onRequestClose={() => setDeleteTarget(null)}>
        <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', padding: 24 }}>
          <View style={{ backgroundColor: colors.card, borderRadius: 12, padding: 18, gap: 12 }}>
            <Text style={{ color: colors.foreground, fontWeight: '700', fontSize: 16 }}>Delete {deleteTarget?.type === 'file' ? 'file' : 'folder'}?</Text>
            <Text style={{ color: colors.mutedForeground }}>
              {deleteTarget?.type === 'file'
                ? `${deleteTarget?.name} will be permanently deleted.`
                : `${deleteTarget?.name} and its contents will be permanently deleted.`}
            </Text>
            <View style={{ flexDirection: 'row', justifyContent: 'flex-end', gap: 10 }}>
              <TouchableOpacity onPress={() => setDeleteTarget(null)}>
                <Text style={{ color: colors.mutedForeground, paddingVertical: 8 }}>Cancel</Text>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={() => {
                  const target = deleteTarget;
                  setDeleteTarget(null);
                  if (target) deleteItem(target);
                }}
                style={{ backgroundColor: colors.destructive, borderRadius: 8, paddingHorizontal: 16, paddingVertical: 8 }}
              >
                <Text style={{ color: '#fff', fontWeight: '600' }}>Delete</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>

      {/* Image lightbox */}
      <Modal visible={lightbox !== null} transparent animationType="fade" onRequestClose={() => setLightbox(null)}>
        <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.92)', justifyContent: 'center' }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', padding: 16 }}>
            <Text style={{ color: '#fff', flex: 1 }} numberOfLines={1}>{lightbox?.name}</Text>
            <TouchableOpacity onPress={() => setLightbox(null)}>
              <X size={20} color="#fff" />
            </TouchableOpacity>
          </View>
          {lightbox && projectId ? (
            <Image
              source={{
                uri: `${getServerUrlSync()}/api/file-tree/projects/${projectId}/files/content?path=${encodeURIComponent(lightbox.path)}`,
                headers: (() => {
                  const token = getStoredAuthToken();
                  return token ? { Authorization: `Bearer ${token}` } : undefined;
                })(),
              }}
              style={{ flex: 1, margin: 16 }}
              resizeMode="contain"
            />
          ) : null}
        </View>
      </Modal>

      {toast ? <Toast toast={toast} /> : null}
    </View>
  );
}
