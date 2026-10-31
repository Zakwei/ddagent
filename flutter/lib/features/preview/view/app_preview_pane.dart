import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_spinner.dart';
import 'package:ddagent_app/features/preview/data/app_preview_models.dart';
import 'package:ddagent_app/features/preview/state/app_preview_controller.dart';
import 'package:ddagent_app/features/preview/view/device_frame.dart';
import 'package:ddagent_app/features/preview/view/preview_browser_surface.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/state/workspace_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

/// Workspace preview pane (PaneKind.preview): the app an agent is building,
/// streamed from the server-side Chromium and framed as a phone, tablet,
/// browser or desktop window — the Teal-login demo page, but live and for
/// whatever the agent registered through the `preview_*` MCP tools.
class AppPreviewPane extends ConsumerStatefulWidget {
  const AppPreviewPane({super.key, required this.pane});

  final SplitPane pane;

  @override
  ConsumerState<AppPreviewPane> createState() => _AppPreviewPaneState();
}

class _AppPreviewPaneState extends ConsumerState<AppPreviewPane> {
  final _surface = GlobalKey<PreviewBrowserSurfaceState>();
  final _urlField = TextEditingController();
  PreviewSurfaceStatus _status = const PreviewSurfaceStatus();
  bool? _landscape;
  bool _fit = true;
  bool _enteringUrl = false;

  SplitPane get pane => widget.pane;
  WorkspaceController get _ws => ref.read(workspaceProvider.notifier);
  AppPreviewController get _ctrl => ref.read(appPreviewControllerProvider.notifier);

  @override
  void dispose() {
    _urlField.dispose();
    super.dispose();
  }

  static bool _isHttp(String u) => u.startsWith('http://') || u.startsWith('https://');

  void _onStatus(PreviewSurfaceStatus s) {
    if (!mounted) return;
    setState(() => _status = s);
  }

  Future<void> _openUrl(String raw) async {
    var url = raw.trim();
    if (url.isEmpty) return;
    if (!_isHttp(url)) url = 'http://$url';
    final existing = ref.read(appPreviewControllerProvider).byUrl(url);
    final target = existing ?? await _ctrl.register(url: url, device: pane.device);
    if (!mounted || target == null) return;
    setState(() => _enteringUrl = false);
    _ws.updatePane(pane.id, url: () => target.url, device: () => pane.device ?? target.device);
  }

  void _selectTarget(AppPreviewTarget t) {
    setState(() {
      _landscape = null;
      _enteringUrl = false;
    });
    _ws.updatePane(pane.id, url: () => t.url, device: () => t.device);
  }

  void _setDevice(PreviewDevice d, AppPreviewTarget? target) {
    _ws.updatePane(pane.id, device: () => d.id);
    if (target != null) unawaited(_ctrl.update(target.id, device: d.id));
  }

  void _setPlatform(PreviewPlatform p, AppPreviewTarget? target) {
    _setDevice(defaultPreviewDevice(p), target);
  }

  Future<void> _removeTarget(AppPreviewTarget t) async {
    await _ctrl.remove(t.id);
    if (!mounted) return;
    _ws.updatePane(pane.id, url: () => null);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final i18n = Translations.of(context);
    final registry = ref.watch(appPreviewControllerProvider);
    final target = registry.byUrl(pane.url);
    final device = resolvePreviewDevice(paneDevice: pane.device, target: target);
    final landscape = _landscape ?? target?.landscape ?? false;
    final hasUrl = pane.url != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _toolbar(context, registry, target, device, landscape),
        if (registry.error != null) _banner(registry.error!, onClose: _ctrl.clearError),
        if (_status.error != null && hasUrl)
          _banner(
            _status.error!,
            action: _status.fatal
                ? TextButton(
                    onPressed: () => _surface.currentState?.retry(),
                    child: Text(i18n.appPreview.retry),
                  )
                : null,
          ),
        Expanded(
          child: hasUrl && !_enteringUrl
              ? _stage(context, target, device, landscape)
              : _empty(context, registry, c),
        ),
      ],
    );
  }

  // ─── Toolbar ──────────────────────────────────────────────────────────────

  Widget _toolbar(
    BuildContext context,
    AppPreviewState registry,
    AppPreviewTarget? target,
    PreviewDevice device,
    bool landscape,
  ) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final fg = c.mutedForeground;
    Widget btn(IconData icon, String tip, VoidCallback? onPressed, {bool active = false}) =>
        IconButton(
          tooltip: tip,
          onPressed: onPressed,
          icon: Icon(icon, size: 16, color: active ? c.primary : fg),
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints.tightFor(width: 30, height: 30),
          padding: EdgeInsets.zero,
        );

    final platformIcon = switch (device.platform) {
      PreviewPlatform.mobile => LucideIcons.smartphone,
      PreviewPlatform.web => LucideIcons.globe,
      PreviewPlatform.desktop => LucideIcons.appWindow,
    };

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        color: c.muted.withValues(alpha: 0.3),
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      child: Row(
        children: [
          // Target picker: registered previews + manual URL entry.
          Flexible(
            child: PopupMenuButton<Object>(
              tooltip: i18n.appPreview.selectTarget,
              onSelected: (v) {
                if (v is AppPreviewTarget) {
                  _selectTarget(v);
                } else {
                  _urlField.text = pane.url ?? '';
                  setState(() => _enteringUrl = true);
                }
              },
              itemBuilder: (_) => [
                for (final p in registry.targets)
                  PopupMenuItem<Object>(
                    value: p,
                    child: Row(
                      children: [
                        Icon(switch (p.platform) {
                          PreviewPlatform.mobile => LucideIcons.smartphone,
                          PreviewPlatform.web => LucideIcons.globe,
                          PreviewPlatform.desktop => LucideIcons.appWindow,
                        }, size: 14),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text(
                                p.url,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: t.labelSmall?.copyWith(color: fg),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (registry.targets.isNotEmpty) const PopupMenuDivider(),
                PopupMenuItem<Object>(
                  value: 'url',
                  child: Row(
                    children: [
                      const Icon(LucideIcons.link, size: 14),
                      const SizedBox(width: 8),
                      Text(i18n.appPreview.enterUrl),
                    ],
                  ),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.monitorSmartphone, size: 14, color: fg),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        target?.title ?? pane.url ?? i18n.appPreview.selectTarget,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodySmall?.copyWith(color: c.foreground),
                      ),
                    ),
                    Icon(LucideIcons.chevronDown, size: 16, color: fg),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          // Platform family.
          PopupMenuButton<PreviewPlatform>(
            tooltip: i18n.appPreview.platform.label,
            onSelected: (p) => _setPlatform(p, target),
            itemBuilder: (_) => [
              for (final p in PreviewPlatform.values)
                CheckedPopupMenuItem(
                  value: p,
                  checked: p == device.platform,
                  child: Text(switch (p) {
                    PreviewPlatform.mobile => i18n.appPreview.platform.mobile,
                    PreviewPlatform.web => i18n.appPreview.platform.web,
                    PreviewPlatform.desktop => i18n.appPreview.platform.desktop,
                  }),
                ),
            ],
            child: SizedBox(
              width: 30,
              height: 30,
              child: Icon(platformIcon, size: 16, color: c.primary),
            ),
          ),
          // Device preset within the platform.
          PopupMenuButton<PreviewDevice>(
            tooltip: i18n.appPreview.device,
            onSelected: (d) => _setDevice(d, target),
            itemBuilder: (_) => [
              for (final d in kPreviewDevices)
                if (d.platform == device.platform)
                  CheckedPopupMenuItem(
                    value: d,
                    checked: d.id == device.id,
                    child: Text('${d.label}  ·  ${d.width}×${d.height}'),
                  ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(device.label, style: t.labelSmall?.copyWith(color: fg)),
                  Icon(LucideIcons.chevronDown, size: 16, color: fg),
                ],
              ),
            ),
          ),
          if (device.isMobile)
            btn(LucideIcons.rotateCcw, i18n.appPreview.rotate, () {
              final next = !landscape;
              setState(() => _landscape = next);
              if (target != null) unawaited(_ctrl.update(target.id, landscape: next));
            }, active: landscape),
          btn(
            LucideIcons.arrowLeft,
            i18n.appPreview.back,
            _status.canGoBack ? () => _surface.currentState?.back() : null,
          ),
          btn(
            LucideIcons.refreshCw,
            i18n.appPreview.reload,
            pane.url == null ? null : () => _surface.currentState?.reload(),
          ),
          btn(
            _fit ? LucideIcons.scan : LucideIcons.maximize,
            _fit ? i18n.appPreview.actualSize : i18n.appPreview.fit,
            () => setState(() => _fit = !_fit),
          ),
          btn(
            LucideIcons.externalLink,
            i18n.appPreview.openExternal,
            pane.url == null
                ? null
                : () => unawaited(
                    launchUrl(
                      Uri.parse(_status.url.isEmpty ? pane.url! : _status.url),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
          ),
          if (target != null)
            btn(
              LucideIcons.x,
              i18n.appPreview.removeTarget,
              () => unawaited(_removeTarget(target)),
            ),
        ],
      ),
    );
  }

  Widget _banner(String message, {Widget? action, VoidCallback? onClose}) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      color: c.destructive.withValues(alpha: 0.1),
      child: Row(
        children: [
          Expanded(
            child: Text(message, style: t.bodySmall?.copyWith(color: c.destructive)),
          ),
          ?action,
          if (onClose != null)
            IconButton(
              onPressed: onClose,
              icon: Icon(LucideIcons.x, size: 14, color: c.destructive),
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }

  // ─── Stage ────────────────────────────────────────────────────────────────

  Widget _stage(
    BuildContext context,
    AppPreviewTarget? target,
    PreviewDevice device,
    bool landscape,
  ) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final viewport = device.viewportFor(landscape);
    final natural = deviceFrameSize(device, viewport);
    final framed = SizedBox.fromSize(
      size: natural,
      child: DeviceFrame(
        device: device,
        viewport: viewport,
        title: _status.title,
        url: _status.url.isEmpty ? (pane.url ?? '') : _status.url,
        loading: _status.loading,
        child: PreviewBrowserSurface(
          key: _surface,
          paneId: pane.id,
          viewport: viewport,
          url: pane.url,
          device: device.id,
          reloadToken: target?.reloadToken ?? 0,
          onStatus: _onStatus,
        ),
      ),
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.6, -0.8),
          radius: 1.4,
          colors: [Color(0xFF1C2A33), Color(0xFF17181C)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: _fit
                  ? FittedBox(fit: BoxFit.contain, child: framed)
                  : SingleChildScrollView(
                      child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: framed),
                    ),
            ),
          ),
          if (!_status.ready)
            Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.35),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppSpinner(),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          i18n.appPreview.starting,
                          style: t.bodySmall?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          // Caption: title · device, agent note (demo-page "Built with Flutter" line).
          Positioned(
            left: 0,
            right: 0,
            bottom: 4,
            child: IgnorePointer(
              child: Text(
                [
                  target?.title ?? pane.url ?? '',
                  '${device.label} ${viewport.width.round()}×${viewport.height.round()}',
                  ?target?.note,
                ].where((s) => s.isNotEmpty).join('  ·  '),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.labelSmall?.copyWith(color: c.mutedForeground),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Empty state / URL entry ──────────────────────────────────────────────

  Widget _empty(BuildContext context, AppPreviewState registry, AppColors c) {
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(LucideIcons.monitorSmartphone, size: 36, color: c.mutedForeground),
              const SizedBox(height: AppSpacing.md),
              Text(i18n.appPreview.emptyTitle, textAlign: TextAlign.center, style: t.titleSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                i18n.appPreview.emptyBody,
                textAlign: TextAlign.center,
                style: t.bodySmall?.copyWith(color: c.mutedForeground),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: AppInput(
                      controller: _urlField,
                      hint: i18n.appPreview.urlHint,
                      autofocus: _enteringUrl,
                      onSubmitted: (v) => unawaited(_openUrl(v)),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppButton(
                    size: AppButtonSize.sm,
                    onPressed: () => unawaited(_openUrl(_urlField.text)),
                    child: Text(i18n.appPreview.open),
                  ),
                ],
              ),
              if (registry.targets.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                for (final p in registry.targets)
                  ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    leading: Icon(
                      switch (p.platform) {
                        PreviewPlatform.mobile => LucideIcons.smartphone,
                        PreviewPlatform.web => LucideIcons.globe,
                        PreviewPlatform.desktop => LucideIcons.appWindow,
                      },
                      size: 16,
                      color: c.mutedForeground,
                    ),
                    title: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(p.url, maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () => _selectTarget(p),
                  ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Text(
                i18n.appPreview.mcpHint,
                textAlign: TextAlign.center,
                style: t.labelSmall?.copyWith(color: c.mutedForeground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
