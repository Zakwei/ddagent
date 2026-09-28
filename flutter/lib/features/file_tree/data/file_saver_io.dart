import 'dart:io';

Future<void> saveBytes(String path, List<int> bytes) =>
    File(path).writeAsBytes(bytes, flush: true);
