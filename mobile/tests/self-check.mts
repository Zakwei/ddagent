// Pure-logic self-check for the mobile app — runs under plain Node (type
// stripping), no emulator needed: `node tests/self-check.mts`
import { readFileSync } from 'node:fs';
import { normalizeServerUrl, wsBaseFor } from '../src/lib/server-url.ts';
import { parseItem, extractRole, messagesFromResponse } from '../src/lib/chat-messages.ts';

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
