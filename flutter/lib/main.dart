import 'dart:async';
import 'dart:ui' show AppExitResponse;

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/platform/window.dart';
import 'package:ddagent_app/core/realtime/notifications_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/router/app_router.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/theme/theme_controller.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/core/widgets/text_selection_scroll_behavior.dart';
import 'package:ddagent_app/features/notifications/data/desktop_notification_presenter.dart';
import 'package:ddagent_app/features/notifications/state/device_notifications_controller.dart';
import 'package:ddagent_app/features/server_connect/state/local_server_controller.dart';
import 'package:ddagent_app/features/settings/state/locale_controller.dart';
import 'package:ddagent_app/features/system/state/update_controller.dart';
import 'package:ddagent_app/features/workspace/state/workspace_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // A failed init must not leave a dead white page — the UI still renders and
  // degraded features surface their own errors. (e.g. IndexedDB is
  // unavailable in some private-browsing modes.)
  try {
    await initStorage();
  } on Object catch (_) {}
  usePathUrlStrategy(); // web: /chat/42 not /#/chat/42 (T7.4)
  try {
    await initWindow();
  } on Object catch (_) {}
  runApp(TranslationProvider(child: const ProviderScope(child: DdagentApp())));
}

/// Snackbars fired outside a route context (e.g. session-expired listener).
final rootMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Surfaces an inbound device notification: an OS/browser notification when the
/// platform supports it, otherwise an in-app toast (web permission denied, or
/// native builds without a notification plugin).
Future<void> presentDesktopNotification(DesktopNotification event) async {
  final title = event.title?.trim();
  final body = event.body?.trim() ?? '';
  final resolvedTitle = (title == null || title.isEmpty) ? 'DDAgent' : title;
  if (await showDesktopNotification(title: resolvedTitle, body: body)) return;
  final context = rootMessengerKey.currentContext;
  if (context != null && context.mounted) {
    AppToast.show(context, body.isEmpty ? resolvedTitle : '$resolvedTitle: $body');
  }
}

class DdagentApp extends ConsumerStatefulWidget {
  const DdagentApp({super.key});

  @override
  ConsumerState<DdagentApp> createState() => _DdagentAppState();
}

class _DdagentAppState extends ConsumerState<DdagentApp> {
  // On quit: apply a staged desktop update (detached installer), then kill the
  // app-spawned local server (an adopted external server is left alone;
  // orphans are re-adopted on next launch anyway).
  late final AppLifecycleListener _lifecycle = AppLifecycleListener(
    // Cross-device workspace sync: flush pending pane edits before the OS
    // suspends us, and re-read the server's panes on every wake.
    onHide: () => _workspace()?.onAppBackgrounded(),
    onPause: () => _workspace()?.onAppBackgrounded(),
    onResume: () => _workspace()?.onAppResumed(),
    onExitRequested: () async {
      try {
        await ref.read(desktopUpdateProvider.notifier).applyOnExit();
      } on Object catch (_) {
        // A failed hand-off must never block quitting.
      }
      await ref.read(localServerProvider.notifier).stop();
      return AppExitResponse.exit;
    },
  );

  @override
  void initState() {
    super.initState();
    // `late` is lazy — touch it so the listener registers at mount.
    _lifecycle;
  }

  // Only when already built (signed in, workspace mounted) — never spin up the
  // socket from a lifecycle callback.
  WorkspaceController? _workspace() =>
      ref.exists(workspaceProvider) ? ref.read(workspaceProvider.notifier) : null;

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
      final ctx = rootMessengerKey.currentContext;
      if (ctx != null) AppToast.error(ctx, Translations.of(ctx).auth.sessionExpired);
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
      title: Translations.of(context).sidebar.app.title,
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
        child: child ?? const SizedBox.shrink(),
      ),
      locale: locale.flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
