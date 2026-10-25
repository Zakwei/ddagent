import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('a global toast shows from the root messenger above the app theme', (tester) async {
    // MaterialApp builds the messenger outside its Theme, as in the app.
    await tester.pumpWidget(
      MaterialApp(
        scaffoldMessengerKey: rootMessengerKey,
        theme: AppTheme.light(),
        home: const Scaffold(body: SizedBox()),
      ),
    );

    AppToast.global('Session not found', isError: true);
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Session not found'), findsOneWidget);
  });
}
