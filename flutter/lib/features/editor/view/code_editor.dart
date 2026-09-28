import 'dart:math' as math;

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:highlight/highlight.dart' show highlight, Node;

/// Editable code surface: line-number gutter, syntax highlighting through
/// [TextEditingController.buildTextSpan], optional minimap, Tab-indent and
/// undo history. The buffer is controlled — [content] is pushed down by the
/// parent (editorProvider tab), edits flow back through [onChanged].
///
/// ponytail: TextField renders the whole buffer inside one vertical
/// ScrollView (no viewport culling) — fine for typical source files; a
/// virtualized editor is the upgrade path for multi-MB files.
class CodeEditor extends StatefulWidget {
  const CodeEditor({
    super.key,
    required this.content,
    this.language,
    this.fontSize = 13,
    this.tabSize = 2,
    this.wordWrap = true,
    this.minimap = true,
    this.onChanged,
  });

  final String content;
  final String? language;
  final double fontSize;
  final int tabSize;
  final bool wordWrap;
  final bool minimap;
  final ValueChanged<String>? onChanged;

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  late final _controller = _HighlightingController(text: widget.content);
  final _vScroll = ScrollController();
  final _hScroll = ScrollController();
  final _undo = UndoHistoryController();
  final _undoFocus = FocusNode();

  // Measurement cache — invalidated when text/width/style inputs change.
  String _measuredText = '';
  double _measuredWidth = -1;
  bool _measuredWrap = true;
  List<double> _lineHeights = const [];
  double _maxLineWidth = 0;
  double _lineHeight = 0;
  int _caretLine = 0;

  List<String> get _lines => _controller.text.split('\n');

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _vScroll.dispose();
    _hScroll.dispose();
    _undo.dispose();
    _undoFocus.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CodeEditor old) {
    super.didUpdateWidget(old);
    // External change (reload, merge apply, discard) — adopt the new buffer.
    if (widget.content != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.content,
        selection: TextSelection.collapsed(offset: widget.content.length),
      );
    }
  }

  void _onControllerChange() {
    final line = _caretLineOf(_controller.selection.baseOffset);
    if (line != _caretLine) setState(() => _caretLine = line);
  }

  int _caretLineOf(int offset) {
    if (offset <= 0) return 0;
    final text = _controller.text;
    var line = 0;
    final end = math.min(offset, text.length);
    for (var i = 0; i < end; i++) {
      if (text.codeUnitAt(i) == 0x0A) line++;
    }
    return line;
  }

  TextStyle _textStyle() => TextStyle(
    fontFamily: 'monospace',
    fontSize: widget.fontSize,
    color: context.appColors.foreground,
  );

  StrutStyle get _strut => StrutStyle(
    fontFamily: 'monospace',
    fontSize: widget.fontSize,
    height: 1.4,
    forceStrutHeight: true,
  );

  void _insertIndent() {
    final sel = _controller.selection;
    final indent = ' ' * widget.tabSize;
    if (!sel.isValid) return;
    final text = _controller.text;
    final start = math.min(sel.start, sel.end);
    final end = math.max(sel.start, sel.end);
    _controller.value = TextEditingValue(
      text: text.replaceRange(start, end, indent),
      selection: TextSelection.collapsed(offset: start + indent.length),
    );
  }

  void _outdent() {
    final sel = _controller.selection;
    if (!sel.isValid || sel.start != sel.end) return;
    final text = _controller.text;
    final lineStart = text.lastIndexOf('\n', math.max(0, sel.start - 1)) + 1;
    var remove = 0;
    while (remove < widget.tabSize &&
        lineStart + remove < text.length &&
        text[lineStart + remove] == ' ') {
      remove++;
    }
    if (remove == 0) return;
    _controller.value = TextEditingValue(
      text: text.replaceRange(lineStart, lineStart + remove, ''),
      selection: TextSelection.collapsed(
        offset: math.max(lineStart, sel.start - remove),
      ),
    );
  }

  /// Measure per-line heights (for the gutter) and the longest line width
  /// (for the no-wrap horizontal scroller).
  void _measure(TextStyle style, double textWidth) {
    final text = _controller.text;
    if (_measuredText == text &&
        _measuredWidth == textWidth &&
        _measuredWrap == widget.wordWrap) {
      return;
    }
    _measuredText = text;
    _measuredWidth = textWidth;
    _measuredWrap = widget.wordWrap;

    final probe = TextPainter(
      text: TextSpan(text: 'Ag', style: style),
      strutStyle: _strut,
      textDirection: TextDirection.ltr,
    )..layout();
    _lineHeight = probe.height;

    final lines = text.split('\n');
    if (!widget.wordWrap) {
      var maxW = 0.0;
      for (final line in lines) {
        if (line.isEmpty) continue;
        final p = TextPainter(
          text: TextSpan(text: line, style: style),
          strutStyle: _strut,
          textDirection: TextDirection.ltr,
          maxLines: 1,
        )..layout();
        if (p.width > maxW) maxW = p.width;
      }
      _lineHeights = List.filled(lines.length, _lineHeight);
      _maxLineWidth = maxW;
    } else {
      _lineHeights = [
        for (final line in lines)
          line.isEmpty
              ? _lineHeight
              : (TextPainter(
                  text: TextSpan(text: line, style: style),
                  strutStyle: _strut,
                  textDirection: TextDirection.ltr,
                )..layout(maxWidth: textWidth)).height,
      ];
      _maxLineWidth = textWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final style = _textStyle();
    _controller
      ..language = widget.language
      ..baseStyle = style
      ..themeMap = dark ? atomOneDarkTheme : atomOneLightTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final minimapW = widget.minimap ? 64.0 : 0.0;
        final availW = constraints.maxWidth - minimapW;
        // Gutter width: digit width × digits + padding.
        final digits = _lines.length.toString().length;
        final gutterW = digits * widget.fontSize * 0.62 + 20;
        final textW = math.max(0.0, availW - gutterW);
        _measure(style, textW);
        final totalHeight = _lineHeights.fold(0.0, (a, b) => a + b);

        final field = CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.tab): _insertIndent,
            const SingleActivator(LogicalKeyboardKey.tab, shift: true):
                _outdent,
          },
          child: UndoHistory(
            value: _undo,
            focusNode: _undoFocus,
            onTriggered: (_) {},
            child: TextField(
              controller: _controller,
              maxLines: null,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              keyboardType: TextInputType.multiline,
              style: style,
              strutStyle: _strut,
              cursorColor: colors.primary,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: widget.onChanged,
            ),
          ),
        );

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _vScroll,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Gutter(
                      heights: _lineHeights,
                      caretLine: _caretLine,
                      width: gutterW,
                      style: style,
                    ),
                    Expanded(
                      child: widget.wordWrap
                          ? Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: field,
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: _hScroll,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: SizedBox(
                                  width: math.max(
                                    textW - 8,
                                    _maxLineWidth + widget.fontSize,
                                  ),
                                  child: field,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.minimap)
              _Minimap(
                lines: _lines,
                scroll: _vScroll,
                contentHeight: totalHeight,
                color: colors.mutedForeground,
                border: colors.border,
              ),
          ],
        );
      },
    );
  }
}

/// Controller that syntax-highlights via `highlight.parse` in
/// [buildTextSpan]. Re-parses only when the text actually changes.
/// ponytail: whole-buffer parse per edit — O(file) per keystroke, fine for
/// editor-sized files; incremental highlighting would need a richer engine.
class _HighlightingController extends TextEditingController {
  _HighlightingController({super.text});

  String? language;
  TextStyle baseStyle = const TextStyle();
  Map<String, TextStyle> themeMap = const {};

  String _parsedText = '';
  List<TextSpan> _spans = const [];

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final lang = language;
    if (lang == null || text.isEmpty) {
      return TextSpan(style: baseStyle, text: text);
    }
    try {
      if (text != _parsedText) {
        _parsedText = text;
        final nodes =
            highlight.parse(text, language: lang).nodes ?? const <Node>[];
        _spans = [for (final n in nodes) ..._nodeSpans(n)];
      }
      return TextSpan(style: baseStyle, children: _spans);
    } on Exception {
      return TextSpan(style: baseStyle, text: text);
    }
  }

  List<TextSpan> _nodeSpans(Node node) {
    final style = baseStyle.merge(themeMap[node.className]);
    if (node.children != null) {
      return [for (final c in node.children!) ..._nodeSpans(c)];
    }
    return [TextSpan(text: node.value, style: style)];
  }
}

/// Line-number gutter. Rows use measured heights so wrapped lines stay
/// aligned with the text column.
class _Gutter extends StatelessWidget {
  const _Gutter({
    required this.heights,
    required this.caretLine,
    required this.width,
    required this.style,
  });

  final List<double> heights;
  final int caretLine;
  final double width;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final numStyle = style.copyWith(
      color: colors.mutedForeground.withValues(alpha: 0.7),
      fontSize: style.fontSize! * 0.9,
    );
    final activeStyle = numStyle.copyWith(color: colors.foreground);
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: colors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < heights.length; i++)
            SizedBox(
              height: heights[i],
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    '${i + 1}',
                    style: i == caretLine ? activeStyle : numStyle,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Right-rail minimap: one bar per line (width ∝ line length), a viewport
/// rectangle tracking [_vScroll], tap/drag to scroll.
class _Minimap extends StatefulWidget {
  const _Minimap({
    required this.lines,
    required this.scroll,
    required this.contentHeight,
    required this.color,
    required this.border,
  });

  final List<String> lines;
  final ScrollController scroll;
  final double contentHeight;
  final Color color;
  final Color border;

  @override
  State<_Minimap> createState() => _MinimapState();
}

class _MinimapState extends State<_Minimap> {
  @override
  void initState() {
    super.initState();
    widget.scroll.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(_Minimap old) {
    super.didUpdateWidget(old);
    if (old.scroll != widget.scroll) {
      old.scroll.removeListener(_onScroll);
      widget.scroll.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.scroll.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (mounted) setState(() {});
  }

  void _jumpTo(double y, double mapHeight) {
    if (!widget.scroll.hasClients ||
        widget.contentHeight <= 0 ||
        widget.lines.isEmpty) {
      return;
    }
    final drawnH = _drawnHeight(mapHeight);
    final frac = (y / drawnH).clamp(0.0, 1.0);
    final pos = widget.scroll.position;
    widget.scroll.jumpTo(
      (frac * widget.contentHeight - pos.viewportDimension / 2).clamp(
        0.0,
        pos.maxScrollExtent,
      ),
    );
  }

  double _drawnHeight(double mapHeight) =>
      math.max(widget.lines.length * 2.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mapH = constraints.maxHeight;
        final drawnH = _drawnHeight(mapH);
        final ready =
            widget.scroll.hasClients &&
            widget.scroll.position.hasContentDimensions;
        final offset = ready ? widget.scroll.offset : 0.0;
        final maxExtent = ready ? widget.scroll.position.maxScrollExtent : 0.0;
        final viewportH = ready
            ? widget.scroll.position.viewportDimension
            : mapH;
        // Scale: fit whole doc when possible, else keep 2px rows and shift.
        final fitAll = drawnH <= mapH;
        final scale = fitAll ? mapH / math.max(widget.contentHeight, 1) : 1.0;
        final drawnDocH = fitAll ? mapH : drawnH;
        final shift = (!fitAll && maxExtent > 0)
            ? (offset / maxExtent) * math.max(0.0, drawnH - mapH)
            : 0.0;
        final rectH =
            (viewportH / math.max(widget.contentHeight, 1)) * drawnDocH;
        final rectTop =
            (offset / math.max(widget.contentHeight, 1)) * drawnDocH - shift;

        return GestureDetector(
          onTapDown: (d) => _jumpTo(d.localPosition.dy + shift, mapH),
          onVerticalDragUpdate: (d) =>
              _jumpTo(d.localPosition.dy + shift, mapH),
          child: Container(
            key: const Key('editor-minimap'),
            width: 64,
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: 0.04),
              border: Border(left: BorderSide(color: widget.border)),
            ),
            clipBehavior: Clip.antiAlias,
            child: CustomPaint(
              painter: _MinimapPainter(
                lines: widget.lines,
                color: widget.color,
                scale: scale,
                shift: shift,
                viewport: Rect.fromLTWH(0, rectTop, 64, rectH),
              ),
              size: Size(64, mapH),
            ),
          ),
        );
      },
    );
  }
}

class _MinimapPainter extends CustomPainter {
  _MinimapPainter({
    required this.lines,
    required this.color,
    required this.scale,
    required this.shift,
    required this.viewport,
  });

  final List<String> lines;
  final Color color;
  final double scale;
  final double shift;
  final Rect viewport;

  @override
  void paint(Canvas canvas, Size size) {
    final barPaint = Paint()..color = color.withValues(alpha: 0.45);
    // Each source line: lineHeight·scale ≈ a couple px; bar width tracks
    // content length (a rough code-shape silhouette).
    final rowH = 2.0 * scale;
    for (var i = 0; i < lines.length; i++) {
      final y = i * rowH - shift;
      if (y > size.height) break;
      if (y + rowH < 0) continue;
      final len = lines[i].trimRight().length;
      if (len == 0) continue;
      final w = math.min(size.width - 4, len * 1.1);
      canvas.drawRect(
        Rect.fromLTWH(3, y, w, math.max(rowH - 0.6, 0.5)),
        barPaint,
      );
    }
    canvas.drawRect(viewport, Paint()..color = color.withValues(alpha: 0.15));
    canvas.drawRect(
      viewport,
      Paint()
        ..color = color.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_MinimapPainter old) =>
      old.lines != lines ||
      old.scale != scale ||
      old.shift != shift ||
      old.viewport != viewport;
}
