/// Android build installer, resolved per platform. The IO implementation
/// downloads a release APK and hands it to the system installer; the web stub
/// reports the capability as unsupported so shared call sites stay branch-free.
library;

export 'app_update_installer_stub.dart' if (dart.library.io) 'app_update_installer_real.dart';
