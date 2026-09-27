import 'package:ddagent_app/core/config/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: DdagentApp()));
}

class DdagentApp extends StatelessWidget {
  const DdagentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ddagent',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
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
