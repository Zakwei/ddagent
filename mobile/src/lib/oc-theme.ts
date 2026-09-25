/**
 * opencode "CLI 1:1" chat palette — verbatim from the web `src/index.css`
 * `.oc-chat` block. Kept as a PURE module (no react-native import) so the
 * remap can be unit-tested in the Node self-check runner; `theme.tsx`
 * re-exports these for the app.
 *
 * The web chat surface is ALWAYS dark regardless of the app theme
 * (ChatInterface.tsx renders `className="oc-chat dark"`), so the native chat
 * uses this fixed palette instead of the app's `useTheme().colors`.
 */
export const ocChatColors = {
  bg: '#0a0a0a',
  panel: '#141414',
  elem: '#1e1e1e',
  menu: '#282828',
  border: '#484848',
  borderSubtle: '#3c3c3c',
  text: '#eeeeee',
  muted: '#808080',
  accent: '#fab283',
  secondary: '#5c9cf5',
  info: '#56b6c2',
  success: '#7fd88f',
  warning: '#f5a742',
  error: '#e06c75',
  diffAdd: '#4fd6be',
  diffDel: '#c53b53',
  diffAddBg: '#20303b',
  diffDelBg: '#37222c',
  diffCtx: '#828bb8',
} as const;

export type OcChatColors = typeof ocChatColors;

/** Monospace stack shared by the web `.oc-chat` surface. */
export const MONO_FONT = 'Menlo';
export const CHAT_FONT_SIZE = 13;

export interface OcChatTheme {
  background: string;
  foreground: string;
  card: string;
  cardForeground: string;
  popover: string;
  popoverForeground: string;
  primary: string;
  primaryForeground: string;
  secondary: string;
  secondaryForeground: string;
  muted: string;
  mutedForeground: string;
  accent: string;
  accentForeground: string;
  destructive: string;
  destructiveForeground: string;
  border: string;
  input: string;
  ring: string;
}

/**
 * The `.oc-chat` CSS remaps every shadcn token onto the opencode palette
 * (`--background: 0 0% 4%`, `--primary: 24 92% 75%`, …). Mirror that remap as
 * a `ThemeColors`-shaped object so existing `colors.*` consumers inside the
 * chat resolve to CLI colors with no per-call-site changes.
 */
export const ocChatTheme: OcChatTheme = {
  background: ocChatColors.bg,
  foreground: ocChatColors.text,
  card: ocChatColors.panel,
  cardForeground: ocChatColors.text,
  popover: ocChatColors.menu,
  popoverForeground: ocChatColors.text,
  primary: ocChatColors.accent,
  primaryForeground: ocChatColors.bg,
  secondary: ocChatColors.elem,
  secondaryForeground: ocChatColors.text,
  muted: ocChatColors.elem,
  mutedForeground: ocChatColors.muted,
  accent: ocChatColors.menu,
  accentForeground: ocChatColors.text,
  destructive: ocChatColors.error,
  destructiveForeground: ocChatColors.text,
  border: ocChatColors.border,
  input: ocChatColors.border,
  ring: ocChatColors.accent,
};
