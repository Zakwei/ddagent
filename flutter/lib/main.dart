import 'package:ddagent_app/core/config/env.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/theme/theme_controller.dart';
import 'package:ddagent_app/features/settings/state/locale_controller.dart';
import 'package:ddagent_app/features/settings/ui/language_picker.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initStorage();
  runApp(TranslationProvider(child: const ProviderScope(child: DdagentApp())));
}

class DdagentApp extends ConsumerWidget {
  const DdagentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      title: 'ddagent',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(themeModeProvider),
      locale: locale.flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: const BootstrapPage(),
    );
  }
}

class BootstrapPage extends StatelessWidget {
  const BootstrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ddagent')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('env: ${Env.environment.name}'),
            Text(
              'server: ${Env.defaultServerUrl.isEmpty ? '(not configured)' : Env.defaultServerUrl}',
            ),
            const SizedBox(height: 16),
            Text('${t.common.buttons.save} / ${t.common.status.loading}'),
            const LanguagePicker(),
          ],
        ),
      ),
    );
  }
}
