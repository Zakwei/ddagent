/** Prism syntax highlighting for chat code blocks — same highlighter the web
 *  chat uses (`react-syntax-highlighter` oneDark/oneLight themes are baked here
 *  as literal HSL colors so RN needs no CSS).
 *
 *  Pure w.r.t. React (Prism only), so it stays runnable under plain Node. */

import Prism from 'prismjs';
import 'prismjs/components/prism-markup.js';
import 'prismjs/components/prism-css.js';
import 'prismjs/components/prism-clike.js';
import 'prismjs/components/prism-javascript.js';
import 'prismjs/components/prism-jsx.js';
import 'prismjs/components/prism-typescript.js';
import 'prismjs/components/prism-tsx.js';
import 'prismjs/components/prism-json.js';
import 'prismjs/components/prism-bash.js';
import 'prismjs/components/prism-python.js';
import 'prismjs/components/prism-markdown.js';
import 'prismjs/components/prism-yaml.js';
import 'prismjs/components/prism-sql.js';
import 'prismjs/components/prism-go.js';
import 'prismjs/components/prism-rust.js';
import 'prismjs/components/prism-java.js';
import 'prismjs/components/prism-c.js';
import 'prismjs/components/prism-cpp.js';
import 'prismjs/components/prism-diff.js';
import 'prismjs/components/prism-toml.js';

export interface SyntaxToken {
  text: string;
  /** Prism token types from outermost to innermost (for style priority). */
  types: string[];
}

interface ThemeStyle {
  color: string;
  italic?: boolean;
}

// Token groups → color, ported from `react-syntax-highlighter` prism oneDark /
// oneLight `[class*="language-"]` style sheets.
const DARK: Record<string, ThemeStyle> = {
  default: { color: 'hsl(220, 14%, 71%)' },
  comment: { color: 'hsl(220, 10%, 40%)', italic: true },
  number: { color: 'hsl(29, 54%, 61%)' },
  keyword: { color: 'hsl(286, 60%, 67%)' },
  property: { color: 'hsl(355, 65%, 65%)' },
  string: { color: 'hsl(95, 38%, 62%)' },
  function: { color: 'hsl(207, 82%, 66%)' },
  url: { color: 'hsl(187, 47%, 55%)' },
};

const LIGHT: Record<string, ThemeStyle> = {
  default: { color: 'hsl(230, 8%, 24%)' },
  comment: { color: 'hsl(230, 4%, 64%)', italic: true },
  number: { color: 'hsl(35, 99%, 36%)' },
  keyword: { color: 'hsl(301, 63%, 40%)' },
  property: { color: 'hsl(5, 74%, 59%)' },
  string: { color: 'hsl(119, 34%, 47%)' },
  function: { color: 'hsl(221, 87%, 60%)' },
  url: { color: 'hsl(198, 99%, 37%)' },
};

// Prism type → theme bucket. First match wins.
const BUCKETS: [string[], keyof typeof DARK][] = [
  [['comment', 'prolog', 'cdata', 'blockquote'], 'comment'],
  [['number', 'boolean', 'constant', 'symbol', 'attr-name', 'class-name', 'atrule', 'builtin', 'char', 'inserted', 'regex'], 'number'],
  [['keyword', 'rule', 'important', 'deleted', 'at-rule'], 'keyword'],
  [['tag', 'selector', 'property', 'attr-value', 'string', 'title'], 'property'],
  [['function', 'operator', 'variable', 'punctuation'], 'function'],
  [['url', 'namespace'], 'url'],
];

const tokenBucket = (types: string[]): keyof typeof DARK => {
  for (const [names, bucket] of BUCKETS) {
    for (const type of types) {
      if (names.includes(type)) return bucket;
    }
  }
  return 'default';
};

export function syntaxStyleFor(types: string[], isDark: boolean): ThemeStyle {
  return (isDark ? DARK : LIGHT)[tokenBucket(types)];
}

export const normalizeLanguage = (language?: string): string => {
  const lang = (language ?? '').trim().toLowerCase();
  if (!lang || lang === 'text' || lang === 'plaintext') return 'text';
  if (lang === 'sh' || lang === 'shell' || lang === 'zsh') return 'bash';
  if (lang === 'yml') return 'yaml';
  if (lang === 'js') return 'javascript';
  if (lang === 'ts') return 'typescript';
  if (lang === 'py') return 'python';
  if (lang === 'md') return 'markdown';
  if (lang === 'html' || lang === 'xml' || lang === 'svg') return 'markup';
  return Prism.languages[lang] ? lang : 'text';
};

export function languageLabel(language?: string): string {
  const resolved = normalizeLanguage(language);
  if (resolved === 'text') return language && language.trim() ? language : 'Text';
  return resolved.charAt(0).toUpperCase() + resolved.slice(1);
}

const flatten = (token: unknown, parentTypes: string[], out: SyntaxToken[]): void => {
  if (typeof token === 'string') {
    if (token) out.push({ text: token, types: parentTypes });
    return;
  }
  if (Array.isArray(token)) {
    for (const t of token) flatten(t, parentTypes, out);
    return;
  }
  if (token && typeof token === 'object') {
    const t = token as { type?: string; alias?: string | string[]; content?: unknown };
    const aliases = Array.isArray(t.alias) ? t.alias : t.alias ? [t.alias] : [];
    const types = [...(t.type ? [t.type] : []), ...aliases, ...parentTypes];
    flatten(t.content, types, out);
  }
};

/** Tokenizes code into flat, style-ready spans. Unknown/empty → one span. */
export function tokenizeCode(code: string, language?: string): SyntaxToken[] {
  const raw = (code ?? '').replace(/\n$/, '');
  const lang = normalizeLanguage(language);
  const grammar = lang === 'text' ? null : Prism.languages[lang];
  if (!grammar) {
    return raw ? [{ text: raw, types: [] }] : [];
  }
  try {
    const out: SyntaxToken[] = [];
    flatten(Prism.tokenize(raw, grammar), [], out);
    return out;
  } catch {
    return raw ? [{ text: raw, types: [] }] : [];
  }
}
