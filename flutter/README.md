# ddagent — Flutter app

Natywny rebuild klienta ddagent (Electron → Flutter). Decyzje architektoniczne:
`.taskmaster/docs/flutter-adr.md`. Plan zadań: `.taskmaster/tasks/tasks.json`.

Platformy: **Android, Windows, Web, Linux** (iOS/macOS opcjonalnie — T39).

## Środowisko

- **Flutter 3.47.5 stable** (Dart 3.13.4) — wersja przypięta też w CI (`flutter-ci.yml`).
- Android SDK 36+, Java 17 (Gradle), Chrome (web), dla Linux: `clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev`.
- Pełna lista komponentów i gotchas hosta dev: `.taskmaster/docs/flutter-env.md`.

### Gotchas tego hosta (z flutter-env.md)

1. **`LD_LIBRARY_PATH` konflikt** — sesyjne env (Playwright/browser-use) zasłania systemowy libfontconfig → link error przy `flutter build linux`. Używaj `env -u LD_LIBRARY_PATH flutter ...` (w `.bashrc` jest alias).
2. **Brak `/dev/kvm`** — emulator Androida nie działa; testuj na fizycznym urządzeniu albo w CI.

## Setup

```bash
cd flutter
flutter pub get
# codegen (freezed/json_serializable) — gdy pojawią się modele:
dart run build_runner build --delete-conflicting-outputs
```

## Uruchamianie

Konfiguracja build-time przez `--dart-define` (nic nie jest hardkodowane w kodzie):

| Flag | Wartości | Domyślne |
|---|---|---|
| `ENV` | `dev`, `prod` | `dev` |
| `DEFAULT_SERVER_URL` | URL serwera ddagent | puste → picker przy starcie |

```bash
# dev
flutter run -d linux   --dart-define=ENV=dev --dart-define=DEFAULT_SERVER_URL=http://localhost:10087
flutter run -d chrome  --dart-define=ENV=dev --dart-define=DEFAULT_SERVER_URL=http://localhost:10087
flutter run -d <android-device> --dart-define=ENV=dev --dart-define=DEFAULT_SERVER_URL=http://<host>:10087

# prod build
flutter build apk     --release --dart-define=ENV=prod
flutter build windows --release --dart-define=ENV=prod
flutter build web     --release --dart-define=ENV=prod
flutter build linux   --release --dart-define=ENV=prod
```

## Layout (feature-first)

```
lib/
  core/            # config (env), network, wspólne utils
  features/
    <domain>/
      data/        # modele (freezed), repozytoria, źródła (dio/WS)
      state/       # providery Riverpod
      ui/          # ekrany i widgety
```

## Checks

```bash
dart format --line-length 100 lib test
flutter analyze   # strict: strict-casts/inference/raw-types
flutter test
```

CI (`.github/workflows/flutter-ci.yml`): PR → format + analyze + test;
push na `main` → build matrix: apk-debug, web, linux, windows.
