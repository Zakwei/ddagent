import 'package:ddagent_app/features/file_tree/data/file_saver_io.dart'
    if (dart.library.js_interop) 'package:ddagent_app/features/file_tree/data/file_saver_web.dart';

/// Writes bytes to an absolute path — native only, stubbed on web so this
/// library compiles for `flutter build web`.
Future<void> saveBytesToPath(String path, List<int> bytes) =>
    saveBytes(path, bytes);
