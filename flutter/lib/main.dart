import 'package:ddagent_app/core/platform/window.dart';
import 'package:ddagent_app/core/router/app_router.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/theme/theme_controller.dart';
import 'package:ddagent_app/features/settings/state/locale_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initStorage();
  usePathUrlStrategy(); // web: /chat/42 not /#/chat/42 (T7.4)
  await initWindow();
  runApp(TranslationProvider(child: const ProviderScope(child: DdagentApp())));
}

class DdagentApp extends ConsumerWidget {
  const DdagentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
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
