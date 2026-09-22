// Node-level self-check for electron/windowState.js — no Electron runtime
// needed: the module binds `screen` via createRequire, so under plain node it
// stays null and display validation is skipped (that path is exercised too).
//
// Run from the repo root:
//   node electron/scripts/check-window-state.mjs
//
// Exit code: 0 = all checks passed, 1 = failure.

import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';

import {
  clampBoundsToDisplays,
  loadWindowState,
  sanitizeWindowState,
  trackWindowState,
} from '../windowState.js';

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

const FHD = { x: 0, y: 0, width: 1920, height: 1080 };
const SECOND = { x: 1920, y: 0, width: 1920, height: 1080 };

check('sanitize: valid state normalized', () => {
  assert.deepEqual(
    sanitizeWindowState({ x: 10.4, y: 20.6, width: 1280.5, height: 800, isMaximized: true }),
    { x: 10, y: 21, width: 1281, height: 800, isMaximized: true },
  );
  // non-boolean isMaximized is not trusted
  assert.equal(sanitizeWindowState({ width: 100, height: 100, isMaximized: 1 }).isMaximized, false);
});

check('sanitize: garbage / missing fields -> null', () => {
  for (const raw of [null, undefined, 'x', 42, {}, { width: 100 }, { width: 'a', height: 100 }]) {
    assert.equal(sanitizeWindowState(raw), null);
  }
});

check('sanitize: lone x or y dropped', () => {
  const state = sanitizeWindowState({ x: 5, width: 800, height: 600 });
  assert.deepEqual(state, { width: 800, height: 600, isMaximized: false });
});

check('clamp: bounds on a display pass through', () => {
  const state = { x: 2000, y: 100, width: 800, height: 600, isMaximized: false };
  assert.deepEqual(clampBoundsToDisplays(state, [FHD, SECOND]), state);
});

check('clamp: removed display -> position dropped, size kept', () => {
  const state = { x: 2000, y: 100, width: 800, height: 600, isMaximized: true };
  assert.deepEqual(clampBoundsToDisplays(state, [FHD]), {
    width: 800, height: 600, isMaximized: true,
  });
});

check('clamp: oversized window shrinks to largest work area', () => {
  const state = { x: 10, y: 10, width: 4000, height: 2000, isMaximized: false };
  assert.deepEqual(clampBoundsToDisplays(state, [FHD]), {
    x: 10, y: 10, width: 1920, height: 1080, isMaximized: false,
  });
});

check('clamp: empty work area list (headless) passes through', () => {
  const state = { x: -5000, y: -5000, width: 100, height: 100, isMaximized: false };
  assert.deepEqual(clampBoundsToDisplays(state, []), state);
});

const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-window-state-'));
const stateFile = path.join(tmpDir, 'window-state.json');

check('load: missing file -> null', () => {
  assert.equal(loadWindowState(tmpDir), null);
});

check('load: corrupted JSON -> null', () => {
  fs.writeFileSync(stateFile, '{not json');
  assert.equal(loadWindowState(tmpDir), null);
});

check('load: valid file round-trips', () => {
  fs.writeFileSync(stateFile, JSON.stringify({ x: 1, y: 2, width: 3, height: 4, isMaximized: true }));
  assert.deepEqual(loadWindowState(tmpDir), { x: 1, y: 2, width: 3, height: 4, isMaximized: true });
});

function fakeWindow(bounds) {
  const listeners = new Map();
  return {
    destroyed: false,
    on: (event, cb) => listeners.set(event, cb),
    emit: (event) => listeners.get(event)?.(),
    isDestroyed() { return this.destroyed; },
    getNormalBounds: () => bounds,
    isMaximized: () => bounds.isMaximized === true,
  };
}

check('track: debounced save + close flush write state file', async () => {
  fs.rmSync(stateFile, { force: true });
  const win = fakeWindow({ x: 7, y: 8, width: 900, height: 700 });
  trackWindowState(win, tmpDir);
  win.emit('close'); // flush writes synchronously
  assert.deepEqual(JSON.parse(fs.readFileSync(stateFile, 'utf8')), {
    x: 7, y: 8, width: 900, height: 700, isMaximized: false,
  });
  // debounce path: resize schedules a write that lands within ~600ms
  win.emit('resize');
  await new Promise((resolve) => setTimeout(resolve, 700));
  assert.ok(fs.existsSync(stateFile));
});

check('track: destroyed window writes nothing', () => {
  fs.rmSync(stateFile, { force: true });
  const win = fakeWindow({ x: 1, y: 1, width: 100, height: 100 });
  win.destroyed = true;
  trackWindowState(win, tmpDir);
  win.emit('close');
  assert.equal(fs.existsSync(stateFile), false);
});

check('track: missing args are no-ops', () => {
  trackWindowState(null, tmpDir);
  trackWindowState(fakeWindow({}), null);
});

fs.rmSync(tmpDir, { recursive: true, force: true });

const failed = checks.filter((c) => !c.ok);
console.log(`\n${checks.length - failed.length}/${checks.length} checks passed`);
process.exit(failed.length ? 1 : 0);
