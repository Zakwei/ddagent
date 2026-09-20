import assert from 'node:assert/strict';
import test from 'node:test';

import { isPrintableKey, readModifiers, toKeyboardPayload, toNormalizedPoint } from './remoteInput';

test('toNormalizedPoint maps client coordinates into frame fractions', () => {
  const point = toNormalizedPoint(150, 100, { left: 100, top: 0, width: 200, height: 100 });
  assert.deepEqual(point, { x: 0.25, y: 1 });
});

test('toNormalizedPoint clamps values outside the frame and rejects zero-size rects', () => {
  assert.deepEqual(toNormalizedPoint(-50, 500, { left: 0, top: 0, width: 200, height: 100 }), { x: 0, y: 1 });
  assert.equal(toNormalizedPoint(10, 10, { left: 0, top: 0, width: 0, height: 100 }), null);
  assert.equal(toNormalizedPoint(10, 10, { left: 0, top: 0, width: 100, height: 0 }), null);
});

test('readModifiers packs dom flags into the cdp bitmask', () => {
  assert.equal(readModifiers({}), 0);
  assert.equal(readModifiers({ shiftKey: true }), 8);
  assert.equal(readModifiers({ ctrlKey: true, altKey: true }), 3);
  assert.equal(readModifiers({ metaKey: true, shiftKey: true }), 12);
});

test('isPrintableKey accepts single characters only', () => {
  assert.equal(isPrintableKey('a'), true);
  assert.equal(isPrintableKey('ł'), true);
  assert.equal(isPrintableKey('Enter'), false);
  assert.equal(isPrintableKey(''), false);
});

test('toKeyboardPayload sends printable text without shortcut modifiers', () => {
  assert.deepEqual(
    toKeyboardPayload({ key: 'ł', code: 'KeyL', keyCode: 76 }),
    { key: 'ł', code: 'KeyL', keyCode: 76, text: 'ł', modifiers: 0 },
  );
});

test('toKeyboardPayload drops text when ctrl/meta/alt is held', () => {
  const ctrl = toKeyboardPayload({ key: 'c', code: 'KeyC', keyCode: 67, ctrlKey: true });
  assert.equal(ctrl.text, undefined);
  assert.equal(ctrl.modifiers, 2);

  const alt = toKeyboardPayload({ key: 'a', code: 'KeyA', keyCode: 65, altKey: true });
  assert.equal(alt.text, undefined);
});

test('toKeyboardPayload keeps navigation keys without text', () => {
  assert.deepEqual(
    toKeyboardPayload({ key: 'Enter', code: 'Enter', keyCode: 13 }),
    { key: 'Enter', code: 'Enter', keyCode: 13, text: undefined, modifiers: 0 },
  );
});
