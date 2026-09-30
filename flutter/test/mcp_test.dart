import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/features/mcp/data/mcp_formatting.dart';
import 'package:ddagent_app/features/mcp/data/mcp_models.dart';
import 'package:ddagent_app/features/mcp/data/mcp_repository.dart';
import 'package:ddagent_app/features/mcp/state/mcp_tokens_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Dio _fakeDio(Map<String, dynamic> routes) {
  final dio = Dio(BaseOptions(baseUrl: 'http://t'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (o, h) {
        var res = routes['${o.method} ${o.path}'];
        if (res is Function) res = res(o);
        h.resolve(Response(requestOptions: o, data: res));
      },
    ),
  );
  return dio;
}

void main() {
  group('mcpFormatting', () {
    test('parseKeyValueLines keeps everything after the first =', () {
      expect(parseKeyValueLines('A=1\nB=x=y\n\n =skipped\nC='), {
        'A': '1',
        'B': 'x=y',
        'C': '',
      });
      expect(formatKeyValueLines({'A': '1'}), 'A=1');
    });

    test('maskSecret truncates like the web', () {
      expect(maskSecret('abcd'), '****');
      expect(maskSecret('abcdef'), 'ab****ef');
      expect(maskSecret(null), '****');
    });

    test('sortMcpServers orders user → project → local, then name', () {
      McpServer s(String n, McpScope scope, [String? proj]) => McpServer(
        provider: 'claude',
        name: n,
        scope: scope,
        transport: McpTransport.stdio,
        projectDisplayName: proj,
      );
      final sorted = sortMcpServers([
        s('b', McpScope.local),
        s('z', McpScope.project, 'p2'),
        s('a', McpScope.user),
        s('m', McpScope.project, 'p1'),
      ]);
      expect(sorted.map((e) => e.name).toList(), ['a', 'm', 'z', 'b']);
    });
  });

  group('buildMcpPayload (createMcpPayloadFromForm parity)', () {
    test('stdio form payload', () {
      final p = buildMcpPayload(
        provider: 'claude',
        name: ' ctx7 ',
        scope: McpScope.user,
        transport: McpTransport.stdio,
        command: 'npx',
        args: ['-y', 'upstash'],
        env: {'K': 'v'},
        cwd: '/ignored',
        url: 'https://x',
        headers: {'H': 'v'},
      );
      expect(p['name'], 'ctx7');
      expect(p['scope'], 'user');
      expect(p.containsKey('workspacePath'), isFalse);
      expect(p['command'], 'npx');
      expect(p['args'], ['-y', 'upstash']);
      expect(p['env'], {'K': 'v'});
      // claude does not support cwd; http-only fields dropped.
      expect(p.containsKey('cwd'), isFalse);
      expect(p.containsKey('url'), isFalse);
      expect(p.containsKey('headers'), isFalse);
      // claude → no codex-only fields.
      expect(p.containsKey('envVars'), isFalse);
    });

    test('codex keeps cwd + provider fields; project scope sends path', () {
      final p = buildMcpPayload(
        provider: 'codex',
        name: 's',
        scope: McpScope.project,
        workspacePath: '/w',
        transport: McpTransport.http,
        url: ' https://x ',
        headers: {'A': 'b'},
        envVars: ['T'],
        bearerTokenEnvVar: ' TOK ',
        envHttpHeaders: {'H': 'v'},
      );
      expect(p['workspacePath'], '/w');
      expect(p['url'], 'https://x');
      expect(p['bearerTokenEnvVar'], 'TOK');
      expect(p['envVars'], ['T']);
    });

    test('codex stdio keeps cwd', () {
      final p = buildMcpPayload(
        provider: 'codex',
        name: 's',
        scope: McpScope.user,
        transport: McpTransport.stdio,
        command: 'run',
        cwd: ' /dir ',
      );
      expect(p['cwd'], '/dir');
    });

    test('unsupported transport throws', () {
      expect(
        () => buildMcpPayload(
          provider: 'cursor',
          name: 's',
          scope: McpScope.user,
          transport: McpTransport.sse,
        ),
        throwsA(
          isA<McpPayloadException>().having(
            (e) => e.message,
            'message',
            'cursor does not support sse MCP servers',
          ),
        ),
      );
    });

    test('json mode parses type/command/args/env', () {
      final p = buildMcpPayload(
        provider: 'claude',
        name: 's',
        scope: McpScope.user,
        transport: McpTransport.stdio,
        importMode: McpImportMode.json,
        jsonInput:
            '{"type":"stdio","command":"npx","args":["m"],"env":{"K":"v"}}',
      );
      expect(p['transport'], 'stdio');
      expect(p['command'], 'npx');
      expect(p['args'], ['m']);
      expect(p['env'], {'K': 'v'});
      expect(p.containsKey('url'), isFalse);
    });

    test('json mode reads type alias and http_headers', () {
      final p = buildMcpPayload(
        provider: 'claude',
        name: 's',
        scope: McpScope.user,
        transport: McpTransport.stdio,
        importMode: McpImportMode.json,
        jsonInput: '{"type":"http","url":"https://x","http_headers":{"A":"b"}}',
      );
      expect(p['transport'], 'http');
      expect(p['url'], 'https://x');
      expect(p['headers'], {'A': 'b'});
      expect(p.containsKey('command'), isFalse);
    });

    test('json mode rejects missing type / non-object', () {
      for (final json in ['{}', '[1]']) {
        expect(
          () => buildMcpPayload(
            provider: 'claude',
            name: 's',
            scope: McpScope.user,
            transport: McpTransport.stdio,
            importMode: McpImportMode.json,
            jsonInput: json,
          ),
          throwsA(isA<McpPayloadException>()),
        );
      }
    });
  });

  group('McpServer.fromApi (normalizeServer parity)', () {
    test('url without transport normalizes to http', () {
      final s = McpServer.fromApi('claude', McpScope.user, {
        'name': 'x',
        'url': 'https://h',
      });
      expect(s.transport, McpTransport.http);
      expect(s.scope, McpScope.user);
    });

    test('project target stamps path + displayName', () {
      final s = McpServer.fromApi(
        'claude',
        McpScope.project,
        {'name': 'x'},
        project: const McpProjectTarget(
          name: 'id1',
          displayName: 'Proj',
          path: '/w',
        ),
      );
      expect(s.workspacePath, '/w');
      expect(s.projectName, 'id1');
      expect(s.identity, 'claude:project:/w:x');
    });

    test('ddagent- names are managed/read-only', () {
      final s = McpServer.fromApi('claude', McpScope.user, {
        'name': 'ddagent-browser',
      });
      expect(s.isManaged, isTrue);
    });
  });

  group('McpRepository endpoints', () {
    test('list carries scope+workspacePath params, unwraps envelope', () async {
      Map<String, dynamic>? captured;
      final repo = McpRepository(
        _fakeDio({
          'GET /api/providers/claude/mcp/servers': (RequestOptions o) {
            captured = o.queryParameters;
            return {
              'success': true,
              'data': {
                'servers': [
                  {'name': 'a', 'transport': 'stdio', 'command': 'run'},
                ],
              },
            };
          },
        }),
      );
      const target = McpProjectTarget(
        name: 'p1',
        displayName: 'P1',
        path: '/w',
      );
      final servers = await repo.servers(
        'claude',
        McpScope.project,
        project: target,
      );
      expect(captured, {'scope': 'project', 'workspacePath': '/w'});
      expect(servers.single.name, 'a');
      expect(servers.single.workspacePath, '/w');
    });

    test('delete sends scope + workspacePath, name url-encoded', () async {
      String? path;
      Map<String, dynamic>? captured;
      final repo = McpRepository(
        _fakeDio({
          'DELETE /api/providers/claude/mcp/servers/my%20srv':
              (RequestOptions o) {
                path = o.path;
                captured = o.queryParameters;
                return <String, dynamic>{
                  'success': true,
                  'data': <String, dynamic>{},
                };
              },
        }),
      );
      const server = McpServer(
        provider: 'claude',
        name: 'my srv',
        scope: McpScope.project,
        transport: McpTransport.stdio,
        workspacePath: '/w',
      );
      await repo.delete('claude', server);
      expect(path, '/api/providers/claude/mcp/servers/my%20srv');
      expect(captured, {'scope': 'project', 'workspacePath': '/w'});
    });

    test('saveGlobal hits /global and parses per-provider results', () async {
      Object? body;
      final repo = McpRepository(
        _fakeDio({
          'POST /api/providers/mcp/servers/global': (RequestOptions o) {
            body = o.data;
            return {
              'success': true,
              'data': {
                'results': [
                  {'provider': 'claude', 'created': true},
                  {'provider': 'codex', 'created': false, 'error': 'nope'},
                ],
              },
            };
          },
        }),
      );
      final results = await repo.saveGlobal({'name': 'x'});
      expect((body! as Map<String, dynamic>)['name'], 'x');
      expect(results.length, 2);
      expect(results[1].created, isFalse);
      expect(results[1].error, 'nope');
    });
  });

  group('McpTokensController', () {
    test('create stores the one-shot plaintext token', () async {
      var postCount = 0;
      final container = ProviderContainer(
        overrides: [
          dioProvider.overrideWithValue(
            _fakeDio({
              'GET /api/mcp/tokens': {
                'success': true,
                'data': {
                  'tokens': [
                    {'id': 't1', 'label': 'l', 'scope': 'read'},
                  ],
                },
              },
              'POST /api/mcp/tokens': (RequestOptions o) {
                postCount++;
                return {
                  'success': true,
                  'data': {'token': 'secret-$postCount'},
                };
              },
            }),
          ),
        ],
      );
      addTearDown(container.dispose);
      // Keep alive past the first read (autoDispose provider).
      final keep = container.listen(mcpTokensProvider, (_, _) {});
      addTearDown(keep.close);
      await container.read(mcpTokensProvider.notifier).refresh();
      expect(container.read(mcpTokensProvider).tokens.single.id, 't1');

      await container.read(mcpTokensProvider.notifier).create('', 'write');
      expect(container.read(mcpTokensProvider).freshToken, 'secret-1');
      container.read(mcpTokensProvider.notifier).dismissFreshToken();
      expect(container.read(mcpTokensProvider).freshToken, isNull);
    });
  });
}
