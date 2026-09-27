import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// KaTeX-equivalent block — native `flutter_math_fork` Math.tex instead of the
/// WebView `/island/katex` used by the React Native shell (T16.6 decision:
/// native render — works on every target platform incl. web, no webview).
class MathBlock extends StatelessWidget {
  const MathBlock({super.key, required this.tex, this.display = true});

  final String tex;

  /// display math (block $$…$$) vs inline.
  final bool display;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final math = Math.tex(
      tex,
      textStyle: Theme.of(context).textTheme.bodyMedium!
          .copyWith(color: colors.foreground),
      mathStyle: display ? MathStyle.display : MathStyle.text,
      onErrorFallback: (err) => Text(
        tex,
        style: Theme.of(context).textTheme.bodySmall!
            .copyWith(fontFamily: 'monospace'),
      ),
    );
    if (!display) return math;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: math,
      ),
    );
  }
}
