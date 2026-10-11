// Conditional facade — web/mobile resolve the stub (no dart:io in their
// compile graph), desktop builds get the real process-managing controller.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

export 'local_server_controller_stub.dart' if (dart.library.io) 'local_server_controller_real.dart';

/// Leave the local server running when the app quits (default on): the next
/// launch adopts it instead of cold-starting Node and the whole server.
class LocalServerKeepRunningController extends Notifier<bool> {
  static const _key = 'localServerKeepRunning';

  @override
  bool build() =>
      !Hive.isBoxOpen('settings') || (Hive.box<dynamic>('settings').get(_key) as bool? ?? true);

  Future<void> set(bool value) async {
    state = value;
    if (Hive.isBoxOpen('settings')) await Hive.box<dynamic>('settings').put(_key, value);
  }
}

final localServerKeepRunningProvider = NotifierProvider<LocalServerKeepRunningController, bool>(
  LocalServerKeepRunningController.new,
);
