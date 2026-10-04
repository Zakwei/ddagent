import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppDialog.pop closes the dialog over a nested shell navigator', (tester) async {
    String? result;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        // Mirror the go_router ShellRoute: the page lives on an inner
        // navigator while showDialog mounts the dialog on the root one.
        home: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (_) => Scaffold(
              body: Builder(
                builder: (context) => Center(
                  child: AppButton(
                    onPressed: () async {
                      result = await AppDialog.show<String>(
                        context,
                        title: 'New file',
                        content: const Text('name'),
                        actions: [
                          AppButton(
                            variant: AppButtonVariant.ghost,
                            onPressed: () => AppDialog.pop(context),
                            child: const Text('Cancel'),
                          ),
                          AppButton(
                            onPressed: () => AppDialog.pop(context, 'created'),
                            child: const Text('Create'),
                          ),
                        ],
                      );
                    },
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Create'), findsOneWidget);

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(result, 'created');
    expect(find.text('Create'), findsNothing, reason: 'dialog should close');
    expect(find.text('open'), findsOneWidget, reason: 'the page must stay mounted');
  });
}
