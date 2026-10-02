import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

Future<void> saveBytes(String path, List<int> bytes) =>
    throw UnsupportedError('Filesystem download is not supported on web');

/// Browser download — Blob + object URL + synthetic anchor click
/// (downloadText parity with the web app's chatExport helpers).
Future<String?> saveTextFile(String filename, String content, String mime) async {
  final blob = web.Blob([content.toJS].toJS, web.BlobPropertyBag(type: mime));
  final url = web.URL.createObjectURL(blob);
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement
    ..href = url
    ..download = filename;
  web.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
  web.URL.revokeObjectURL(url);
  return null;
}

/// Browser download for binary content — ChatMessageFiles blob parity.
Future<String?> saveBlob(String filename, List<int> bytes, String mime) async {
  final data = bytes is Uint8List ? bytes : Uint8List.fromList(bytes);
  final blob = web.Blob([data.toJS].toJS, web.BlobPropertyBag(type: mime));
  final url = web.URL.createObjectURL(blob);
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement
    ..href = url
    ..download = filename;
  web.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
  web.URL.revokeObjectURL(url);
  return null;
}

/// openHtmlPreview parity — blob URL in a new tab renders the file with the
/// browser's own engine.
Future<void> previewHtml(String filename, String html) async {
  final blob = web.Blob([html.toJS].toJS, web.BlobPropertyBag(type: 'text/html'));
  web.window.open(web.URL.createObjectURL(blob), '_blank');
}

/// chatExport.ts downloadPDF parity — render the export HTML in a popup and
/// let the browser print dialog save it as PDF.
Future<void> printHtml(String html) async {
  final win = web.window.open('', '_blank', 'width=800,height=600');
  if (win == null) throw Exception('Popup blocked');
  win.document.write(html.toJS);
  win.document.close();
  // Delay the dialog so the written content finishes loading.
  await Future<void>.delayed(const Duration(milliseconds: 250));
  win.print();
}
