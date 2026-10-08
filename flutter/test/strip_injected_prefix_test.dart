import 'package:ddagent_app/features/sessions/state/message_merge.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('stripInjectedPrefix leaves only the typed text of a first turn', () {
    expect(
      stripInjectedPrefix('<unified-rules>\nrules\n</unified-rules>\n\nReply PONG.'),
      'Reply PONG.',
    );
    expect(stripInjectedPrefix('Plain prompt'), 'Plain prompt');
  });
}
