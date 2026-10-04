import 'package:ddagent_app/features/chat/view/tool_blocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

Map<String, dynamic> _input() => {
      'questions': [
        {
          'question': 'Pick a scope?',
          'header': 'Scope',
          'options': [
            {'label': 'MVP', 'description': 'small'},
            {'label': 'Full clone'},
          ],
        },
      ],
    };

void main() {
  testWidgets('autoSubmit tap fires onDecision with the picked label', (t) async {
    (bool, Map<String, dynamic>)? got;
    await t.pumpWidget(
      _wrap(
        AskUserQuestionPanel(
          requestId: 'r1',
          input: _input(),
          autoSubmit: true,
          onDecision: (allow, updated) => got = (allow, updated),
        ),
      ),
    );

    await t.tap(find.text('MVP'));
    await t.pump();

    expect(got, isNotNull);
    expect(got!.$1, isTrue);
    expect(got!.$2['answers'], {'Pick a scope?': 'MVP'});
  });

  testWidgets('non-autoSubmit tap only selects; Submit sends answers', (t) async {
    (bool, Map<String, dynamic>)? got;
    await t.pumpWidget(
      _wrap(
        AskUserQuestionPanel(
          requestId: 'r1',
          input: _input(),
          onDecision: (allow, updated) => got = (allow, updated),
        ),
      ),
    );

    await t.tap(find.text('Full clone'));
    await t.pump();
    expect(got, isNull);

    await t.tap(find.text('Submit'));
    await t.pump();
    expect(got?.$2['answers'], {'Pick a scope?': 'Full clone'});
  });
}
