import 'package:ddagent_app/core/platform/window.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('window title names the active server address', () {
    final app = t.sidebar.app.title;
    expect(appWindowTitle('http://127.0.0.1:10087'), '$app — 127.0.0.1:10087');
    expect(appWindowTitle('https://ddagent.example.com'), '$app — ddagent.example.com');
    expect(appWindowTitle(''), app);
    expect(appWindowTitle(null), app);
  });
}
