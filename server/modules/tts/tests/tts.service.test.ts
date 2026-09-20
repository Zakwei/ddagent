import assert from 'node:assert/strict';
import test from 'node:test';

import { sanitizeSsmlInput } from '@/modules/tts/tts.service.js';

// Regression: replies carrying `<ref_file … />` tags or a bare "<" used to be
// pasted into msedge-tts' SSML verbatim, which made Edge drop the request and
// the read-aloud stream hang with no audio at all.
test('sanitizeSsmlInput removes tag-like spans and escapes SSML-breaking chars', () => {
  assert.equal(
    sanitizeSsmlInput('Krótko. <ref_file file="/tmp/x.ts" /> Dalej <2 min i R&D.'),
    'Krótko.   Dalej &lt;2 min i R&amp;D.',
  );
});

test('sanitizeSsmlInput escapes every raw bracket and ampersand', () => {
  assert.equal(sanitizeSsmlInput('<b>x</b> & < y > z'), ' x  &amp; &lt; y &gt; z');
});
