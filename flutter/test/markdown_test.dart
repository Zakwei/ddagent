import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/widgets/app_markdown.dart';
import 'package:ddagent_app/core/widgets/code_block.dart';
import 'package:ddagent_app/core/widgets/diff_block.dart';
import 'package:ddagent_app/core/widgets/math_block.dart';
import 'package:ddagent_app/core/widgets/mermaid_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => ProviderScope(
  child: MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  ),
);

void main() {
  testWidgets('AppMarkdown renders headings, code, diff, math, mermaid', (tester) async {
    const md = '''
# Title

Some `inline` **bold** text.

```dart
void main() {}
```

```diff
+added
-removed
@@ hunk
```

```mermaid
graph TD; A-->B
```

\$\$x^2\$\$
''';
    await tester.pumpWidget(_wrap(const AppMarkdown(data: md)));
    await tester.pump();
    expect(find.text('Title'), findsOneWidget);
    expect(find.byType(CodeBlock), findsNWidgets(2)); // dart + mermaid raw source
    expect(find.byType(DiffBlock), findsOneWidget);
    expect(find.byType(MermaidBlock), findsOneWidget);
    expect(find.byType(MathBlock), findsOneWidget); // $$ → math fence
  });

  testWidgets('code block has copy + wrap controls', (tester) async {
    await tester.pumpWidget(_wrap(const AppMarkdown(data: '```js\nconst a=1\n```')));
    await tester.pump();
    expect(find.byTooltip('Copy'), findsOneWidget);
    expect(find.byTooltip('Wrap lines'), findsOneWidget);
  });

  testWidgets('unlabelled fence renders as plain code, not an error box', (tester) async {
    // `highlight.parse(language: null)` throws ArgumentError; an unlabelled
    // fence used to crash the whole transcript. Render it as plain text.
    await tester.pumpWidget(_wrap(const AppMarkdown(data: '```\nplain text\n```')));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byType(CodeBlock), findsOneWidget);
    expect(find.text('plain text'), findsOneWidget);
  });

  test('preprocess converts display math to math fence', () {
    final out = AppMarkdown.preprocess('a \$\$x+1\$\$ b');
    expect(out, contains('```math\nx+1\n```'));
    expect(AppMarkdown.preprocess('no math').trim(), 'no math');
  });

  test(r'preprocess leaves $$ inside fenced code untouched', () {
    const input = 'text \$\$a\$\$\n```sh\necho \$\$HOME\$\$\n```\nend \$\$b\$\$';
    final out = AppMarkdown.preprocess(input);
    expect(out, contains('```math\na\n```'));
    expect(out, contains('echo \$\$HOME\$\$'));
    expect(out, contains('```math\nb\n```'));
  });
}
