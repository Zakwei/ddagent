import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import {
  ActivityIndicator,
  Modal,
  ScrollView,
  Text,
  TextInput,
  TouchableOpacity,
  useWindowDimensions,
  View,
} from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTranslation } from 'react-i18next';
import {
  AlertCircle,
  ArrowLeft,
  Check,
  ChevronDown,
  ChevronRight,
  Download,
  FileText,
  GitBranch,
  GitCommitHorizontal,
  GitFork,
  History,
  Home,
  Plus,
  RefreshCw,
  RotateCcw,
  Trash2,
  Upload,
  X,
} from 'lucide-react-native';
import { api } from '~shared/utils/api';
import { useTheme } from '../theme';
import { ActionSheet, ActionSheetItem } from '../components/ActionSheet';
import {
  getAllChangedFiles,
  getChangedFileCount,
  GitBranch as BranchInfo,
  GitChangedFile,
  GitCommitSummary,
  gitClient,
  useGitPanel,
  WorktreeInfo,
  WorktreeScriptsStatusResponse,
} from '../lib/git';
import { computeCommitGraph, formatCommitDate, laneColor, parseCommitFilesFull } from '../lib/git-extras';
import {
  CommitFileList,
  CommitGraphStrip,
  ConfirmModal,
  ConfirmRequest,
  DiffViewer,
  FileStatusLegend,
  MergeWorktreeModal,
  NewWorktreeModal,
  RemoveWorktreeModal,
  WorktreeRunButton,
  WorktreeScriptsModal,
} from '../components/SourceControlBlocks';

interface Project {
  id: string;
  displayName?: string;
  name?: string;
  path?: string;
}

type TabId = 'changes' | 'history' | 'branches' | 'worktrees';

const STATUS_BADGE: Record<GitChangedFile['status'], { letter: string; bg: string; text: string }> = {
  M: { letter: 'M', bg: '#fef3c7', text: '#b45309' },
  A: { letter: 'A', bg: '#dcfce7', text: '#15803d' },
  D: { letter: 'D', bg: '#fee2e2', text: '#b91c1c' },
  U: { letter: 'U', bg: '#e5e7eb', text: '#4b5563' },
};

function shortHash(hash: string): string {
  return hash.slice(0, 7);
}

function fileName(path: string): string {
  const parts = path.split('/');
  return parts[parts.length - 1] || path;
}

function FileRow({
  file,
  selected,
  diff,
  colors,
  t,
  hunkAction,
  onToggle,
  onDiscard,
  onOpenFile,
}: {
  file: GitChangedFile;
  selected: boolean;
  diff?: string;
  colors: any;
  t: (key: string, opts?: Record<string, unknown>) => string;
  hunkAction?: { variant: 'add' | 'remove'; onAction: (hunkIndex: number) => void };
  onToggle: () => void;
  onDiscard: () => void;
  onOpenFile: () => void;
}) {
  const [expanded, setExpanded] = useState(false);
  const [viewMode, setViewMode] = useState<'unified' | 'split'>('unified');
  const [wrapText, setWrapText] = useState(false);
  const badge = STATUS_BADGE[file.status];
  return (
    <View style={{ borderBottomWidth: 1, borderBottomColor: colors.border }}>
      <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingVertical: 8, paddingHorizontal: 12 }}>
        <TouchableOpacity onPress={onToggle} hitSlop={6}>
          <View
            style={{
              height: 18,
              width: 18,
              borderRadius: 4,
              borderWidth: 1,
              borderColor: selected ? colors.primary : colors.input,
              backgroundColor: selected ? colors.primary : 'transparent',
              alignItems: 'center',
              justifyContent: 'center',
            }}
          >
            {selected ? <Check size={12} color={colors.primaryForeground} /> : null}
          </View>
        </TouchableOpacity>
        <TouchableOpacity onPress={() => setExpanded((value) => !value)} hitSlop={6}>
          <ChevronRight size={14} color={colors.mutedForeground} style={{ transform: [{ rotate: expanded ? '90deg' : '0deg' }] }} />
        </TouchableOpacity>
        <TouchableOpacity style={{ flex: 1 }} onPress={onOpenFile}>
          <Text style={{ color: colors.foreground, fontSize: 12 }} numberOfLines={1}>
            {file.path}
          </Text>
        </TouchableOpacity>
        <View style={{ backgroundColor: badge.bg, borderRadius: 4, paddingHorizontal: 5, paddingVertical: 1 }}>
          <Text style={{ color: badge.text, fontSize: 10, fontWeight: '700' }}>{badge.letter}</Text>
        </View>
        {file.status !== 'A' ? (
          <TouchableOpacity onPress={onDiscard} hitSlop={6}>
            <Trash2 size={14} color={colors.destructive} />
          </TouchableOpacity>
        ) : null}
      </View>
      {expanded ? (
        <View style={{ paddingHorizontal: 12, paddingBottom: 12 }}>
          {hunkAction ? (
            <View style={{ flexDirection: 'row', gap: 8, marginTop: 6 }}>
              <TouchableOpacity
                onPress={() => setViewMode((mode) => (mode === 'unified' ? 'split' : 'unified'))}
                style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 6, paddingHorizontal: 8, paddingVertical: 3 }}
              >
                <Text style={{ color: colors.mutedForeground, fontSize: 10, fontWeight: '600' }}>
                  {viewMode === 'unified' ? t('gitPanel.switchSplit') : t('gitPanel.switchUnified')}
                </Text>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={() => setWrapText((value) => !value)}
                style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 6, paddingHorizontal: 8, paddingVertical: 3 }}
              >
                <Text style={{ color: colors.mutedForeground, fontSize: 10, fontWeight: '600' }}>
                  {wrapText ? t('gitPanel.switchScroll') : t('gitPanel.switchWrap')}
                </Text>
              </TouchableOpacity>
            </View>
          ) : null}
          <DiffViewer diff={diff} colors={colors} viewMode={viewMode} wrapText={wrapText} hunkAction={hunkAction} />
        </View>
      ) : null}
    </View>
  );
}

export default function SourceControlScreen() {
  const { colors } = useTheme();
  const { t } = useTranslation('common');
  const insets = useSafeAreaInsets();
  const navigation = useNavigation<any>();
  const { width } = useWindowDimensions();
  const columnWidth = Math.min(width * 0.9, 420);

  const [projects, setProjects] = useState<Project[]>([]);
  const [projectId, setProjectId] = useState<string | undefined>();
  const [activeProject, setActiveProject] = useState<Project | undefined>();
  const [tab, setTab] = useState<TabId>('changes');
  const [projectSheet, setProjectSheet] = useState(false);
  const [commitMessage, setCommitMessage] = useState('');
  const [busy, setBusy] = useState(false);
  const [actionError, setActionError] = useState<string | null>(null);
  const [askUserConfirm, setAskUserConfirm] = useState<AreaConfirmation | null>(null);
  const [expandedCommit, setExpandedCommit] = useState<string | null>(null);
  const [commitDiff, setCommitDiff] = useState('');
  const [commitDiffLoading, setCommitDiffLoading] = useState(false);
  const [branchSearch, setBranchSearch] = useState('');
  const [newBranchOpen, setNewBranchOpen] = useState(false);
  const [newBranchName, setNewBranchName] = useState('');
  const [worktrees, setWorktrees] = useState<WorktreeInfo[]>([]);
  const [worktreeBusy, setWorktreeBusy] = useState<string | null>(null);
  const [worktreeRepoRoot, setWorktreeRepoRoot] = useState('');
  const [newWorktreeOpen, setNewWorktreeOpen] = useState(false);
  const [mergeTarget, setMergeTarget] = useState<WorktreeInfo | null>(null);
  const [removeTarget, setRemoveTarget] = useState<WorktreeInfo | null>(null);
  const [scriptsOpen, setScriptsOpen] = useState(false);
  const [scriptsStatus, setScriptsStatus] = useState<WorktreeScriptsStatusResponse['data'] | null>(null);
  const [worktreeOp, setWorktreeOp] = useState(false);
  const [confirmRequest, setConfirmRequest] = useState<ConfirmRequest | null>(null);

  const openFile = useCallback(
    async (filePath: string) => {
      if (!projectId) return;
      let diffInfo: { old_string: string; new_string: string } | undefined;
      try {
        const data = await gitClient.fileWithDiff(projectId, filePath);
        if (!data.error && typeof data.currentContent === 'string') {
          diffInfo = { old_string: data.oldContent ?? '', new_string: data.currentContent };
        }
      } catch {
        /* open without diff */
      }
      navigation.navigate('Editor', { projectId, filePath, diffInfo });
    },
    [navigation, projectId],
  );

  const git = useGitPanel(projectId);
  const changedFiles = useMemo(() => getAllChangedFiles(git.status), [git.status]);
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const selectedRef = useRef(selected);
  selectedRef.current = selected;

  useEffect(() => {
    setSelected(new Set(git.status?.staged ?? []));
  }, [git.status?.staged]);

  useEffect(() => {
    let cancelled = false;
    api
      .projects()
      .then(async (response) => {
        const payload = await response.json();
        const list = Array.isArray(payload) ? payload : payload?.data?.projects ?? [];
        if (cancelled) return;
        const normalized: Project[] = list.map((project: any) => ({
          id: project.id ?? project.projectId,
          displayName: project.displayName ?? project.name,
          name: project.name,
          path: project.path ?? project.fullPath,
        }));
        setProjects(normalized);
        setProjectId((current) => current ?? normalized[0]?.id);
      })
      .catch(() => undefined);
    return () => {
      cancelled = true;
    };
  }, []);

  useEffect(() => {
    setActiveProject(projects.find((project) => project.id === projectId));
  }, [projectId, projects]);

  const refreshWorktrees = useCallback(async () => {
    if (!projectId) return;
    try {
      const payload = await gitClient.worktrees(projectId);
      setWorktrees(payload?.data?.worktrees ?? []);
      setWorktreeRepoRoot(payload?.data?.repositoryRoot ?? '');
    } catch (err) {
      setActionError(err instanceof Error ? err.message : String(err));
    }
  }, [projectId]);

  const refreshScripts = useCallback(async () => {
    if (!projectId) return;
    try {
      const payload = await gitClient.worktreeScriptsStatus(projectId);
      setScriptsStatus(payload?.data ?? null);
    } catch {
      setScriptsStatus(null);
    }
  }, [projectId]);

  useEffect(() => {
    if (tab === 'worktrees') {
      void refreshWorktrees();
      void refreshScripts();
    }
  }, [tab, refreshWorktrees, refreshScripts]);

  const run = useCallback(async (operation: () => Promise<unknown>) => {
    setBusy(true);
    setActionError(null);
    try {
      await operation();
      await git.refresh({ commits: true });
      return true;
    } catch (err) {
      setActionError(err instanceof Error ? err.message : String(err));
      return false;
    } finally {
      setBusy(false);
    }
  }, [git]);

  const runWorktree = useCallback(
    async (key: string, operation: () => Promise<unknown>) => {
      setWorktreeBusy(key);
      setActionError(null);
      try {
        await operation();
        await refreshWorktrees();
      } catch (err) {
        setActionError(err instanceof Error ? err.message : String(err));
      } finally {
        setWorktreeBusy(null);
      }
    },
    [refreshWorktrees],
  );

  const toggleSelected = useCallback(
    async (file: GitChangedFile) => {
      if (!projectId) return;
      const next = new Set(selectedRef.current);
      const wasSelected = next.has(file.path);
      if (wasSelected) next.delete(file.path);
      else next.add(file.path);
      setSelected(next);
      setBusy(true);
      setActionError(null);
      try {
        if (wasSelected) await gitClient.unstage(projectId, [file.path]);
        else await gitClient.stage(projectId, [file.path]);
        await git.refresh({ commits: true });
      } catch (err) {
        setSelected(new Set(git.status?.staged ?? []));
        setActionError(err instanceof Error ? err.message : String(err));
      } finally {
        setBusy(false);
      }
    },
    [git, projectId],
  );

  const stageAll = useCallback(async () => {
    if (!projectId) return;
    await run(() => gitClient.stage(projectId, changedFiles.map((file) => file.path)));
  }, [changedFiles, projectId, run]);

  const unstageAll = useCallback(async () => {
    if (!projectId) return;
    await run(() => gitClient.unstage(projectId, changedFiles.map((file) => file.path)));
  }, [changedFiles, projectId, run]);

  const discardFile = useCallback(
    (file: GitChangedFile) => {
      if (!projectId) return;
      setAskUserConfirm({
        message:
          file.status === 'U'
            ? t('gitPanel.confirmDeleteFile', { file: file.path })
            : t('gitPanel.confirmDiscardFile', { file: file.path }),
        label: file.status === 'U' ? t('gitPanel.confirmActions.delete') : t('gitPanel.confirmActions.discard'),
        onConfirm: () =>
          run(() =>
            file.status === 'U' ? gitClient.deleteUntracked(projectId, file.path) : gitClient.discard(projectId, file.path),
          ),
      });
    },
    [projectId, run, t],
  );

  const commitSelected = useCallback(async () => {
    if (!projectId || !commitMessage.trim() || selected.size === 0) return;
    const ok = await run(() => gitClient.commit(projectId, commitMessage.trim(), Array.from(selected)));
    if (ok) {
      setCommitMessage('');
      setSelected(new Set());
    }
  }, [commitMessage, projectId, run, selected]);

  const generateMessage = useCallback(async () => {
    if (!projectId) return;
    setBusy(true);
    try {
      const payload = await gitClient.generateCommitMessage(projectId, Array.from(selected));
      if (payload?.message) setCommitMessage(payload.message);
    } catch (err) {
      setActionError(err instanceof Error ? err.message : String(err));
    } finally {
      setBusy(false);
    }
  }, [projectId, selected]);

  const openCommitDiff = useCallback(
    async (commit: GitCommitSummary) => {
      if (expandedCommit === commit.hash) {
        setExpandedCommit(null);
        return;
      }
      setExpandedCommit(commit.hash);
      setCommitDiffLoading(true);
      setCommitDiff('');
      try {
        const diff = await git.fetchCommitDiff(commit.hash);
        setCommitDiff(diff);
      } catch (err) {
        setActionError(err instanceof Error ? err.message : String(err));
      } finally {
        setCommitDiffLoading(false);
      }
    },
    [expandedCommit, git],
  );

  const switchBranch = useCallback(
    async (branch: BranchInfo) => {
      if (!projectId || branch.current) return;
      await run(() => gitClient.checkout(projectId, branch.name));
      await git.refresh({ commits: true });
    },
    [git, projectId, run],
  );

  const createBranch = useCallback(async () => {
    if (!projectId || !newBranchName.trim()) return;
    const ok = await run(() => gitClient.createBranch(projectId, newBranchName.trim()));
    if (ok) {
      setNewBranchOpen(false);
      setNewBranchName('');
    }
  }, [newBranchName, projectId, run]);

  const deleteBranch = useCallback(
    (branch: BranchInfo) => {
      if (!projectId) return;
      setConfirmRequest({
        title: t('gitPanel.confirmTitles.deleteBranch', 'Delete branch'),
        message: t('gitPanel.branches.confirmDelete', { branch: branch.name }),
        actionLabel: t('gitPanel.confirmActions.deleteBranch'),
        onConfirm: () => void run(() => gitClient.deleteBranch(projectId, branch.name, false)),
        alternate: {
          label: t('gitPanel.branches.forceDeleteLabel', 'Force delete'),
          description: t('gitPanel.branches.forceDeleteDesc', 'Delete the branch even if it is not fully merged.'),
          actionLabel: t('gitPanel.branches.forceDelete', 'Force delete'),
          onConfirm: () => void run(() => gitClient.deleteBranch(projectId, branch.name, true)),
        },
      });
    },
    [projectId, run, t],
  );

  const changeCount = getChangedFileCount(git.status);
  const unstagedFiles = changedFiles.filter((file) => !selected.has(file.path));
  const stagedFiles = changedFiles.filter((file) => selected.has(file.path));
  const filteredBranches = git.branches.filter((branch) =>
    branch.name.toLowerCase().includes(branchSearch.trim().toLowerCase()),
  );
  const localBranches = filteredBranches.filter((branch) => !branch.remote);
  const remoteBranches = filteredBranches.filter((branch) => branch.remote);

  const graphRows = useMemo(
    () => (git.commits.some((commit) => commit.parents !== undefined) ? computeCommitGraph(git.commits) : null),
    [git.commits],
  );

  const tabs: { id: TabId; label: string; icon: typeof FileText; count?: number }[] = [
    { id: 'changes', label: t('gitPanel.tabs.changes'), icon: FileText, count: changeCount },
    { id: 'history', label: t('gitPanel.tabs.history'), icon: History },
    { id: 'branches', label: t('gitPanel.tabs.branches'), icon: GitBranch },
    { id: 'worktrees', label: t('gitPanel.tabs.worktrees'), icon: GitFork },
  ];

  return (
    <View style={{ flex: 1, backgroundColor: colors.background }}>
      {/* header */}
      <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6, paddingHorizontal: 12, paddingVertical: 8, borderBottomWidth: 1, borderBottomColor: colors.border }}>
        <TouchableOpacity onPress={() => navigation.navigate('Main', { screen: 'Projects' })} hitSlop={8} style={{ padding: 4 }}>
          <ArrowLeft size={18} color={colors.mutedForeground} />
        </TouchableOpacity>
        <TouchableOpacity onPress={() => setProjectSheet(true)} style={{ flex: 1, flexDirection: 'row', alignItems: 'center', gap: 6 }}>
          <GitBranch size={16} color={colors.foreground} />
          <Text style={{ color: colors.foreground, fontWeight: '600', fontSize: 14 }} numberOfLines={1}>
            {activeProject?.displayName ?? activeProject?.name ?? t('gitPanel.selectProject')}
          </Text>
          <ChevronDown size={14} color={colors.mutedForeground} />
        </TouchableOpacity>
        <TouchableOpacity onPress={() => void git.refresh({ commits: true })} hitSlop={8} style={{ padding: 4 }} disabled={busy}>
          <RefreshCw size={16} color={busy ? colors.mutedForeground : colors.foreground} />
        </TouchableOpacity>
      </View>

      {/* branch + remote status */}
      {git.status && !git.status.notGitRepository ? (
        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingHorizontal: 12, paddingVertical: 6, borderBottomWidth: 1, borderBottomColor: colors.border }}>
          <Text style={{ color: colors.foreground, fontSize: 12, fontWeight: '600' }}>
            {git.status.branch ?? 'main'}
          </Text>
          {git.remoteStatus?.hasRemote ? (
            <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>
              {git.remoteStatus.isUpToDate
                ? t('gitPanel.upToDate')
                : `↑${git.remoteStatus.ahead ?? 0} ↓${git.remoteStatus.behind ?? 0}`}
            </Text>
          ) : null}
          <View style={{ flex: 1 }} />
          {git.remoteStatus?.hasRemote ? (
            <>
              {!git.remoteStatus.hasUpstream ? (
                <TouchableOpacity
                  disabled={busy}
                  onPress={() => projectId && run(() => gitClient.publish(projectId, git.status?.branch ?? 'main'))}
                  style={{ backgroundColor: colors.primary, borderRadius: 6, paddingHorizontal: 8, paddingVertical: 4 }}
                >
                  <Text style={{ color: colors.primaryForeground, fontSize: 11, fontWeight: '600' }}>{t('gitPanel.publish')}</Text>
                </TouchableOpacity>
              ) : (
                <>
                  <TouchableOpacity disabled={busy} onPress={() => projectId && run(() => gitClient.fetchRemote(projectId))} hitSlop={6} style={{ padding: 4 }}>
                    <RefreshCw size={15} color={colors.mutedForeground} />
                  </TouchableOpacity>
                  <TouchableOpacity
                    disabled={busy || (git.remoteStatus.behind ?? 0) === 0}
                    onPress={() => projectId && run(() => gitClient.pull(projectId))}
                    hitSlop={6}
                    style={{ padding: 4 }}
                  >
                    <Download size={15} color={(git.remoteStatus.behind ?? 0) > 0 ? colors.foreground : colors.mutedForeground} />
                  </TouchableOpacity>
                  <TouchableOpacity disabled={busy} onPress={() => projectId && run(() => gitClient.push(projectId))} hitSlop={6} style={{ padding: 4 }}>
                    <Upload size={15} color={(git.remoteStatus.ahead ?? 0) > 0 ? '#f97316' : colors.foreground} />
                  </TouchableOpacity>
                </>
              )}
            </>
          ) : null}
          <TouchableOpacity
            disabled={busy}
            onPress={() =>
              projectId
                ? setAskUserConfirm({
                    message: t('gitPanel.confirmRevert'),
                    label: t('gitPanel.confirmActions.revertLocalCommit'),
                    onConfirm: () => run(() => gitClient.revertLocalCommit(projectId)),
                  })
                : undefined
            }
            hitSlop={6}
            style={{ padding: 4 }}
          >
            <RotateCcw size={15} color={colors.mutedForeground} />
          </TouchableOpacity>
        </View>
      ) : null}

      {/* tabs */}
      <ScrollView horizontal showsHorizontalScrollIndicator={false} style={{ flexGrow: 0 }} contentContainerStyle={{ borderBottomWidth: 1, borderBottomColor: colors.border }}>
        {tabs.map((entry) => {
          const Icon = entry.icon;
          const active = tab === entry.id;
          return (
            <TouchableOpacity
              key={entry.id}
              onPress={() => setTab(entry.id)}
              style={{ flexDirection: 'row', alignItems: 'center', gap: 6, paddingHorizontal: 16, paddingVertical: 10, borderBottomWidth: 2, borderBottomColor: active ? colors.primary : 'transparent' }}
            >
              <Icon size={15} color={active ? colors.primary : colors.mutedForeground} />
              <Text style={{ color: active ? colors.primary : colors.mutedForeground, fontSize: 13, fontWeight: '600' }}>{entry.label}</Text>
              {entry.count ? (
                <View style={{ backgroundColor: colors.muted, borderRadius: 8, paddingHorizontal: 5, paddingVertical: 1 }}>
                  <Text style={{ color: colors.mutedForeground, fontSize: 10, fontWeight: '700' }}>{entry.count}</Text>
                </View>
              ) : null}
            </TouchableOpacity>
          );
        })}
      </ScrollView>

      {actionError ? (
        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6, backgroundColor: colors.destructive + '22', paddingHorizontal: 12, paddingVertical: 6 }}>
          <AlertCircle size={14} color={colors.destructive} />
          <Text style={{ color: colors.destructive, fontSize: 12, flex: 1 }} numberOfLines={2}>{actionError}</Text>
          <TouchableOpacity onPress={() => setActionError(null)} hitSlop={6}>
            <X size={14} color={colors.destructive} />
          </TouchableOpacity>
        </View>
      ) : null}

      {git.isLoading && !git.status ? (
        <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
          <ActivityIndicator color={colors.primary} />
        </View>
      ) : git.status?.notGitRepository ? (
        <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', gap: 12, padding: 32 }}>
          <GitBranch size={40} color={colors.mutedForeground} />
          <Text style={{ color: colors.foreground, fontWeight: '600', textAlign: 'center' }}>{t('gitPanel.notGitRepository')}</Text>
          <TouchableOpacity
            disabled={busy}
            onPress={() => projectId && run(() => gitClient.initRepo(projectId))}
            style={{ backgroundColor: colors.primary, borderRadius: 8, paddingHorizontal: 16, paddingVertical: 10 }}
          >
            <Text style={{ color: colors.primaryForeground, fontWeight: '600' }}>{t('gitPanel.noRepo.init')}</Text>
          </TouchableOpacity>
        </View>
      ) : tab === 'changes' ? (
        <ScrollView style={{ flex: 1 }} contentContainerStyle={{ paddingBottom: 16 + insets.bottom }}>
          {/* commit composer */}
          <View style={{ padding: 12, gap: 8 }}>
            <TextInput
              value={commitMessage}
              onChangeText={setCommitMessage}
              placeholder={t('gitPanel.messagePlaceholder')}
              placeholderTextColor={colors.mutedForeground}
              multiline
              style={{ borderWidth: 1, borderColor: colors.input, borderRadius: 8, padding: 10, color: colors.foreground, minHeight: 60, textAlignVertical: 'top' }}
            />
            <View style={{ flexDirection: 'row', gap: 8 }}>
              <TouchableOpacity
                disabled={busy || selected.size === 0}
                onPress={generateMessage}
                style={{ flex: 1, borderWidth: 1, borderColor: colors.border, borderRadius: 8, paddingVertical: 10, alignItems: 'center' }}
              >
                <Text style={{ color: colors.mutedForeground, fontSize: 12, fontWeight: '600' }}>{t('gitPanel.aiSuggest')}</Text>
              </TouchableOpacity>
              <TouchableOpacity
                disabled={busy || !commitMessage.trim() || selected.size === 0}
                onPress={commitSelected}
                style={{
                  flex: 1,
                  backgroundColor: commitMessage.trim() && selected.size > 0 ? colors.primary : colors.muted,
                  borderRadius: 8,
                  paddingVertical: 10,
                  alignItems: 'center',
                }}
              >
                <Text style={{ color: commitMessage.trim() && selected.size > 0 ? colors.primaryForeground : colors.mutedForeground, fontSize: 12, fontWeight: '600' }}>
                  {busy ? t('gitPanel.committing') : `${t('gitPanel.commit')} (${selected.size})`}
                </Text>
              </TouchableOpacity>
            </View>
          </View>

          <FileStatusLegend colors={colors} t={t} />
          {git.status?.hasCommits === false && changedFiles.length > 0 ? (
            <View style={{ alignItems: 'center', gap: 10, padding: 24 }}>
              <Text style={{ color: colors.foreground, fontWeight: '600', textAlign: 'center' }}>{t('gitPanel.noCommits.title')}</Text>
              <Text style={{ color: colors.mutedForeground, textAlign: 'center', fontSize: 12 }}>{t('gitPanel.noCommits.description')}</Text>
              <TouchableOpacity
                disabled={busy}
                onPress={() => projectId && run(() => gitClient.initialCommit(projectId))}
                style={{ backgroundColor: colors.primary, borderRadius: 8, paddingHorizontal: 16, paddingVertical: 10 }}
              >
                <Text style={{ color: colors.primaryForeground, fontWeight: '600' }}>{busy ? t('gitPanel.noCommits.creating') : t('gitPanel.noCommits.create')}</Text>
              </TouchableOpacity>
            </View>
          ) : changedFiles.length === 0 ? (
            <View>
              <View style={{ alignItems: 'center', gap: 6, padding: 24 }}>
                <Check size={32} color={colors.mutedForeground} />
                <Text style={{ color: colors.mutedForeground }}>{t('gitPanel.noChanges')}</Text>
              </View>
              {git.commits.length > 0 ? (
                <View style={{ paddingHorizontal: 12, gap: 6 }}>
                  <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                    <Text style={{ color: colors.mutedForeground, fontSize: 11, fontWeight: '700', textTransform: 'uppercase' }}>{t('gitPanel.recentCommits')}</Text>
                    <TouchableOpacity onPress={() => setTab('history')}><Text style={{ color: colors.primary, fontSize: 12, fontWeight: '600' }}>{t('gitPanel.viewAll')}</Text></TouchableOpacity>
                  </View>
                  {git.commits.slice(0, 5).map((commit) => (
                    <View key={commit.hash} style={{ flexDirection: 'row', gap: 8 }}>
                      <Text style={{ color: colors.mutedForeground, fontSize: 11, fontFamily: 'monospace' }}>{shortHash(commit.hash)}</Text>
                      <Text style={{ color: colors.foreground, fontSize: 12, flex: 1 }} numberOfLines={1}>{commit.message}</Text>
                    </View>
                  ))}
                </View>
              ) : null}
            </View>
          ) : (
            <>
              {stagedFiles.length > 0 ? (
                <View>
                  <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', paddingHorizontal: 12, paddingVertical: 8 }}>
                    <Text style={{ color: colors.mutedForeground, fontSize: 11, fontWeight: '700', textTransform: 'uppercase' }}>
                      {t('gitPanel.staged', { count: stagedFiles.length })}
                    </Text>
                    <TouchableOpacity disabled={busy} onPress={unstageAll}>
                      <Text style={{ color: colors.primary, fontSize: 12, fontWeight: '600' }}>{t('gitPanel.unstageAll')}</Text>
                    </TouchableOpacity>
                  </View>
                  {stagedFiles.map((file) => (
                    <FileRow
                      key={file.path}
                      file={file}
                      selected={selected.has(file.path)}
                      diff={git.diffs[file.path]}
                      colors={colors}
                      t={t}
                      onToggle={() => void toggleSelected(file)}
                      onDiscard={() => discardFile(file)}
                      onOpenFile={() => openFile(file.path)}
                      hunkAction={projectId ? { variant: 'remove', onAction: (hunkIndex) => void run(() => gitClient.unstageHunks(projectId, file.path, [hunkIndex])) } : undefined}
                    />
                  ))}
                </View>
              ) : null}
              {unstagedFiles.length > 0 ? (
                <View>
                  <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', paddingHorizontal: 12, paddingVertical: 8 }}>
                    <Text style={{ color: colors.mutedForeground, fontSize: 11, fontWeight: '700', textTransform: 'uppercase' }}>
                      {t('gitPanel.changesCount', { count: unstagedFiles.length })}
                    </Text>
                    <TouchableOpacity disabled={busy} onPress={stageAll}>
                      <Text style={{ color: colors.primary, fontSize: 12, fontWeight: '600' }}>{t('gitPanel.stageAll')}</Text>
                    </TouchableOpacity>
                  </View>
                  {unstagedFiles.map((file) => (
                    <FileRow
                      key={file.path}
                      file={file}
                      selected={false}
                      diff={git.diffs[file.path]}
                      colors={colors}
                      t={t}
                      onToggle={() => void toggleSelected(file)}
                      onDiscard={() => discardFile(file)}
                      onOpenFile={() => openFile(file.path)}
                      hunkAction={projectId ? { variant: 'add', onAction: (hunkIndex) => void run(() => gitClient.stageHunks(projectId, file.path, [hunkIndex])) } : undefined}
                    />
                  ))}
                </View>
              ) : null}
            </>
          )}
        </ScrollView>
      ) : tab === 'history' ? (
        <ScrollView style={{ flex: 1 }} contentContainerStyle={{ paddingBottom: 16 + insets.bottom }}>
          {git.commits.length === 0 ? (
            <View style={{ alignItems: 'center', padding: 32 }}>
              <Text style={{ color: colors.mutedForeground }}>{t('gitPanel.history.empty')}</Text>
            </View>
          ) : (
            git.commits.map((commit, index) => {
              const expanded = expandedCommit === commit.hash;
              const parsed = expanded ? parseCommitFilesFull(commitDiff) : null;
              const graphRow = graphRows?.[index];
              return (
                <View key={commit.hash} style={{ borderBottomWidth: 1, borderBottomColor: colors.border }}>
                  <TouchableOpacity onPress={() => void openCommitDiff(commit)} style={{ flexDirection: 'row', gap: 8, padding: 12 }}>
                    {graphRow ? <CommitGraphStrip row={graphRow} /> : <GitCommitHorizontal size={15} color={colors.mutedForeground} />}
                    <View style={{ flex: 1 }}>
                      {commit.refs && commit.refs.length > 0 ? (
                        <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 4, marginBottom: 2 }}>
                          {commit.refs.map((ref) => (
                            <View key={ref} style={{ backgroundColor: (graphRow ? laneColor(graphRow.nodeLane) : '#0ea5e9') + '22', borderRadius: 3, paddingHorizontal: 4 }}>
                              <Text style={{ color: graphRow ? laneColor(graphRow.nodeLane) : '#0ea5e9', fontSize: 10, fontWeight: '600' }}>
                                {ref.replace(/^HEAD -> /, '').replace(/^tag: /, '')}
                              </Text>
                            </View>
                          ))}
                        </View>
                      ) : null}
                      <Text style={{ color: colors.foreground, fontSize: 13, fontWeight: '600' }} numberOfLines={2}>
                        {commit.message}
                      </Text>
                      <Text style={{ color: colors.mutedForeground, fontSize: 11, marginTop: 2 }}>
                        {commit.author} · {formatCommitDate(commit.date)}
                      </Text>
                    </View>
                    <Text style={{ color: colors.mutedForeground, fontSize: 11, fontFamily: 'monospace' }}>{shortHash(commit.hash)}</Text>
                  </TouchableOpacity>
                  {expanded ? (
                    <View style={{ paddingHorizontal: 12, paddingBottom: 12 }}>
                      {commitDiffLoading ? (
                        <ActivityIndicator color={colors.primary} />
                      ) : (
                        <>
                          <Text style={{ color: colors.mutedForeground, fontSize: 11, fontFamily: 'monospace', marginBottom: 6 }}>{commit.hash}</Text>
                          {parsed ? (
                            <View style={{ flexDirection: 'row', gap: 12, marginBottom: 8 }}>
                              <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{t('gitPanel.history.files')}: {parsed.totalFiles}</Text>
                              <Text style={{ color: '#15803d', fontSize: 11 }}>+{parsed.totalInsertions}</Text>
                              <Text style={{ color: '#b91c1c', fontSize: 11 }}>−{parsed.totalDeletions}</Text>
                            </View>
                          ) : null}
                          {parsed ? <CommitFileList files={parsed.files} colors={colors} /> : null}
                          <DiffViewer diff={commitDiff} colors={colors} />
                        </>
                      )}
                    </View>
                  ) : null}
                </View>
              );
            })
          )}
        </ScrollView>
      ) : tab === 'branches' ? (
        <ScrollView style={{ flex: 1 }} contentContainerStyle={{ paddingBottom: 16 + insets.bottom }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, padding: 12 }}>
            <View style={{ flex: 1, flexDirection: 'row', alignItems: 'center', gap: 6, borderWidth: 1, borderColor: colors.input, borderRadius: 8, paddingHorizontal: 10 }}>
              <TextInput
                value={branchSearch}
                onChangeText={setBranchSearch}
                placeholder={t('gitPanel.searchBranches')}
                placeholderTextColor={colors.mutedForeground}
                style={{ flex: 1, color: colors.foreground, paddingVertical: 8 }}
              />
            </View>
            <TouchableOpacity onPress={() => setNewBranchOpen(true)} style={{ flexDirection: 'row', alignItems: 'center', gap: 4, backgroundColor: colors.primary, borderRadius: 8, paddingHorizontal: 10, paddingVertical: 9 }}>
              <Plus size={14} color={colors.primaryForeground} />
              <Text style={{ color: colors.primaryForeground, fontSize: 12, fontWeight: '600' }}>{t('gitPanel.createBranch')}</Text>
            </TouchableOpacity>
          </View>
          {localBranches.map((branch) => (
            <View key={branch.name} style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingHorizontal: 12, paddingVertical: 10, borderBottomWidth: 1, borderBottomColor: colors.border }}>
              <GitBranch size={14} color={branch.current ? colors.primary : colors.mutedForeground} />
              <Text style={{ flex: 1, color: colors.foreground, fontSize: 13 }} numberOfLines={1}>{branch.name}</Text>
              {branch.current ? (
                <View style={{ backgroundColor: colors.primary + '22', borderRadius: 4, paddingHorizontal: 5, paddingVertical: 1 }}>
                  <Text style={{ color: colors.primary, fontSize: 10, fontWeight: '700' }}>{t('gitPanel.branches.current')}</Text>
                </View>
              ) : null}
              {!branch.current ? (
                <>
                  <TouchableOpacity onPress={() => void switchBranch(branch)} style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 6, paddingHorizontal: 8, paddingVertical: 4 }}>
                    <Text style={{ color: colors.foreground, fontSize: 11, fontWeight: '600' }}>{t('gitPanel.branches.switch')}</Text>
                  </TouchableOpacity>
                  <TouchableOpacity onPress={() => deleteBranch(branch)} hitSlop={6}>
                    <Trash2 size={14} color={colors.destructive} />
                  </TouchableOpacity>
                </>
              ) : null}
            </View>
          ))}
          {remoteBranches.length > 0 ? (
            <Text style={{ color: colors.mutedForeground, fontSize: 11, fontWeight: '700', textTransform: 'uppercase', paddingHorizontal: 12, paddingTop: 12, paddingBottom: 4 }}>
              {t('gitPanel.branches.remote')}
            </Text>
          ) : null}
          {remoteBranches.map((branch) => (
            <View key={branch.name} style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingHorizontal: 12, paddingVertical: 10, borderBottomWidth: 1, borderBottomColor: colors.border }}>
              <Text style={{ flex: 1, color: colors.mutedForeground, fontSize: 12 }} numberOfLines={1}>{branch.name}</Text>
            </View>
          ))}
        </ScrollView>
      ) : (
        <ScrollView style={{ flex: 1 }} contentContainerStyle={{ paddingBottom: 16 + insets.bottom }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, padding: 12 }}>
            <Text style={{ flex: 1, color: colors.mutedForeground, fontSize: 12 }}>
              {t('gitPanel.worktrees.count', { count: worktrees.length })}
            </Text>
            <TouchableOpacity onPress={() => setScriptsOpen(true)} hitSlop={6} style={{ padding: 4 }}>
              <FileText size={15} color={colors.mutedForeground} />
            </TouchableOpacity>
            <TouchableOpacity onPress={() => void refreshWorktrees()} hitSlop={6} style={{ padding: 4 }}>
              <RefreshCw size={15} color={colors.mutedForeground} />
            </TouchableOpacity>
            <TouchableOpacity onPress={() => setNewWorktreeOpen(true)} style={{ flexDirection: 'row', alignItems: 'center', gap: 4, backgroundColor: colors.primary, borderRadius: 8, paddingHorizontal: 10, paddingVertical: 7 }}>
              <Plus size={14} color={colors.primaryForeground} />
              <Text style={{ color: colors.primaryForeground, fontSize: 12, fontWeight: '600' }}>{t('worktrees.new', 'New worktree')}</Text>
            </TouchableOpacity>
          </View>
          {worktrees.map((worktree) => (
            <View key={worktree.path} style={{ borderBottomWidth: 1, borderBottomColor: colors.border, padding: 12, gap: 4 }}>
              <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6 }}>
                {worktree.isMain ? <Home size={14} color={colors.mutedForeground} /> : <GitFork size={14} color={colors.mutedForeground} />}
                <Text style={{ color: colors.foreground, fontSize: 13, fontWeight: '600' }} numberOfLines={1}>
                  {worktree.branch ?? t('gitPanel.worktrees.detachedAt')}
                </Text>
                {worktree.isCurrent ? (
                  <View style={{ backgroundColor: colors.primary + '22', borderRadius: 4, paddingHorizontal: 5, paddingVertical: 1 }}>
                    <Text style={{ color: colors.primary, fontSize: 10, fontWeight: '700' }}>{t('gitPanel.worktrees.current')}</Text>
                  </View>
                ) : null}
              </View>
              <Text style={{ color: colors.mutedForeground, fontSize: 11 }} numberOfLines={1}>{worktree.lastCommitSubject}</Text>
              <View style={{ flexDirection: 'row', gap: 8, marginTop: 4 }}>
                <TouchableOpacity
                  disabled={worktreeBusy !== null}
                  onPress={() => projectId && runWorktree(worktree.path, () => gitClient.openWorktree(projectId, worktree.path))}
                  style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 6, paddingHorizontal: 8, paddingVertical: 4 }}
                >
                  <Text style={{ color: colors.foreground, fontSize: 11, fontWeight: '600' }}>{t('gitPanel.worktrees.open')}</Text>
                </TouchableOpacity>
                <TouchableOpacity
                  disabled={worktreeBusy !== null || !worktree.branch || (worktree.ahead ?? 0) === 0}
                  onPress={() => setMergeTarget(worktree)}
                  style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 6, paddingHorizontal: 8, paddingVertical: 4 }}
                >
                  <Text style={{ color: colors.foreground, fontSize: 11, fontWeight: '600' }}>{t('gitPanel.worktrees.merge')}</Text>
                </TouchableOpacity>
                <TouchableOpacity
                  disabled={worktreeBusy !== null || worktree.isMain}
                  onPress={() => setRemoveTarget(worktree)}
                  style={{ borderWidth: 1, borderColor: colors.destructive + '55', borderRadius: 6, paddingHorizontal: 8, paddingVertical: 4 }}
                >
                  <Text style={{ color: colors.destructive, fontSize: 11, fontWeight: '600' }}>{t('gitPanel.worktrees.remove')}</Text>
                </TouchableOpacity>
                {scriptsStatus?.scripts?.run && projectId ? (
                  <WorktreeRunButton
                    colors={colors}
                    t={t}
                    running={(scriptsStatus?.runtimes?.[worktree.path]?.run?.status ?? 'idle') === 'running'}
                    port={scriptsStatus?.runtimes?.[worktree.path]?.run?.port}
                    disabled={worktreeBusy !== null || worktreeOp}
                    onPress={() => {
                      const running = (scriptsStatus?.runtimes?.[worktree.path]?.run?.status ?? 'idle') === 'running';
                      setWorktreeOp(true);
                      void (running ? gitClient.stopWorktreeScripts(projectId) : gitClient.runWorktreeScripts(projectId))
                        .then(() => refreshScripts())
                        .catch((err) => setActionError(err instanceof Error ? err.message : String(err)))
                        .finally(() => setWorktreeOp(false));
                    }}
                  />
                ) : null}
              </View>
            </View>
          ))}
        </ScrollView>
      )}

      <ActionSheet
        visible={projectSheet}
        items={projects.map((project) => ({
          label: project.displayName ?? project.name ?? project.id,
          onPress: () => setProjectId(project.id),
        }))}
        onClose={() => setProjectSheet(false)}
      />
      <ActionSheet
        visible={Boolean(askUserConfirm)}
        title={askUserConfirm?.message}
        items={[
          {
            label: askUserConfirm?.label ?? t('gitPanel.discard'),
            destructive: true,
            onPress: () => {
              askUserConfirm?.onConfirm();
            },
          },
        ]}
        onClose={() => setAskUserConfirm(null)}
      />

      <Modal visible={newBranchOpen} transparent animationType="fade" onRequestClose={() => setNewBranchOpen(false)}>
        <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', alignItems: 'center', justifyContent: 'center', padding: 24 }}>
          <View style={{ backgroundColor: colors.card, borderRadius: 12, padding: 16, width: '100%', gap: 10 }}>
            <Text style={{ color: colors.foreground, fontWeight: '600' }}>{t('gitPanel.createBranch')}</Text>
            <TextInput
              value={newBranchName}
              onChangeText={setNewBranchName}
              autoCapitalize="none"
              placeholder={t('gitPanel.newBranch.nameLabel')}
              placeholderTextColor={colors.mutedForeground}
              style={{ borderWidth: 1, borderColor: colors.input, borderRadius: 8, padding: 10, color: colors.foreground }}
            />
            <View style={{ flexDirection: 'row', gap: 8, justifyContent: 'flex-end' }}>
              <TouchableOpacity onPress={() => setNewBranchOpen(false)} style={{ paddingHorizontal: 12, paddingVertical: 8 }}>
                <Text style={{ color: colors.mutedForeground }}>{t('gitPanel.cancel')}</Text>
              </TouchableOpacity>
              <TouchableOpacity
                disabled={busy || !newBranchName.trim()}
                onPress={() => void createBranch()}
                style={{ backgroundColor: colors.primary, borderRadius: 8, paddingHorizontal: 14, paddingVertical: 8 }}
              >
                <Text style={{ color: colors.primaryForeground, fontWeight: '600' }}>{t('gitPanel.createBranch')}</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>
      <ConfirmModal request={confirmRequest} colors={colors} t={t} onClose={() => setConfirmRequest(null)} />
      <NewWorktreeModal
        visible={newWorktreeOpen}
        colors={colors}
        t={t}
        baseBranch={git.status?.branch ?? null}
        localBranches={git.branches.filter((branch) => !branch.remote).map((branch) => branch.name)}
        repositoryRoot={worktreeRepoRoot}
        isCreating={worktreeOp}
        onClose={() => setNewWorktreeOpen(false)}
        onCreate={(branch, baseBranch, openAfterCreate) => {
          if (!projectId) return;
          setWorktreeOp(true);
          void gitClient
            .createWorktree(projectId, branch, baseBranch)
            .then(async (result: any) => {
              const createdProjectId = result?.data?.project?.projectId;
              if (openAfterCreate && createdProjectId) setProjectId(createdProjectId);
              else await refreshWorktrees();
              setNewWorktreeOpen(false);
            })
            .catch((err) => setActionError(err instanceof Error ? err.message : String(err)))
            .finally(() => setWorktreeOp(false));
        }}
      />
      <MergeWorktreeModal
        visible={Boolean(mergeTarget)}
        colors={colors}
        t={t}
        worktreeBranch={mergeTarget?.branch ?? null}
        isMerging={worktreeOp}
        onClose={() => setMergeTarget(null)}
        onMerge={({ squash, message, removeAfterMerge }) => {
          if (!projectId || !mergeTarget) return;
          setWorktreeOp(true);
          void runWorktree(mergeTarget.path, () => gitClient.mergeWorktree(projectId, mergeTarget.path, squash, message, removeAfterMerge))
            .finally(() => {
              setWorktreeOp(false);
              setMergeTarget(null);
            });
        }}
      />
      <RemoveWorktreeModal
        visible={Boolean(removeTarget)}
        colors={colors}
        t={t}
        isDirty={(removeTarget?.changedFileCount ?? 0) > 0}
        hasBranch={Boolean(removeTarget?.branch)}
        isRemoving={worktreeOp}
        onClose={() => setRemoveTarget(null)}
        onRemove={({ force, deleteBranch: shouldDeleteBranch }) => {
          if (!projectId || !removeTarget) return;
          setWorktreeOp(true);
          void runWorktree(removeTarget.path, () => gitClient.removeWorktree(projectId, removeTarget.path, force, shouldDeleteBranch))
            .finally(() => {
              setWorktreeOp(false);
              setRemoveTarget(null);
            });
        }}
      />
      <WorktreeScriptsModal
        visible={scriptsOpen}
        colors={colors}
        t={t}
        config={scriptsStatus?.scripts ?? null}
        isSaving={worktreeOp}
        onClose={() => setScriptsOpen(false)}
        onSave={(next) => {
          if (!projectId) return;
          setWorktreeOp(true);
          void gitClient
            .saveWorktreeScripts(projectId, next.setup, next.run, next.runPort)
            .then(() => refreshScripts())
            .then(() => setScriptsOpen(false))
            .catch((err) => setActionError(err instanceof Error ? err.message : String(err)))
            .finally(() => setWorktreeOp(false));
        }}
      />
      <View style={{ height: insets.bottom }} />
    </View>
  );
}

type AreaConfirmation = { message: string; label: string; onConfirm: () => void };
