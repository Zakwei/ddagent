import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/widgets/app_markdown.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('chat markdown lists, links and code are part of the selection', (tester) async {
    var selected = '';
    await tester.pumpWidget(
      TranslationProvider(
        child: ProviderScope(
          child: MaterialApp(
            theme: AppTheme.ocChat(),
            home: Scaffold(
              body: SelectionArea(
                onSelectionChanged: (c) => selected = c?.plainText ?? '',
                child: const AppMarkdown(
                  selectable: false,
                  data:
                      '- first item\n- [a link](https://example.com)\n\n'
                      'Inline `code` here.\n\n```dart\nfinal x = 1;\n```\n',
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('first item'));
    await tester.sendKeyDownEvent(LogicalKeyboardKey.control);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.control);
    await tester.pump();
    for (final part in ['first item', 'a link', 'code', 'final x = 1;']) {
      expect(selected, contains(part));
    }
  });
}
