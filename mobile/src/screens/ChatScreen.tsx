import React, { useCallback, useEffect, useRef, useState } from 'react';
import {
  ActivityIndicator,
  Alert,
  FlatList,
  Image,
  Modal,
  Platform,
  Share,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import { useNavigation, useRoute } from '@react-navigation/native';
import { useKeyboardState, useReanimatedKeyboardAnimation } from 'react-native-keyboard-controller';
import Reanimated, { useAnimatedStyle } from 'react-native-reanimated';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import Markdown from 'react-native-markdown-display';
import * as Haptics from 'expo-haptics';
import { Send, Wrench, ChevronDown, ChevronRight, ChevronUp, Zap, X, ShieldAlert, Check, Square, Paperclip, MoreVertical, FileDiff, Volume2, Pin, RotateCcw, HelpCircle, AudioLines, TerminalSquare, ArrowDown, Mic, Search } from 'lucide-react-native';
import * as Clipboard from 'expo-clipboard';
import * as ImagePicker from 'expo-image-picker';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { usePinnedFiles } from '../lib/pinned-files';
import { useVoiceInput } from '../lib/voice-input';
import { useTts, speakText, stopSpeaking, loadPreferredVoice } from '../lib/tts';
import { matchesModelSearch, permissionModesFor, buildMarkdownExport, buildHtmlExport, exportFilename } from '../lib/chat-extras';
import { ActionSheet, ActionSheetItem } from '../components/ActionSheet';
import { api, getStoredAuthToken } from '~shared/utils/api';
import { WebView } from 'react-native-webview';
import { useTheme } from '../theme';
import { useWebSocket } from '../contexts/WebSocketContext';
import { getServerUrlSync } from '../lib/server-config';
import { ChatMessage, ToolCall, messagesFromResponse, parseItem } from '../lib/chat-messages';
import { buildSearchIndex, stepMatch, nearestMatchIndex } from '../lib/chat-search';
import { HighlightText } from '../components/HighlightText';

interface QueuedItem {
  id: string;
  content?: string;
}

interface PermissionRequest {
  requestId: string;
  toolName: string;
  input?: unknown;
}

interface AQQuestion {
  question: string;
  header?: string;
  options: { label: string; description?: string }[];
  multiSelect?: boolean;
}

/** AskUserQuestion → option picker; answers ride back in updatedInput. */
function AskUserQuestionCard({
  request,
  colors,
  onDecision,
}: {
  request: PermissionRequest;
  colors: any;
  onDecision: (ids: string[], decision: { allow: boolean; message?: string; updatedInput?: unknown }) => void;
}) {
  const input = (request.input ?? {}) as { questions?: AQQuestion[] };
  const questions = Array.isArray(input.questions) ? input.questions : [];
  const [picked, setPicked] = useState<Record<number, string[]>>({});
  const [other, setOther] = useState<Record<number, string>>({});
  if (questions.length === 0) return null;

  const toggle = (qi: number, label: string) => {
    setPicked((prev) => {
      const cur = prev[qi] ?? [];
      const multi = questions[qi]?.multiSelect;
      const next = multi ? (cur.includes(label) ? cur.filter((l) => l !== label) : [...cur, label]) : [label];
      return { ...prev, [qi]: next };
    });
  };

  const buildAnswers = () => {
    const answers: Record<string, string> = {};
    questions.forEach((q, qi) => {
      const sel = [...(picked[qi] ?? [])];
      const o = (other[qi] ?? '').trim();
      if (o) sel.push(o);
      if (sel.length) answers[q.question] = sel.join(', ');
    });
    return answers;
  };

  const submit = (answers: Record<string, string>) =>
    onDecision([request.requestId], { allow: true, updatedInput: { ...input, answers } });

  return (
    <View style={{ backgroundColor: colors.card, borderColor: colors.primary, borderWidth: 1, borderRadius: 10, padding: 12, marginBottom: 6 }}>
      {questions.map((q, qi) => (
        <View key={qi} style={{ marginBottom: 10 }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6, marginBottom: 6 }}>
            <HelpCircle size={14} color={colors.primary} />
            {q.header ? <Text style={{ color: colors.primary, fontSize: 10, fontWeight: '700', textTransform: 'uppercase' }}>{q.header}</Text> : null}
          </View>
          <Text style={{ color: colors.foreground, fontSize: 14, fontWeight: '600', marginBottom: 6 }}>{q.question}</Text>
          {q.multiSelect ? <Text style={{ color: colors.mutedForeground, fontSize: 10, marginBottom: 4 }}>Select all that apply</Text> : null}
          {(q.options ?? []).map((opt) => {
            const on = (picked[qi] ?? []).includes(opt.label);
            return (
              <TouchableOpacity
                key={opt.label}
                onPress={() => toggle(qi, opt.label)}
                style={{
                  flexDirection: 'row',
                  alignItems: 'center',
                  borderWidth: 1,
                  borderColor: on ? colors.primary : colors.border,
                  backgroundColor: on ? colors.secondary : 'transparent',
                  borderRadius: 8,
                  paddingHorizontal: 10,
                  paddingVertical: 8,
                  marginBottom: 5,
                }}
              >
                <View style={{ flex: 1 }}>
                  <Text style={{ color: colors.foreground, fontSize: 13 }}>{opt.label}</Text>
                  {opt.description ? <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{opt.description}</Text> : null}
                </View>
                {on && <Check size={15} color={colors.primary} />}
              </TouchableOpacity>
            );
          })}
          <TextInput
            value={other[qi] ?? ''}
            onChangeText={(t) => setOther((p) => ({ ...p, [qi]: t }))}
            placeholder="Other…"
            placeholderTextColor={colors.mutedForeground}
            style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 8, paddingHorizontal: 10, paddingVertical: 6, color: colors.foreground, fontSize: 13 }}
          />
        </View>
      ))}
      <View style={{ flexDirection: 'row', justifyContent: 'flex-end', gap: 14 }}>
        <TouchableOpacity onPress={() => submit({})}>
          <Text style={{ color: colors.mutedForeground, fontSize: 13 }}>Skip</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={() => submit(buildAnswers())} style={{ backgroundColor: colors.primary, borderRadius: 8, paddingHorizontal: 14, paddingVertical: 7 }}>
          <Text style={{ color: colors.primaryForeground, fontWeight: '600', fontSize: 13 }}>Submit</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

/** Pending permission_request frames → Allow/Deny banner above the composer. */
function PermissionBanner({
  requests,
  colors,
  onDecision,
}: {
  requests: PermissionRequest[];
  colors: any;
  onDecision: (ids: string[], decision: { allow: boolean; message?: string; updatedInput?: unknown }) => void;
}) {
  if (requests.length === 0) return null;
  const allIds = requests.map((r) => r.requestId);
  return (
    <View style={{ borderTopWidth: 1, borderTopColor: colors.border, backgroundColor: colors.card, padding: 10 }}>
      {requests.length > 1 && (
        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginBottom: 8 }}>
          <Text style={{ color: colors.foreground, fontSize: 12, fontWeight: '600' }}>{requests.length} queued</Text>
          <View style={{ flexDirection: 'row', gap: 12 }}>
            <TouchableOpacity onPress={() => onDecision(allIds, { allow: false, message: 'User denied all tool use' })}>
              <Text style={{ color: colors.destructive, fontWeight: '600' }}>Reject all</Text>
            </TouchableOpacity>
            <TouchableOpacity onPress={() => onDecision(allIds, { allow: true })}>
              <Text style={{ color: '#16a34a', fontWeight: '600' }}>Allow all</Text>
            </TouchableOpacity>
          </View>
        </View>
      )}
      {requests.map((r) =>
        /ask[_ ]?user[_ ]?question/i.test(r.toolName) ? (
          <AskUserQuestionCard key={r.requestId} request={r} colors={colors} onDecision={onDecision} />
        ) : (
        <View
          key={r.requestId}
          style={{
            backgroundColor: colors.background,
            borderColor: colors.border,
            borderWidth: 1,
            borderRadius: 10,
            padding: 10,
            marginBottom: 6,
          }}
        >
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6, marginBottom: 4 }}>
            <ShieldAlert size={15} color="#f59e0b" />
            <Text style={{ color: colors.foreground, fontWeight: '600', fontSize: 13 }}>Permission required</Text>
            <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{r.toolName}</Text>
          </View>
          {r.input != null && (
            <Text style={{ color: colors.mutedForeground, fontSize: 11, fontFamily: 'monospace' }} numberOfLines={3}>
              {typeof r.input === 'string' ? r.input : JSON.stringify(r.input)}
            </Text>
          )}
          <View style={{ flexDirection: 'row', gap: 10, marginTop: 8 }}>
            <TouchableOpacity
              onPress={() => onDecision([r.requestId], { allow: false, message: 'User denied tool use' })}
              style={{ flex: 1, borderColor: colors.destructive, borderWidth: 1, borderRadius: 8, paddingVertical: 8, alignItems: 'center' }}
            >
              <View style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
                <X size={14} color={colors.destructive} />
                <Text style={{ color: colors.destructive, fontWeight: '600', fontSize: 13 }}>Deny</Text>
              </View>
            </TouchableOpacity>
            <TouchableOpacity
              onPress={() => onDecision([r.requestId], { allow: true })}
              style={{ flex: 1, backgroundColor: '#16a34a', borderRadius: 8, paddingVertical: 8, alignItems: 'center' }}
            >
              <View style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
                <Check size={14} color="#fff" />
                <Text style={{ color: '#fff', fontWeight: '600', fontSize: 13 }}>Allow</Text>
              </View>
            </TouchableOpacity>
          </View>
        </View>
        ),
      )}
    </View>
  );
}

/** ```mermaid fence → /island/mermaid WebView; tap opens it fullscreen. */
function MermaidBlock({ code, colors }: { code: string; colors: any }) {
  const [expanded, setExpanded] = useState(false);
  const uri = (() => {
    const base = getServerUrlSync();
    const token = getStoredAuthToken();
    if (!base || !token) return null;
    const b64 = btoa(unescape(encodeURIComponent(code))).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
    return `${base}/island/mermaid?code=${b64}&token=${encodeURIComponent(token)}`;
  })();

  if (!uri) return null;
  const diagram = (
    <WebView
      source={{ uri }}
      style={{ flex: 1, backgroundColor: 'transparent' }}
      scrollEnabled={expanded}
      setSupportMultipleWindows={false}
    />
  );
  return (
    <>
      <TouchableOpacity activeOpacity={0.85} onPress={() => setExpanded(true)}>
        <View style={{ height: 240, borderRadius: 8, borderWidth: 1, borderColor: colors.border, overflow: 'hidden', marginVertical: 6 }}>
          {diagram}
        </View>
      </TouchableOpacity>
      <Modal visible={expanded} animationType="fade" onRequestClose={() => setExpanded(false)}>
        <View style={{ flex: 1, backgroundColor: colors.background }}>
          {expanded ? diagram : null}
          <TouchableOpacity
            onPress={() => setExpanded(false)}
            style={{ position: 'absolute', top: 48, right: 16, padding: 10, backgroundColor: colors.card, borderRadius: 20 }}
          >
            <X size={20} color={colors.foreground} />
          </TouchableOpacity>
        </View>
      </Modal>
    </>
  );
}

/** $...$ / $$...$$ segments → /island/katex WebView (same island the web app
 *  renders math through). WebViews are block-level in RN, so inline math
 *  gets its own slim row rather than wrapping inside the text flow. */
function KatexView({ code, display, colors }: { code: string; display: boolean; colors: any }) {
  const base = getServerUrlSync();
  const token = getStoredAuthToken();
  if (!base || !token) return null;
  const b64 = btoa(unescape(encodeURIComponent(code))).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
  return (
    <View style={{ height: display ? 140 : 44, marginVertical: 2 }}>
      <WebView
        source={{ uri: `${base}/island/katex?code=${b64}&display=${display ? 1 : 0}&token=${encodeURIComponent(token)}` }}
        style={{ flex: 1, backgroundColor: 'transparent' }}
        scrollEnabled={false}
        setSupportMultipleWindows={false}
      />
    </View>
  );
}

/** Split text into plain + math segments ($$..$$ block, $..$ inline). */
function renderMathText(text: string, keyPrefix: string, colors: any, textStyle: any) {
  const parts: any[] = [];
  const re = /\$\$([\s\S]+?)\$\$|\$([^$\n]+?)\$/g;
  let last = 0;
  let m: RegExpExecArray | null;
  let i = 0;
  while ((m = re.exec(text))) {
    if (m.index > last) parts.push(<Text key={`${keyPrefix}-t${i}`} style={textStyle}>{text.slice(last, m.index)}</Text>);
    parts.push(<KatexView key={`${keyPrefix}-k${i}`} code={(m[1] ?? m[2]).trim()} display={m[1] !== undefined} colors={colors} />);
    last = m.index + m[0].length;
    i++;
  }
  if (last < text.length) parts.push(<Text key={`${keyPrefix}-t${i}`} style={textStyle}>{text.slice(last)}</Text>);
  return parts;
}

/** markdown rules: mermaid fences go to the island, everything else default. */
const markdownRules = (colors: any) => ({
  fence: (node: any) => {
    const lang = (node.sourceInfo ?? '').trim().split(/\s+/)[0];
    if (lang === 'mermaid') {
      return <MermaidBlock key={node.key} code={node.content} colors={colors} />;
    }
    return (
      <View
        key={node.key}
        style={{ backgroundColor: colors.card, borderRadius: 8, padding: 10, borderWidth: 1, borderColor: colors.border, marginVertical: 4 }}
      >
        <Text style={{ color: colors.foreground, fontFamily: Platform.OS === 'ios' ? 'Menlo' : 'monospace', fontSize: 13 }}>
          {node.content}
        </Text>
      </View>
    );
  },
  text: (node: any, _children: any, _parent: any, styles: any, inheritedStyles: any = {}) => {
    const content = node.content ?? '';
    if (!content.includes('$')) {
      // replicate the default text rule — returning undefined here drops the node entirely
      return <Text key={node.key} style={[inheritedStyles, styles?.text]}>{content}</Text>;
    }
    return <View key={node.key}>{renderMathText(content, node.key, colors, [inheritedStyles, styles?.text])}</View>;
  },
});

function ToolRow({ tool, colors, query = '' }: { tool: ToolCall; colors: any; query?: string }) {
  const [open, setOpen] = useState(false);
  return (
    <TouchableOpacity
      onPress={() => tool.detail && setOpen(!open)}
      style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: colors.card, borderColor: colors.border, borderWidth: 1, borderRadius: 8, padding: 8, marginBottom: 4 }}
    >
      <Wrench size={13} color={colors.mutedForeground} />
      <HighlightText text={tool.name ?? ''} query={query} style={{ color: colors.mutedForeground, fontSize: 12, marginLeft: 6, flex: 1 }} numberOfLines={1} />
      {tool.detail ? (
        open ? <ChevronDown size={13} color={colors.mutedForeground} /> : <ChevronRight size={13} color={colors.mutedForeground} />
      ) : null}
      {open && !!tool.detail && (
        <Text style={{ color: colors.mutedForeground, fontSize: 11, fontFamily: 'monospace', marginTop: 6 }}>{tool.detail}</Text>
      )}
    </TouchableOpacity>
  );
}

function QueueBar({ sessionId, colors, reloadKey }: { sessionId?: string; colors: any; reloadKey: number }) {
  const [items, setItems] = useState<QueuedItem[]>([]);
  const { subscribe, isConnected } = useWebSocket();

  const load = useCallback(async () => {
    if (!sessionId) return;
    try {
      const res = await api.queue.list(sessionId);
      if (res.ok) {
        const data = await res.json();
        const list = Array.isArray(data) ? data : data?.data?.messages ?? data?.messages ?? data?.items ?? [];
        setItems(list);
      }
    } catch {
      /* queue endpoint optional */
    }
  }, [sessionId]);

  useEffect(() => {
    load();
  }, [load, reloadKey]);

  // The server broadcasts queue snapshots on enqueue/send-now/remove —
  // consume them directly instead of refetching.
  useEffect(
    () =>
      subscribe((event) => {
        if (event?.type === 'queued-messages-updated' && event.sessionId === sessionId) {
          setItems(Array.isArray(event.messages) ? event.messages : []);
        }
      }),
    [subscribe, sessionId],
  );

  if (items.length === 0) return null;

  return (
    <View style={{ borderTopWidth: 1, borderTopColor: colors.border, backgroundColor: colors.card, paddingHorizontal: 10, paddingVertical: 6 }}>
      {!isConnected && (
        <Text style={{ color: '#b45309', fontSize: 11, marginBottom: 4 }}>
          {items.length === 1
            ? '1 message queued offline — will send automatically when reconnected'
            : `${items.length} messages queued offline — will send automatically when reconnected`}
        </Text>
      )}
      {items.map((q, i) => (
        <View key={q.id ?? i} style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 4 }}>
          <Text style={{ flex: 1, color: colors.mutedForeground, fontSize: 12 }} numberOfLines={1}>
            {q.content ?? 'queued message'}
          </Text>
          <TouchableOpacity
            onPress={() => api.queue.sendNow(q.id).then(load).catch(() => {})}
            style={{ padding: 6 }}
            hitSlop={6}
          >
            <Zap size={14} color={colors.primary} />
          </TouchableOpacity>
          <TouchableOpacity onPress={() => api.queue.remove(q.id).then(load).catch(() => {})} style={{ padding: 6 }} hitSlop={6}>
            <X size={14} color={colors.mutedForeground} />
          </TouchableOpacity>
        </View>
      ))}
    </View>
  );
}

export default function ChatScreen() {
  const { colors } = useTheme();
  const insets = useSafeAreaInsets();
  const kbVisible = useKeyboardState((s) => s.isVisible);
  const { height: kbHeightSV } = useReanimatedKeyboardAnimation();
  const kbPad = useAnimatedStyle(() => ({ paddingBottom: -kbHeightSV.value }));
  const route = useRoute<any>();
  const navigation = useNavigation<any>();
  // newSession → draft mode: first send POSTs /api/providers/sessions with
  // the message, then we swap params to the real sessionId.
  const { sessionId, newSession, projectPath: paramPath, provider: paramProvider } = route.params as {
    sessionId?: string;
    newSession?: boolean;
    projectPath?: string;
    provider?: string;
  };
  const { projectId: paramProjectId } = route.params as { projectId?: string };
  const [resolved, setResolved] = useState<{ provider?: string; projectPath?: string; projectId?: string }>({});
  const provider = paramProvider ?? resolved.provider;
  const projectPath = paramPath ?? resolved.projectPath;
  const projectId = paramProjectId ?? resolved.projectId;
  const { subscribe, sendMessage, isConnected } = useWebSocket();
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [loading, setLoading] = useState(true);
  const [draft, setDraft] = useState('');
  const [atBottom, setAtBottom] = useState(true);

  // Composer draft persistence — the web keeps the typed text per session;
  // AsyncStorage does the same across remounts/app restarts.
  const draftKey = `chat-draft-${sessionId ?? `new-${projectId ?? paramPath ?? 'x'}`}`;
  const draftLoadedFor = useRef<string | null>(null);
  useEffect(() => {
    if (draftLoadedFor.current === draftKey) return;
    draftLoadedFor.current = draftKey;
    AsyncStorage.getItem(draftKey)
      .then((v) => { if (v) setDraft(v); })
      .catch(() => {});
  }, [draftKey]);
  useEffect(() => {
    const t = setTimeout(() => {
      void AsyncStorage.setItem(draftKey, draft).catch(() => {});
    }, 400);
    return () => clearTimeout(t);
  }, [draft, draftKey]);
  const [sheet, setSheet] = useState<{ title?: string; items: ActionSheetItem[] } | null>(null);
  const [sending, setSending] = useState(false);
  const [running, setRunning] = useState(false);
  const [permissionMode, setPermissionMode] = useState<string>('default');
  const [permissionModes, setPermissionModes] = useState<string[]>(permissionModesFor(null));
  const [model, setModel] = useState<string | null>(null);
  const [models, setModels] = useState<{ value: string; label: string; description?: string; effort?: { values: { value: string; label?: string }[] } }[]>([]);
  const [modelSearch, setModelSearch] = useState('');
  const [effort, setEffort] = useState<string | null>(null);
  const [modelModal, setModelModal] = useState(false);
  const [permModal, setPermModal] = useState(false);
  const [autoContinue, setAutoContinue] = useState(false);
  const [autoRead, setAutoRead] = useState(false);
  const [slashCommands, setSlashCommands] = useState<{ name: string; description?: string; path?: string }[]>([]);
  const [pendingAttachments, setPendingAttachments] = useState<{ uri: string; name: string; mimeType: string }[]>([]);
  const [mentionFiles, setMentionFiles] = useState<string[]>([]);
  const [tokenUsage, setTokenUsage] = useState<{ used: number; total: number } | null>(null);
  const [changedFiles, setChangedFiles] = useState<string[] | null>(null);
  const [queueKey, setQueueKey] = useState(0);
  const listRef = useRef<FlatList<ChatMessage>>(null);
  // Live WS items can carry duplicate or missing ids (tool_use shares call ids,
  // text events have none) — a counter keeps FlatList keys unique.
  const liveSeq = useRef(0);
  const [pendingPermissions, setPendingPermissions] = useState<PermissionRequest[]>([]);
  const [hasMore, setHasMore] = useState(false);
  const [loadingOlder, setLoadingOlder] = useState(false);
  const [searchOpen, setSearchOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [activeMatchIndex, setActiveMatchIndex] = useState(0);
  const searchInputRef = useRef<TextInput>(null);
  // Raw history items fetched so far — pagination offset counts raw rows,
  // not rendered messages (tool_results fold into tool_use rows).
  const rawCountRef = useRef(0);

  const trimmedSearch = searchQuery.trim();
  const searchIndex = buildSearchIndex(messages, trimmedSearch);
  const isSearchActive = trimmedSearch.length > 0;
  const activeSearchMessageIndex = isSearchActive && searchIndex.count > 0
    ? searchIndex.matchedIndices[Math.min(activeMatchIndex, searchIndex.count - 1)]
    : null;

  useEffect(() => {
    if (searchIndex.count > 0 && activeMatchIndex >= searchIndex.count) {
      setActiveMatchIndex(Math.max(0, searchIndex.count - 1));
    }
  }, [searchIndex.count, activeMatchIndex]);

  const openSearch = () => {
    setSearchOpen(true);
    setTimeout(() => searchInputRef.current?.focus(), 50);
  };

  const closeSearch = () => {
    setSearchOpen(false);
    setSearchQuery('');
    setActiveMatchIndex(0);
  };

  const goToMatch = (delta: number) => {
    if (searchIndex.count === 0) return;
    const next = stepMatch(activeMatchIndex, searchIndex.count, delta);
    setActiveMatchIndex(next);
    const target = nearestMatchIndex(searchIndex.matchedIndices, next);
    if (target !== null) {
      try {
        listRef.current?.scrollToIndex({ index: target, animated: true, viewPosition: 0.4 });
      } catch {
        // list has no getItemLayout; scrollToIndex can throw on unrendered rows.
      }
    }
  };

  // Auto-read replies aloud (web composer AudioLines toggle equivalent).
  const messagesRef = useRef<ChatMessage[]>([]);
  messagesRef.current = messages;
  const wasRunning = useRef(false);
  useEffect(() => {
    if (wasRunning.current && !running && autoRead) {
      const last = [...messagesRef.current].reverse().find((m) => m.role === 'assistant' && m.text.trim() && !m.isError);
      if (last) speakText(last.text.trim());
    }
    wasRunning.current = running;
  }, [running, autoRead]);

  // Persisted composer prefs (web uses localStorage chat-auto-continue-tasks).
  useEffect(() => {
    AsyncStorage.getItem('chat-auto-continue-tasks').then((v) => {
      if (v === 'true') setAutoContinue(true);
    });
    AsyncStorage.getItem('chat-auto-read').then((v) => {
      if (v === 'true') setAutoRead(true);
    });
  }, []);
  const toggleAutoContinue = () => {
    setAutoContinue((v) => {
      AsyncStorage.setItem('chat-auto-continue-tasks', String(!v)).catch(() => {});
      return !v;
    });
  };
  const toggleAutoRead = () => {
    setAutoRead((v) => {
      AsyncStorage.setItem('chat-auto-read', String(!v)).catch(() => {});
      if (v) stopSpeaking();
      return !v;
    });
  };

  // Preferred read-aloud voice (settings picker writes it; hydrate on mount).
  useEffect(() => {
    void loadPreferredVoice();
  }, []);

  // Permission modes come from the backend capability matrix, not a hardcode.
  useEffect(() => {
    if (!provider) return;
    let alive = true;
    api
      .get('/providers/capabilities')
      .then((r) => (r.ok ? r.json() : null))
      .then((d) => {
        if (!alive || !d) return;
        const list = d?.data?.providers ?? d?.providers ?? [];
        const entry = Array.isArray(list) ? list.find((p: any) => p.provider === provider) : undefined;
        if (Array.isArray(entry?.permissionModes)) setPermissionModes(entry.permissionModes);
      })
      .catch(() => {});
    return () => {
      alive = false;
    };
  }, [provider]);

  const parseRaw = useCallback((raw: any[]): ChatMessage[] => {
    const msgs: ChatMessage[] = [];
    for (const m of raw) {
      const p = parseItem(m);
      // Fold tool_result payloads into their tool_use row instead of
      // rendering a second row per call.
      if (m.kind === 'tool_result' && p.tools[0]) {
        const toolId = String(m.toolId ?? '');
        const target = msgs.findLast((x) => x.tools.some((t) => t.id === toolId));
        const tool = target?.tools.find((t) => t.id === toolId);
        if (tool) {
          tool.status = m.isError ? 'error' : 'done';
          tool.detail = [tool.detail, p.tools[0].detail].filter(Boolean).join('\n→ ');
          continue;
        }
      }
      if (p.skip || (p.text.trim().length === 0 && p.tools.length === 0 && !p.images?.length)) continue;
      msgs.push({
        id: String(m.id ?? m.uuid ?? `hist-${msgs.length}`),
        role: p.role,
        text: p.text,
        tools: p.tools,
        images: p.images,
        files: p.files,
        timestamp: m.timestamp ?? m.createdAt,
      });
    }
    return msgs;
  }, []);

  const load = useCallback(async () => {
    if (!sessionId) {
      setLoading(false);
      return;
    }
    try {
      const res = await api.unifiedSessionMessages(sessionId, 'claude', { limit: 100 } as never);
      if (res.ok) {
        const data = await res.json();
        const raw = messagesFromResponse(data);
        rawCountRef.current = raw.length;
        setMessages((prev) => {
          const parsed = parseRaw(raw);
          // Keep optimistic/error rows the server hasn't persisted yet (e.g. a
          // run that failed before storing the user message) — drop them once
          // an identical row exists in history.
          const pending = prev.filter(
            (m) =>
              (m.id.startsWith('local-') || m.isError) &&
              !parsed.some((p) => p.role === m.role && p.text === m.text),
          );
          return pending.length ? [...parsed, ...pending] : parsed;
        });
        setHasMore(Boolean(data?.data?.hasMore ?? data?.hasMore));
      }
    } catch (err) {
      console.error('messages load failed:', err);
    } finally {
      setLoading(false);
    }
  }, [sessionId, parseRaw]);

  const loadOlder = useCallback(async () => {
    if (loadingOlder || !hasMore) return;
    setLoadingOlder(true);
    try {
      // offset counts raw items back from the newest end.
      const res = await api.unifiedSessionMessages(sessionId!, 'claude', { limit: 100, offset: rawCountRef.current } as never);
      if (res.ok) {
        const data = await res.json();
        const raw = messagesFromResponse(data);
        rawCountRef.current += raw.length;
        setMessages((prev) => [...parseRaw(raw), ...prev]);
        setHasMore(Boolean(data?.data?.hasMore ?? data?.hasMore));
      }
    } finally {
      setLoadingOlder(false);
    }
  }, [loadingOlder, hasMore, sessionId, parseRaw]);

  useEffect(() => {
    load();
  }, [load]);

  // Deltas only flow after a per-session chat.subscribe — send it whenever the
  // socket (re)connects, mirroring useChatSessionState on web.
  useEffect(() => {
    if (!isConnected || !sessionId) return;
    sendMessage({ type: 'chat.subscribe', sessions: [{ sessionId, lastSeq: 0 }] });
  }, [isConnected, sendMessage, sessionId]);

  // Mark viewed once the session is open. Also resolves provider/projectPath
  // when they weren't passed as nav params (e.g. deep link).
  useEffect(() => {
    if (!sessionId) return;
    api.markSessionViewed(sessionId).catch(() => {});
    if (paramProvider && paramPath) return;
    api
      .sessionDetails(sessionId)
      .then((r) => (r.ok ? r.json() : null))
      .then((d) => {
        if (d?.data) {
          setResolved({
            provider: d.data.provider,
            projectPath: d.data.project?.path,
            projectId: d.data.project?.projectId,
          });
        }
      })
      .catch(() => {});
  }, [sessionId, paramProvider, paramPath]);

  // Composer state: model catalog + the session's currently-active model.
  useEffect(() => {
    if (!sessionId || !provider) return;
    let alive = true;
    (async () => {
      try {
        const [catRes, activeRes] = await Promise.all([
          api.get(`/providers/${provider}/models`),
          api.get(`/providers/${provider}/sessions/${sessionId}/active-model`),
        ]);
        if (!alive) return;
        if (catRes.ok) {
          const body = await catRes.json();
          const opts = body?.data?.models?.OPTIONS ?? body?.data?.models?.options ?? [];
          setModels(
            opts.map((m: any) => ({
              value: String(m.value),
              label: String(m.label ?? m.value),
              description: m.description ? String(m.description) : undefined,
              effort: Array.isArray(m?.effort?.values) ? { values: m.effort.values.map((v: any) => ({ value: String(v.value), label: v.label ? String(v.label) : undefined })) } : undefined,
            })),
          );
        }
        if (activeRes.ok) {
          const body = await activeRes.json();
          if (body?.data?.model) setModel(String(body.data.model));
        }
      } catch {
        /* model endpoints optional */
      }
    })();
    return () => {
      alive = false;
    };
  }, [sessionId, provider]);

  // Slash commands for the current project (built-in + custom; provider skills
  // are merged on web too but kept simple here).
  useEffect(() => {
    if (!projectPath) return;
    api
      .post('/commands/list', { projectPath })
      .then((r) => (r.ok ? r.json() : null))
      .then((d) => {
        if (!d) return;
        setSlashCommands([...(d.builtIn ?? d.data?.builtIn ?? []), ...(d.custom ?? d.data?.custom ?? [])]);
      })
      .catch(() => {});
  }, [projectPath]);

  // @-mention file list — flattened once per project, filtered on the draft.
  useEffect(() => {
    if (!projectId) return;
    api
      .getMentionableFiles(projectId)
      .then((r) => (r.ok ? r.json() : null))
      .then((tree) => {
        if (!Array.isArray(tree)) return;
        const paths: string[] = [];
        const walk = (nodes: any[], prefix: string) => {
          for (const n of nodes) {
            const p = prefix ? `${prefix}/${n.name}` : n.name;
            if (n.type === 'directory' && Array.isArray(n.children)) walk(n.children, p);
            else if (n.type !== 'directory') paths.push(n.path ?? p);
          }
        };
        walk(tree, '');
        setMentionFiles(paths);
      })
      .catch(() => {});
  }, [projectId]);

  // Token usage for this session — refreshed when a turn completes.
  const loadTokenUsage = useCallback(() => {
    if (!sessionId) return;
    api
      .get(`/providers/sessions/${sessionId}/token-usage`)
      .then((r) => (r.ok ? r.json() : null))
      .then((d) => {
        const u = d?.data;
        if (u && typeof u.used === 'number') setTokenUsage({ used: u.used, total: u.total });
      })
      .catch(() => {});
  }, [sessionId]);

  useEffect(() => {
    loadTokenUsage();
  }, [loadTokenUsage, messages.length === 0]);

  const exportChat = async (format: 'markdown' | 'html' | 'text' = 'markdown') => {
    if (messages.length === 0) return;
    const title = route.params?.title as string | undefined;
    if (format === 'markdown') {
      await Share.share({ message: buildMarkdownExport(messages, title), title: exportFilename(title, 'md') });
    } else if (format === 'html') {
      await Share.share({ message: buildHtmlExport(messages, title), title: exportFilename(title, 'html') });
    } else {
      const plain = messages.map((m) => `${m.role}: ${m.text}`).join('\n\n');
      await Share.share({ message: plain, title: exportFilename(title, 'txt') });
    }
  };

  const openChangedFiles = () => {
    if (!sessionId) return;
    api
      .sessionChangedFiles(sessionId)
      .then((r) => (r.ok ? r.json() : null))
      .then((d) => {
        const files = (d?.data?.files ?? []).map((f: any) => (typeof f === 'string' ? f : f.path ?? f.file ?? String(f)));
        setChangedFiles(files);
      })
      .catch(() => {});
  };

  // Header ⋯ menu: export transcript + changed files.
  useEffect(() => {
    if (!sessionId) return;
    navigation.setOptions({
      headerRight: () => (
        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
          <TouchableOpacity
            onPress={() => (searchOpen ? closeSearch() : openSearch())}
            hitSlop={8}
            style={{ padding: 6 }}
          >
            <Search size={18} color={searchOpen ? colors.primary : colors.mutedForeground} />
          </TouchableOpacity>
          <TouchableOpacity
            onPress={() =>
              setSheet({
                title: 'Session',
                items: [
                  { label: 'Export as Markdown', onPress: () => void exportChat('markdown') },
                  { label: 'Export as HTML', onPress: () => void exportChat('html') },
                  { label: 'Export as text', onPress: () => void exportChat('text') },
                  { label: 'Changed files', onPress: openChangedFiles },
                  { label: 'Open terminal', onPress: () => navigation.navigate('Terminal' as never, { sessionId } as never) },
                ],
              })
            }
            hitSlop={8}
            style={{ padding: 6 }}
          >
            <MoreVertical size={18} color={colors.mutedForeground} />
          </TouchableOpacity>
        </View>
      ),
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [navigation, sessionId, colors, messages, searchOpen, searchQuery]);

  const pickImage = async () => {
    const res = await ImagePicker.launchImageLibraryAsync({ mediaTypes: ['images'], quality: 0.8 });
    if (res.canceled) return;
    setPendingAttachments((prev) => [
      ...prev,
      ...res.assets.map((a) => ({
        uri: a.uri,
        name: a.fileName ?? `image-${Date.now()}.jpg`,
        mimeType: a.mimeType ?? 'image/jpeg',
      })),
    ]);
  };

  const takePhoto = async () => {
    const permission = await ImagePicker.requestCameraPermissionsAsync();
    if (!permission.granted) {
      Alert.alert('Camera unavailable', 'Camera permission was denied.');
      return;
    }
    const res = await ImagePicker.launchCameraAsync({ mediaTypes: ['images'], quality: 0.8 });
    if (res.canceled) return;
    setPendingAttachments((prev) => [
      ...prev,
      ...res.assets.map((a) => ({
        uri: a.uri,
        name: a.fileName ?? `photo-${Date.now()}.jpg`,
        mimeType: a.mimeType ?? 'image/jpeg',
      })),
    ]);
  };

  const openAttachMenu = () => {
    setSheet({
      title: 'Attach',
      items: [
        { label: 'Attach files', onPress: () => void pickImage() },
        { label: 'Take photo', onPress: () => void takePhoto() },
      ],
    });
  };

  const pickModel = async (value: string) => {
    setModel(value);
    setModelModal(false);
    if (sessionId && provider) {
      try {
        await api.put(`/providers/${provider}/sessions/${sessionId}/active-model`, { model: value });
      } catch (err) {
        console.error('set model failed:', err);
      }
    }
  };

  useEffect(
    () =>
      subscribe((event) => {
        if (!event || !sessionId) return;
        // `queued-messages-updated` is handled by QueueBar; reconnect marker
        // uses `kind` (same field as server frames).
        if (event.kind === 'websocket_reconnected') {
          load();
          setQueueKey((k) => k + 1);
          return;
        }
        // The subscribe ack carries the session's live pending approvals —
        // without this a reload/app restart loses Allow/Deny banners that the
        // server is still holding open.
        if (event.kind === 'chat_subscribed' && Array.isArray(event.pendingPermissions)) {
          setPendingPermissions(event.pendingPermissions as PermissionRequest[]);
          return;
        }
        if (event.sessionId !== sessionId) return;

        const finalizeStreams = () => {
          setRunning(false);
          setMessages((prev) => prev.map((m) => (m.isStreaming ? { ...m, isStreaming: false } : m)));
        };

        switch (event.kind) {
          case 'stream_delta':
          case 'thought_delta': {
            const delta = typeof event.content === 'string' ? event.content : '';
            if (!delta) return;
            setRunning(true);
            const role = event.kind === 'thought_delta' ? 'thinking' : 'assistant';
            setMessages((prev) => {
              const last = prev[prev.length - 1];
              if (last?.isStreaming && last.role === role) {
                const copy = [...prev];
                copy[copy.length - 1] = { ...last, text: last.text + delta };
                return copy;
              }
              return [...prev, { id: `live-${role}-${liveSeq.current++}`, role, text: delta, tools: [], isStreaming: true }];
            });
            return;
          }
          case 'stream_replace': {
            const text = typeof event.content === 'string' ? event.content : '';
            setMessages((prev) => {
              const idx = prev.findLastIndex((m) => m.isStreaming && m.role === 'assistant');
              if (idx < 0) return prev;
              const copy = [...prev];
              copy[idx] = { ...copy[idx], text };
              return copy;
            });
            return;
          }
          case 'stream_end':
            finalizeStreams();
            return;
          case 'permission_request': {
            const requestId = event.requestId;
            if (typeof requestId !== 'string' || !requestId) return;
            void Haptics.notificationAsync(Haptics.NotificationFeedbackType.Warning);
            setPendingPermissions((prev) =>
              prev.some((r) => r.requestId === requestId)
                ? prev
                : [...prev, { requestId, toolName: String(event.toolName ?? 'UnknownTool'), input: event.input }],
            );
            return;
          }
          case 'permission_cancelled': {
            const requestId = event.requestId;
            if (typeof requestId === 'string') {
              setPendingPermissions((prev) => prev.filter((r) => r.requestId !== requestId));
            }
            return;
          }
          case 'error': {
            const text = typeof event.content === 'string' && event.content ? event.content : 'The run failed';
            setRunning(false);
            setMessages((prev) => [
              ...prev,
              { id: `live-error-${liveSeq.current++}`, role: 'assistant', text, tools: [], isError: true, timestamp: event.timestamp },
            ]);
            return;
          }
          case 'complete':
          case 'session_upserted':
            finalizeStreams();
            load();
            loadTokenUsage();
            setQueueKey((k) => k + 1);
            return;
          case 'tool_use':
          case 'tool_result':
          case 'text': {
            // Live non-stream items: merge tool_result into its tool_use row,
            // otherwise append — matches the load() normalization.
            setRunning(true);
            const p = parseItem(event);
            if (p.skip) return;
            if (event.kind === 'tool_result' && p.tools[0]) {
              const toolId = String(event.toolId ?? '');
              setMessages((prev) => {
                const idx = prev.findLastIndex((x) => x.tools.some((t) => t.id === toolId));
                if (idx < 0) return prev;
                const copy = [...prev];
                const tools = copy[idx].tools.map((t) =>
                  t.id === toolId
                    ? { ...t, status: event.isError ? 'error' : 'done', detail: [t.detail, p.tools[0].detail].filter(Boolean).join('\n→ ') }
                    : t,
                );
                copy[idx] = { ...copy[idx], tools };
                return copy;
              });
              return;
            }
            setMessages((prev) => [
              ...prev,
              {
                id: `live-${event.kind}-${liveSeq.current++}`,
                role: p.role,
                text: p.text,
                tools: p.tools,
                images: p.images,
                files: p.files,
                timestamp: event.timestamp,
              },
            ]);
            return;
          }
          default:
            return;
        }
      }),
    [subscribe, sessionId, load, loadTokenUsage],
  );

  const handlePermissionDecision = useCallback(
    (ids: string[], decision: { allow: boolean; message?: string; updatedInput?: unknown }) => {
      for (const requestId of ids) {
        sendMessage({
          type: 'chat.permission-response',
          requestId,
          allow: decision.allow,
          message: decision.message,
          ...(decision.updatedInput !== undefined ? { updatedInput: decision.updatedInput } : {}),
        });
      }
      setPendingPermissions((prev) => prev.filter((r) => !ids.includes(r.requestId)));
    },
    [sendMessage],
  );

  const { pinnedFiles, unpinFile } = usePinnedFiles(projectId);
  const voiceInput = useVoiceInput(
    useCallback(
      (text: string) => setDraft((d) => (d ? `${d.replace(/\s+$/, '')} ${text}` : text)),
      [],
    ),
  );

  // Git checkpoint: snapshot the working tree before each AI turn so one tap
  // restores it if the run goes sideways — same as the web CheckpointButton.
  const checkpointRef = useRef<{ ref: string } | null>(null);
  const [undoState, setUndoState] = useState<'idle' | 'restoring' | 'restored'>('idle');
  const createCheckpoint = useCallback(() => {
    if (!projectId) return;
    api
      .post('/git/checkpoint', { project: projectId, label: 'mobile chat turn' })
      .then((r) => (r.ok ? r.json() : null))
      .then((d) => {
        if (d?.checkpoint?.ref) {
          checkpointRef.current = d.checkpoint;
          setUndoState('idle');
        }
      })
      .catch(() => {
        // A failed snapshot must not block the turn.
      });
  }, [projectId]);

  const undoAiRun = useCallback(async () => {
    const checkpoint = checkpointRef.current;
    if (!projectId || !checkpoint || undoState === 'restoring') return;
    setUndoState('restoring');
    try {
      const res = await api.post('/git/checkpoint/restore', { project: projectId, ref: checkpoint.ref });
      if (!res.ok) throw new Error(`restore failed (${res.status})`);
      setUndoState('restored');
    } catch (err) {
      setUndoState('idle');
      Alert.alert('Undo failed', err instanceof Error ? err.message : String(err));
    }
  }, [projectId, undoState]);

  const buildSendOptions = () => ({
    permissionMode,
    ...(model ? { model } : {}),
    ...(effort ? { effort } : {}),
    autoContinueTasks: autoContinue,
  });

  const send = async () => {
    const content = draft.trim();
    if (!content || sending) return;
    void Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    setSending(true);
    setDraft('');
    try {
      // Slash command dispatch — matches /api/commands/execute on web.
      const slash = content.match(/^\/(\S+)\s*(.*)$/);
      const cmd = slash && slashCommands.find((c) => c.name === `/${slash[1]}` || c.name === slash[1]);
      if (cmd && sessionId) {
        await api.post('/commands/execute', {
          commandName: cmd.name,
          commandPath: cmd.path,
          args: slash![2] ? slash![2].trim().split(/\s+/) : [],
          context: { projectPath, sessionId, provider, model },
        });
        setQueueKey((k) => k + 1);
        return;
      }
      // Pinned files merge into the prompt text — the backend relays content
      // verbatim, same as the web composer.
      const pinned = pinnedFiles.filter((p) => p.trim());
      const messageContent =
        pinned.length > 0
          ? `Pinned files:\n${pinned.map((p) => `- ${p}`).join('\n')}\n\n${content}`
          : content;
      // Snapshot the working tree before the turn so it can be undone.
      createCheckpoint();
      if (newSession && !sessionId) {
        // Draft mode: create the session row (initialMessage only names it),
        // then enqueue the real content — same two-step as the web composer.
        // setParams rebinds the screen to the new id so chat.subscribe picks
        // up deltas.
        const res = await api.post('/providers/sessions', {
          provider: provider ?? 'claude',
          projectPath,
          initialMessage: messageContent,
        });
        if (!res.ok) throw new Error(`create session failed (${res.status})`);
        const body = await res.json();
        const newId = body?.data?.sessionId;
        if (!newId) throw new Error('create session returned no id');
        navigation.setParams({
          sessionId: newId,
          newSession: undefined,
          title: body?.data?.sessionName || content.slice(0, 50),
        });
        setMessages([{ id: `local-${Date.now()}`, role: 'user', text: messageContent, tools: [], timestamp: Date.now() }]);
        if (isConnected) {
          sendMessage({ type: 'chat.send', sessionId: newId, content: messageContent, options: buildSendOptions() });
        } else {
          await api.queue.enqueue(newId, { content: messageContent, options: buildSendOptions() });
        }
      } else {
        // Upload pending attachments first — the returned descriptors ride
        // along in options.attachments, same as the web composer.
        let attachments: unknown[] = [];
        if (pendingAttachments.length > 0) {
          const form = new FormData();
          for (const a of pendingAttachments) {
            form.append('files', { uri: a.uri, name: a.name, type: a.mimeType } as never);
          }
          const up = await api.post('/assets/files', form);
          if (!up.ok) throw new Error(`upload failed (${up.status})`);
          const upBody = await up.json();
          attachments = Array.isArray(upBody?.attachments) ? upBody.attachments : [];
          setPendingAttachments([]);
        }
        setMessages((prev) => [...prev, { id: `local-${Date.now()}`, role: 'user', text: messageContent, tools: [], timestamp: Date.now() }]);
        const options = { ...buildSendOptions(), attachments };
        // chat.send over WS binds this socket as the run's writer → live
        // deltas stream here. Server auto-enqueues on RUN_IN_PROGRESS; only
        // the offline path hits the REST queue.
        if (isConnected) {
          sendMessage({ type: 'chat.send', sessionId, content: messageContent, options });
        } else {
          await api.queue.enqueue(sessionId, { content: messageContent, options });
        }
      }
      setQueueKey((k) => k + 1);
      // After a draft-mode send the session id changes → the draft saved
      // under the old key would resurrect on the next "new session".
      void AsyncStorage.removeItem(draftKey).catch(() => {});
    } catch (err) {
      console.error('send failed:', err);
      Alert.alert('Send failed', err instanceof Error ? err.message : String(err));
    } finally {
      setSending(false);
    }
  };

  // Resend the last user message after a provider error — no duplicate
  // bubble, the failed turn simply reruns (same as the web retry affordance).
  const retryLast = useCallback(() => {
    const last = [...messagesRef.current].reverse().find((m) => m.role === 'user');
    if (!last || !sessionId || sending) return;
    const options = buildSendOptions();
    if (isConnected) {
      sendMessage({ type: 'chat.send', sessionId, content: last.text, options });
    } else {
      void api.queue.enqueue(sessionId, { content: last.text, options });
    }
    setQueueKey((k) => k + 1);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sessionId, sending, isConnected, permissionMode, model, effort, autoContinue]);

  const { speaking, speak, stop: stopSpeak } = useTts();

  const renderMessage = ({ item, index }: { item: ChatMessage; index: number }) => {
    const isUser = item.role === 'user';
    const isActiveSearchMatch = isSearchActive && index === activeSearchMessageIndex;
    const searchRing = isActiveSearchMatch
      ? { borderWidth: 2, borderColor: colors.primary, borderRadius: 12 }
      : null;
    if (item.role === 'thinking') {
      return (
        <View style={[{ marginBottom: 8, opacity: 0.6 }, searchRing]}>
          <HighlightText
            text={item.text}
            query={trimmedSearch}
            style={{ color: colors.mutedForeground, fontStyle: 'italic', fontSize: 13 }}
            numberOfLines={3}
          />
        </View>
      );
    }
    const messageActions = () => {
      const text = item.text.trim();
      if (!text) return;
      setSheet({
        title: 'Message',
        items: [
          { label: 'Copy', onPress: () => void Clipboard.setStringAsync(text) },
          { label: 'Share', onPress: () => void Share.share({ message: text }) },
          {
            label: speaking ? 'Stop reading' : 'Read aloud',
            onPress: () => {
              if (speaking) stopSpeak();
              else speak(text);
            },
          },
          // "Save as task" — assistant answers become TaskMaster cards.
          ...(isUser || !projectId
            ? []
            : [
                {
                  label: 'Save as task',
                  onPress: () => {
                    const title = text.length <= 80 ? text : `${text.slice(0, 77).trim()}…`;
                    api.taskmaster
                      .addTask(projectId, { title, description: text, priority: 'medium' })
                      .catch((err) => console.error('save as task failed:', err));
                  },
                },
              ]),
        ],
      });
    };
    return (
      <TouchableOpacity
        activeOpacity={0.9}
        onLongPress={messageActions}
        style={[{
          alignSelf: isUser ? 'flex-end' : 'stretch',
          maxWidth: isUser ? '85%' : '100%',
          backgroundColor: isUser ? colors.primary : 'transparent',
          borderRadius: 12,
          paddingHorizontal: isUser ? 12 : 4,
          paddingVertical: 8,
          marginBottom: 8,
        }, searchRing]}
      >
        {item.tools.map((t) => (
          <ToolRow key={t.id} tool={t} colors={colors} query={isSearchActive ? trimmedSearch : ''} />
        ))}
        {item.images?.map((img, i) => {
          // Inline base64 or a server path → project file content endpoint.
          const uri = img.data
            ? img.data.startsWith('data:')
              ? img.data
              : `data:image/png;base64,${img.data}`
            : img.path && projectId
              ? `${getServerUrlSync()}/api/file-tree/projects/${projectId}/files/content?path=${encodeURIComponent(img.path)}`
              : null;
          if (!uri) return null;
          return (
            <Image
              key={`${img.path ?? img.name ?? i}`}
              source={{ uri, headers: img.data ? undefined : { Authorization: `Bearer ${getStoredAuthToken() ?? ''}` } }}
              style={{ width: 220, height: 160, borderRadius: 8, marginBottom: 6 }}
              resizeMode="cover"
            />
          );
        })}
        {item.files?.map((f, i) => (
          <View key={`${f.path ?? f.name ?? i}`} style={{ flexDirection: 'row', alignItems: 'center', marginBottom: 4, opacity: 0.85 }}>
            <Paperclip size={12} color={isUser ? colors.primaryForeground : colors.mutedForeground} />
            <Text style={{ color: isUser ? colors.primaryForeground : colors.mutedForeground, fontSize: 12, marginLeft: 5 }} numberOfLines={1}>
              {f.name ?? f.path ?? 'file'}
            </Text>
          </View>
        ))}
        {item.text.trim().length > 0 &&
          (item.isError ? (
            <View>
              <HighlightText text={item.text} query={trimmedSearch} style={{ color: colors.destructive }} />
              <TouchableOpacity onPress={retryLast} disabled={sending} style={{ marginTop: 6, alignSelf: 'flex-start', paddingVertical: 4, paddingHorizontal: 12, borderRadius: 8, borderWidth: 1, borderColor: colors.destructive }}>
                <Text style={{ color: colors.destructive, fontSize: 13 }}>Retry</Text>
              </TouchableOpacity>
            </View>
          ) : isUser ? (
            <HighlightText text={item.text} query={trimmedSearch} style={{ color: colors.primaryForeground }} highlightColor="#fbbf24" highlightTextColor="#422006" />
          ) : (
            <Markdown
              rules={markdownRules(colors) as any}
              style={{
                body: { color: colors.foreground, fontSize: 15 },
                code_inline: { backgroundColor: colors.muted, color: colors.foreground, borderRadius: 4 },
                code_block: { backgroundColor: colors.card, color: colors.foreground, borderRadius: 8, padding: 10, borderWidth: 1, borderColor: colors.border },
                fence: { backgroundColor: colors.card, color: colors.foreground, borderRadius: 8, padding: 10, borderWidth: 1, borderColor: colors.border },
                link: { color: colors.primary },
                heading1: { color: colors.foreground },
                heading2: { color: colors.foreground },
                heading3: { color: colors.foreground },
                blockquote: { backgroundColor: colors.muted, borderLeftColor: colors.border, paddingHorizontal: 10 },
                list_item: { color: colors.foreground },
              }}
            >
              {item.text}
            </Markdown>
          ))}
        {item.isStreaming && <ActivityIndicator size="small" color={colors.primary} style={{ marginTop: 4, alignSelf: 'flex-start' }} />}
      </TouchableOpacity>
    );
  };

  return (
    <Reanimated.View style={[{ flex: 1, backgroundColor: colors.background }, kbPad]}>
      {loading ? (
        <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
          <ActivityIndicator color={colors.primary} size="large" />
        </View>
      ) : (
        <View style={{ flex: 1 }}>
        {searchOpen && (
          <View style={{ flexDirection: 'row', alignItems: 'center', paddingHorizontal: 10, paddingVertical: 6, borderBottomWidth: 1, borderBottomColor: colors.border, backgroundColor: colors.card }}>
            <Search size={15} color={colors.mutedForeground} />
            <TextInput
              ref={searchInputRef}
              value={searchQuery}
              onChangeText={(v) => { setSearchQuery(v); setActiveMatchIndex(0); }}
              placeholder="Search"
              placeholderTextColor={colors.mutedForeground}
              autoCorrect={false}
              autoCapitalize="none"
              returnKeyType="search"
              onSubmitEditing={() => goToMatch(1)}
              onKeyPress={(e) => {
                // Hardware keyboard: Esc clears and closes (web parity).
                if (e.nativeEvent.key === 'Escape') closeSearch();
              }}
              style={{ flex: 1, color: colors.foreground, fontSize: 14, marginLeft: 8, paddingVertical: 4 }}
            />
            {isSearchActive && (
              <Text style={{ color: colors.mutedForeground, fontSize: 12, marginRight: 4 }}>
                {searchIndex.count > 0 ? `${Math.min(activeMatchIndex + 1, searchIndex.count)} of ${searchIndex.count}` : '0 of 0'}
              </Text>
            )}
            {isSearchActive && (
              <>
                <TouchableOpacity onPress={() => goToMatch(-1)} disabled={searchIndex.count === 0} hitSlop={6} style={{ padding: 4 }}>
                  <ChevronUp size={16} color={searchIndex.count === 0 ? colors.mutedForeground : colors.foreground} />
                </TouchableOpacity>
                <TouchableOpacity onPress={() => goToMatch(1)} disabled={searchIndex.count === 0} hitSlop={6} style={{ padding: 4 }}>
                  <ChevronDown size={16} color={searchIndex.count === 0 ? colors.mutedForeground : colors.foreground} />
                </TouchableOpacity>
                <TouchableOpacity onPress={closeSearch} hitSlop={6} style={{ padding: 4 }}>
                  <X size={16} color={colors.mutedForeground} />
                </TouchableOpacity>
              </>
            )}
          </View>
        )}
        <FlatList
          ref={listRef}
          data={messages}
          keyExtractor={(item) => item.id}
          renderItem={renderMessage}
          contentContainerStyle={{ padding: 12, paddingBottom: 8 }}
          onContentSizeChange={() => { if (atBottom) listRef.current?.scrollToEnd({ animated: false }); }}
          onScroll={(e) => {
            const { contentOffset, layoutMeasurement, contentSize } = e.nativeEvent;
            setAtBottom(contentOffset.y + layoutMeasurement.height >= contentSize.height - 80);
          }}
          scrollEventThrottle={100}
          ListHeaderComponent={
            hasMore ? (
              <TouchableOpacity onPress={loadOlder} disabled={loadingOlder} style={{ alignSelf: 'center', paddingVertical: 8, paddingHorizontal: 16, marginBottom: 8, backgroundColor: colors.card, borderRadius: 8, borderWidth: 1, borderColor: colors.border }}>
                {loadingOlder ? <ActivityIndicator size="small" color={colors.primary} /> : <Text style={{ color: colors.primary, fontSize: 13 }}>Load older messages</Text>}
              </TouchableOpacity>
            ) : null
          }
          ListEmptyComponent={
            <Text style={{ color: colors.mutedForeground, textAlign: 'center', marginTop: 48 }}>
              {isSearchActive ? 'No messages match your search.' : 'No messages yet — send the first one'}
            </Text>
          }
        />
        {isSearchActive && searchIndex.count === 0 && messages.length > 0 && (
          <Text style={{ position: 'absolute', top: 8, alignSelf: 'center', color: colors.mutedForeground, fontSize: 12, backgroundColor: colors.card, paddingHorizontal: 10, paddingVertical: 4, borderRadius: 12, borderWidth: 1, borderColor: colors.border }}>
            No messages match your search.
          </Text>
        )}
        {!atBottom && (
          <TouchableOpacity
            onPress={() => listRef.current?.scrollToEnd({ animated: true })}
            style={{ position: 'absolute', right: 16, bottom: 12 + insets.bottom, backgroundColor: colors.card, borderRadius: 20, padding: 10, borderWidth: 1, borderColor: colors.border }}
          >
            <ArrowDown color={colors.foreground} size={18} />
          </TouchableOpacity>
        )}
        </View>
      )}
      <PermissionBanner requests={pendingPermissions} colors={colors} onDecision={handlePermissionDecision} />
      <QueueBar sessionId={sessionId} colors={colors} reloadKey={queueKey} />
      {(() => {
        const m = draft.match(/@([\w./-]*)$/);
        if (!m || mentionFiles.length === 0) return null;
        const q = m[1].toLowerCase();
        const matches = mentionFiles.filter((p) => p.toLowerCase().includes(q)).slice(0, 8);
        if (matches.length === 0) return null;
        return (
          <View style={{ backgroundColor: colors.card, borderTopWidth: 1, borderTopColor: colors.border, maxHeight: 200 }}>
            <FlatList
              keyboardShouldPersistTaps="handled"
              data={matches}
              keyExtractor={(p) => p}
              renderItem={({ item: p }) => (
                <TouchableOpacity
                  onPress={() => setDraft((d) => d.replace(/@[\w./-]*$/, `@${p} `))}
                  style={{ paddingVertical: 10, paddingHorizontal: 14, borderBottomWidth: 1, borderBottomColor: colors.border }}
                >
                  <Text style={{ color: colors.foreground, fontSize: 13 }} numberOfLines={1}>{p}</Text>
                </TouchableOpacity>
              )}
            />
          </View>
        );
      })()}
      {draft.startsWith('/') && slashCommands.length > 0 && (
        <View style={{ backgroundColor: colors.card, borderTopWidth: 1, borderTopColor: colors.border, maxHeight: 200 }}>
          <FlatList
            keyboardShouldPersistTaps="handled"
            data={slashCommands.filter((c) => c.name.replace(/^\//, '').startsWith(draft.slice(1).split(/\s/)[0]))}
            keyExtractor={(c) => c.name}
            renderItem={({ item: c }) => (
              <TouchableOpacity
                onPress={() => setDraft(c.name.startsWith('/') ? `${c.name} ` : `/${c.name} `)}
                style={{ paddingVertical: 10, paddingHorizontal: 14, borderBottomWidth: 1, borderBottomColor: colors.border }}
              >
                <Text style={{ color: colors.primary, fontWeight: '500', fontSize: 13 }}>
                  {c.name.startsWith('/') ? c.name : `/${c.name}`}
                </Text>
                {!!c.description && (
                  <Text style={{ color: colors.mutedForeground, fontSize: 12, marginTop: 2 }} numberOfLines={1}>
                    {c.description}
                  </Text>
                )}
              </TouchableOpacity>
            )}
          />
        </View>
      )}
      <View style={{ flexDirection: 'row', gap: 8, paddingHorizontal: 10, paddingTop: 8, backgroundColor: colors.card, borderTopWidth: 1, borderTopColor: colors.border }}>
        {models.length > 0 && (
          <TouchableOpacity
            onPress={() => { setModelSearch(''); setModelModal(true); }}
            style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: colors.secondary, borderRadius: 12, paddingHorizontal: 10, paddingVertical: 4 }}
          >
            <Text style={{ color: colors.secondaryForeground, fontSize: 12 }}>{models.find((m) => m.value === model)?.label ?? model ?? 'Model'}</Text>
            <ChevronDown size={12} color={colors.secondaryForeground} />
          </TouchableOpacity>
        )}
        <TouchableOpacity
          onPress={() => setPermModal(true)}
          style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: permissionMode === 'default' ? colors.secondary : colors.primary, borderRadius: 12, paddingHorizontal: 10, paddingVertical: 4 }}
        >
          <Text style={{ color: permissionMode === 'default' ? colors.secondaryForeground : colors.primaryForeground, fontSize: 12 }}>
            {permissionMode}
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          onPress={toggleAutoRead}
          style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: autoRead ? colors.primary : colors.secondary, borderRadius: 12, paddingHorizontal: 10, paddingVertical: 4 }}
        >
          <AudioLines size={12} color={autoRead ? colors.primaryForeground : colors.secondaryForeground} />
        </TouchableOpacity>
        {checkpointRef.current && undoState !== 'restored' && (
          <TouchableOpacity
            onPress={() => void undoAiRun()}
            disabled={undoState === 'restoring'}
            style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: colors.secondary, borderRadius: 12, paddingHorizontal: 10, paddingVertical: 4 }}
          >
            {undoState === 'restoring' ? <ActivityIndicator size={10} color={colors.secondaryForeground} /> : <RotateCcw size={11} color={colors.secondaryForeground} />}
            <Text style={{ color: colors.secondaryForeground, fontSize: 12, marginLeft: 4 }}>Undo</Text>
          </TouchableOpacity>
        )}
        {undoState === 'restored' && (
          <View style={{ flexDirection: 'row', alignItems: 'center', paddingHorizontal: 8, paddingVertical: 4 }}>
            <Check size={11} color="#10b981" />
            <Text style={{ color: '#10b981', fontSize: 12, marginLeft: 3 }}>Undone</Text>
          </View>
        )}
        {tokenUsage && (
          <TouchableOpacity onPress={openChangedFiles} style={{ marginLeft: 'auto', flexDirection: 'row', alignItems: 'center', paddingHorizontal: 6 }}>
            <FileDiff size={12} color={colors.mutedForeground} />
            <Text style={{ color: colors.mutedForeground, fontSize: 11, marginLeft: 3 }}>
              {Math.round(tokenUsage.used / 1000)}k/{Math.round(tokenUsage.total / 1000)}k
            </Text>
          </TouchableOpacity>
        )}
        {running && (
          <TouchableOpacity
            onPress={() => sessionId && sendMessage({ type: 'chat.abort', sessionId })}
            style={{ marginLeft: tokenUsage ? 8 : 'auto', flexDirection: 'row', alignItems: 'center', backgroundColor: colors.destructive, borderRadius: 12, paddingHorizontal: 10, paddingVertical: 4 }}
          >
            <Square size={11} color="#fff" fill="#fff" />
            <Text style={{ color: '#fff', fontSize: 12, marginLeft: 4 }}>Stop</Text>
          </TouchableOpacity>
        )}
      </View>
      {pinnedFiles.length > 0 && (
        <View style={{ flexDirection: 'row', flexWrap: 'wrap', alignItems: 'center', gap: 6, paddingHorizontal: 10, paddingTop: 6, backgroundColor: colors.card }}>
          <Pin size={11} color={colors.mutedForeground} />
          {pinnedFiles.map((p) => (
            <View key={p} style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: colors.secondary, borderRadius: 8, paddingHorizontal: 8, paddingVertical: 4, maxWidth: 220 }}>
              <Text style={{ color: colors.secondaryForeground, fontSize: 11 }} numberOfLines={1}>{p}</Text>
              <TouchableOpacity onPress={() => unpinFile(p)} hitSlop={6} style={{ marginLeft: 4 }}>
                <X size={12} color={colors.secondaryForeground} />
              </TouchableOpacity>
            </View>
          ))}
        </View>
      )}
      {pendingAttachments.length > 0 && (
        <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 6, paddingHorizontal: 10, paddingTop: 6, backgroundColor: colors.card }}>
          {pendingAttachments.map((a, i) => (
            <View key={`${a.uri}-${i}`} style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: colors.secondary, borderRadius: 8, paddingHorizontal: 8, paddingVertical: 4 }}>
              <Text style={{ color: colors.secondaryForeground, fontSize: 11 }} numberOfLines={1}>{a.name}</Text>
              <TouchableOpacity onPress={() => setPendingAttachments((prev) => prev.filter((_, j) => j !== i))} hitSlop={6} style={{ marginLeft: 4 }}>
                <X size={12} color={colors.secondaryForeground} />
              </TouchableOpacity>
            </View>
          ))}
        </View>
      )}
      {voiceInput.error && (
        <Text style={{ color: colors.destructive, fontSize: 11, paddingHorizontal: 12, paddingTop: 4, backgroundColor: colors.card }}>
          {voiceInput.error}
        </Text>
      )}
      <View
        style={{
          flexDirection: 'row',
          alignItems: 'flex-end',
          padding: 10,
          paddingBottom: kbVisible ? 10 : 10 + insets.bottom,
          gap: 8,
          backgroundColor: colors.card,
        }}
      >
        <TouchableOpacity onPress={openAttachMenu} style={{ padding: 10 }} hitSlop={6}>
          <Paperclip color={colors.mutedForeground} size={18} />
        </TouchableOpacity>
        <TouchableOpacity
          onPress={() => void voiceInput.toggle()}
          style={{ padding: 10 }}
          hitSlop={6}
          accessibilityLabel="Voice input"
        >
          <Mic
            color={voiceInput.state === 'recording' ? '#ef4444' : voiceInput.state === 'processing' ? '#f59e0b' : colors.mutedForeground}
            size={18}
          />
        </TouchableOpacity>
        <TextInput
          value={draft}
          onChangeText={setDraft}
          placeholder={isConnected ? 'Message…' : 'Reconnecting…'}
          placeholderTextColor={colors.mutedForeground}
          multiline
          style={{
            flex: 1,
            backgroundColor: colors.background,
            color: colors.foreground,
            borderColor: colors.border,
            borderWidth: 1,
            borderRadius: 10,
            paddingHorizontal: 12,
            paddingTop: 10,
            paddingBottom: 10,
            maxHeight: 120,
          }}
        />
        <TouchableOpacity
          onPress={send}
          disabled={!draft.trim() || sending}
          style={{ backgroundColor: colors.primary, borderRadius: 10, padding: 12, opacity: !draft.trim() || sending ? 0.5 : 1 }}
        >
          <Send color={colors.primaryForeground} size={18} />
        </TouchableOpacity>
      </View>
      <ActionSheet visible={sheet !== null} title={sheet?.title} items={sheet?.items ?? []} onClose={() => setSheet(null)} />
      <Modal visible={changedFiles !== null} transparent animationType="fade" onRequestClose={() => setChangedFiles(null)}>
        <TouchableOpacity style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', padding: 24 }} activeOpacity={1} onPress={() => setChangedFiles(null)}>
          <View style={{ backgroundColor: colors.card, borderRadius: 12, padding: 8, maxHeight: 400 }}>
            <Text style={{ color: colors.foreground, fontWeight: '600', padding: 12 }}>Changed files</Text>
            <FlatList
              data={changedFiles ?? []}
              keyExtractor={(f, i) => `${f}-${i}`}
              ListEmptyComponent={<Text style={{ color: colors.mutedForeground, padding: 12 }}>No changed files</Text>}
              renderItem={({ item: f }) => (
                <View style={{ paddingVertical: 8, paddingHorizontal: 12 }}>
                  <Text style={{ color: colors.foreground, fontSize: 13 }} numberOfLines={1}>{f}</Text>
                </View>
              )}
            />
          </View>
        </TouchableOpacity>
      </Modal>
      <Modal visible={modelModal} transparent animationType="fade" onRequestClose={() => setModelModal(false)}>
        <TouchableOpacity style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', padding: 24 }} activeOpacity={1} onPress={() => setModelModal(false)}>
          <View style={{ backgroundColor: colors.card, borderRadius: 12, padding: 8, maxHeight: 400 }}>
            <Text style={{ color: colors.foreground, fontWeight: '600', padding: 12 }}>Model</Text>
            <TextInput
              value={modelSearch}
              onChangeText={setModelSearch}
              placeholder="Search models…"
              placeholderTextColor={colors.mutedForeground}
              autoCapitalize="none"
              autoCorrect={false}
              style={{ marginHorizontal: 12, marginBottom: 8, backgroundColor: colors.background, color: colors.foreground, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 10, paddingVertical: 8 }}
            />
            <FlatList
              data={models.filter((m) => matchesModelSearch(`${m.label} ${m.value} ${m.description ?? ''}`, modelSearch))}
              keyExtractor={(m) => m.value}
              renderItem={({ item: m }) => (
                <TouchableOpacity
                  onPress={() => void pickModel(m.value)}
                  style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 10, paddingHorizontal: 12, borderRadius: 8, backgroundColor: m.value === model ? colors.secondary : 'transparent' }}
                >
                  <View style={{ flex: 1 }}>
                    <Text style={{ color: colors.foreground, fontSize: 14 }}>{m.label}</Text>
                    {!!m.description && (
                      <Text style={{ color: colors.mutedForeground, fontSize: 11, marginTop: 2 }} numberOfLines={2}>{m.description}</Text>
                    )}
                  </View>
                  {m.value === model && <Check size={16} color={colors.primary} />}
                </TouchableOpacity>
              )}
            />
            {(models.find((m) => m.value === model)?.effort?.values?.length ?? 0) > 0 && (
              <View style={{ padding: 12, borderTopWidth: 1, borderTopColor: colors.border }}>
                <Text style={{ color: colors.mutedForeground, fontSize: 11, marginBottom: 6 }}>Effort</Text>
                <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 6 }}>
                  {[{ value: 'default', label: 'Default' }, ...(models.find((m) => m.value === model)?.effort?.values ?? [])].map((e) => {
                    const on = (effort ?? 'default') === e.value;
                    return (
                      <TouchableOpacity
                        key={e.value}
                        onPress={() => setEffort(e.value === 'default' ? null : e.value)}
                        style={{ borderRadius: 8, paddingHorizontal: 10, paddingVertical: 6, backgroundColor: on ? colors.primary : colors.secondary }}
                      >
                        <Text style={{ color: on ? colors.primaryForeground : colors.secondaryForeground, fontSize: 12 }}>{e.label ?? e.value}</Text>
                      </TouchableOpacity>
                    );
                  })}
                </View>
              </View>
            )}
          </View>
        </TouchableOpacity>
      </Modal>
      <Modal visible={permModal} transparent animationType="fade" onRequestClose={() => setPermModal(false)}>
        <TouchableOpacity style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', padding: 24 }} activeOpacity={1} onPress={() => setPermModal(false)}>
          <View style={{ backgroundColor: colors.card, borderRadius: 12, padding: 8 }}>
            <Text style={{ color: colors.foreground, fontWeight: '600', padding: 12 }}>Permission mode</Text>
            {permissionModes.map((m) => (
              <TouchableOpacity
                key={m}
                onPress={() => {
                  setPermissionMode(m);
                  setPermModal(false);
                }}
                style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 10, paddingHorizontal: 12, borderRadius: 8, backgroundColor: m === permissionMode ? colors.secondary : 'transparent' }}
              >
                <Text style={{ flex: 1, color: colors.foreground, fontSize: 14 }}>{m}</Text>
                {m === permissionMode && <Check size={16} color={colors.primary} />}
              </TouchableOpacity>
            ))}
            <TouchableOpacity
              onPress={toggleAutoContinue}
              style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 10, paddingHorizontal: 12, borderTopWidth: 1, borderTopColor: colors.border, marginTop: 4 }}
            >
              <Text style={{ flex: 1, color: colors.foreground, fontSize: 14 }}>Auto-continue tasks</Text>
              <View style={{ width: 36, height: 20, borderRadius: 10, backgroundColor: autoContinue ? colors.primary : colors.muted, justifyContent: 'center', paddingHorizontal: 2 }}>
                <View style={{ width: 16, height: 16, borderRadius: 8, backgroundColor: '#fff', alignSelf: autoContinue ? 'flex-end' : 'flex-start' }} />
              </View>
            </TouchableOpacity>
          </View>
        </TouchableOpacity>
      </Modal>
    </Reanimated.View>
  );
}
