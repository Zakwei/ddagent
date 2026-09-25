import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { ActivityIndicator, Alert, Image, Modal, ScrollView, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { useNavigation, useRoute } from '@react-navigation/native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { WebView } from 'react-native-webview';
import {
  AlertCircle, ChevronDown, ChevronUp, Copy, Download, Eye, FileWarning, Pencil, Pin, Save, X,
} from 'lucide-react-native';
import * as Clipboard from 'expo-clipboard';
import * as FileSystem from 'expo-file-system/legacy';
import * as Sharing from 'expo-sharing';
import { useTranslation } from 'react-i18next';
import { api, getStoredAuthToken } from '~shared/utils/api';
import { useTheme } from '../theme';
import { usePinnedFiles } from '../lib/pinned-files';
import { getServerUrlSync } from '../lib/server-config';
import { useProviderSettings } from '../lib/provider-settings-store';
import { tokenizeCode, normalizeLanguage, syntaxStyleFor } from '../lib/highlight';
import { buildDiffLines } from '../lib/git';
import { useToast, Toast } from '../components/Toast';
import Markdown from 'react-native-markdown-display';
import { createMarkdownRules } from '../components/MarkdownBlocks';
import {
  changeIndices, languageForPath, previewKindFor, splitLines, stepChange, type PreviewKind,
} from '../lib/editor';

const PREVIEW_LIMIT = 400 * 1024;

type Row = { text: string; types: string[]; line: number } | { hunk: string };

export default function EditorScreen() {
  const { colors, isDark } = useTheme();
  const insets = useSafeAreaInsets();
  const navigation = useNavigation<any>();
  const route = useRoute<any>();
  const { projectId, filePath, diffInfo, line } = route.params ?? {};
  const { t } = useTranslation('codeEditor');
  const { toast, show: showToast } = useToast();
  const { codeEditor } = useProviderSettings();
  const { isPinned, pinFile, unpinFile } = usePinnedFiles(projectId);
  const pinned = isPinned(filePath);

  const kind: PreviewKind = useMemo(() => previewKindFor(filePath ?? ''), [filePath]);
  const isMarkdown = kind === 'markdown';

  const [mode, setMode] = useState<'preview' | 'edit'>('preview');
  const [markdownPreview, setMarkdownPreview] = useState(isMarkdown);
  const [content, setContent] = useState<string | null>(null);
  const [loadedContent, setLoadedContent] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [savedAt, setSavedAt] = useState(false);
  const [showDiff, setShowDiff] = useState(Boolean(diffInfo?.old_string !== undefined));
  const [diffLines, setDiffLines] = useState<ReturnType<typeof buildDiffLines> | null>(null);
  const [changeIdx, setChangeIdx] = useState(-1);
  const [fullscreenImage, setFullscreenImage] = useState(false);
  const scrollRef = useRef<ScrollView>(null);
  const dirty = content !== null && loadedContent !== null && content !== loadedContent;

  const editorUri = useMemo(() => {
    const base = getServerUrlSync();
    const token = getStoredAuthToken();
    if (!base || !token) return null;
    return `${base}/island/editor?project=${encodeURIComponent(projectId)}&path=${encodeURIComponent(filePath)}&token=${encodeURIComponent(token)}`;
  }, [projectId, filePath]);

  const mediaUri = useMemo(() => {
    const base = getServerUrlSync();
    if (!base) return null;
    return `${base}/api/file-tree/projects/${encodeURIComponent(projectId)}/files/content?path=${encodeURIComponent(filePath)}`;
  }, [projectId, filePath]);

  useEffect(() => {
    let cancelled = false;
    setLoading(true);
    setError(null);
    if (kind === 'binary') {
      setLoading(false);
      return undefined;
    }
    (async () => {
      try {
        const res = await api.readFile(projectId, filePath);
        if (!res.ok) {
          if (!cancelled) setError(`http-${res.status}`);
          return;
        }
        const data = await res.json().catch(() => null);
        const text = typeof data === 'string' ? data : data?.content ?? '';
        if (!cancelled) {
          const sliced = text.length > PREVIEW_LIMIT ? text.slice(0, PREVIEW_LIMIT) : text;
          setContent(sliced);
          setLoadedContent(sliced);
        }
      } catch (err) {
        if (!cancelled) setError(err instanceof Error ? err.message : 'load failed');
      } finally {
        if (!cancelled) setLoading(false);
      }
    })();
    return () => { cancelled = true; };
  }, [projectId, filePath, kind]);

  useEffect(() => {
    if (!showDiff || diffInfo?.old_string === undefined) return;
    const oldL = splitLines(diffInfo.old_string).map((l) => `- ${l.text}`);
    const newL = splitLines(diffInfo.new_string ?? '').map((l) => `+ ${l.text}`);
    const diff = `@@ changes @@\n${oldL.join('\n')}\n${newL.join('\n')}`;
    setDiffLines(buildDiffLines(diff));
  }, [showDiff, diffInfo]);

  // Unsaved-changes guard on back navigation.
  useEffect(() => {
    const unsub = navigation.addListener('beforeRemove', (e: any) => {
      if (!dirty || mode === 'edit') return;
      e.preventDefault();
      Alert.alert(t('actions.save', 'Save'), 'Discard unsaved changes?', [
        { text: 'Cancel', style: 'cancel' },
        { text: 'Discard', style: 'destructive', onPress: () => navigation.dispatch(e.data.action) },
        { text: t('actions.save', 'Save'), onPress: async () => { await save(); navigation.dispatch(e.data.action); } },
      ]);
    });
    return unsub;
  }, [dirty, mode, content]);

  const save = useCallback(async () => {
    if (content === null || loading || error || kind !== 'code') return;
    setSaving(true);
    try {
      const res = await api.saveFile(projectId, filePath, content);
      if (!res.ok) {
        const data = await res.json().catch(() => ({}));
        showToast(data?.error || `Save failed: ${res.status}`, 'error');
        return;
      }
      setLoadedContent(content);
      setSavedAt(true);
      showToast(t('actions.saved', 'Saved!'), 'success');
      setTimeout(() => setSavedAt(false), 2000);
    } catch (e) {
      showToast(e instanceof Error ? e.message : 'Save failed', 'error');
    } finally {
      setSaving(false);
    }
  }, [content, loading, error, kind, projectId, filePath, showToast, t]);

  const download = useCallback(async () => {
    if (content === null) return;
    try {
      const target = `${FileSystem.cacheDirectory}${filePath.split(/[\\/]/).pop()}`;
      await FileSystem.writeAsStringAsync(target, content, { encoding: FileSystem.EncodingType.UTF8 });
      if (await Sharing.isAvailableAsync()) await Sharing.shareAsync(target);
    } catch {
      showToast('Download failed', 'error');
    }
  }, [content, filePath, showToast]);

  const copyPath = useCallback(async () => {
    await Clipboard.setStringAsync(filePath);
    showToast(t('actions.pathCopied', 'File path copied'), 'success');
  }, [filePath, showToast, t]);

  // Syntax-tokenized preview rows (code only).
  const rows: Row[] = useMemo(() => {
    if (kind !== 'code' || content === null) return [];
    const lang = languageForPath(filePath ?? '');
    const lines = splitLines(content).slice(0, 4000);
    const out: Row[] = [];
    for (const l of lines) {
      const tokens = tokenizeCode(l.text, lang);
      tokens.forEach((tk, i) => out.push({ text: tk.text, types: tk.types, line: i === 0 ? l.number : -1 }));
    }
    if (lines.length === 0) out.push({ text: '', types: [], line: 1 });
    return out;
  }, [kind, content, filePath]);

  const changes = useMemo(() => (diffLines ? changeIndices(diffLines.map((d) => d.kind)) : []), [diffLines]);
  const goChange = (delta: number) => {
    if (changes.length === 0) return;
    const next = stepChange(changeIdx, changes.length, delta);
    setChangeIdx(next);
    const rowIndex = changes[next];
    scrollRef.current?.scrollTo({ y: Math.max(0, (rowIndex - 2) * (Number(codeEditor.fontSize) + 6)), animated: true });
  };

  const header = (
    <View style={{ flexDirection: 'row', alignItems: 'center', gap: 10, paddingHorizontal: 12, paddingVertical: 8, borderBottomWidth: 1, borderBottomColor: colors.border, backgroundColor: colors.card }}>
      <TouchableOpacity onPress={() => navigation.goBack()} hitSlop={10}>
        <X size={18} color={colors.mutedForeground} />
      </TouchableOpacity>
      <Text numberOfLines={1} style={{ flex: 1, color: colors.foreground, fontSize: 13, fontWeight: '600', fontFamily: 'monospace' }}>
        {filePath?.split(/[\\/]/).pop()}
      </Text>
      {diffInfo?.old_string !== undefined ? (
        <TouchableOpacity onPress={() => setShowDiff((v) => !v)} hitSlop={8}>
          <ChevronUp size={16} color={showDiff ? colors.primary : colors.mutedForeground} />
        </TouchableOpacity>
      ) : null}
      {changes.length > 0 && showDiff ? (
        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
          <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{changeIdx + 1}/{changes.length}</Text>
          <TouchableOpacity onPress={() => goChange(-1)} hitSlop={6}><ChevronUp size={16} color={colors.mutedForeground} /></TouchableOpacity>
          <TouchableOpacity onPress={() => goChange(1)} hitSlop={6}><ChevronDown size={16} color={colors.mutedForeground} /></TouchableOpacity>
        </View>
      ) : null}
      {isMarkdown ? (
        <TouchableOpacity onPress={() => setMarkdownPreview((v) => !v)} hitSlop={8}>
          <Eye size={17} color={markdownPreview ? colors.primary : colors.mutedForeground} />
        </TouchableOpacity>
      ) : null}
      {kind === 'code' ? (
        <TouchableOpacity onPress={() => void save()} disabled={saving || !dirty} hitSlop={8}>
          {saving ? <ActivityIndicator size="small" color={colors.primary} />
            : <Save size={17} color={dirty ? colors.primary : colors.mutedForeground} />}
        </TouchableOpacity>
      ) : null}
      <TouchableOpacity onPress={() => void download()} hitSlop={8}><Download size={17} color={colors.mutedForeground} /></TouchableOpacity>
      <TouchableOpacity onPress={() => void copyPath()} hitSlop={8}><Copy size={17} color={colors.mutedForeground} /></TouchableOpacity>
      <TouchableOpacity onPress={() => (pinned ? unpinFile(filePath) : pinFile(filePath))} hitSlop={8}>
        <Pin size={17} color={pinned ? colors.primary : colors.mutedForeground} />
      </TouchableOpacity>
      {kind === 'code' ? (
        <TouchableOpacity onPress={() => setMode((m) => (m === 'edit' ? 'preview' : 'edit'))} hitSlop={8}>
          <Pencil size={17} color={mode === 'edit' ? colors.primary : colors.mutedForeground} />
        </TouchableOpacity>
      ) : null}
    </View>
  );

  const footer = kind === 'code' && content !== null ? (
    <View style={{ flexDirection: 'row', gap: 16, paddingHorizontal: 12, paddingVertical: 6, borderTopWidth: 1, borderTopColor: colors.border }}>
      <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{t('footer.lines', 'Lines:')} {splitLines(content).length}</Text>
      <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{t('footer.characters', 'Characters:')} {content.length}</Text>
    </View>
  ) : null;

  if (mode === 'edit' && editorUri) {
    return (
      <View style={{ flex: 1, backgroundColor: colors.background }}>
        {header}
        <WebView
          source={{ uri: editorUri }}
          style={{ flex: 1, backgroundColor: colors.background }}
          startInLoadingState
          renderLoading={() => (
            <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: colors.background }}>
              <ActivityIndicator color={colors.primary} size="large" />
            </View>
          )}
        />
        {toast ? <Toast toast={toast} /> : null}
      </View>
    );
  }

  const body = (() => {
    if (kind === 'binary') {
      return (
        <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', padding: 32, gap: 12 }}>
          <FileWarning size={40} color={colors.mutedForeground} />
          <Text style={{ color: colors.foreground, fontWeight: '600' }}>{t('binaryFile.title', 'Binary File')}</Text>
          <Text style={{ color: colors.mutedForeground, fontSize: 12, textAlign: 'center' }}>
            {t('binaryFile.message', 'This file cannot be displayed in the editor.')}
          </Text>
          <TouchableOpacity onPress={() => void download()} style={{ backgroundColor: colors.primary, borderRadius: 8, paddingHorizontal: 16, paddingVertical: 8 }}>
            <Text style={{ color: colors.primaryForeground, fontWeight: '600' }}>{t('actions.download', 'Download file')}</Text>
          </TouchableOpacity>
        </View>
      );
    }
    if (loading) {
      return (
        <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', gap: 10 }}>
          <ActivityIndicator color={colors.primary} size="large" />
          <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('loading', 'Loading…')}</Text>
        </View>
      );
    }
    if (error) {
      return (
        <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center', gap: 10 }}>
          <AlertCircle size={36} color={colors.destructive} />
          <Text style={{ color: colors.destructive }}>{error}</Text>
          <TouchableOpacity onPress={() => setMode('edit')}><Text style={{ color: colors.primary }}>{t('filePreview.openInNewTab', 'Open in editor')}</Text></TouchableOpacity>
        </View>
      );
    }
    if (kind === 'image' && mediaUri) {
      return (
        <ScrollView contentContainerStyle={{ flexGrow: 1, alignItems: 'center', justifyContent: 'center', padding: 16 }}>
          <TouchableOpacity onPress={() => setFullscreenImage(true)}>
            <Image
              source={{ uri: mediaUri, headers: { Authorization: `Bearer ${getStoredAuthToken() ?? ''}` } }}
              style={{ width: 280, height: 280 }}
              resizeMode="contain"
            />
          </TouchableOpacity>
        </ScrollView>
      );
    }
    if (kind === 'pdf' || kind === 'video' || kind === 'audio') {
      return mediaUri ? (
        <WebView source={{ uri: `${mediaUri}&token=${encodeURIComponent(getStoredAuthToken() ?? '')}` }} style={{ flex: 1, backgroundColor: colors.background }} />
      ) : null;
    }
    if (isMarkdown && markdownPreview) {
      const rules = createMarkdownRules({ colors, isDark, onOpenFile: undefined });
      return (
        <ScrollView contentContainerStyle={{ padding: 14 }}>
          <Markdown rules={rules as any} style={{ body: { color: colors.foreground } }}>{content ?? ''}</Markdown>
        </ScrollView>
      );
    }
    // Code preview: optional diff, then syntax-highlighted lines.
    const fontSize = Number(codeEditor.fontSize) || 13;
    const lineHeight = fontSize + 6;
    const wrap = codeEditor.wordWrap;
    const showNumbers = codeEditor.lineNumbers;
    const renderRows: Row[] = showDiff && diffLines ? diffLines.map((d) => ({ hunk: `${d.kind}\u0000${d.text}` })) : rows;
    return (
      <ScrollView ref={scrollRef} contentContainerStyle={{ paddingVertical: 8 }}>
        {renderRows.map((row, i) => {
          if ('hunk' in row) {
            const [k, text] = row.hunk.split('\u0000');
            const bg = k === 'add' ? 'rgba(32,48,59,0.6)' : k === 'del' ? 'rgba(55,34,44,0.6)' : k === 'hunk' ? 'rgba(92,156,245,0.12)' : 'transparent';
            const col = k === 'add' ? '#4fd6be' : k === 'del' ? '#c53b53' : k === 'hunk' ? '#5c9cf5' : colors.mutedForeground;
            return (
              <Text key={i} style={{ backgroundColor: bg, color: col, fontFamily: 'monospace', fontSize, lineHeight, paddingHorizontal: 10 }} numberOfLines={wrap ? undefined : 1}>
                {text}
              </Text>
            );
          }
          const styled = row.types.length ? syntaxStyleFor(row.types, isDark) : null;
          return (
            <View key={i} style={{ flexDirection: 'row' }}>
              {showNumbers ? (
                <Text style={{ width: 44, textAlign: 'right', paddingRight: 8, color: colors.mutedForeground, fontFamily: 'monospace', fontSize, lineHeight, opacity: 0.6 }}>
                  {row.line > 0 ? row.line : ''}
                </Text>
              ) : null}
              <Text
                style={{ flex: 1, color: styled?.color ?? colors.foreground, fontFamily: 'monospace', fontSize, lineHeight, fontStyle: styled?.italic ? 'italic' : 'normal' }}
                numberOfLines={wrap ? undefined : 1}
              >
                {row.text || ' '}
              </Text>
            </View>
          );
        })}
      </ScrollView>
    );
  })();

  return (
    <View style={{ flex: 1, backgroundColor: colors.background }}>
      {header}
      <View style={{ flex: 1 }}>{body}</View>
      {footer}
      <Modal visible={fullscreenImage} transparent animationType="fade" onRequestClose={() => setFullscreenImage(false)}>
        <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.92)', justifyContent: 'center' }}>
          <TouchableOpacity onPress={() => setFullscreenImage(false)} style={{ position: 'absolute', top: insets.top + 12, right: 16, zIndex: 10 }}>
            <X size={26} color="#fff" />
          </TouchableOpacity>
          {mediaUri ? (
            <Image source={{ uri: mediaUri, headers: { Authorization: `Bearer ${getStoredAuthToken() ?? ''}` } }} style={{ width: '100%', height: '80%' }} resizeMode="contain" />
          ) : null}
        </View>
      </Modal>
      {toast ? <Toast toast={toast} /> : null}
    </View>
  );
}
