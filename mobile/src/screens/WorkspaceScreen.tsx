import React, { useCallback, useEffect, useMemo, useState } from 'react';
import {
  Modal,
  ScrollView,
  Text,
  TouchableOpacity,
  useWindowDimensions,
  View,
} from 'react-native';
import { useNavigation, useRoute } from '@react-navigation/native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import {
  Globe,
  LayoutGrid,
  Megaphone,
  MessageSquarePlus,
  MonitorPlay,
  MousePointerClick,
  NotebookPen,
  Terminal,
  X,
} from 'lucide-react-native';
import { api } from '~shared/utils/api';
import { useTheme } from '../theme';
import { useWorkspace } from '../contexts/WorkspaceContext';
import {
  kindLabel,
  paneDisplayTitle,
  type PaneKind,
  type WorkspacePane,
} from '../lib/workspace-panes';
import {
  BroadcastDialog,
  BrowserPane,
  NotesPane,
  PreviewPane,
  TerminalPane,
} from '../components/Panes';
import BrowserSessionsPane from '../components/BrowserSessionsPane';
import { ActionSheet, ActionSheetItem } from '../components/ActionSheet';
import { Toast, useToast } from '../components/Toast';

interface ProjectOption {
  projectId: string;
  displayName: string;
  fullPath?: string;
  path?: string;
}

interface SessionOption {
  sessionId: string;
  title: string;
  projectName?: string | null;
  isArchived?: boolean;
}

export default function WorkspaceScreen() {
  const { colors } = useTheme();
  const insets = useSafeAreaInsets();
  const { width, height } = useWindowDimensions();
  const navigation = useNavigation<any>();
  const route = useRoute<any>();
  const { toast, show: showToast } = useToast();
  const workspace = useWorkspace();

  const mobileTabMode = workspace.panes.length > 1;

  const [projects, setProjects] = useState<ProjectOption[]>([]);
  const [sessions, setSessions] = useState<SessionOption[]>([]);
  const [overviewOpen, setOverviewOpen] = useState(false);
  const [broadcastOpen, setBroadcastOpen] = useState(false);
  const [paneMenu, setPaneMenu] = useState<string | null>(null);

  const projectById = useMemo(() => {
    const map = new Map<string, ProjectOption>();
    projects.forEach((p) => map.set(p.projectId, p));
    return map;
  }, [projects]);

  const sessionById = useMemo(() => {
    const map = new Map<string, SessionOption>();
    sessions.forEach((s) => map.set(s.sessionId, s));
    return map;
  }, [sessions]);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      try {
        const res = await api.projects();
        const arr = Array.isArray(res) ? res : ((res as any)?.data?.projects ?? (res as any)?.projects ?? []);
        if (cancelled) return;
        setProjects(
          (arr as any[]).map((p) => ({
            projectId: p.projectId ?? p.id,
            displayName: p.displayName ?? p.name ?? p.projectId ?? p.id,
            fullPath: p.fullPath,
            path: p.path,
          })),
        );
      } catch {
        /* ignore */
      }
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  useEffect(() => {
    let cancelled = false;
    (async () => {
      try {
        const res = await api.recentConversations({ limit: 50 });
        const payload = (res as any)?.data?.conversations ?? (res as any)?.conversations ?? res;
        const arr = Array.isArray(payload) ? payload : [];
        if (cancelled) return;
        setSessions(
          (arr as any[]).map((s) => ({
            sessionId: s.sessionId ?? s.id,
            title: s.summary || s.title || s.name || String(s.sessionId ?? s.id).slice(0, 8),
            projectName: s.projectName ?? s.project?.displayName ?? null,
            isArchived: Boolean(s.isArchived),
          })),
        );
      } catch {
        /* ignore */
      }
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  useEffect(() => {
    const kind = route.params?.initialKind as PaneKind | undefined;
    if (!kind) return;
    const projectId = (route.params?.projectId as string | undefined) ?? workspace.lastUsedProjectId ?? undefined;
    workspace.openPane(kind, { projectId: projectId ?? null });
    navigation.setParams({ initialKind: undefined } as never);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [route.params?.initialKind]);

  const displayFor = useCallback(
    (pane: WorkspacePane) => {
      const session = pane.sessionId ? sessionById.get(pane.sessionId) : undefined;
      const project = pane.projectId ? projectById.get(pane.projectId) : undefined;
      return paneDisplayTitle(pane, {
        sessionTitle: session?.title ?? null,
        projectName: project?.displayName ?? project?.fullPath ?? project?.path ?? null,
        url: pane.url ?? null,
      });
    },
    [sessionById, projectById],
  );

  const addPane = (kind: PaneKind) => {
    if (!workspace.canAdd) {
      showToast('Maximum of 6 panes reached', 'error');
      return;
    }
    const projectId = workspace.lastUsedProjectId ?? projects[0]?.projectId ?? null;
    if (kind === 'chat') workspace.openPane('chat', { projectId, picker: true });
    else workspace.openPane(kind, { projectId });
  };

  const closePane = (id: string) => workspace.removePane(id);

  const movePane = (id: string, dir: -1 | 1) => {
    const index = workspace.panes.findIndex((p) => p.id === id);
    if (index < 0) return;
    workspace.reorderPanes(id, index + dir);
  };

  const renderPane = (pane: WorkspacePane, isActive: boolean) => {
    switch (pane.kind) {
      case 'browser':
        return (
          <BrowserPane
            url={pane.url ?? null}
            isActive={isActive}
            colors={colors}
            onUrlChange={(url) => workspace.updatePane(pane.id, { url })}
          />
        );
      case 'terminal':
        return <TerminalPane projectId={pane.projectId ?? null} isActive={isActive} colors={colors} />;
      case 'preview': {
        const project = pane.projectId ? projectById.get(pane.projectId) : undefined;
        return (
          <PreviewPane
            projectId={pane.projectId ?? null}
            projectPath={project?.fullPath ?? project?.path ?? null}
            isActive={isActive}
            colors={colors}
          />
        );
      }
      case 'notes':
        return <NotesPane projectId={pane.projectId ?? null} isActive={isActive} colors={colors} />;
      case 'browseruse':
        return <BrowserSessionsPane isVisible={isActive} />;
      case 'chat':
      default:
        return <ChatPane pane={pane} colors={colors} projects={projects} navigation={navigation} />;
    }
  };

  const activePane = workspace.panes.find((p) => p.id === workspace.activePaneId) ?? workspace.panes[0];
  const overviewPanes = workspace.panes.map((p) => ({ ...displayFor(p), id: p.id, kind: p.kind }));

  const visiblePanes = mobileTabMode && activePane ? [activePane] : workspace.panes;
  const layout = workspace.layout;
  const gap = 2;
  const gridWidth = width - gap * (layout.columns - 1);
  const paneWidth = gridWidth / layout.columns;
  const gridHeight = height - insets.top - insets.bottom - 88;
  const paneHeight = gridHeight / layout.rows;

  return (
    <View style={{ flex: 1, backgroundColor: colors.background }}>
      <View
        style={{
          height: 44,
          flexDirection: 'row',
          alignItems: 'center',
          gap: 6,
          paddingHorizontal: 8,
          borderBottomWidth: 1,
          borderBottomColor: colors.border,
        }}
      >
        <ToolbarButton icon={MessageSquarePlus} colors={colors} disabled={!workspace.canAdd} onPress={() => addPane('chat')} />
        <ToolbarButton icon={Globe} colors={colors} disabled={!workspace.canAdd} onPress={() => addPane('browser')} />
        <ToolbarButton icon={Terminal} colors={colors} disabled={!workspace.canAdd} onPress={() => addPane('terminal')} />
        <ToolbarButton icon={MonitorPlay} colors={colors} disabled={!workspace.canAdd} onPress={() => addPane('preview')} />
        <ToolbarButton icon={MousePointerClick} colors={colors} disabled={!workspace.canAdd} onPress={() => addPane('browseruse')} />
        <ToolbarButton icon={NotebookPen} colors={colors} disabled={!workspace.canAdd} onPress={() => addPane('notes')} />
        <ToolbarButton icon={Megaphone} colors={colors} onPress={() => setBroadcastOpen(true)} />
        <View style={{ flex: 1 }} />
        <ToolbarButton icon={LayoutGrid} colors={colors} active={overviewOpen} onPress={() => setOverviewOpen(true)} />
      </View>

      {mobileTabMode ? (
        <View style={{ flex: 1 }}>
          <ScrollView
            horizontal
            showsHorizontalScrollIndicator={false}
            style={{ maxHeight: 40, borderBottomWidth: 1, borderBottomColor: colors.border }}
            contentContainerStyle={{ alignItems: 'center', paddingHorizontal: 6 }}
          >
            {workspace.panes.map((pane) => {
              const isActive = pane.id === activePane?.id;
              return (
                <TouchableOpacity
                  key={pane.id}
                  onPress={() => workspace.setActivePaneId(pane.id)}
                  onLongPress={() => setPaneMenu(pane.id)}
                  style={{
                    flexDirection: 'row',
                    alignItems: 'center',
                    gap: 6,
                    paddingHorizontal: 10,
                    paddingVertical: 6,
                    marginRight: 4,
                    borderRadius: 8,
                    backgroundColor: isActive ? colors.accent : 'transparent',
                  }}
                >
                  <Text style={{ color: isActive ? colors.foreground : colors.mutedForeground, fontSize: 12 }}>
                    {displayFor(pane).title}
                  </Text>
                  <TouchableOpacity onPress={() => closePane(pane.id)} hitSlop={6}>
                    <X size={12} color={colors.mutedForeground} />
                  </TouchableOpacity>
                </TouchableOpacity>
              );
            })}
          </ScrollView>
          {activePane ? <View style={{ flex: 1 }}>{renderPane(activePane, true)}</View> : null}
        </View>
      ) : (
        <ScrollView contentContainerStyle={{ flexDirection: 'row', flexWrap: 'wrap', gap }}>
          {visiblePanes.map((pane) => {
            const isActive = pane.id === workspace.activePaneId;
            return (
              <View
                key={pane.id}
                style={{
                  width: paneWidth,
                  height: paneHeight,
                  backgroundColor: colors.card,
                  borderWidth: isActive ? 2 : 1,
                  borderColor: isActive ? colors.primary : colors.border,
                  borderRadius: 6,
                  overflow: 'hidden',
                }}
              >
                <View
                  style={{
                    flexDirection: 'row',
                    alignItems: 'center',
                    gap: 6,
                    paddingHorizontal: 8,
                    paddingVertical: 4,
                    borderBottomWidth: 1,
                    borderBottomColor: colors.border,
                  }}
                >
                  <Text style={{ flex: 1, color: colors.foreground, fontSize: 11, fontWeight: '600' }} numberOfLines={1}>
                    {kindLabel(pane.kind)} · {displayFor(pane).title}
                  </Text>
                  <TouchableOpacity onPress={() => setPaneMenu(pane.id)} hitSlop={6}>
                    <LayoutGrid size={12} color={colors.mutedForeground} />
                  </TouchableOpacity>
                  <TouchableOpacity onPress={() => closePane(pane.id)} hitSlop={6}>
                    <X size={12} color={colors.mutedForeground} />
                  </TouchableOpacity>
                </View>
                <TouchableOpacity activeOpacity={1} onPress={() => workspace.setActivePaneId(pane.id)} style={{ flex: 1 }}>
                  {renderPane(pane, isActive)}
                </TouchableOpacity>
              </View>
            );
          })}
        </ScrollView>
      )}

      <ActionSheet
        visible={paneMenu !== null}
        title="Pane"
        onClose={() => setPaneMenu(null)}
        items={(() => {
          const index = paneMenu ? workspace.panes.findIndex((p) => p.id === paneMenu) : -1;
          const items: ActionSheetItem[] = [];
          if (index > 0) items.push({ label: 'Move left', onPress: () => paneMenu && movePane(paneMenu, -1) });
          if (index >= 0 && index < workspace.panes.length - 1)
            items.push({ label: 'Move right', onPress: () => paneMenu && movePane(paneMenu, 1) });
          items.push({ label: 'Close pane', destructive: true, onPress: () => paneMenu && closePane(paneMenu) });
          return items;
        })()}
      />

      <Modal visible={overviewOpen} transparent animationType="fade" onRequestClose={() => setOverviewOpen(false)}>
        <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', padding: 20 }}>
          <View style={{ backgroundColor: colors.card, borderRadius: 14, padding: 16, maxHeight: '80%' }}>
            <View style={{ flexDirection: 'row', alignItems: 'center', marginBottom: 10 }}>
              <Text style={{ flex: 1, color: colors.foreground, fontSize: 15, fontWeight: '600' }}>
                Workspace panes ({workspace.panes.length})
              </Text>
              <TouchableOpacity onPress={() => setOverviewOpen(false)} hitSlop={8}>
                <X size={18} color={colors.mutedForeground} />
              </TouchableOpacity>
            </View>
            <ScrollView>
              {overviewPanes.map((p) => {
                const isActive = p.id === workspace.activePaneId;
                return (
                  <TouchableOpacity
                    key={p.id}
                    onPress={() => {
                      workspace.setActivePaneId(p.id);
                      setOverviewOpen(false);
                    }}
                    style={{
                      flexDirection: 'row',
                      alignItems: 'center',
                      gap: 10,
                      padding: 12,
                      borderRadius: 10,
                      borderWidth: 1,
                      borderColor: isActive ? colors.primary : colors.border,
                      marginBottom: 8,
                    }}
                  >
                    <KindIcon kind={p.kind} color={colors.foreground} />
                    <View style={{ flex: 1 }}>
                      <Text style={{ color: colors.foreground, fontSize: 13 }}>{p.title}</Text>
                      {p.subtitle ? (
                        <Text style={{ color: colors.mutedForeground, fontSize: 11 }} numberOfLines={1}>
                          {p.subtitle}
                        </Text>
                      ) : null}
                    </View>
                    {isActive ? <Text style={{ color: colors.primary, fontSize: 11 }}>Active</Text> : null}
                  </TouchableOpacity>
                );
              })}
            </ScrollView>
          </View>
        </View>
      </Modal>

      <BroadcastDialog
        visible={broadcastOpen}
        colors={colors}
        sessions={sessions}
        onClose={() => setBroadcastOpen(false)}
        onSent={({ ok, failed }) =>
          showToast(
            failed > 0 ? `Sent to ${ok}, ${failed} failed` : `Sent to ${ok} session${ok === 1 ? '' : 's'}`,
            failed > 0 ? 'error' : 'success',
          )
        }
      />

      {toast ? <Toast toast={toast} /> : null}
    </View>
  );
}

function ChatPane({
  pane,
  colors,
  projects,
  navigation,
}: {
  pane: WorkspacePane;
  colors: any;
  projects: ProjectOption[];
  navigation: any;
}) {
  const [sheet, setSheet] = useState(false);
  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', padding: 16, gap: 10 }}>
      <MessageSquarePlus size={22} color={colors.mutedForeground} />
      <Text style={{ color: colors.mutedForeground, fontSize: 12, textAlign: 'center' }}>
        {pane.sessionId ? 'Chat pane' : 'Pick a session or workspace for this pane'}
      </Text>
      <TouchableOpacity
        onPress={() => setSheet(true)}
        style={{ backgroundColor: colors.primary, borderRadius: 8, paddingHorizontal: 14, paddingVertical: 8 }}
      >
        <Text style={{ color: colors.primaryForeground, fontSize: 12 }}>Open</Text>
      </TouchableOpacity>
      <ActionSheet
        visible={sheet}
        title="Chat pane"
        onClose={() => setSheet(false)}
        items={[
          ...(pane.sessionId
            ? [
                {
                  label: 'Open full chat',
                  onPress: () =>
                    navigation.navigate('Chat', { sessionId: pane.sessionId, projectId: pane.projectId ?? undefined }),
                },
              ]
            : []),
          ...projects.slice(0, 5).map((p) => ({
            label: `New session · ${p.displayName}`,
            onPress: () =>
              navigation.navigate('Chat', {
                newSession: true,
                projectId: p.projectId,
                projectPath: p.fullPath ?? p.path,
              }),
          })),
        ]}
      />
    </View>
  );
}

function KindIcon({ kind, color }: { kind: PaneKind; color: string }) {
  switch (kind) {
    case 'browser':
      return <Globe size={18} color={color} />;
    case 'terminal':
      return <Terminal size={18} color={color} />;
    case 'preview':
      return <MonitorPlay size={18} color={color} />;
    case 'notes':
      return <NotebookPen size={18} color={color} />;
    case 'browseruse':
      return <MousePointerClick size={18} color={color} />;
    case 'chat':
    default:
      return <MessageSquarePlus size={18} color={color} />;
  }
}

function ToolbarButton({
  icon: Icon,
  colors,
  onPress,
  disabled,
  active,
}: {
  icon: React.ComponentType<{ size?: number; color?: string }>;
  colors: any;
  onPress: () => void;
  disabled?: boolean;
  active?: boolean;
}) {
  return (
    <TouchableOpacity
      onPress={onPress}
      disabled={disabled}
      style={{
        width: 34,
        height: 34,
        borderRadius: 8,
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: active ? colors.accent : 'transparent',
        opacity: disabled ? 0.4 : 1,
      }}
    >
      <Icon size={18} color={active ? colors.primary : colors.foreground} />
    </TouchableOpacity>
  );
}
