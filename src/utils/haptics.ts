export const HAPTIC_PATTERNS = {
  permissionRequested: [80, 40, 80],
  completion: 50,
  error: [100, 50, 100, 50, 100],
} as const;

export type HapticPreset = keyof typeof HAPTIC_PATTERNS;

export const permissionRequested = HAPTIC_PATTERNS.permissionRequested;
export const completion = HAPTIC_PATTERNS.completion;
export const error = HAPTIC_PATTERNS.error;

export type HapticPattern = HapticPreset | number | number[];

/**
 * Safely triggers haptic feedback via `navigator.vibrate` if supported.
 * Accepts a preset name ('permissionRequested', 'completion', 'error')
 * or a raw duration / vibration pattern.
 */
export function triggerHapticFeedback(pattern: HapticPattern = [50, 30, 50]): void {
  if (typeof navigator === 'undefined' || typeof navigator.vibrate !== 'function') {
    return;
  }

  try {
    const resolvedPattern =
      typeof pattern === 'string' && pattern in HAPTIC_PATTERNS
        ? HAPTIC_PATTERNS[pattern as HapticPreset]
        : (pattern as number | number[]);

    navigator.vibrate(resolvedPattern as number | number[]);
  } catch {
    // Browsers or WebViews may throw when vibration is restricted
  }
}
