/// Build-time environment configuration.
///
/// All values come from `--dart-define` flags — never hardcode server URLs
/// or environment names in source. See README.md for the full flag list.
///
/// Example:
///   flutter run --dart-define=ENV=dev \
///               --dart-define=DEFAULT_SERVER_URL=http://localhost:10087
enum AppEnvironment { dev, prod }

class Env {
  const Env._();

  /// `dev` or `prod`, set via `--dart-define=ENV=...` (defaults to `dev`).
  static const AppEnvironment environment =
      String.fromEnvironment('ENV', defaultValue: 'dev') == 'prod'
      ? AppEnvironment.prod
      : AppEnvironment.dev;

  /// Pre-configured server URL shown in the server picker.
  ///
  /// Set via `--dart-define=DEFAULT_SERVER_URL=...`. May be empty — the app
  /// must then ask the user for a server address at first launch.
  static const String defaultServerUrl = String.fromEnvironment('DEFAULT_SERVER_URL');

  static const bool isProd = environment == AppEnvironment.prod;
  static const bool isDev = environment == AppEnvironment.dev;
}
