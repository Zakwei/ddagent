import 'dart:io';

import 'package:ddagent_app/core/platform/instance.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:window_manager/window_manager.dart';

/// Desktop window management (T7.5): persisted size/position in the
/// `settings` Hive box, minimum size, fixed title. No-op on web/Android.
Future<void> initWindow() async {
  if (kIsWeb || !(Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
    return;
  }
  await windowManager.ensureInitialized();
  _windowReady = true;
  final box = Hive.box<dynamic>('settings');
  final saved = box.get('windowBounds');

  const minSize = Size(720, 480);
  // Pinned windows know their server already; others get it via syncWindowTitle.
  final title = appWindowTitle(pinnedServerUrl);
  // No widget tree here (runs before `runApp`), so use the global accessor.
  var opts = WindowOptions(minimumSize: minSize, title: title, titleBarStyle: TitleBarStyle.normal);
  if (saved is Map) {
    opts = WindowOptions(
      minimumSize: minSize,
      title: title,
      titleBarStyle: TitleBarStyle.normal,
      size: Size((saved['w'] as num?)?.toDouble() ?? 1280, (saved['h'] as num?)?.toDouble() ?? 800),
    );
  }
  await windowManager.waitUntilReadyToShow(opts, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  windowManager.addListener(_WindowBoundsPersister());
}

/// "DDAgent — host:port" — the title names the server so several windows (and
/// a server switch) stay tellable apart.
String appWindowTitle(String? serverUrl) {
  if (serverUrl == null || serverUrl.isEmpty) return t.sidebar.app.title;
  final uri = Uri.tryParse(serverUrl);
  final address = uri == null || uri.host.isEmpty ? serverUrl : uri.authority;
  return '${t.sidebar.app.title} — $address';
}

/// Set by [initWindow] — tests and web/mobile never get a window manager.
bool _windowReady = false;

/// Retitles the desktop window for the active server. No-op without a window.
Future<void> syncWindowTitle(String serverUrl) async {
  if (_windowReady) await windowManager.setTitle(appWindowTitle(serverUrl));
}

class _WindowBoundsPersister with WindowListener {
  @override
  void onWindowResized() => _save();

  @override
  void onWindowMoved() => _save();

  Future<void> _save() async {
    final size = await windowManager.getSize();
    final pos = await windowManager.getPosition();
    await Hive.box<dynamic>('settings')
        .put('windowBounds', {'w': size.width, 'h': size.height, 'x': pos.dx, 'y': pos.dy});
  }
}
