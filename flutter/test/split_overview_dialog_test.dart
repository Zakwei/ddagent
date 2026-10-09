import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/chat/state/pending_permissions.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/view/workspace_dialogs.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  setUpAll(() async {
    Hive.init('/tmp/ddagent_overview_hive');
    if (!Hive.isBoxOpen(WorkspaceStorage.boxName)) {
      await Hive.openBox<dynamic>(WorkspaceStorage.boxName);
    }
  });

  // Regression: the dialog used to get a snapshot from open time, so an
  // agent asking (or finishing) while it was open never changed the tile.
  testWidgets('tiles follow pane state while the dialog is open', (tester) async {
    // Ahem glyphs are wide — give the 720px dialog room to lay out.
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    const pane = SplitPane(id: 'p1', kind: PaneKind.chat, sessionId: 's1');
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TranslationProvider(
          child: MaterialApp(
            theme: AppTheme.dark(),
            home: Scaffold(
              body: SplitOverviewDialog(
                onSelectPane: (_) {},
                panes: (ref) => [
                  OverviewPaneInfo(
                    pane: pane,
                    title: 'Session',
                    action: ref.watch(pendingPermissionSessionsProvider).contains('s1')
                        ? PaneAction.question
                        : PaneAction.idle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);

    container
        .read(pendingPermissionsProvider.notifier)
        .add(const PendingPermission(sessionId: 's1', requestId: 'r1', toolName: 'Bash'));
    await tester.pump();
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

    container.read(pendingPermissionsProvider.notifier).remove('r1');
    await tester.pump();
    expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);
  });
}
