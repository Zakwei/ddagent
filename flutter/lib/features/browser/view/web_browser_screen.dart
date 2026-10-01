import 'package:ddagent_app/core/widgets/subpage_header.dart';
import 'package:ddagent_app/features/browser/view/browser_use_panel.dart';
import 'package:ddagent_app/features/browser/view/remote_browser_view.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Standalone `/web` page — the same remote-Chromium stream that runs inside
/// workspace browser panes, hosted as a full route (the legacy app keeps the
/// remote browser pane-only; this route replaces the placeholder).
class WebBrowserScreen extends StatelessWidget {
  const WebBrowserScreen({super.key, this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SubpageHeader(title: 'Web', icon: LucideIcons.globe),
            Expanded(child: RemoteBrowserView(url: url)),
          ],
        ),
      ),
    );
  }
}

/// Standalone `/browser` page — hosts `BrowserUsePanel` (the agent-browser
/// monitor tab the web app gates behind the browser-use setting).
class BrowserUseScreen extends StatelessWidget {
  const BrowserUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: BrowserUsePanel()));
  }
}
