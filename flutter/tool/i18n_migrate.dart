// Migrates i18next locale JSONs (src/i18n/locales/<locale>/*.json) into slang
// translation files (lib/i18n/strings[_<locale>].i18n.json).
//
// - namespaces (common/settings/auth/sidebar/chat/codeEditor/tasks) become
//   top-level objects
// - interpolation syntax is unchanged: slang runs with
//   `string_interpolation: double_braces` so `{{var}}` stays `{{var}}`
// - i18next plurals `key_one/_few/_many/_other/...` become slang
//   `"key(param=count)": {"one": ..., ...}`
//
// Run: dart run tool/i18n_migrate.dart   (from flutter/)
import 'dart:convert';
import 'dart:io';

const _pluralSuffixes = {'zero', 'one', 'two', 'few', 'many', 'other'};
const _srcDir = '../src/i18n/locales';
const _outDir = 'lib/i18n';

Map<String, dynamic> _convert(Map<String, dynamic> node) {
  final out = <String, dynamic>{};
  final plurals = <String, Map<String, dynamic>>{};

  for (final e in node.entries) {
    final key = e.key;
    final value = e.value;
    final split = key.lastIndexOf('_');
    if (value is String && split > 0 && _pluralSuffixes.contains(key.substring(split + 1))) {
      plurals.putIfAbsent(key.substring(0, split), () => {})[key.substring(split + 1)] = value;
    } else if (value is Map<String, dynamic>) {
      out[key] = _convert(value);
    } else {
      out[key] = value;
    }
  }

  for (final e in plurals.entries) {
    final base = e.key;
    final forms = e.value;
    // Merge a non-suffixed base key (i18next uses it as "other" for some locales).
    if (out[base] is String) {
      forms.putIfAbsent('other', () => out.remove(base) as String);
    }
    out['$base(param=count)'] = forms;
  }
  return out;
}

Future<void> main() async {
  final localesDir = Directory(_srcDir);
  final locales =
      localesDir
          .listSync()
          .whereType<Directory>()
          .map((d) => d.uri.pathSegments.where((s) => s.isNotEmpty).last)
          .toList()
        ..sort();

  var totalKeys = 0;
  for (final locale in locales) {
    final merged = <String, dynamic>{};
    final nsFiles =
        Directory('$_srcDir/$locale')
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.json'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    for (final f in nsFiles) {
      final ns = f.uri.pathSegments.last.replaceAll('.json', '');
      final data = jsonDecode(await f.readAsString()) as Map<String, dynamic>;
      merged[ns] = _convert(data);
    }

    int countLeaves(Object? n) => n is Map
        ? n.values.fold(0, (a, v) => a + countLeaves(v))
        : n is List
        ? n.fold(0, (a, v) => a + countLeaves(v))
        : 1;
    totalKeys += countLeaves(merged);

    final outName = '${locale.replaceAll('-', '_')}.i18n.json';
    final out = File('$_outDir/$outName');
    await out.writeAsString(const JsonEncoder.withIndent('  ').convert(merged));
    stdout.writeln('$locale -> $outName (${nsFiles.length} namespaces)');
  }
  stdout.writeln('Done: ${locales.length} locales, $totalKeys leaf strings.');
}
