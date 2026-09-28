import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';

/// How the editor should present a file. Mirrors the React editor's
/// previewableFile.ts / binaryFile.ts split: text renders in CodeEditor,
/// markdown gets an edit/preview toggle, images use AuthImage, media and
/// binary fall back to an info/hex card.
enum EditorFileKind { text, markdown, image, media, binary }

const _markdownExt = {'md', 'markdown', 'mdx'};

// Audio/video the desktop UI could preview natively — Flutter can't decode
// them without a plugin, so they get the "media" card instead of hex dump.
const _mediaExt = {
  'mp3',
  'wav',
  'm4a',
  'aac',
  'flac',
  'ogg',
  'oga',
  'opus',
  'weba',
  'mp4',
  'webm',
  'ogv',
  'mov',
  'm4v',
  'avi',
  'mkv',
  'flv',
  'wmv',
};

// Ported from src/components/code-editor/utils/binaryFile.ts.
const _binaryExt = {
  'zip',
  'tar',
  'gz',
  'rar',
  '7z',
  'bz2',
  'xz',
  'exe',
  'dll',
  'so',
  'dylib',
  'app',
  'dmg',
  'msi',
  'pdf',
  'doc',
  'docx',
  'xls',
  'xlsx',
  'ppt',
  'pptx',
  'odt',
  'ods',
  'odp',
  'ttf',
  'otf',
  'woff',
  'woff2',
  'eot',
  'db',
  'sqlite',
  'sqlite3',
  'bin',
  'dat',
  'iso',
  'img',
  'class',
  'jar',
  'war',
  'pyc',
  'pyo',
};

String _ext(String path) {
  final dot = path.lastIndexOf('.');
  return dot < 0 ? '' : path.substring(dot + 1).toLowerCase();
}

EditorFileKind editorFileKind(String path) {
  final ext = _ext(path);
  if (_markdownExt.contains(ext)) return EditorFileKind.markdown;
  if (isImageFile(path)) return EditorFileKind.image;
  if (_mediaExt.contains(ext)) return EditorFileKind.media;
  if (_binaryExt.contains(ext)) return EditorFileKind.binary;
  return EditorFileKind.text;
}

/// Whether the tab needs its text buffer loaded (everything but media kinds
/// that only render a preview anyway).
bool editorKindNeedsContent(EditorFileKind kind) =>
    kind == EditorFileKind.text || kind == EditorFileKind.markdown;

/// `highlight` package language id for syntax highlighting, or null when the
/// extension is unknown (plain text, no highlighting attempt).
String? editorLanguage(String path) {
  final name = path.split('/').last.toLowerCase();
  // Extensionless well-known names first.
  const byName = {
    'dockerfile': 'dockerfile',
    'makefile': 'makefile',
    'cmakelists.txt': 'cmake',
    '.gitignore': 'bash',
    '.env': 'ini',
  };
  if (byName.containsKey(name)) return byName[name];
  const byExt = {
    'dart': 'dart',
    'js': 'javascript',
    'mjs': 'javascript',
    'cjs': 'javascript',
    'jsx': 'javascript',
    'ts': 'typescript',
    'tsx': 'typescript',
    'json': 'json',
    'jsonc': 'json',
    'yaml': 'yaml',
    'yml': 'yaml',
    'toml': 'ini',
    'ini': 'ini',
    'cfg': 'ini',
    'conf': 'ini',
    'env': 'ini',
    'py': 'python',
    'rb': 'ruby',
    'rs': 'rust',
    'go': 'go',
    'java': 'java',
    'kt': 'kotlin',
    'kts': 'kotlin',
    'scala': 'scala',
    'c': 'c',
    'h': 'c',
    'cpp': 'cpp',
    'cc': 'cpp',
    'cxx': 'cpp',
    'hpp': 'cpp',
    'cs': 'csharp',
    'm': 'objectivec',
    'mm': 'objectivec',
    'php': 'php',
    'swift': 'swift',
    'r': 'r',
    'lua': 'lua',
    'pl': 'perl',
    'pm': 'perl',
    'sh': 'bash',
    'bash': 'bash',
    'zsh': 'bash',
    'fish': 'bash',
    'ps1': 'powershell',
    'bat': 'dos',
    'cmd': 'dos',
    'html': 'xml',
    'htm': 'xml',
    'xml': 'xml',
    'xsl': 'xml',
    'vue': 'xml',
    'svg': 'xml',
    'css': 'css',
    'scss': 'scss',
    'sass': 'scss',
    'less': 'less',
    'sql': 'sql',
    'graphql': 'graphql',
    'gql': 'graphql',
    'dockerfile': 'dockerfile',
    'mk': 'makefile',
    'cmake': 'cmake',
    'gradle': 'gradle',
    'tf': 'hcl',
    'proto': 'protobuf',
    'md': 'markdown',
    'markdown': 'markdown',
    'diff': 'diff',
    'patch': 'diff',
    'tex': 'latex',
    'hs': 'haskell',
    'ex': 'elixir',
    'exs': 'elixir',
    'erl': 'erlang',
    'clj': 'clojure',
    'cljs': 'clojure',
    'vim': 'vim',
    'wasm': 'wasm',
    'nginx': 'nginx',
  };
  return byExt[_ext(path)];
}
