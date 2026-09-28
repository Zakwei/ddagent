import 'package:ddagent_app/features/browser/view/remote_browser_view.dart';
import 'package:flutter/material.dart';

/// Workspace browser pane (PaneKind.browser): the remote-Chromium stream plus
/// its address bar, with the URL persisted on the pane so reloads restore it.
class WebBrowserPane extends StatelessWidget {
  const WebBrowserPane({super.key, this.url, this.onUrlChange});

  final String? url;
  final ValueChanged<String>? onUrlChange;

  @override
  Widget build(BuildContext context) =>
      RemoteBrowserView(url: url, onUrlChange: onUrlChange);
}
