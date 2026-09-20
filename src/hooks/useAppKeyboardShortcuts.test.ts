import { describe, it } from 'node:test';
import assert from 'node:assert/strict';

import {
  getAltDigit,
  getTargetTabForDigit,
  isFocusModeShortcut,
} from './useAppKeyboardShortcuts';

describe('useAppKeyboardShortcuts logic', () => {
  describe('getAltDigit', () => {
    it('detects Alt+1..5 with altKey=true and no ctrl/meta', () => {
      // By event.key
      assert.equal(getAltDigit({ altKey: true, ctrlKey: false, metaKey: false, key: '1', code: '' } as KeyboardEvent), 1);
      assert.equal(getAltDigit({ altKey: true, ctrlKey: false, metaKey: false, key: '2', code: '' } as KeyboardEvent), 2);
      assert.equal(getAltDigit({ altKey: true, ctrlKey: false, metaKey: false, key: '3', code: '' } as KeyboardEvent), 3);
      assert.equal(getAltDigit({ altKey: true, ctrlKey: false, metaKey: false, key: '4', code: '' } as KeyboardEvent), 4);
      assert.equal(getAltDigit({ altKey: true, ctrlKey: false, metaKey: false, key: '5', code: '' } as KeyboardEvent), 5);

      // By event.code (e.g. international layouts where Alt changes key character)
      assert.equal(getAltDigit({ altKey: true, ctrlKey: false, metaKey: false, key: '¡', code: 'Digit1' } as KeyboardEvent), 1);
      assert.equal(getAltDigit({ altKey: true, ctrlKey: false, metaKey: false, key: '™', code: 'Digit2' } as KeyboardEvent), 2);
      assert.equal(getAltDigit({ altKey: true, ctrlKey: false, metaKey: false, key: '£', code: 'Digit3' } as KeyboardEvent), 3);
      assert.equal(getAltDigit({ altKey: true, ctrlKey: false, metaKey: false, key: '¢', code: 'Digit4' } as KeyboardEvent), 4);
      assert.equal(getAltDigit({ altKey: true, ctrlKey: false, metaKey: false, key: '∞', code: 'Digit5' } as KeyboardEvent), 5);
    });

    it('rejects when altKey is false (normal typing)', () => {
      assert.equal(getAltDigit({ altKey: false, ctrlKey: false, metaKey: false, key: '1', code: 'Digit1' } as KeyboardEvent), null);
      assert.equal(getAltDigit({ altKey: false, ctrlKey: false, metaKey: false, key: '2', code: 'Digit2' } as KeyboardEvent), null);
    });

    it('rejects when ctrlKey or metaKey is active', () => {
      assert.equal(getAltDigit({ altKey: true, ctrlKey: true, metaKey: false, key: '1', code: 'Digit1' } as KeyboardEvent), null);
      assert.equal(getAltDigit({ altKey: true, ctrlKey: false, metaKey: true, key: '1', code: 'Digit1' } as KeyboardEvent), null);
    });

    it('rejects digits outside 1..5 and letters', () => {
      assert.equal(getAltDigit({ altKey: true, ctrlKey: false, metaKey: false, key: '6', code: 'Digit6' } as KeyboardEvent), null);
      assert.equal(getAltDigit({ altKey: true, ctrlKey: false, metaKey: false, key: '0', code: 'Digit0' } as KeyboardEvent), null);
      assert.equal(getAltDigit({ altKey: true, ctrlKey: false, metaKey: false, key: 'a', code: 'KeyA' } as KeyboardEvent), null);
    });
  });

  describe('getTargetTabForDigit', () => {
    it('maps Alt+1 to chat', () => {
      assert.equal(getTargetTabForDigit(1, true), 'chat');
      assert.equal(getTargetTabForDigit(1, false), 'chat');
    });

    it('maps Alt+2 to tasks when tasks tab is available, or git when not available', () => {
      assert.equal(getTargetTabForDigit(2, true), 'tasks');
      assert.equal(getTargetTabForDigit(2, false), 'git');
    });

    it('maps Alt+3 to git', () => {
      assert.equal(getTargetTabForDigit(3, true), 'git');
      assert.equal(getTargetTabForDigit(3, false), 'git');
    });

    it('returns null for Alt+4 and Alt+5', () => {
      assert.equal(getTargetTabForDigit(4, true), null);
      assert.equal(getTargetTabForDigit(4, false), null);
      assert.equal(getTargetTabForDigit(5, true), null);
      assert.equal(getTargetTabForDigit(5, false), null);
    });

    it('returns null for unknown digits', () => {
      assert.equal(getTargetTabForDigit(6, true), null);
      assert.equal(getTargetTabForDigit(0, true), null);
    });
  });

  describe('isFocusModeShortcut', () => {
    it('detects Ctrl+Shift+F', () => {
      assert.equal(isFocusModeShortcut({
        ctrlKey: true,
        metaKey: false,
        shiftKey: true,
        altKey: false,
        key: 'F',
        code: 'KeyF',
      } as KeyboardEvent), true);

      assert.equal(isFocusModeShortcut({
        ctrlKey: true,
        metaKey: false,
        shiftKey: true,
        altKey: false,
        key: 'f',
        code: 'KeyF',
      } as KeyboardEvent), true);
    });

    it('detects Cmd+Shift+F (metaKey)', () => {
      assert.equal(isFocusModeShortcut({
        ctrlKey: false,
        metaKey: true,
        shiftKey: true,
        altKey: false,
        key: 'F',
        code: 'KeyF',
      } as KeyboardEvent), true);
    });

    it('rejects without shiftKey', () => {
      assert.equal(isFocusModeShortcut({
        ctrlKey: true,
        metaKey: false,
        shiftKey: false,
        altKey: false,
        key: 'f',
        code: 'KeyF',
      } as KeyboardEvent), false);
    });

    it('rejects with altKey', () => {
      assert.equal(isFocusModeShortcut({
        ctrlKey: true,
        metaKey: false,
        shiftKey: true,
        altKey: true,
        key: 'f',
        code: 'KeyF',
      } as KeyboardEvent), false);
    });

    it('rejects other letters', () => {
      assert.equal(isFocusModeShortcut({
        ctrlKey: true,
        metaKey: false,
        shiftKey: true,
        altKey: false,
        key: 'k',
        code: 'KeyK',
      } as KeyboardEvent), false);
    });
  });
});
