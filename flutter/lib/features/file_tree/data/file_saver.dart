import 'package:ddagent_app/features/file_tree/data/file_saver_io.dart'
    if (dart.library.js_interop) 'package:ddagent_app/features/file_tree/data/file_saver_web.dart';

/// Writes bytes to an absolute path — native only, stubbed on web so this
/// library compiles for `flutter build web`.
Future<void> saveBytesToPath(String path, List<int> bytes) =>
    saveBytes(path, bytes);

/// Hands [content] to the platform as a download (web: browser download,
/// native: temp file). Returns the saved path on native, null on web.
Future<String?> downloadText(
  String filename,
  String content, {
  String mime = 'text/plain',
}) => saveTextFile(filename, content, mime);

/// Binary variant — attachment downloads (web ChatMessageFiles parity).
Future<String?> downloadBytes(
  String filename,
  List<int> bytes, {
  String mime = 'application/octet-stream',
}) => saveBlob(filename, bytes, mime);

/// Opens [html] in a new window and triggers the browser print dialog —
/// the web app's "PDF (Print to File)" path. Native: unsupported.
Future<void> printHtmlDocument(String html) => printHtml(html);

/// Renders an .html/.htm buffer in a new tab — web `openHtmlPreview` parity.
/// Native: writes a temp file and asks the OS to open it (external browser).
Future<void> previewHtmlFile(String filename, String html) =>
    previewHtml(filename, html);
