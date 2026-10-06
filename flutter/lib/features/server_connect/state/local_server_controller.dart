// Conditional facade — web/mobile resolve the stub (no dart:io in their
// compile graph), desktop builds get the real process-managing controller.
export 'local_server_controller_stub.dart'
    if (dart.library.io) 'local_server_controller_real.dart';
