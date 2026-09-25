// Pure-logic self-check for the mobile app — runs under plain Node (type
// stripping), no emulator needed: `node tests/self-check.mts`
import { readFileSync } from 'node:fs';
import { normalizeServerUrl, wsBaseFor } from '../src/lib/server-url.ts';
import { parseItem, extractRole, messagesFromResponse } from '../src/lib/chat-messages.ts';
import { matchesModelSearch, permissionModesFor, speechText, exportFilename } from '../src/lib/chat-extras.ts';
import { getSearchableText, messageMatches, buildSearchIndex, stepMatch, splitHighlight, nearestMatchIndex } from '../src/lib/chat-search.ts';
import { createEmptyClaudeSettings, parseClaudeSettings, buildClaudeToolPermissionEntry, extractAffectedFilePaths, isPlanToolRequest, matchingRememberRequestIds, grantClaudeToolPermission, resolveStoredPermissionMode } from '../src/lib/chat-permissions.ts';
import { deriveToolStatus, resolveToolName, getToolDisplay, shouldHideToolResult, calculateDiff, diffContentFor, extractFilePaths, parseTaskListContent, groupConsecutiveTools, isToolGroupItem } from '../src/lib/tool-render.ts';

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
