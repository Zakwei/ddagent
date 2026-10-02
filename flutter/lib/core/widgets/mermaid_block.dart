import 'dart:convert';

import 'package:ddagent_app/core/widgets/code_block.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Mermaid diagram (T16.5/16.7 decision): no native Flutter mermaid renderer
/// exists. The server already ships a `/island/mermaid?code=<b64>` WebView
/// island — the Flutter client renders the raw highlighted source inline plus
/// an "Open diagram" action that launches the island in the system browser.
/// A webview island embed can replace the fallback once `webview_flutter`
/// (or per-platform equivalent) is pulled in for the preview feature.
class MermaidBlock extends StatelessWidget {
  const MermaidBlock({super.key, required this.code, required this.serverBaseUrl});

  final String code;
  final String serverBaseUrl;

  Uri get _islandUri {
    final b64 = base64Url.encode(utf8.encode(code));
    return Uri.parse('$serverBaseUrl/island/mermaid?code=$b64');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CodeBlock(code: code, language: 'mermaid'),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.open_in_new, size: 14),
            label: const Text('Open diagram'),
            onPressed: () => launchUrl(_islandUri, mode: LaunchMode.externalApplication),
          ),
        ),
      ],
    );
  }
}
