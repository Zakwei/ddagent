import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/features/preview/data/app_preview_models.dart';
import 'package:ddagent_app/features/preview/state/app_preview_controller.dart';
import 'package:ddagent_app/features/preview/view/device_frame.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/view/split_workspace_grid.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

AppPreviewTarget _target(
  String url, {
  String? device,
  PreviewPlatform platform = PreviewPlatform.web,
}) => AppPreviewTarget(id: 'id-$url', url: url, title: url, platform: platform, device: device);

void main() {
  group('PaneKind.preview', () {
    test('round-trips through JSON with its device and has title/icon', () {
      const pane = SplitPane(
        id: 'pv1',
        kind: PaneKind.preview,
        url: 'http://localhost:8088/',
        device: 'pixel-8',
      );
      final restored = SplitPane.fromJson(pane.toJson())!;
      expect(restored.kind, PaneKind.preview);
      expect(restored.url, 'http://localhost:8088/');
      expect(restored.device, 'pixel-8');
      expect(paneKindIcon(PaneKind.preview), isNotNull);
      final display = splitPaneDisplay(pane, sessionTitles: const {}, projectNames: const {});
      expect(display.title, 'Preview');
      expect(display.subtitle, 'localhost');
    });

    test('app-preview broadcasts are recognised as broadcast frames', () {
      const e = ServerEvent(raw: {'type': 'app-preview-upserted', 'preview': <String, dynamic>{}});
      expect(e.isBroadcast, isTrue);
    });
  });

  group('device catalog', () {
    test('every platform has a default and ids are unique', () {
      for (final p in PreviewPlatform.values) {
        expect(defaultPreviewDevice(p).platform, p);
      }
      expect(kPreviewDevices.map((d) => d.id).toSet().length, kPreviewDevices.length);
    });

    test('resolvePreviewDevice prefers the pane, then the target, then the platform default', () {
      final target = _target('u', device: 'pixel-8', platform: PreviewPlatform.mobile);
      expect(resolvePreviewDevice(paneDevice: 'iphone-se', target: target).id, 'iphone-se');
      expect(resolvePreviewDevice(target: target).id, 'pixel-8');
      expect(
        resolvePreviewDevice(target: _target('u', platform: PreviewPlatform.desktop)).id,
        'desktop-window',
      );
      expect(resolvePreviewDevice().id, 'web-laptop');
      // Unknown ids (older client / newer server) fall through instead of crashing.
      expect(resolvePreviewDevice(paneDevice: 'nokia', target: target).id, 'pixel-8');
    });

    test('mobile viewports rotate, window frames do not', () {
      final phone = previewDeviceById('iphone-15-pro')!;
      expect(phone.viewportFor(false), const Size(393, 852));
      expect(phone.viewportFor(true), const Size(852, 393));
      final web = previewDeviceById('web-laptop')!;
      expect(web.viewportFor(true), const Size(1366, 768));
    });

    test('frame size is the viewport plus the chrome around it', () {
      final phone = previewDeviceById('iphone-15-pro')!;
      final size = deviceFrameSize(phone, phone.viewportFor(false));
      expect(size.width, greaterThan(393));
      expect(size.height, greaterThan(852));
      final win = previewDeviceById('desktop-window')!;
      expect(deviceFrameSize(win, win.viewportFor(false)).width, 1282);
    });
  });

  group('previewFollowAction', () {
    const empty = WorkspaceState();
    const chatOnly = WorkspaceState(
      panes: [SplitPane(id: 'c', kind: PaneKind.chat)],
      activePaneId: 'c',
    );

    test('opens a pane when none exists and the grid has room', () {
      expect(
        previewFollowAction(empty, _target('http://a/'), created: true),
        isA<OpenPreviewPane>(),
      );
      expect(
        previewFollowAction(chatOnly, _target('http://a/'), created: false),
        isA<OpenPreviewPane>(),
      );
    });

    test('does nothing when the grid is full', () {
      final full = WorkspaceState(
        panes: [for (var i = 0; i < maxSplitPanes; i++) SplitPane(id: 'p$i', kind: PaneKind.chat)],
      );
      expect(
        previewFollowAction(full, _target('http://a/'), created: true),
        isA<NoPreviewAction>(),
      );
    });

    test('a pane already showing the URL only refreshes (no retarget)', () {
      const ws = WorkspaceState(
        panes: [SplitPane(id: 'pv', kind: PaneKind.preview, url: 'http://a/')],
        activePaneId: 'pv',
      );
      final action = previewFollowAction(ws, _target('http://a/'), created: false);
      expect(action, isA<UpdatePreviewPane>());
      expect((action as UpdatePreviewPane).retarget, isFalse);
      expect(action.paneId, 'pv');
    });

    test('a new target goes to the active preview pane, an empty one wins over it', () {
      const ws = WorkspaceState(
        panes: [
          SplitPane(id: 'pv1', kind: PaneKind.preview, url: 'http://old/'),
          SplitPane(id: 'pv2', kind: PaneKind.preview, url: 'http://other/'),
        ],
        activePaneId: 'pv2',
      );
      final toActive =
          previewFollowAction(ws, _target('http://new/'), created: true) as UpdatePreviewPane;
      expect(toActive.paneId, 'pv2');
      expect(toActive.retarget, isTrue);

      const withEmpty = WorkspaceState(
        panes: [
          SplitPane(id: 'pv1', kind: PaneKind.preview, url: 'http://old/'),
          SplitPane(id: 'pv3', kind: PaneKind.preview),
        ],
        activePaneId: 'pv1',
      );
      final toEmpty = previewFollowAction(
        withEmpty,
        _target('http://new/'),
        created: true,
      ) as UpdatePreviewPane;
      expect(toEmpty.paneId, 'pv3');
    });

    test("an update to a target nobody shows does not hijack the user's pane", () {
      const ws = WorkspaceState(
        panes: [SplitPane(id: 'pv', kind: PaneKind.preview, url: 'http://mine/')],
        activePaneId: 'pv',
      );
      expect(
        previewFollowAction(ws, _target('http://theirs/'), created: false),
        isA<NoPreviewAction>(),
      );
    });
  });

  group('AppPreviewTarget.fromJson', () {
    test('parses the server shape and tolerates missing fields', () {
      final t = AppPreviewTarget.fromJson({
        'id': 'x',
        'url': 'http://localhost:1/',
        'title': 'T',
        'platform': 'mobile',
        'device': 'pixel-8',
        'orientation': 'landscape',
        'reloadToken': 3,
        'note': 'n',
      })!;
      expect(t.platform, PreviewPlatform.mobile);
      expect(t.landscape, isTrue);
      expect(t.reloadToken, 3);
      expect(AppPreviewTarget.fromJson({'id': 'x'}), isNull);
      expect(
        AppPreviewTarget.fromJson({'id': 'y', 'url': 'http://a/'})!.platform,
        PreviewPlatform.web,
      );
    });
  });
}
