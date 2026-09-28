import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/auth_image.dart';
import 'package:ddagent_app/core/widgets/code_block.dart';
import 'package:ddagent_app/core/widgets/diff_block.dart';
import 'package:ddagent_app/core/widgets/math_block.dart';
import 'package:ddagent_app/core/widgets/mermaid_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

/// Shared markdown renderer (chat, PRD, notes) — T16.1/16.3.
///
/// Covers headings/lists/tables/links/images/blockquotes via
/// flutter_markdown_plus; fenced code via [CodeBlock] (syntax highlight,
/// copy, wrap); ```diff fences via [DiffBlock]; ```mermaid via [MermaidBlock];
/// display `$$…$$` math is preprocessed into ` ```math ` fences → [MathBlock]
/// (inline `$…$` stays literal — KaTeX parity is only for display math).
class AppMarkdown extends ConsumerWidget {
  const AppMarkdown({super.key, required this.data, this.selectable = true});

  final String data;
  final bool selectable;

  /// Converts display `$$…$$` blocks into `math` fenced code blocks so the
  /// `pre` builder can route them to [MathBlock]. Fenced code regions are
  /// skipped — `$$` inside a ` ``` ` block (e.g. docs showing LaTeX source,
  /// shell snippets) stays literal.
  static String preprocess(String input) {
    // Line scan: prose segments separated by ``` fences; $$…$$ is rewritten
    // only outside fenced code.
    final out = StringBuffer();
    final prose = StringBuffer();
    var inFence = false;

    void flushProse() {
      if (prose.isEmpty) return;
      out.write(
        prose.toString().replaceAllMapped(RegExp(r'\$\$([\s\S]+?)\$\$'), (m) {
          return '\n```math\n${m.group(1)!.trim()}\n```\n';
        }),
      );
      prose.clear();
    }

    for (final line in input.split('\n')) {
      if (line.trimLeft().startsWith('```')) {
        flushProse();
        inFence = !inFence;
        out.writeln(line);
        continue;
      }
      (inFence ? out : prose).writeln(line);
    }
    flushProse();
    return out.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final baseUrl = ref.watch(serverBaseUrlProvider);

    final style = MarkdownStyleSheet.fromTheme(theme).copyWith(
      code: theme.textTheme.bodySmall!.copyWith(
        fontFamily: 'monospace',
        backgroundColor: colors.muted,
        color: colors.foreground,
      ),
      codeblockDecoration: const BoxDecoration(), // CodeBlock draws its own
      blockquoteDecoration: BoxDecoration(
        border: Border(left: BorderSide(color: colors.border, width: 3)),
      ),
      blockquotePadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      tableBorder: TableBorder.all(color: colors.border, width: 0.5),
      a: theme.textTheme.bodyMedium!.copyWith(
        color: colors.primary,
        decoration: TextDecoration.underline,
      ),
    );

    return MarkdownBody(
      data: preprocess(data),
      selectable: selectable,
      styleSheet: style,
      onTapLink: (text, href, title) {
        final uri = href == null ? null : Uri.tryParse(href);
        if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
          launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      imageBuilder: (uri, title, alt) => AuthImage(url: uri.toString()),
      builders: {'pre': _BlockDispatcher(baseUrl)},
    );
  }
}

/// Routes fenced blocks to specialized renderers by `language-*` class.
class _BlockDispatcher extends MarkdownElementBuilder {
  _BlockDispatcher(this.serverBaseUrl);

  final String serverBaseUrl;

  @override
  bool isBlockElement() => true;

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final children = element.children;
    final first = children != null && children.isNotEmpty
        ? children.first
        : element;
    final codeEl = first is md.Element ? first : element;
    final classAttr = codeEl.attributes['class'] ?? '';
    final language = classAttr.startsWith('language-')
        ? classAttr.substring(9)
        : '';
    final code = codeEl.textContent.trimRight();

    return switch (language) {
      'mermaid' => MermaidBlock(code: code, serverBaseUrl: serverBaseUrl),
      'diff' => DiffBlock(diff: code),
      'math' => MathBlock(tex: code),
      _ => CodeBlock(code: code, language: language.isEmpty ? null : language),
    };
  }
}
