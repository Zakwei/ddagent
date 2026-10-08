# ddagent — Flutter client

The ddagent client: one Flutter codebase for **web, Linux and Windows desktop, and
Android**. It connects to a self-hosted ddagent server (REST + WebSocket API). macOS
and iOS are not built yet (there is no `macos/` or `ios/` target).

## Requirements

- **Flutter 3.47.5 stable** (Dart 3.13.4) — the same version is pinned in CI
  (`.github/workflows/flutter-ci.yml`, `flutter-release.yml`).
- Android: Android SDK and Java 17 (Gradle).
- Web: Chrome for `flutter run -d chrome`.
- Linux desktop: `clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libsecret-1-dev`.
- A running ddagent server (`npm run dev` from the repo root, default port `3001`).

## Setup

```bash
cd flutter
flutter pub get
```

Generated code is committed. Regenerate it when you change its sources:

```bash
# freezed / json_serializable models (*.freezed.dart, *.g.dart)
dart run build_runner build --delete-conflicting-outputs

# translations: edit lib/i18n/<locale>.i18n.json, then regenerate lib/i18n/strings*.g.dart
dart run slang
```

## Running

Build-time configuration comes from `--dart-define` flags (see
`lib/core/config/env.dart`); nothing is hardcoded:

| Flag | Values | Default |
|---|---|---|
| `ENV` | `dev`, `prod` | `dev` |
| `DEFAULT_SERVER_URL` | ddagent server URL | empty → the app asks for a server on first launch |
| `API_KEY` | value sent as `x-api-key` when the server's API-key gate is on | empty (gate off) |
| `EMBEDDED` | `true` for a build served by the server itself (no login flow); web builds always count as embedded | `false` |

```bash
# development
flutter run -d linux  --dart-define=DEFAULT_SERVER_URL=http://localhost:3001
flutter run -d chrome --dart-define=DEFAULT_SERVER_URL=http://localhost:3001
flutter run -d <android-device> --dart-define=DEFAULT_SERVER_URL=http://<host>:3001

# release builds
flutter build web     --release --dart-define=ENV=prod
flutter build linux   --release --dart-define=ENV=prod
flutter build windows --release --dart-define=ENV=prod
flutter build apk     --release --dart-define=ENV=prod
```

The server does not serve the web UI. Serve `build/web` with
`scripts/serve-flutter-web.cjs` (port `8085` by default; it proxies `/api` and the
WebSocket upgrades to the backend on `FLUTTER_BACKEND_PORT`, default `10087` — set it
to your server's port) or any static file server.

Release packaging used by `flutter-release.yml`: `packaging/linux/build-deb.sh`
(`.deb` from the Linux bundle) and `packaging/windows/installer.iss` (Inno Setup
installer).

## Layout (feature-first)

```
lib/
  core/            # config (env), network, realtime (WebSocket channels), router, theme, widgets
  features/
    <feature>/
      data/        # models (freezed), repositories, API/WS sources
      state/       # Riverpod providers/controllers
      view/        # screens and widgets
  i18n/            # slang translations (*.i18n.json) and generated strings*.g.dart
```

## Checks

```bash
dart format --line-length 100 lib test   # CI fails on any diff (--set-exit-if-changed)
flutter analyze                          # strict: strict-casts / strict-inference / strict-raw-types
flutter test
```

CI (`.github/workflows/flutter-ci.yml`): pull requests run format, analyze and
test; pushes to `main` also build the debug matrix (Android APK, web, Linux,
Windows).

## Troubleshooting

- **`flutter build linux` fails with a libfontconfig link error** — a session
  `LD_LIBRARY_PATH` (for example from a Playwright/browser tooling environment) can
  shadow the system libraries. Run `env -u LD_LIBRARY_PATH flutter build linux`.
- **No `/dev/kvm`** — the Android emulator cannot run; use a physical device or CI.
