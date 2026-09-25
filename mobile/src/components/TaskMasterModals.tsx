import React, { useEffect, useState } from 'react';
import { ActivityIndicator, Alert, Modal, ScrollView, Text, TextInput, TouchableOpacity, View } from 'react-native';
import Markdown from 'react-native-markdown-display';
import { Download, Eye, Play, Sparkles, X } from 'lucide-react-native';
import { api } from '~shared/utils/api';
import type { ThemeColors } from '../theme';
import { createMarkdownRules } from './MarkdownBlocks';
import {
  PRD_TEMPLATE,
  computeTaskStats,
  defaultPrdName,
  ensurePrdExtension,
  nextTaskOf,
  stripPrdExtension,
  type PrdListItem,
} from '../lib/task-board';
import type { TaskMasterTask } from '../lib/tasks';

import type { TFunction } from 'i18next';
type T = TFunction;

/* ------------------------------------------------------------- next-task banner */

export function NextTaskBanner({
  tasks,
  colors,
  isDark,
  t,
  notConfigured,
  onStartTask,
  onShowAllTasks,
  onOpenTask,
}: {
  tasks: TaskMasterTask[];
  colors: ThemeColors;
  isDark: boolean;
  t: T;
  notConfigured: boolean;
  onStartTask: (task: TaskMasterTask) => void;
  onShowAllTasks: () => void;
  onOpenTask: (task: TaskMasterTask) => void;
}) {
  const [showDetails, setShowDetails] = useState(false);
  if (notConfigured) {
    return (
      <View style={{ borderWidth: 1, borderColor: '#93c5fd', backgroundColor: isDark ? '#0c1e3a' : '#eff6ff', borderRadius: 10, padding: 12, margin: 12, gap: 6 }}>
        <Text style={{ color: isDark ? '#bfdbfe' : '#1e40af', fontWeight: '700' }}>{t('nextTask.notConfigured')}</Text>
        <TouchableOpacity onPress={() => setShowDetails((value) => !value)}>
          <Text style={{ color: colors.primary, fontSize: 12 }}>{showDetails ? t('nextTask.hideDetails') : t('nextTask.whatIs')}</Text>
        </TouchableOpacity>
        {showDetails ? (
          <View style={{ gap: 2 }}>
            {[t('nextTask.feature1'), t('nextTask.feature2'), t('nextTask.feature3')].map((line, index) => (
              <Text key={index} style={{ color: isDark ? '#93c5fd' : '#1e3a8a', fontSize: 12 }}>• {line}</Text>
            ))}
          </View>
        ) : null}
      </View>
    );
  }
  const next = nextTaskOf(tasks);
  const stats = computeTaskStats(tasks);
  if (!next) {
    if (tasks.length === 0) return null;
    return (
      <View style={{ borderWidth: 1, borderColor: colors.border, backgroundColor: colors.card, borderRadius: 10, padding: 12, margin: 12, gap: 4 }}>
        <Text style={{ color: colors.foreground, fontWeight: '700' }}>
          {stats.completed === stats.total ? t('nextTask.allComplete') : t('nextTask.noPending')}
        </Text>
        <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{stats.completed}/{stats.total}</Text>
      </View>
    );
  }
  return (
    <View style={{ borderWidth: 1, borderColor: colors.border, backgroundColor: colors.card, borderRadius: 10, padding: 12, margin: 12, gap: 8 }}>
      <Text style={{ color: colors.mutedForeground, fontSize: 11, fontFamily: 'monospace' }}>{t('nextTask.taskId', { id: next.id })}</Text>
      <Text style={{ color: colors.foreground, fontWeight: '600' }} numberOfLines={2}>{next.title}</Text>
      <View style={{ flexDirection: 'row', alignItems: 'center', gap: 12 }}>
        <TouchableOpacity onPress={() => onStartTask(next)} style={{ flexDirection: 'row', alignItems: 'center', gap: 6, backgroundColor: colors.primary, borderRadius: 8, paddingHorizontal: 14, paddingVertical: 8 }}>
          <Play size={13} color={colors.primaryForeground} />
          <Text style={{ color: colors.primaryForeground, fontWeight: '600', fontSize: 13 }}>{t('nextTask.startTask')}</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={() => onOpenTask(next)} hitSlop={8}>
          <Text style={{ color: colors.primary, fontSize: 12 }}>{t('nextTask.viewDetails')}</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={onShowAllTasks} hitSlop={8}>
          <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('nextTask.viewAll')}</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

/* ------------------------------------------------------------- help modal */

export function HelpModal({ visible, colors, t, onClose, onCreatePrd }: { visible: boolean; colors: ThemeColors; t: T; onClose: () => void; onCreatePrd: () => void }) {
  const steps = ['createPRD', 'generateTasks', 'analyzeTasks', 'startBuilding'];
  const accents = ['#3b82f6', '#10b981', '#f59e0b', '#8b5cf6'];
  const tips = ['search', 'views', 'filters', 'details'];
  return (
    <Modal visible={visible} transparent animationType="slide" onRequestClose={onClose}>
      <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' }}>
        <View style={{ backgroundColor: colors.card, borderTopLeftRadius: 16, borderTopRightRadius: 16, maxHeight: '85%' }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', padding: 16, borderBottomWidth: 1, borderBottomColor: colors.border }}>
            <Text style={{ flex: 1, color: colors.foreground, fontSize: 16, fontWeight: '700' }}>{t('helpGuide.title')}</Text>
            <TouchableOpacity onPress={onClose} hitSlop={8}><X size={18} color={colors.mutedForeground} /></TouchableOpacity>
          </View>
          <ScrollView contentContainerStyle={{ padding: 16, gap: 12 }}>
            <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('helpGuide.subtitle')}</Text>
            {steps.map((step, index) => (
              <View key={step} style={{ borderLeftWidth: 3, borderLeftColor: accents[index], paddingLeft: 10, gap: 3 }}>
                <Text style={{ color: colors.foreground, fontWeight: '600' }}>{t(`gettingStarted.steps.${step}.title`)}</Text>
                <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t(`gettingStarted.steps.${step}.description`)}</Text>
                {step === 'createPRD' ? (
                  <TouchableOpacity onPress={onCreatePrd} style={{ alignSelf: 'flex-start', marginTop: 4 }}>
                    <Text style={{ color: colors.primary, fontSize: 12, fontWeight: '600' }}>{t('buttons.addPRD')}</Text>
                  </TouchableOpacity>
                ) : null}
              </View>
            ))}
            <View style={{ gap: 4, marginTop: 4 }}>
              <Text style={{ color: colors.foreground, fontWeight: '600' }}>{t('helpGuide.proTips.title')}</Text>
              {tips.map((tip) => (
                <Text key={tip} style={{ color: colors.mutedForeground, fontSize: 12 }}>• {t(`helpGuide.proTips.${tip}`)}</Text>
              ))}
            </View>
          </ScrollView>
        </View>
      </View>
    </Modal>
  );
}

/* ------------------------------------------------------------- setup modal */

export function SetupModal({ visible, colors, t, projectName, initializing, onClose, onInitialize }: { visible: boolean; colors: ThemeColors; t: T; projectName: string; initializing: boolean; onClose: () => void; onInitialize: () => Promise<void> }) {
  const [complete, setComplete] = useState(false);
  useEffect(() => { if (visible) setComplete(false); }, [visible]);
  const run = async () => {
    await onInitialize();
    setComplete(true);
    setTimeout(onClose, 800);
  };
  return (
    <Modal visible={visible} transparent animationType="fade" onRequestClose={onClose}>
      <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', padding: 24 }}>
        <View style={{ backgroundColor: colors.card, borderRadius: 12, padding: 20, gap: 12 }}>
          <Text style={{ color: colors.foreground, fontSize: 16, fontWeight: '700' }}>{t('setupModal.title')}</Text>
          <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('setupModal.subtitle', { projectName })}</Text>
          <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('setupModal.description')}</Text>
          {complete ? <Text style={{ color: '#16a34a', fontWeight: '600' }}>{t('setupModal.completed')}</Text> : null}
          <View style={{ flexDirection: 'row', justifyContent: 'flex-end', gap: 10, marginTop: 4 }}>
            <TouchableOpacity onPress={onClose} style={{ paddingVertical: 8, paddingHorizontal: 12 }}>
              <Text style={{ color: colors.mutedForeground }}>{complete ? t('setupModal.closeContinueButton') : t('setupModal.closeButton')}</Text>
            </TouchableOpacity>
            <TouchableOpacity onPress={() => void run()} disabled={initializing || complete} style={{ backgroundColor: colors.primary, borderRadius: 8, paddingVertical: 8, paddingHorizontal: 16, opacity: initializing ? 0.6 : 1 }}>
              <Text style={{ color: colors.primaryForeground, fontWeight: '600' }}>{initializing ? t('setupModal.initializing') : t('setupModal.initializeButton')}</Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>
    </Modal>
  );
}

/* ------------------------------------------------------------- PRD editor */

export function PrdEditorModal({
  visible,
  colors,
  isDark,
  t,
  projectId,
  file,
  isNewFile,
  existingNames,
  onClose,
  onSaved,
  download,
}: {
  visible: boolean;
  colors: ThemeColors;
  isDark: boolean;
  t: T;
  projectId: string | null;
  file: { name: string; content?: string } | null;
  isNewFile: boolean;
  existingNames: string[];
  onClose: () => void;
  onSaved: (fileName: string) => Promise<void> | void;
  download: (fileName: string, content: string) => Promise<void>;
}) {
  const [name, setName] = useState('');
  const [content, setContent] = useState('');
  const [preview, setPreview] = useState(false);
  const [wordWrap, setWordWrap] = useState(true);
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [generate, setGenerate] = useState(false);
  const isExisting = Boolean(file && !isNewFile);
  useEffect(() => {
    if (!visible) return;
    setName(file?.name ? stripPrdExtension(file.name) : defaultPrdName());
    setContent(isNewFile ? file?.content || PRD_TEMPLATE : file?.content ?? '');
    setPreview(false);
    setSaved(false);
    setError(null);
  }, [visible, file, isNewFile]);
  const lines = content.split('\n').length;
  const words = content.split(/\s+/).filter(Boolean).length;
  const save = async (allowOverwrite = false) => {
    if (!projectId || !content.trim() || !name.trim()) return;
    setSaving(true);
    setError(null);
    try {
      const fileName = ensurePrdExtension(name.trim());
      if (!allowOverwrite && !isExisting && existingNames.includes(fileName)) {
        // server overwrites silently; confirm only on a real name collision
        setSaving(false);
        Alert.alert('Overwrite?', `A PRD named "${fileName}" already exists. Overwrite it?`, [
          { text: 'Cancel', style: 'cancel' },
          { text: 'Overwrite', style: 'destructive', onPress: () => void save(true) },
        ]);
        return;
      }
      await api.post(`/taskmaster/prd/${encodeURIComponent(projectId)}`, { fileName, content });
      setSaved(true);
      setTimeout(() => setSaved(false), 2000);
      await onSaved(fileName);
    } catch (caught) {
      setError(caught instanceof Error ? caught.message : 'Failed to save PRD');
    } finally {
      setSaving(false);
    }
  };
  const markdownRules = createMarkdownRules({ colors, isDark, onOpenFile: () => {}, renderText: undefined });
  return (
    <Modal visible={visible} animationType="slide" onRequestClose={onClose}>
      <View style={{ flex: 1, backgroundColor: colors.background }}>
        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingHorizontal: 12, paddingVertical: 8, borderBottomWidth: 1, borderBottomColor: colors.border }}>
          <TextInput
            value={name}
            onChangeText={setName}
            placeholder="PRD filename"
            placeholderTextColor={colors.mutedForeground}
            maxLength={100}
            style={{ flex: 1, color: colors.foreground, borderWidth: 1, borderColor: colors.input, borderRadius: 8, paddingHorizontal: 10, paddingVertical: 6 }}
          />
          <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>.txt</Text>
          <TouchableOpacity onPress={() => setPreview((value) => !value)} hitSlop={8} style={{ padding: 4 }}>
            <Eye size={16} color={preview ? colors.primary : colors.mutedForeground} />
          </TouchableOpacity>
          <TouchableOpacity onPress={() => setWordWrap((value) => !value)} hitSlop={8} style={{ padding: 4 }}>
            <Text style={{ color: wordWrap ? colors.primary : colors.mutedForeground, fontSize: 11, fontWeight: '700' }}>WRAP</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => void download(ensurePrdExtension(name.trim()), content)} hitSlop={8} style={{ padding: 4 }}>
            <Download size={16} color={colors.mutedForeground} />
          </TouchableOpacity>
          <TouchableOpacity onPress={() => setGenerate(true)} disabled={!content.trim()} hitSlop={8} style={{ padding: 4, opacity: content.trim() ? 1 : 0.4 }}>
            <Sparkles size={16} color={colors.primary} />
          </TouchableOpacity>
          <TouchableOpacity onPress={() => void save(false)} disabled={saving || !content.trim()} style={{ paddingVertical: 6, paddingHorizontal: 12, borderRadius: 8, backgroundColor: saved ? '#16a34a' : colors.primary }}>
            <Text style={{ color: colors.primaryForeground, fontWeight: '600', fontSize: 12 }}>{saved ? 'Saved!' : saving ? 'Saving…' : 'Save PRD'}</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={onClose} hitSlop={8} style={{ padding: 4 }}><X size={18} color={colors.mutedForeground} /></TouchableOpacity>
        </View>
        {error ? <Text style={{ color: '#dc2626', fontSize: 12, paddingHorizontal: 16, paddingVertical: 6 }}>{error}</Text> : null}
        {preview ? (
          <ScrollView contentContainerStyle={{ padding: 16 }}>
            <Markdown style={markdownRules as any}>{content || ''}</Markdown>
          </ScrollView>
        ) : (
          <TextInput
            value={content}
            onChangeText={setContent}
            multiline
            textAlignVertical="top"
            scrollEnabled
            style={{ flex: 1, color: colors.foreground, fontFamily: 'monospace', fontSize: 13, padding: 12 }}
          />
        )}
        <View style={{ flexDirection: 'row', gap: 14, paddingHorizontal: 16, paddingVertical: 8, borderTopWidth: 1, borderTopColor: colors.border }}>
          <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>Lines: {lines}</Text>
          <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>Characters: {content.length}</Text>
          <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>Words: {words}</Text>
          <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>Format: Markdown</Text>
        </View>
        <Modal visible={generate} transparent animationType="fade" onRequestClose={() => setGenerate(false)}>
          <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', padding: 24 }}>
            <View style={{ backgroundColor: colors.card, borderRadius: 12, padding: 20, gap: 10 }}>
              <Text style={{ color: colors.foreground, fontSize: 16, fontWeight: '700' }}>Generate tasks from PRD</Text>
              <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>Ask the agent directly:</Text>
              <Text style={{ color: colors.foreground, fontFamily: 'monospace', fontSize: 12, backgroundColor: colors.muted, borderRadius: 8, padding: 10 }}>
                I have a PRD at .taskmaster/docs/{ensurePrdExtension(name.trim())}. Parse it and create the initial tasks.
              </Text>
              <TouchableOpacity onPress={() => setGenerate(false)} style={{ alignSelf: 'flex-end', marginTop: 4 }}>
                <Text style={{ color: colors.primary, fontWeight: '600' }}>Got it</Text>
              </TouchableOpacity>
            </View>
          </View>
        </Modal>
      </View>
    </Modal>
  );
}

/* ------------------------------------------------------------- PRD list */

export function PrdListSheet({ visible, colors, t, items, onOpen, onCreate, onClose }: { visible: boolean; colors: ThemeColors; t: T; items: PrdListItem[]; onOpen: (item: PrdListItem) => void; onCreate: () => void; onClose: () => void }) {
  return (
    <Modal visible={visible} transparent animationType="slide" onRequestClose={onClose}>
      <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' }}>
        <View style={{ backgroundColor: colors.card, borderTopLeftRadius: 16, borderTopRightRadius: 16, maxHeight: '80%', padding: 16, gap: 10 }}>
          <View style={{ flexDirection: 'row', alignItems: 'center' }}>
            <Text style={{ flex: 1, color: colors.foreground, fontSize: 16, fontWeight: '700' }}>{t('buttons.prds', 'PRDs')}</Text>
            <TouchableOpacity onPress={onCreate} style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
              <Text style={{ color: colors.primary, fontWeight: '600' }}>{t('buttons.addPRD', 'Add PRD')}</Text>
            </TouchableOpacity>
          </View>
          {items.length === 0 ? (
            <Text style={{ color: colors.mutedForeground, fontSize: 13 }}>{t('buttons.createNewPRD', 'Create a new PRD')}</Text>
          ) : (
            <ScrollView>
              {items.map((item) => (
                <TouchableOpacity key={item.name} onPress={() => onOpen(item)} style={{ paddingVertical: 12, borderBottomWidth: 1, borderBottomColor: colors.border }}>
                  <Text style={{ color: colors.foreground }}>{item.name}</Text>
                  {item.modified ? <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{t('prd.modified', { date: new Date(item.modified).toLocaleDateString() })}</Text> : null}
                </TouchableOpacity>
              ))}
            </ScrollView>
          )}
          <TouchableOpacity onPress={onClose} style={{ alignSelf: 'center', paddingVertical: 8 }}>
            <Text style={{ color: colors.mutedForeground }}>{t('taskDetail.close', 'Close')}</Text>
          </TouchableOpacity>
        </View>
      </View>
    </Modal>
  );
}

export function LoadingRow({ colors }: { colors: ThemeColors }) {
  return <View style={{ padding: 24, alignItems: 'center' }}><ActivityIndicator color={colors.primary} /></View>;
}
