import 'dart:convert';
import 'dart:typed_data';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/skills/data/skill_models.dart';
import 'package:ddagent_app/features/skills/data/skills_constants.dart';
import 'package:ddagent_app/features/skills/data/skills_formatting.dart';
import 'package:ddagent_app/features/skills/state/provider_skills_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'git_test.dart' show FakeProjectsController;

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

SkillSourceFile _src(String path, [String content = 'x']) => SkillSourceFile(
  relativePath: path,
  bytes: Uint8List.fromList(utf8.encode(content)),
  lastModifiedMillis: 1,
);

ProviderSkill _skill(
  String command,
  SkillScope scope, {
  String sourcePath = '/x/SKILL.md',
  String? project,
  String? projectPath,
}) => ProviderSkill(
  provider: 'claude',
  name: command,
  description: '',
  command: command,
  scope: scope,
  sourcePath: sourcePath,
  projectDisplayName: project,
  projectPath: projectPath,
);

void main() {
  group('managedSkillDirectoryName (getManagedSkillDirectoryName parity)', () {
    test('direct child of the managed root is deletable', () {
      final s = _skill(
        '/a',
        SkillScope.user,
        sourcePath: '/home/u/.claude/skills/my-skill/SKILL.md',
      );
      expect(managedSkillDirectoryName(s), 'my-skill');
      // Windows separators normalize too.
      final w = _skill('/a', SkillScope.user, sourcePath: 'C:\\u\\.claude\\skills\\win\\SKILL.md');
      expect(managedSkillDirectoryName(w), 'win');
    });

    test('nested / unmanaged / provider-less roots are not deletable', () {
      // Nested below the managed root — not a direct child.
      final nested = _skill(
        '/a',
        SkillScope.user,
        sourcePath: '/u/.claude/skills/group/inner/SKILL.md',
      );
      expect(managedSkillDirectoryName(nested), isNull);
      // Different root entirely.
      final unmanaged = _skill('/a', SkillScope.user, sourcePath: '/repo/.other/skills/x/SKILL.md');
      expect(managedSkillDirectoryName(unmanaged), isNull);
      // devin has no managed dir — the web hides delete for it.
      final devin = ProviderSkill(
        provider: 'devin',
        name: 'a',
        description: '',
        command: '/a',
        scope: SkillScope.user,
        sourcePath: '/u/.devin/skills/x/SKILL.md',
      );
      expect(managedSkillDirectoryName(devin), isNull);
      // Non-SKILL.md leaf.
      final notSkill = _skill('/a', SkillScope.user, sourcePath: '/u/.claude/skills/x/README.md');
      expect(managedSkillDirectoryName(notSkill), isNull);
    });
  });

  group('skill formatting (sortSkills/groupSkillsByScope parity)', () {
    test('sort: scope order → project name → command', () {
      final sorted = sortProviderSkills([
        _skill('/b', SkillScope.system),
        _skill('/z', SkillScope.project, project: 'p2'),
        _skill('/a', SkillScope.user),
        _skill('/m', SkillScope.project, project: 'p1'),
      ]);
      expect(sorted.map((s) => s.command), ['/a', '/m', '/z', '/b']);
    });

    test('groupSkillsByScope keeps SCOPE_ORDER, drops empty groups', () {
      final groups = groupSkillsByScope([
        _skill('/p', SkillScope.project),
        _skill('/u', SkillScope.user),
      ]);
      expect(groups.map((g) => g.scope), [SkillScope.user, SkillScope.project]);
    });

    test('filterSkills matches command/name/scope/project/sourcePath', () {
      final skills = [_skill('/deploy', SkillScope.user), _skill('/lint', SkillScope.plugin)];
      expect(filterSkills(skills, 'dep').single.command, '/deploy');
      expect(filterSkills(skills, 'PLUGIN').single.command, '/lint');
      expect(filterSkills(skills, '  '), skills);
      expect(filterSkills(skills, 'zzz'), isEmpty);
    });

    test('formatSkillFileSize', () {
      expect(formatSkillFileSize(512), '512 B');
      expect(formatSkillFileSize(2048), '2.0 KB');
      expect(formatSkillFileSize(3 * 1024 * 1024), '3.0 MB');
    });
  });

  group('SkillScope classification', () {
    test('splits global scopes from project-scoped ones', () {
      for (final s in [SkillScope.user, SkillScope.plugin, SkillScope.admin, SkillScope.system]) {
        expect(s.isGlobal, isTrue, reason: '${s.wire} is global');
        expect(s.isProjectScoped, isFalse);
      }
      for (final s in [SkillScope.project, SkillScope.repo]) {
        expect(s.isProjectScoped, isTrue, reason: '${s.wire} is project-scoped');
        expect(s.isGlobal, isFalse);
      }
    });
  });

  group('buildQueuedSkillFolders (ProviderSkills.tsx parity)', () {
    test('roots at every SKILL.md; files rebase under the skill root', () {
      final queued = buildQueuedSkillFolders([
        _src('picked/my-skill/SKILL.md', '---\nname: my-skill\n---'),
        _src('picked/my-skill/scripts/run.sh', 'echo hi'),
        _src('picked/other/SKILL.md'),
        _src('picked/other/refs/a.txt'),
      ]);
      expect(queued.length, 2);
      final my = queued.firstWhere((q) => q.name == 'my-skill');
      expect(my.kind, QueuedSkillKind.folder);
      expect(my.files.map((f) => f.relativePath), ['SKILL.md', 'scripts/run.sh']);
    });

    test('nested skill owns its subtree, not the outer root', () {
      final queued = buildQueuedSkillFolders([
        _src('picked/outer/SKILL.md'),
        _src('picked/outer/extra.md'),
        _src('picked/outer/nested/SKILL.md'),
        _src('picked/outer/nested/inner.txt'),
      ]);
      expect(queued.length, 2);
      final outer = queued.firstWhere((q) => q.name == 'outer');
      final nested = queued.firstWhere((q) => q.name == 'nested');
      expect(outer.files.map((f) => f.relativePath), ['SKILL.md', 'extra.md']);
      expect(nested.files.map((f) => f.relativePath), ['SKILL.md', 'inner.txt']);
    });

    test('missing SKILL.md / caps throw SkillPayloadException', () {
      expect(
        () => buildQueuedSkillFolders([_src('picked/readme.md')]),
        throwsA(isA<SkillPayloadException>()),
      );
      expect(
        () => buildQueuedSkillFolders([
          for (var i = 0; i <= kSkillFolderMaxFiles; i++) _src('p/f$i.md'),
        ]),
        throwsA(isA<SkillPayloadException>()),
      );
      expect(
        () => buildQueuedSkillFolders([
          SkillSourceFile(relativePath: 'p/SKILL.md', bytes: Uint8List(kSkillFolderMaxBytes + 1)),
        ]),
        throwsA(isA<SkillPayloadException>()),
      );
    });
  });

  group('buildSkillEntries (POST entries parity)', () {
    test('markdown entry sends fileName + content, no files', () async {
      final entries = await buildSkillEntries([queueMarkdownFile(_src('solo.md', '# hi'))]);
      expect(entries, [
        {'fileName': 'solo.md', 'content': '# hi'},
      ]);
    });

    test('folder entry sends directoryName + base64 supporting files', () async {
      final queued = buildQueuedSkillFolders([
        _src('picked/tool/SKILL.md', '# tool'),
        _src('picked/tool/bin/x.sh', 'run'),
      ]);
      final entries = await buildSkillEntries(queued);
      expect(entries.length, 1);
      final e = entries.single;
      expect(e['fileName'], 'tool.md');
      expect(e['directoryName'], 'tool');
      expect(e['content'], '# tool');
      final files = e['files'] as List;
      expect(files.single, {
        'relativePath': 'bin/x.sh',
        'content': base64Encode(utf8.encode('run')),
        'encoding': 'base64',
      });
    });
  });

  group('ProviderSkill.fromApi (normalizeSkill parity)', () {
    test('defaults + unknown scope → user', () {
      final s = ProviderSkill.fromApi('claude', {'command': '/x'});
      expect(s.scope, SkillScope.user);
      expect(s.name, '');
      expect(s.pluginName, isNull);
    });

    test('project scope stamps the fetch target', () {
      final s = ProviderSkill.fromApi('claude', {
        'name': 'x',
        'scope': 'project',
      }, project: const SkillProjectTarget(projectId: 'p1', displayName: 'Proj', path: '/w'));
      expect(s.projectDisplayName, 'Proj');
      expect(s.projectPath, '/w');
      expect(s.identity, 'claude:project::no-source-path:/w');
    });
  });

  group('ProviderSkillsController', () {
    ProviderContainer container(Map<String, dynamic> routes) {
      final c = ProviderContainer(
        overrides: [
          dioProvider.overrideWithValue(_fakeDio(routes)),
          projectsProvider.overrideWith(
            () => FakeProjectsController([
              const Project(projectId: 'p1', path: '/w/p1', displayName: 'P1'),
            ]),
          ),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    test('global + project scopes merge into one sorted list', () async {
      final c = container({
        'GET /api/providers/claude/skills': (RequestOptions o) => {
          'success': true,
          'data': {
            'skills': [
              if (o.queryParameters['workspacePath'] == '/w/p1')
                {'name': 'p', 'command': '/p', 'scope': 'project'}
              else
                {'name': 'g', 'command': '/g', 'scope': 'user'},
            ],
          },
        },
      });
      final keep = c.listen(providerSkillsProvider('claude'), (_, _) {});
      addTearDown(keep.close);
      // build() schedules a microtask refresh — let it win its loadId race
      // first, then force a deterministic reload.
      await pumpEventQueue();
      await c.read(providerSkillsProvider('claude').notifier).refresh(force: true);
      final skills = c.read(providerSkillsProvider('claude')).skills;
      expect(skills.map((s) => s.command), ['/g', '/p']);
      expect(skills.last.projectDisplayName, 'P1');
    });

    test('selectProject scans only the chosen project', () async {
      final requested = <String?>[];
      final c = ProviderContainer(
        overrides: [
          dioProvider.overrideWithValue(
            _fakeDio({
              'GET /api/providers/claude/skills': (RequestOptions o) {
                requested.add(o.queryParameters['workspacePath'] as String?);
                return {
                  'success': true,
                  'data': {'skills': <dynamic>[]},
                };
              },
            }),
          ),
          projectsProvider.overrideWith(
            () => FakeProjectsController([
              const Project(projectId: 'p1', path: '/w/p1', displayName: 'P1'),
              const Project(projectId: 'p2', path: '/w/p2', displayName: 'P2'),
            ]),
          ),
        ],
      );
      addTearDown(c.dispose);
      final keep = c.listen(providerSkillsProvider('claude'), (_, _) {});
      addTearDown(keep.close);
      await pumpEventQueue();

      // Defaults to the first target, sorted by path.
      final notifier = c.read(providerSkillsProvider('claude').notifier);
      expect(c.read(providerSkillsProvider('claude')).selectedProjectPath, '/w/p1');

      requested.clear();
      await notifier.selectProject('/w/p2');
      expect(c.read(providerSkillsProvider('claude')).selectedProjectPath, '/w/p2');
      expect(requested, contains('/w/p2'));
      expect(requested, isNot(contains('/w/p1')));
    });

    test('addSkills posts {entries} then refreshes; delete hits encoded path', () async {
      Object? body;
      var deleted = '';
      var gets = 0;
      final c = container({
        'GET /api/providers/claude/skills': (RequestOptions o) {
          gets++;
          return {
            'success': true,
            'data': {'skills': <dynamic>[]},
          };
        },
        'POST /api/providers/claude/skills': (RequestOptions o) {
          body = o.data;
          return {
            'success': true,
            'data': {'provider': 'claude', 'skills': <dynamic>[]},
          };
        },
        'DELETE /api/providers/claude/skills/my%20skill': (RequestOptions o) {
          deleted = o.path;
          return {
            'success': true,
            'data': {'removed': true, 'directoryName': 'my skill'},
          };
        },
      });
      final keep = c.listen(providerSkillsProvider('claude'), (_, _) {});
      addTearDown(keep.close);
      await pumpEventQueue();
      final notifier = c.read(providerSkillsProvider('claude').notifier);
      await notifier.refresh(force: true);

      final err = await notifier.addSkills([
        {'fileName': 'x.md', 'content': '# x'},
      ]);
      expect(err, isNull);
      expect((body! as Map)['entries'], [
        {'fileName': 'x.md', 'content': '# x'},
      ]);

      await notifier.delete('my skill');
      expect(deleted, '/api/providers/claude/skills/my%20skill');
      expect(gets, greaterThanOrEqualTo(3)); // initial + post-add + post-del
    });
  });
}
