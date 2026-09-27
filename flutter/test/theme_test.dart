import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_badge.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_card.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('base widgets render under light and dark themes', (tester) async {
    for (final theme in [AppTheme.light(), AppTheme.dark()]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Column(
              children: [
                AppButton(onPressed: () {}, child: const Text('ok')),
                const AppButton(
                  variant: AppButtonVariant.destructive,
                  onPressed: null,
                  child: Text('del'),
                ),
                const AppInput(hint: 'hint'),
                const AppCard(child: Text('card')),
                const AppBadge(label: '3'),
                const AppSpinner(),
                const AppSkeleton(width: 100),
              ],
            ),
          ),
        ),
      );
      expect(find.text('ok'), findsOneWidget);
      expect(find.byType(AppSpinner), findsOneWidget);
    }
  });

  test('breakpoints', () {
    expect(AppBreakpoints.forWidth(500), AppBreakpoint.compact);
    expect(AppBreakpoints.forWidth(600), AppBreakpoint.medium);
    expect(AppBreakpoints.forWidth(1200), AppBreakpoint.medium);
    expect(AppBreakpoints.forWidth(1201), AppBreakpoint.expanded);
  });

  test('themes expose token extensions', () {
    expect(AppTheme.light().extension<AppColors>(), AppColors.light);
    expect(AppTheme.dark().extension<AppNavTokens>(), isNotNull);
  });
}
