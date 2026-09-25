import React, { useCallback, useEffect, useMemo, useState } from 'react';
import { ActivityIndicator, Modal, ScrollView, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { Archive, ChevronDown, Folder, FolderOpen, MessageSquarePlus, Pin, RotateCcw, Search, Star, Trash2, X } from 'lucide-react-native';
import { api } from '~shared/utils/api';

import type { ThemeColors } from '../theme';
import { ActionSheet, ActionSheetItem } from './ActionSheet';
import {
  type ArchivedPickerProject,
  type ArchivedPickerSession,
  type PickerSession,
  filterPickerSessions,
  formatPickerAge,
  getPickerSessionTitle,
  groupArchivedPickerSessions,
  groupPickerSessions,
  isPickerSessionUnread,
} from '../lib/session-picker';
import { usePinnedSessions } from '../lib/pinned-sessions';

const PROVIDER_LABELS: Record<string, string> = {
  claude: 'Claude',
  cursor: 'Cursor',
  codex: 'Codex',
  opencode: 'OpenCode',
  devin: 'Devin',
};

interface SessionPickerSheetProps {
  visible: boolean;
  colors: ThemeColors;
  sessions: PickerSession[];
  currentSessionId?: string | null;
  processingSessionIds?: ReadonlySet<string>;
  onSelect: (session: PickerSession) => void;
  onNewChat: () => void;
  onClose: () => void;
  onDeleted?: () => void;
}

/**
 * In-pane session picker (web `SessionPicker.tsx`): grouped current/other
 * projects, search, running/unread dots, account badge, ages, pin, and an
 * archived view with restore-session / restore-project.
 */
export function SessionPickerSheet(props: SessionPickerSheetProps) {
  const { visible, colors, sessions, currentSessionId, processingSessionIds, onSelect, onNewChat, onClose, onDeleted } = props;
  const [query, setQuery] = useState('');
  const [showArchived, setShowArchived] = useState(false);
  const [archivedSessions, setArchivedSessions] = useState<ArchivedPickerSession[]>([]);
  const [archivedProjects, setArchivedProjects] = useState<ArchivedPickerProject[]>([]);
  const [archivedLoading, setArchivedLoading] = useState(false);
  const [archivedError, setArchivedError] = useState(false);
  const [accountLabels, setAccountLabels] = useState<Record<string, string>>({});
  const [busyId, setBusyId] = useState<string | null>(null);
  const [pendingDelete, setPendingDelete] = useState<{ id: string; title: string } | null>(null);
  const { isSessionPinned, toggleSessionPinned } = usePinnedSessions();

  useEffect(() => {
    if (!visible) {
      setQuery('');
      setShowArchived(false);
      return;
    }
    api
      .get('/provider-accounts')
      .then((r) => (r.ok ? r.json() : null))
      .then((d) => {
        const accounts = d?.data?.accounts ?? d?.accounts ?? [];
        const map: Record<string, string> = {};
        for (const a of accounts) if (a?.id) map[a.id] = a.label ?? a.id;
        setAccountLabels(map);
      })
      .catch(() => {});
  }, [visible]);

  const loadArchived = useCallback(async () => {
    setArchivedLoading(true);
    setArchivedError(false);
    try {
      const [sessionsRes, projectsRes] = await Promise.all([api.getArchivedSessions(), api.archivedProjects()]);
      const sJson = sessionsRes.ok ? await sessionsRes.json() : null;
      const pJson = projectsRes.ok ? await projectsRes.json() : null;
      setArchivedSessions(sJson?.data?.sessions ?? sJson?.sessions ?? []);
      setArchivedProjects(pJson?.data?.projects ?? pJson?.projects ?? []);
    } catch {
      setArchivedError(true);
    } finally {
      setArchivedLoading(false);
    }
  }, []);

  useEffect(() => {
    if (visible && showArchived) void loadArchived();
  }, [visible, showArchived, loadArchived]);

  const filtered = useMemo(() => filterPickerSessions(sessions, query), [sessions, query]);
  const groups = useMemo(() => groupPickerSessions(filtered), [filtered]);

  const archivedGroups = useMemo(() => {
    const term = query.trim().toLowerCase();
    const kept = term
      ? archivedSessions.filter((s) => `${s.sessionTitle} ${s.projectDisplayName}`.toLowerCase().includes(term))
      : archivedSessions;
    return groupArchivedPickerSessions(kept, archivedProjects);
  }, [archivedSessions, archivedProjects, query]);

  const restoreSession = async (sessionId: string) => {
    setBusyId(sessionId);
    try {
      const res = await api.restoreSession(sessionId);
      if (res.ok) {
        await loadArchived();
        onDeleted?.();
      }
      return res.ok;
    } catch {
      return false;
    } finally {
      setBusyId(null);
    }
  };

  const restoreProject = async (projectId: string) => {
    setBusyId(projectId);
    try {
      const res = await api.restoreProject(projectId);
      if (res.ok) await loadArchived();
      return res.ok;
    } catch {
      return false;
    } finally {
      setBusyId(null);
    }
  };

  const confirmDelete = async () => {
    const target = pendingDelete;
    setPendingDelete(null);
    if (!target) return;
    setBusyId(target.id);
    try {
      const res = await api.deleteSession(target.id, true);
      if (res.ok) {
        await loadArchived();
        onDeleted?.();
      }
    } finally {
      setBusyId(null);
    }
  };

  const renderRow = (session: PickerSession) => {
    const running = Boolean(processingSessionIds?.has(session.id));
    const unread = !running && isPickerSessionUnread(session);
    const title = getPickerSessionTitle(session);
    const pinned = isSessionPinned(session.id);
    const age = formatPickerAge(session.lastActivity);
    const accountId = typeof session.accountId === 'string' ? session.accountId : null;
    const accountLabel = accountId ? accountLabels[accountId] : undefined;
    const active = session.id === currentSessionId;

    return (
      <TouchableOpacity
        key={session.id}
        onPress={() => {
          onSelect(session);
          onClose();
        }}
        onLongPress={() => toggleSessionPinned(session.id)}
        style={{
          flexDirection: 'row',
          alignItems: 'center',
          paddingVertical: 10,
          paddingHorizontal: 12,
          borderRadius: 8,
          backgroundColor: active ? colors.accent : 'transparent',
          marginBottom: 2,
        }}
      >
        <View style={{ flex: 1 }}>
          <View style={{ flexDirection: 'row', alignItems: 'center' }}>
            {session.provider ? (
              <Text style={{ color: colors.mutedForeground, fontSize: 10, marginRight: 6, textTransform: 'uppercase' }}>
                {PROVIDER_LABELS[session.provider] ?? session.provider}
              </Text>
            ) : null}
            <Text style={{ color: colors.foreground, fontSize: 14 }} numberOfLines={1}>
              {title}
            </Text>
          </View>
          <View style={{ flexDirection: 'row', alignItems: 'center', marginTop: 2 }}>
            {session.projectName ? (
              <Text style={{ color: colors.mutedForeground, fontSize: 11, marginRight: 8 }} numberOfLines={1}>
                {session.projectName}
              </Text>
            ) : null}
            {accountLabel ? (
              <Text style={{ color: colors.mutedForeground, fontSize: 10, marginRight: 8 }} numberOfLines={1}>
                {accountLabel}
              </Text>
            ) : null}
            {age ? <Text style={{ color: colors.mutedForeground, fontSize: 10 }}>{age}</Text> : null}
          </View>
        </View>
        {running ? <View style={{ width: 8, height: 8, borderRadius: 4, backgroundColor: '#10b981', marginLeft: 8 }} /> : null}
        {unread ? <View style={{ width: 8, height: 8, borderRadius: 4, backgroundColor: '#0ea5e9', marginLeft: 8 }} /> : null}
        {pinned ? <Pin size={13} color={colors.primary} style={{ marginLeft: 8 }} /> : null}
        <TouchableOpacity
          onPress={() => toggleSessionPinned(session.id)}
          hitSlop={8}
          style={{ padding: 6, marginLeft: 2 }}
        >
          <Star size={15} color={pinned ? '#f59e0b' : colors.mutedForeground} />
        </TouchableOpacity>
        <TouchableOpacity onPress={() => setPendingDelete({ id: session.id, title })} hitSlop={8} style={{ padding: 6 }}>
          <Trash2 size={15} color={colors.mutedForeground} />
        </TouchableOpacity>
      </TouchableOpacity>
    );
  };

  return (
    <Modal visible={visible} transparent animationType="slide" onRequestClose={onClose}>
      <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' }}>
        <View style={{ backgroundColor: colors.card, borderTopLeftRadius: 16, borderTopRightRadius: 16, maxHeight: '85%', paddingBottom: 12 }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', padding: 14, borderBottomWidth: 1, borderBottomColor: colors.border }}>
            <Text style={{ color: colors.foreground, fontWeight: '600', fontSize: 16, flex: 1 }}>Sessions</Text>
            <TouchableOpacity onPress={() => setShowArchived((v) => !v)} hitSlop={8} style={{ padding: 6 }}>
              <Archive size={18} color={showArchived ? colors.primary : colors.mutedForeground} />
            </TouchableOpacity>
            <TouchableOpacity onPress={onClose} hitSlop={8} style={{ padding: 6 }}>
              <X size={18} color={colors.mutedForeground} />
            </TouchableOpacity>
          </View>

          <View style={{ flexDirection: 'row', alignItems: 'center', paddingHorizontal: 12, paddingTop: 10 }}>
            <View style={{ flex: 1, flexDirection: 'row', alignItems: 'center', backgroundColor: colors.background, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 8 }}>
              <Search size={14} color={colors.mutedForeground} />
              <TextInput
                value={query}
                onChangeText={setQuery}
                placeholder="Search sessions…"
                placeholderTextColor={colors.mutedForeground}
                style={{ flex: 1, color: colors.foreground, paddingVertical: 8, paddingHorizontal: 6 }}
              />
            </View>
            <TouchableOpacity
              onPress={() => {
                onNewChat();
                onClose();
              }}
              style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: colors.accent, borderRadius: 8, paddingHorizontal: 10, paddingVertical: 8, marginLeft: 8 }}
            >
              <MessageSquarePlus size={15} color={colors.foreground} />
              <Text style={{ color: colors.foreground, fontSize: 13, marginLeft: 4 }}>New</Text>
            </TouchableOpacity>
          </View>

          {showArchived ? (
            <ScrollView style={{ paddingHorizontal: 10, marginTop: 8 }}>
              {archivedLoading ? (
                <ActivityIndicator color={colors.primary} style={{ marginTop: 24 }} />
              ) : archivedError ? (
                <TouchableOpacity onPress={() => void loadArchived()} style={{ alignItems: 'center', padding: 24 }}>
                  <Text style={{ color: colors.destructive, marginBottom: 6 }}>Failed to load archived sessions.</Text>
                  <Text style={{ color: colors.primary }}>Retry</Text>
                </TouchableOpacity>
              ) : archivedGroups.length === 0 ? (
                <Text style={{ color: colors.mutedForeground, textAlign: 'center', marginTop: 24 }}>No archived sessions</Text>
              ) : (
                archivedGroups.map((group) => (
                  <View key={group.key} style={{ marginBottom: 12 }}>
                    <View style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 8 }}>
                      <Folder size={14} color={colors.mutedForeground} />
                      <Text style={{ color: colors.foreground, fontSize: 13, fontWeight: '600', marginLeft: 6, flex: 1 }} numberOfLines={1}>
                        {group.projectDisplayName}
                      </Text>
                      {group.isProjectArchived && group.projectId ? (
                        <TouchableOpacity
                          onPress={() => void restoreProject(group.projectId as string)}
                          disabled={busyId === group.projectId}
                          style={{ flexDirection: 'row', alignItems: 'center' }}
                        >
                          <RotateCcw size={13} color={colors.primary} />
                          <Text style={{ color: colors.primary, fontSize: 12, marginLeft: 4 }}>Restore project</Text>
                        </TouchableOpacity>
                      ) : null}
                    </View>
                    {group.sessions.length === 0 ? (
                      <Text style={{ color: colors.mutedForeground, fontSize: 12, paddingLeft: 20 }}>Project archived, no sessions</Text>
                    ) : (
                      group.sessions.map((s) => (
                        <View key={s.sessionId} style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 10, paddingHorizontal: 12, backgroundColor: colors.background, borderRadius: 8, marginBottom: 4 }}>
                          <View style={{ flex: 1 }}>
                            <Text style={{ color: colors.foreground, fontSize: 14 }} numberOfLines={1}>
                              {s.sessionTitle}
                            </Text>
                            <Text style={{ color: colors.mutedForeground, fontSize: 11, marginTop: 2 }}>
                              {[formatPickerAge(s.lastActivity), s.messageCount ? `${s.messageCount} messages` : null].filter(Boolean).join(' · ')}
                            </Text>
                          </View>
                          <TouchableOpacity onPress={() => void restoreSession(s.sessionId)} disabled={busyId === s.sessionId} style={{ padding: 6 }}>
                            {busyId === s.sessionId ? (
                              <ActivityIndicator size="small" color={colors.primary} />
                            ) : (
                              <RotateCcw size={16} color={colors.primary} />
                            )}
                          </TouchableOpacity>
                          <TouchableOpacity onPress={() => setPendingDelete({ id: s.sessionId, title: s.sessionTitle })} style={{ padding: 6 }}>
                            <Trash2 size={16} color={colors.mutedForeground} />
                          </TouchableOpacity>
                        </View>
                      ))
                    )}
                  </View>
                ))
              )}
            </ScrollView>
          ) : (
            <ScrollView style={{ paddingHorizontal: 10, marginTop: 6 }}>
              {groups.currentProject.length > 0 ? (
                <>
                  <Text style={{ color: colors.mutedForeground, fontSize: 11, textTransform: 'uppercase', paddingVertical: 8, paddingHorizontal: 4 }}>
                    {groups.currentProjectName ? `Current project (${groups.currentProjectName})` : 'Current project'}
                  </Text>
                  {groups.currentProject.map(renderRow)}
                </>
              ) : null}
              {groups.otherProjects.length > 0 ? (
                <>
                  <Text style={{ color: colors.mutedForeground, fontSize: 11, textTransform: 'uppercase', paddingVertical: 8, paddingHorizontal: 4 }}>
                    {groups.currentProject.length > 0 ? 'Other projects' : 'Recent sessions'}
                  </Text>
                  {groups.otherProjects.map(renderRow)}
                </>
              ) : null}
              {filtered.length === 0 ? (
                <Text style={{ color: colors.mutedForeground, textAlign: 'center', marginTop: 24 }}>
                  {query.trim() ? 'No sessions match your search' : 'No other sessions'}
                </Text>
              ) : null}
            </ScrollView>
          )}
        </View>
      </View>

      <ActionSheet
        visible={pendingDelete !== null}
        title={pendingDelete?.title}
        items={[
          { label: 'Delete permanently', destructive: true, onPress: () => void confirmDelete() },
        ]}
        onClose={() => setPendingDelete(null)}
      />
    </Modal>
  );
}

// --- Draft-pane empty state ------------------------------------------------

export interface DraftPaneEmptyStateProps {
  colors: ThemeColors;
  providers: string[];
  provider?: string;
  onSelectProvider: (provider: string) => void;
  models: { value: string; label: string }[];
  model?: string | null;
  onSelectModel: (model: string) => void;
  projects: { projectId: string; displayName?: string; name?: string; path?: string; fullPath?: string }[];
  selectedProjectId?: string;
  onSelectWorkspace: (project: { projectId: string; path?: string; fullPath?: string }) => void;
  nextTask?: { id: string | number; title: string } | null;
  onStartTask?: (task: { id: string | number; title: string }) => void;
}

/** Draft-pane provider/model/workspace chooser (web `ProviderSelectionEmptyState`). */
export function DraftPaneEmptyState(props: DraftPaneEmptyStateProps) {
  const { colors, providers, provider, onSelectProvider, models, model, onSelectModel, projects, selectedProjectId, onSelectWorkspace, nextTask, onStartTask } = props;
  const [providerSheet, setProviderSheet] = useState(false);
  const [modelSheet, setModelSheet] = useState(false);
  const [workspaceSheet, setWorkspaceSheet] = useState(false);

  const activeProject = projects.find((p) => p.projectId === selectedProjectId);
  const providerLabel = provider ? PROVIDER_LABELS[provider] ?? provider : 'Select provider';
  const modelLabel = models.find((m) => m.value === model)?.label ?? model ?? 'Select model';

  const card = (icon: React.ReactNode, label: string, value: string, onPress: () => void) => (
    <TouchableOpacity
      onPress={onPress}
      style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: colors.card, borderColor: colors.border, borderWidth: 1, borderRadius: 10, padding: 14, marginBottom: 10 }}
    >
      {icon}
      <View style={{ flex: 1, marginLeft: 10 }}>
        <Text style={{ color: colors.mutedForeground, fontSize: 11, textTransform: 'uppercase' }}>{label}</Text>
        <Text style={{ color: colors.foreground, fontSize: 15, marginTop: 2 }} numberOfLines={1}>
          {value}
        </Text>
      </View>
      <ChevronDown size={16} color={colors.mutedForeground} />
    </TouchableOpacity>
  );

  return (
    <ScrollView contentContainerStyle={{ padding: 16 }}>
      <Text style={{ color: colors.foreground, fontSize: 20, fontWeight: '600', marginBottom: 4 }}>Start a conversation</Text>
      <Text style={{ color: colors.mutedForeground, fontSize: 13, marginBottom: 16 }}>
        Pick a provider, model and workspace to begin.
      </Text>
      {card(<Star size={18} color={colors.primary} />, 'Provider', providerLabel, () => setProviderSheet(true))}
      {models.length > 0 ? card(<Pin size={18} color={colors.primary} />, 'Model', modelLabel, () => setModelSheet(true)) : null}
      {projects.length > 0 ? (
        card(
          <FolderOpen size={18} color={colors.primary} />,
          'Workspace',
          activeProject?.displayName || activeProject?.name || 'No workspace',
          () => setWorkspaceSheet(true),
        )
      ) : null}
      {nextTask && onStartTask ? (
        <TouchableOpacity
          onPress={() => onStartTask(nextTask)}
          style={{ backgroundColor: colors.accent, borderRadius: 10, padding: 14, marginTop: 6, flexDirection: 'row', alignItems: 'center' }}
        >
          <Text style={{ color: colors.foreground, fontSize: 14, flex: 1 }} numberOfLines={1}>
            Next task: {nextTask.title}
          </Text>
          <Text style={{ color: colors.primary, fontSize: 13 }}>Start</Text>
        </TouchableOpacity>
      ) : null}

      <ActionSheet
        visible={providerSheet}
        title="Provider"
        items={providers.map((p) => ({
          label: PROVIDER_LABELS[p] ?? p,
          onPress: () => {
            setProviderSheet(false);
            onSelectProvider(p);
          },
        }))}
        onClose={() => setProviderSheet(false)}
      />
      <ActionSheet
        visible={modelSheet}
        title="Model"
        items={models.map((m) => ({
          label: m.label,
          onPress: () => {
            setModelSheet(false);
            onSelectModel(m.value);
          },
        }))}
        onClose={() => setModelSheet(false)}
      />
      <ActionSheet
        visible={workspaceSheet}
        title="Workspace"
        items={projects.map((p) => ({
          label: p.displayName || p.name || p.path || p.projectId,
          onPress: () => {
            setWorkspaceSheet(false);
            onSelectWorkspace(p);
          },
        }))}
        onClose={() => setWorkspaceSheet(false)}
      />
    </ScrollView>
  );
}

// --- Change-workspace dialog ----------------------------------------------

export interface WorkspaceDialogProps {
  visible: boolean;
  colors: ThemeColors;
  currentPath?: string;
  onClose: () => void;
  onSubmit: (projectPath: string) => Promise<{ ok: boolean; error?: string }>;
}

export function SessionWorkspaceDialog({ visible, colors, currentPath, onClose, onSubmit }: WorkspaceDialogProps) {
  const [path, setPath] = useState(currentPath ?? '');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (visible) {
      setPath(currentPath ?? '');
      setError(null);
    }
  }, [visible, currentPath]);

  const submit = async () => {
    const trimmed = path.trim();
    if (!trimmed) {
      setError('Workspace path is required');
      return;
    }
    setSaving(true);
    setError(null);
    const result = await onSubmit(trimmed);
    setSaving(false);
    if (result.ok) onClose();
    else setError(result.error ?? 'Failed to change workspace');
  };

  return (
    <Modal visible={visible} transparent animationType="fade" onRequestClose={onClose}>
      <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', alignItems: 'center', justifyContent: 'center', padding: 24 }}>
        <View style={{ backgroundColor: colors.card, borderRadius: 12, padding: 20, width: '100%' }}>
          <Text style={{ color: colors.foreground, fontWeight: '600', marginBottom: 6 }}>Change workspace</Text>
          <Text style={{ color: colors.mutedForeground, fontSize: 12, marginBottom: 12 }}>
            Later turns run with the new working directory.
          </Text>
          <TextInput
            value={path}
            onChangeText={setPath}
            autoCapitalize="none"
            autoCorrect={false}
            placeholder="/path/to/workspace"
            placeholderTextColor={colors.mutedForeground}
            style={{ backgroundColor: colors.background, color: colors.foreground, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10 }}
          />
          {error ? <Text style={{ color: colors.destructive, fontSize: 12, marginTop: 8 }}>{error}</Text> : null}
          <View style={{ flexDirection: 'row', justifyContent: 'flex-end', gap: 12, marginTop: 16 }}>
            <TouchableOpacity onPress={onClose} disabled={saving}>
              <Text style={{ color: colors.mutedForeground, padding: 8 }}>Cancel</Text>
            </TouchableOpacity>
            <TouchableOpacity onPress={() => void submit()} disabled={saving}>
              {saving ? (
                <ActivityIndicator size="small" color={colors.primary} style={{ padding: 8 }} />
              ) : (
                <Text style={{ color: colors.primary, fontWeight: '600', padding: 8 }}>Save</Text>
              )}
            </TouchableOpacity>
          </View>
        </View>
      </View>
    </Modal>
  );
}

export type { ActionSheetItem };
