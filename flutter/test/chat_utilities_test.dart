import 'package:ddagent_app/features/chat/view/chat_utilities.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:flutter_test/flutter_test.dart';

SessionMessage _m(String kind, {String? content, String? role, String? tool}) =>
    SessionMessage(
      id: 'x',
      sessionId: 's',
      timestamp: 't',
      provider: 'claude',
      kind: kind,
      content: content,
      role: role,
      toolName: tool,
    );

void main() {
  test('formatTokenCount buckets', () {
    expect(formatTokenCount(0), '0');
    expect(formatTokenCount(950), '950');
    expect(formatTokenCount(1500), '1.5K');
    expect(formatTokenCount(25000), '25K');
    expect(formatTokenCount(2500000), '2.5M');
    expect(formatTokenCount(25000000), '25M');
  });

  test('parseUsage folds cache into input only with breakdown', () {
    final withBd = parseUsage({
      'used': 100,
      'inputTokens': 80,
      'outputTokens': 20,
      'breakdown': {'input': 80, 'output': 20, 'cacheRead': 500},
    });
    expect(withBd.input, 80);
    expect(withBd.cacheRead, 500);

    // No breakdown → cache is carved out of reported input.
    final bare = parseUsage({
      'used': 600,
      'inputTokens': 580,
      'outputTokens': 20,
      'cacheReadTokens': 500,
    });
    expect(bare.input, 80);
    expect(bare.contextPercent, isNull);
  });

  test('estimateCostUsd substring match + unknown', () {
    expect(estimateCostUsd(model: 'claude-sonnet-4', input: 1e6), 3);
    expect(estimateCostUsd(model: 'unknown-thing', input: 1e6), isNull);
    expect(formatCostUsd(null), '—');
    expect(formatCostUsd(0.12), '\$0.120');
  });

  test('transcriptToMarkdown marks user and tools', () {
    final md = transcriptToMarkdown([
      _m('text', content: 'hi', role: 'user'),
      _m('thinking', content: 'hmm'),
      _m('tool_use', tool: 'bash', content: 'ls'),
    ]);
    expect(md, contains('**You:** hi'));
    expect(md, contains('_thinking:_'));
    expect(md, contains('```tool:bash'));
  });

  test('transcriptToHtml escapes markup', () {
    final html = transcriptToHtml([_m('text', content: '<b>&</b>')]);
    expect(html, contains('&lt;b&gt;&amp;&lt;/b&gt;'));
    expect(html, isNot(contains('<b>&</b>')));
  });
}
