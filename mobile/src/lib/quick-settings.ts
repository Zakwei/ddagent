// Pure helpers for the native quick-settings handle/panel, mirroring the web
// `src/components/quick-settings-panel/**`. No React/RN imports so it can run
// under node in tests/self-check.mts.

export const QUICK_SETTINGS_POSITION_KEY = 'quickSettingsHandlePosition';
export const DEFAULT_HANDLE_POSITION = 50;
export const MIN_HANDLE_POSITION = 10;
export const MAX_HANDLE_POSITION = 90;
export const DRAG_THRESHOLD_PX = 5;

export function clampHandlePosition(pct: number): number {
  if (!Number.isFinite(pct)) return DEFAULT_HANDLE_POSITION;
  return Math.max(MIN_HANDLE_POSITION, Math.min(MAX_HANDLE_POSITION, pct));
}

export function parseHandlePosition(raw: string | null | undefined): number {
  if (!raw) return DEFAULT_HANDLE_POSITION;
  try {
    const parsed = JSON.parse(raw);
    if (typeof parsed === 'number') return clampHandlePosition(parsed);
    if (parsed && typeof parsed === 'object' && typeof (parsed as { y?: unknown }).y === 'number') {
      return clampHandlePosition((parsed as { y: number }).y);
    }
    return DEFAULT_HANDLE_POSITION;
  } catch {
    return DEFAULT_HANDLE_POSITION;
  }
}

export function serializeHandlePosition(y: number): string {
  return JSON.stringify({ y: clampHandlePosition(y) });
}

/** New vertical percentage after a drag delta (sign inverted on mobile). */
export function dragPositionFromDelta(input: {
  startPct: number;
  deltaY: number;
  viewportHeight: number;
  mobile?: boolean;
}): number {
  const { startPct, deltaY, viewportHeight, mobile = false } = input;
  if (!Number.isFinite(viewportHeight) || viewportHeight <= 0) {
    return clampHandlePosition(startPct);
  }
  const delta = (deltaY / viewportHeight) * 100;
  return clampHandlePosition(startPct + (mobile ? -delta : delta));
}
