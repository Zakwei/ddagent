/**
 * Pure input-mapping helpers for the remote browser view.
 *
 * The view sends pointer positions as fractions of the rendered frame (0..1)
 * so the server can scale them to its own viewport without the client knowing
 * the device-pixel ratio. Keyboard events are reduced to the CDP-shaped fields
 * the server forwards to Chromium.
 */

export type NormalizedPoint = { x: number; y: number };

export type KeyboardPayload = {
  key: string;
  code?: string;
  keyCode?: number;
  text?: string;
  modifiers: number;
};

export type PointerRect = { left: number; top: number; width: number; height: number };

/**
 * Maps a client-space pointer position to fractions of the rendered frame.
 *
 * Values are clamped to 0..1 so drags that leave the frame settle on the edge
 * instead of producing out-of-bounds CDP events. Returns null when the frame
 * has no measurable size (before first layout).
 */
export function toNormalizedPoint(clientX: number, clientY: number, rect: PointerRect): NormalizedPoint | null {
  if (!rect.width || !rect.height) return null;
  const x = (clientX - rect.left) / rect.width;
  const y = (clientY - rect.top) / rect.height;
  return {
    x: Math.min(Math.max(x, 0), 1),
    y: Math.min(Math.max(y, 0), 1),
  };
}

type ModifierState = { altKey?: boolean; ctrlKey?: boolean; metaKey?: boolean; shiftKey?: boolean };

/** Packs DOM modifier booleans into the CDP modifier bitmask. */
export function readModifiers(event: ModifierState): number {
  return (event.altKey ? 1 : 0)
    | (event.ctrlKey ? 2 : 0)
    | (event.metaKey ? 4 : 0)
    | (event.shiftKey ? 8 : 0);
}

type KeyLike = ModifierState & { key: string; code?: string; keyCode?: number };

/** True for keys that represent a single printable character. */
export function isPrintableKey(key: string): boolean {
  return typeof key === 'string' && [...key].length === 1;
}

/**
 * Converts a DOM keyboard event into the payload the server dispatches.
 *
 * Printable characters without Ctrl/Meta/Alt are sent with `text` so the
 * server can insert them directly (correct for non-ASCII, e.g. Polish). Other
 * keys are sent as raw key codes so Enter, Backspace, arrows, and shortcuts
 * behave natively.
 */
export function toKeyboardPayload(event: KeyLike): KeyboardPayload {
  const modifiers = readModifiers(event);
  const printable = isPrintableKey(event.key) && !(modifiers & (2 | 4 | 1));
  return {
    key: event.key,
    code: event.code,
    keyCode: event.keyCode,
    text: printable ? event.key : undefined,
    modifiers,
  };
}
