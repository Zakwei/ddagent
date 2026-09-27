import 'package:ddagent_app/core/config/env.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initStorage();
  runApp(const ProviderScope(child: DdagentApp()));
}

class DdagentApp extends ConsumerWidget {
  const DdagentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'ddagent',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(themeModeProvider),
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
          ],
        ),
      ),
    );
  }
}
