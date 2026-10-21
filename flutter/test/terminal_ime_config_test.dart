import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xterm/xterm.dart';

void main() {
  // Upstream xterm.dart opens the IME without personalized learning, which
  // puts Gboard in incognito mode with voice typing off (packages/xterm).
  testWidgets('the terminal IME connection keeps Gboard voice typing available', (tester) async {
    final configs = <Map<String, dynamic>>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.textInput, (
      call,
    ) async {
      if (call.method == 'TextInput.setClient') {
        final args = call.arguments as List<dynamic>;
        configs.add((args[1] as Map<dynamic, dynamic>).cast<String, dynamic>());
      }
      return null;
    });
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.textInput,
        null,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: TerminalView(Terminal(), autofocus: true))),
    );
    await tester.pump();

    expect(configs, isNotEmpty);
    expect(configs.last['enableIMEPersonalizedLearning'], isTrue);
  });
}
