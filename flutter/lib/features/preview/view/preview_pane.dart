import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/preview/state/preview_controller.dart';
import 'package:ddagent_app/features/preview/view/preview_embed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Live dev-server preview (port of preview/view/PreviewPane.tsx): a dropdown
/// of localhost ports attributed to this project, a reload button and an
/// open-external action above the proxied page. On web the page renders in an
/// iframe via [previewEmbed]; other platforms get the URL + open hint (no
/// in-tree webview plugin).
class PreviewPane extends ConsumerStatefulWidget {
  const PreviewPane({super.key, this.projectPath});

  /// `projects.path` — ports are filtered by process cwd; null = all ports.
  final String? projectPath;

  @override
  ConsumerState<PreviewPane> createState() => _PreviewPaneState();
}

class _PreviewPaneState extends ConsumerState<PreviewPane> {
  int _reloadTick = 0;
  Uri? _embedUrl;
  int _embedPort = -1;

  Future<void> _resolveUrl() async {
    final ctrl = ref.read(previewProvider(widget.projectPath).notifier);
    final url = await ctrl.proxyUrl();
    if (!mounted) return;
    setState(() {
      _embedUrl = url;
      _embedPort =
          ref.read(previewProvider(widget.projectPath)).selectedPort?.port ??
          -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(previewProvider(widget.projectPath));
    final ctrl = ref.read(previewProvider(widget.projectPath).notifier);
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final sel = state.selectedPort;

    // The embed URL is async (needs the auth token) — re-resolve whenever the
    // selection or the reload tick changes.
    if (sel != null && (_embedPort != sel.port || _embedUrl == null)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _resolveUrl());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          decoration: BoxDecoration(
            color: c.muted.withValues(alpha: 0.3),
            border: Border(bottom: BorderSide(color: c.border)),
          ),
          child: Row(
            children: [
              Icon(Icons.public, size: 14, color: c.mutedForeground),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: DropdownButton<int>(
                  value: sel?.port,
                  isDense: true,
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  style: t.bodySmall,
                  hint: Text(
                    state.error != null
                        ? 'Could not load ports'
                        : 'No dev servers detected',
                    style: t.bodySmall?.copyWith(color: c.mutedForeground),
                  ),
                  items: [
                    for (final p in state.ports)
                      DropdownMenuItem(
                        value: p.port,
                        child: Text(
                          p.processName != null
                              ? ':${p.port} — ${p.processName}'
                              : ':${p.port}',
                        ),
                      ),
                  ],
                  onChanged: (p) {
                    if (p != null) ctrl.selectPort(p);
                  },
                ),
              ),
              IconButton(
                tooltip: 'Reload preview',
                onPressed: sel == null
                    ? null
                    : () => setState(() {
                        _reloadTick++;
                        _embedUrl = null;
                      }),
                icon: Icon(Icons.refresh, size: 16, color: c.mutedForeground),
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                tooltip: 'Open in system browser',
                onPressed: sel == null
                    ? null
                    : () async {
                        final url = _embedUrl ?? await ctrl.proxyUrl();
                        if (url != null) {
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                icon: Icon(
                  Icons.open_in_new,
                  size: 16,
                  color: c.mutedForeground,
                ),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
        if (state.error != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 4,
            ),
            color: c.destructive.withValues(alpha: 0.1),
            child: Text(
              state.error!,
              style: t.bodySmall?.copyWith(color: c.destructive),
            ),
          ),
        Expanded(
          child: sel == null
              ? _empty(state)
              : (previewEmbedSupported
                    ? (_embedUrl == null
                          ? const Center(child: CircularProgressIndicator())
                          : previewEmbed(
                              url: _embedUrl!.toString(),
                              reloadTick: _reloadTick,
                            ))
                    : _desktopFallback(sel.port)),
        ),
      ],
    );
  }

  Widget _empty(PreviewState state) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    if (state.loading && state.ports.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.public_off, size: 28, color: c.mutedForeground),
            const SizedBox(height: AppSpacing.sm),
            Text(
              state.error != null
                  ? 'Could not load ports'
                  : 'No dev servers detected',
              textAlign: TextAlign.center,
              style: t.bodySmall?.copyWith(color: c.mutedForeground),
            ),
            if (state.error != null)
              TextButton(
                onPressed: () => unawaited(
                  ref
                      .read(previewProvider(widget.projectPath).notifier)
                      .refresh(),
                ),
                child: const Text('Retry'),
              ),
            if (state.error == null)
              Text(
                'Start a dev server (npm run dev, flutter run -d web-server…)\n'
                'and its port appears here.',
                textAlign: TextAlign.center,
                style: t.labelSmall?.copyWith(
                  color: c.mutedForeground.withValues(alpha: 0.7),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _desktopFallback(int port) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.open_in_browser, size: 28, color: c.mutedForeground),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Embedded preview is available on the web build',
            style: t.bodySmall?.copyWith(color: c.mutedForeground),
          ),
          const SizedBox(height: AppSpacing.xs),
          SelectableText(
            _embedUrl?.toString() ?? 'http://localhost:$port',
            style: t.bodySmall?.copyWith(fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }
}
