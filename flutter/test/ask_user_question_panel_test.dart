import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/chat/view/tool_blocks.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => TranslationProvider(
  child: ProviderScope(
    child: MaterialApp(
      theme: AppTheme.dark(),
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  ),
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

  testWidgets('planContent renders the plan review and collapses', (t) async {
    await t.pumpWidget(
      _wrap(
        AskUserQuestionPanel(
          requestId: 'r1',
          input: {
            'questions': [
              {
                'question': 'Plan ready for review. Begin implementation?',
                'header': 'Plan Review',
                'planContent': '# My plan\n\n- do the thing',
                'planFilePath': '/home/u/.commandcode/plans/my-plan.md',
                'options': [
                  {'label': 'Yes, auto-accept edits'},
                  {'label': 'Cancel'},
                ],
              },
            ],
          },
          onDecision: (_, _) {},
        ),
      ),
    );

    // Plan file name and markdown body are visible above the options.
    expect(find.text('my-plan.md'), findsOneWidget);
    expect(find.textContaining('do the thing'), findsWidgets);
    expect(find.text('Yes, auto-accept edits'), findsOneWidget);

    // Tapping the header collapses the plan body.
    await t.tap(find.text('my-plan.md'));
    await t.pump();
    expect(find.textContaining('do the thing'), findsNothing);
  });

  testWidgets('a model "Other"-like option reveals the free-text field', (t) async {
    (bool, Map<String, dynamic>)? got;
    await t.pumpWidget(
      _wrap(
        AskUserQuestionPanel(
          requestId: 'r1',
          input: {
            'questions': [
              {
                'question': 'Which rule?',
                'header': 'Colour',
                'options': [
                  {'label': 'Usage vs time'},
                  {'label': 'Inne (wpiszę)', 'description': 'opisz własną regułę'},
                ],
              },
            ],
          },
          onDecision: (allow, updated) => got = (allow, updated),
        ),
      ),
    );

    expect(find.byType(TextField), findsNothing);
    await t.tap(find.text('Inne (wpiszę)'));
    await t.pump();
    expect(find.byType(TextField), findsOneWidget);

    await t.enterText(find.byType(TextField), 'my own rule');
    await t.tap(find.text('Submit'));
    await t.pump();

    expect(got, isNotNull);
    expect(got!.$2['answers'], {'Which rule?': 'Inne (wpiszę), my own rule'});
  });

  test('extractQuestionFreeText keeps only text that is not an option label', () {
    final input = {
      'questions': [
        {
          'question': 'Which rule?',
          'options': [
            {'label': 'Usage vs time'},
            {'label': 'Inne (wpiszę)'},
          ],
        },
      ],
    };
    expect(
      extractQuestionFreeText(input, {
        'answers': {'Which rule?': 'Inne (wpiszę), my own rule'},
      }),
      'my own rule',
    );
    expect(
      extractQuestionFreeText(input, {
        'answers': {'Which rule?': 'Usage vs time'},
      }),
      '',
    );
    expect(
      extractQuestionFreeText(input, {
        'answers': {'Which rule?': 'just my own text'},
      }),
      'just my own text',
    );
  });
}
