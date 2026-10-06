import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_nav_menu.dart';
import 'package:ddagent_app/core/widgets/update_badge.dart';
import 'package:ddagent_app/features/browser_use/state/browser_use_controller.dart';
import 'package:ddagent_app/features/palette/command_palette.dart';
import 'package:ddagent_app/features/sessions/state/sessions_controller.dart';
import 'package:ddagent_app/features/settings/state/ui_preferences_controller.dart';
import 'package:ddagent_app/features/settings/view/quick_settings_sheet.dart';
import 'package:ddagent_app/features/taskmaster/state/tasks_settings_controller.dart';
import 'package:ddagent_app/features/workspace/view/session_quick_switcher.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// `BUY_ME_A_COFFEE_URL` from the web client's shared/constants.ts.
const _kCoffeeUrl = 'https://buymeacoffee.com/ddnet';

/// Top-level destinations shown in the rail, mirroring the web client's
/// SidebarRail order: pane workspace + sessions first, then standalone pages.
/// New-app-only pages (projects, scheduler) sit in a second group below.
/// Labels are resolved from i18n via [_destinationLabel] so the tables stay
/// `const`.
const _destinations = [
  (icon: LucideIcons.messageSquarePlus, path: '/workspace'),
  (icon: LucideIcons.history, path: '/sessions'),
];

const _pageDestinations = [
  (icon: LucideIcons.squareKanban, path: '/board'),
  (icon: LucideIcons.clipboardCheck, path: '/tasks'),
  (icon: LucideIcons.gauge, path: '/quota'),
  (icon: LucideIcons.gitBranch, path: '/git'),
  (icon: LucideIcons.folder, path: '/files'),
];

const _extraDestinations = [
  (icon: LucideIcons.brain, path: '/knowledge'),
  (icon: LucideIcons.layoutGrid, path: '/projects'),
  (icon: LucideIcons.calendarClock, path: '/scheduler'),
];

/// Shown only when the server reports browser-use enabled (the web app's
/// `shouldShowBrowserTab` gate on `/api/browser-use/settings`).
const _browserDestination = (icon: LucideIcons.monitorPlay, path: '/browser');

const _settingsDestination = (icon: LucideIcons.settings, path: '/settings');

const _allDestinations = [
  ..._destinations,
  ..._pageDestinations,
  ..._extraDestinations,
  _browserDestination,
  _settingsDestination,
];

/// Localized label for a destination entry in the rail/drawer.
String _destinationLabel(Translations t, String path) => switch (path) {
  '/workspace' => t.sidebar.panel.open,
  '/sessions' => t.common.quota.metric.sessions,
  '/board' => t.sidebar.tabs.board,
  '/tasks' => t.common.tabs.tasks,
  '/quota' => t.sidebar.tabs.usage,
  '/git' => t.common.tabs.git,
  '/files' => t.common.tabs.files,
  '/knowledge' => t.knowledge.title,
  '/projects' => t.sidebar.projects.title,
  '/scheduler' => t.settings.schedules.title,
  '/browser' => t.common.tabs.browser,
  '/settings' => t.common.navigation.settings,
  _ => path,
};

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

  /// Synced in [build] for the hardware-key handler (web `shouldShowTasksTab`).
  bool _showTasks = true;

  /// Set while the command palette dialog is showing so Ctrl+Shift+K toggles
  /// it closed (web `setOpen((prev) => !prev)`).
  bool _paletteOpen = false;

  @override
  void initState() {
    super.initState();
    // Global shortcuts (web `useAppKeyboardShortcuts`): Ctrl/Cmd+Shift+F focus
    // mode, Ctrl/Cmd+K session quick switcher, Alt+1..3 tab nav.
    // HardwareKeyboard level so it works regardless of which pane is focused.
    HardwareKeyboard.instance.addHandler(_globalKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_globalKey);
    super.dispose();
  }

  /// Web parity: skip navigation shortcuts while a dialog/sheet is on top
  /// (legacy `isModalOpen()`).
  bool get _modalOpen => ModalRoute.of(context)?.isCurrent == false;

  bool _globalKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    final key = event.logicalKey;
    final kb = HardwareKeyboard.instance;
    final ctrlOrMeta = kb.isControlPressed || kb.isMetaPressed;

    // 1. Alt+1..3 quick switch — 1: Panel, 2: Tasks (gated) else Git, 3: Git.
    if (kb.isAltPressed && !ctrlOrMeta && !kb.isShiftPressed) {
      final path = switch (key) {
        LogicalKeyboardKey.digit1 => '/workspace',
        LogicalKeyboardKey.digit2 => _showTasks ? '/tasks' : '/git',
        LogicalKeyboardKey.digit3 => '/git',
        _ => null,
      };
      if (path != null) {
        if (_modalOpen) return false;
        context.go(path);
        return true;
      }
      return false;
    }

    // 2. Ctrl/Cmd+Shift+F — focus mode (desktop only; compact uses drawer).
    if (ctrlOrMeta &&
        kb.isShiftPressed &&
        !kb.isAltPressed &&
        key == LogicalKeyboardKey.keyF) {
      if (_modalOpen || context.breakpoint.isCompact) return false;
      ref.read(uiPreferencesProvider.notifier).toggleSidebar();
      return true;
    }

    // 3. Ctrl/Cmd+K — session quick switcher.
    if (ctrlOrMeta &&
        !kb.isShiftPressed &&
        !kb.isAltPressed &&
        key == LogicalKeyboardKey.keyK) {
      if (_modalOpen) return false;
      unawaited(showSessionQuickSwitcher(context));
      return true;
    }

    // 4. Ctrl/Cmd+Shift+K — command palette (web CommandPalette). Toggles:
    // when the palette itself is the top modal, the shortcut closes it.
    if (ctrlOrMeta &&
        kb.isShiftPressed &&
        !kb.isAltPressed &&
        key == LogicalKeyboardKey.keyK) {
      if (_paletteOpen) {
        Navigator.of(context, rootNavigator: true).pop();
        return true;
      }
      if (_modalOpen) return false;
      _paletteOpen = true;
      unawaited(
        showCommandPalette(context).whenComplete(() => _paletteOpen = false),
      );
      return true;
    }

    // 5. Ctrl/Cmd+, — open settings (web CommandPalette's second binding;
    // also backs the shortcut badge it renders).
    if (ctrlOrMeta &&
        !kb.isShiftPressed &&
        !kb.isAltPressed &&
        key == LogicalKeyboardKey.comma) {
      if (_modalOpen) return false;
      context.go('/settings');
      return true;
    }

    return false;
  }

  /// Web `useKeepAwake`: hold a screen wake lock while `preventSleep` is on
  /// and at least one agent is running.
  void _syncKeepAwake() {
    final enabled =
        ref.read(uiPreferencesProvider).preventSleep &&
        ref
            .read(sessionsProvider((null, null)))
            .sessions
            .any((s) => s.isRunning && !s.isArchived);
    // WakelockPlus throws on unsupported platforms (e.g. Linux) — ignore.
    unawaited(WakelockPlus.toggle(enable: enabled).catchError((_) {}));
  }

  @override
  Widget build(BuildContext context) {
    final bp = context.breakpoint;
    // Watched early so they stay alive for the key handler even in focus mode.
    _showTasks =
        ref.watch(tasksEnabledProvider) &&
        (ref.watch(taskmasterInstallStatusProvider).value?.isInstalled ??
            false);
    ref.listen(
      uiPreferencesProvider.select((p) => p.preventSleep),
      (_, _) => _syncKeepAwake(),
    );
    ref.listen(
      sessionsProvider((null, null))
          .select((s) => s.sessions.any((x) => x.isRunning && !x.isArchived)),
      (_, _) => _syncKeepAwake(),
    );
    if (bp.isCompact) {
      // Compact has no room for a rail, so the destinations move into a
      // hamburger drawer (web `MobileNavMenu` parity) — no bottom bar and no
      // dedicated top row: each screen's own header carries the hamburger
      // (web `onMenuClick` parity), so it costs no extra vertical space.
      return AppDrawer(
        drawerKey: _drawerKey,
        child: Scaffold(
          key: _drawerKey,
          drawer: _CompactNavDrawer(
            selectedPath: _selectedPath(context),
            showTasks: _showTasks,
          ),
          // Edge-to-edge (Android 15+): keep content off the status/nav bars.
          body: SafeArea(child: widget.child),
        ),
      );
    }
    // Focus mode — web `sidebarVisible` pref: hiding the rail is the desktop
    // focus affordance (the Flutter shell has no second sidebar to collapse).
    if (!ref.watch(uiPreferencesProvider).sidebarVisible) {
      return Scaffold(body: SafeArea(child: widget.child));
    }
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            _AppRail(
              selectedPath: _selectedPath(context),
              showTasks: _showTasks,
            ),
            Expanded(child: widget.child),
          ],
        ),
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
  const _AppRail({required this.selectedPath, required this.showTasks});

  final String? selectedPath;

  /// `tasksEnabled && TaskMaster installed` — web `shouldShowTasksTab`.
  final bool showTasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final nav = context.appNav;
    final t = Translations.of(context);
    final runningCount = ref
        .watch(sessionsProvider((null, null)))
        .sessions
        .where((s) => s.isRunning && !s.isArchived)
        .length;
    final browserEnabled = ref.watch(browserUseEnabledProvider).value ?? false;
    final pageDestinations = [
      for (final d in _pageDestinations)
        if (showTasks || d.path != '/tasks') d,
    ];

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
            label: t.common.quota.metric.sessions,
            selected: selectedPath == '/sessions',
            onTap: () => context.go('/sessions'),
          ),
          _NavDivider(color: nav.dividerColor),
          for (final d in pageDestinations)
            _RailButton(
              icon: d.icon,
              label: _destinationLabel(t, d.path),
              selected: selectedPath == d.path,
              onTap: () => context.go(d.path),
            ),
          _NavDivider(color: nav.dividerColor),
          for (final d in _extraDestinations)
            _RailButton(
              icon: d.icon,
              label: _destinationLabel(t, d.path),
              selected: selectedPath == d.path,
              onTap: () => context.go(d.path),
            ),
          if (browserEnabled)
            _RailButton(
              icon: _browserDestination.icon,
              label: _destinationLabel(t, _browserDestination.path),
              selected: selectedPath == _browserDestination.path,
              onTap: () => context.go(_browserDestination.path),
            ),
          const Spacer(),
          const UpdateBadge(),
          _RailButton(
            icon: LucideIcons.server,
            label: t.serverConnect.changeServer,
            onTap: () => context.go('/connect'),
          ),
          _RailButton(
            icon: LucideIcons.slidersHorizontal,
            label: t.settings.quickSettings.title,
            onTap: () => showQuickSettings(context),
          ),
          _RailButton(
            icon: LucideIcons.coffee,
            label: t.settings.about.buyMeACoffee,
            onTap: () => launchUrl(Uri.parse(_kCoffeeUrl)),
          ),
          _RailButton(
            icon: LucideIcons.settings,
            label: t.common.navigation.settings,
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
  const _CompactNavDrawer({
    required this.selectedPath,
    required this.showTasks,
  });

  final String? selectedPath;

  /// `tasksEnabled && TaskMaster installed` — web `shouldShowTasksTab`.
  final bool showTasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final nav = context.appNav;
    final t = Translations.of(context);
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
              _destinationLabel(t, '/workspace'),
              '/workspace',
              badge: runningCount,
            ),
            item(
              LucideIcons.history,
              _destinationLabel(t, '/sessions'),
              '/sessions',
            ),
            _drawerDivider(nav.dividerColor),
            for (final d in _pageDestinations)
              if (showTasks || d.path != '/tasks')
                item(d.icon, _destinationLabel(t, d.path), d.path),
            _drawerDivider(nav.dividerColor),
            for (final d in _extraDestinations)
              item(d.icon, _destinationLabel(t, d.path), d.path),
            if (browserEnabled)
              item(
                _browserDestination.icon,
                _destinationLabel(t, _browserDestination.path),
                _browserDestination.path,
              ),
            _drawerDivider(nav.dividerColor),
            const UpdateBadge(variant: UpdateBadgeVariant.row),
            ListTile(
              leading: const Icon(LucideIcons.server, size: 18),
              title: Text(
                t.serverConnect.changeServer,
                style: const TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.of(context).pop();
                context.go('/connect');
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.slidersHorizontal, size: 18),
              title: Text(
                t.settings.quickSettings.title,
                style: const TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.of(context).pop();
                showQuickSettings(context);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.coffee, size: 18),
              title: Text(
                t.settings.about.buyMeACoffee,
                style: const TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.of(context).pop();
                launchUrl(Uri.parse(_kCoffeeUrl));
              },
            ),
            item(
              _settingsDestination.icon,
              _destinationLabel(t, _settingsDestination.path),
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
