/// Basename/dirname for server paths, which may be POSIX (`/a/b`) or
/// Windows (`C:\a\b`, or mixed `C:/a\b`) depending on the server's OS.
library;

final _separator = RegExp(r'[\\/]');

/// Last segment of [path]; a trailing separator is ignored.
String pathBasename(String path) {
  final trimmed = path.length > 1 && _separator.hasMatch(path[path.length - 1])
      ? path.substring(0, path.length - 1)
      : path;
  return trimmed.substring(trimmed.lastIndexOf(_separator) + 1);
}

/// Parent of [path] with its original separators kept, so it can be sent back
/// to the server (`C:\a\b.txt` → `C:\a`, `/a` → `/`). Empty when [path] has no
/// separator (e.g. `C:`).
String pathDirname(String path) {
  final i = path.lastIndexOf(_separator);
  if (i < 0) return '';
  return i == 0 ? path[0] : path.substring(0, i);
}
