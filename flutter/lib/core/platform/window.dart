import 'dart:io';

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
  final box = Hive.box<dynamic>('settings');
  final saved = box.get('windowBounds');

  const minSize = Size(720, 480);
  // No widget tree here (runs before `runApp`), so use the global accessor.
  var opts = WindowOptions(
    minimumSize: minSize,
    title: t.sidebar.app.title,
    titleBarStyle: TitleBarStyle.normal,
  );
  if (saved is Map) {
    opts = WindowOptions(
      minimumSize: minSize,
      title: t.sidebar.app.title,
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
