import 'dart:async';
import 'dart:convert';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_nav_menu.dart';
import 'package:ddagent_app/features/browser_use/data/browser_use_repository.dart';
import 'package:ddagent_app/features/browser_use/state/browser_use_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

String _domain(String? url) {
  if (url == null || url.isEmpty) return t.common.browserUse.noPageLoaded;
  return Uri.tryParse(url)?.host.isNotEmpty == true ? Uri.parse(url).host : url;
}

String _formatRelativeTime(String? value) {
  final rel = t.common.browserUse.relative;
  if (value == null) return rel.never;
  final ts = DateTime.tryParse(value);
  if (ts == null) return rel.unknown;
  final elapsed = DateTime.now().difference(ts).inSeconds;
  if (elapsed < 10) return rel.justNow;
  if (elapsed < 60) return '$elapsed${rel.secondsAgo}';
  final minutes = elapsed ~/ 60;
  if (minutes < 60) return '$minutes${rel.minutesAgo}';
  final hours = minutes ~/ 60;
  if (hours < 24) return '$hours${rel.hoursAgo}';
  return '${hours ~/ 24}${rel.daysAgo}';
}

/// Localized label for a session status wire value; unknown values pass through.
String _statusLabel(String status) => switch (status) {
  'ready' => t.browserUse.sessionStatus.ready,
  'stopped' => t.browserUse.sessionStatus.stopped,
  'unavailable' => t.browserUse.sessionStatus.unavailable,
  _ => status,
};

String _formatAction(String? action) =>
    action == null ? t.common.browserUse.waiting : action.replaceAll('_', ' ');

/// Headless agent-browser panel — port of `browser-use/view/BrowserUsePanel.tsx`:
/// runtime badge + install, session list with a selected-session surface
/// (screenshot + agent-cursor overlay), fullscreen viewer and delete confirm.
class BrowserUsePanel extends ConsumerStatefulWidget {
  const BrowserUsePanel({super.key});

  @override
  ConsumerState<BrowserUsePanel> createState() => _BrowserUsePanelState();
}

class _BrowserUsePanelState extends ConsumerState<BrowserUsePanel> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(browserUseProvider);
    final ctrl = ref.read(browserUseProvider.notifier);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final compact = context.breakpoint.isCompact;
    final t = Translations.of(context);
    final status = state.status;

    final sessions = state.sessions;
    final selected =
        sessions.cast<BrowserUseSession?>().firstWhere(
          (s) => s?.id == _selectedId,
          orElse: () => null,
        ) ??
        (sessions.isNotEmpty ? sessions.first : null);
    final activeCount = sessions.where((s) => s.isRunning).length;
    final needsBinaries =
        status?.enabled == true && !(status!.playwrightInstalled && status.chromiumInstalled);
    final runtime = t.common.browserUse.runtime;
    final runtimeLabel = status?.enabled != true
        ? runtime.disabled
        : status!.available
        ? runtime.ready
        : status.installInProgress || state.busy
        ? runtime.installing
        : runtime.setupRequired;
    final runtimeReady =
        status != null && status.enabled && (status.available || status.installInProgress);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header — title + runtime badge + settings/refresh. On compact the
        // hamburger rides here (web `onMenuClick` parity).
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: c.border.withValues(alpha: 0.6))),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Row(
            spacing: AppSpacing.sm,
            children: [
              if (compact) const AppNavMenuButton(),
              Icon(LucideIcons.monitorPlay, size: 16, color: c.primary),
              Flexible(
                child: Text(
                  t.common.browserUse.title,
                  overflow: TextOverflow.ellipsis,
                  style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              _Badge(label: runtimeLabel, highlighted: runtimeReady),
              const Spacer(),
              IconButton(
                tooltip: t.common.browserUse.openSettings,
                icon: const Icon(LucideIcons.settings, size: 14),
                visualDensity: VisualDensity.compact,
                onPressed: () => context.go('/settings/tools'),
              ),
              IconButton(
                tooltip: t.common.browserUse.refresh,
                icon: const Icon(LucideIcons.refreshCw, size: 14),
                visualDensity: VisualDensity.compact,
                onPressed: state.loading ? null : () => ctrl.refresh(),
              ),
            ],
          ),
        ),
        if (state.error != null)
          Container(
            decoration: BoxDecoration(
              color: c.destructive.withValues(alpha: 0.1),
              border: Border(bottom: BorderSide(color: c.destructive.withValues(alpha: 0.2))),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Text(state.error!, style: tt.bodySmall?.copyWith(color: c.destructive)),
          ),
        // Compact session strip (legacy `lg:hidden` chip row).
        if (compact && sessions.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: c.muted.withValues(alpha: 0.2),
              border: Border(bottom: BorderSide(color: c.border.withValues(alpha: 0.6))),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: AppSpacing.sm,
                children: [
                  for (final s in sessions)
                    _SessionChip(
                      session: s,
                      selected: selected?.id == s.id,
                      onTap: () => setState(() => _selectedId = s.id),
                    ),
                ],
              ),
            ),
          ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Counts strip.
                    Container(
                      decoration: BoxDecoration(
                        color: c.muted.withValues(alpha: 0.2),
                        border: Border(bottom: BorderSide(color: c.border.withValues(alpha: 0.6))),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${t.common.browserUse.activeCount(count: activeCount)} / '
                              '${t.common.browserUse.totalCount(count: sessions.length)}',
                              overflow: TextOverflow.ellipsis,
                              style: tt.labelSmall?.copyWith(color: c.mutedForeground),
                            ),
                          ),
                          Text(
                            t.common.browserUse.updated(
                              time: _formatRelativeTime(selected?.updatedAt),
                            ),
                            overflow: TextOverflow.ellipsis,
                            style: tt.labelSmall?.copyWith(color: c.mutedForeground),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: sessions.isEmpty
                          ? _EmptyState(
                              enabled: status?.enabled == true,
                              needsBinaries: needsBinaries,
                              message: status?.message,
                              installing: state.busy || status?.installInProgress == true,
                              onInstall: () => unawaited(ctrl.installRuntime()),
                            )
                          : Container(
                              color: c.muted.withValues(alpha: 0.2),
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: _SessionSurface(
                                session: selected,
                                compact: compact,
                                busy: state.busy,
                                onStop: selected == null
                                    ? null
                                    : () => unawaited(ctrl.stopSession(selected.id)),
                                onDelete: selected == null
                                    ? null
                                    : () => unawaited(_confirmDelete(context, selected)),
                                onFullscreen: selected == null || selected.screenshotDataUrl == null
                                    ? null
                                    : () => unawaited(_showFullscreen(context, selected)),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              if (!compact)
                SizedBox(
                  width: 320,
                  child: _SessionsAside(
                    sessions: sessions,
                    selected: selected,
                    activeCount: activeCount,
                    busy: state.busy,
                    onSelect: (s) => setState(() => _selectedId = s.id),
                    onStop: selected == null
                        ? null
                        : () => unawaited(ctrl.stopSession(selected.id)),
                    onDelete: selected == null
                        ? null
                        : () => unawaited(_confirmDelete(context, selected)),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, BrowserUseSession session) async {
    final c = context.appColors;
    final t = Translations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.common.browserUse.deleteTitle),
        content: Text(
          t.common.browserUse.deleteDesc(
            name: session.title ?? session.url ?? t.common.browserUse.thisSession,
          ),
        ),
        actions: [
          AppButton(
            variant: AppButtonVariant.ghost,
            size: AppButtonSize.sm,
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.common.browserUse.cancel),
          ),
          AppButton(
            size: AppButtonSize.sm,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.common.buttons.delete, style: TextStyle(color: c.destructive)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref.read(browserUseProvider.notifier).deleteSession(session.id);
    }
  }

  Future<void> _showFullscreen(BuildContext context, BrowserUseSession session) {
    final t = Translations.of(context);
    return showDialog<void>(
      context: context,
      builder: (ctx) => Dialog.fullscreen(
        backgroundColor: Colors.black.withValues(alpha: 0.9),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      session.title ?? session.url ?? t.common.browserUse.sessionFallback,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(ctx).textTheme.titleSmall?.copyWith(color: Colors.white70),
                    ),
                  ),
                  AppButton(
                    variant: AppButtonVariant.outline,
                    size: AppButtonSize.sm,
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: AppSpacing.xs,
                      children: [Icon(LucideIcons.x, size: 14), Text(t.common.browserUse.close)],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _Surface(session: session, fullscreen: true)),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, this.highlighted = false});

  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: highlighted ? c.primary.withValues(alpha: 0.05) : c.muted.withValues(alpha: 0.5),
        border: Border.all(color: highlighted ? c.primary.withValues(alpha: 0.3) : c.border),
        borderRadius: AppRadii.borderMd,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(fontSize: 10, color: highlighted ? c.foreground : c.mutedForeground),
      ),
    );
  }
}

/// Compact session selector chip (legacy mobile strip).
class _SessionChip extends StatelessWidget {
  const _SessionChip({required this.session, required this.selected, required this.onTap});

  final BrowserUseSession session;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.borderMd,
      child: Container(
        constraints: const BoxConstraints(minWidth: 160),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: selected ? c.primary.withValues(alpha: 0.05) : c.background,
          border: Border.all(color: selected ? c.primary.withValues(alpha: 0.4) : c.border),
          borderRadius: AppRadii.borderMd,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.sm,
          children: [
            _StatusDot(ready: session.isRunning),
            Flexible(
              child: Text(
                session.title ?? _domain(session.url),
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.ready});

  final bool ready;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ready ? c.primary : c.mutedForeground.withValues(alpha: 0.5),
      ),
    );
  }
}

/// Framed selected-session card: status/title/url row + screenshot surface.
class _SessionSurface extends StatelessWidget {
  const _SessionSurface({
    required this.session,
    required this.compact,
    required this.busy,
    this.onStop,
    this.onDelete,
    this.onFullscreen,
  });

  final BrowserUseSession? session;
  final bool compact;
  final bool busy;
  final VoidCallback? onStop;
  final VoidCallback? onDelete;
  final VoidCallback? onFullscreen;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final t = Translations.of(context);
    final s = session;
    return Container(
      decoration: BoxDecoration(
        color: c.background,
        border: Border.all(color: c.border),
        borderRadius: AppRadii.borderMd,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            child: Row(
              spacing: AppSpacing.sm,
              children: [
                _Badge(
                  label: s == null ? t.common.browserUse.emptyStatus : _statusLabel(s.status),
                  highlighted: s?.isRunning == true,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s?.title ?? _domain(s?.url),
                        overflow: TextOverflow.ellipsis,
                        style: tt.titleSmall,
                      ),
                      Row(
                        spacing: 4,
                        children: [
                          Icon(LucideIcons.externalLink, size: 12, color: c.mutedForeground),
                          Expanded(
                            child: Text(
                              s?.url ?? t.common.browserUse.noPageLoaded,
                              overflow: TextOverflow.ellipsis,
                              style: tt.labelSmall?.copyWith(color: c.mutedForeground),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!compact && s?.lastAction != null)
                  Text(
                    _formatAction(s!.lastAction),
                    style: tt.labelSmall?.copyWith(color: c.mutedForeground),
                  ),
                IconButton(
                  tooltip: t.common.browserUse.fullscreen,
                  icon: const Icon(LucideIcons.expand, size: 16),
                  visualDensity: VisualDensity.compact,
                  onPressed: onFullscreen,
                ),
                if (compact) ...[
                  IconButton(
                    tooltip: t.common.browserUse.stopSession,
                    icon: const Icon(LucideIcons.square, size: 16),
                    visualDensity: VisualDensity.compact,
                    onPressed: busy || s?.isRunning != true ? null : onStop,
                  ),
                  IconButton(
                    tooltip: t.common.browserUse.deleteSession,
                    icon: const Icon(LucideIcons.trash2, size: 16),
                    visualDensity: VisualDensity.compact,
                    onPressed: busy || s == null ? null : onDelete,
                  ),
                ],
              ],
            ),
          ),
          Expanded(child: _Surface(session: s)),
        ],
      ),
    );
  }
}

/// Screenshot surface with the agent-cursor overlay (legacy
/// `renderBrowserSurface`): cursor position is a fraction of the remote
/// viewport, so it lands on the same spot regardless of display size.
class _Surface extends StatelessWidget {
  const _Surface({required this.session, this.fullscreen = false});

  final BrowserUseSession? session;
  final bool fullscreen;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final t = Translations.of(context);
    final dataUrl = session?.screenshotDataUrl;
    final cursor = session?.cursor;
    final viewport = session?.viewport;
    return Container(
      color: const Color(0xFF0A0A0A), // neutral-950
      alignment: Alignment.center,
      constraints: BoxConstraints(minHeight: fullscreen ? 0 : 420),
      child: dataUrl == null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  LucideIcons.monitorPlay,
                  size: 36,
                  color: Color(0xFF737373), // neutral-500
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  session?.message ?? t.common.browserUse.waitingForScreenshot,
                  style: tt.bodyMedium?.copyWith(
                    color: const Color(0xFFF5F5F5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  t.common.browserUse.nextSnapshot,
                  style: tt.labelSmall?.copyWith(color: const Color(0xFFA3A3A3)),
                ),
              ],
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final image = _Screenshot(
                  dataUrl: dataUrl,
                  fit: BoxFit.contain,
                  width: constraints.maxWidth,
                );
                if (cursor == null || viewport == null) return image;
                return Stack(
                  children: [
                    Positioned.fill(child: Center(child: image)),
                    Positioned.fill(
                      child: _CursorOverlay(cursor: cursor, viewport: viewport),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

/// Cursor dot positioned as a fraction of the captured viewport — matches the
/// legacy `left/top: cursor/viewport * 100%` overlay.
class _CursorOverlay extends StatelessWidget {
  const _CursorOverlay({required this.cursor, required this.viewport});

  final ({double x, double y}) cursor;
  final ({double width, double height}) viewport;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // The screenshot is letterboxed (BoxFit.contain); find its drawn rect
        // so the fractional cursor lands on the image, not the container.
        final vw = viewport.width <= 0 ? 1.0 : viewport.width;
        final vh = viewport.height <= 0 ? 1.0 : viewport.height;
        final scale = (constraints.maxWidth / vw).clamp(0, double.infinity).toDouble();
        final scaleH = (constraints.maxHeight / vh).clamp(0, double.infinity).toDouble();
        final s = scale < scaleH ? scale : scaleH;
        final drawnW = vw * s;
        final drawnH = vh * s;
        final left = (constraints.maxWidth - drawnW) / 2 + drawnW * (cursor.x / vw);
        final top = (constraints.maxHeight - drawnH) / 2 + drawnH * (cursor.y / vh);
        return Stack(
          children: [
            Positioned(
              left: left - 10,
              top: top - 10,
              child: IgnorePointer(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.18),
                        blurRadius: 0,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: SizedBox.square(
                      dimension: 8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Aside (wide layouts): session list + selected-session meta + actions.
class _SessionsAside extends StatelessWidget {
  const _SessionsAside({
    required this.sessions,
    required this.selected,
    required this.activeCount,
    required this.busy,
    required this.onSelect,
    this.onStop,
    this.onDelete,
  });

  final List<BrowserUseSession> sessions;
  final BrowserUseSession? selected;
  final int activeCount;
  final bool busy;
  final ValueChanged<BrowserUseSession> onSelect;
  final VoidCallback? onStop;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final t = Translations.of(context);
    final s = selected;
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: c.border.withValues(alpha: 0.6))),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: c.border.withValues(alpha: 0.6))),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.common.browserUse.sessions,
                        style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        t.common.browserUse.totalCount(count: sessions.length),
                        style: tt.labelSmall?.copyWith(color: c.mutedForeground),
                      ),
                    ],
                  ),
                ),
                _Badge(label: t.common.browserUse.activeCount(count: activeCount)),
              ],
            ),
          ),
          Expanded(
            child: sessions.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      t.common.browserUse.noSessions,
                      textAlign: TextAlign.center,
                      style: tt.labelSmall?.copyWith(color: c.mutedForeground),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    children: [
                      for (final sess in sessions)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: _SessionListItem(
                            session: sess,
                            selected: sess.id == s?.id,
                            onTap: () => onSelect(sess),
                          ),
                        ),
                    ],
                  ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: c.border.withValues(alpha: 0.6))),
            ),
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: c.muted.withValues(alpha: 0.3),
                border: Border.all(color: c.border.withValues(alpha: 0.7)),
                borderRadius: AppRadii.borderMd,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: AppSpacing.sm,
                    children: [
                      Icon(LucideIcons.bot, size: 14, color: c.mutedForeground),
                      Text(
                        t.common.browserUse.selected,
                        style: tt.labelSmall?.copyWith(
                          color: c.mutedForeground,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _MetaRow(
                    label: t.common.browserUse.status,
                    value: s == null ? t.common.browserUse.none : _statusLabel(s.status),
                  ),
                  _MetaRow(
                    label: t.common.browserUse.lastAction,
                    value: _formatAction(s?.lastAction),
                  ),
                  _MetaRow(
                    label: t.common.browserUse.profile,
                    value: s?.profileName ?? t.common.browserUse.temporary,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    spacing: AppSpacing.sm,
                    children: [
                      Expanded(
                        child: AppButton(
                          variant: AppButtonVariant.outline,
                          size: AppButtonSize.sm,
                          onPressed: busy || s?.isRunning != true ? null : onStop,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: AppSpacing.xs,
                            children: [
                              Icon(LucideIcons.square, size: 14),
                              Text(t.common.browserUse.stop),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: AppButton(
                          variant: AppButtonVariant.outline,
                          size: AppButtonSize.sm,
                          onPressed: busy || s == null ? null : onDelete,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: AppSpacing.xs,
                            children: [
                              Icon(LucideIcons.trash2, size: 14),
                              Text(t.common.buttons.delete),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label, style: tt.labelSmall?.copyWith(color: c.mutedForeground)),
          const Spacer(),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: tt.labelSmall?.copyWith(color: c.foreground, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionListItem extends StatelessWidget {
  const _SessionListItem({required this.session, required this.selected, required this.onTap});

  final BrowserUseSession session;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.borderMd,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: selected ? c.primary.withValues(alpha: 0.1) : c.card.withValues(alpha: 0.3),
          border: Border.all(
            color: selected ? c.primary.withValues(alpha: 0.5) : c.border.withValues(alpha: 0.6),
          ),
          borderRadius: AppRadii.borderMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: AppSpacing.sm,
              children: [
                _StatusDot(ready: session.isRunning),
                Expanded(
                  child: Text(
                    session.title ?? _domain(session.url),
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: selected ? c.foreground : c.mutedForeground,
                    ),
                  ),
                ),
                _Badge(label: _statusLabel(session.status)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 2),
              child: Text(
                _domain(session.url),
                overflow: TextOverflow.ellipsis,
                style: tt.labelSmall?.copyWith(color: c.mutedForeground),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              spacing: 4,
              children: [
                Icon(LucideIcons.clock3, size: 12, color: c.mutedForeground),
                Text(
                  _formatRelativeTime(session.updatedAt),
                  style: tt.labelSmall?.copyWith(color: c.mutedForeground, fontSize: 11),
                ),
                Expanded(
                  child: Text(
                    '- ${_formatAction(session.lastAction)}',
                    overflow: TextOverflow.ellipsis,
                    style: tt.labelSmall?.copyWith(color: c.mutedForeground, fontSize: 11),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state: icon + title/description (enabled vs disabled copy), runtime
/// setup card when binaries are missing, and the two prompt-suggestion cards.
class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.enabled,
    required this.needsBinaries,
    required this.installing,
    required this.onInstall,
    this.message,
  });

  final bool enabled;
  final bool needsBinaries;
  final bool installing;
  final String? message;
  final VoidCallback onInstall;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final t = Translations.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 640),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: c.card.withValues(alpha: 0.4),
            border: Border.all(color: c.border),
            borderRadius: AppRadii.borderMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.md,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: c.background,
                      border: Border.all(color: c.border),
                      borderRadius: AppRadii.borderMd,
                    ),
                    child: Icon(LucideIcons.monitorPlay, size: 20, color: c.primary),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          enabled
                              ? t.common.browserUse.empty.titleEnabled
                              : t.common.browserUse.empty.titleDisabled,
                          style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          enabled
                              ? t.common.browserUse.empty.descEnabled
                              : t.common.browserUse.empty.descDisabled,
                          style: tt.bodySmall?.copyWith(color: c.mutedForeground, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (needsBinaries) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: c.muted.withValues(alpha: 0.3),
                    border: Border.all(color: c.border),
                    borderRadius: AppRadii.borderMd,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.common.browserUse.runtimeSetup,
                        style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      if (message != null) ...[
                        const SizedBox(height: 4),
                        Text(message!, style: tt.bodySmall?.copyWith(color: c.mutedForeground)),
                      ],
                      const SizedBox(height: AppSpacing.sm),
                      AppButton(
                        size: AppButtonSize.sm,
                        loading: installing,
                        onPressed: onInstall,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: AppSpacing.xs,
                          children: [
                            Icon(LucideIcons.download, size: 14),
                            Text(t.common.browserUse.installRuntime),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _PromptCard(text: t.common.browserUse.prompts.prompt1),
                  _PromptCard(text: t.common.browserUse.prompts.prompt2),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromptCard extends StatelessWidget {
  const _PromptCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    return Container(
      width: 260,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: c.background.withValues(alpha: 0.7),
        border: Border.all(color: c.border.withValues(alpha: 0.7)),
        borderRadius: AppRadii.borderMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: AppSpacing.xs,
            children: [
              Icon(LucideIcons.bot, size: 12, color: c.mutedForeground),
              Text(
                t.common.browserUse.promptLabel,
                style: tt.labelSmall?.copyWith(
                  color: c.mutedForeground,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(text, style: tt.bodySmall?.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}

class _Screenshot extends StatelessWidget {
  const _Screenshot({required this.dataUrl, this.fit, this.width});

  final String dataUrl;
  final BoxFit? fit;
  final double? width;

  @override
  Widget build(BuildContext context) {
    try {
      final comma = dataUrl.indexOf(',');
      final bytes = base64Decode(comma >= 0 ? dataUrl.substring(comma + 1) : dataUrl);
      return Image.memory(
        bytes,
        width: width ?? double.infinity,
        fit: fit ?? BoxFit.cover,
        gaplessPlayback: true,
      );
    } on Object {
      return const SizedBox.shrink();
    }
  }
}

/// Hosted dialog wrapper — "Browser" button entry point.
Future<void> showBrowserUseDialog(BuildContext context) {
  final t = Translations.of(context);
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(t.browser.dialogTitle),
      content: const SizedBox(width: 720, height: 480, child: BrowserUsePanel()),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(t.common.browserUse.close),
        ),
      ],
    ),
  );
}
