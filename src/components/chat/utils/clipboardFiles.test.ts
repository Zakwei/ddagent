import assert from 'node:assert/strict';
import test from 'node:test';

import { collectPastedFiles } from './clipboardFiles';

const makeFile = (name: string, lastModified: number) =>
  ({ name, size: 123, type: 'image/png', lastModified }) as unknown as File;

const makeClipboardData = (
  files: File[],
  items: Array<{ kind: string; getAsFile: () => File | null }>,
) => ({ files, items } as unknown as DataTransfer);

test('collectPastedFiles prefers clipboardData.files over items', () => {
  const fromFiles = makeFile('image.png', 2000);
  const data = makeClipboardData(
    [fromFiles],
    [{ kind: 'file', getAsFile: () => makeFile('image.png', 1000) }],
  );

  const collected = collectPastedFiles(data);
  assert.equal(collected.length, 1);
  assert.equal(collected[0], fromFiles);
});

test('collectPastedFiles falls back to file items when files is empty', () => {
  const first = makeFile('a.png', 1);
  const second = makeFile('b.pdf', 2);
  const data = makeClipboardData([], [
    { kind: 'string', getAsFile: () => null },
    { kind: 'file', getAsFile: () => first },
    { kind: 'file', getAsFile: () => second },
  ]);

  const collected = collectPastedFiles(data);
  assert.equal(collected.length, 2);
  assert.equal(collected[0], first);
  assert.equal(collected[1], second);
});

test('collectPastedFiles returns nothing for a text-only paste', () => {
  const data = makeClipboardData([], [{ kind: 'string', getAsFile: () => null }]);
  assert.deepEqual(collectPastedFiles(data), []);
});
