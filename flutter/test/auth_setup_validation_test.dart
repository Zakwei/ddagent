import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/auth/state/auth_controller.dart';
import 'package:ddagent_app/features/auth/view/auth_screens.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuth extends AuthController {
  @override
  AuthState build() => const AuthState();
}

Widget _app() => TranslationProvider(
  child: ProviderScope(
    overrides: [authControllerProvider.overrideWith(_FakeAuth.new)],
    child: MaterialApp(
      theme: AppTheme.dark(),
      home: const Scaffold(body: SetupScreen()),
    ),
  ),
);

void main() {
  Future<void> fill(
    WidgetTester tester, {
    String? username,
    String? password,
    String? confirm,
  }) async {
    final fields = find.byType(TextField);
    if (username != null) await tester.enterText(fields.at(0), username);
    if (password != null) await tester.enterText(fields.at(1), password);
    if (confirm != null) await tester.enterText(fields.at(2), confirm);
  }

  testWidgets('SetupScreen validates required → username ≥3 → password ≥6 → match', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pump();

    // Title and button share the label — the button's copy is last.
    final submit = find.text('Create Account').last;

    // All empty → required fields.
    await tester.tap(submit);
    await tester.pump();
    expect(find.text('Please fill in all fields'), findsOneWidget);

    // Short username.
    await fill(tester, username: 'ab', password: 'secret6', confirm: 'secret6');
    await tester.tap(submit);
    await tester.pump();
    expect(find.text('Username must be at least 3 characters'), findsOneWidget);

    // Short password.
    await fill(tester, username: 'alice', password: '12345', confirm: '12345');
    await tester.tap(submit);
    await tester.pump();
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);

    // Mismatch.
    await fill(tester, username: 'alice', password: 'secret6', confirm: 'secret7');
    await tester.tap(submit);
    await tester.pump();
    expect(find.text('Passwords do not match'), findsOneWidget);
  });
}
