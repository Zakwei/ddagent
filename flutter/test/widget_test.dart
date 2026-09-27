import 'package:ddagent_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App boots and shows env info', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: DdagentApp()));

    expect(find.text('ddagent'), findsOneWidget);
    expect(find.textContaining('env:'), findsOneWidget);
  });
}
