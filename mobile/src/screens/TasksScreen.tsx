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
  ArrowRight,
  CheckCircle,
  ChevronDown,
  ChevronUp,
  Circle,
  ClipboardCheck,
  Clock,
  Folder,
  Grid,
  LayoutGrid,
  List,
  Minus,
  Pause,
  Play,
  Plus,
  RefreshCw,
  Search,
  X,
} from 'lucide-react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { api } from '~shared/utils/api';
import { useTheme } from '../theme';
import { ActionSheet, ActionSheetItem } from '../components/ActionSheet';
import {
  buildTaskColumns,
  PRIORITY_OPTIONS,
  sortTasks,
  STATUS_OPTIONS,
  TaskId,
  TaskKanbanColumn,
  TasksView,
  TaskMasterTask,
  useTasksBoard,
} from '../lib/tasks';
interface Project {
  id: string;
  displayName?: string;
  name?: string;
  path?: string;
}
function statusIcon(status?: string, color?: string) {
  const size = 16;
  if (status === 'done') return <CheckCircle size={size} color="#16a34a" />;
  if (status === 'in-progress') return <Clock size={size} color="#2563eb" />;
  if (status === 'review') return <AlertCircle size={size} color="#d97706" />;
  if (status === 'deferred') return <Pause size={size} color={color} />;
  if (status === 'cancelled') return <X size={size} color="#dc2626" />;
  return <Circle size={size} color={color} />;
}
function priorityIcon(priority: string | undefined) {
  if (priority === 'high') return <ChevronUp size={12} color="#dc2626" />;
  if (priority === 'medium') return <Minus size={12} color="#d97706" />;
  if (priority === 'low') return <Circle size={6} color="#2563eb" />;
  return <Circle size={6} color="#9ca3af" />;
}
function priorityBadgeStyle(priority: string | undefined, isDark: boolean) {
  if (priority === 'high') return { bg: isDark ? '#450a0a' : '#fef2f2', text: isDark ? '#fca5a5' : '#b91c1c' };
  if (priority === 'medium') return { bg: isDark ? '#451a03' : '#fffbeb', text: isDark ? '#fcd34d' : '#b45309' };
  if (priority === 'low') return { bg: isDark ? '#172554' : '#eff6ff', text: isDark ? '#93c5fd' : '#1d4ed8' };
  return { bg: isDark ? '#1f2937' : '#f9fafb', text: isDark ? '#9ca3af' : '#4b5563' };
}
function getSubtaskProgress(task: TaskMasterTask) {
  const subtasks = task.subtasks ?? [];
  const total = subtasks.length;
  const completed = subtasks.filter((subtask) => subtask.status === 'done').length;
  return { completed, total, percentage: total > 0 ? Math.round((completed / total) * 100) : 0 };
}
function TaskCard({ task, onOpen, onRun }: { task: TaskMasterTask; onOpen: () => void; onRun: () => void }) {
  const { t } = useTranslation('tasks');
  const { colors, isDark } = useTheme();
  const progress = getSubtaskProgress(task);
  const badge = priorityBadgeStyle(task.priority, isDark);
  const running = task.status === 'in-progress';
  return (
    <TouchableOpacity
      onPress={onOpen}
      activeOpacity={0.8}
      style={{
        backgroundColor: colors.card,
        borderWidth: 1,
        borderColor: colors.border,
        borderRadius: 10,
        padding: 12,
        gap: 10,
        marginBottom: 10,
      }}
    >
      <View style={{ flexDirection: 'row', justifyContent: 'space-between', gap: 8 }}>
        <View style={{ flex: 1 }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6, marginBottom: 4 }}>
            {statusIcon(task.status, colors.mutedForeground)}
            <Text style={{ color: colors.mutedForeground, fontSize: 11, fontFamily: 'monospace' }}>{String(task.id)}</Text>
          </View>
          <Text style={{ color: colors.foreground, fontSize: 14, fontWeight: '500' }} numberOfLines={2}>
            {task.title}
          </Text>
        </View>
        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6 }}>
          <View style={{ height: 16, width: 16, borderRadius: 4, alignItems: 'center', justifyContent: 'center', backgroundColor: badge.bg }}>
            {priorityIcon(task.priority)}
          </View>
          <TouchableOpacity onPress={onRun} hitSlop={8} style={{ height: 24, width: 24, alignItems: 'center', justifyContent: 'center' }}>
            <Play size={14} color={running ? colors.primary : colors.mutedForeground} />
          </TouchableOpacity>
        </View>
      </View>
      <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
          {Array.isArray(task.dependencies) && task.dependencies.length > 0 ? (
            <>
              <ArrowRight size={11} color="#d97706" />
              <Text style={{ color: '#d97706', fontSize: 11 }}>
                {t('card.dependsOnList', { tasks: task.dependencies.join(', '), defaultValue: 'Depends on: {{tasks}}' })}
              </Text>
            </>
          ) : null}
        </View>
        {progress.total > 0 ? (
          <View style={{ alignItems: 'flex-end' }}>
            <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>
              {t('card.progressLabel', 'Progress:')} {progress.percentage}%
            </Text>
            <View style={{ height: 4, width: 60, borderRadius: 2, backgroundColor: colors.muted, marginTop: 2 }}>
              <View style={{ height: 4, width: (60 * progress.percentage) / 100, borderRadius: 2, backgroundColor: colors.primary }} />
            </View>
          </View>
        ) : (
          <Text style={{ fontSize: 10, fontWeight: '600', color: badge.text, backgroundColor: badge.bg, borderRadius: 4, paddingHorizontal: 8, paddingVertical: 2, textTransform: 'capitalize' }}>
            {t(`priorities.${task.priority ?? 'medium'}`, task.priority ?? 'medium')}
          </Text>
        )}
      </View>
    </TouchableOpacity>
  );
}
function CompactTaskRow({ task, onOpen, onRun, onToggle }: { task: TaskMasterTask; onOpen: () => void; onRun: () => void; onToggle: () => void }) {
  const { t } = useTranslation('tasks');
  const { colors, isDark } = useTheme();
  const isDone = task.status === 'done';
  const badge = priorityBadgeStyle(task.priority, isDark);
  return (
    <TouchableOpacity
      onPress={onOpen}
      activeOpacity={0.8}
      style={{ flexDirection: 'row', alignItems: 'center', gap: 10, paddingHorizontal: 12, paddingVertical: 10, borderBottomWidth: 1, borderBottomColor: colors.border, backgroundColor: colors.card }}
    >
      <TouchableOpacity onPress={onToggle} hitSlop={8}>
        {statusIcon(task.status, colors.mutedForeground)}
      </TouchableOpacity>
      <Text style={{ color: colors.mutedForeground, fontSize: 11, fontFamily: 'monospace' }}>{String(task.id)}</Text>
      <Text style={{ flex: 1, color: isDone ? colors.mutedForeground : colors.foreground, fontSize: 13, textDecorationLine: isDone ? 'line-through' : 'none' }} numberOfLines={1}>
        {task.title}
      </Text>
      <Text style={{ fontSize: 10, fontWeight: '600', color: badge.text, backgroundColor: badge.bg, borderRadius: 4, paddingHorizontal: 6, paddingVertical: 2, textTransform: 'capitalize' }}>
        {t(`priorities.${task.priority ?? 'medium'}`, task.priority ?? 'medium')}
      </Text>
      <TouchableOpacity onPress={onRun} hitSlop={8}>
        <Play size={14} color={task.status === 'in-progress' ? colors.primary : colors.mutedForeground} />
      </TouchableOpacity>
    </TouchableOpacity>
  );
}
function TaskEmptyState({ hasTaskMaster, onInitialize, initializing }: { hasTaskMaster: boolean; onInitialize: () => void; initializing: boolean }) {
  const { t } = useTranslation('tasks');
  const { colors } = useTheme();
  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', padding: 32, gap: 12 }}>
      <ClipboardCheck size={44} color={colors.mutedForeground} />
      <Text style={{ color: colors.foreground, fontWeight: '700', fontSize: 16, textAlign: 'center' }}>
        {hasTaskMaster ? t('board.empty.title') : t('notConfigured.title', 'TaskMaster AI is not configured')}
      </Text>
      <Text style={{ color: colors.mutedForeground, fontSize: 13, textAlign: 'center' }}>
        {hasTaskMaster ? t('board.empty.description', 'Create a task to get started.') : t('notConfigured.description')}
      </Text>
      {!hasTaskMaster ? (
        <TouchableOpacity
          onPress={onInitialize}
          disabled={initializing}
          style={{ backgroundColor: colors.primary, borderRadius: 8, paddingHorizontal: 20, paddingVertical: 10, opacity: initializing ? 0.6 : 1 }}
        >
          <Text style={{ color: colors.primaryForeground, fontWeight: '600' }}>
            {initializing ? t('setupModal.initializing', 'Initializing...') : t('notConfigured.initializeButton', 'Initialize TaskMaster AI')}
          </Text>
        </TouchableOpacity>
      ) : null}
    </View>
  );
}
type DetailProps = {
  task: TaskMasterTask | null;
  onClose: () => void;
  onStatusChange: (status: string) => void;
  onSave: (updates: Partial<TaskMasterTask>) => Promise<void>;
  onDelete: () => Promise<void>;
};
function TaskDetailSheet({ task, onClose, onStatusChange, onSave, onDelete }: DetailProps) {
  const { t } = useTranslation('tasks');
  const { colors } = useTheme();
  const [editing, setEditing] = useState(false);
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [priority, setPriority] = useState('medium');
  const [dependencies, setDependencies] = useState('');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [sheet, setSheet] = useState<{ title: string; items: ActionSheetItem[] } | null>(null);
  useEffect(() => {
    if (!task) return;
    setTitle(task.title ?? '');
    setDescription(task.description ?? '');
    setPriority(task.priority ?? 'medium');
    setDependencies((task.dependencies ?? []).map(String).join(', '));
    setEditing(false);
    setError(null);
  }, [task]);
  if (!task) return null;
  const save = async () => {
    if (!title.trim()) {
      setError(t('taskDetail.titleRequired', 'Title is required'));
      return;
    }
    setSaving(true);
    setError(null);
    try {
      await onSave({
        title: title.trim(),
        description,
        priority,
        dependencies: dependencies.split(',').map((entry) => entry.trim()).filter(Boolean),
      });
      setEditing(false);
    } catch (caught) {
      setError(caught instanceof Error ? caught.message : t('taskDetail.updateFailed', 'Failed to update task'));
    } finally {
      setSaving(false);
    }
  };
  return (
    <Modal visible transparent animationType="slide" onRequestClose={onClose}>
      <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' }}>
        <View style={{ backgroundColor: colors.card, borderTopLeftRadius: 16, borderTopRightRadius: 16, maxHeight: '90%' }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 10, padding: 16, borderBottomWidth: 1, borderBottomColor: colors.border }}>
            {statusIcon(task.status, colors.mutedForeground)}
            <View style={{ flex: 1 }}>
              <Text style={{ color: colors.mutedForeground, fontSize: 11, fontFamily: 'monospace' }}>{t('taskDetail.taskId', { id: task.id, defaultValue: 'Task {{id}}' })}</Text>
              {editing ? (
                <TextInput
                  value={title}
                  onChangeText={setTitle}
                  style={{ color: colors.foreground, fontSize: 16, fontWeight: '700', borderBottomWidth: 1, borderBottomColor: colors.primary }}
                />
              ) : (
                <Text style={{ color: colors.foreground, fontSize: 16, fontWeight: '700' }} numberOfLines={2}>{task.title}</Text>
              )}
            </View>
            <TouchableOpacity onPress={() => (editing ? void save() : setEditing(true))} disabled={saving} hitSlop={8} style={{ padding: 4 }}>
              <Text style={{ color: saving ? colors.mutedForeground : colors.primary, fontWeight: '600' }}>
                {editing ? t('taskDetail.save', 'Save') : t('taskDetail.edit', 'Edit task')}
              </Text>
            </TouchableOpacity>
            <TouchableOpacity onPress={onClose} hitSlop={8} style={{ padding: 4 }}>
              <X size={18} color={colors.mutedForeground} />
            </TouchableOpacity>
          </View>
          {error ? <Text style={{ color: colors.destructive, fontSize: 12, paddingHorizontal: 16, paddingVertical: 8 }}>{error}</Text> : null}
          <ScrollView keyboardShouldPersistTaps="handled" contentContainerStyle={{ padding: 16, gap: 14 }}>
            <View style={{ flexDirection: 'row', gap: 12 }}>
              <View style={{ flex: 1, gap: 4 }}>
                <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('taskDetail.status', 'Status')}</Text>
                <TouchableOpacity
                  onPress={() =>
                    setSheet({
                      title: t('taskDetail.status', 'Status'),
                      items: STATUS_OPTIONS.map((option) => ({
                        label: t(`statuses.${option}`, option),
                        onPress: () => onStatusChange(option),
                      })),
                    })
                  }
                  style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', borderWidth: 1, borderColor: colors.input, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10 }}
                >
                  <Text style={{ color: colors.foreground }}>{t(`statuses.${task.status ?? 'pending'}`, task.status ?? 'pending')}</Text>
                  <ChevronDown size={14} color={colors.mutedForeground} />
                </TouchableOpacity>
              </View>
              <View style={{ flex: 1, gap: 4 }}>
                <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('taskDetail.priority', 'Priority')}</Text>
                {editing ? (
                  <TouchableOpacity
                    onPress={() =>
                      setSheet({
                        title: t('taskDetail.priority', 'Priority'),
                        items: PRIORITY_OPTIONS.map((option) => ({
                          label: t(`priorities.${option}`, option),
                          onPress: () => setPriority(option),
                        })),
                      })
                    }
                    style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', borderWidth: 1, borderColor: colors.input, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10 }}
                  >
                    <Text style={{ color: colors.foreground, textTransform: 'capitalize' }}>{t(`priorities.${priority}`, priority)}</Text>
                    <ChevronDown size={14} color={colors.mutedForeground} />
                  </TouchableOpacity>
                ) : (
                  <View style={{ borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10, backgroundColor: priorityBadgeStyle(task.priority, false).bg }}>
                    <Text style={{ color: priorityBadgeStyle(task.priority, false).text, textTransform: 'capitalize' }}>
                      {task.priority ? t(`priorities.${task.priority}`, task.priority) : t('taskDetail.priorityNotSet', 'Not set')}
                    </Text>
                  </View>
                )}
              </View>
            </View>
            <View style={{ gap: 4 }}>
              <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('taskDetail.dependencies', 'Dependencies')}</Text>
              {editing ? (
                <TextInput
                  value={dependencies}
                  onChangeText={setDependencies}
                  placeholder={t('taskDetail.dependenciesPlaceholder', 'e.g. 1, 2, 3')}
                  placeholderTextColor={colors.mutedForeground}
                  style={{ borderWidth: 1, borderColor: colors.input, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10, color: colors.foreground }}
                />
              ) : Array.isArray(task.dependencies) && task.dependencies.length > 0 ? (
                <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 6 }}>
                  {task.dependencies.map((dependency) => (
                    <Text key={String(dependency)} style={{ color: '#1d4ed8', backgroundColor: '#dbeafe', borderRadius: 4, paddingHorizontal: 8, paddingVertical: 3, fontSize: 12 }}>
                      {dependency}
                    </Text>
                  ))}
                </View>
              ) : (
                <Text style={{ color: colors.mutedForeground, fontSize: 13 }}>{t('taskDetail.noDependencies', 'No dependencies')}</Text>
              )}
            </View>
            <View style={{ gap: 4 }}>
              <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('taskDetail.description', 'Description')}</Text>
              {editing ? (
                <TextInput
                  value={description}
                  onChangeText={setDescription}
                  multiline
                  numberOfLines={4}
                  style={{ borderWidth: 1, borderColor: colors.input, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10, color: colors.foreground, minHeight: 88, textAlignVertical: 'top' }}
                />
              ) : (
                <Text style={{ color: colors.foreground, fontSize: 13 }}>{task.description || t('taskDetail.noDescription', 'No description provided')}</Text>
              )}
            </View>
            {task.details ? (
              <View style={{ gap: 4 }}>
                <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('taskDetail.implDetails', 'Implementation Details')}</Text>
                <Text style={{ color: colors.foreground, fontSize: 13 }}>{task.details}</Text>
              </View>
            ) : null}
            {task.testStrategy ? (
              <View style={{ gap: 4 }}>
                <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('taskDetail.testStrategy', 'Test Strategy')}</Text>
                <Text style={{ color: colors.foreground, fontSize: 13 }}>{task.testStrategy}</Text>
              </View>
            ) : null}
            <TouchableOpacity onPress={() => void onDelete()} style={{ paddingVertical: 10 }}>
              <Text style={{ color: colors.destructive, fontWeight: '600' }}>{t('taskDetail.delete', 'Delete task')}</Text>
            </TouchableOpacity>
          </ScrollView>
        </View>
        <ActionSheet visible={Boolean(sheet)} title={sheet?.title} items={sheet?.items ?? []} onClose={() => setSheet(null)} />
      </View>
    </Modal>
  );
}
function CreateTaskDialog({ visible, onClose, onSubmit }: { visible: boolean; onClose: () => void; onSubmit: (body: { title: string; description?: string; priority?: string }) => Promise<void> }) {
  const { t } = useTranslation('tasks');
  const { colors } = useTheme();
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [priority, setPriority] = useState('medium');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [sheet, setSheet] = useState(false);
  useEffect(() => {
    if (visible) {
      setTitle('');
      setDescription('');
      setPriority('medium');
      setError(null);
    }
  }, [visible]);
  const canSubmit = title.trim().length > 0 && !saving;
  const submit = async () => {
    if (!canSubmit) return;
    setSaving(true);
    setError(null);
    try {
      await onSubmit({ title: title.trim(), description: description.trim(), priority });
      onClose();
    } catch (caught) {
      setError(caught instanceof Error ? caught.message : t('createTask.error', 'Failed to add task'));
    } finally {
      setSaving(false);
    }
  };
  return (
    <Modal visible={visible} transparent animationType="slide" onRequestClose={onClose}>
      <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' }}>
        <View style={{ backgroundColor: colors.card, borderTopLeftRadius: 16, borderTopRightRadius: 16, padding: 20 }}>
          <Text style={{ color: colors.foreground, fontSize: 16, fontWeight: '700', marginBottom: 12 }}>{t('createTask.title', 'Add Task')}</Text>
          <Text style={{ color: colors.mutedForeground, fontSize: 12, marginBottom: 4 }}>{t('createTask.titleLabel', 'Title')}</Text>
          <TextInput
            value={title}
            onChangeText={(value) => { setTitle(value); if (error) setError(null); }}
            placeholder={t('createTask.titlePlaceholder', 'What needs to be done?')}
            placeholderTextColor={colors.mutedForeground}
            style={{ borderWidth: 1, borderColor: colors.input, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10, color: colors.foreground, marginBottom: 12 }}
          />
          <Text style={{ color: colors.mutedForeground, fontSize: 12, marginBottom: 4 }}>{t('createTask.descriptionLabel', 'Description')}</Text>
          <TextInput
            value={description}
            onChangeText={setDescription}
            placeholder={t('createTask.descriptionPlaceholder', 'Optional details')}
            placeholderTextColor={colors.mutedForeground}
            multiline
            numberOfLines={3}
            style={{ borderWidth: 1, borderColor: colors.input, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10, color: colors.foreground, minHeight: 72, textAlignVertical: 'top', marginBottom: 12 }}
          />
          <Text style={{ color: colors.mutedForeground, fontSize: 12, marginBottom: 4 }}>{t('createTask.priorityLabel', 'Priority')}</Text>
          <TouchableOpacity
            onPress={() => setSheet(true)}
            style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', borderWidth: 1, borderColor: colors.input, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10, marginBottom: 12 }}
          >
            <Text style={{ color: colors.foreground, textTransform: 'capitalize' }}>{t(`priorities.${priority}`, priority)}</Text>
            <ChevronDown size={14} color={colors.mutedForeground} />
          </TouchableOpacity>
          {error ? <Text style={{ color: colors.destructive, fontSize: 12, marginBottom: 8 }}>{error}</Text> : null}
          <View style={{ flexDirection: 'row', justifyContent: 'flex-end', gap: 8 }}>
            <TouchableOpacity onPress={onClose} style={{ paddingVertical: 10, paddingHorizontal: 16 }}>
              <Text style={{ color: colors.mutedForeground }}>{t('createTask.cancel', 'Cancel')}</Text>
            </TouchableOpacity>
            <TouchableOpacity onPress={() => void submit()} disabled={!canSubmit} style={{ backgroundColor: canSubmit ? colors.primary : colors.muted, borderRadius: 8, paddingVertical: 10, paddingHorizontal: 20 }}>
              <Text style={{ color: canSubmit ? colors.primaryForeground : colors.mutedForeground, fontWeight: '600' }}>
                {saving ? t('createTask.submitting', 'Adding...') : t('createTask.submit', 'Add Task')}
              </Text>
            </TouchableOpacity>
          </View>
        </View>
        <ActionSheet
          visible={sheet}
          title={t('createTask.priorityLabel', 'Priority')}
          items={PRIORITY_OPTIONS.map((option) => ({ label: t(`priorities.${option}`, option), onPress: () => setPriority(option) }))}
          onClose={() => setSheet(false)}
        />
      </View>
    </Modal>
  );
}
export default function TasksScreen() {
  const { t } = useTranslation('tasks');
  const { colors, isDark } = useTheme();
  const insets = useSafeAreaInsets();
  const navigation = useNavigation<any>();
  const { width } = useWindowDimensions();
  const columnWidth = Math.min(width * 0.85, 340);
  const [projects, setProjects] = useState<Project[]>([]);
  const [projectId, setProjectId] = useState<string | null>(null);
  const [projectSheet, setProjectSheet] = useState(false);
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [priorityFilter, setPriorityFilter] = useState('all');
  const [view, setView] = useState<TasksView>('kanban');
  const [filterSheet, setFilterSheet] = useState(false);
  const [filterSubSheet, setFilterSubSheet] = useState<{ title: string; items: ActionSheetItem[] } | null>(null);
  const [activeColumn, setActiveColumn] = useState(0);
  const [selectedTask, setSelectedTask] = useState<TaskMasterTask | null>(null);
  const [createOpen, setCreateOpen] = useState(false);
  const [initializing, setInitializing] = useState(false);
  const [installed, setInstalled] = useState<boolean | null>(null);
  const carouselRef = useRef<ScrollView>(null);
  const activeProject = projects.find((project) => project.id === projectId) ?? null;
  const { tasks, error, refresh, updateTask, deleteTask, addTask, statuses, priorities } = useTasksBoard(projectId);
  useEffect(() => {
    void (async () => {
      try {
        const res = await api.projects();
        if (!res.ok) return;
        const data = await res.json();
        const raw: any[] = Array.isArray(data) ? data : data?.data?.projects ?? data?.projects ?? [];
        const normalized = raw.map((project) => ({ ...project, id: project.id ?? project.projectId }));
        setProjects(normalized);
        setProjectId((current) => (current && normalized.some((project) => project.id === current) ? current : normalized[0]?.id ?? null));
      } catch {
        /* leave empty */
      }
    })();
  }, []);
  useEffect(() => {
    void api.get('/taskmaster/installation-status').then(async (response) => {
      const payload = await response.json().catch(() => null);
      setInstalled(Boolean(payload?.installation?.isInstalled));
    }).catch(() => {});
  }, []);
  const filtered = useMemo(() => {
    const term = search.trim().toLowerCase();
    const matched = tasks.filter((task) => {
      const status = task.status ?? 'pending';
      const priority = task.priority ?? 'medium';
      const matchesSearch = !term || task.title.toLowerCase().includes(term) || String(task.id).includes(term);
      return matchesSearch && (statusFilter === 'all' || status === statusFilter) && (priorityFilter === 'all' || priority === priorityFilter);
    });
    return sortTasks(matched, 'id', 'asc');
  }, [tasks, search, statusFilter, priorityFilter]);
  const columns: TaskKanbanColumn[] = useMemo(
    () => buildTaskColumns(filtered, isDark, (key) => t(key)),
    [filtered, isDark, t],
  );
  const scrollToColumn = (index: number) => {
    carouselRef.current?.scrollTo({ x: index * columnWidth, animated: true });
    setActiveColumn(index);
  };
  const runTask = useCallback(
    async (task: TaskMasterTask) => {
      const prompt = `/task-master start ${task.id}`;
      try {
        if (projectId) {
          await updateTask(task.id, { status: 'in-progress' });
          await AsyncStorage.setItem(`chat-draft-new-${projectId}`, prompt).catch(() => {});
        }
      } catch {
        /* still navigate */
      }
      navigation.navigate('Chat' as never, { newSession: true, projectId, projectPath: activeProject?.path } as never);
    },
    [projectId, activeProject?.path, updateTask, navigation],
  );
  const openTask = (task: TaskMasterTask) => setSelectedTask(task);
  const handleInitialize = async () => {
    if (!projectId) return;
    setInitializing(true);
    try {
      await api.taskmaster.init(projectId);
      setInstalled(true);
      await refresh();
    } catch {
      /* ignore */
    } finally {
      setInitializing(false);
    }
  };
  return (
    <View style={{ flex: 1, backgroundColor: colors.background }}>
      <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingHorizontal: 12, paddingVertical: 8, borderBottomWidth: 1, borderBottomColor: colors.border }}>
        <TouchableOpacity onPress={() => setProjectSheet(true)} style={{ flex: 1, flexDirection: 'row', alignItems: 'center', gap: 6 }}>
          <Folder size={16} color={colors.foreground} />
          <Text style={{ color: colors.foreground, fontWeight: '600', fontSize: 14 }} numberOfLines={1}>
            {activeProject?.displayName ?? activeProject?.name ?? t('board.title', 'Tasks')}
          </Text>
          <ChevronDown size={14} color={colors.mutedForeground} />
        </TouchableOpacity>
        <TouchableOpacity onPress={() => void refresh()} hitSlop={8} style={{ padding: 4 }}>
          <RefreshCw size={16} color={colors.mutedForeground} />
        </TouchableOpacity>
        <TouchableOpacity onPress={() => setCreateOpen(true)} hitSlop={8} style={{ padding: 4 }} disabled={!projectId}>
          <Plus size={20} color={colors.primary} />
        </TouchableOpacity>
      </View>
      <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingHorizontal: 12, paddingVertical: 8 }}>
        <View style={{ flex: 1, flexDirection: 'row', alignItems: 'center', gap: 6, borderWidth: 1, borderColor: colors.input, borderRadius: 8, paddingHorizontal: 10 }}>
          <Search size={14} color={colors.mutedForeground} />
          <TextInput
            value={search}
            onChangeText={setSearch}
            placeholder={t('search.placeholder')}
            placeholderTextColor={colors.mutedForeground}
            style={{ flex: 1, color: colors.foreground, paddingVertical: 8 }}
          />
        </View>
        <View style={{ flexDirection: 'row', borderRadius: 8, backgroundColor: colors.muted, padding: 2 }}>
          {([['kanban', LayoutGrid], ['list', List], ['grid', Grid]] as const).map(([mode, Icon]) => (
            <TouchableOpacity key={mode} onPress={() => setView(mode)} style={{ padding: 6, borderRadius: 6, backgroundColor: view === mode ? colors.card : 'transparent' }}>
              <Icon size={16} color={view === mode ? colors.foreground : colors.mutedForeground} />
            </TouchableOpacity>
          ))}
        </View>
        <TouchableOpacity onPress={() => setFilterSheet(true)} hitSlop={8} style={{ padding: 6 }}>
          <Text style={{ color: statusFilter !== 'all' || priorityFilter !== 'all' ? colors.primary : colors.mutedForeground, fontSize: 12, fontWeight: '600' }}>
            {t('filters.button')}
          </Text>
        </TouchableOpacity>
      </View>
      {error ? <Text style={{ color: colors.destructive, fontSize: 12, paddingHorizontal: 16, paddingBottom: 4 }}>{error}</Text> : null}
      {tasks.length === 0 ? (
        <TaskEmptyState hasTaskMaster={installed !== false} onInitialize={handleInitialize} initializing={initializing} />
      ) : filtered.length === 0 ? (
        <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', padding: 32, gap: 6 }}>
          <Search size={40} color={colors.mutedForeground} />
          <Text style={{ color: colors.foreground, fontWeight: '600' }}>{t('noMatchingTasks.title')}</Text>
          <Text style={{ color: colors.mutedForeground, textAlign: 'center' }}>{t('noMatchingTasks.description')}</Text>
        </View>
      ) : view === 'kanban' ? (
        <>
          <ScrollView horizontal showsHorizontalScrollIndicator={false} style={{ flexGrow: 0 }} contentContainerStyle={{ gap: 6, paddingHorizontal: 12, paddingVertical: 6 }}>
            {columns.map((column, index) => (
              <TouchableOpacity
                key={column.id}
                onPress={() => scrollToColumn(index)}
                style={{ flexDirection: 'row', alignItems: 'center', gap: 6, borderRadius: 999, paddingHorizontal: 12, paddingVertical: 4, backgroundColor: activeColumn === index ? colors.primary : colors.muted }}
              >
                <Text style={{ color: activeColumn === index ? colors.primaryForeground : colors.mutedForeground, fontSize: 12, fontWeight: '600' }}>{column.title}</Text>
                <Text style={{ color: activeColumn === index ? colors.primaryForeground : colors.mutedForeground, fontSize: 10, fontWeight: '700' }}>{column.tasks.length}</Text>
              </TouchableOpacity>
            ))}
          </ScrollView>
          <ScrollView
            ref={carouselRef}
            horizontal
            showsHorizontalScrollIndicator={false}
            snapToInterval={columnWidth}
            decelerationRate="fast"
            onMomentumScrollEnd={(event) => setActiveColumn(Math.max(0, Math.min(columns.length - 1, Math.round(event.nativeEvent.contentOffset.x / columnWidth))))}
            contentContainerStyle={{ paddingHorizontal: 12, paddingBottom: 12, gap: 16 }}
            style={{ flex: 1 }}
          >
            {columns.map((column) => (
              <View key={column.id} style={{ width: columnWidth - 16 }}>
                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', borderRadius: 10, paddingHorizontal: 12, paddingVertical: 8, backgroundColor: column.headerBg }}>
                  <Text style={{ color: column.headerText, fontSize: 14, fontWeight: '700' }}>{column.title}</Text>
                  <Text style={{ color: column.headerText, fontSize: 12 }}>{column.tasks.length}</Text>
                </View>
                <ScrollView style={{ maxHeight: 520, marginTop: 8 }}>
                  {column.tasks.map((task) => (
                    <TaskCard key={String(task.id)} task={task} onOpen={() => openTask(task)} onRun={() => void runTask(task)} />
                  ))}
                  {column.tasks.length === 0 ? (
                    <Text style={{ color: colors.mutedForeground, fontSize: 12, textAlign: 'center', paddingVertical: 24 }}>{t('kanban.noTasksYet')}</Text>
                  ) : null}
                </ScrollView>
              </View>
            ))}
          </ScrollView>
          <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 6, paddingVertical: 6 }}>
            {columns.map((column, index) => (
              <TouchableOpacity key={column.id} onPress={() => scrollToColumn(index)} style={{ height: 6, width: activeColumn === index ? 20 : 6, borderRadius: 3, backgroundColor: activeColumn === index ? colors.primary : colors.border }} />
            ))}
          </View>
        </>
      ) : view === 'list' ? (
        <ScrollView style={{ flex: 1 }}>
          {filtered.map((task) => (
            <CompactTaskRow
              key={String(task.id)}
              task={task}
              onOpen={() => openTask(task)}
              onRun={() => void runTask(task)}
              onToggle={() => void updateTask(task.id, { status: task.status === 'done' ? 'pending' : 'done' })}
            />
          ))}
        </ScrollView>
      ) : (
        <ScrollView key="grid" contentContainerStyle={{ padding: 12 }} style={{ flex: 1 }}>
          {filtered.map((task) => (
            <TaskCard key={String(task.id)} task={task} onOpen={() => openTask(task)} onRun={() => void runTask(task)} />
          ))}
        </ScrollView>
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
      <ActionSheet
        visible={filterSheet}
        title={t('filters.button', 'Filters')}
        items={[
          {
            label: `${t('filters.status', 'Status')}: ${statusFilter === 'all' ? t('filters.allStatuses', 'All Statuses') : t(`statuses.${statusFilter}`, statusFilter)}`,
            onPress: () => {
              setFilterSheet(false);
              setFilterSubSheet({
                title: t('filters.status', 'Status'),
                items: [{ label: t('filters.allStatuses', 'All Statuses'), onPress: () => setStatusFilter('all') }, ...statuses.map((status) => ({ label: t(`statuses.${status}`, status), onPress: () => setStatusFilter(status) }))],
              });
            },
          },
          {
            label: `${t('filters.priority', 'Priority')}: ${priorityFilter === 'all' ? t('filters.allPriorities', 'All Priorities') : t(`priorities.${priorityFilter}`, priorityFilter)}`,
            onPress: () => {
              setFilterSheet(false);
              setFilterSubSheet({
                title: t('filters.priority', 'Priority'),
                items: [{ label: t('filters.allPriorities', 'All Priorities'), onPress: () => setPriorityFilter('all') }, ...priorities.map((priority) => ({ label: t(`priorities.${priority}`, priority), onPress: () => setPriorityFilter(priority) }))],
              });
            },
          },
          {
            label: t('filters.clearFilters', 'Clear Filters'),
            onPress: () => {
              setSearch('');
              setStatusFilter('all');
              setPriorityFilter('all');
            },
          },
        ]}
        onClose={() => setFilterSheet(false)}
      />
      <ActionSheet
        visible={Boolean(filterSubSheet)}
        title={filterSubSheet?.title}
        items={filterSubSheet?.items ?? []}
        onClose={() => setFilterSubSheet(null)}
      />
      <TaskDetailSheet
        task={selectedTask}
        onClose={() => setSelectedTask(null)}
        onStatusChange={(status) => {
          if (selectedTask) void updateTask(selectedTask.id, { status });
        }}
        onSave={async (updates) => {
          if (selectedTask) await updateTask(selectedTask.id, updates);
        }}
        onDelete={async () => {
          if (!selectedTask) return;
          await deleteTask(selectedTask.id);
          setSelectedTask(null);
        }}
      />
      <CreateTaskDialog visible={createOpen} onClose={() => setCreateOpen(false)} onSubmit={async (body) => { await addTask(body); }} />
    </View>
  );
}
