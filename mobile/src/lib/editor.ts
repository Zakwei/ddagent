export type PreviewKind = 'code' | 'markdown' | 'image' | 'audio' | 'video' | 'pdf' | 'binary';

const IMAGE_EXT = new Set(['png', 'jpg', 'jpeg', 'gif', 'svg', 'webp', 'ico', 'bmp', 'avif', 'apng']);
const AUDIO_EXT = new Set(['mp3', 'wav', 'm4a', 'aac', 'flac', 'opus', 'oga', 'ogg', 'weba']);
const VIDEO_EXT = new Set(['mp4', 'webm', 'ogv', 'mov', 'm4v']);
const MARKDOWN_EXT = new Set(['md', 'markdown']);
const BINARY_EXT = new Set([
  'zip', 'tar', 'gz', 'bz2', 'xz', '7z', 'rar', 'jar', 'war', 'exe', 'dll', 'so', 'dylib', 'bin', 'dat',
  'iso', 'dmg', 'class', 'o', 'a', 'pyc', 'woff', 'woff2', 'ttf', 'otf', 'eot',
  'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'odt', 'ods', 'sqlite', 'db',
]);

export function fileExtensionOf(path: string): string {
  const name = path.split(/[\\/]/).pop() ?? path;
  const dot = name.lastIndexOf('.');
  if (dot <= 0) return '';
  return name.slice(dot + 1).toLowerCase();
}

export function isMarkdownFile(path: string): boolean {
  return MARKDOWN_EXT.has(fileExtensionOf(path));
}

export function previewKindFor(path: string): PreviewKind {
  const ext = fileExtensionOf(path);
  if (IMAGE_EXT.has(ext)) return 'image';
  if (AUDIO_EXT.has(ext)) return 'audio';
  if (VIDEO_EXT.has(ext)) return 'video';
  if (ext === 'pdf') return 'pdf';
  if (MARKDOWN_EXT.has(ext)) return 'markdown';
  if (BINARY_EXT.has(ext)) return 'binary';
  return 'code';
}

/** Maps a file extension to a Prism grammar name (broader than web's set). */
const EXT_LANGUAGE: Record<string, string> = {
  js: 'javascript', mjs: 'javascript', cjs: 'javascript', jsx: 'jsx',
  ts: 'typescript', tsx: 'tsx', mts: 'typescript', cts: 'typescript',
  py: 'python', rb: 'ruby', go: 'go', rs: 'rust', java: 'java',
  c: 'c', h: 'c', cpp: 'cpp', cc: 'cpp', cxx: 'cpp', hpp: 'cpp',
  cs: 'csharp', php: 'php', swift: 'swift', kt: 'kotlin',
  json: 'json', jsonc: 'json', yaml: 'yaml', yml: 'yaml', toml: 'toml', ini: 'ini',
  sh: 'bash', bash: 'bash', zsh: 'bash', fish: 'bash',
  html: 'markup', htm: 'markup', xml: 'markup', svg: 'markup', vue: 'markup',
  css: 'css', scss: 'scss', less: 'less',
  md: 'markdown', markdown: 'markdown',
  sql: 'sql', graphql: 'graphql',
  env: 'bash', gitignore: 'bash', dockerfile: 'docker',
};

export function languageForPath(path: string): string {
  const ext = fileExtensionOf(path);
  return EXT_LANGUAGE[ext] ?? ext;
}

export interface CodeLine {
  number: number;
  text: string;
}

/** Splits content into lines with 1-based numbers; keeps empty trailing-free lines. */
export function splitLines(content: string): CodeLine[] {
  const parts = content.replace(/\r\n?/g, '\n').split('\n');
  if (parts.length > 1 && parts[parts.length - 1] === '') parts.pop();
  return parts.map((text, i) => ({ number: i + 1, text }));
}

/** Indices of hunk/change marker rows inside a `buildDiffLines`-style array. */
export function changeIndices(kinds: string[]): number[] {
  const out: number[] = [];
  kinds.forEach((kind, i) => {
    if (kind === 'hunk') out.push(i);
  });
  return out;
}

/** Cycles change navigation; wraps at both ends. Returns -1 when empty. */
export function stepChange(current: number, total: number, delta: number): number {
  if (total <= 0) return -1;
  if (current < 0) return delta >= 0 ? 0 : total - 1;
  return (current + delta + total) % total;
}
