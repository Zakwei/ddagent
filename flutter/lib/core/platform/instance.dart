import 'dart:io';

/// Server a secondary desktop window is pinned to (`--server=<url>`), null in
/// the primary instance. Set once by `main` before anything reads it.
///
/// Each window is its own process: Hive locks its box files exclusively, so a
/// second process sharing the primary's storage could open none of its boxes.
/// A pinned window therefore keeps its own Hive dir and auth-token slot and
/// leaves app-wide duties (self-update, local-server upgrades) to the primary.
String? pinnedServerUrl;

/// The pinned server runs on this device (`--local`).
bool pinnedServerIsLocal = false;

bool get isSecondaryInstance => pinnedServerUrl != null;

void parseInstanceArgs(List<String> args) {
  for (final a in args) {
    if (a.startsWith('--server=')) pinnedServerUrl = a.substring('--server='.length);
    if (a == '--local') pinnedServerIsLocal = true;
  }
}

/// Hive subdirectory (under the documents dir) for the pinned server — stable
/// per URL, so reopening a server's window restores its panes and login.
String? instanceStorageSubdir() => pinnedServerUrl == null
    ? null
    : 'ddagent-windows/${pinnedServerUrl!.replaceAll(RegExp('[^A-Za-z0-9.-]+'), '_')}';

/// Starts another app window pinned to [url].
Future<void> openServerWindow(String url, {bool isLocal = false}) => Process.start(
  Platform.resolvedExecutable,
  ['--server=$url', if (isLocal) '--local'],
  mode: ProcessStartMode.detached,
);
