import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:highlight/highlight.dart' show highlight, Node;

/// Fenced code block: syntax highlight + filename/language header + copy
/// button + line-wrap toggle (T16.2).
class CodeBlock extends StatefulWidget {
  const CodeBlock({super.key, required this.code, this.language, this.filename});

  final String code;
  final String? language;
  final String? filename;

  @override
  State<CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<CodeBlock> {
  bool _wrap = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final dark = theme.brightness == Brightness.dark;
    final mono = theme.textTheme.bodySmall!.copyWith(fontFamily: 'monospace', fontSize: 12.5);

    final spans = _highlight(
      widget.code,
      widget.language,
      dark ? atomOneDarkTheme : atomOneLightTheme,
      mono,
    );

    return Container(
      decoration: BoxDecoration(
        color: colors.muted.withValues(alpha: 0.45),
        border: Border.all(color: colors.border),
        borderRadius: AppRadii.borderMd,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(context),
          _wrap
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: SelectableText.rich(TextSpan(children: spans), style: mono),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(10),
                  child: SelectableText.rich(TextSpan(children: spans), style: mono),
                ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final label = widget.filename ?? widget.language ?? 'code';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.muted.withValues(alpha: 0.6),
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.labelSmall!.copyWith(
                fontFamily: 'monospace',
                color: colors.mutedForeground,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            tooltip: _wrap ? 'No wrap' : 'Wrap lines',
            visualDensity: VisualDensity.compact,
            icon: Icon(_wrap ? Icons.wrap_text : Icons.align_horizontal_left, size: 15),
            onPressed: () => setState(() => _wrap = !_wrap),
          ),
          IconButton(
            tooltip: 'Copy',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.copy_outlined, size: 15),
            onPressed: () => Clipboard.setData(ClipboardData(text: widget.code)),
          ),
        ],
      ),
    );
  }

  static List<TextSpan> _highlight(
    String code,
    String? language,
    Map<String, TextStyle> themeMap,
    TextStyle base,
  ) {
    try {
      final nodes = highlight.parse(code, language: language).nodes ?? const [];
      return [for (final n in nodes) ..._nodeSpans(n, themeMap, base)];
    } on Exception {
      return [TextSpan(text: code, style: base)];
    }
  }

  static List<TextSpan> _nodeSpans(Node node, Map<String, TextStyle> themeMap, TextStyle base) {
    final style = base.merge(themeMap[node.className]);
    if (node.children != null) {
      return [for (final c in node.children!) ..._nodeSpans(c, themeMap, style)];
    }
    return [TextSpan(text: node.value, style: style)];
  }
}
