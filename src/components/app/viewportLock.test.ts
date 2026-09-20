import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import test from 'node:test';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

test('AppContent implements Smart Keyboard Viewport Lock with Visual Viewport and scroll reset', () => {
  const appContentPath = path.resolve(__dirname, 'AppContent.tsx');
  const content = fs.readFileSync(appContentPath, 'utf-8');

  // Verify visualViewport event listeners (both resize and scroll)
  assert.ok(
    content.includes("vv.addEventListener('resize', handleViewportChange)"),
    'AppContent should attach resize listener to visualViewport',
  );
  assert.ok(
    content.includes("vv.addEventListener('scroll', handleScroll)"),
    'AppContent should attach scroll listener to visualViewport',
  );
  assert.ok(
    content.includes("window.addEventListener('scroll', handleScroll"),
    'AppContent should attach scroll listener to window',
  );

  // Verify window.scrollTo(0, 0) drift prevention
  assert.ok(
    content.includes('window.scrollTo(0, 0)'),
    'AppContent should reset window scroll to (0, 0) to prevent iOS Safari drift',
  );

  // Verify keyboard-open, overflow-hidden, and overscroll-none classes
  assert.ok(
    content.includes('keyboard-open') &&
      content.includes('overflow-hidden') &&
      content.includes('overscroll-none'),
    'AppContent should add keyboard-open, overflow-hidden, and overscroll-none to lock document',
  );
});

test('ChatComposer handles mobile touch focus safely to prevent window scroll drift', () => {
  const composerPath = path.resolve(__dirname, '../chat/view/subcomponents/ChatComposer.tsx');
  const content = fs.readFileSync(composerPath, 'utf-8');

  assert.ok(
    content.includes('ontouchstart') || content.includes('navigator.maxTouchPoints'),
    'ChatComposer should detect mobile touch device during focus',
  );
  assert.ok(
    content.includes('window.scrollTo(0, 0)'),
    'ChatComposer should maintain window scroll at (0, 0) on focus',
  );
});

test('index.css enforces keyboard-open viewport lock rules', () => {
  const cssPath = path.resolve(__dirname, '../../index.css');
  const css = fs.readFileSync(cssPath, 'utf-8');

  assert.ok(
    css.includes('body.keyboard-open'),
    'index.css should define body.keyboard-open rules',
  );
  assert.ok(
    css.includes('overscroll-behavior: none !important'),
    'index.css should enforce overscroll-behavior: none !important during keyboard-open',
  );
});
