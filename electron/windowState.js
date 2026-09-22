// Persisted main-window bounds: <userData>/window-state.json holds
// {x, y, width, height, isMaximized}, written debounced on resize/move/
// maximize/unmaximize and flushed on close. On startup the saved bounds are
// validated against the current displays so a window on a removed monitor
// falls back to OS placement instead of spawning off-screen.
//
// `electron` is CJS — its ESM named exports don't resolve under plain node
// (index.js exports a binary-path string), so bind via createRequire: inside
// Electron this is the real API; under plain node `screen` stays null and
// display validation is skipped. Keeps the module importable in node-level
// checks and harmless in headless smoke runs.
import fs from 'node:fs';
import { createRequire } from 'node:module';
import path from 'node:path';

const electron = createRequire(import.meta.url)('electron');
const screen = electron && typeof electron === 'object' ? electron.screen : null;

const STATE_FILENAME = 'window-state.json';
const SAVE_DEBOUNCE_MS = 500;

function getStatePath(userDataDir) {
  return path.join(userDataDir, STATE_FILENAME);
}

function isFiniteNumber(value) {
  return typeof value === 'number' && Number.isFinite(value);
}

// Raw parsed JSON -> clean state, or null when unusable. x/y only count
// together — a lone coordinate is dropped.
export function sanitizeWindowState(raw) {
  if (!raw || typeof raw !== 'object') return null;
  if (!isFiniteNumber(raw.width) || !isFiniteNumber(raw.height)) return null;
  const state = {
    width: Math.max(1, Math.round(raw.width)),
    height: Math.max(1, Math.round(raw.height)),
    isMaximized: raw.isMaximized === true,
  };
  if (isFiniteNumber(raw.x) && isFiniteNumber(raw.y)) {
    state.x = Math.round(raw.x);
    state.y = Math.round(raw.y);
  }
  return state;
}

// workAreas: [{x, y, width, height}] (display.workArea). Empty list means we
// can't validate (headless / no screen API) — the state passes through.
export function clampBoundsToDisplays(state, workAreas) {
  const result = { ...state };
  if (!Array.isArray(workAreas) || workAreas.length === 0) return result;

  const onScreen = isFiniteNumber(result.x) && isFiniteNumber(result.y)
    && workAreas.some((area) =>
      result.x < area.x + area.width && result.x + result.width > area.x
      && result.y < area.y + area.height && result.y + result.height > area.y);
  if (!onScreen) {
    // The display the window was on is gone — let the OS pick the position.
    delete result.x;
    delete result.y;
  }
  // Never restore a window larger than the biggest available work area.
  const maxWidth = Math.max(...workAreas.map((area) => area.width));
  const maxHeight = Math.max(...workAreas.map((area) => area.height));
  result.width = Math.min(result.width, maxWidth);
  result.height = Math.min(result.height, maxHeight);
  return result;
}

function getDisplayWorkAreas() {
  try {
    if (!screen || typeof screen.getAllDisplays !== 'function') return [];
    return screen.getAllDisplays()
      .map((display) => display?.workArea)
      .filter((area) => area && isFiniteNumber(area.width) && isFiniteNumber(area.height));
  } catch {
    return [];
  }
}

export function loadWindowState(userDataDir) {
  if (!userDataDir) return null;
  try {
    const raw = fs.readFileSync(getStatePath(userDataDir), 'utf8');
    const state = sanitizeWindowState(JSON.parse(raw));
    if (!state) return null;
    return clampBoundsToDisplays(state, getDisplayWorkAreas());
  } catch {
    // Missing file, corrupted JSON, unreadable dir — start with defaults.
    return null;
  }
}

export function trackWindowState(win, userDataDir) {
  if (!win || !userDataDir || typeof win.on !== 'function') return;
  let saveTimer = null;

  const writeState = () => {
    saveTimer = null;
    if (win.isDestroyed()) return;
    let state;
    try {
      // getNormalBounds returns pre-maximize bounds — exactly what we restore.
      const bounds = win.getNormalBounds();
      state = {
        x: bounds.x,
        y: bounds.y,
        width: bounds.width,
        height: bounds.height,
        isMaximized: win.isMaximized(),
      };
    } catch {
      return;
    }
    try {
      const statePath = getStatePath(userDataDir);
      const tmpPath = `${statePath}.tmp`;
      fs.writeFileSync(tmpPath, JSON.stringify(state));
      fs.renameSync(tmpPath, statePath); // tmp+rename: never a half-written file
    } catch (error) {
      console.warn('[window-state] could not save:', error?.message || error);
    }
  };

  const scheduleSave = () => {
    if (saveTimer) clearTimeout(saveTimer);
    saveTimer = setTimeout(writeState, SAVE_DEBOUNCE_MS);
    saveTimer.unref?.(); // never hold the event loop open for a pending save
  };

  win.on('resize', scheduleSave);
  win.on('move', scheduleSave);
  win.on('maximize', scheduleSave);
  win.on('unmaximize', scheduleSave);
  win.on('close', () => {
    // Flush — a pending debounce would be lost once the window is gone.
    if (saveTimer) clearTimeout(saveTimer);
    writeState();
  });
}
