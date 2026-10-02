import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/platform/window.dart';
import 'package:ddagent_app/core/router/app_router.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/theme/theme_controller.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/settings/state/locale_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
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

class DdagentApp extends ConsumerWidget {
  const DdagentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    // X-Auth-Error / expired JWT → toast + back to login (T8.5).
    ref.listen(sessionExpiredProvider, (_, _) {
      final ctx = rootMessengerKey.currentContext;
      if (ctx != null) AppToast.error(ctx, Translations.of(ctx).auth.sessionExpired);
      ref.read(routerProvider).go('/login');
    });
    return MaterialApp.router(
      scaffoldMessengerKey: rootMessengerKey,
      title: 'ddagent',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(themeModeProvider),
      locale: locale.flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
