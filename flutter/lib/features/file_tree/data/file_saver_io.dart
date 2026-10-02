import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

Future<void> saveBytes(String path, List<int> bytes) => File(path).writeAsBytes(bytes, flush: true);

/// Native "download": writes to the system temp dir and returns the path.
Future<String?> saveTextFile(String filename, String content, String mime) async {
  final dir = Directory.systemTemp.createTempSync('ddagent_export');
  final file = File('${dir.path}/$filename');
  await file.writeAsString(content, flush: true);
  return file.path;
}

/// Native "download": writes to the system temp dir and returns the path.
Future<String?> saveBlob(String filename, List<int> bytes, String mime) async {
  final dir = Directory.systemTemp.createTempSync('ddagent_download');
  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}

/// ponytail: no WebView dep — a temp file + file:// is the cheapest real
/// browser render on desktop; Android browsers may refuse file:// URIs.
Future<void> previewHtml(String filename, String html) async {
  final dir = Directory.systemTemp.createTempSync('ddagent_preview');
  final file = File('${dir.path}/$filename');
  await file.writeAsString(html, flush: true);
  await launchUrl(Uri.file(file.path), mode: LaunchMode.externalApplication);
}

Future<void> printHtml(String html) => throw Exception('Print-to-file is not supported on native');
