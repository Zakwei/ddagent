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

  /// Optional API key sent as `x-api-key` when the server has the key gate on.
  /// Set via `--dart-define=API_KEY=...`. Empty = gate disabled.
  static const String apiKey = String.fromEnvironment('API_KEY');

  /// Platform/embedded build — the UI is served by the sidecar Node process
  /// itself, so there is no login flow (parity with `IS_PLATFORM` in the
  /// Electron client). Set via `--dart-define=EMBEDDED=true`.
  static const bool embedded = bool.fromEnvironment('EMBEDDED');

  static const bool isProd = environment == AppEnvironment.prod;
  static const bool isDev = environment == AppEnvironment.dev;
}
