/**
 * Native command palette + global search (T29).
 *
 * Mirrors the web `src/components/command-palette/CommandPalette.tsx`: a
 * searchable sheet with Actions / Navigate / Settings / Sessions / Files /
 * Commits / Branches groups, a live session-message search (SSE), and a
 * session token/cost compare page. Opened from the Home header in
 * `ProjectsScreen` (no hardware-keyboard shortcut on mobile).
 */
import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import {
  ActivityIndicator,
  Modal,
  ScrollView,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTranslation } from 'react-i18next';
import {
  ArrowLeft,
  FileText,
  GitBranch,
  GitCommitHorizontal,
  LogIn,
  MessageSquare,
  Search,
  Settings as SettingsIcon,
  Star,
  X,
} from 'lucide-react-native';
import { api, getStoredAuthToken } from '~shared/utils/api';
import { useTheme } from '../theme';
import { ActionSheet, type ActionSheetItem } from './ActionSheet';
import { streamSse } from '../lib/sse';
import { getServerUrlSync } from '../lib/server-config';
import {
  BROWSE_LIMIT,
  PALETTE_NAV_ITEMS,
  SEARCH_DEBOUNCE_MS,
  SEARCH_MIN_QUERY,
  buildSessionSearchUrl,
  drawerRouteForTarget,
  flattenPaletteFiles,
  formatCostUsd,
  matchesQuery,
  mergeSessionMatches,
  mobileSettingsTab,
  parseBranchRows,
  parseCommitRows,
  parseProjectSessions,
  parseSessionSearchResult,
  usageFromTokenUsage,
  type BranchRow,
  type CommitRow,
  type FileRow,
  type MessageMatch,
  type PalettePage,
  type SessionRow,
  type TokenUsageSummary,
} from '../lib/command-palette';

const SETTINGS_TABS: { id: string; labelKey: string }[] = [
  { id: 'agents', labelKey: 'agents' },
  { id: 'appearance', labelKey: 'appearance' },
  { id: 'workspaces', labelKey: 'workspaces' },
  { id: 'schedules', labelKey: 'schedules' },
  { id: 'git', labelKey: 'git' },
  { id: 'api', labelKey: 'apiTokens' },
  { id: 'tasks', labelKey: 'tasks' },
  { id: 'browser', labelKey: 'browser' },
  { id: 'notifications', labelKey: 'notifications' },
  { id: 'quota', labelKey: 'quota' },
  { id: 'about', labelKey: 'about' },
];

interface ProjectOption {
  id: string;
  displayName: string;
}

export interface CommandPaletteProps {
  visible: boolean;
  projectId?: string | null;
  onClose: () => void;
}

export default function CommandPalette({ visible, projectId, onClose }: CommandPaletteProps) {
  const { colors } = useTheme();
  const insets = useSafeAreaInsets();
  const navigation = useNavigation<any>();
  const { t } = useTranslation(['common', 'settings']);
  const tt = (key: string, fallback?: string, opts?: Record<string, unknown>) =>
    String(t(key, { defaultValue: fallback, ...(opts ?? {}) }));
  const inputRef = useRef<TextInput>(null);

  const [query, setQuery] = useState('');
  const [page, setPage] = useState<PalettePage | null>(null);
  const [projects, setProjects] = useState<ProjectOption[]>([]);
  const [activeProjectId, setActiveProjectId] = useState<string | null>(projectId ?? null);
  const [sessions, setSessions] = useState<SessionRow[]>([]);
  const [matches, setMatches] = useState<MessageMatch[]>([]);
  const [files, setFiles] = useState<FileRow[]>([]);
  const [commits, setCommits] = useState<CommitRow[]>([]);
  const [branches, setBranches] = useState<BranchRow[]>([]);
  const [projectSheet, setProjectSheet] = useState(false);
  const [compare, setCompare] = useState<[string, string]>([
    sessions[0]?.id ?? '',
    sessions[1]?.id ?? '',
  ]);
  const [comparePick, setComparePick] = useState<0 | 1 | null>(null);
  const [usage, setUsage] = useState<[TokenUsageSummary | null, TokenUsageSummary | null]>([null, null]);
  const [compareBusy, setCompareBusy] = useState(false);
  const activeStream = useRef<{ abort: () => void } | null>(null);

  const effectiveProjectId = activeProjectId ?? projects[0]?.id ?? null;

  const reset = useCallback(() => {
    setQuery('');
    setPage(null);
    setMatches([]);
  }, []);

  // Reset every time the sheet opens.
  useEffect(() => {
    if (visible) {
      setActiveProjectId(projectId ?? null);
      setSessions([]);
      setMatches([]);
      setPage(null);
      setQuery('');
      setTimeout(() => inputRef.current?.focus(), 250);
    }
  }, [visible, projectId]);

  // Projects list (for the project chip).
  useEffect(() => {
    if (!visible) return;
    let cancelled = false;
    api
      .projects()
      .then((res) => res.json())
      .then((payload) => {
        if (cancelled) return;
        const list = Array.isArray(payload) ? payload : payload?.data?.projects ?? payload?.projects ?? [];
        const mapped = (list as any[])
          .map((p) => ({ id: String(p.id ?? p.projectId ?? ''), displayName: p.displayName ?? p.name ?? p.path ?? '' }))
          .filter((p) => p.id);
        setProjects(mapped);
      })
      .catch(() => {});
    return () => {
      cancelled = true;
    };
  }, [visible]);

  // Sessions source.
  useEffect(() => {
    if (!visible || !effectiveProjectId) return;
    let cancelled = false;
    api
      .projectSessions(effectiveProjectId, { limit: 200, offset: 0 })
      .then((res) => res.json())
      .then((payload) => {
        if (!cancelled) setSessions(parseProjectSessions(payload, effectiveProjectId));
      })
      .catch(() => {});
    return () => {
      cancelled = true;
    };
  }, [visible, effectiveProjectId]);

  // Files source.
  useEffect(() => {
    if (!visible || !effectiveProjectId) return;
    let cancelled = false;
    api
      .get(`/file-tree/projects/${encodeURIComponent(effectiveProjectId)}/files?respectGitignore=true`)
      .then((res) => res.json())
      .then((payload) => {
        if (!cancelled) setFiles(flattenPaletteFiles(Array.isArray(payload) ? payload : []));
      })
      .catch(() => {});
    return () => {
      cancelled = true;
    };
  }, [visible, effectiveProjectId]);

  // Commits + branches (only needed on their pages).
  useEffect(() => {
    if (!visible || !effectiveProjectId || (page !== 'commits' && page !== 'branches')) return;
    let cancelled = false;
    api
      .get(`/git/commits?project=${encodeURIComponent(effectiveProjectId)}&limit=50`)
      .then((res) => res.json())
      .then((payload) => {
        if (!cancelled) setCommits(parseCommitRows(payload));
      })
      .catch(() => {});
    api
      .get(`/git/branches?project=${encodeURIComponent(effectiveProjectId)}`)
      .then((res) => res.json())
      .then((payload) => {
        if (!cancelled) setBranches(parseBranchRows(payload));
      })
      .catch(() => {});
    return () => {
      cancelled = true;
    };
  }, [visible, effectiveProjectId, page]);

  // Live session-message search (SSE).
  useEffect(() => {
    const q = query.trim();
    if (!visible || !effectiveProjectId || q.length < SEARCH_MIN_QUERY) {
      setMatches([]);
      return;
    }
    if (page && page !== 'sessions') return;
    const timer = setTimeout(() => {
      const url = buildSessionSearchUrl(getServerUrlSync(), q, getStoredAuthToken());
      const handle = streamSse(url, {
        onEvent: (event) => {
          if (event.event !== 'result') return;
          try {
            const payload = JSON.parse(event.data);
            const found = parseSessionSearchResult(payload, effectiveProjectId);
            if (found.length) setMatches((prev) => (prev.length ? [...prev, ...found] : found));
          } catch {
            // ignore malformed frames
          }
        },
      });
      activeStream.current = handle;
    }, SEARCH_DEBOUNCE_MS);
    return () => {
      clearTimeout(timer);
      activeStream.current?.abort();
      activeStream.current = null;
    };
  }, [visible, query, effectiveProjectId, page]);

  const close = useCallback(() => {
    reset();
    onClose();
  }, [onClose, reset]);

  const openTab = useCallback(
    (target: string) => {
      close();
      navigation.navigate('Main', { screen: target });
    },
    [close, navigation],
  );

  const openSession = useCallback(
    (session: SessionRow) => {
      close();
      navigation.navigate('Chat', {
        sessionId: session.id,
        title: session.label,
        provider: session.provider,
        projectId: session.projectId ?? effectiveProjectId ?? undefined,
      });
    },
    [close, navigation, effectiveProjectId],
  );

  const openSettings = useCallback(
    (tab?: string) => {
      close();
      navigation.navigate('Main', { screen: 'Settings', params: tab ? { tab: mobileSettingsTab(tab) } : undefined });
    },
    [close, navigation],
  );

  const openFile = useCallback(
    (file: FileRow) => {
      if (!effectiveProjectId) return;
      close();
      navigation.navigate('Editor', { projectId: effectiveProjectId, filePath: file.path });
    },
    [close, navigation, effectiveProjectId],
  );

  const runGit = useCallback(
    async (action: 'fetch' | 'pull' | 'push') => {
      if (!effectiveProjectId) return;
      try {
        await api.post(`/git/${action}`, { project: effectiveProjectId });
      } catch {
        // errors surface on the Source Control screen
      }
      close();
      navigation.navigate('Main', { screen: 'SourceControl' });
    },
    [close, navigation, effectiveProjectId],
  );

  // Compare page: load usage for the two selected sessions.
  useEffect(() => {
    if (page !== 'compare') return;
    const ids = compare.filter(Boolean);
    const distinct = ids.length === 2 && ids[0] !== ids[1];
    if (!distinct) {
      setUsage([null, null]);
      return;
    }
    let cancelled = false;
    setCompareBusy(true);
    Promise.all(
      compare.map(async (sessionId) => {
        const session = sessions.find((s) => s.id === sessionId);
        const provider = session?.provider;
        const [usageRes, modelRes] = await Promise.all([
          api.get(`/providers/sessions/${encodeURIComponent(sessionId)}/token-usage`).then((r) => r.json()).catch(() => null),
          provider
            ? api
                .get(`/providers/${encodeURIComponent(provider)}/sessions/${encodeURIComponent(sessionId)}/active-model`)
                .then((r) => r.json())
                .catch(() => null)
            : Promise.resolve(null),
        ]);
        const model = (modelRes?.data ?? modelRes)?.model ?? null;
        return usageFromTokenUsage(usageRes, model);
      }),
    )
      .then((results) => {
        if (!cancelled) setUsage([results[0] ?? null, results[1] ?? null]);
      })
      .finally(() => {
        if (!cancelled) setCompareBusy(false);
      });
    return () => {
      cancelled = true;
    };
  }, [page, compare, sessions]);

  const q = query.trim();
  const browse = !page && !q;

  const sessionRows = useMemo(() => {
    const base = matches.length ? mergeSessionMatches(sessions, matches) : sessions;
    const filtered = base.filter((r) => matchesQuery(q, r.label, r.provider, r.snippet));
    return browse ? filtered.slice(0, BROWSE_LIMIT) : filtered;
  }, [sessions, matches, q, browse]);

  const fileRows = useMemo(() => {
    const filtered = files.filter((r) => matchesQuery(q, r.name, r.path));
    return browse ? filtered.slice(0, BROWSE_LIMIT) : filtered;
  }, [files, q, browse]);

  const commitRows = useMemo(() => {
    const filtered = commits.filter((r) => matchesQuery(q, r.message, r.shortHash, r.author));
    return browse ? filtered.slice(0, BROWSE_LIMIT) : filtered;
  }, [commits, q, browse]);

  const branchRows = useMemo(() => {
    const filtered = branches.filter((r) => matchesQuery(q, r.name));
    return browse ? filtered.slice(0, BROWSE_LIMIT) : filtered;
  }, [branches, q, browse]);

  const showActions = !page || page === 'actions';
  const showSessions = page === 'sessions' || (!page && browse);
  const showFiles = page === 'files' || (!page && browse);
  const showCommits = page === 'commits' || (browse && commitRows.length > 0);
  const showBranches = page === 'branches' || (browse && branchRows.length > 0);

  const renderGroupHeader = (label: string) => (
    <Text style={{ color: colors.mutedForeground, fontSize: 11, fontWeight: '600', letterSpacing: 0.5, textTransform: 'uppercase', marginTop: 14, marginBottom: 4, paddingHorizontal: 4 }}>
      {label}
    </Text>
  );

  const renderRow = (key: string, icon: React.ReactNode, label: string, sub: string | undefined, onPress: () => void) => (
    <TouchableOpacity
      key={key}
      onPress={onPress}
      style={{ flexDirection: 'row', alignItems: 'center', gap: 10, minHeight: 44, paddingHorizontal: 4, borderRadius: 8 }}
    >
      <View style={{ width: 20, alignItems: 'center' }}>{icon}</View>
      <View style={{ flex: 1 }}>
        <Text numberOfLines={1} style={{ color: colors.foreground, fontSize: 14 }}>
          {label}
        </Text>
        {sub ? (
          <Text numberOfLines={1} style={{ color: colors.mutedForeground, fontSize: 12 }}>
            {sub}
          </Text>
        ) : null}
      </View>
    </TouchableOpacity>
  );

  const projectLabel = projects.find((p) => p.id === effectiveProjectId)?.displayName ?? 'Project';

  const pageLabel = page ? tt(`commandPalette.pages.${page}`, page) : '';

  const compareSheetItems: ActionSheetItem[] = sessions.map((s) => ({
    label: s.label,
    onPress: () => {
      if (comparePick === null) return;
      setCompare((prev) => {
        const next: [string, string] = [...prev] as [string, string];
        next[comparePick] = s.id;
        return next;
      });
      setComparePick(null);
    },
  }));

  return (
    <Modal visible={visible} animationType="slide" onRequestClose={close} presentationStyle="pageSheet">
      <View style={{ flex: 1, backgroundColor: colors.background, paddingTop: insets.top }}>
        {/* Header */}
        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingHorizontal: 12, paddingVertical: 8 }}>
          {page ? (
            <TouchableOpacity onPress={() => { setPage(null); setQuery(''); }} hitSlop={8} style={{ padding: 6 }}>
              <ArrowLeft size={18} color={colors.foreground} />
            </TouchableOpacity>
          ) : (
            <Search size={18} color={colors.mutedForeground} />
          )}
          <TextInput
            ref={inputRef}
            value={query}
            onChangeText={setQuery}
            placeholder={page ? tt('commandPalette.searchPagePlaceholder', 'Search {{page}}…', { page: pageLabel }) : tt('commandPalette.placeholder', 'Type to search anything…')}
            placeholderTextColor={colors.mutedForeground}
            style={{ flex: 1, color: colors.foreground, fontSize: 15 }}
            autoCapitalize="none"
            autoCorrect={false}
          />
          <TouchableOpacity onPress={close} hitSlop={8} style={{ padding: 6 }}>
            <X size={18} color={colors.mutedForeground} />
          </TouchableOpacity>
        </View>

        {page ? (
          <Text style={{ color: colors.mutedForeground, fontSize: 12, paddingHorizontal: 16, paddingBottom: 6 }}>
            {pageLabel}
          </Text>
        ) : null}

        <ScrollView keyboardShouldPersistTaps="handled" contentContainerStyle={{ paddingHorizontal: 12, paddingBottom: insets.bottom + 32 }}>
          {/* Project chip */}
          <TouchableOpacity
            onPress={() => setProjectSheet(true)}
            style={{ flexDirection: 'row', alignItems: 'center', gap: 6, alignSelf: 'flex-start', backgroundColor: colors.card, borderColor: colors.border, borderWidth: 1, borderRadius: 999, paddingHorizontal: 10, paddingVertical: 4, marginVertical: 6 }}
          >
            <FileText size={12} color={colors.mutedForeground} />
            <Text style={{ color: colors.foreground, fontSize: 12 }}>{projectLabel}</Text>
          </TouchableOpacity>

          {page === 'compare' ? (
            <ComparePanel
              colors={colors}
              t={tt}
              sessions={sessions}
              compare={compare}
              usage={usage}
              busy={compareBusy}
              onPick={(side) => setComparePick(side)}
              onOpenSplit={() => {
                close();
                navigation.navigate('Main', { screen: 'Projects' });
              }}
            />
          ) : (
            <>
              {showActions ? (
                <>
                  {renderGroupHeader(tt('commandPalette.groups.actions', 'Actions'))}
                  {renderRow('new-chat', <MessageSquare size={16} color={colors.primary} />, tt('commandPalette.items.startNewChat', 'Start new chat'), undefined, () => {
                    close();
                    navigation.navigate('Main', { screen: 'Projects' });
                  })}
                  {renderRow('settings', <SettingsIcon size={16} color={colors.mutedForeground} />, tt('commandPalette.items.openSettings', 'Open settings'), undefined, () => openSettings())}
                  {renderRow('compare', <Star size={16} color={colors.mutedForeground} />, tt('commandPalette.items.compareSessions', 'Compare sessions'), tt('commandPalette.items.tokensAndCost', 'Tokens and cost'), () => setPage('compare'))}
                  {renderRow('fetch', <GitBranch size={16} color={colors.mutedForeground} />, tt('commandPalette.items.gitFetch', 'Git: fetch'), undefined, () => void runGit('fetch'))}
                  {renderRow('pull', <GitBranch size={16} color={colors.mutedForeground} />, tt('commandPalette.items.gitPull', 'Git: pull'), undefined, () => void runGit('pull'))}
                  {renderRow('push', <GitBranch size={16} color={colors.mutedForeground} />, tt('commandPalette.items.gitPush', 'Git: push'), undefined, () => void runGit('push'))}
                </>
              ) : null}

              {showActions ? (
                <>
                  {renderGroupHeader(tt('commandPalette.groups.navigate', 'Navigate'))}
                  {PALETTE_NAV_ITEMS.filter((item) => matchesQuery(q, tt(`commandPalette.${item.labelKey}`, item.key))).map((item) => {
                    const route = drawerRouteForTarget(item.target as any);
                    if (!route) return null;
                    return renderRow(
                      `nav-${item.key}`,
                      <LogIn size={16} color={colors.mutedForeground} />,
                      tt(`commandPalette.${item.labelKey}`, item.key),
                      item.shortcut,
                      () => openTab(route),
                    );
                  })}
                </>
              ) : null}

              {showActions ? (
                <>
                  {renderGroupHeader(tt('commandPalette.groups.settings', 'Settings'))}
                  {SETTINGS_TABS.filter((tabItem) => matchesQuery(q, tt(`mainTabs.${tabItem.labelKey}`, tabItem.labelKey))).map((tabItem) =>
                    renderRow(
                      `setting-${tabItem.id}`,
                      <SettingsIcon size={16} color={colors.mutedForeground} />,
                      tt('commandPalette.items.settingsEntry', 'Settings: {{label}}', { label: tt(`mainTabs.${tabItem.labelKey}`, tabItem.labelKey) }),
                      undefined,
                      () => openSettings(tabItem.id),
                    ),
                  )}
                </>
              ) : null}

              {showSessions ? (
                <>
                  {renderGroupHeader(tt('commandPalette.groups.sessions', 'Sessions'))}
                  {sessionRows.length === 0 ? (
                    <Text style={{ color: colors.mutedForeground, fontSize: 13, padding: 4 }}>{tt('commandPalette.noResults', 'No results')}</Text>
                  ) : (
                    sessionRows.map((s) =>
                      renderRow(
                        `session-${s.id}`,
                        <MessageSquare size={16} color={colors.mutedForeground} />,
                        s.label,
                        s.snippet ?? s.provider,
                        () => openSession(s),
                      ),
                    )
                  )}
                </>
              ) : null}

              {showFiles && fileRows.length > 0 ? (
                <>
                  {renderGroupHeader(tt('commandPalette.groups.files', 'Files'))}
                  {fileRows.map((f) =>
                    renderRow(`file-${f.path}`, <FileText size={16} color={colors.mutedForeground} />, f.name, f.path, () => openFile(f)),
                  )}
                </>
              ) : null}

              {showCommits ? (
                <>
                  {renderGroupHeader(tt('commandPalette.groups.commits', 'Commits'))}
                  {commitRows.map((c) =>
                    renderRow(`commit-${c.hash}`, <GitCommitHorizontal size={16} color={colors.mutedForeground} />, c.message, `${c.shortHash} · ${c.author ?? ''}`, () => openTab('SourceControl')),
                  )}
                </>
              ) : null}

              {showBranches ? (
                <>
                  {renderGroupHeader(tt('commandPalette.groups.branches', 'Branches'))}
                  {branchRows.map((b) =>
                    renderRow(`branch-${b.name}`, <GitBranch size={16} color={colors.mutedForeground} />, b.name, undefined, () => openTab('SourceControl')),
                  )}
                </>
              ) : null}
            </>
          )}
        </ScrollView>

        <ActionSheet
          visible={projectSheet}
          title="Project"
          items={projects.map((p) => ({
            label: p.displayName,
            onPress: () => {
              setActiveProjectId(p.id);
              setProjectSheet(false);
            },
          }))}
          onClose={() => setProjectSheet(false)}
        />
        <ActionSheet
          visible={comparePick !== null}
          title={tt('commandPalette.compare.selectSession', 'Select session')}
          items={compareSheetItems}
          onClose={() => setComparePick(null)}
        />
      </View>
    </Modal>
  );
}

function ComparePanel({
  colors,
  t,
  sessions,
  compare,
  usage,
  busy,
  onPick,
  onOpenSplit,
}: {
  colors: any;
  t: (key: string, fallback?: string, opts?: any) => string;
  sessions: SessionRow[];
  compare: [string, string];
  usage: [TokenUsageSummary | null, TokenUsageSummary | null];
  busy: boolean;
  onPick: (side: 0 | 1) => void;
  onOpenSplit: () => void;
}) {
  const tt = (key: string, fallback?: string, opts?: Record<string, unknown>) => t(key, fallback, opts);
  const label = (id: string) => sessions.find((s) => s.id === id)?.label ?? tt('commandPalette.compare.selectSession', 'Select session');
  const rows: { key: string; label: string; a: string; b: string }[] = [
    { key: 'provider', label: tt('commandPalette.compare.provider', 'Provider'), a: sessions.find((s) => s.id === compare[0])?.provider ?? '—', b: sessions.find((s) => s.id === compare[1])?.provider ?? '—' },
    { key: 'model', label: tt('commandPalette.compare.model', 'Model'), a: usage[0]?.model ?? '—', b: usage[1]?.model ?? '—' },
    { key: 'tokens', label: tt('commandPalette.compare.tokensUsed', 'Tokens used'), a: usage[0] ? (usage[0].unsupported ? 'N/A' : String(usage[0].used)) : '—', b: usage[1] ? (usage[1].unsupported ? 'N/A' : String(usage[1].used)) : '—' },
    { key: 'io', label: tt('commandPalette.compare.inputOutput', 'Input / Output'), a: usage[0] ? `${usage[0].input} / ${usage[0].output}` : '—', b: usage[1] ? `${usage[1].input} / ${usage[1].output}` : '—' },
    { key: 'cost', label: tt('commandPalette.compare.estCost', 'Est. cost'), a: usage[0] ? formatCostUsd(usage[0].costUsd) : '—', b: usage[1] ? formatCostUsd(usage[1].costUsd) : '—' },
  ];

  return (
    <View style={{ marginTop: 8 }}>
      <View style={{ flexDirection: 'row', gap: 8 }}>
        {([0, 1] as const).map((side) => (
          <TouchableOpacity
            key={side}
            onPress={() => onPick(side)}
            style={{ flex: 1, borderWidth: 1, borderColor: colors.border, borderRadius: 8, padding: 10, backgroundColor: colors.card }}
          >
            <Text numberOfLines={1} style={{ color: colors.foreground, fontSize: 13 }}>
              {compare[side] ? label(compare[side]) : tt('commandPalette.compare.selectSession', 'Select session')}
            </Text>
          </TouchableOpacity>
        ))}
      </View>

      {busy ? <ActivityIndicator color={colors.primary} style={{ marginTop: 16 }} /> : null}

      <View style={{ marginTop: 12, borderWidth: 1, borderColor: colors.border, borderRadius: 8, overflow: 'hidden' }}>
        {rows.map((row, index) => (
          <View key={row.key} style={{ flexDirection: 'row', borderTopWidth: index === 0 ? 0 : 1, borderTopColor: colors.border, paddingVertical: 8 }}>
            <Text style={{ flex: 1, color: colors.mutedForeground, fontSize: 12, paddingHorizontal: 8 }}>{row.label}</Text>
            <Text numberOfLines={1} style={{ flex: 1, color: colors.foreground, fontSize: 12, paddingHorizontal: 4 }}>{row.a}</Text>
            <Text numberOfLines={1} style={{ flex: 1, color: colors.foreground, fontSize: 12, paddingHorizontal: 4 }}>{row.b}</Text>
          </View>
        ))}
      </View>

      <Text style={{ color: colors.mutedForeground, fontSize: 11, marginTop: 8 }}>{tt('commandPalette.compare.costNote', 'Costs are estimated from published per-token rates.')}</Text>

      <TouchableOpacity
        onPress={onOpenSplit}
        disabled={!compare[0] || !compare[1] || compare[0] === compare[1]}
        style={{ marginTop: 12, backgroundColor: colors.primary, borderRadius: 8, paddingVertical: 10, alignItems: 'center', opacity: !compare[0] || !compare[1] || compare[0] === compare[1] ? 0.5 : 1 }}
      >
        <Text style={{ color: colors.primaryForeground, fontSize: 14, fontWeight: '600' }}>{tt('commandPalette.compare.openSplit', 'Open in split view')}</Text>
      </TouchableOpacity>
    </View>
  );
}
