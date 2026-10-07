/// App self-updater, resolved per platform. The IO implementation installs a
/// release on Android (system installer) or stages a desktop build and applies
/// it on quit; the web stub reports the capability as unsupported so shared
/// call sites stay branch-free.
library;

export 'app_update_installer_stub.dart' if (dart.library.io) 'app_update_installer_real.dart';
