import 'package:ddagent_app/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// T40.4 — E2E smoke: the app must boot on a real device/emulator into the
/// connect/onboarding flow without crashing. Requires a device:
/// `flutter test integration_test/app_test.dart -d <device>`.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app boots to a stable first frame', (tester) async {
    await app.main();
    await tester.pumpAndSettle(const Duration(seconds: 10));
    expect(tester.takeException(), isNull);
  });
}
