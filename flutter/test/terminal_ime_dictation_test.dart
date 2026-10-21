import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xterm/xterm.dart';

void main() {
  // Gboard voice typing commits partial text as it recognises it and rewrites
  // its own last fragment. Upstream xterm reset the IME field after every
  // commit, which ends the dictation mid-word (packages/xterm).
  testWidgets('dictated text reaches the terminal without resetting the IME field', (tester) async {
    final terminal = Terminal();
    final sent = <String>[];
    terminal.onOutput = sent.add;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: TerminalView(terminal, autofocus: true, deleteDetection: true)),
      ),
    );
    await tester.pump();

    void ime(String text) => tester.testTextInput.updateEditingValue(
      TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      ),
    );
    bool resetSince(int from) =>
        tester.testTextInput.log.skip(from).any((c) => c.method == 'TextInput.setEditingState');

    final mark = tester.testTextInput.log.length;
    ime('  Prz');
    ime('  Przepra');
    ime('  Przep'); // Gboard rewrites its partial: two characters back
    ime('  Przepraszam');
    expect(sent.join(), 'Przepra\x7f\x7fraszam');
    expect(resetSince(mark), isFalse);

    sent.clear();
    ime('  Przepraszam\n');
    expect(sent.join(), '\n');
    expect(resetSince(mark), isTrue);

    // Backspace on the delete-detection padding still reaches the terminal.
    sent.clear();
    ime(' ');
    expect(sent, ['\x7f']);
  });
}
