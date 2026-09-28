import 'package:ddagent_app/features/server_connect/data/server_profiles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('normalizeServerUrl adds https and strips trailing slashes', () {
    expect(normalizeServerUrl(' host:10087/ '), 'https://host:10087');
    expect(normalizeServerUrl('http://a/b/'), 'http://a/b');
    expect(normalizeServerUrl('   '), '');
    expect(wsBaseFor('https://h:1'), 'wss://h:1');
    expect(wsBaseFor('http://h:1'), 'ws://h:1');
  });

  test('select adds profile once and activates it; remove switches active', () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    final n = c.read(serverProfilesProvider.notifier);
    await n.select(' a:1 ');
    await n.select('https://a:1'); // dup — no second entry
    await n.select('b:2');
    var s = c.read(serverProfilesProvider);
    expect(s.profiles.map((p) => p.url), ['https://a:1', 'https://b:2']);
    expect(s.activeUrl, 'https://b:2');

    await n.remove('https://b:2');
    s = c.read(serverProfilesProvider);
    expect(s.activeUrl, 'https://a:1');
    await n.remove('https://a:1');
    expect(c.read(serverProfilesProvider).activeUrl, isNull);
  });
}
