import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/utils/clipboard.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async => LocaleSettings.setLocale(AppLocale.en));

  Future<void> runUnder(WidgetTester tester, Future<void> Function(BuildContext) run) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          theme: AppTheme.dark(),
          home: Scaffold(
            body: Builder(
              builder: (c) {
                ctx = c;
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
    await run(ctx);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('copies text and toasts on success', (tester) async {
    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (
      call,
    ) async {
      calls.add(call);
      return null;
    });
    bool? result;
    await runUnder(tester, (ctx) async {
      result = await copyTextWithFeedback(ctx, 'hello');
    });
    expect(result, isTrue);
    expect(calls.any((c) => c.method == 'Clipboard.setData'), isTrue);
    expect(find.text('Message copied'), findsOneWidget);
  });

  testWidgets('toasts an error when the platform rejects', (tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (
      call,
    ) async {
      if (call.method == 'Clipboard.setData') {
        throw PlatformException(code: 'clipboard-denied');
      }
      return null;
    });
    bool? result;
    await runUnder(tester, (ctx) async {
      result = await copyTextWithFeedback(ctx, 'hello');
    });
    expect(result, isFalse);
    expect(find.text('Copy failed'), findsOneWidget);
  });

  testWidgets('empty text is a silent no-op', (tester) async {
    bool? result;
    await runUnder(tester, (ctx) async {
      result = await copyTextWithFeedback(ctx, '   ');
    });
    expect(result, isFalse);
  });
}
