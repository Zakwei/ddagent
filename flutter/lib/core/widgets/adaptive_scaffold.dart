import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_nav_menu.dart';
import 'package:ddagent_app/features/browser_use/state/browser_use_controller.dart';
import 'package:ddagent_app/features/sessions/state/sessions_controller.dart';
import 'package:ddagent_app/features/settings/state/ui_preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

/// `BUY_ME_A_COFFEE_URL` from the web client's shared/constants.ts.
const _kCoffeeUrl = 'https://buymeacoffee.com/ddnet';

/// Top-level destinations shown in the rail, mirroring the web client's
/// SidebarRail order: pane workspace + sessions first, then standalone pages.
/// New-app-only pages (projects, scheduler) sit in a second group below.
const _destinations = [
  (icon: LucideIcons.messageSquarePlus, label: 'Panel', path: '/workspace'),
  (icon: LucideIcons.history, label: 'Sessions', path: '/sessions'),
];

const _pageDestinations = [
  (icon: LucideIcons.squareKanban, label: 'Agent Board', path: '/board'),
  (icon: LucideIcons.clipboardCheck, label: 'Tasks', path: '/tasks'),
  (icon: LucideIcons.gauge, label: 'Quota & Usage', path: '/quota'),
  (icon: LucideIcons.gitBranch, label: 'Source Control', path: '/git'),
  (icon: LucideIcons.folder, label: 'Files', path: '/files'),
];

const _extraDestinations = [
  (icon: LucideIcons.layoutGrid, label: 'Projects', path: '/projects'),
  (icon: LucideIcons.calendarClock, label: 'Schedules', path: '/scheduler'),
];

/// Shown only when the server reports browser-use enabled (the web app's
/// `shouldShowBrowserTab` gate on `/api/browser-use/settings`).
const _browserDestination = (
  icon: LucideIcons.monitorPlay,
  label: 'Browser',
  path: '/browser',
);

const _settingsDestination = (
  icon: LucideIcons.settings,
  label: 'Settings',
  path: '/settings',
);

const _allDestinations = [
  ..._destinations,
  ..._pageDestinations,
  ..._extraDestinations,
  _browserDestination,
  _settingsDestination,
];

/// Adaptive shell: 48px icon rail (web SidebarRail parity) on medium+ widths,
/// hamburger drawer (web MobileNavMenu parity) on compact.
class AdaptiveScaffold extends ConsumerStatefulWidget {
  const AdaptiveScaffold({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends ConsumerState<AdaptiveScaffold> {
  /// Stable across rebuilds — a key recreated in `build` would remount the
  /// drawer Scaffold on every parent rebuild and slam an open drawer shut.
  final _drawerKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Ctrl/Cmd+Shift+F — focus mode (web `useAppKeyboardShortcuts`).
    // HardwareKeyboard level so it works regardless of which pane is focused.
    HardwareKeyboard.instance.addHandler(_focusModeKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_focusModeKey);
    super.dispose();
  }

  bool _focusModeKey(KeyEvent event) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.keyF ||
        !HardwareKeyboard.instance.isShiftPressed ||
        !(HardwareKeyboard.instance.isControlPressed ||
            HardwareKeyboard.instance.isMetaPressed)) {
      return false;
    }
    // Desktop-only affordance — compact uses the drawer instead.
    if (context.breakpoint.isCompact) return false;
    ref.read(uiPreferencesProvider.notifier).toggleSidebar();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final bp = context.breakpoint;
    if (bp.isCompact) {
      // Compact has no room for a rail, so the destinations move into a
      // hamburger drawer (web `MobileNavMenu` parity) — no bottom bar and no
      // dedicated top row: each screen's own header carries the hamburger
      // (web `onMenuClick` parity), so it costs no extra vertical space.
      return AppDrawer(
        drawerKey: _drawerKey,
        child: Scaffold(
          key: _drawerKey,
          drawer: _CompactNavDrawer(selectedPath: _selectedPath(context)),
          body: widget.child,
        ),
      );
    }
    // Focus mode — web `sidebarVisible` pref: hiding the rail is the desktop
    // focus affordance (the Flutter shell has no second sidebar to collapse).
    if (!ref.watch(uiPreferencesProvider).sidebarVisible) {
      return Scaffold(body: widget.child);
    }
    return Scaffold(
      body: Row(
        children: [
          _AppRail(selectedPath: _selectedPath(context)),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  String? _selectedPath(BuildContext context) {
    final loc = GoRouterState.of(context).uri.path;
    for (final d in _allDestinations) {
      if (loc == d.path || loc.startsWith('${d.path}/')) return d.path;
    }
    return null;
  }
}

/// 48px icon rail — visual port of the React `SidebarRail`:/// `flex w-12 flex-col items-center gap-1 bg-background/80 py-3`,
/// 36×36 `rounded-lg` buttons with 16px Lucide icons.
class _AppRail extends ConsumerWidget {
  const _AppRail({required this.selectedPath});

  final String? selectedPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final nav = context.appNav;
    final runningCount = ref
        .watch(sessionsProvider((null, null)))
        .sessions
        .where((s) => s.isRunning && !s.isArchived)
        .length;
    final browserEnabled = ref.watch(browserUseEnabledProvider).value ?? false;

    return Container(
      // w-12 rail + border-r: 48px of rail plus the 1px separator.
      width: 49,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: c.background.withValues(alpha: 0.8),
        // React wraps the rail in `border-r border-border/50`.
        border: Border(
          right: BorderSide(color: c.border.withValues(alpha: 0.5)),
        ),
      ),
      child: Column(
        spacing: 4,
        children: [
          _RailButton(
            icon: LucideIcons.messageSquarePlus,
            label: runningCount > 0 ? 'Panel · $runningCount active' : 'Panel',
            selected: selectedPath == '/workspace',
            badgeCount: runningCount,
            onTap: () => context.go('/workspace'),
          ),
          _RailButton(
            icon: LucideIcons.history,
            label: 'Sessions',
            selected: selectedPath == '/sessions',
            onTap: () => context.go('/sessions'),
          ),
          _NavDivider(color: nav.dividerColor),
          for (final d in _pageDestinations)
            _RailButton(
              icon: d.icon,
              label: d.label,
              selected: selectedPath == d.path,
              onTap: () => context.go(d.path),
            ),
          _NavDivider(color: nav.dividerColor),
          for (final d in _extraDestinations)
            _RailButton(
              icon: d.icon,
              label: d.label,
              selected: selectedPath == d.path,
              onTap: () => context.go(d.path),
            ),
          if (browserEnabled)
            _RailButton(
              icon: _browserDestination.icon,
              label: _browserDestination.label,
              selected: selectedPath == _browserDestination.path,
              onTap: () => context.go(_browserDestination.path),
            ),
          const Spacer(),
          _RailButton(
            icon: LucideIcons.coffee,
            label: 'Buy Me a Coffee',
            onTap: () => launchUrl(Uri.parse(_kCoffeeUrl)),
          ),
          _RailButton(
            icon: LucideIcons.settings,
            label: 'Settings',
            selected: selectedPath == '/settings',
            onTap: () => context.go('/settings'),
          ),
        ],
      ),
    );
  }
}

/// `nav-divider` — 24px wide, 1px gradient line with 4px vertical margin.
class _NavDivider extends StatelessWidget {
  const _NavDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0),
            color,
            color.withValues(alpha: 0),
          ],
          stops: const [0, 0.2, 1],
        ),
      ),
    );
  }
}

/// One rail button — `h-9 w-9 rounded-lg`, 16px icon, muted → foreground on
/// hover, `bg-accent` when selected. Optional emerald running-count badge.
class _RailButton extends StatefulWidget {
  const _RailButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.badgeCount = 0,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final int badgeCount;

  @override
  State<_RailButton> createState() => _RailButtonState();
}

class _RailButtonState extends State<_RailButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final highlighted = widget.selected || _hovering;
    return Tooltip(
      message: widget.label,
      preferBelow: false,
      verticalOffset: 12,
      waitDuration: const Duration(milliseconds: 400),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: AppMotion.base,
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: widget.selected
                  ? c.accent.withValues(alpha: 0.7)
                  : _hovering
                  ? c.accent.withValues(alpha: 0.8)
                  : Colors.transparent,
              borderRadius: AppRadii.borderLg,
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    widget.icon,
                    size: 16,
                    color: highlighted ? c.foreground : c.mutedForeground,
                  ),
                ),
                if (widget.badgeCount > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      height: 16,
                      constraints: const BoxConstraints(minWidth: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981), // emerald-500
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.badgeCount > 99 ? '99+' : '${widget.badgeCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact navigation drawer — web `MobileNavMenu` parity: a modal side panel
/// with the app-level destinations, no session/project lists.
class _CompactNavDrawer extends ConsumerWidget {
  const _CompactNavDrawer({required this.selectedPath});

  final String? selectedPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final nav = context.appNav;
    final runningCount = ref
        .watch(sessionsProvider((null, null)))
        .sessions
        .where((s) => s.isRunning && !s.isArchived)
        .length;
    final browserEnabled = ref.watch(browserUseEnabledProvider).value ?? false;

    Widget item(IconData icon, String label, String path, {int badge = 0}) {
      final selected = selectedPath == path;
      return ListTile(
        leading: Icon(icon, size: 18),
        title: Text(label, style: const TextStyle(fontSize: 14)),
        trailing: badge > 0
            ? Container(
                height: 18,
                constraints: const BoxConstraints(minWidth: 18),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(9),
                ),
                alignment: Alignment.center,
                child: Text(
                  badge > 99 ? '99+' : '$badge',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              )
            : null,
        selected: selected,
        onTap: () {
          Navigator.of(context).pop();
          context.go(path);
        },
      );
    }

    return Drawer(
      width: 288,
      backgroundColor: c.card,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 4),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Navigation',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: c.mutedForeground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            item(
              LucideIcons.messageSquarePlus,
              'Panel',
              '/workspace',
              badge: runningCount,
            ),
            item(LucideIcons.history, 'Sessions', '/sessions'),
            _drawerDivider(nav.dividerColor),
            for (final d in _pageDestinations) item(d.icon, d.label, d.path),
            _drawerDivider(nav.dividerColor),
            for (final d in _extraDestinations) item(d.icon, d.label, d.path),
            if (browserEnabled)
              item(
                _browserDestination.icon,
                _browserDestination.label,
                _browserDestination.path,
              ),
            _drawerDivider(nav.dividerColor),
            ListTile(
              leading: const Icon(LucideIcons.coffee, size: 18),
              title: const Text(
                'Buy Me a Coffee',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.of(context).pop();
                launchUrl(Uri.parse(_kCoffeeUrl));
              },
            ),
            item(
              _settingsDestination.icon,
              _settingsDestination.label,
              _settingsDestination.path,
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerDivider(Color color) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Divider(height: 1, color: color.withValues(alpha: 0.5)),
  );
}
