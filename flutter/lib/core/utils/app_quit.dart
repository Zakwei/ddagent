// Quits the running desktop app right away. Returns false where there is no
// process to exit (web), so callers can fall back to a no-op.
export 'package:ddagent_app/core/utils/app_quit_stub.dart'
    if (dart.library.io) 'package:ddagent_app/core/utils/app_quit_io.dart';
