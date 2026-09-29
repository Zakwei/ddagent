import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/sessions/view/provider_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProviderLogo renders every provider mark', (tester) async {
    for (final provider in [
      'claude',
      'devin',
      'opencode',
      'codex',
      'cursor',
      'orchestrator',
      null,
      'unknown-future',
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: Center(child: ProviderLogo(provider: provider)),
          ),
        ),
      );
      expect(tester.takeException(), isNull, reason: '$provider');
    }
  });
}
