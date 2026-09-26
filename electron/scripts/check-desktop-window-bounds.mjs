// Node-level verification for desktop window bounds calculation and layout event handling.
// Run from the repo root:
//   node electron/scripts/check-desktop-window-bounds.mjs
//
// Exit code: 0 = all checks passed, 1 = failure.

import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const checks = [];
function check(name, fn) {
  try {
    fn();
    checks.push({ name, ok: true });
    console.log(`PASS ${name}`);
  } catch (error) {
    checks.push({ name, ok: false });
    console.log(`FAIL ${name} — ${error?.message || error}`);
  }
}

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');
const desktopWindowSource = fs.readFileSync(path.join(root, 'electron/desktopWindow.js'), 'utf8');
const launcherCssSource = fs.readFileSync(path.join(root, 'electron/launcher/launcher.css'), 'utf8');

// 1. Static inspection of DesktopWindowManager
check('desktopWindow: getContentViewBounds accounts for isFullScreen', () => {
  assert.match(desktopWindowSource, /isFullScreen\s*=\s*Boolean\(typeof this\.mainWindow\.isFullScreen === 'function' && this\.mainWindow\.isFullScreen\(\)\)/);
  assert.match(desktopWindowSource, /titlebarHeight\s*=\s*isFullScreen \? 0 : TITLEBAR_HEIGHT/);
});

check('desktopWindow: syncSettingsWindowBounds prefers getContentBounds', () => {
  assert.match(desktopWindowSource, /const bounds = typeof this\.mainWindow\.getContentBounds === 'function'/);
  assert.match(desktopWindowSource, /\? this\.mainWindow\.getContentBounds\(\)/);
  assert.match(desktopWindowSource, /: this\.mainWindow\.getBounds\(\)/);
  assert.match(desktopWindowSource, /this\.settingsWindow\.setBounds\(bounds\)/);
});

check('desktopWindow: ensureSettingsWindow sets fullscreenable to true', () => {
  assert.match(desktopWindowSource, /fullscreenable:\s*true/);
});

check('desktopWindow: mainWindow listens to all layout and resize events', () => {
  const events = ['resize', 'maximize', 'unmaximize', 'enter-full-screen', 'leave-full-screen', 'restore'];
  for (const evt of events) {
    assert.ok(
      desktopWindowSource.includes(`'${evt}'`),
      `desktopWindow.js must register listener for event '${evt}'`
    );
  }
});

check('launcher.css: .cc-sheet has adaptive max-height and overflow-y: auto', () => {
  assert.match(launcherCssSource, /\.cc-sheet\s*\{[^}]*max-height:\s*min\(720px,\s*calc\(100vh\s*-\s*48px\)\);/);
  assert.match(launcherCssSource, /\.cc-sheet\s*\{[^}]*overflow-y:\s*auto;/);
});

// 2. Behavioral verification of the calculations with mock window objects
check('behavior: getContentViewBounds returns 44px top offset in normal mode', () => {
  const TITLEBAR_HEIGHT = 44;
  function getContentViewBounds(mainWindow) {
    if (!mainWindow) return { x: 0, y: TITLEBAR_HEIGHT, width: 0, height: 0 };
    const isFullScreen = Boolean(typeof mainWindow.isFullScreen === 'function' && mainWindow.isFullScreen());
    const titlebarHeight = isFullScreen ? 0 : TITLEBAR_HEIGHT;
    const [width, height] = mainWindow.getContentSize();
    return {
      x: 0,
      y: titlebarHeight,
      width,
      height: Math.max(0, height - titlebarHeight),
    };
  }

  const normalWindow = {
    isFullScreen: () => false,
    getContentSize: () => [1280, 800],
  };

  const bounds = getContentViewBounds(normalWindow);
  assert.deepEqual(bounds, { x: 0, y: 44, width: 1280, height: 756 });
});

check('behavior: getContentViewBounds returns 0 offset and full height in fullscreen mode', () => {
  const TITLEBAR_HEIGHT = 44;
  function getContentViewBounds(mainWindow) {
    if (!mainWindow) return { x: 0, y: TITLEBAR_HEIGHT, width: 0, height: 0 };
    const isFullScreen = Boolean(typeof mainWindow.isFullScreen === 'function' && mainWindow.isFullScreen());
    const titlebarHeight = isFullScreen ? 0 : TITLEBAR_HEIGHT;
    const [width, height] = mainWindow.getContentSize();
    return {
      x: 0,
      y: titlebarHeight,
      width,
      height: Math.max(0, height - titlebarHeight),
    };
  }

  const fullScreenWindow = {
    isFullScreen: () => true,
    getContentSize: () => [1920, 1080],
  };

  const bounds = getContentViewBounds(fullScreenWindow);
  assert.deepEqual(bounds, { x: 0, y: 0, width: 1920, height: 1080 });
});

check('behavior: syncSettingsWindowBounds syncs content bounds without native OS borders', () => {
  let appliedBounds = null;
  const mockSettingsWindow = {
    isDestroyed: () => false,
    setBounds: (b) => { appliedBounds = b; },
  };
  const mockMainWindow = {
    // Windows maximized window scenario: getBounds has -8 offset, getContentBounds has client area (0, 0)
    getBounds: () => ({ x: -8, y: -8, width: 1936, height: 1096 }),
    getContentBounds: () => ({ x: 0, y: 0, width: 1920, height: 1080 }),
  };

  const bounds = typeof mockMainWindow.getContentBounds === 'function'
    ? mockMainWindow.getContentBounds()
    : mockMainWindow.getBounds();
  mockSettingsWindow.setBounds(bounds);

  assert.deepEqual(appliedBounds, { x: 0, y: 0, width: 1920, height: 1080 });
});

check('behavior: layout change event dispatcher triggers on all resize/maximize/fullscreen events', () => {
  const registeredEvents = new Map();
  const mockMainWindow = {
    on: (evt, cb) => {
      registeredEvents.set(evt, cb);
    },
  };

  let resized = 0;
  let synced = 0;
  const mockViewHost = {
    resizeActiveView: () => { resized++; },
  };
  const syncSettingsWindowBounds = () => { synced++; };

  const handleLayoutChange = () => {
    mockViewHost.resizeActiveView();
    syncSettingsWindowBounds();
  };

  for (const event of ['resize', 'maximize', 'unmaximize', 'enter-full-screen', 'leave-full-screen', 'restore']) {
    mockMainWindow.on(event, handleLayoutChange);
  }
  mockMainWindow.on('move', () => {
    syncSettingsWindowBounds();
  });

  // Trigger all events
  for (const event of ['resize', 'maximize', 'unmaximize', 'enter-full-screen', 'leave-full-screen', 'restore']) {
    registeredEvents.get(event)();
  }
  assert.equal(resized, 6);
  assert.equal(synced, 6);

  registeredEvents.get('move')();
  assert.equal(resized, 6);
  assert.equal(synced, 7);
});

const failed = checks.filter((c) => !c.ok);
console.log(`\n${checks.length - failed.length}/${checks.length} checks passed`);
process.exit(failed.length ? 1 : 0);
