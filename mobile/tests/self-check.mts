// Pure-logic self-check for the mobile app — runs under plain Node (type
// stripping), no emulator needed: `node tests/self-check.mts`
import { readFileSync } from 'node:fs';
import { normalizeServerUrl, wsBaseFor } from '../src/lib/server-url.ts';
import { parseItem, extractRole, messagesFromResponse } from '../src/lib/chat-messages.ts';
import { matchesModelSearch, permissionModesFor, speechText, exportFilename } from '../src/lib/chat-extras.ts';
import { getSearchableText, messageMatches, buildSearchIndex, stepMatch, splitHighlight, nearestMatchIndex } from '../src/lib/chat-search.ts';
import { createEmptyClaudeSettings, parseClaudeSettings, buildClaudeToolPermissionEntry, extractAffectedFilePaths, isPlanToolRequest, matchingRememberRequestIds, grantClaudeToolPermission, resolveStoredPermissionMode } from '../src/lib/chat-permissions.ts';
import { deriveToolStatus, resolveToolName, getToolDisplay, shouldHideToolResult, calculateDiff, diffContentFor, extractFilePaths, parseTaskListContent, groupConsecutiveTools, isToolGroupItem } from '../src/lib/tool-render.ts';
import { normalizeInlineCodeFences, stripProposedPlanEnvelope, formatUsageLimitText, parseTaskNotification, parseInteractivePrompt, detectPureJson, fileRefFromLink, looksLikeFilePath, stripLineSuffix, formatMessageTime, turnLatencySeconds, formatTurnLatency, isGroupedMessage, formatFileSize } from '../src/lib/chat-format.ts';
import { tokenizeCode, languageLabel, normalizeLanguage, syntaxStyleFor } from '../src/lib/highlight.ts';
import { flattenFileTree, filterMentions, mentionQueryAt, insertMention, splitMentionParts, activeMentionTokens, filterSlashCommands, slashQueryAt, groupCommands, stepIndex, flattenCommandRows, resolveCommandResult, attachmentKind, attachmentKindLabel, submitState, shouldSubmitOnEnter, isOpenTask } from '../src/lib/composer.ts';
import { getModelTier, isFreeModel, formatContextWindow, modelSubtitle, filterModelsByTier, loadFavoritesFrom, toggleFavoriteIn, mergeFavorites, resolveEffortOptions, sectionForModel, isModelAvailableIn, isProviderAvailableIn, getPermissionAppearance, isAntigravityModel } from '../src/lib/model-menu.ts';
import { formatTokenCount, tokenBreakdown, activityLabel, formatElapsed, quotaTone, windowMatchesModel, quotaBadgeFor, advanceCursor } from '../src/lib/usage.ts';

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

console.log(failures === 0 ? '\nALL PASS' : `\n${failures} FAILURES`);
process.exit(failures ? 1 : 0);
