import 'package:web/web.dart' as web;

/// `document.execCommand('copy')` fallback — `navigator.clipboard` only exists
/// in secure contexts, so `Clipboard.setData` rejects outright when the app is
/// served over plain HTTP (the flutter-web deployment). execCommand still
/// works there while the tap's transient activation is live.
bool legacyClipboardCopy(String text) {
  final area = web.document.createElement('textarea') as web.HTMLTextAreaElement;
  area.value = text;
  area.style.cssText = 'position:fixed;top:0;left:0;opacity:0';
  web.document.body!.appendChild(area);
  area
    ..focus()
    ..select();
  try {
    return web.document.execCommand('copy');
  } on Object {
    return false;
  } finally {
    area.remove();
  }
}
