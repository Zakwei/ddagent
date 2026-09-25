// Pure-logic self-check for the mobile app — runs under plain Node (type
// stripping), no emulator needed: `node tests/self-check.mts`
import { readFileSync } from 'node:fs';
import { normalizeServerUrl, wsBaseFor } from '../src/lib/server-url.ts';
import { parseItem, extractRole, messagesFromResponse } from '../src/lib/chat-messages.ts';
import { matchesModelSearch, permissionModesFor, speechText, exportFilename, formatExportTimestamp, convertMarkdownToPlainText, copyFormatOptions, copyFormatTag } from '../src/lib/chat-extras.ts';
import { buildPrintHtml, buildPrintFilename } from '../src/lib/chat-print.ts';
import { parseChangedFiles, splitReviewPath, formatTokenEstimate, estimateTokensFromContent } from '../src/lib/review-files.ts';
import { getSearchableText, messageMatches, buildSearchIndex, stepMatch, splitHighlight, nearestMatchIndex } from '../src/lib/chat-search.ts';
import { createEmptyClaudeSettings, parseClaudeSettings, buildClaudeToolPermissionEntry, extractAffectedFilePaths, isPlanToolRequest, matchingRememberRequestIds, grantClaudeToolPermission, resolveStoredPermissionMode } from '../src/lib/chat-permissions.ts';
import { deriveToolStatus, resolveToolName, getToolDisplay, shouldHideToolResult, calculateDiff, diffContentFor, extractFilePaths, parseTaskListContent, groupConsecutiveTools, isToolGroupItem } from '../src/lib/tool-render.ts';
import { normalizeInlineCodeFences, stripProposedPlanEnvelope, formatUsageLimitText, parseTaskNotification, parseInteractivePrompt, detectPureJson, fileRefFromLink, looksLikeFilePath, stripLineSuffix, formatMessageTime, turnLatencySeconds, formatTurnLatency, isGroupedMessage, formatFileSize } from '../src/lib/chat-format.ts';
import { tokenizeCode, languageLabel, normalizeLanguage, syntaxStyleFor } from '../src/lib/highlight.ts';
import { flattenFileTree, filterMentions, mentionQueryAt, insertMention, splitMentionParts, activeMentionTokens, filterSlashCommands, slashQueryAt, groupCommands, stepIndex, flattenCommandRows, resolveCommandResult, attachmentKind, attachmentKindLabel, submitState, shouldSubmitOnEnter, isOpenTask } from '../src/lib/composer.ts';
import { getModelTier, isFreeModel, formatContextWindow, modelSubtitle, filterModelsByTier, loadFavoritesFrom, toggleFavoriteIn, mergeFavorites, resolveEffortOptions, sectionForModel, isModelAvailableIn, isProviderAvailableIn, getPermissionAppearance, isAntigravityModel } from '../src/lib/model-menu.ts';
import { formatTokenCount, tokenBreakdown, activityLabel, formatElapsed, quotaTone, windowMatchesModel, quotaBadgeFor, advanceCursor } from '../src/lib/usage.ts';
import { offlineQueueKey, isPlaceholderSession, parseOfflineQueue, serializeOfflineQueue, purgeSession, flushOfflineMessages } from '../src/lib/offline-queue.ts';
import { ocChatColors, ocChatTheme, CHAT_FONT_SIZE, MONO_FONT } from '../src/lib/oc-theme.ts';
import { resolveChatShortcut } from '../src/lib/chat-shortcuts.ts';
import { parseBoolean, parseUiPreferences, serializeUiPreferences, UI_PREFERENCES_DEFAULTS, UI_PREFERENCES_STORAGE_KEY } from '../src/lib/ui-preferences.ts';
import { parseCodeEditorSettings, serializeCodeEditorSettings, sortProjectList, CODE_EDITOR_FONT_SIZES, DEFAULT_CODE_EDITOR_SETTINGS } from '../src/lib/appearance-settings.ts';
import { formatScheduleTime, scheduleMetaLine, truncateSchedulePrompt, DEFAULT_CRON, SCHEDULE_PROVIDERS } from '../src/lib/schedules.ts';
import { parseEndpoints, isChannelEnabled, toggleChannelIn, parseTelegramChats } from '../src/lib/notifications.ts';
import {
  SESSION_MESSAGES_PAGE_SIZE,
  isNearBottom,
  shouldPinOnContentGrowth,
  computeAnchorOffset,
  nextVisibleCount,
  formatNewMessageBadge,
  sliceVisibleMessages,
  shouldAutoLoadAll,
} from '../src/lib/scroll.ts';
import {
  formatPickerAge,
  filterPickerSessions,
  getPickerSessionTitle,
  groupPickerSessions,
  isPickerSessionUnread,
  getAvailableSplitSessions,
  groupArchivedPickerSessions,
  parsePinnedSessions,
  togglePinnedIn,
  sortSessionsWithPinned,
  resolveDraftKey,
  sessionDraftKey,
  projectDraftKey,
  legacyMobileDraftKey,
  parseArmedSessions,
  toggleArmedIn,
  isArmedIn,
  shouldSpeakCompletion,
} from '../src/lib/session-picker.ts';
import {
  PROVIDER_SETTINGS_KEYS,
  PROVIDER_SETTINGS_CHANGED_EVENT,
  COMMON_CLAUDE_TOOLS,
  COMMON_CURSOR_COMMANDS,
  FALLBACK_PERMISSION_MODES,
  parseClaudeSettings as parseProviderClaudeSettings,
  parseCursorSettings,
  serializeClaudeSettings,
  serializeCursorSettings,
  toCodexPermissionMode,
  toProviderPermissionMode,
  parseStoredPermissionMode,
  serializePermissionModeSetting,
  addUnique,
  removeValue,
} from '../src/lib/provider-settings.ts';
let failures = 0;
const eq = (name: string, got: unknown, want: unknown) => {
  const ok = JSON.stringify(got) === JSON.stringify(want);
  if (!ok) failures++;
  console.log(`${ok ? 'PASS' : 'FAIL'} ${name}${ok ? '' : ` — got ${JSON.stringify(got)}`}`);
};
const ok = (name: string, cond: boolean) => eq(name, cond, true);

// --- server-url ---
eq('normalize adds https', normalizeServerUrl('example.com'), 'https://example.com');
eq('normalize keeps http', normalizeServerUrl('http://10.0.2.2:10087'), 'http://10.0.2.2:10087');
eq('normalize strips trailing /', normalizeServerUrl('https://host:8444/'), 'https://host:8444');
eq('normalize strips multiple /', normalizeServerUrl('https://host///'), 'https://host');
eq('normalize trims spaces', normalizeServerUrl('  host:8444  '), 'https://host:8444');
eq('normalize empty', normalizeServerUrl('   '), '');
eq('ws http→ws', wsBaseFor('http://10.0.2.2:10087'), 'ws://10.0.2.2:10087');
eq('ws https→wss', wsBaseFor('https://h.tail.ts.net:8444'), 'wss://h.tail.ts.net:8444');

// --- chat-extras (model search / permission modes / export) ---
eq('model search tokens', matchesModelSearch('Anthropic Claude Haiku 4.5', 'claude 4.5'), true);
eq('model search miss', matchesModelSearch('Anthropic Claude Haiku 4.5', 'chatgpt'), false);
eq('model search empty', matchesModelSearch('x', '  '), true);
eq('perm fallback claude', permissionModesFor('claude').includes('auto'), true);
eq('perm fallback codex', permissionModesFor('codex'), ['default', 'acceptEdits', 'bypassPermissions']);
eq('perm unknown provider', permissionModesFor('nope'), permissionModesFor('claude'));
eq('perm capabilities win', permissionModesFor('claude', { claude: ['only'] }), ['only']);
eq('speech strips code', speechText('a ```code``` b'), 'a b');
eq('speech neutralizes tags', speechText('<b>hi</b>'), 'hi');
eq('export filename ext', exportFilename('My Chat!', 'md').endsWith('.md'), true);
eq('export filename date', /-\d{4}-\d{2}-\d{2}\.md$/.test(exportFilename('x', 'md')), true);
eq('export filename fallback', exportFilename(undefined, 'txt').startsWith('chat-'), true);
eq('export timestamp format', /^[A-Z][a-z]{2} \d{1,2}, \d{4}, \d{2}:\d{2}:\d{2}$/.test(formatExportTimestamp(new Date(2026, 0, 5, 9, 3, 7))), true);
eq('export timestamp invalid', formatExportTimestamp('not-a-date'), '');
eq('md→text strips fences', convertMarkdownToPlainText('```js\nconst a=1;\n```'), 'const a=1;');
eq('md→text strips headings', convertMarkdownToPlainText('## Head\n\nplain'), 'Head\n\nplain');
eq('md→text strips bold', convertMarkdownToPlainText('**bold** and _ital_'), 'bold and ital');
eq('md→text link text', convertMarkdownToPlainText('see [docs](https://x.y)'), 'see docs');
eq('copy format options', copyFormatOptions().map((o) => o.format), ['markdown', 'text']);
eq('copy tag md', copyFormatTag('markdown'), 'MD');
eq('copy tag text', copyFormatTag('text'), 'TXT');
ok('print html is doctype', buildPrintHtml([{ id: '1', role: 'user', text: 'hi', tools: [] }]).startsWith('<!DOCTYPE html>'));
ok('print html escapes', buildPrintHtml([{ id: '1', role: 'assistant', text: '<script>', tools: [] }], { sessionTitle: 'T' }).includes('&lt;script&gt;'));
ok('print html provider meta', buildPrintHtml([{ id: '1', role: 'assistant', text: 'x', tools: [], provider: 'claude' }], { provider: 'claude' }).includes('from Claude'));
ok('print html includes timestamp', buildPrintHtml([{ id: '1', role: 'user', text: 'yo', tools: [], timestamp: 1700000000000 }]).includes('<p class="time">'));
ok('print filename ext', buildPrintFilename('My Chat!').endsWith('.pdf'));
ok('print filename fallback', buildPrintFilename(undefined).startsWith('chat-'));

// --- chat-messages: real {kind} schema ---
eq('kind=text user', parseItem({ kind: 'text', role: 'user', content: 'hi' }), {
  role: 'user', text: 'hi', tools: [], skip: false,
});
eq('kind=text assistant', parseItem({ kind: 'text', role: 'assistant', content: 'yo' }).role, 'assistant');
ok('kind=thinking', parseItem({ kind: 'thinking', content: 'hmm' }).role === 'thinking');
const tu = parseItem({ kind: 'tool_use', toolId: 'call_1', toolName: 'bash', toolInput: { command: 'ls' } });
eq('tool_use name', tu.tools[0].name, 'bash');
eq('tool_use detail', tu.tools[0].detail, '{"command":"ls"}');
eq('tool_use id', tu.tools[0].id, 'call_1');
const tr = parseItem({ kind: 'tool_result', toolId: 'call_1', content: 'out', isError: false });
eq('tool_result status', tr.tools[0].status, 'done');
ok('status skipped', parseItem({ kind: 'status', text: 'token_budget' }).skip);
ok('stream_end skipped', parseItem({ kind: 'stream_end' }).skip);

// --- legacy nested shape fallback ---
eq('legacy string content', parseItem({ role: 'assistant', content: 'hello' }).text, 'hello');
eq('legacy parts tools', parseItem({ content: [{ type: 'tool_use', id: 't', name: 'x' }] }).tools[0].name, 'x');
eq('role nested', extractRole({ message: { role: 'assistant' } }), 'assistant');

// --- envelope unwrap ---
eq('envelope {data:{messages}}', messagesFromResponse({ success: true, data: { messages: [1, 2] } }).length, 2);
eq('envelope {messages}', messagesFromResponse({ messages: [1] }).length, 1);
eq('bare array', messagesFromResponse([1, 2, 3]).length, 3);
eq('garbage', messagesFromResponse({}), []);

// --- chat-search (T1 transcript search) ---
eq('searchable joins text+tools', getSearchableText({ text: 'hello', tools: [{ name: 'Bash' }] }), 'hello Bash');
eq('match case-insensitive', messageMatches({ text: 'Hello World' }, 'world'), true);
eq('match empty query', messageMatches({ text: 'x' }, ''), true);
eq('match miss', messageMatches({ text: 'abc' }, 'zzz'), false);
const idx = buildSearchIndex([{ text: 'alpha' }, { text: 'beta' }, { text: 'Alpha again' }], 'alpha');
eq('index count', idx.count, 2);
eq('index matched positions', idx.matchedIndices, [0, 2]);
eq('index ordinals', idx.ordinalByIndex, { 0: 1, 2: 2 });
eq('index empty query', buildSearchIndex([{ text: 'x' }], '  ').count, 0);
eq('step wraps forward', stepMatch(1, 3, 1), 2);
eq('step wraps backward from 0', stepMatch(0, 3, -1), 2);
eq('step no matches', stepMatch(0, 0, 1), 0);
eq('highlight splits', splitHighlight('aXbXc', 'x').map((p) => p.isMatch), [false, true, false, true, false]);
eq('highlight escapes regex', splitHighlight('a.b', '.').filter((p) => p.isMatch).length, 1);
eq('nearest clamps', nearestMatchIndex([5, 9], 5), 9);
eq('nearest empty', nearestMatchIndex([], 0), null);

// --- chat-permissions (T2 permission banner) ---
eq('bash entry scopes command', buildClaudeToolPermissionEntry('Bash', { command: 'npm test' }), 'Bash(npm:*)');
eq('bash entry keeps git subcommand', buildClaudeToolPermissionEntry('Bash', { command: 'git push origin' }), 'Bash(git push:*)');
eq('non-bash entry is tool name', buildClaudeToolPermissionEntry('Edit', { file_path: '/a' }), 'Edit');
eq('entry null without tool', buildClaudeToolPermissionEntry(undefined, {}), null);
eq('parse settings defaults', parseClaudeSettings(null), createEmptyClaudeSettings());
eq('parse settings coerces lists', parseClaudeSettings(JSON.stringify({ allowedTools: ['Bash(ls:*)'] })).allowedTools, ['Bash(ls:*)']);
eq('affected paths from Edit input', extractAffectedFilePaths('Edit', { file_path: '/x/y.ts' }), ['/x/y.ts']);
eq('affected paths from apply_patch', extractAffectedFilePaths('apply_patch', { patch: '*** Update File: a.ts\n*** Add File: b.ts' }), ['a.ts', 'b.ts']);
eq('affected paths empty for Bash', extractAffectedFilePaths('Bash', { command: 'ls' }), []);
eq('plan tool detection', isPlanToolRequest('ExitPlanMode'), true);
eq('plan tool detection snake', isPlanToolRequest('exit_plan_mode'), true);
eq('plan tool detection plain', isPlanToolRequest('Edit'), false);
const rememberIds = matchingRememberRequestIds(
  [
    { requestId: 'r1', toolName: 'Bash', input: { command: 'npm test' } },
    { requestId: 'r2', toolName: 'Bash', input: { command: 'npm run build' } },
    { requestId: 'r3', toolName: 'Edit', input: { file_path: '/a' } },
  ],
  'Bash(npm:*)',
  'r1',
);
eq('remember matches shared bash entry', rememberIds, ['r1', 'r2']);
eq('remember falls back without entry', matchingRememberRequestIds([], null, 'r9'), ['r9']);
const granted = grantClaudeToolPermission(createEmptyClaudeSettings(), 'Edit');
eq('grant adds entry', granted.settings.allowedTools, ['Edit']);
eq('grant reports new', granted.alreadyAllowed, false);
eq('grant idempotent', grantClaudeToolPermission(granted.settings, 'Edit').alreadyAllowed, true);
eq(
  'mode resolution prefers session',
  resolveStoredPermissionMode(['default', 'plan'], { sessionMode: 'plan', paneMode: 'default', providerMode: 'default' }, 'default'),
  'plan',
);
eq(
  'mode resolution skips invalid',
  resolveStoredPermissionMode(['default'], { sessionMode: 'bogus', paneMode: 'nope', providerMode: null }, 'default'),
  'default',
);

// --- tool-render (status / diff / aliases / grouping) ---
eq('status: no result → running', deriveToolStatus(false, false, ''), 'running');
eq('status: ok → completed', deriveToolStatus(true, false, 'done'), 'completed');
eq('status: error', deriveToolStatus(true, true, 'boom'), 'error');
eq('status: claude denial → denied', deriveToolStatus(true, true, 'User denied tool use'), 'denied');
eq('alias bash → Bash', resolveToolName('bash'), 'Bash');
eq('alias apply_patch → ApplyPatch', resolveToolName('apply_patch'), 'ApplyPatch');
eq('alias strips functions. prefix from toolId', resolveToolName('edit', 'functions.edit'), 'Edit');
eq('alias strips :N suffix from toolId', resolveToolName('unknown', 'Edit:3'), 'Edit');
eq('display Edit is collapsible diff', getToolDisplay('Edit').kind, 'collapsible');
eq('display Read hides result', shouldHideToolResult('Read', false), true);
eq('display Bash hides result on success', shouldHideToolResult('bash', false), true);
eq('diff adds a line', calculateDiff('a\nb', 'a\nb\nc').some((l) => l.type === 'added' && l.content === 'c'), true);
eq('diff removes a line', calculateDiff('a\nb', 'a').some((l) => l.type === 'removed' && l.content === 'b'), true);
eq('diff identical → no lines', calculateDiff('x\ny', 'x\ny'), []);
eq('write diff badge New', diffContentFor('Write', { content: 'hi' }).badge, 'New');
eq('extract file paths from files[]', extractFilePaths({ files: [{ path: '/a/b.ts' }] }), ['/a/b.ts']);
eq('parse task list', parseTaskListContent('#15. [in_progress] Do it').map((t) => [t.id, t.status]), [['15', 'in_progress']]);

const grouped = groupConsecutiveTools([
  { id: 'a', role: 'assistant', text: '', tools: [{ id: 't1', name: 'bash' }] },
  { id: 'b', role: 'assistant', text: '', tools: [{ id: 't2', name: 'bash' }] },
  { id: 'c', role: 'assistant', text: '', tools: [{ id: 't3', name: 'bash' }] },
] as any, true);
ok('grouping: 3 bash → one group', grouped.length === 1 && isToolGroupItem(grouped[0]));
ok('grouping: group holds 3 messages', isToolGroupItem(grouped[0]) && grouped[0].messages.length === 3);
const ungrouped = groupConsecutiveTools([
  { id: 'a', role: 'assistant', text: '', tools: [{ id: 't1', name: 'Edit' }] },
  { id: 'b', role: 'assistant', text: '', tools: [{ id: 't2', name: 'Edit' }] },
  { id: 'c', role: 'assistant', text: '', tools: [{ id: 't3', name: 'Edit' }] },
] as any, true);
ok('grouping: Edit never groups', ungrouped.length === 3 && !isToolGroupItem(ungrouped[0]));
const pair = groupConsecutiveTools([
  { id: 'a', role: 'assistant', text: '', tools: [{ id: 't1', name: 'grep' }] },
  { id: 'b', role: 'assistant', text: '', tools: [{ id: 't2', name: 'grep' }] },
] as any, true);
ok('grouping: 2 < threshold stays flat', pair.length === 2);

// --- chat-format (T4 markdown + message rendering) ---
eq('inline code fence normalized', normalizeInlineCodeFences('a ```b``` c'), 'a `b` c');
eq('plan envelope stripped', stripProposedPlanEnvelope('<proposed_plan>\nHello\n</proposed_plan>'), 'Hello');
eq('plan envelope no-op', stripProposedPlanEnvelope('plain'), 'plain');
ok('usage limit rewritten', formatUsageLimitText('Claude AI usage limit reached|1700000000').includes('reset'));
ok('usage limit keeps text', formatUsageLimitText('normal text') === 'normal text');
const tn = parseTaskNotification('<task-notification>\n<status>completed</status>\n<summary>Done</summary>\n<result>All good</result>\n</task-notification>');
ok('task notification parsed', !!tn && tn.status === 'completed' && tn.summary === 'Done' && tn.result === 'All good');
eq('task notification non-match', parseTaskNotification('hello'), null);
const ip = parseInteractivePrompt('Pick one?\n❯ 1. Yes\n  2. No');
eq('interactive question', ip.questionLine, 'Pick one?');
eq('interactive options', ip.options.map((o) => [o.number, o.text, o.isSelected]), [['1', 'Yes', true], ['2', 'No', false]]);
eq('pure json detected', detectPureJson('{"a":1}')?.formatted, '{\n  "a": 1\n}');
eq('pure json rejects prose', detectPureJson('hello {'), null);
eq('file ref href', fileRefFromLink('src/a.ts', 'a.ts'), 'src/a.ts');
eq('file ref strips line suffix', fileRefFromLink('src/a.ts:12:3', 'a.ts'), 'src/a.ts');
eq('file ref external is null', fileRefFromLink('https://x.com/a.ts', 'a.ts'), null);
eq('looksLikeFilePath ext', looksLikeFilePath('a.ts'), true);
eq('looksLikeFilePath bare word', looksLikeFilePath('hello'), false);
eq('stripLineSuffix', stripLineSuffix('a.ts:10'), 'a.ts');
ok('formatMessageTime HH:MM:SS', /^\d{2}:\d{2}:\d{2}$/.test(formatMessageTime(Date.now()) ?? ''));
eq('turn latency plausibility', turnLatencySeconds({ role: 'assistant', timestamp: 2000 }, { role: 'user', timestamp: 1000 }), 1);
eq('turn latency rejects implausible', turnLatencySeconds({ role: 'assistant', timestamp: 999999 }, { role: 'user', timestamp: 1000 }), null);
eq('formatTurnLatency seconds', formatTurnLatency(1.23), '1.2s');
eq('formatTurnLatency minutes', formatTurnLatency(65), '1m 5s');
eq('grouping same role', isGroupedMessage({ role: 'assistant' }, { role: 'assistant' }), true);
eq('grouping different role', isGroupedMessage({ role: 'assistant' }, { role: 'user' }), false);
eq('formatFileSize B', formatFileSize(500), '500 B');
eq('formatFileSize KB', formatFileSize(2048), '2.0 KB');

// --- highlight (T4 Prism) ---
eq('languageLabel bash', languageLabel('bash'), 'Bash');
eq('languageLabel markdown', languageLabel('md'), 'Markdown');
eq('languageLabel text fallback', languageLabel('', ), 'Text');
eq('normalizeLanguage sh→bash', normalizeLanguage('sh'), 'bash');
eq('normalizeLanguage ts→typescript', normalizeLanguage('ts'), 'typescript');
ok('tokenize marks keyword', tokenizeCode('const x = 1', 'javascript').some((t) => t.types.includes('keyword')));
ok('tokenize marks string', tokenizeCode('const s = "hi"', 'javascript').some((t) => t.types.includes('string')));
ok('tokenize unknown → single span', tokenizeCode('plain', '').length === 1);
ok('syntaxStyleFor returns color', typeof syntaxStyleFor(['keyword'], true).color === 'string');

// --- composer: mentions, slash commands, command results, attachments, submit ---
{
  const tree = [
    { name: 'src', type: 'directory', children: [
      { name: 'a.ts', type: 'file', path: 'src/a.ts' },
      { name: 'b', type: 'directory', children: [{ name: 'c.ts', type: 'file' }] },
    ] },
    { name: 'README.md', type: 'file' },
  ];
  const flat = flattenFileTree(tree as any);
  eq('flattenFileTree paths', flat.map((f) => f.id), ['src/a.ts', 'src/b/c.ts', 'README.md']);
  eq('flattenFileTree subtitle uses path', flat[0].subtitle, 'src/a.ts');

  const items = [
    { id: 's1', title: 'Fix login', type: 'session' as const, value: 'Fix login' },
    { id: '0', title: 'Do thing', type: 'task' as const, value: 'Do thing', subtitle: 'pending' },
    { id: 'src/a.ts', title: 'a.ts', type: 'file' as const, value: 'src/a.ts', subtitle: 'src/a.ts' },
  ];
  eq('filterMentions empty → files first', filterMentions(items, '')[0].type, 'file');
  eq('filterMentions matches subtitle', filterMentions(items, 'pending').map((m) => m.id), ['0']);
  eq('filterMentions spaced miss closes', filterMentions(items, 'zzz zzz'), []);
  eq('isOpenTask pending', isOpenTask('pending'), true);
  eq('isOpenTask done', isOpenTask('done'), false);
  eq('isOpenTask undefined', isOpenTask(undefined), true);
  const many = Array.from({ length: 30 }, (_, i) => ({ id: `f${i}`, title: `f${i}`, type: 'file' as const, value: `f${i}` }));
  eq('filterMentions limit', filterMentions(many, 'f').length, 15);

  eq('mentionQueryAt finds', mentionQueryAt('hello @src/a', 12), 'src/a');
  eq('mentionQueryAt newline closes', mentionQueryAt('@a\nb', 4), null);
  eq('mentionQueryAt none', mentionQueryAt('hello', 5), null);
  const ins = insertMention('hi @ab tail', items[2], 3, 6);
  eq('insertMention text', ins.text, 'hi @src/a.ts  tail');
  eq('insertMention cursor', ins.cursor, 13);
  eq('activeMentionTokens filters', activeMentionTokens('x @src/a.ts y', ['@src/a.ts', '@nope']), ['@src/a.ts']);
  eq('splitMentionParts flags', splitMentionParts('x @src/a.ts y', ['@src/a.ts']).map((p) => p.mention), [false, true, false]);

  const cmds = [
    { name: '/help', description: 'Show help', type: 'built-in' },
    { name: '/model', description: 'Pick model', type: 'built-in' },
    { name: '/ship', description: 'Release', namespace: 'project', type: 'custom' },
  ];
  eq('filterSlashCommands prefix wins', filterSlashCommands(cmds, 'he').map((c) => c.name), ['/help']);
  eq('filterSlashCommands substring', filterSlashCommands(cmds, 'odel').map((c) => c.name), ['/model']);
  eq('filterSlashCommands description fallback', filterSlashCommands(cmds, 'Release').map((c) => c.name), ['/ship']);
  eq('slashQueryAt bare slash', slashQueryAt('/'), '');
  eq('slashQueryAt null when space', slashQueryAt('/a b'), null);
  const groups = groupCommands(cmds, [cmds[0]]);
  eq('groupCommands frequent first', groups[0].namespace, 'frequent');
  ok('groupCommands no dup of frequent', !groups.find((g) => g.namespace === 'builtin')?.rows.some((r) => r.command.name === '/help'));
  eq('flattenCommandRows count', flattenCommandRows(groups).length, 3);
  eq('stepIndex wraps forward', stepIndex(2, 3, 1), 0);
  eq('stepIndex wraps back', stepIndex(0, 3, -1), 2);
  eq('stepIndex from -1 forward', stepIndex(-1, 3, 1), 0);

  eq('resolveCommandResult modal', (resolveCommandResult({ type: 'builtin', action: 'cost', data: { a: 1 } }) as any).modal.kind, 'cost');
  eq('resolveCommandResult custom', (resolveCommandResult({ type: 'custom', content: 'X' }) as any).insertText, 'X');
  eq('resolveCommandResult memory', (resolveCommandResult({ action: 'memory' }) as any).action, 'memory');
  eq('resolveCommandResult null', resolveCommandResult({ action: 'nope' }), null);

  eq('attachmentKind image mime', attachmentKind('image/png'), 'image');
  eq('attachmentKind image ext', attachmentKind(undefined, 'a.PNG'), 'image');
  eq('attachmentKind file', attachmentKind('application/pdf', 'a.pdf'), 'file');
  eq('attachmentKindLabel ext', attachmentKindLabel('application/pdf', 'report.pdf'), 'PDF');
  eq('attachmentKindLabel mime', attachmentKindLabel('text/csv'), 'CSV');

  eq('submitState send', submitState({ hasText: true, running: false }).action, 'send');
  eq('submitState disabled', submitState({ hasText: false, running: false }).action, 'disabled');
  eq('submitState stop', submitState({ hasText: false, running: true }).action, 'stop');
  eq('submitState queue', submitState({ hasText: true, running: true, queuedCount: 1 }).action, 'queue');
  eq('shouldSubmitOnEnter plain sends', shouldSubmitOnEnter(false, false), true);
  eq('shouldSubmitOnEnter pref blocks plain', shouldSubmitOnEnter(true, false), false);
  eq('shouldSubmitOnEnter pref allows ctrl', shouldSubmitOnEnter(true, true), true);
}

// --- model menu + usage helpers ---
{
  eq('getModelTier antigravity', getModelTier({ value: 'x/antigravity-1', label: 'Antigravity' }), 'paid');
  eq('getModelTier explicit free', getModelTier({ value: 'm', label: 'M', tier: 'free' }), 'free');
  eq('getModelTier description free', getModelTier({ value: 'm', label: 'M', description: 'a free model' }), 'free');
  eq('getModelTier default paid', getModelTier({ value: 'm', label: 'M' }), 'paid');
  ok('isFreeModel', isFreeModel({ value: 'm', label: 'M', tier: 'free' }));

  eq('formatContextWindow 1M', formatContextWindow(1_000_000), '1M');
  eq('formatContextWindow 200k', formatContextWindow(200_000), '200k');
  eq('formatContextWindow null', formatContextWindow(0), null);
  eq('formatContextWindow undefined', formatContextWindow(undefined), null);

  eq('modelSubtitle free', modelSubtitle({ value: 'm', label: 'M', tier: 'free', context: 200_000 }), '200k context');
  eq('modelSubtitle paid', modelSubtitle({ value: 'm', label: 'M', description: 'Fast', context: 128_000 }), 'Fast · 128k context');

  eq('filterModelsByTier all', filterModelsByTier([{ value: 'a', label: 'A' }, { value: 'b', label: 'B', tier: 'free' }], 'all').length, 2);
  eq('filterModelsByTier free', filterModelsByTier([{ value: 'a', label: 'A' }, { value: 'b', label: 'B', tier: 'free' }], 'free').length, 1);

  eq('loadFavoritesFrom null', Object.keys(loadFavoritesFrom(null)).length, 0);
  eq('loadFavoritesFrom bad json', Object.keys(loadFavoritesFrom('{oops')).length, 0);
  const migrated = loadFavoritesFrom(JSON.stringify({ 'claude:ag': { provider: 'claude', value: 'ag', label: 'Antigravity' } }));
  eq('loadFavoritesFrom migrates antigravity', migrated['claude:ag'].tier, 'paid');

  const toggled = toggleFavoriteIn({}, 'claude', { value: 'sonnet', label: 'Sonnet' });
  ok('toggleFavoriteIn adds', Boolean(toggled['claude:sonnet']));
  eq('toggleFavoriteIn removes', Object.keys(toggleFavoriteIn(toggled, 'claude', { value: 'sonnet', label: 'Sonnet' })).length, 0);

  const merged = mergeFavorites([{ value: 'sonnet', label: 'Sonnet' }], { 'claude:opus': { provider: 'claude', value: 'opus', label: 'Opus' }, 'codex:x': { provider: 'codex', value: 'x', label: 'X' } }, 'claude');
  eq('mergeFavorites favorites', merged.favoritesList.map((f) => f.value), ['opus']);
  eq('mergeFavorites others', merged.others.map((f) => f.value), ['sonnet']);

  eq('resolveEffortOptions empty', resolveEffortOptions(null).length, 0);
  eq('resolveEffortOptions injects default', resolveEffortOptions({ values: [{ value: 'low' }] })[0].value, 'default');

  eq('sectionForModel gemini', sectionForModel('google/gemini-2'), 'gemini');
  eq('sectionForModel opencode', sectionForModel('opencode/big'), 'opencode');
  eq('sectionForModel none', sectionForModel('claude-sonnet'), null);
  ok('isModelAvailableIn no usage', isModelAvailableIn(null, 'claude', 'x', 'paid'));
  ok('isModelAvailableIn free', isModelAvailableIn({}, 'opencode', 'opencode/x', 'free'));
  ok('isModelAvailableIn gated false', !isModelAvailableIn({ opencode: { plan: 'free', error: 'no subscription' } }, 'opencode', 'opencode/x', 'paid'));
  ok('isProviderAvailableIn no usage', isProviderAvailableIn(null, 'opencode'));
  ok('isProviderAvailableIn byok section', isProviderAvailableIn({ opencode: { plan: 'free', error: 'x' } }, 'claude'));

  eq('getPermissionAppearance known', getPermissionAppearance('plan').iconKey, 'clipboard');
  eq('getPermissionAppearance unknown', getPermissionAppearance('zzz').iconKey, 'shield');
  ok('isAntigravityModel', isAntigravityModel({ value: 'a', label: 'Antigravity Pro' }));

  eq('formatTokenCount 0', formatTokenCount(0), '0');
  eq('formatTokenCount 1500', formatTokenCount(1500), '1.5K');
  eq('formatTokenCount 25000', formatTokenCount(25_000), '25K');
  eq('formatTokenCount 2M', formatTokenCount(2_000_000), '2.0M');
  const tb = tokenBreakdown({ used: 80, total: 100, inputTokens: 40, outputTokens: 20, cacheReadTokens: 10, cacheCreationTokens: 10 });
  eq('tokenBreakdown used', tb?.used, 80);
  eq('tokenBreakdown contextPercent', tb?.contextPercent, 80);
  eq('tokenBreakdown input subtracts cache', tb?.input, 20);
  eq('tokenBreakdown cache', tb?.cache, 20);
  eq('tokenBreakdown unsupported', tokenBreakdown({ unsupported: true, message: 'n/a' })?.contextPercent, null);
  eq('tokenBreakdown null', tokenBreakdown(null), null);

  eq('activityLabel explicit', activityLabel('Thinking hard...', 0), 'Thinking hard');
  eq('activityLabel rotating', activityLabel(null, 0), 'Thinking');
  eq('activityLabel rotates at 4s', activityLabel(null, 4), 'Processing');
  eq('formatElapsed seconds', formatElapsed(45), '45s');
  eq('formatElapsed minutes', formatElapsed(125), '2m 5s');
  eq('quotaTone ok', quotaTone(50, 75, 90), 'ok');
  eq('quotaTone warn', quotaTone(80, 75, 90), 'warn');
  eq('quotaTone critical', quotaTone(95, 75, 90), 'critical');

  ok('windowMatchesModel no model', windowMatchesModel('Gemini Models', null));
  eq('windowMatchesModel gemini', windowMatchesModel('Gemini Models', 'gemini-2'), true);
  eq('windowMatchesModel gemini miss', windowMatchesModel('Gemini Models', 'claude-x'), false);

  const badge = quotaBadgeFor(
    { opencode: { plan: 'Pro', windows: { 'OpenCode Go': { status: 'active', percent: 42, resetsAt: null } } } },
    'opencode', 'opencode/big', { watch: 75, danger: 90 },
  );
  eq('quotaBadgeFor percent', badge?.percent, 42);
  eq('quotaBadgeFor tone', badge?.tone, 'ok');
  eq('quotaBadgeFor no section', quotaBadgeFor({}, 'claude', 'x', { watch: 75, danger: 90 }), null);

  eq('advanceCursor new', advanceCursor(undefined, 'run1', 5).seq, 5);
  eq('advanceCursor advances', advanceCursor({ runId: 'run1', seq: 5 }, 'run1', 9).seq, 9);
  eq('advanceCursor ignores stale', advanceCursor({ runId: 'run1', seq: 9 }, 'run1', 3).seq, 9);
  eq('advanceCursor resets on new run', advanceCursor({ runId: 'run1', seq: 9 }, 'run2', 1).seq, 1);
}

// --- offline queue (T8) ---
{
  eq('offlineQueueKey', offlineQueueKey('p1'), 'ddagent_offline_queue_p1');
  ok('placeholder session', isPlaceholderSession('offline-session-123'));
  ok('real session not placeholder', !isPlaceholderSession('sess-abc'));

  eq('parse null', parseOfflineQueue(null), []);
  eq('parse bad json', parseOfflineQueue('{oops'), []);
  eq('parse non-array', parseOfflineQueue('{"a":1}'), []);
  const q = parseOfflineQueue(JSON.stringify([
    { id: 'a', sessionId: 'sess-1', content: 'hi', createdAt: 1 },
    { id: 'b', sessionId: 'sess-1', content: 42, createdAt: 2 },
  ]));
  eq('parse filters non-content', q.length, 1);
  eq('parse keeps content', q[0].content, 'hi');

  eq('serialize empty', serializeOfflineQueue([]), null);
  eq('serialize roundtrip', JSON.parse(serializeOfflineQueue([{ id: 'x', sessionId: 's', content: 'c', createdAt: 1 }])!).length, 1);

  const purged = purgeSession(
    [
      { id: 'a', sessionId: 's1', content: 'a', createdAt: 1 },
      { id: 'b', sessionId: 's2', content: 'b', createdAt: 2 },
    ],
    's1',
  );
  eq('purgeSession drops session', purged.length, 1);
  eq('purgeSession keeps other', purged[0].sessionId, 's2');
}

// --- flushOfflineMessages (placeholder promotion + claim/requeue) ---
async function testFlush() {
  const sent: { sessionId: string; content: string }[] = [];
  let created = 0;
  const result = await flushOfflineMessages(
    [
      { id: '1', sessionId: 'offline-session-x', content: 'first', createdAt: 1 },
      { id: '2', sessionId: 'offline-session-x', content: 'second', createdAt: 2 },
      { id: '3', sessionId: 'sess-real', content: 'third', createdAt: 3 },
    ],
    {
      createSession: async () => { created += 1; return 'sess-promoted'; },
      send: (sid, m) => { sent.push({ sessionId: sid, content: m.content }); return true; },
    },
  );
  eq('flush created one session for placeholder', created, 1);
  eq('flush sent all', result.sent.length, 3);
  eq('flush promoted both placeholders', sent[0].sessionId + ',' + sent[1].sessionId, 'sess-promoted,sess-promoted');
  eq('flush real session untouched', sent[2].sessionId, 'sess-real');
  eq('flush remaining empty', result.remaining.length, 0);

  // send failure keeps the entry for retry.
  const failed = await flushOfflineMessages(
    [{ id: '9', sessionId: 'sess-real', content: 'nope', createdAt: 9 }],
    { createSession: async () => null, send: () => false },
  );
  eq('flush failure requeued', failed.remaining.length, 1);
  eq('flush failure not sent', failed.sent.length, 0);

  // createSession failure leaves the placeholder queued.
  const noSession = await flushOfflineMessages(
    [{ id: '10', sessionId: 'offline-session-y', content: 'z', createdAt: 10 }],
    { createSession: async () => null, send: () => true },
  );
  eq('flush no-session stays queued', noSession.remaining.length, 1);

  // claim=false means a sibling took it — skipped without send.
  let sendCalls = 0;
  const claimed = await flushOfflineMessages(
    [{ id: '11', sessionId: 'sess-real', content: 'c', createdAt: 11 }],
    { createSession: async () => null, claim: () => false, send: () => { sendCalls += 1; return true; } },
  );
  eq('flush claim=false skips send', sendCalls, 0);
  eq('flush claim=false no sent', claimed.sent.length, 0);
}
ok('flushOfflineMessages runs', true);

await testFlush();

// --- scroll / pagination (T9) ---
eq('scroll page size', SESSION_MESSAGES_PAGE_SIZE, 40);
ok('nearBottom: maxScroll<=0', isNearBottom({ scrollTop: 0, contentHeight: 100, layoutHeight: 100 }));
ok('nearBottom: at bottom', isNearBottom({ scrollTop: 900, contentHeight: 1000, layoutHeight: 100 }));
ok('nearBottom: scrolled up is false', !isNearBottom({ scrollTop: 100, contentHeight: 2000, layoutHeight: 500 }));
ok('nearBottom: threshold honours 80', isNearBottom({ scrollTop: 1450, contentHeight: 2000, layoutHeight: 500 }));
ok('pin: growth + at bottom', shouldPinOnContentGrowth({ previousHeight: 100, nextHeight: 200, isUserScrolledUp: false }));
ok('pin: no growth', !shouldPinOnContentGrowth({ previousHeight: 200, nextHeight: 200, isUserScrolledUp: false }));
ok('pin: scrolled up blocks', !shouldPinOnContentGrowth({ previousHeight: 100, nextHeight: 200, isUserScrolledUp: true }));
ok('pin: interacting blocks', !shouldPinOnContentGrowth({ previousHeight: 100, nextHeight: 200, isUserScrolledUp: false, isUserInteracting: true }));
eq('anchor: growth added to offset', computeAnchorOffset({ prevOffset: 50, prevContentHeight: 100, nextContentHeight: 160 }), 110);
eq('anchor: shrink adds nothing', computeAnchorOffset({ prevOffset: 50, prevContentHeight: 200, nextContentHeight: 180 }), 50);
eq('nextVisibleCount +page', nextVisibleCount(40), 80);
eq('nextVisibleCount non-finite resets', nextVisibleCount(Number.POSITIVE_INFINITY), 40);
eq('badge caps at 99+', formatNewMessageBadge(150), '99+');
eq('badge single', formatNewMessageBadge(3), '3');
eq('badge zero', formatNewMessageBadge(0), '0');
{
  const msgs = Array.from({ length: 50 }, (_, i) => ({ id: `m${i}`, role: i % 2 ? 'assistant' : 'user', text: `t${i}` }));
  eq('slice: count >= length returns all', sliceVisibleMessages(msgs, 50).length, 50);
  eq('slice: window keeps requested count', sliceVisibleMessages(msgs, 10).length, 10);
  eq('slice: keeps newest', sliceVisibleMessages(msgs, 10).at(-1)?.id, 'm49');
  eq('slice: zero returns empty', sliceVisibleMessages(msgs, 0).length, 0);
}
{
  const toolOnly = [{ _isGroup: true }, { _isGroup: true }];
  ok('autoLoadAll tool-only triggers', shouldAutoLoadAll({ items: toolOnly, hasMore: true, allLoaded: false, loading: false, loadingOlder: false, total: 50, isUserScrolledUp: false }));
  ok('autoLoadAll mixed items no', !shouldAutoLoadAll({ items: [{ _isGroup: true }, {}], hasMore: true, allLoaded: false, loading: false, loadingOlder: false, total: 50, isUserScrolledUp: false }));
  ok('autoLoadAll scrolled up no', !shouldAutoLoadAll({ items: toolOnly, hasMore: true, allLoaded: false, loading: false, loadingOlder: false, total: 50, isUserScrolledUp: true }));
  ok('autoLoadAll over threshold no', !shouldAutoLoadAll({ items: toolOnly, hasMore: true, allLoaded: false, loading: false, loadingOlder: false, total: 5000, isUserScrolledUp: false }));
}

// --- session picker + pinned + drafts + armed set (T10) ---
{
  const s = (over: Record<string, unknown> = {}) => ({ id: 'abc12345', ...over });
  eq('picker title summary wins', getPickerSessionTitle(s({ summary: 'Sum', title: 'Tit' })), 'Sum');
  eq('picker title falls to title', getPickerSessionTitle(s({ summary: '  ', title: 'Tit' })), 'Tit');
  eq('picker title falls to id slice', getPickerSessionTitle(s({})), 'abc12345');
  const list = [s({ id: '1', summary: 'Alpha', projectName: 'p' }), s({ id: '2', title: 'Beta', projectName: 'q' })];
  eq('filter picker matches title', filterPickerSessions(list, 'alph').map((x) => x.id), ['1']);
  eq('filter picker matches project', filterPickerSessions(list, 'q').map((x) => x.id), ['2']);
  eq('filter picker empty returns all', filterPickerSessions(list, '  ').length, 2);
  eq('filter picker no match', filterPickerSessions(list, 'zzz').length, 0);
  const grouped = groupPickerSessions([
    s({ id: '1', isCurrentProject: true, projectName: 'cur' }),
    s({ id: '2', isCurrentProject: false, projectName: 'other' }),
  ]);
  eq('group current', grouped.currentProject.map((x) => x.id), ['1']);
  eq('group other', grouped.otherProjects.map((x) => x.id), ['2']);
  eq('group current name', grouped.currentProjectName, 'cur');
  const now = 1_700_000_000_000;
  eq('age just now', formatPickerAge(new Date(now - 10_000).toISOString(), now), '<1m');
  eq('age minutes', formatPickerAge(new Date(now - 5 * 60_000).toISOString(), now), '5m');
  eq('age hours', formatPickerAge(new Date(now - 3 * 3_600_000).toISOString(), now), '3hr');
  eq('age days', formatPickerAge(new Date(now - 2 * 86_400_000).toISOString(), now), '2d');
  eq('age null', formatPickerAge(null, now), '');
  ok('unread no lastViewed', isPickerSessionUnread(s({ lastActivity: '2026-01-01T00:00:00Z', lastViewedAt: null })));
  ok('unread viewed before', isPickerSessionUnread(s({ lastActivity: '2026-01-02T00:00:00Z', lastViewedAt: '2026-01-01T00:00:00Z' })));
  ok('read after view', !isPickerSessionUnread(s({ lastActivity: '2026-01-01T00:00:00Z', lastViewedAt: '2026-01-02T00:00:00Z' })));
  const split = getAvailableSplitSessions(
    [s({ id: 'a', isCurrentProject: false, lastActivity: '2026-01-02T00:00:00Z' }), s({ id: 'b', isCurrentProject: true, lastActivity: '2026-01-01T00:00:00Z' }), s({ id: 'c' })],
    'c',
  );
  eq('split excludes current, hoists project', split.map((x) => x.id), ['b', 'a']);
  const archived = groupArchivedPickerSessions(
    [
      { sessionId: 's1', projectId: 'p1', projectPath: '/p1', projectDisplayName: 'P1', sessionTitle: 'S1', lastActivity: '2026-01-02T00:00:00Z', isProjectArchived: true },
      { sessionId: 's2', projectId: 'p1', projectPath: '/p1', projectDisplayName: 'P1', sessionTitle: 'S2', lastActivity: '2026-01-01T00:00:00Z', isProjectArchived: true },
    ],
    [{ projectId: 'p2', displayName: 'P2', fullPath: '/p2' }],
  );
  eq('archived groups', archived.map((g) => g.key).sort(), ['p1', 'p2']);
  eq('archived p1 has 2', archived.find((g) => g.key === 'p1')?.sessions.length, 2);
  eq('archived p2 empty project', archived.find((g) => g.key === 'p2')?.sessions.length, 0);
  eq('pinned parse bad json', parsePinnedSessions('{'), []);
  eq('pinned parse filters', parsePinnedSessions('["a",1,"","b"]'), ['a', 'b']);
  eq('pinned toggle add', togglePinnedIn([], 'x'), { list: ['x'], pinned: true });
  eq('pinned toggle remove', togglePinnedIn(['x'], 'x'), { list: [], pinned: false });
  eq('sort pinned first', sortSessionsWithPinned([{ id: '1' }, { id: '2' }], (id) => id === '2').map((x) => x.id), ['2', '1']);
  eq('draft session key', resolveDraftKey({ sessionId: 's', projectId: 'p' }), sessionDraftKey('s'));
  eq('draft project key', resolveDraftKey({ projectId: 'p' }), projectDraftKey('p'));
  eq('draft none', resolveDraftKey({}), null);
  eq('project draft key value', projectDraftKey('p'), 'draft_input_p');
  eq('session draft key value', sessionDraftKey('s'), 'draft_input_session_s');
  eq('legacy key value', legacyMobileDraftKey('new-p'), 'chat-draft-new-p');
  eq('armed parse', parseArmedSessions('["s1"]'), ['s1']);
  eq('armed toggle on', toggleArmedIn([], 's1', true), ['s1']);
  eq('armed toggle off', toggleArmedIn(['s1'], 's1', false), []);
  eq('armed toggle idempotent', toggleArmedIn(['s1'], 's1', true), ['s1']);
  ok('isArmed', isArmedIn(['s1'], 's1'));
  ok('not armed', !isArmedIn(['s1'], 's2'));
  ok('seq speaks first', shouldSpeakCompletion(undefined, 1));
  ok('seq skips replay', !shouldSpeakCompletion(1, 1));
  ok('seq speaks newer', shouldSpeakCompletion(1, 2));
  ok('seq invalid', !shouldSpeakCompletion(0, undefined));
}

// --- review files + pinned files (T12) ---
{
  const parsed = parseChangedFiles({ data: { files: [{ path: 'src/a.ts', edits: 3, subagent: true }, { file: 'b.ts' }, 'c.ts', null, { nope: 1 }] } });
  eq('parseChangedFiles count', parsed.length, 3);
  eq('parseChangedFiles object', parsed[0], { path: 'src/a.ts', edits: 3, subagent: true });
  eq('parseChangedFiles file alias default edits', parsed[1], { path: 'b.ts', edits: 1, subagent: false });
  eq('parseChangedFiles bare string', parsed[2], { path: 'c.ts', edits: 1, subagent: false });
  eq('parseChangedFiles bad payload', parseChangedFiles(null).length, 0);
  eq('parseChangedFiles non-array', parseChangedFiles({ data: { files: 'x' } }).length, 0);
  eq('parseChangedFiles zero edits coerced', parseChangedFiles({ data: { files: [{ path: 'x', edits: 0 }] } })[0].edits, 1);

  eq('splitReviewPath nested', splitReviewPath('src/components/a.tsx'), { basename: 'a.tsx', dirname: 'src/components' });
  eq('splitReviewPath bare', splitReviewPath('a.ts'), { basename: 'a.ts', dirname: '' });
  eq('splitReviewPath backslashes', splitReviewPath('src\\a\\b.ts'), { basename: 'b.ts', dirname: 'src/a' });

  eq('formatTokenEstimate k', formatTokenEstimate(1500), '~1.5K tokens');
  eq('formatTokenEstimate raw', formatTokenEstimate(420), '~420 tokens');
  eq('formatTokenEstimate zero', formatTokenEstimate(0), '');
  eq('estimateTokensFromContent', estimateTokensFromContent('abcdefgh'), 2);
  eq('estimateTokensFromContent empty', estimateTokensFromContent(''), 0);
}

// --- opencode chat theme (T13 typography + forced dark palette) ---
{
  eq('oc bg', ocChatColors.bg, '#0a0a0a');
  eq('oc accent', ocChatColors.accent, '#fab283');
  eq('oc diff add', ocChatColors.diffAdd, '#4fd6be');
  eq('oc diff del bg', ocChatColors.diffDelBg, '#37222c');
  eq('oc chat font size', CHAT_FONT_SIZE, 13);
  eq('oc mono font', MONO_FONT, 'Menlo');
  // The remap maps every shadcn token onto the oc palette (never the app theme).
  eq('oc theme background → oc bg', ocChatTheme.background, ocChatColors.bg);
  eq('oc theme primary → oc accent', ocChatTheme.primary, ocChatColors.accent);
  eq('oc theme muted-fg → oc muted', ocChatTheme.mutedForeground, ocChatColors.muted);
  eq('oc theme destructive → oc error', ocChatTheme.destructive, ocChatColors.error);
  eq('oc theme border → oc border', ocChatTheme.border, ocChatColors.border);
  eq('oc theme canvas is dark', ocChatTheme.background === '#0a0a0a', true);
  eq('oc theme has all ThemeColors keys', Object.keys(ocChatTheme).length, Object.keys({
    background: 0, foreground: 0, card: 0, cardForeground: 0, popover: 0, popoverForeground: 0,
    primary: 0, primaryForeground: 0, secondary: 0, secondaryForeground: 0, muted: 0, mutedForeground: 0,
    accent: 0, accentForeground: 0, destructive: 0, destructiveForeground: 0, border: 0, input: 0, ring: 0,
  }).length);
}

// --- keyboard shortcuts + ui preferences (T14) ---
{
  eq('abort on Escape while running', resolveChatShortcut({ key: 'Escape', running: true }), 'abort');
  eq('no abort when idle', resolveChatShortcut({ key: 'Escape', running: false }), null);
  eq('close-search wins over abort', resolveChatShortcut({ key: 'Escape', running: true, searchOpen: true }), 'close-search');
  eq('menu swallows Escape', resolveChatShortcut({ key: 'Escape', running: true, menuOpen: true }), null);
  eq('ctrl+shift+f focuses search', resolveChatShortcut({ key: 'f', ctrlKey: true, shiftKey: true }), 'focus-search');
  eq('cmd+shift+F focuses search', resolveChatShortcut({ key: 'F', metaKey: true, shiftKey: true }), 'focus-search');
  eq('plain f is not a shortcut', resolveChatShortcut({ key: 'f' }), null);
  eq('ctrl+f without shift is not a shortcut', resolveChatShortcut({ key: 'f', ctrlKey: true }), null);

  eq('ui prefs storage key', UI_PREFERENCES_STORAGE_KEY, 'uiPreferences');
  eq('ui prefs default thinking', UI_PREFERENCES_DEFAULTS.showThinking, true);
  eq('ui prefs default preventSleep', UI_PREFERENCES_DEFAULTS.preventSleep, false);
  eq('parseBoolean true string', parseBoolean('true', false), true);
  eq('parseBoolean false string', parseBoolean('false', true), false);
  eq('parseBoolean junk falls back', parseBoolean('nope', true), true);
  eq('parse prefs null → defaults', parseUiPreferences(null).showThinking, true);
  eq('parse prefs bad json → defaults', parseUiPreferences('{bad').sendByCtrlEnter, false);
  eq('parse prefs array → defaults', parseUiPreferences('[]').showThinking, true);
  const parsedPrefs = parseUiPreferences('{"preventSleep":true,"showThinking":"false"}');
  eq('parse prefs coerces preventSleep', parsedPrefs.preventSleep, true);
  eq('parse prefs coerces string false', parsedPrefs.showThinking, false);
  eq('serialize roundtrips', parseUiPreferences(serializeUiPreferences({ ...UI_PREFERENCES_DEFAULTS, focusFollowsPointer: true })).focusFollowsPointer, true);
}

// --- provider settings / agents tab (T15) ---
{
  eq('provider settings keys claude', PROVIDER_SETTINGS_KEYS.claude, 'claude-settings');
  eq('provider settings keys cursor', PROVIDER_SETTINGS_KEYS.cursor, 'cursor-tools-settings');
  eq('provider settings keys codex', PROVIDER_SETTINGS_KEYS.codex, 'codex-settings');
  eq('provider settings keys opencode', PROVIDER_SETTINGS_KEYS.opencode, 'opencode-settings');
  eq('provider settings keys devin', PROVIDER_SETTINGS_KEYS.devin, 'devin-settings');
  eq('provider settings event', PROVIDER_SETTINGS_CHANGED_EVENT, 'provider-settings-changed');
  ok('common claude tools non-empty', COMMON_CLAUDE_TOOLS.length > 0);
  ok('common cursor commands non-empty', COMMON_CURSOR_COMMANDS.length > 0);

  eq('parseClaude null → defaults', parseProviderClaudeSettings(null).allowedTools, []);
  eq('parseClaude bad json → defaults', parseProviderClaudeSettings('{bad').skipPermissions, false);
  const claude = parseProviderClaudeSettings('{"allowedTools":["Read",7],"disallowedTools":"x","skipPermissions":"true"}');
  eq('parseClaude coerces allowed list', claude.allowedTools, ['Read']);
  eq('parseClaude coerces non-array → []', claude.disallowedTools, []);
  eq('parseClaude coerces skip bool', parseClaudeSettings('{"skipPermissions":true}').skipPermissions, true);
  eq('parseClaude string bool not coerced', claude.skipPermissions, false);

  eq('parseCursor null → defaults', parseCursorSettings(null).allowedCommands, []);
  const cursor = parseCursorSettings('{"allowedCommands":["Shell(ls)"],"disallowedCommands":null}');
  eq('parseCursor allowed list', cursor.allowedCommands, ['Shell(ls)']);
  eq('parseCursor null disallowed → []', cursor.disallowedCommands, []);

  eq('toCodex accepts acceptEdits', toCodexPermissionMode('acceptEdits'), 'acceptEdits');
  eq('toCodex rejects plan → default', toCodexPermissionMode('plan'), 'default');
  eq('toProvider accepts plan', toProviderPermissionMode('plan'), 'plan');
  eq('toProvider rejects junk → default', toProviderPermissionMode('nope'), 'default');

  eq('parseStoredPermissionMode null', parseStoredPermissionMode(null), null);
  eq('parseStoredPermissionMode reads mode', parseStoredPermissionMode('{"permissionMode":"plan"}'), 'plan');
  eq('parseStoredPermissionMode bad json', parseStoredPermissionMode('{bad'), null);

  eq('serialize permission roundtrip', parseStoredPermissionMode(serializePermissionModeSetting('acceptEdits')), 'acceptEdits');
  eq('serialize claude roundtrip', parseProviderClaudeSettings(serializeClaudeSettings({ allowedTools: ['Read'], disallowedTools: [], skipPermissions: true })).skipPermissions, true);
  eq('serialize cursor roundtrip', parseCursorSettings(serializeCursorSettings({ allowedCommands: ['Shell(ls)'], disallowedCommands: [], skipPermissions: false })).allowedCommands, ['Shell(ls)']);

  eq('addUnique trims + appends', addUnique(['Read'], '  Bash(ls)  '), ['Read', 'Bash(ls)']);
  eq('addUnique dedups', addUnique(['Read'], 'Read'), ['Read']);
  eq('addUnique ignores empty', addUnique(['Read'], '   '), ['Read']);
  eq('removeValue removes', removeValue(['Read', 'Edit'], 'Read'), ['Edit']);
  eq('removeValue no-op', removeValue(['Read'], 'Edit'), ['Read']);

  ok('fallback modes claude non-empty', FALLBACK_PERMISSION_MODES.claude.length > 0);
  ok('fallback modes devin has no plan', !FALLBACK_PERMISSION_MODES.devin.includes('plan' as never));
}

// --- appearance settings (T16 code editor + project sort) ---
{
  eq('code editor font sizes', CODE_EDITOR_FONT_SIZES, ['10', '11', '12', '13', '14', '15', '16', '18', '20']);
  eq('code editor defaults', DEFAULT_CODE_EDITOR_SETTINGS, { wordWrap: false, showMinimap: true, lineNumbers: true, fontSize: '14' });
  eq('parse empty -> defaults', parseCodeEditorSettings({}), DEFAULT_CODE_EDITOR_SETTINGS);
  eq('parse wordWrap only true string', parseCodeEditorSettings({ wordWrap: 'true' }).wordWrap, true);
  eq('parse wordWrap false string', parseCodeEditorSettings({ wordWrap: 'false' }).wordWrap, false);
  eq('parse minimap !== false keeps default', parseCodeEditorSettings({ showMinimap: null }).showMinimap, true);
  eq('parse minimap false', parseCodeEditorSettings({ showMinimap: 'false' }).showMinimap, false);
  eq('parse lineNumbers false', parseCodeEditorSettings({ lineNumbers: 'false' }).lineNumbers, false);
  eq('parse font size kept', parseCodeEditorSettings({ fontSize: '18' }).fontSize, '18');
  eq('parse font size invalid -> default', parseCodeEditorSettings({ fontSize: '99' }).fontSize, '14');
  const serialized = serializeCodeEditorSettings({ wordWrap: true, showMinimap: false, lineNumbers: false, fontSize: '16' });
  eq('serialize wordWrap', serialized.codeEditorWordWrap, 'true');
  eq('serialize minimap key', serialized.codeEditorShowMinimap, 'false');
  eq('serialize lineNumbers key', serialized.codeEditorLineNumbers, 'false');
  eq('serialize fontSize key', serialized.codeEditorFontSize, '16');

  const projects = [
    { id: 'b', displayName: 'Beta', isStarred: false },
    { id: 'a', displayName: 'Alpha', isStarred: true },
    { id: 'c', displayName: 'Charlie', isStarred: false },
  ];
  eq('sort name starred first', sortProjectList(projects, 'name').map((p) => p.id), ['a', 'b', 'c']);
  eq('sort date falls back to name', sortProjectList(projects, 'date').map((p) => p.id), ['a', 'b', 'c']);
  const dated = [
    { id: 'x', displayName: 'X', lastActivity: '2026-01-01T00:00:00Z' },
    { id: 'y', displayName: 'Y', lastActivity: '2026-06-01T00:00:00Z' },
  ];
  eq('sort date newest first', sortProjectList(dated, 'date').map((p) => p.id), ['y', 'x']);
  eq('sort does not mutate', projects.map((p) => p.id), ['b', 'a', 'c']);
}

// --- live server payload (captured from /api/providers/sessions/:id/messages) ---
try {
  const real = JSON.parse(readFileSync('/tmp/real-msgs2.json', 'utf8'));
  const items = messagesFromResponse(real);
  ok('real payload has items', items.length > 0);
  const parsed = items.map(parseItem);
  ok('real: every item parsed', parsed.every((p) => typeof p.text === 'string' && Array.isArray(p.tools)));
  ok('real: text items render', parsed.filter((p) => !p.skip && p.text.trim()).length >= 1);
  ok('real: tool_use parsed', parsed.filter((p) => p.tools.length > 0).length >= 1);
  console.log(`real: ${items.length} items → ${parsed.filter((p) => !p.skip).length} rendered`);
} catch {
  console.log('SKIP live payload test (no /tmp/real-msgs2.json)');
}

// --- schedules (T18) ---
ok('schedules: default cron', DEFAULT_CRON === '0 9 * * *');
ok('schedules: provider list order', SCHEDULE_PROVIDERS.join(',') === 'claude,codex,cursor,opencode,devin');
ok('schedules: format null time', formatScheduleTime(null) === '');
ok('schedules: format invalid time', formatScheduleTime('not-a-date') === '');
{
  const formatted = formatScheduleTime('2026-03-05T09:30:00.000Z');
  ok('schedules: format valid time non-empty', formatted.length > 0 && /,\s\d{4}\s\d{2}:\d{2}$/.test(formatted));
}
ok('schedules: meta line', scheduleMetaLine({ cron: '0 9 * * *', provider: 'claude' }, 'Proj') === '0 9 * * * · Proj · claude');
ok('schedules: truncate short', truncateSchedulePrompt('  hello   world  ') === 'hello world');
ok('schedules: truncate long ends with ellipsis', truncateSchedulePrompt('x'.repeat(200), 40).length === 40);
ok('schedules: truncate long collapses whitespace', truncateSchedulePrompt('a\n\nb\tc', 40) === 'a b c');

// --- notifications (T19) ---
ok('notifications: parseEndpoints reads {endpoints}', parseEndpoints({ endpoints: [{ channel: 'fcm', endpointId: 'abc', label: 'phone', enabled: true }] }).length === 1);
ok('notifications: parseEndpoints reads {data:{endpoints}}', parseEndpoints({ data: { endpoints: [{ channel: 'fcm', endpointId: 'x' }] } })[0]?.endpointId === 'x');
ok('notifications: parseEndpoints drops missing id', parseEndpoints({ endpoints: [{ channel: 'fcm' }, { endpointId: 'ok' }] }).length === 1);
ok('notifications: parseEndpoints bad payload', parseEndpoints(null).length === 0);
ok('notifications: isChannelEnabled true', isChannelEnabled({ channels: { telegram: true }, events: { actionRequired: false, stop: false, error: false } }, 'telegram') === true);
ok('notifications: isChannelEnabled false when null', isChannelEnabled(null, 'telegram') === false);
{
  const toggled = toggleChannelIn({ channels: { inApp: true, telegram: false }, events: { actionRequired: false, stop: false, error: false } }, 'telegram', true);
  ok('notifications: toggleChannelIn sets channel', toggled.channels.telegram === true);
  ok('notifications: toggleChannelIn keeps others', toggled.channels.inApp === true);
}
{
  const chats = parseTelegramChats({ detected: [{ chatId: '1', title: 'Me' }], paired: [{ endpointId: '1', label: 'Me' }] });
  ok('notifications: parseTelegramChats detected', chats.detected[0]?.chatId === '1');
  ok('notifications: parseTelegramChats paired', chats.paired[0]?.label === 'Me');
  ok('notifications: parseTelegramChats null-safe', parseTelegramChats(null).detected.length === 0);
}

console.log(failures === 0 ? '\nALL PASS' : `\n${failures} FAILURES`);
process.exit(failures ? 1 : 0);