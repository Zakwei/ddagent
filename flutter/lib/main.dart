import 'dart:async';
import 'dart:io' show FileSystemException, exit;
import 'dart:ui' show AppExitResponse;

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/platform/instance.dart';
import 'package:ddagent_app/core/platform/window.dart';
import 'package:ddagent_app/core/realtime/notifications_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/router/app_router.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/theme/theme_controller.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/core/widgets/boot_screen.dart';
import 'package:ddagent_app/core/widgets/text_selection_scroll_behavior.dart';
import 'package:ddagent_app/features/notifications/data/desktop_notification_presenter.dart';
import 'package:ddagent_app/features/notifications/state/device_notifications_controller.dart';
import 'package:ddagent_app/features/server_connect/data/local_server_status.dart';
import 'package:ddagent_app/features/server_connect/state/local_server_controller.dart';
import 'package:ddagent_app/features/settings/state/locale_controller.dart';
import 'package:ddagent_app/features/system/state/update_controller.dart';
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/workspace/state/workspace_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main([List<String> args = const []]) async {
  WidgetsFlutterBinding.ensureInitialized();
  parseInstanceArgs(args);
  // First frame right away — the window shows a progress bar, not black,
  // while storage and the window manager initialize.
  runApp(const BootSplashApp());
  // A failed init must not leave a dead white page — the UI still renders and
  // degraded features surface their own errors. (e.g. IndexedDB is
  // unavailable in some private-browsing modes.)
  try {
    await initStorage();
  } on FileSystemException catch (e) {
    // Another process of this instance holds the storage locks (the Windows
    // runner already brought its window forward) — never run a second copy.
    if (e.path?.endsWith('.lock') ?? false) exit(0);
  } on Object catch (_) {}
  usePathUrlStrategy(); // web: /chat/42 not /#/chat/42 (T7.4)
  try {
    await initWindow();
  } on Object catch (_) {}
  runApp(TranslationProvider(child: const ProviderScope(child: DdagentApp())));
}

/// Surfaces an inbound device notification: an OS/browser notification when the
/// platform supports it, otherwise an in-app toast (permission denied, or no OS
/// notification service — e.g. a Linux session without a D-Bus notifier).
Future<void> presentDesktopNotification(DesktopNotification event) async {
  final title = event.title?.trim();
  final body = event.body?.trim() ?? '';
  final resolvedTitle = (title == null || title.isEmpty) ? 'DDAgent' : title;
  if (await showDesktopNotification(title: resolvedTitle, body: body)) return;
  AppToast.global(body.isEmpty ? resolvedTitle : '$resolvedTitle: $body');
}

class DdagentApp extends ConsumerStatefulWidget {
  const DdagentApp({super.key});

  @override
  ConsumerState<DdagentApp> createState() => _DdagentAppState();
}

class _DdagentAppState extends ConsumerState<DdagentApp> {
  // On quit: apply a staged desktop update (detached installer), then kill the
  // app-spawned local server unless the user keeps it running (the default —
  // the next launch adopts it instead of a cold start).
  late final AppLifecycleListener _lifecycle = AppLifecycleListener(
    // Cross-device workspace sync: flush pending pane edits before the OS
    // suspends us, and re-read the server's panes on every wake.
    onHide: () => _workspace()?.onAppBackgrounded(),
    onPause: () => _workspace()?.onAppBackgrounded(),
    onResume: () {
      _workspace()?.onAppResumed();
      if (ref.exists(terminalControllerProvider)) {
        ref.read(terminalControllerProvider.notifier).onAppResumed();
      }
    },
    onExitRequested: () async {
      try {
        await ref.read(desktopUpdateProvider.notifier).applyOnExit();
      } on Object catch (_) {
        // A failed hand-off must never block quitting.
      }
      if (!ref.read(localServerKeepRunningProvider)) {
        await ref.read(localServerProvider.notifier).stop();
      }
      return AppExitResponse.exit;
    },
  );

  @override
  void initState() {
    super.initState();
    // `late` is lazy — touch it so the listener registers at mount.
    _lifecycle;
    ref.listenManual(
      serverBaseUrlProvider,
      (_, url) => unawaited(syncWindowTitle(url)),
      fireImmediately: true,
    );
  }

  // Only when already built (signed in, workspace mounted) — never spin up the
  // socket from a lifecycle callback.
  WorkspaceController? _workspace() =>
      ref.exists(workspaceProvider) ? ref.read(workspaceProvider.notifier) : null;

  /// What the first route is waiting for: the local server's stage when the
  /// active server is this device, otherwise the server being contacted.
  Widget _bootScreen() {
    final i18n = Translations.of(context);
    if (ref.watch(activeServerIsLocalProvider)) {
      final s = ref.watch(localServerProvider);
      final local = i18n.serverConnect.local;
      return switch (s.stage) {
        LocalServerStage.downloading => BootScreen(
          message: local.downloading(percent: (s.progress * 100).round()),
          progress: s.progress,
        ),
        LocalServerStage.installing => BootScreen(message: local.installing),
        _ => BootScreen(message: local.starting),
      };
    }
    final url = ref.watch(serverBaseUrlProvider);
    return BootScreen(
      message: url.isEmpty ? i18n.boot.starting : i18n.boot.connecting(server: url),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    // Keep the device-notification subscription alive app-wide so an enabled
    // device re-arms after reload, and surface inbound alerts as they arrive.
    ref.watch(deviceNotificationsProvider);
    // Keep the desktop self-updater alive app-wide so it stages a newer build
    // in the background (install-on-quit); inert on mobile/web.
    ref.watch(desktopUpdateProvider);
    ref.listen(desktopNotificationEventsProvider, (_, next) {
      final event = next.value;
      if (event != null) unawaited(presentDesktopNotification(event));
    });
    // X-Auth-Error / expired JWT → toast + back to login (T8.5).
    ref.listen(sessionExpiredProvider, (_, _) {
      AppToast.global(t.auth.sessionExpired, isError: true);
      ref.read(routerProvider).go('/login');
    });
    final themeMode = ref.watch(themeModeProvider);
    final isDark = switch (themeMode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      _ => MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };
    return MaterialApp.router(
      scaffoldMessengerKey: rootMessengerKey,
      scrollBehavior: const NoMouseDragScrollBehavior(),
      title: appWindowTitle(ref.watch(serverBaseUrlProvider)),
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      // Edge-to-edge on Android 15+ draws under the system bars — keep the
      // bar icons readable against our background.
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
        child: Stack(
          children: [
            child ?? const SizedBox.shrink(),
            if (ref.watch(bootingProvider)) _bootScreen(),
          ],
        ),
      ),
      locale: locale.flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
