import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import {
  ActivityIndicator,
  Alert,
  FlatList,
  Image,
  Modal,
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
import { Send, ChevronDown, ChevronRight, ChevronUp, X, ShieldAlert, Check, Square, Paperclip, MoreVertical, FileDiff, Volume2, RotateCcw, HelpCircle, AudioLines, TerminalSquare, Mic, Search, UserCircle2 } from 'lucide-react-native';
import * as Clipboard from 'expo-clipboard';
import * as ImagePicker from 'expo-image-picker';
import * as DocumentPicker from 'expo-document-picker';
import * as Print from 'expo-print';
import * as Sharing from 'expo-sharing';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { usePinnedFiles } from '../lib/pinned-files';
import { useVoiceInput } from '../lib/voice-input';
import { useTts, speakText, stopSpeaking, loadPreferredVoice } from '../lib/tts';
import { permissionModesFor, buildMarkdownExport, buildHtmlExport, exportFilename, convertMarkdownToPlainText, copyFormatOptions, formatExportTimestamp } from '../lib/chat-extras';
import { buildPrintFilename, buildPrintHtml } from '../lib/chat-print';
import {
  type MentionableItem,
  type CommandModalPayload,
  type SlashCommand as ComposerSlashCommand,
  filterMentions,
  filterSlashCommands,
  flattenCommandRows,
  flattenFileTree,
  groupCommands,
  insertMention,
  isOpenTask,
  mentionQueryAt,
  resolveCommandResult,
  shouldSubmitOnEnter,
  slashQueryAt,
  splitMentionParts,
  stepIndex,
  submitState,
} from '../lib/composer';
import { ActionSheet, ActionSheetItem } from '../components/ActionSheet';
import {
  CommandMenuList,
  CommandResultModal,
  ComposerAttachmentChip,
  MentionDropdown,
  MentionHighlightOverlay,
} from '../components/ComposerMenus';
import { AccountMenuModal, ModelMenuModal, PermissionMenuModal } from '../components/ModelMenus';
import { ActivityBanner, ContextBanner, QuotaBadge, useActivityResync } from '../components/UsageBlocks';
import { resolveEffortOptions } from '../lib/model-menu';
import { advanceCursor, formatTokenCount } from '../lib/usage';
import {
  QueuedOfflineMessage,
  flushOfflineMessages,
  offlineQueueKey,
  parseOfflineQueue,
  serializeOfflineQueue,
} from '../lib/offline-queue';
import { OfflineQueueCard, QueuedMessageCard } from '../components/QueueBlocks';
import { DraftPaneEmptyState, SessionPickerSheet, SessionWorkspaceDialog } from '../components/SessionBlocks';
import { FadeSlideIn } from '../components/FadeSlideIn';
import { Toast, useToast } from '../components/Toast';
import { resolveChatShortcut } from '../lib/chat-shortcuts';
import { acquireKeepAwake, releaseKeepAwake } from '../lib/keep-awake';
import { useUiPreferences } from '../lib/ui-preferences-store';
import { usePinnedSessions } from '../lib/pinned-sessions';
import {
  isArmedIn,
  legacyMobileDraftKey,
  parseArmedSessions,
  projectDraftKey,
  resolveDraftKey,
  sessionDraftKey,
  shouldSpeakCompletion,
  toggleArmedIn,
  type PickerSession,
} from '../lib/session-picker';
import { LoadAllOverlay, OlderMessagesBanner, ScrollToBottomButton, ShowingLastRow } from '../components/ScrollBlocks';
import { PinnedFilesBar, ReviewFilesPanel } from '../components/ReviewBlocks';
import { estimateTokensFromContent, parseChangedFiles, type ChangedFile } from '../lib/review-files';
import {
  SESSION_MESSAGES_PAGE_SIZE,
  computeAnchorOffset,
  isNearBottom,
  nextVisibleCount,
  shouldAutoLoadAll,
  sliceVisibleMessages,
} from '../lib/scroll';
import { api, getStoredAuthToken } from '~shared/utils/api';
import { WebView } from 'react-native-webview';
import { ocChatColors, ocChatTheme, CHAT_FONT_SIZE, MONO_FONT } from '../theme';
import { useWebSocket } from '../contexts/WebSocketContext';
import { getServerUrlSync } from '../lib/server-config';
import { getLanguage } from '../i18n';
import { ChatMessage, ToolCall, messagesFromResponse, parseItem } from '../lib/chat-messages';
import { buildSearchIndex, stepMatch, nearestMatchIndex } from '../lib/chat-search';
import { HighlightText } from '../components/HighlightText';
import { ToolItem, ToolGroupBlock } from '../components/ToolBlocks';
import { createMarkdownRules } from '../components/MarkdownBlocks';
import {
  AssistantFooter,
  MessageAvatar,
  MessageFileCard,
  MessageImage,
  InteractivePromptCard,
  JsonCard,
  ReasoningBlock,
  TaskNotificationRow,
} from '../components/MarkdownBlocks';
import { groupConsecutiveTools, isToolGroupItem } from '../lib/tool-render';
import {
  detectPureJson,
  formatUsageLimitText,
  isGroupedMessage,
  normalizeInlineCodeFences,
  parseInteractivePrompt,
  parseTaskNotification,
  stripProposedPlanEnvelope,
  turnLatencySeconds,
} from '../lib/chat-format';
import {
  ClaudeSettings,
  createEmptyClaudeSettings,
  parseClaudeSettings,
  buildClaudeToolPermissionEntry,
  formatToolInputForDisplay,
  extractAffectedFilePaths,
  isPlanToolRequest,
  matchingRememberRequestIds,
  grantClaudeToolPermission,
  resolveStoredPermissionMode,
} from '../lib/chat-permissions';

const CLAUDE_SETTINGS_KEY = 'claude-settings';

interface QueuedItem {
  id: string;
  content?: string;
  status?: 'queued' | 'sending' | 'sent' | 'failed';
  options?: { attachments?: unknown[] } | null;
}

interface PermissionRequest {
  requestId: string;
  toolName: string;
  input?: unknown;
  sessionId?: string;
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

/** ExitPlanMode → inline plan approval (web renders this via PlanDisplay). */
function PlanApprovalCard({
  request,
  colors,
  onDecision,
}: {
  request: PermissionRequest;
  colors: any;
  onDecision: (ids: string[], decision: { allow: boolean; message?: string; updatedInput?: unknown }) => void;
}) {
  const plan =
    request.input && typeof request.input === 'object' && typeof (request.input as { plan?: unknown }).plan === 'string'
      ? (request.input as { plan: string }).plan
      : formatToolInputForDisplay(request.input);
  return (
    <View style={{ backgroundColor: colors.card, borderColor: colors.border, borderWidth: 1, borderRadius: 10, padding: 10, marginBottom: 6 }}>
      <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6, marginBottom: 6 }}>
        <FileDiff size={15} color={colors.primary} />
        <Text style={{ color: colors.foreground, fontWeight: '600', fontSize: 13 }}>Plan ready for review</Text>
      </View>
      <Text style={{ color: colors.mutedForeground, fontSize: 12, lineHeight: 18, marginBottom: 8 }}>{plan}</Text>
      <View style={{ flexDirection: 'row', justifyContent: 'flex-end', gap: 10 }}>
        <TouchableOpacity
          onPress={() => onDecision([request.requestId], { allow: false, message: 'User asked to revise the plan' })}
          style={{ borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 14, paddingVertical: 8 }}
        >
          <Text style={{ color: colors.mutedForeground, fontWeight: '600', fontSize: 13 }}>Revise</Text>
        </TouchableOpacity>
        <TouchableOpacity
          onPress={() => onDecision([request.requestId], { allow: true })}
          style={{ backgroundColor: colors.primary, borderRadius: 8, paddingHorizontal: 14, paddingVertical: 8 }}
        >
          <Text style={{ color: colors.primaryForeground, fontWeight: '600', fontSize: 13 }}>Build</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

/**
 * Pending permission_request frames → Allow/Deny banner above the composer.
 * Mirrors the web PermissionRequestsBanner: affected-file "blast radius",
 * the Claude allow-rule entry, expandable raw input, and Allow & remember.
 */
function PermissionBanner({
  requests,
  colors,
  provider,
  onDecision,
  onGrant,
}: {
  requests: PermissionRequest[];
  colors: any;
  provider?: string;
  onDecision: (ids: string[], decision: { allow: boolean; message?: string; updatedInput?: unknown }) => void;
  onGrant: (entry: string | null) => void;
}) {
  const [settings, setSettings] = useState<ClaudeSettings>(createEmptyClaudeSettings);
  // ExitPlanMode is handled inline (PlanApprovalCard), not as a generic card.
  const filtered = requests.filter((r) => !isPlanToolRequest(r.toolName));
  const planRequests = requests.filter((r) => isPlanToolRequest(r.toolName));

  useEffect(() => {
    AsyncStorage.getItem(CLAUDE_SETTINGS_KEY)
      .then((raw) => setSettings(parseClaudeSettings(raw)))
      .catch(() => {});
  }, [requests.length]);

  if (requests.length === 0) return null;
  const allIds = filtered.map((r) => r.requestId);
  return (
    <View style={{ borderTopWidth: 1, borderTopColor: colors.border, backgroundColor: colors.card, padding: 10 }}>
      {allIds.length > 1 && (
        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginBottom: 8 }}>
          <Text style={{ color: colors.foreground, fontSize: 12, fontWeight: '600' }}>{allIds.length} queued</Text>
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
      {planRequests.map((r) => (
        <PlanApprovalCard key={r.requestId} request={r} colors={colors} onDecision={onDecision} />
      ))}
      {filtered.map((r) =>
        /ask[_ ]?user[_ ]?question/i.test(r.toolName) ? (
          <AskUserQuestionCard key={r.requestId} request={r} colors={colors} onDecision={onDecision} />
        ) : (
          <PermissionCard
            key={r.requestId}
            request={r}
            requests={requests}
            colors={colors}
            provider={provider}
            settings={settings}
            onDecision={onDecision}
            onGrant={onGrant}
          />
        ),
      )}
    </View>
  );
}

function PermissionCard({
  request: r,
  requests,
  colors,
  provider,
  settings,
  onDecision,
  onGrant,
}: {
  request: PermissionRequest;
  requests: PermissionRequest[];
  colors: any;
  provider?: string;
  settings: ClaudeSettings;
  onDecision: (ids: string[], decision: { allow: boolean; message?: string; updatedInput?: unknown }) => void;
  onGrant: (entry: string | null) => void;
}) {
  const [showInput, setShowInput] = useState(false);
  const rawInput = formatToolInputForDisplay(r.input);
  const affectedPaths = extractAffectedFilePaths(r.toolName, r.input);
  const isClaude = provider === 'claude';
  const entry = isClaude ? buildClaudeToolPermissionEntry(r.toolName, rawInput) : null;
  const alreadyAllowed = entry ? settings.allowedTools.includes(entry) : false;
  const matchingIds = matchingRememberRequestIds(requests, entry, r.requestId);

  return (
    <View
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
      {affectedPaths.length > 0 && (
        <View style={{ marginBottom: 4 }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
            <Text style={{ color: '#d97706', fontSize: 11 }}>
              Touches {affectedPaths.length} file{affectedPaths.length === 1 ? '' : 's'}:
            </Text>
          </View>
          {affectedPaths.slice(0, 5).map((path) => (
            <Text key={path} style={{ color: '#d97706', fontSize: 11, fontFamily: 'monospace' }} numberOfLines={1}>
              {path}
            </Text>
          ))}
          {affectedPaths.length > 5 && (
            <Text style={{ color: '#d97706', fontSize: 11 }}>+{affectedPaths.length - 5} more</Text>
          )}
        </View>
      )}
      {entry && (
        <Text style={{ color: colors.mutedForeground, fontSize: 11, marginBottom: 4 }}>
          Allow rule: <Text style={{ fontFamily: 'monospace' }}>{entry}</Text>
        </Text>
      )}
      {rawInput ? (
        <TouchableOpacity onPress={() => setShowInput((v) => !v)} style={{ marginBottom: 4 }}>
          <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>View tool input</Text>
          {showInput && (
            <Text style={{ color: colors.mutedForeground, fontSize: 11, fontFamily: 'monospace', marginTop: 4 }} numberOfLines={20}>
              {rawInput}
            </Text>
          )}
        </TouchableOpacity>
      ) : null}
      <View style={{ flexDirection: 'row', gap: 8, marginTop: 6, flexWrap: 'wrap' }}>
        <TouchableOpacity
          onPress={() => onDecision([r.requestId], { allow: false, message: 'User denied tool use' })}
          style={{ flexGrow: 1, flexBasis: 90, borderColor: colors.destructive, borderWidth: 1, borderRadius: 8, paddingVertical: 8, alignItems: 'center' }}
        >
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
            <X size={14} color={colors.destructive} />
            <Text style={{ color: colors.destructive, fontWeight: '600', fontSize: 13 }}>Reject</Text>
          </View>
        </TouchableOpacity>
        {isClaude && (
          <TouchableOpacity
            disabled={!entry}
            onPress={() => {
              if (entry && !alreadyAllowed) onGrant(entry);
              onDecision(matchingIds, { allow: true });
            }}
            style={{ flexGrow: 1, flexBasis: 120, borderColor: colors.primary, borderWidth: 1, borderRadius: 8, paddingVertical: 8, alignItems: 'center', opacity: entry ? 1 : 0.5 }}
          >
            <View style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
              <Check size={14} color={colors.primary} />
              <Text style={{ color: colors.primary, fontWeight: '600', fontSize: 13 }}>
                {alreadyAllowed ? 'Allow (saved)' : 'Allow & remember'}
              </Text>
            </View>
          </TouchableOpacity>
        )}
        <TouchableOpacity
          onPress={() => onDecision([r.requestId], { allow: true })}
          style={{ flexGrow: 1, flexBasis: 100, backgroundColor: '#16a34a', borderRadius: 8, paddingVertical: 8, alignItems: 'center' }}
        >
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
            <Check size={14} color="#fff" />
            <Text style={{ color: '#fff', fontWeight: '600', fontSize: 13 }}>Allow once</Text>
          </View>
        </TouchableOpacity>
      </View>
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

/** markdown rules: mermaid fences go to the island, code is Prism-highlighted,
 *  links to workspace files open the native editor. */
const markdownRules = (colors: any, isDark: boolean, onOpenFile?: (path: string) => void) =>
  createMarkdownRules({
    colors,
    isDark,
    onOpenFile,
    renderFenceOverride: (node: any) => {
      const lang = (node.sourceInfo ?? '').trim().split(/\s+/)[0];
      return lang === 'mermaid' ? <MermaidBlock key={node.key} code={node.content} colors={colors} /> : null;
    },
    renderText: (node: any, _children: any, _parent: any, styles: any, inheritedStyles: any = {}) => {
      const content = node.content ?? '';
      if (!content.includes('$')) {
        // replicate the default text rule — returning undefined here drops the node entirely
        return <Text key={node.key} style={[inheritedStyles, styles?.text]}>{content}</Text>;
      }
      return <View key={node.key}>{renderMathText(content, node.key, colors, [inheritedStyles, styles?.text])}</View>;
    },
  });

function QueueBar({
  sessionId,
  colors,
  reloadKey,
  offlineQueue,
  onClearOffline,
  onEditQueued,
}: {
  sessionId?: string;
  colors: any;
  reloadKey: number;
  offlineQueue: QueuedOfflineMessage[];
  onClearOffline: () => void;
  onEditQueued: (message: QueuedItem) => void;
}) {
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

  if (items.length === 0 && offlineQueue.length === 0) return null;

  return (
    <View style={{ borderTopWidth: 1, borderTopColor: colors.border, backgroundColor: colors.card, paddingHorizontal: 10, paddingVertical: 6 }}>
      {!isConnected && offlineQueue.length > 0 && <OfflineQueueCard count={offlineQueue.length} colors={colors} onClear={onClearOffline} />}
      {items.map((q, i) => (
        <QueuedMessageCard
          key={q.id ?? i}
          message={{
            id: q.id,
            content: q.content ?? 'queued message',
            status: q.status === 'failed' ? 'failed' : q.status === 'sending' ? 'sending' : 'queued',
            attachmentCount: Array.isArray(q.options?.attachments) ? q.options!.attachments!.length : 0,
          }}
          colors={colors}
          onSendNow={() => { void api.queue.sendNow(q.id).then(load).catch(() => {}); }}
          onEdit={() => onEditQueued(q)}
          onDelete={() => { void api.queue.remove(q.id).then(load).catch(() => {}); }}
        />
      ))}
    </View>
  );
}

export default function ChatScreen() {
  // The web chat is forced dark with the opencode CLI palette (`.oc-chat dark`
  // in ChatInterface.tsx) regardless of the app theme, so the whole surface
  // uses the oc remap rather than the app-theme palette.
  const colors = ocChatTheme;
  const isDark = true;
  const insets = useSafeAreaInsets();
  const { preferences } = useUiPreferences();
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

  // Composer draft persistence — web parity: session-scoped drafts when bound
  // to a session, project-scoped otherwise. Migrates the old mobile key
  // (`chat-draft-<id>`) the first time each target is loaded.
  const draftKey =
    resolveDraftKey({ sessionId, projectId: projectId ?? paramPath }) ?? legacyMobileDraftKey(projectId ?? paramPath ?? 'x');
  const legacyDraftKey = legacyMobileDraftKey(sessionId ?? projectId ?? paramPath ?? 'x');
  const draftLoadedFor = useRef<string | null>(null);
  useEffect(() => {
    if (draftLoadedFor.current === draftKey) return;
    draftLoadedFor.current = draftKey;
    AsyncStorage.getItem(draftKey)
      .then(async (v) => {
        if (v) {
          setDraft(v);
          return;
        }
        const legacy = legacyDraftKey !== draftKey ? await AsyncStorage.getItem(legacyDraftKey).catch(() => null) : null;
        if (legacy) {
          setDraft(legacy);
          void AsyncStorage.setItem(draftKey, legacy).catch(() => {});
          void AsyncStorage.removeItem(legacyDraftKey).catch(() => {});
        }
      })
      .catch(() => {});
  }, [draftKey, legacyDraftKey]);
  useEffect(() => {
    const t = setTimeout(() => {
      if (draft) void AsyncStorage.setItem(draftKey, draft).catch(() => {});
      else void AsyncStorage.removeItem(draftKey).catch(() => {});
    }, 400);
    return () => clearTimeout(t);
  }, [draft, draftKey]);

  // Local offline queue (web chatStorage) — messages typed while the socket is
  // down are persisted per project and replayed on reconnect. Mirrors the web
  // `ddagent_offline_queue_<projectId>` key.
  const offlineQueueRef = useRef<QueuedOfflineMessage[]>([]);
  const offlineQueueProjectRef = useRef<string | null>(null);
  // Placeholder sessions created offline, mapped to the real session once the
  // send path promotes them, so a reconnect reuses one session per draft.
  const pendingOfflinePromotions = useRef<Map<string, string>>(new Map());
  useEffect(() => {
    const pid = projectId ?? projectPath;
    if (!pid) return;
    offlineQueueProjectRef.current = pid;
    AsyncStorage.getItem(offlineQueueKey(pid))
      .then((raw) => {
        const parsed = parseOfflineQueue(raw);
        offlineQueueRef.current = parsed;
        setOfflineQueue(parsed);
      })
      .catch(() => {});
  }, [projectId, projectPath]);
  const persistOfflineQueue = useCallback((next: QueuedOfflineMessage[]) => {
    offlineQueueRef.current = next;
    setOfflineQueue(next);
    const pid = offlineQueueProjectRef.current;
    if (!pid) return;
    const serialized = serializeOfflineQueue(next);
    if (serialized === null) void AsyncStorage.removeItem(offlineQueueKey(pid)).catch(() => {});
    else void AsyncStorage.setItem(offlineQueueKey(pid), serialized).catch(() => {});
  }, []);
  const [sheet, setSheet] = useState<{ title?: string; items: ActionSheetItem[] } | null>(null);
  const [sending, setSending] = useState(false);
  const [running, setRunning] = useState(false);
  const [permissionMode, setPermissionMode] = useState<string>('default');
  const [permissionModes, setPermissionModes] = useState<string[]>(permissionModesFor(null));
  const [model, setModel] = useState<string | null>(null);
  const [models, setModels] = useState<{ value: string; label: string; description?: string; context?: number; tier?: 'free' | 'paid'; isCustom?: boolean; effort?: { values: { value: string; label?: string }[] } }[]>([]);
  const [modelsLoading, setModelsLoading] = useState(false);
  const [effort, setEffort] = useState<string | null>(null);
  const [modelModal, setModelModal] = useState(false);
  const [permModal, setPermModal] = useState(false);
  const [accountModal, setAccountModal] = useState(false);
  const [accounts, setAccounts] = useState<{ id: string; provider: string; label: string; isDefault: boolean }[]>([]);
  const [accountId, setAccountId] = useState<string | null>(null);
  const [autoContinue, setAutoContinue] = useState(false);
  const [armedSessions, setArmedSessions] = useState<string[]>([]);
  const [pickerOpen, setPickerOpen] = useState(false);
  const [workspaceDialogOpen, setWorkspaceDialogOpen] = useState(false);
  const [pickerSessions, setPickerSessions] = useState<PickerSession[]>([]);
  const [availableProviders, setAvailableProviders] = useState<string[]>([]);
  const [pickerProjects, setPickerProjects] = useState<{ projectId: string; displayName?: string; name?: string; path?: string; fullPath?: string }[]>([]);
  const [slashCommands, setSlashCommands] = useState<ComposerSlashCommand[]>([]);
  const [commandHistory, setCommandHistory] = useState<Record<string, number>>({});
  const [pendingAttachments, setPendingAttachments] = useState<{ uri: string; name: string; mimeType: string; size?: number }[]>([]);
  const [mentionItems, setMentionItems] = useState<MentionableItem[]>([]);
  const [mentionQuery, setMentionQuery] = useState<string | null>(null);
  const [mentionAt, setMentionAt] = useState(-1);
  const [mentionIndex, setMentionIndex] = useState(-1);
  const [mentionTokens, setMentionTokens] = useState<string[]>([]);
  const [cursorPos, setCursorPos] = useState(0);
  const [commandIndex, setCommandIndex] = useState(-1);
  const [commandModal, setCommandModal] = useState<CommandModalPayload | null>(null);
  const [offlineQueue, setOfflineQueue] = useState<QueuedOfflineMessage[]>([]);
  const { toast, show: showToast, clear: clearToast } = useToast();
  const [copyFormat, setCopyFormat] = useState<'markdown' | 'text'>('markdown');
  const [attachmentPreview, setAttachmentPreview] = useState<string | null>(null);
  const composerRef = useRef<TextInput>(null);
  const [tokenUsage, setTokenUsage] = useState<{ used: number; total: number } | null>(null);
  const startedAtRef = useRef<number | null>(null);
  const [runStartedAt, setRunStartedAt] = useState<number | null>(null);
  const lastSeqRef = useRef<Map<string, { runId?: string | null; seq: number }>>(new Map());
  // Review-changed-files panel state (replaces the old modal).
  const [reviewOpen, setReviewOpen] = useState(false);
  const [changedFiles, setChangedFiles] = useState<ChangedFile[]>([]);
  const [changedLoading, setChangedLoading] = useState(false);
  const [changedError, setChangedError] = useState(false);
  const savedScrollTopRef = useRef<number | null>(null);
  const [pinnedTokenEstimate, setPinnedTokenEstimate] = useState(0);
  const tokenCacheRef = useRef<Map<string, number>>(new Map());
  const [queueKey, setQueueKey] = useState(0);
  const listRef = useRef<FlatList<any>>(null);
  // Live WS items can carry duplicate or missing ids (tool_use shares call ids,
  // text events have none) — a counter keeps FlatList keys unique.
  const liveSeq = useRef(0);
  const [pendingPermissions, setPendingPermissions] = useState<PermissionRequest[]>([]);
  const [hasMore, setHasMore] = useState(false);
  const [loadingOlder, setLoadingOlder] = useState(false);
  const [loadOlderError, setLoadOlderError] = useState(false);
  // Windowing mirrors the web: only the newest page is rendered until the user
  // asks for earlier messages; "Load all" fetches the whole transcript.
  const [visibleCount, setVisibleCount] = useState<number>(SESSION_MESSAGES_PAGE_SIZE);
  const [allMessagesLoaded, setAllMessagesLoaded] = useState(false);
  const [loadingAll, setLoadingAll] = useState(false);
  const [loadAllJustFinished, setLoadAllJustFinished] = useState(false);
  const [totalMessages, setTotalMessages] = useState(0);
  const [newMessagesCount, setNewMessagesCount] = useState(0);
  const [searchOpen, setSearchOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [activeMatchIndex, setActiveMatchIndex] = useState(0);
  const searchInputRef = useRef<TextInput>(null);
  // Raw history items fetched so far — pagination offset counts raw rows,
  // not rendered messages (tool_results fold into tool_use rows).
  const rawCountRef = useRef(0);
  // Scroll bookkeeping for anchor restoration + new-message counting.
  const scrollOffsetRef = useRef(0);
  const prevContentHeightRef = useRef(0);
  const prevMessagesLengthRef = useRef(0);
  const isUserInteractingRef = useRef(false);
  const autoLoadAllTriggeredRef = useRef(false);

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
      // Grouping collapses list rows, so map the message index to its row.
      const msgId = messages[target]?.id;
      const row = msgId ? listData.findIndex((it) => (isToolGroupItem(it) ? it.messages.some((m) => m.id === msgId) : it.id === msgId)) : -1;
      if (row >= 0) {
        try {
          listRef.current?.scrollToIndex({ index: row, animated: true, viewPosition: 0.4 });
        } catch {
          // list has no getItemLayout; scrollToIndex can throw on unrendered rows.
        }
      }
    }
  };

  // @-mention picker + slash-command menu derived state (web useMentions/useSlashCommands).
  const mentionMatches = mentionQuery !== null ? filterMentions(mentionItems, mentionQuery) : [];
  const commandQuery = useMemo(() => slashQueryAt(draft), [draft]);
  const filteredCommands = useMemo(
    () => (commandQuery !== null ? filterSlashCommands(slashCommands, commandQuery) : []),
    [slashCommands, commandQuery],
  );
  const frequentCommands = useMemo(
    () =>
      slashCommands
        .map((c) => ({ command: c, usage: commandHistory[c.name] ?? 0 }))
        .filter((e) => e.usage > 0)
        .sort((a, b) => b.usage - a.usage)
        .slice(0, 4)
        .map((e) => e.command),
    [slashCommands, commandHistory],
  );
  const commandGroups = useMemo(
    () => (commandQuery !== null ? groupCommands(filteredCommands, frequentCommands) : []),
    [commandQuery, filteredCommands, frequentCommands],
  );
  const flatCommandRows = useMemo(() => flattenCommandRows(commandGroups), [commandGroups]);
  const showCommandMenu = commandQuery !== null && slashCommands.length > 0;
  const mentionParts = useMemo(() => splitMentionParts(draft, mentionTokens), [draft, mentionTokens]);
  const submit = submitState({ hasText: draft.trim().length > 0, hasAttachments: pendingAttachments.length > 0, running });

  const onDraftChange = (text: string, cursor: number) => {
    setDraft(text);
    setCursorPos(cursor);
    const q = mentionQueryAt(text, cursor);
    if (q === null) {
      setMentionQuery(null);
      setMentionAt(-1);
      setMentionIndex(-1);
    } else {
      setMentionAt(text.slice(0, cursor).lastIndexOf('@'));
      setMentionQuery(q);
      setMentionIndex(-1);
    }
    setCommandIndex(-1);
  };

  const selectMentionItem = (item: MentionableItem) => {
    if (mentionAt < 0) return;
    const { text } = insertMention(draft, item, mentionAt, cursorPos);
    setDraft(text);
    setMentionTokens((prev) => (prev.includes(`@${item.value}`) ? prev : [...prev, `@${item.value}`]));
    setMentionQuery(null);
    setMentionAt(-1);
    setMentionIndex(-1);
    setTimeout(() => composerRef.current?.focus(), 30);
  };

  const onComposerKeyPress = (key: string) => {
    // Hardware-keyboard shortcuts first (Esc abort / Ctrl+Shift+F search).
    const shortcut = resolveChatShortcut({
      key,
      running,
      searchOpen,
      menuOpen: mentionMatches.length > 0 || showCommandMenu,
    });
    if (shortcut === 'abort') {
      if (sessionId) sendMessage({ type: 'chat.abort', sessionId });
      return;
    }
    if (shortcut === 'close-search') return closeSearch();
    if (shortcut === 'focus-search') return openSearch();
    // Interactive mentions first, then slash commands (web ChatComposer.tsx).
    if (mentionMatches.length > 0) {
      if (key === 'ArrowDown') return setMentionIndex((i) => stepIndex(i, mentionMatches.length, 1));
      if (key === 'ArrowUp') return setMentionIndex((i) => stepIndex(i, mentionMatches.length, -1));
      if (key === 'Enter' || key === 'Tab') return selectMentionItem(mentionMatches[mentionIndex >= 0 ? mentionIndex : 0]);
      if (key === 'Escape') {
        setMentionQuery(null);
        setMentionAt(-1);
        return;
      }
    }
    if (showCommandMenu && flatCommandRows.length > 0) {
      if (key === 'ArrowDown') return setCommandIndex((i) => stepIndex(i, flatCommandRows.length, 1));
      if (key === 'ArrowUp') return setCommandIndex((i) => stepIndex(i, flatCommandRows.length, -1));
      if (key === 'Enter') {
        const chosen = flatCommandRows[commandIndex >= 0 ? commandIndex : 0];
        void runCommand(chosen.command);
        return;
      }
      if (key === 'Escape') {
        setCommandIndex(-1);
        return;
      }
    }
    // ponytail: RN onKeyPress has no modifier info, so Ctrl+Enter can't be
    // distinguished from Enter. Honour the pref the only way RN allows —
    // when sendByCtrlEnter is off, Enter submits; when on, Enter newlines.
    if (key === 'Enter' && !preferences.sendByCtrlEnter && submit.action !== 'disabled') {
      void send();
    }
  };

  // Auto-read replies aloud (web composer AudioLines toggle equivalent).
  // Web arms per session (voiceAutoRead.armedSessions) and dedups by the last
  // spoken sequence per session so a replayed completion isn't read twice.
  const messagesRef = useRef<ChatMessage[]>([]);
  messagesRef.current = messages;
  const wasRunning = useRef(false);
  const lastSpokenSeqRef = useRef<Map<string, number>>(new Map());
  const completionSeqRef = useRef<Map<string, number>>(new Map());
  const lastAssistantText = useCallback(() => {
    const last = [...messagesRef.current].reverse().find((m) => m.role === 'assistant' && m.text.trim() && !m.isError);
    return last?.text.trim() ?? '';
  }, []);
  useEffect(() => {
    if (running && !wasRunning.current) {
      startedAtRef.current = Date.now();
      setRunStartedAt(startedAtRef.current);
    }
    if (wasRunning.current && !running && sessionId && isArmedIn(armedSessions, sessionId)) {
      const seq = (completionSeqRef.current.get(sessionId) ?? 0) + 1;
      completionSeqRef.current.set(sessionId, seq);
      if (shouldSpeakCompletion(lastSpokenSeqRef.current.get(sessionId), seq)) {
        lastSpokenSeqRef.current.set(sessionId, seq);
        const text = lastAssistantText();
        if (text) speakText(text);
      }
    }
    wasRunning.current = running;
  }, [running, sessionId, armedSessions, lastAssistantText]);

  // Keep the screen awake while a run is active + the user enabled preventSleep
  // (web `useKeepAwake`).
  useEffect(() => {
    if (!preferences.preventSleep || !running) return;
    void acquireKeepAwake();
    return () => {
      void releaseKeepAwake();
    };
  }, [preferences.preventSleep, running]);

  // Persisted composer prefs (web uses localStorage chat-auto-continue-tasks).
  useEffect(() => {
    AsyncStorage.getItem('chat-auto-continue-tasks').then((v) => {
      if (v === 'true') setAutoContinue(true);
    });
    AsyncStorage.getItem('voiceAutoRead.armedSessions')
      .then((raw) => setArmedSessions(parseArmedSessions(raw)))
      .catch(() => {});
  }, []);
  const toggleAutoContinue = () => {
    setAutoContinue((v) => {
      AsyncStorage.setItem('chat-auto-continue-tasks', String(!v)).catch(() => {});
      return !v;
    });
  };
  // Auto-read is armed per session (web `voiceAutoRead.armedSessions`).
  const toggleAutoRead = () => {
    if (!sessionId) return;
    const next = toggleArmedIn(armedSessions, sessionId, !isArmedIn(armedSessions, sessionId));
    setArmedSessions(next);
    AsyncStorage.setItem('voiceAutoRead.armedSessions', JSON.stringify(next)).catch(() => {});
    if (isArmedIn(armedSessions, sessionId)) stopSpeaking();
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

  // Draft-pane empty state: provider list + workspace list.
  useEffect(() => {
    let alive = true;
    api
      .get('/providers/capabilities')
      .then((r) => (r.ok ? r.json() : null))
      .then((d) => {
        if (!alive || !d) return;
        const list = d?.data?.providers ?? d?.providers ?? [];
        const names = Array.isArray(list)
          ? list.map((p: { provider?: string }) => p.provider).filter((p: string | undefined): p is string => Boolean(p))
          : [];
        if (names.length) setAvailableProviders(names);
      })
      .catch(() => {});
    api
      .projects()
      .then((r) => (r.ok ? r.json() : null))
      .then((payload) => {
        if (!alive || !payload) return;
        const list = Array.isArray(payload) ? payload : payload?.data?.projects ?? payload?.projects ?? [];
        setPickerProjects(
          (list as any[]).map((p) => ({
            projectId: String(p.id ?? p.projectId),
            displayName: p.displayName ?? p.name,
            name: p.name,
            path: p.path ?? p.fullPath,
            fullPath: p.fullPath ?? p.path,
          })),
        );
      })
      .catch(() => {});
    return () => {
      alive = false;
    };
  }, []);
  useEffect(() => {
    let alive = true;
    const keys = [
      sessionId ? `permissionMode-${sessionId}` : null,
      `permissionMode-last-${provider ?? 'claude'}`,
      `permissionMode-provider-${provider ?? 'claude'}`,
    ].filter((k): k is string => Boolean(k));
    Promise.all(keys.map((k) => AsyncStorage.getItem(k)))
      .then(([sessionMode, paneMode, providerMode]) => {
        if (!alive) return;
        const fallback = permissionModes.includes('default') ? 'default' : permissionModes[0] ?? 'default';
        setPermissionMode(resolveStoredPermissionMode(permissionModes, { sessionMode, paneMode, providerMode }, fallback));
      })
      .catch(() => {});
    return () => {
      alive = false;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sessionId, provider]);

  const selectPermissionMode = useCallback(
    (mode: string) => {
      setPermissionMode(mode);
      const scope = provider ?? 'claude';
      AsyncStorage.setItem(`permissionMode-last-${scope}`, mode).catch(() => {});
      if (sessionId) AsyncStorage.setItem(`permissionMode-${sessionId}`, mode).catch(() => {});
      // Push to the live runtime so a mid-run toggle takes effect immediately.
      if (sessionId) sendMessage({ type: 'chat.set-permission-mode', sessionId, permissionMode: mode });
    },
    [provider, sessionId, sendMessage],
  );

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
          tool.result = p.tools[0].result;
          tool.isError = Boolean(m.isError);
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
        provider: typeof m.provider === 'string' ? m.provider : undefined,
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
        const total = data?.data?.total ?? data?.total;
        if (typeof total === 'number') setTotalMessages(total);
        else setTotalMessages((t) => Math.max(t, raw.length));
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
    setLoadOlderError(false);
    // The fetch prepends older rows; keep the visible anchor stable.
    expectPrependRef.current = true;
    try {
      // offset counts raw items back from the newest end.
      const res = await api.unifiedSessionMessages(sessionId!, 'claude', { limit: 100, offset: rawCountRef.current } as never);
      if (res.ok) {
        const data = await res.json();
        const raw = messagesFromResponse(data);
        rawCountRef.current += raw.length;
        setMessages((prev) => [...parseRaw(raw), ...prev]);
        setHasMore(Boolean(data?.data?.hasMore ?? data?.hasMore));
      } else {
        setLoadOlderError(true);
      }
    } catch {
      setLoadOlderError(true);
    } finally {
      setLoadingOlder(false);
    }
  }, [loadingOlder, hasMore, sessionId, parseRaw]);

  const loadAll = useCallback(async () => {
    if (!sessionId || loadingAll || allMessagesLoaded) return;
    setLoadingAll(true);
    try {
      const res = await api.unifiedSessionMessages(sessionId, 'claude', { limit: null, offset: 0 } as never);
      if (res.ok) {
        const data = await res.json();
        const raw = messagesFromResponse(data);
        rawCountRef.current = raw.length;
        setMessages((prev) => {
          const parsed = parseRaw(raw);
          const pending = prev.filter(
            (m) => (m.id.startsWith('local-') || m.isError) && !parsed.some((p) => p.role === m.role && p.text === m.text),
          );
          return pending.length ? [...parsed, ...pending] : parsed;
        });
        setHasMore(false);
        setTotalMessages((t) => Math.max(t, raw.length));
        setVisibleCount(Number.POSITIVE_INFINITY);
        setAllMessagesLoaded(true);
        setLoadAllJustFinished(true);
      }
    } catch (err) {
      console.error('load all messages failed:', err);
    } finally {
      setLoadingAll(false);
    }
  }, [sessionId, loadingAll, allMessagesLoaded, parseRaw]);

  const prevSessionForWindow = useRef<string | undefined>(undefined);
  useEffect(() => {
    if (prevSessionForWindow.current === sessionId) return;
    prevSessionForWindow.current = sessionId;
    setVisibleCount(SESSION_MESSAGES_PAGE_SIZE);
    setAllMessagesLoaded(false);
    setLoadAllJustFinished(false);
    setNewMessagesCount(0);
    prevMessagesLengthRef.current = 0;
    autoLoadAllTriggeredRef.current = false;
  }, [sessionId]);

  // Clear the "all messages loaded" pill after a short beat (web 2500ms).
  useEffect(() => {
    if (!loadAllJustFinished) return;
    const t = setTimeout(() => setLoadAllJustFinished(false), 2500);
    return () => clearTimeout(t);
  }, [loadAllJustFinished]);

  useEffect(() => {
    load();
  }, [load]);

  // Deltas only flow after a per-session chat.subscribe. A reconnect replays
  // only the events missed since the recorded cursor (new run → seq restarts).
  const subscribeWithCursor = useCallback(
    (sid: string) => {
      const cursor = lastSeqRef.current.get(sid);
      sendMessage({ type: 'chat.subscribe', sessions: [{ sessionId: sid, runId: cursor?.runId ?? null, lastSeq: cursor?.seq ?? 0 }] });
    },
    [sendMessage],
  );

  useEffect(() => {
    if (!isConnected || !sessionId) return;
    subscribeWithCursor(sessionId);
    load();
  }, [isConnected, sessionId, subscribeWithCursor, load]);

  // Foreground resync + 10s watchdog while a turn is running (web ChatInterface).
  useActivityResync({ enabled: Boolean(isConnected), sessionId: sessionId ?? null, isProcessing: running, reconnect: subscribeWithCursor });

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
  const loadModels = useCallback(
    async (refresh = false) => {
      if (!provider) return;
      setModelsLoading(true);
      try {
        const res = await api.get(`/providers/${provider}/models${refresh ? '?refresh=true' : ''}`);
        if (!res.ok) return;
        const body = await res.json();
        const opts = body?.data?.models?.OPTIONS ?? body?.data?.models?.options ?? [];
        setModels(
          opts.map((m: any) => ({
            value: String(m.value),
            label: String(m.label ?? m.value),
            description: m.description ? String(m.description) : undefined,
            context: typeof m.context === 'number' ? m.context : typeof m.contextWindow === 'number' ? m.contextWindow : undefined,
            tier: m.tier === 'free' || m.tier === 'paid' ? m.tier : undefined,
            isCustom: Boolean(m.isCustom),
            effort: Array.isArray(m?.effort?.values) ? { values: m.effort.values.map((v: any) => ({ value: String(v.value), label: v.label ? String(v.label) : undefined })) } : undefined,
          })),
        );
      } catch {
        /* model endpoint optional */
      } finally {
        setModelsLoading(false);
      }
    },
    [provider],
  );

  useEffect(() => {
    if (!sessionId || !provider) return;
    let alive = true;
    void loadModels();
    api
      .get(`/providers/${provider}/sessions/${sessionId}/active-model`)
      .then((r) => (r.ok ? r.json() : null))
      .then((body) => {
        if (alive && body?.data?.model) setModel(String(body.data.model));
      })
      .catch(() => {});
    return () => {
      alive = false;
    };
  }, [sessionId, provider, loadModels]);

  // Provider accounts for the new-session account picker (web ComposerAccountMenu).
  useEffect(() => {
    if (!provider) return;
    let alive = true;
    api
      .get(`/provider-accounts?provider=${encodeURIComponent(provider)}`)
      .then((r) => (r.ok ? r.json() : null))
      .then((body) => {
        const list = body?.data?.accounts ?? body?.accounts ?? [];
        if (alive) setAccounts(Array.isArray(list) ? list : []);
      })
      .catch(() => {});
    return () => {
      alive = false;
    };
  }, [provider]);

  // Slash commands for the current project: built-in + provider skills + custom,
  // sorted by persisted usage so frequently-used commands surface first.
  useEffect(() => {
    if (!projectPath) return;
    let cancelled = false;
    const historyKey = `command_history_${projectId ?? projectPath}`;
    AsyncStorage.getItem(historyKey)
      .then((raw) => {
        const history = raw ? (JSON.parse(raw) as Record<string, number>) : {};
        if (!cancelled) setCommandHistory(history);
      })
      .catch(() => {});

    (async () => {
      try {
        const builtIn = await api.post('/commands/list', { projectPath }).then((r) => (r.ok ? r.json() : null));
        if (!builtIn) return;
        let skills: ComposerSlashCommand[] = [];
        if (provider) {
          const skillsRes = await api
            .get(`/providers/${encodeURIComponent(provider)}/skills?workspacePath=${encodeURIComponent(projectPath)}`)
            .then((r) => (r.ok ? r.json() : null))
            .catch(() => null);
          const rawSkills = (skillsRes?.data?.skills ?? []) as { name: string; description?: string; command: string; scope?: string; sourcePath?: string; pluginName?: string; pluginId?: string }[];
          const seen = new Set<string>();
          skills = rawSkills
            .filter((s) => {
              if (!s.command || seen.has(s.command)) return false;
              seen.add(s.command);
              return true;
            })
            .map((s) => ({ name: s.command, description: s.description, namespace: 'skill', path: s.sourcePath, type: 'skill' }));
        }
        const all: ComposerSlashCommand[] = [
          ...((builtIn.builtIn ?? builtIn.data?.builtIn ?? []) as ComposerSlashCommand[]).map((c) => ({ ...c, type: c.type ?? 'built-in' })),
          ...skills,
          ...((builtIn.custom ?? builtIn.data?.custom ?? []) as ComposerSlashCommand[]).map((c) => ({ ...c, type: 'custom' })),
        ];
        if (!cancelled) setSlashCommands(all);
      } catch {
        // Command listing is best-effort.
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [projectPath, projectId, provider]);

  // @-mention catalog: project files + recent sessions + open TaskMaster tasks.
  useEffect(() => {
    if (!projectId) return;
    let cancelled = false;
    const files = api
      .getMentionableFiles(projectId)
      .then((r) => (r.ok ? r.json() : null))
      .then((tree) => (Array.isArray(tree) ? flattenFileTree(tree as any) : []))
      .catch(() => [] as MentionableItem[]);
    const sessions = api
      .recentConversations({ limit: 40 })
      .then((r) => (r.ok ? r.json() : null))
      .then((payload) => {
        const list = Array.isArray(payload) ? payload : payload?.data?.conversations ?? payload?.conversations ?? [];
        return (list as any[])
          .filter((c) => c?.sessionId)
          .map((c) => {
            const title = c.sessionTitle || c.title || c.summary || c.name || `Session ${c.sessionId}`;
            return { id: String(c.sessionId), title, type: 'session' as const, value: title };
          });
      })
      .catch(() => [] as MentionableItem[]);
    const tasks = api
      .get(`/taskmaster/tasks/${encodeURIComponent(projectId)}`)
      .then((r) => (r.ok ? r.json() : null))
      .then((payload) => {
        const list = (Array.isArray(payload) ? payload : payload?.tasks ?? []) as { id: string | number; title?: string; status?: string }[];
        return list
          .filter((t) => isOpenTask(t.status))
          .map((t) => ({ id: String(t.id), title: t.title || `Task ${t.id}`, type: 'task' as const, value: t.title || `Task ${t.id}`, subtitle: t.status || undefined }));
      })
      .catch(() => [] as MentionableItem[]);
    Promise.all([files, sessions, tasks])
      .then(([f, s, t]) => {
        if (!cancelled) setMentionItems([...s, ...t, ...f]);
      })
      .catch(() => {});
    return () => {
      cancelled = true;
    };
  }, [projectId]);

  // In-pane session picker data: recent sessions mapped to the picker shape,
  // with the current project's sessions hoisted into their own group.
  useEffect(() => {
    if (!pickerOpen) return;
    let cancelled = false;
    api
      .recentConversations({ limit: 50 })
      .then((r) => (r.ok ? r.json() : null))
      .then((payload) => {
        if (cancelled) return;
        const list = Array.isArray(payload) ? payload : payload?.data?.conversations ?? payload?.conversations ?? [];
        const mapped: PickerSession[] = (list as any[])
          .filter((c) => c?.sessionId || c?.id)
          .map((c) => ({
            id: String(c.sessionId ?? c.id),
            summary: c.sessionTitle ?? c.summary ?? null,
            title: c.title ?? null,
            name: c.name ?? null,
            provider: c.provider ?? null,
            projectId: c.projectId ?? null,
            projectPath: c.projectPath ?? null,
            projectName: c.projectName ?? c.projectDisplayName ?? null,
            isCurrentProject: Boolean(projectId && (c.projectId === projectId || c.projectPath === projectPath)),
            lastActivity: c.lastActivity ?? c.updatedAt ?? null,
            lastViewedAt: c.lastViewedAt ?? null,
            accountId: c.accountId ?? null,
            messageCount: c.messageCount,
          }));
        setPickerSessions(mapped);
      })
      .catch(() => {});
    return () => {
      cancelled = true;
    };
  }, [pickerOpen, projectId, projectPath]);

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

  // Full token breakdown card (web CommandResultModal cost view).
  const openTokenUsage = () => {
    if (!sessionId) return;
    api
      .get(`/providers/sessions/${sessionId}/token-usage`)
      .then((r) => (r.ok ? r.json() : null))
      .then((d) => setCommandModal({ kind: 'cost', data: { ...(d?.data ?? {}), provider, model } }))
      .catch(() => setCommandModal({ kind: 'cost', data: { provider, model } }));
  };

  const exportChat = async (format: 'markdown' | 'html' | 'text' | 'pdf' = 'markdown') => {
    if (messages.length === 0) return;
    const title = route.params?.title as string | undefined;
    if (format === 'pdf') {
      try {
        const html = buildPrintHtml(messages, { sessionTitle: title, provider });
        const { uri } = await Print.printToFileAsync({ html });
        if (await Sharing.isAvailableAsync()) {
          await Sharing.shareAsync(uri, { mimeType: 'application/pdf', dialogTitle: buildPrintFilename(title), UTI: 'com.adobe.pdf' });
        } else {
          showToast('PDF saved');
        }
      } catch (err) {
        console.error('pdf export failed:', err);
        showToast('PDF export failed', 'error');
      }
      return;
    }
    if (format === 'markdown') {
      await Share.share({ message: buildMarkdownExport(messages, title), title: exportFilename(title, 'md') });
    } else if (format === 'html') {
      await Share.share({ message: buildHtmlExport(messages, title), title: exportFilename(title, 'html') });
    } else {
      const plain = messages.map((m) => `${m.role}: ${m.text}`).join('\n\n');
      await Share.share({ message: plain, title: exportFilename(title, 'txt') });
    }
  };

  const loadChangedFiles = useCallback(() => {
    if (!sessionId) return;
    setChangedLoading(true);
    setChangedError(false);
    api
      .sessionChangedFiles(sessionId)
      .then(async (r) => {
        if (!r.ok) {
          setChangedFiles([]);
          // 404 = unknown session → empty list per contract; anything else is real.
          if (r.status !== 404) setChangedError(true);
          return;
        }
        const d = await r.json();
        setChangedFiles(parseChangedFiles(d));
      })
      .catch(() => {
        setChangedFiles([]);
        setChangedError(true);
      })
      .finally(() => setChangedLoading(false));
  }, [sessionId]);

  const toggleReview = useCallback(() => {
    setReviewOpen((open) => {
      if (!open) {
        savedScrollTopRef.current = scrollOffsetRef.current;
        void loadChangedFiles();
      }
      return !open;
    });
  }, [loadChangedFiles]);

  // Restore the transcript offset after the review panel closes (the list
  // shrinks while it is open, so RN would otherwise keep a stale offset).
  useEffect(() => {
    if (reviewOpen) return;
    const saved = savedScrollTopRef.current;
    savedScrollTopRef.current = null;
    if (saved !== null) {
      requestAnimationFrame(() => listRef.current?.scrollToOffset({ offset: saved, animated: false }));
    }
  }, [reviewOpen]);

  // The file list belongs to one session's transcript — drop it on rebind.
  useEffect(() => {
    savedScrollTopRef.current = null;
    setReviewOpen(false);
  }, [sessionId]);

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
                  { label: 'Change session', onPress: () => setPickerOpen(true) },
                  { label: 'Change workspace', onPress: () => setWorkspaceDialogOpen(true) },
                  { label: 'Export as Markdown', onPress: () => void exportChat('markdown') },
                  { label: 'Export as HTML', onPress: () => void exportChat('html') },
                  { label: 'Export as PDF', onPress: () => void exportChat('pdf') },
                  { label: 'Export as text', onPress: () => void exportChat('text') },
                  { label: 'Review changed files', onPress: () => { setSheet(null); toggleReview(); } },
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
  }, [navigation, sessionId, colors, messages, searchOpen, searchQuery, toggleReview]);

  const pickImage = async () => {
    const res = await ImagePicker.launchImageLibraryAsync({ mediaTypes: ['images'], quality: 0.8 });
    if (res.canceled) return;
    setPendingAttachments((prev) => [
      ...prev,
      ...res.assets.map((a) => ({
        uri: a.uri,
        name: a.fileName ?? `image-${Date.now()}.jpg`,
        mimeType: a.mimeType ?? 'image/jpeg',
        size: a.fileSize,
      })),
    ]);
  };

  const pickDocument = async () => {
    const res = await DocumentPicker.getDocumentAsync({ type: '*/*', multiple: true, copyToCacheDirectory: true });
    if (res.canceled) return;
    setPendingAttachments((prev) => [
      ...prev,
      ...res.assets.map((a) => ({
        uri: a.uri,
        name: a.name,
        mimeType: a.mimeType ?? 'application/octet-stream',
        size: a.size,
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
        size: a.fileSize,
      })),
    ]);
  };

  // Mobile composer action sheet — mirrors MobileComposerActionSheet.tsx.
  const openAttachMenu = () => {
    const items: ActionSheetItem[] = [
      { label: 'Attach files', onPress: () => void pickDocument() },
      { label: 'Attach image', onPress: () => void pickImage() },
      { label: 'Take photo', onPress: () => void takePhoto() },
    ];
    if (slashCommands.length > 0) {
      items.push({ label: 'Slash commands', onPress: () => setDraft((d) => (d.startsWith('/') ? d : `/${d}`)) });
    }
    if (checkpointRef.current) {
      items.push({ label: 'Undo checkpoint', onPress: () => void undoAiRun() });
    }
    items.push({
      label: 'Token usage',
      onPress: () => {
        if (sessionId) {
          api
            .get(`/providers/sessions/${sessionId}/token-usage`)
            .then((r) => (r.ok ? r.json() : null))
            .then((d) => setCommandModal({ kind: 'cost', data: { ...(d?.data ?? {}), provider, model } }))
            .catch(() => {});
        }
      },
    });
    if (draft.trim().length > 0) {
      items.push({ label: 'Clear input', destructive: true, onPress: () => { setDraft(''); setMentionQuery(null); setMentionAt(-1); } });
    }
    setSheet({ title: 'Tools & actions', items });
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
        // Record replay progress for every sequenced frame so a reconnect can
        // ask the server to replay only what was missed.
        if (typeof event.seq === 'number') {
          lastSeqRef.current.set(sessionId, advanceCursor(lastSeqRef.current.get(sessionId), event.runId ?? null, event.seq));
        }
        // `queued-messages-updated` is handled by QueueBar; reconnect marker
        // uses `kind` (same field as server frames).
        if (event.kind === 'websocket_reconnected') {
          subscribeWithCursor(sessionId);
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
                : [...prev, { requestId, toolName: String(event.toolName ?? 'UnknownTool'), input: event.input, sessionId }],
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
                    ? { ...t, status: event.isError ? 'error' : 'done', result: p.tools[0].result, isError: Boolean(event.isError), detail: [t.detail, p.tools[0].detail].filter(Boolean).join('\n→ ') }
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

  // "Allow & remember" writes the Claude allow-rule to local storage, matching
  // web grantClaudeToolPermission (key `claude-settings`).
  const handleGrantToolPermission = useCallback((entry: string | null) => {
    if (!entry) return;
    AsyncStorage.getItem(CLAUDE_SETTINGS_KEY)
      .then((raw) => {
        const { settings } = grantClaudeToolPermission(parseClaudeSettings(raw), entry);
        return AsyncStorage.setItem(CLAUDE_SETTINGS_KEY, JSON.stringify(settings));
      })
      .catch(() => {});
  }, []);

  const { pinnedFiles, unpinFile } = usePinnedFiles(projectId);
  // Token estimate for the pinned bar — cached by path+length so typing or
  // re-rendering never refetches the same file (mirrors web ChatComposer).
  useEffect(() => {
    if (pinnedFiles.length === 0 || !projectId) {
      setPinnedTokenEstimate(0);
      return;
    }
    let cancelled = false;
    const cache = tokenCacheRef.current;
    Promise.all(
      pinnedFiles.map(async (path) => {
        try {
          const r = await api.readFile(projectId, path);
          if (!r.ok) return 0;
          const d = await r.json();
          const content = typeof d?.content === 'string' ? d.content : '';
          const key = `${path}:${content.length}`;
          const cached = cache.get(key);
          if (cached !== undefined) return cached;
          const estimate = estimateTokensFromContent(content);
          cache.set(key, estimate);
          return estimate;
        } catch {
          return 0;
        }
      }),
    ).then((totals) => {
      if (!cancelled) setPinnedTokenEstimate(totals.reduce((sum, v) => sum + v, 0));
    });
    return () => {
      cancelled = true;
    };
  }, [pinnedFiles, projectId]);
  const voiceInput = useVoiceInput(
    useCallback(
      (text: string) => setDraft((d) => (d ? `${d.replace(/\s+$/, '')} ${text}` : text)),
      [],
    ),
    getLanguage(),
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

  // Built-in/custom slash-command dispatch — shared by the send button path and
  // the command menu (web onExecuteCommand → handleBuiltInCommand).
  const runCommand = async (cmd: ComposerSlashCommand) => {
    const historyKey = `command_history_${projectId ?? projectPath}`;
    const next = { ...commandHistory, [cmd.name]: (commandHistory[cmd.name] ?? 0) + 1 };
    setCommandHistory(next);
    void AsyncStorage.setItem(historyKey, JSON.stringify(next)).catch(() => {});
    if (cmd.type === 'custom' || cmd.type === 'skill') {
      setDraft(`${cmd.name} `);
      setCommandIndex(-1);
      return;
    }
    try {
      const res = await api.post('/commands/execute', {
        commandName: cmd.name,
        commandPath: cmd.path,
        args: [],
        context: { projectPath, sessionId, provider, model },
      });
      const body = res.ok ? await res.json() : null;
      setDraft('');
      setCommandIndex(-1);
      const resolved = resolveCommandResult(body);
      if (resolved && 'modal' in resolved) {
        setCommandModal(resolved.modal);
      } else if (resolved && 'insertText' in resolved) {
        setDraft(resolved.insertText);
      } else if (resolved && 'action' in resolved && resolved.action === 'memory') {
        const path = body?.data?.path as string | undefined;
        if (path && projectId) navigation.navigate('Editor', { projectId, filePath: path });
      } else if (resolved && 'action' in resolved && resolved.action === 'config') {
        navigation.navigate('Main', { screen: 'Settings' });
      }
      setQueueKey((k) => k + 1);
    } catch (err) {
      console.error('command failed:', err);
    }
  };

  const send = async () => {
    const content = draft.trim();
    if (!content || sending) return;
    void Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    setSending(true);
    setDraft('');
    try {
      // Slash command dispatch — built-ins open a result modal, custom
      // commands resolve to content server-side (web onExecuteCommand).
      const slash = content.match(/^\/(\S+)\s*(.*)$/);
      const cmd = slash && slashCommands.find((c) => c.name === `/${slash[1]}` || c.name === slash[1]);
      if (cmd && cmd.type !== 'custom' && cmd.type !== 'skill') {
        await runCommand(cmd);
        return;
      }
      if (cmd && cmd.type === 'custom' && sessionId) {
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
        if (!isConnected) {
          // Offline draft: queue against a placeholder session so nothing is
          // lost; the reconnect flush promotes it to a real session (web
          // offline-session-* placeholder flow).
          const placeholderId = `offline-session-${Date.now()}`;
          setMessages([{ id: `local-${Date.now()}`, role: 'user', text: messageContent, tools: [], timestamp: Date.now() }]);
          enqueueOffline(placeholderId, messageContent, buildSendOptions(), []);
          void AsyncStorage.removeItem(draftKey).catch(() => {});
          return;
        }
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
        sendMessage({ type: 'chat.send', sessionId: newId, content: messageContent, options: buildSendOptions() });
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
        // the offline path uses the local queue.
        if (isConnected) {
          sendMessage({ type: 'chat.send', sessionId, content: messageContent, options });
        } else {
          enqueueOffline(sessionId!, messageContent, options, attachments);
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
      enqueueOffline(sessionId, last.text, options, []);
    }
    setQueueKey((k) => k + 1);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sessionId, sending, isConnected, permissionMode, model, effort, autoContinue]);

  // Persist a message locally for replay on reconnect (web chatStorage). The
  // id is client-generated; placeholder sessions are promoted at flush time.
  const enqueueOffline = useCallback(
    (targetSessionId: string, content: string, options: Record<string, unknown>, attachments: unknown[]) => {
      const entry: QueuedOfflineMessage = {
        id: `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`,
        sessionId: targetSessionId,
        content,
        options,
        attachments,
        createdAt: Date.now(),
      };
      persistOfflineQueue([...offlineQueueRef.current, entry]);
      showToast(
        offlineQueueRef.current.length + 1 === 1
          ? 'Message queued offline — sending when reconnected'
          : 'Messages queued offline — sending when reconnected',
      );
    },
    [persistOfflineQueue],
  );

  // Replay the local queue once the socket is back. Placeholder sessions from
  // offline draft sends are promoted to a real session first (web
  // flushOfflineMessages); claim/requeue keeps the entry in storage only while
  // its socket write runs so a reload cannot lose it.
  useEffect(() => {
    if (!isConnected || offlineQueueRef.current.length === 0) return;
    void (async () => {
      await flushOfflineMessages(offlineQueueRef.current, {
        send: (sid, m) => sendMessage({ type: 'chat.send', sessionId: sid, content: m.content, options: m.options }),
        createSession: async (m) => {
          try {
            const res = await api.post('/providers/sessions', {
              provider: provider ?? 'claude',
              projectPath,
              initialMessage: m.content,
            });
            if (!res.ok) return null;
            const body = await res.json();
            return body?.data?.sessionId ?? null;
          } catch {
            return null;
          }
        },
        onSessionPromoted: (realId) => {
          navigation.setParams({ sessionId: realId, newSession: undefined });
        },
        claim: (m) => {
          const current = offlineQueueRef.current;
          if (!current.some((e) => e.id === m.id)) return false;
          persistOfflineQueue(current.filter((e) => e.id !== m.id));
          return true;
        },
        requeue: (m) => {
          if (!offlineQueueRef.current.some((e) => e.id === m.id)) {
            persistOfflineQueue([...offlineQueueRef.current, m]);
          }
        },
      });
    })();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isConnected, provider, projectPath]);

  // Restore a queued message into the composer (web editQueuedMessage): the
  // text appends to the current draft rather than clobbering it. Uploaded
  // attachment descriptors cannot be turned back into local files, so only the
  // text is restored (ponytail: skip descriptor restore).
  const editQueuedMessage = useCallback(
    async (item: { id: string | number; content?: string; options?: { attachments?: unknown[] } | null }, isLocal: boolean) => {
      const content = item.content ?? '';
      setDraft((prev) => (prev.trim() ? `${prev}\n${content}` : content));
      if (isLocal) {
        persistOfflineQueue(offlineQueueRef.current.filter((e) => e.id !== String(item.id)));
      } else {
        try {
          await api.queue.remove(item.id);
        } catch {
          /* queue entry may already be gone */
        }
        setQueueKey((k) => k + 1);
      }
      setTimeout(() => composerRef.current?.focus(), 100);
    },
    [persistOfflineQueue],
  );

  const { speaking, speak, stop: stopSpeak } = useTts();

  // The window keeps the FlatList cheap: only the newest `visibleCount` messages
  // render until the user reveals earlier ones or loads all (web sessionMessagePagination).
  const windowedMessages = useMemo(
    () =>
      allMessagesLoaded || isSearchActive
        ? messages
        : sliceVisibleMessages(messages, visibleCount),
    [allMessagesLoaded, isSearchActive, messages, visibleCount],
  );
  // Consecutive >=3 same-tool calls collapse into one group row (web toolGrouping.ts).
  const listData = React.useMemo(() => groupConsecutiveTools(windowedMessages, true), [windowedMessages]);

  const canRevealLocal = !allMessagesLoaded && !isSearchActive && visibleCount < messages.length;
  const hasOlder = hasMore || canRevealLocal;
  const expectPrependRef = useRef(false);

  const loadEarlier = useCallback(() => {
    if (canRevealLocal) {
      // Reveal messages already fetched, then let the server paging take over.
      expectPrependRef.current = true;
      setVisibleCount((c) => nextVisibleCount(c));
      return;
    }
    void loadOlder();
  }, [canRevealLocal, loadOlder]);

  // New-message counter: only tail growth while the user is scrolled up counts.
  useEffect(() => {
    const prevLen = prevMessagesLengthRef.current;
    const len = messages.length;
    prevMessagesLengthRef.current = len;
    if (len <= prevLen || prevLen === 0) return;
    if (atBottom || loadingOlder || loadingAll) return;
    // Older-page prepends are not "new messages" — consume the flag once.
    if (expectPrependRef.current) {
      expectPrependRef.current = false;
      return;
    }
    setNewMessagesCount((c) => c + (len - prevLen));
  }, [messages, atBottom, loadingOlder, loadingAll]);

  useEffect(() => {
    if (atBottom && newMessagesCount !== 0) setNewMessagesCount(0);
  }, [atBottom, newMessagesCount]);

  // Tool-only transcripts auto-load the full history (web cap 1000) so the
  // user isn't stuck staring at a wall of collapsed tool groups.
  useEffect(() => {
    if (autoLoadAllTriggeredRef.current) return;
    if (
      shouldAutoLoadAll({
        items: listData as { _isGroup?: boolean }[],
        hasMore,
        allLoaded: allMessagesLoaded,
        loading: loadingAll,
        loadingOlder,
        total: totalMessages,
        isUserScrolledUp: !atBottom,
      })
    ) {
      autoLoadAllTriggeredRef.current = true;
      void loadAll();
    }
  }, [listData, hasMore, allMessagesLoaded, loadingAll, loadingOlder, totalMessages, atBottom, loadAll]);

  // Tool renderers can open a touched file in the native editor.
  const handleOpenFile = useCallback(
    (path: string) => {
      if (path && projectId) navigation.navigate('Editor', { projectId, filePath: path });
    },
    [navigation, projectId],
  );

  const renderMessage = ({ item }: { item: any; index: number }) => {
    if (isToolGroupItem(item)) {
      return (
        <ToolGroupBlock
          group={item}
          colors={colors}
          isDark={isDark}
          query={isSearchActive ? trimmedSearch : ''}
          onOpenFile={handleOpenFile}
        />
      );
    }
    const isUser = item.role === 'user';
    // listData collapses tool runs, so list index != message index; compare ids.
    const activeMessage = activeSearchMessageIndex != null ? messages[activeSearchMessageIndex] : undefined;
    const isActiveSearchMatch = isSearchActive && activeMessage?.id === item.id;
    const searchRing = isActiveSearchMatch
      ? { borderWidth: 2, borderColor: colors.primary, borderRadius: 12 }
      : null;
    // Grouping / footer context (web MessageComponent.tsx).
    const msgIndex = messages.findIndex((m) => m.id === item.id);
    const prevMsg = msgIndex > 0 ? messages[msgIndex - 1] : null;
    const grouped = isGroupedMessage({ role: item.role }, prevMsg);
    const isTaskNotification = parseTaskNotification(item.text);
    const interactive = item.role === 'assistant' && !item.isError ? parseInteractivePrompt(item.text) : null;
    const hasInteractive = !!interactive && interactive.options.length > 0;

    // Normalize/format assistant text the way the web renderer does.
    let displayText = item.text;
    if (!isUser && !item.isError && !isTaskNotification) {
      displayText = formatUsageLimitText(displayText);
      if (provider === 'codex') displayText = stripProposedPlanEnvelope(displayText);
      displayText = normalizeInlineCodeFences(displayText);
    }
    const pureJson = !isUser && !item.isError && !hasInteractive ? detectPureJson(displayText) : null;
    const latency = turnLatencySeconds({ role: item.role, timestamp: item.timestamp }, prevMsg);

    if (item.role === 'thinking') {
      return (
        <View style={[{ marginBottom: 8 }, searchRing]}>
          <ReasoningBlock
            text={item.text}
            colors={colors}
            title="Thinking"
            query={isSearchActive ? trimmedSearch : ''}
          />
        </View>
      );
    }
    if (isTaskNotification) {
      return (
        <View style={searchRing}>
          <TaskNotificationRow notification={isTaskNotification} timestamp={item.timestamp} colors={colors} />
        </View>
      );
    }
    const messageActions = () => {
      const text = item.text.trim();
      if (!text) return;
      const canSelectFormat = !isUser;
      const copyPayload = !canSelectFormat || copyFormat === 'text' ? convertMarkdownToPlainText(text) : text;
      setSheet({
        title: 'Message',
        items: [
          {
            label: `Copy (${copyFormat === 'markdown' && canSelectFormat ? 'MD' : 'TXT'})`,
            onPress: () => {
              void Clipboard.setStringAsync(copyPayload);
              showToast('Copied to clipboard');
            },
          },
          ...(canSelectFormat
            ? copyFormatOptions().map((opt) => ({
                label: `${opt.format === copyFormat ? '● ' : '○ '}${opt.label}`,
                onPress: () => setCopyFormat(opt.format),
              }))
            : []),
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
                      .then((res: any) => {
                        if (res && res.ok === false) throw new Error('add task failed');
                        showToast('Saved to TaskMaster');
                      })
                      .catch((err) => {
                        console.error('save as task failed:', err);
                        showToast('Failed to save task', 'error');
                      });
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
          // oc-chat user turn: full-width left accent border + panel bg (no bubble).
          alignSelf: 'stretch',
          maxWidth: '100%',
          backgroundColor: isUser ? ocChatColors.panel : 'transparent',
          borderLeftWidth: isUser ? 3 : 0,
          borderLeftColor: ocChatColors.accent,
          borderRadius: 0,
          paddingHorizontal: 12,
          paddingVertical: 8,
          marginBottom: 8,
        }, searchRing]}
      >
        {/* oc-chat hides assistant/tool/error headers — identity lives in the footer. */}
        {!grouped && isUser && !item.isStreaming && (
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6, marginBottom: 4, alignSelf: 'flex-start' }}>
            <MessageAvatar role={item.role} label="You" colors={colors} />
          </View>
        )}
        {item.tools.map((t: ToolCall) => (
          <ToolItem key={t.id} tool={t} colors={colors} isDark={isDark} query={isSearchActive ? trimmedSearch : ''} onOpenFile={handleOpenFile} />
        ))}
        {item.images?.map((img: { path?: string; name?: string; data?: string }, i: number) => {
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
            <MessageImage
              key={`${img.path ?? img.name ?? i}`}
              uri={uri}
              name={img.name ?? img.path}
              headers={img.data ? undefined : { Authorization: `Bearer ${getStoredAuthToken() ?? ''}` }}
              colors={colors}
            />
          );
        })}
        {item.files?.map((f: { path?: string; name?: string; size?: number }, i: number) => {
          const name = f.name ?? f.path ?? 'file';
          const url = f.path && projectId
            ? `${getServerUrlSync()}/api/file-tree/projects/${projectId}/files/content?path=${encodeURIComponent(f.path)}`
            : undefined;
          return (
            <MessageFileCard key={`${f.path ?? f.name ?? i}`} name={name} size={f.size} url={url} colors={colors} light={isUser} />
          );
        })}
        {displayText.trim().length > 0 &&
          (item.isError ? (
            <View>
              <HighlightText text={item.text} query={trimmedSearch} style={{ color: colors.destructive }} />
              <TouchableOpacity onPress={retryLast} disabled={sending} style={{ marginTop: 6, alignSelf: 'flex-start', paddingVertical: 4, paddingHorizontal: 12, borderRadius: 8, borderWidth: 1, borderColor: colors.destructive }}>
                <Text style={{ color: colors.destructive, fontSize: 13 }}>Retry</Text>
              </TouchableOpacity>
            </View>
          ) : isUser ? (
            <HighlightText text={item.text} query={trimmedSearch} style={{ color: ocChatColors.text, fontFamily: MONO_FONT, fontSize: CHAT_FONT_SIZE }} highlightColor="#fbbf24" highlightTextColor="#422006" />
          ) : hasInteractive && interactive ? (
            <InteractivePromptCard prompt={interactive} colors={colors} />
          ) : pureJson ? (
            <JsonCard formatted={pureJson.formatted} colors={colors} label="JSON" />
          ) : (
            <Markdown
              rules={markdownRules(colors, isDark, handleOpenFile) as any}
              style={{
                body: { color: colors.foreground, fontSize: CHAT_FONT_SIZE, lineHeight: 20, fontFamily: MONO_FONT },
                code_inline: { backgroundColor: colors.muted, color: colors.foreground, borderRadius: 4, fontFamily: MONO_FONT, fontSize: 12 },
                code_block: { backgroundColor: colors.card, color: colors.foreground, borderRadius: 4, padding: 10, borderWidth: 1, borderColor: '#3c3c3c', fontFamily: MONO_FONT, fontSize: 12 },
                fence: { backgroundColor: colors.card, color: colors.foreground, borderRadius: 4, padding: 10, borderWidth: 1, borderColor: '#3c3c3c', fontFamily: MONO_FONT, fontSize: 12 },
                link: { color: colors.primary },
                heading1: { color: colors.foreground, fontFamily: MONO_FONT },
                heading2: { color: colors.foreground, fontFamily: MONO_FONT },
                heading3: { color: colors.foreground, fontFamily: MONO_FONT },
                blockquote: { backgroundColor: colors.muted, borderLeftColor: colors.primary, paddingHorizontal: 10 },
                list_item: { color: colors.foreground },
              }}
            >
              {displayText}
            </Markdown>
          ))}
        {item.isStreaming && <ActivityIndicator size="small" color={colors.primary} style={{ marginTop: 4, alignSelf: 'flex-start' }} />}
        {(isUser || item.role === 'assistant') && !item.isStreaming && (
          <AssistantFooter
            providerLabel={isUser ? 'You' : (provider ?? 'agent')}
            latencySeconds={latency}
            timestamp={item.timestamp}
            colors={colors}
            align={isUser ? 'right' : 'left'}
          />
        )}
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
        <ContextBanner
          colors={colors}
          providerLabel={provider ?? 'agent'}
          model={model}
          projectPath={projectPath}
          usage={tokenUsage}
        />
        <ActivityBanner
          colors={colors}
          running={running || sending}
          startedAt={runStartedAt}
          canInterrupt
          onAbort={() => { if (sessionId) sendMessage({ type: 'chat.abort', sessionId }); }}
          projectId={projectId}
        />
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
        {reviewOpen ? (
          <View style={{ flex: 1, padding: 12 }}>
            <ReviewFilesPanel
              files={changedFiles}
              loading={changedLoading}
              error={changedError}
              colors={colors}
              onRefresh={loadChangedFiles}
              onOpenFile={handleOpenFile}
              onClose={() => setReviewOpen(false)}
            />
          </View>
        ) : (
        <>
        <FlatList
          ref={listRef}
          data={listData as any}
          keyExtractor={(it: any) => (isToolGroupItem(it) ? `grp-${it.messages[0]?.id}` : it.id)}
          renderItem={renderMessage}
          contentContainerStyle={{ padding: 12, paddingBottom: 8, flexGrow: 1 }}
          onContentSizeChange={(_w, h) => {
            if (atBottom) {
              listRef.current?.scrollToEnd({ animated: false });
            } else if (expectPrependRef.current) {
              // Keep the visible anchor stable when older rows are prepended.
              const target = computeAnchorOffset({
                prevOffset: scrollOffsetRef.current,
                prevContentHeight: prevContentHeightRef.current,
                nextContentHeight: h,
              });
              listRef.current?.scrollToOffset({ offset: target, animated: false });
            }
            prevContentHeightRef.current = h;
            expectPrependRef.current = false;
          }}
          onScrollBeginDrag={() => { isUserInteractingRef.current = true; }}
          onMomentumScrollEnd={() => { isUserInteractingRef.current = false; }}
          onScroll={(e) => {
            const { contentOffset, layoutMeasurement, contentSize } = e.nativeEvent;
            scrollOffsetRef.current = contentOffset.y;
            setAtBottom(isNearBottom({ scrollTop: contentOffset.y, contentHeight: contentSize.height, layoutHeight: layoutMeasurement.height }));
          }}
          scrollEventThrottle={16}
          ListHeaderComponent={
            <View>
              <OlderMessagesBanner
                colors={colors}
                loading={loadingOlder}
                error={loadOlderError}
                hasMore={hasOlder}
                allLoaded={allMessagesLoaded}
                shown={windowedMessages.length}
                total={totalMessages || messages.length}
                onRetry={() => void (canRevealLocal ? loadEarlier() : loadOlder())}
              />
              {hasOlder && !loadingOlder && !loadOlderError && (
                <TouchableOpacity
                  onPress={loadEarlier}
                  style={{ alignSelf: 'center', paddingVertical: 6, paddingHorizontal: 16, marginBottom: 8 }}
                >
                  <Text style={{ color: colors.primary, fontSize: 13 }}>Load earlier messages</Text>
                </TouchableOpacity>
              )}
              {!hasMore && !allMessagesLoaded && messages.length > windowedMessages.length && (
                <ShowingLastRow
                  colors={colors}
                  shown={windowedMessages.length}
                  total={messages.length}
                  canLoadEarlier={canRevealLocal}
                  onLoadEarlier={() => setVisibleCount((c) => nextVisibleCount(c))}
                  onLoadAll={() => void loadAll()}
                />
              )}
            </View>
          }
          ListEmptyComponent={
            <FadeSlideIn offset={6} style={{ marginTop: 48, alignItems: 'center' }}>
              {isSearchActive ? (
                <Text style={{ color: colors.mutedForeground, textAlign: 'center' }}>
                  No messages match your search.
                </Text>
              ) : newSession && !sessionId ? (
                <DraftPaneEmptyState
                  colors={colors}
                  providers={availableProviders}
                  provider={provider}
                  onSelectProvider={(p) => navigation.setParams({ provider: p } as never)}
                  models={models.map((m) => ({ value: m.value, label: m.label }))}
                  model={model}
                  onSelectModel={(m) => void pickModel(m)}
                  projects={pickerProjects}
                  selectedProjectId={projectId}
                  onSelectWorkspace={(project) =>
                    navigation.setParams({ projectId: project.projectId, projectPath: project.fullPath ?? project.path } as never)
                  }
                />
              ) : (
                <Text style={{ color: colors.mutedForeground, textAlign: 'center' }}>
                  No messages yet — send the first one
                </Text>
              )}
            </FadeSlideIn>
          }
        />
        <LoadAllOverlay
          colors={colors}
          allLoaded={loadAllJustFinished}
          loading={loadingAll}
          hasMore={hasMore && !allMessagesLoaded && !canRevealLocal}
          total={totalMessages}
          onLoadAll={() => void loadAll()}
        />
        {isSearchActive && searchIndex.count === 0 && messages.length > 0 && (
          <Text style={{ position: 'absolute', top: 8, alignSelf: 'center', color: colors.mutedForeground, fontSize: 12, backgroundColor: colors.card, paddingHorizontal: 10, paddingVertical: 4, borderRadius: 12, borderWidth: 1, borderColor: colors.border }}>
            No messages match your search.
          </Text>
        )}
        {!atBottom && (
          <ScrollToBottomButton
            colors={colors}
            count={newMessagesCount}
            onPress={() => {
              setNewMessagesCount(0);
              listRef.current?.scrollToEnd({ animated: true });
            }}
          />
        )}
        </>
        )}
        </View>
      )}
      <PermissionBanner
        requests={pendingPermissions}
        colors={colors}
        provider={provider}
        onDecision={handlePermissionDecision}
        onGrant={handleGrantToolPermission}
      />
      <QueueBar
        sessionId={sessionId}
        colors={colors}
        reloadKey={queueKey}
        offlineQueue={offlineQueue}
        onClearOffline={() => {
          persistOfflineQueue([]);
          clearToast();
        }}
        onEditQueued={(q) => { void editQueuedMessage(q, false); }}
      />
      {offlineQueue.length > 0 && (
        <View style={{ paddingHorizontal: 10, paddingBottom: 4 }}>
          {offlineQueue.map((q) => (
            <QueuedMessageCard
              key={q.id}
              message={{ id: q.id, content: q.content, attachmentCount: q.attachments?.length ?? 0, status: 'queued' }}
              colors={colors}
              onEdit={() => { void editQueuedMessage(q, true); }}
              onDelete={() => persistOfflineQueue(offlineQueueRef.current.filter((e) => e.id !== q.id))}
            />
          ))}
        </View>
      )}
      {toast && <Toast toast={toast} />}

      <MentionDropdown items={mentionMatches} selectedIndex={mentionIndex} colors={colors} onPick={selectMentionItem} />
      {showCommandMenu && (
        <CommandMenuList
          groups={commandGroups}
          flatRows={flatCommandRows}
          selectedIndex={commandIndex}
          colors={colors}
          onPick={(cmdIndex) => {
            const row = flatCommandRows.find((x) => x.commandIndex === cmdIndex);
            if (row) void runCommand(row.command);
          }}
        />
      )}
      <View style={{ flexDirection: 'row', gap: 8, paddingHorizontal: 10, paddingTop: 8, backgroundColor: colors.card, borderTopWidth: 1, borderTopColor: colors.border }}>
        {newSession && accounts.length > 0 && (
          <TouchableOpacity
            onPress={() => setAccountModal(true)}
            style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: colors.secondary, borderRadius: 12, paddingHorizontal: 10, paddingVertical: 4 }}
          >
            <UserCircle2 size={12} color={colors.secondaryForeground} />
            <Text style={{ color: colors.secondaryForeground, fontSize: 12, marginLeft: 3 }}>
              {accounts.find((a) => a.id === accountId)?.label ?? 'Auto'}
            </Text>
            <ChevronDown size={12} color={colors.secondaryForeground} />
          </TouchableOpacity>
        )}
        {models.length > 0 && (
          <TouchableOpacity
            onPress={() => setModelModal(true)}
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
          style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: isArmedIn(armedSessions, sessionId) ? colors.primary : colors.secondary, borderRadius: 12, paddingHorizontal: 10, paddingVertical: 4 }}
        >
          <AudioLines size={12} color={isArmedIn(armedSessions, sessionId) ? colors.primaryForeground : colors.secondaryForeground} />
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
          <TouchableOpacity onPress={openTokenUsage} style={{ flexDirection: 'row', alignItems: 'center', paddingHorizontal: 6 }}>
            <FileDiff size={12} color={colors.mutedForeground} />
            <Text style={{ color: colors.mutedForeground, fontSize: 11, marginLeft: 3 }}>
              {formatTokenCount(tokenUsage.used)}
            </Text>
          </TouchableOpacity>
        )}
        <QuotaBadge colors={colors} provider={provider} model={model} />
        <View style={{ flex: 1 }} />
        {running && (
          <TouchableOpacity
            onPress={() => sessionId && sendMessage({ type: 'chat.abort', sessionId })}
            style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: colors.destructive, borderRadius: 12, paddingHorizontal: 10, paddingVertical: 4 }}
          >
            <Square size={11} color="#fff" fill="#fff" />
            <Text style={{ color: '#fff', fontSize: 12, marginLeft: 4 }}>Stop</Text>
          </TouchableOpacity>
        )}
      </View>
      <PinnedFilesBar
        files={pinnedFiles}
        tokenEstimate={pinnedTokenEstimate}
        colors={colors}
        onUnpin={unpinFile}
        onFileOpen={handleOpenFile}
      />
      {pendingAttachments.length > 0 && (
        <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 6, paddingHorizontal: 10, paddingTop: 6, backgroundColor: colors.card }}>
          {pendingAttachments.map((a, i) => (
            <ComposerAttachmentChip
              key={`${a.uri}-${i}`}
              uri={a.uri}
              name={a.name}
              mimeType={a.mimeType}
              size={a.size}
              colors={colors}
              onExpand={setAttachmentPreview}
              onRemove={() => setPendingAttachments((prev) => prev.filter((_, j) => j !== i))}
            />
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
          disabled={!voiceInput.supported}
        >
          {voiceInput.supported ? (
            <Mic
              color={voiceInput.state === 'recording' ? '#ef4444' : voiceInput.state === 'processing' ? '#f59e0b' : colors.mutedForeground}
              size={18}
            />
          ) : null}
        </TouchableOpacity>
        <View style={{ flex: 1, justifyContent: 'center' }}>
          {/* `>` prompt marker (web `.oc-input-caret`). */}
          <Text style={{ position: 'absolute', left: 12, top: 10, color: ocChatColors.accent, fontWeight: '700', fontFamily: MONO_FONT, fontSize: CHAT_FONT_SIZE, zIndex: 1 }} pointerEvents="none">
            {'>'}
          </Text>
          {/* Overlay draws mention chips beneath the real input (web placeholder trick). */}
          {mentionTokens.length > 0 && (
            <MentionHighlightOverlay
              parts={mentionParts}
              style={{
                color: 'transparent',
                fontSize: CHAT_FONT_SIZE,
                lineHeight: 20,
                paddingLeft: 26,
                paddingRight: 12,
                paddingTop: 10,
                paddingBottom: 10,
              }}
            />
          )}
          <TextInput
            ref={composerRef}
            value={draft}
            onChangeText={(text) => onDraftChange(text, Math.min(cursorPos, text.length))}
            onSelectionChange={(e) => setCursorPos(e.nativeEvent.selection.end)}
            onKeyPress={(e) => onComposerKeyPress(e.nativeEvent.key)}
            placeholder={isConnected ? 'Message…' : 'Reconnecting…'}
            placeholderTextColor={colors.mutedForeground}
            multiline
            textAlignVertical="top"
            style={{
              backgroundColor: mentionTokens.length > 0 ? 'transparent' : colors.card,
              color: colors.foreground,
              borderColor: ocChatColors.border,
              borderWidth: 1,
              borderRadius: 4,
              fontFamily: MONO_FONT,
              fontSize: CHAT_FONT_SIZE,
              lineHeight: 20,
              paddingLeft: 26,
              paddingRight: 12,
              paddingTop: 10,
              paddingBottom: 10,
              maxHeight: 120,
            }}
          />
        </View>
        <TouchableOpacity
          onPress={() => {
            if (submit.action === 'stop') {
              if (sessionId) sendMessage({ type: 'chat.abort', sessionId });
            } else {
              void send();
            }
          }}
          disabled={submit.action === 'disabled' || sending}
          style={{ backgroundColor: submit.action === 'stop' ? colors.destructive : colors.primary, borderRadius: 10, padding: 12, opacity: submit.action === 'disabled' || sending ? 0.5 : 1 }}
        >
          {submit.action === 'stop' ? (
            <Square color="#fff" size={18} fill="#fff" />
          ) : submit.action === 'queue' ? (
            <ChevronDown color={colors.primaryForeground} size={18} />
          ) : (
            <Send color={colors.primaryForeground} size={18} />
          )}
        </TouchableOpacity>
      </View>
      <CommandResultModal
        payload={commandModal}
        colors={colors}
        onClose={() => setCommandModal(null)}
        onSelectModel={(m) => {
          setModel(m);
          AsyncStorage.setItem(`${provider ?? 'claude'}-model`, m).catch(() => {});
        }}
      />
      <Modal visible={attachmentPreview !== null} transparent animationType="fade" onRequestClose={() => setAttachmentPreview(null)}>
        <TouchableOpacity style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.9)', alignItems: 'center', justifyContent: 'center' }} activeOpacity={1} onPress={() => setAttachmentPreview(null)}>
          {attachmentPreview && (
            <Image source={{ uri: attachmentPreview }} style={{ width: '90%', height: '70%', resizeMode: 'contain' } as any} />
          )}
        </TouchableOpacity>
      </Modal>
      <ActionSheet visible={sheet !== null} title={sheet?.title} items={sheet?.items ?? []} onClose={() => setSheet(null)} />
      <ModelMenuModal
        visible={modelModal}
        onClose={() => setModelModal(false)}
        colors={colors}
        isDark={isDark}
        provider={provider}
        models={models}
        model={model}
        effort={effort}
        effortOptions={models.find((m) => m.value === model)?.effort?.values ?? []}
        onSelectModel={(v) => void pickModel(v)}
        onSelectEffort={setEffort}
        onRefreshModels={() => void loadModels(true)}
        modelsLoading={modelsLoading}
      />
      <PermissionMenuModal
        visible={permModal}
        onClose={() => setPermModal(false)}
        colors={colors}
        isDark={isDark}
        permissionMode={permissionMode}
        permissionModes={permissionModes}
        onSelect={selectPermissionMode}
        providerLabel={provider ?? 'Claude'}
        autoContinue={autoContinue}
        onToggleAutoContinue={toggleAutoContinue}
      />
      <AccountMenuModal
        visible={accountModal}
        onClose={() => setAccountModal(false)}
        colors={colors}
        accounts={accounts}
        accountId={accountId}
        onSelect={setAccountId}
      />
      <SessionPickerSheet
        visible={pickerOpen}
        colors={colors}
        sessions={pickerSessions}
        currentSessionId={sessionId}
        processingSessionIds={running && sessionId ? new Set([sessionId]) : undefined}
        onSelect={(s) => {
          setPickerOpen(false);
          navigation.setParams({ sessionId: s.id, newSession: undefined, title: s.summary ?? s.title ?? undefined, provider: s.provider ?? undefined });
        }}
        onNewChat={() => {
          setPickerOpen(false);
          navigation.setParams({ sessionId: undefined, newSession: true } as never);
        }}
        onClose={() => setPickerOpen(false)}
      />
      <SessionWorkspaceDialog
        visible={workspaceDialogOpen}
        colors={colors}
        currentPath={projectPath}
        onClose={() => setWorkspaceDialogOpen(false)}
        onSubmit={async (path) => {
          if (!sessionId) return { ok: false, error: 'No session' };
          try {
            const res = await api.changeSessionWorkspace(sessionId, path);
            if (res.ok) return { ok: true };
            const body = await res.json().catch(() => null);
            return { ok: false, error: body?.error?.message ?? body?.error ?? 'Failed to change workspace' };
          } catch {
            return { ok: false, error: 'Failed to change workspace' };
          }
        }}
      />
    </Reanimated.View>
  );
}
