import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import {
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
  ArrowRightLeft,
  ChevronDown,
  ChevronRight,
  Folder,
  GitBranch,
  GitPullRequest,
  Loader2,
  MessageSquare,
  MoreVertical,
  Plus,
  RefreshCw,
  SquareKanban,
  UserCircle2,
  X,
} from 'lucide-react-native';
import { api } from '~shared/utils/api';
import { useTheme } from '../theme';
import { useWebSocket } from '../contexts/WebSocketContext';
import { ActionSheet, ActionSheetItem } from '../components/ActionSheet';
import {
  BoardColumn,
  buildBoardColumns,
  CollabUser,
  CreateKanbanCardBody,
  KanbanCard,
  MOVE_TARGETS,
  useBoardConfig,
  useKanbanBoard,
} from '../lib/kanban';

interface Project {
  id: string;
  displayName?: string;
  name?: string;
  path?: string;
}

function initials(name: string): string {
  const parts = name.trim().split(/\s+/).filter(Boolean);
  if (parts.length === 0) return '?';
  if (parts.length === 1) return parts[0].slice(0, 2).toUpperCase();
  return `${parts[0][0]}${parts[1][0]}`.toUpperCase();
}

function relativeTime(value: string): string {
  const timestamp = new Date(value).getTime();
  if (!Number.isFinite(timestamp)) return '';
  const seconds = Math.max(0, Math.floor((Date.now() - timestamp) / 1000));
  if (seconds < 60) return 'now';
  const minutes = Math.floor(seconds / 60);
  if (minutes < 60) return `${minutes}m`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `${hours}h`;
  return `${Math.floor(hours / 24)}d`;
}

/** Assignee picker + activity feed sources. */
function useCollabUsers(): CollabUser[] {
  const [users, setUsers] = useState<CollabUser[]>([]);
  useEffect(() => {
    let cancelled = false;
    api.collab
      .users()
      .then(async (response) => {
        const payload = await response.json();
        if (!cancelled && response.ok && payload.success !== false) {
          setUsers(Array.isArray(payload.data?.users) ? payload.data.users : []);
        }
      })
      .catch(() => {});
    return () => {
      cancelled = true;
    };
  }, []);
  return users;
}

function ActivityFeed({ projectId, users }: { projectId: string; users: CollabUser[] }) {
  const { t } = useTranslation('tasks');
  const { colors } = useTheme();
  const { subscribe } = useWebSocket();
  const [expanded, setExpanded] = useState(false);
  const [events, setEvents] = useState<any[]>([]);

  const load = useCallback(async () => {
    try {
      const response = await api.collab.activity(projectId);
      const payload = await response.json();
      if (response.ok && payload.success !== false) {
        setEvents(Array.isArray(payload.data?.events) ? payload.data.events : []);
      }
    } catch {
      /* auxiliary */
    }
  }, [projectId]);

  useEffect(() => {
    if (expanded) void load();
  }, [expanded, load]);

  useEffect(
    () =>
      subscribe((event) => {
        if (expanded && typeof event?.type === 'string' && event.type.startsWith('kanban-') && event.projectId === projectId) {
          void load();
        }
      }),
    [subscribe, expanded, projectId, load],
  );

  return (
    <View style={{ borderTopWidth: 1, borderTopColor: colors.border }}>
      <TouchableOpacity
        onPress={() => setExpanded((previous) => !previous)}
        style={{ flexDirection: 'row', alignItems: 'center', gap: 6, paddingHorizontal: 16, paddingVertical: 8 }}
      >
        {expanded ? <ChevronDown size={14} color={colors.mutedForeground} /> : <ChevronRight size={14} color={colors.mutedForeground} />}
        <Text style={{ color: colors.mutedForeground, fontSize: 12, fontWeight: '600' }}>
          {t('board.activity.title', 'Activity')}
        </Text>
      </TouchableOpacity>
      {expanded ? (
        <View style={{ maxHeight: 180, paddingHorizontal: 16, paddingBottom: 12, gap: 6 }}>
          {events.length === 0 ? (
            <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('board.activity.empty', 'No activity yet')}</Text>
          ) : (
            <ScrollView>
              {events.map((event) => {
                const name = event.userId == null ? null : users.find((u) => u.id === event.userId)?.displayName ?? `#${event.userId}`;
                return (
                  <View key={event.id} style={{ flexDirection: 'row', gap: 8, marginBottom: 6 }}>
                    <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{relativeTime(event.createdAt)}</Text>
                    <Text style={{ color: colors.foreground, fontSize: 12, flex: 1 }} numberOfLines={2}>
                      {name ? <Text style={{ fontWeight: '600' }}>{name}: </Text> : null}
                      {event.summary}
                    </Text>
                  </View>
                );
              })}
            </ScrollView>
          )}
        </View>
      ) : null}
    </View>
  );
}

type CardProps = {
  card: KanbanCard;
  assigneeName?: string;
  onOpen: (card: KanbanCard) => void;
  onOpenSession: (card: KanbanCard) => void;
  onAbort: (card: KanbanCard) => void;
  onMenu: (card: KanbanCard) => void;
};

function KanbanCardItem({ card, assigneeName, onOpen, onOpenSession, onAbort, onMenu }: CardProps) {
  const { t } = useTranslation('tasks');
  const { colors } = useTheme();
  const isWorking = card.status === 'working';
  const needsDecision = card.status === 'needs_decision';

  return (
    <TouchableOpacity
      onPress={() => onOpen(card)}
      activeOpacity={0.8}
      style={{
        borderRadius: 10,
        borderWidth: 1,
        borderColor: needsDecision ? '#f59e0b' : colors.border,
        backgroundColor: colors.card,
        padding: 12,
        marginBottom: 8,
      }}
    >
      <View style={{ flexDirection: 'row', alignItems: 'flex-start', gap: 8 }}>
        <Text style={{ color: colors.foreground, fontSize: 14, fontWeight: '600', flex: 1 }}>{card.title}</Text>
        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6 }}>
          {assigneeName ? (
            <View style={{ height: 20, width: 20, borderRadius: 10, backgroundColor: colors.accent, alignItems: 'center', justifyContent: 'center' }}>
              <Text style={{ color: colors.primary, fontSize: 9, fontWeight: '700' }}>{initials(assigneeName)}</Text>
            </View>
          ) : null}
          <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{relativeTime(card.updatedAt)}</Text>
        </View>
      </View>

      {card.statusMessage ? (
        <View style={{ flexDirection: 'row', alignItems: 'flex-start', gap: 4, marginTop: 6 }}>
          {needsDecision ? <AlertCircle size={12} color="#f59e0b" style={{ marginTop: 2 }} /> : null}
          <Text style={{ color: needsDecision ? '#d97706' : colors.mutedForeground, fontSize: 12, flex: 1 }} numberOfLines={2}>
            {card.statusMessage}
          </Text>
        </View>
      ) : null}

      {card.branch || card.prUrl || card.sessionId ? (
        <View style={{ flexDirection: 'row', flexWrap: 'wrap', alignItems: 'center', gap: 12, marginTop: 8 }}>
          {card.branch ? (
            <View style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
              <GitBranch size={12} color={colors.mutedForeground} />
              <Text style={{ color: colors.mutedForeground, fontSize: 11 }} numberOfLines={1}>{card.branch}</Text>
            </View>
          ) : null}
          {card.prUrl ? (
            <View style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
              <GitPullRequest size={12} color={colors.mutedForeground} />
              <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{t('board.card.pullRequest')}</Text>
            </View>
          ) : null}
          {card.sessionId ? (
            <TouchableOpacity onPress={() => onOpenSession(card)} style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
              <MessageSquare size={12} color={colors.primary} />
              <Text style={{ color: colors.primary, fontSize: 11 }}>{t('board.card.openSession')}</Text>
            </TouchableOpacity>
          ) : null}
        </View>
      ) : null}

      {isWorking ? (
        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginTop: 8 }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
            <Loader2 size={12} color="#3b82f6" />
            <Text style={{ color: '#3b82f6', fontSize: 11, fontWeight: '600' }}>{t('board.card.running')}</Text>
          </View>
          <TouchableOpacity onPress={() => onAbort(card)}>
            <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{t('board.card.abort')}</Text>
          </TouchableOpacity>
        </View>
      ) : null}

      <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end', marginTop: 6 }}>
        <TouchableOpacity onPress={() => onMenu(card)} hitSlop={8} style={{ padding: 4 }}>
          <MoreVertical size={14} color={colors.mutedForeground} />
        </TouchableOpacity>
      </View>
    </TouchableOpacity>
  );
}

type DialogProps = {
  visible: boolean;
  onClose: () => void;
  onSubmit: (body: CreateKanbanCardBody) => Promise<void>;
  card: KanbanCard | null;
  users: CollabUser[];
};

function CardDialog({ visible, onClose, onSubmit, card, users }: DialogProps) {
  const { t } = useTranslation('tasks');
  const { colors } = useTheme();
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [assigneeUserId, setAssigneeUserId] = useState<number | null | undefined>(undefined);
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [comments, setComments] = useState<any[]>([]);
  const [draft, setDraft] = useState('');
  const { subscribe } = useWebSocket();

  useEffect(() => {
    if (!visible) return;
    setTitle(card?.title ?? '');
    setDescription(card?.description ?? '');
    setAssigneeUserId(card?.assigneeUserId ?? undefined);
    setError(null);
    setDraft('');
  }, [visible, card]);

  const loadComments = useCallback(async () => {
    if (!card) return;
    try {
      const response = await api.kanban.listComments(card.cardId);
      const payload = await response.json();
      if (response.ok && payload.success !== false) {
        setComments(Array.isArray(payload.data?.comments) ? payload.data.comments : []);
      }
    } catch {
      /* auxiliary */
    }
  }, [card]);

  useEffect(() => {
    if (visible && card) void loadComments();
  }, [visible, card, loadComments]);

  useEffect(
    () =>
      subscribe((event) => {
        if (visible && card && event?.type === 'kanban-comment-added' && event.cardId === card.cardId) void loadComments();
      }),
    [subscribe, visible, card, loadComments],
  );

  const handleSend = async () => {
    const body = draft.trim();
    if (!body || !card || isSaving) return;
    try {
      const response = await api.kanban.addComment(card.cardId, body);
      const payload = await response.json();
      if (response.ok && payload.success !== false && payload.data?.comment) {
        setComments((previous) => [...previous, payload.data.comment]);
        setDraft('');
      }
    } catch {
      /* ignore */
    }
  };

  const canSubmit = title.trim().length > 0 && !isSaving;
  const handleSubmit = async () => {
    if (!canSubmit) return;
    setIsSaving(true);
    setError(null);
    try {
      await onSubmit({
        title: title.trim(),
        description: description.trim(),
        ...(assigneeUserId !== undefined ? { assigneeUserId } : {}),
      });
      onClose();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to save card');
    } finally {
      setIsSaving(false);
    }
  };

  const [assigneeSheet, setAssigneeSheet] = useState(false);
  const authorName = (userId: number | null) =>
    userId === null ? t('board.comments.unknownAuthor', 'Someone') : users.find((u) => u.id === userId)?.displayName ?? `#${userId}`;

  return (
    <Modal visible={visible} transparent animationType="slide" onRequestClose={onClose}>
      <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' }}>
        <View style={{ backgroundColor: colors.card, borderTopLeftRadius: 16, borderTopRightRadius: 16, padding: 20, maxHeight: '90%' }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginBottom: 12 }}>
            <Text style={{ color: colors.foreground, fontSize: 16, fontWeight: '700' }}>
              {card ? t('board.dialog.editTitle') : t('board.dialog.createTitle')}
            </Text>
            <TouchableOpacity onPress={onClose} hitSlop={8}>
              <X size={18} color={colors.mutedForeground} />
            </TouchableOpacity>
          </View>

          <ScrollView keyboardShouldPersistTaps="handled">
            <Text style={{ color: colors.mutedForeground, fontSize: 12, marginBottom: 4 }}>{t('board.dialog.titleLabel')}</Text>
            <TextInput
              value={title}
              onChangeText={(value) => {
                setTitle(value);
                if (error) setError(null);
              }}
              placeholder={t('board.dialog.titlePlaceholder')}
              placeholderTextColor={colors.mutedForeground}
              style={{ borderWidth: 1, borderColor: colors.input, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10, color: colors.foreground, marginBottom: 12 }}
            />

            <Text style={{ color: colors.mutedForeground, fontSize: 12, marginBottom: 4 }}>{t('board.dialog.descriptionLabel')}</Text>
            <TextInput
              value={description}
              onChangeText={(value) => {
                setDescription(value);
                if (error) setError(null);
              }}
              placeholder={t('board.dialog.descriptionPlaceholder')}
              placeholderTextColor={colors.mutedForeground}
              multiline
              numberOfLines={4}
              style={{ borderWidth: 1, borderColor: colors.input, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10, color: colors.foreground, minHeight: 88, textAlignVertical: 'top', marginBottom: 12 }}
            />

            {users.length > 0 ? (
              <>
                <Text style={{ color: colors.mutedForeground, fontSize: 12, marginBottom: 4 }}>{t('board.assignee.label', 'Assignee')}</Text>
                <TouchableOpacity
                  onPress={() => setAssigneeSheet(true)}
                  style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', borderWidth: 1, borderColor: colors.input, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10, marginBottom: 12 }}
                >
                  <Text style={{ color: colors.foreground }}>
                    {assigneeUserId == null ? t('board.assignee.unassigned', 'Unassigned') : users.find((u) => u.id === assigneeUserId)?.displayName ?? `#${assigneeUserId}`}
                  </Text>
                  <ChevronDown size={16} color={colors.mutedForeground} />
                </TouchableOpacity>
              </>
            ) : null}

            {card ? (
              <View style={{ marginBottom: 12 }}>
                <Text style={{ color: colors.mutedForeground, fontSize: 12, marginBottom: 6 }}>{t('board.comments.label', 'Comments')}</Text>
                {comments.length > 0 ? (
                  <View style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 8, padding: 8, marginBottom: 8 }}>
                    {comments.map((comment) => (
                      <Text key={comment.id} style={{ color: colors.foreground, fontSize: 12, marginBottom: 4 }}>
                        <Text style={{ fontWeight: '600' }}>{authorName(comment.userId)} </Text>
                        {comment.body}
                      </Text>
                    ))}
                  </View>
                ) : null}
                <View style={{ flexDirection: 'row', gap: 6 }}>
                  <TextInput
                    value={draft}
                    onChangeText={setDraft}
                    placeholder={t('board.comments.placeholder', 'Write a comment…')}
                    placeholderTextColor={colors.mutedForeground}
                    onSubmitEditing={() => void handleSend()}
                    style={{ flex: 1, borderWidth: 1, borderColor: colors.input, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 8, color: colors.foreground }}
                  />
                  <TouchableOpacity onPress={() => void handleSend()} disabled={!draft.trim()} style={{ justifyContent: 'center', paddingHorizontal: 12 }}>
                    <Text style={{ color: draft.trim() ? colors.primary : colors.mutedForeground, fontWeight: '600' }}>{t('board.comments.send', 'Send')}</Text>
                  </TouchableOpacity>
                </View>
              </View>
            ) : null}

            {error ? <Text style={{ color: colors.destructive, fontSize: 12, marginBottom: 8 }}>{error}</Text> : null}
          </ScrollView>

          <View style={{ flexDirection: 'row', justifyContent: 'flex-end', gap: 8, marginTop: 8 }}>
            <TouchableOpacity onPress={onClose} style={{ paddingVertical: 10, paddingHorizontal: 16 }}>
              <Text style={{ color: colors.mutedForeground }}>{t('board.dialog.cancel')}</Text>
            </TouchableOpacity>
            <TouchableOpacity
              onPress={() => void handleSubmit()}
              disabled={!canSubmit}
              style={{ backgroundColor: canSubmit ? colors.primary : colors.muted, borderRadius: 8, paddingVertical: 10, paddingHorizontal: 20 }}
            >
              <Text style={{ color: canSubmit ? colors.primaryForeground : colors.mutedForeground, fontWeight: '600' }}>{t('board.dialog.save')}</Text>
            </TouchableOpacity>
          </View>
        </View>

        <ActionSheet
          visible={assigneeSheet}
          title={t('board.assignee.label', 'Assignee')}
          items={[
            { label: t('board.assignee.unassigned', 'Unassigned'), onPress: () => setAssigneeUserId(null) },
            ...users.map((user) => ({ label: user.displayName, onPress: () => setAssigneeUserId(user.id) })),
          ]}
          onClose={() => setAssigneeSheet(false)}
        />
      </View>
    </Modal>
  );
}

export default function BoardScreen() {
  const { t } = useTranslation('tasks');
  const { colors, isDark } = useTheme();
  const insets = useSafeAreaInsets();
  const navigation = useNavigation<any>();
  const { width } = useWindowDimensions();
  const columnWidth = Math.min(width * 0.85, 340);

  const [projects, setProjects] = useState<Project[]>([]);
  const [projectId, setProjectId] = useState<string | null>(null);
  const [projectSheet, setProjectSheet] = useState(false);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingCard, setEditingCard] = useState<KanbanCard | null>(null);
  const [sheet, setSheet] = useState<{ title?: string; items: ActionSheetItem[] } | null>(null);
  const [activeColumn, setActiveColumn] = useState(0);
  const [assigneeFilter, setAssigneeFilter] = useState('all');

  const carouselRef = useRef<ScrollView>(null);
  const users = useCollabUsers();
  const activeProject = projects.find((p) => p.id === projectId) ?? null;
  const { cards, isLoading, error, refreshCards, createCard, updateCard, moveCard, abortCard, deleteCard } = useKanbanBoard(projectId);

  useEffect(() => {
    void (async () => {
      try {
        const res = await api.projects();
        if (!res.ok) return;
        const data = await res.json();
        const raw: any[] = Array.isArray(data) ? data : data?.data?.projects ?? data?.projects ?? [];
        const normalized = raw.map((p) => ({ ...p, id: p.id ?? p.projectId }));
        setProjects(normalized);
        setProjectId((current) => (current && normalized.some((p) => p.id === current) ? current : normalized[0]?.id ?? null));
      } catch {
        /* leave empty */
      }
    })();
  }, []);

  const filteredCards = useMemo(() => {
    if (assigneeFilter === 'all') return cards;
    if (assigneeFilter === 'none') return cards.filter((card) => card.assigneeUserId === null);
    return cards.filter((card) => card.assigneeUserId === Number(assigneeFilter));
  }, [cards, assigneeFilter]);

  const columns: BoardColumn[] = useMemo(
    () => buildBoardColumns(filteredCards, isDark, (key) => t(key)),
    [filteredCards, isDark, t],
  );

  const usersById = useMemo(() => new Map(users.map((user) => [user.id, user])), [users]);
  const assigneeFilterLabel =
    assigneeFilter === 'all'
      ? t('board.assignee.label', 'Assignee')
      : assigneeFilter === 'none'
        ? t('board.assignee.unassigned', 'Unassigned')
        : usersById.get(Number(assigneeFilter))?.displayName ?? assigneeFilter;

  const openSession = useCallback(
    (sessionId: string) => navigation.navigate('Chat' as never, { sessionId } as never),
    [navigation],
  );

  const handleOpenCard = useCallback(
    (card: KanbanCard) => {
      if (card.sessionId) {
        openSession(card.sessionId);
        return;
      }
      setEditingCard(card);
      setDialogOpen(true);
    },
    [openSession],
  );

  const cardMenu = (card: KanbanCard) => {
    const moveItems: ActionSheetItem[] = MOVE_TARGETS[card.status].map((status) => ({
      label: `${t('board.card.moveTo', 'Move to')}: ${t(`board.columns.${status === 'needs_decision' ? 'needsDecision' : status}`)}`,
      onPress: () => void moveCard(card.cardId, status),
    }));
    setSheet({
      title: card.title,
      items: [
        ...moveItems,
        { label: t('board.card.edit', 'Edit'), onPress: () => { setEditingCard(card); setDialogOpen(true); } },
        {
          label: t('board.card.delete'),
          destructive: true,
          onPress: () => void deleteCard(card.cardId),
        },
      ],
    });
  };

  const handleSubmitCard = async (body: CreateKanbanCardBody) => {
    if (editingCard) {
      await updateCard(editingCard.cardId, body);
      return;
    }
    const created = await createCard(body);
    if (created && body.assigneeUserId !== undefined) {
      await updateCard(created.cardId, { assigneeUserId: body.assigneeUserId }).catch(() => {});
    }
  };

  const closeDialog = () => {
    setDialogOpen(false);
    setEditingCard(null);
  };

  const scrollToColumn = (index: number) => {
    carouselRef.current?.scrollTo({ x: index * columnWidth, animated: true });
    setActiveColumn(index);
  };

  const handleCarouselEnd = (offsetX: number) => {
    const index = Math.round(offsetX / columnWidth);
    setActiveColumn(Math.max(0, Math.min(columns.length - 1, index)));
  };

  return (
    <View style={{ flex: 1, backgroundColor: colors.background }}>
      <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingHorizontal: 12, paddingVertical: 8, borderBottomWidth: 1, borderBottomColor: colors.border }}>
        <TouchableOpacity onPress={() => setProjectSheet(true)} style={{ flex: 1, flexDirection: 'row', alignItems: 'center', gap: 6 }}>
          <Folder size={16} color={colors.foreground} />
          <Text style={{ color: colors.foreground, fontWeight: '600', fontSize: 14 }} numberOfLines={1}>
            {activeProject?.displayName ?? activeProject?.name ?? t('board.title', 'Agent Board')}
          </Text>
          <ChevronDown size={14} color={colors.mutedForeground} />
        </TouchableOpacity>
        {users.length > 0 ? (
          <TouchableOpacity
            onPress={() =>
              setSheet({
                title: t('board.assignee.label', 'Assignee'),
                items: [
                  { label: t('board.assignee.all', 'All assignees'), onPress: () => setAssigneeFilter('all') },
                  { label: t('board.assignee.unassigned', 'Unassigned'), onPress: () => setAssigneeFilter('none') },
                  ...users.map((user) => ({ label: user.displayName, onPress: () => setAssigneeFilter(String(user.id)) })),
                ],
              })
            }
            style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}
          >
            <UserCircle2 size={18} color={colors.mutedForeground} />
            <Text style={{ color: colors.mutedForeground, fontSize: 12 }} numberOfLines={1}>{assigneeFilterLabel}</Text>
          </TouchableOpacity>
        ) : null}
        {projectId ? <BoardAgentSettings projectId={projectId} /> : null}
        <TouchableOpacity onPress={() => void refreshCards()} disabled={isLoading} hitSlop={8} style={{ padding: 4 }}>
          <RefreshCw size={16} color={isLoading ? colors.primary : colors.mutedForeground} />
        </TouchableOpacity>
        <TouchableOpacity onPress={() => { setEditingCard(null); setDialogOpen(true); }} hitSlop={8} style={{ padding: 4 }}>
          <Plus size={20} color={colors.primary} />
        </TouchableOpacity>
      </View>

      {error ? <Text style={{ color: colors.destructive, fontSize: 12, paddingHorizontal: 16, paddingVertical: 6 }}>{error}</Text> : null}

      {!activeProject ? (
        <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', padding: 32 }}>
          <SquareKanban size={40} color={colors.mutedForeground} />
          <Text style={{ color: colors.foreground, fontWeight: '600', marginTop: 12 }}>{t('board.empty.title')}</Text>
          <Text style={{ color: colors.mutedForeground, textAlign: 'center', marginTop: 6 }}>{t('board.noProject', 'Add a project first, then create cards for it.')}</Text>
        </View>
      ) : (
        <>
          <ScrollView horizontal showsHorizontalScrollIndicator={false} style={{ flexGrow: 0 }} contentContainerStyle={{ gap: 6, paddingHorizontal: 12, paddingVertical: 8 }}>
            {columns.map((column, index) => (
              <TouchableOpacity
                key={column.id}
                onPress={() => scrollToColumn(index)}
                style={{
                  flexDirection: 'row',
                  alignItems: 'center',
                  gap: 6,
                  borderRadius: 999,
                  paddingHorizontal: 12,
                  paddingVertical: 4,
                  backgroundColor: activeColumn === index ? colors.primary : colors.muted,
                }}
              >
                <View style={{ height: 8, width: 8, borderRadius: 4, backgroundColor: column.accent }} />
                <Text style={{ color: activeColumn === index ? colors.primaryForeground : colors.mutedForeground, fontSize: 12, fontWeight: '600' }}>{column.title}</Text>
                <Text style={{ color: activeColumn === index ? colors.primaryForeground : colors.mutedForeground, fontSize: 10, fontWeight: '700' }}>{column.cards.length}</Text>
              </TouchableOpacity>
            ))}
          </ScrollView>

          <ScrollView
            ref={carouselRef}
            horizontal
            showsHorizontalScrollIndicator={false}
            snapToInterval={columnWidth}
            decelerationRate="fast"
            onMomentumScrollEnd={(event) => handleCarouselEnd(event.nativeEvent.contentOffset.x)}
            contentContainerStyle={{ paddingHorizontal: 12, paddingBottom: 12, gap: 16 }}
            style={{ flex: 1 }}
          >
            {columns.map((column) => (
              <View key={column.id} style={{ width: columnWidth - 16 }}>
                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', borderRadius: 10, paddingHorizontal: 12, paddingVertical: 8, backgroundColor: column.headerBg }}>
                  <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
                    <View style={{ height: 8, width: 8, borderRadius: 4, backgroundColor: column.accent }} />
                    <Text style={{ color: column.headerText, fontSize: 14, fontWeight: '700' }}>{column.title}</Text>
                  </View>
                  <Text style={{ color: column.headerText, fontSize: 12 }}>{column.cards.length}</Text>
                </View>
                <ScrollView style={{ maxHeight: 520, marginTop: 8 }} contentContainerStyle={{ paddingBottom: 4 }}>
                  {column.cards.map((card) => (
                    <KanbanCardItem
                      key={card.cardId}
                      card={card}
                      assigneeName={card.assigneeUserId == null ? undefined : usersById.get(card.assigneeUserId)?.displayName ?? `#${card.assigneeUserId}`}
                      onOpen={handleOpenCard}
                      onOpenSession={(c) => c.sessionId && openSession(c.sessionId)}
                      onAbort={(c) => void abortCard(c.cardId)}
                      onMenu={cardMenu}
                    />
                  ))}
                  {column.cards.length === 0 ? (
                    <TouchableOpacity
                      onPress={() => { setEditingCard(null); setDialogOpen(true); }}
                      style={{ borderWidth: 1, borderStyle: 'dashed', borderColor: colors.border, borderRadius: 8, paddingVertical: 10, alignItems: 'center', flexDirection: 'row', justifyContent: 'center', gap: 4 }}
                    >
                      <Plus size={14} color={colors.mutedForeground} />
                      <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('board.addCard', 'Add card')}</Text>
                    </TouchableOpacity>
                  ) : null}
                </ScrollView>
              </View>
            ))}
          </ScrollView>

          <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 6, paddingVertical: 6 }}>
            {columns.map((column, index) => (
              <TouchableOpacity
                key={column.id}
                onPress={() => scrollToColumn(index)}
                style={{ height: 6, width: activeColumn === index ? 20 : 6, borderRadius: 3, backgroundColor: activeColumn === index ? colors.primary : colors.border }}
              />
            ))}
          </View>

          <ActivityFeed projectId={activeProject.id} users={users} />
        </>
      )}

      <View style={{ height: insets.bottom }} />

      <ActionSheet
        visible={projectSheet}
        title={t('board.projectLabel', 'Project')}
        items={projects.map((project) => ({
          label: project.displayName ?? project.name ?? project.id,
          onPress: () => {
            setProjectId(project.id);
            setActiveColumn(0);
          },
        }))}
        onClose={() => setProjectSheet(false)}
      />

      <ActionSheet visible={Boolean(sheet)} title={sheet?.title} items={sheet?.items ?? []} onClose={() => setSheet(null)} />

      <CardDialog visible={dialogOpen} onClose={closeDialog} onSubmit={handleSubmitCard} card={editingCard} users={users} />
    </View>
  );
}

/** Compact provider/model/effort menus that seed agent values for new cards. */
function BoardAgentSettings({ projectId }: { projectId: string }) {
  const { t } = useTranslation('tasks');
  const { colors } = useTheme();
  const { config, providers, modelOptions, effortOptions, save } = useBoardConfig(projectId);
  const [sheet, setSheet] = useState<{ title: string; items: ActionSheetItem[] } | null>(null);

  return (
    <>
      <TouchableOpacity
        onPress={() =>
          setSheet({
            title: t('board.agent.provider', 'Agent'),
            items: [
              { label: t('board.agent.anyProvider', 'Any agent'), onPress: () => void save({ provider: null, model: null, effort: null }) },
              ...providers.map((provider) => ({ label: provider, onPress: () => void save({ provider, model: null, effort: null }) })),
            ],
          })
        }
        hitSlop={8}
        style={{ padding: 4 }}
      >
        <Text style={{ color: config.provider ? colors.primary : colors.mutedForeground, fontSize: 12 }}>{config.provider ?? t('board.agent.provider', 'Agent')}</Text>
      </TouchableOpacity>
      {config.provider ? (
        <TouchableOpacity
          onPress={() =>
            setSheet({
              title: t('board.agent.model', 'Model'),
              items: [
                { label: t('board.agent.defaultModel', 'Default model'), onPress: () => void save({ model: null }) },
                ...modelOptions.map((option) => ({ label: option.label, onPress: () => void save({ model: option.value, effort: null }) })),
              ],
            })
          }
          hitSlop={8}
          style={{ padding: 4 }}
        >
          <Text style={{ color: colors.mutedForeground, fontSize: 12 }} numberOfLines={1}>
            {config.model ?? t('board.agent.defaultModel', 'Default model')}
          </Text>
        </TouchableOpacity>
      ) : null}
      {config.model && effortOptions.length > 0 ? (
        <TouchableOpacity
          onPress={() =>
            setSheet({
              title: t('board.agent.effort', 'Reasoning'),
              items: [
                { label: t('board.agent.defaultEffort', 'Default'), onPress: () => void save({ effort: null }) },
                ...effortOptions.map((option) => ({ label: option.value, onPress: () => void save({ effort: option.value }) })),
              ],
            })
          }
          hitSlop={8}
          style={{ padding: 4 }}
        >
          <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{config.effort ?? t('board.agent.effort', 'Reasoning')}</Text>
        </TouchableOpacity>
      ) : null}
      <ActionSheet visible={Boolean(sheet)} title={sheet?.title} items={sheet?.items ?? []} onClose={() => setSheet(null)} />
    </>
  );
}
