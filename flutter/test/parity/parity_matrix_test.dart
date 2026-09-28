import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'parity_matrix.dart';

/// T40.1 — the matrix must cover 100% of the source inventory and every
/// mapped artifact must exist on disk.
void main() {
  const webGroups = [
    'app', 'auth', 'browser-use', 'chat', 'code-editor', 'command-palette',
    'file-tree', 'git-panel', 'islands', 'kanban', 'llm-provider-logo',
    'main-content', 'mcp', 'onboarding', 'prd-editor', 'preview',
    'project-creation-wizard', 'provider-auth', 'quick-settings-panel',
    'quota', 'settings', 'shared-notes', 'shell', 'sidebar', 'skills',
    'standalone-shell', 'task-master', 'web-browser',
  ];
  const mobileScreens = [
    'BoardScreen', 'ChatScreen', 'EditorScreen', 'FileTreeScreen',
    'LoginScreen', 'OnboardingScreen', 'ProjectsScreen', 'QuotaScreen',
    'RecentScreen', 'ServerConnectScreen', 'SessionsScreen',
    'SettingsScreen', 'SettingsTabs', 'SetupScreen', 'SourceControlScreen',
    'TasksScreen', 'TerminalScreen', 'WebScreen', 'WorkspaceScreen',
    'settings/',
  ];
  const settingsTabs = [
    'general', 'agents', 'orchestration', 'appearance', 'workspaces', 'git',
    'api', 'tasks', 'browser', 'notifications', 'schedules', 'about',
  ];

  group('parity matrix completeness', () {
    test('covers all 28 web component groups', () {
      final keys = parityMatrix
          .where((e) => e.source == ParitySource.web)
          .map((e) => e.key)
          .toSet();
      expect(keys, containsAll(webGroups));
      expect(keys.length, webGroups.length, reason: 'no duplicates');
    });

    test('covers all 20 mobile screens', () {
      final keys = parityMatrix
          .where((e) => e.source == ParitySource.mobile)
          .map((e) => e.key)
          .toSet();
      expect(keys, containsAll(mobileScreens));
      expect(keys.length, mobileScreens.length);
    });

    test('covers all 12 settings tabs', () {
      final keys = parityMatrix
          .where((e) => e.source == ParitySource.settings)
          .map((e) => e.key)
          .toSet();
      expect(keys, containsAll(settingsTabs));
      expect(keys.length, settingsTabs.length);
    });

    test('every implemented/partial/deferred row points at a real artifact',
        () {
      for (final e in parityMatrix) {
        if (e.status == ParityStatus.missing ||
            e.status == ParityStatus.notApplicable) {
          expect(
            e.flutterPath,
            isNull,
            reason: '${e.key}: missing/n-a rows must not fake a path',
          );
          continue;
        }
        expect(
          e.flutterPath,
          isNotNull,
          reason: '${e.key}: ${e.status.name} needs a flutterPath',
        );
        final f = File(e.flutterPath!);
        final d = Directory(e.flutterPath!);
        expect(
          f.existsSync() || d.existsSync(),
          isTrue,
          reason: '${e.key}: ${e.flutterPath} does not exist',
        );
      }
    });

    test('coverage report', () {
      final counts = <ParityStatus, int>{};
      for (final e in parityMatrix) {
        counts[e.status] = (counts[e.status] ?? 0) + 1;
      }
      // Ignorable on purpose — the matrix itself is the artifact; print for
      // the review log.
      // ignore: avoid_print
      print('Parity: $counts / ${parityMatrix.length} entries');
      expect(counts[ParityStatus.missing] ?? 0, lessThanOrEqualTo(2));
    });
  });
}
