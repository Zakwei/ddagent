// Client reload entry point.
//
// Web builds can reload the browser tab; other platforms have no page to
// reload and report that by returning false.
export 'package:ddagent_app/core/utils/app_reload_stub.dart'
    if (dart.library.js_interop) 'package:ddagent_app/core/utils/app_reload_web.dart';
