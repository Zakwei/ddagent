<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>Jeden interfejs dla wszystkich Twoich agentów AI do kodowania.</strong><br>
  Serwer self-hosted i klient Flutter (web, Linux, Windows i Android) dla Claude Code, Codex, Cursor CLI, OpenCode, Devin, Command Code i Antigravity — sesje, pliki, git, terminale i zadania w jednym miejscu.</p>

  <p>
    <img src="https://img.shields.io/github/v/release/Zakwei/ddagent?label=wersja&amp;color=0066FF" alt="wersja">
    <img src="https://img.shields.io/badge/license-AGPL--3.0-blue" alt="licencja: AGPL-3.0">
    <img src="https://img.shields.io/badge/node-%E2%89%A522-339933" alt="node >= 22">
    <img src="https://img.shields.io/badge/self--hosted-yes-success" alt="self-hosted">
  </p>

  <p>
    <a href="#instalacja">Instalacja</a> ·
    <a href="https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md">Współpraca</a> ·
    <a href="https://github.com/Zakwei/ddagent/issues">Zgłaszanie błędów</a>
  </p>

  <p>
    <a href="../../README.md">English</a> ·
    <strong>Polski</strong> ·
    <a href="README.de.md">Deutsch</a> ·
    <a href="README.es.md">Español</a> ·
    <a href="README.fr.md">Français</a> ·
    <a href="README.it.md">Italiano</a> ·
    <a href="README.ja.md">日本語</a> ·
    <a href="README.ko.md">한국어</a> ·
    <a href="README.ru.md">Русский</a> ·
    <a href="README.tr.md">Türkçe</a> ·
    <a href="README.zh-CN.md">简体中文</a> ·
    <a href="README.zh-TW.md">繁體中文</a>
  </p>
</div>

<p align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/desktop-main.png" alt="widok czatu ddagent" width="78%">&nbsp;
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/mobile-chat.png" alt="widok mobilny ddagent" width="20%">
</p>

<table>
  <tr>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/sessions.png" alt="Ostatnie sesje z Claude Code i Codex"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/kanban-board.png" alt="Tablica kanban sterująca uruchomieniami agentów"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/git-panel.png" alt="Panel Git ze stage'owaniem fragmentów zmian"></td>
  </tr>
  <tr>
    <td align="center"><sub>Sesje wszystkich agentów na jednej liście</sub></td>
    <td align="center"><sub>Tablica kanban — karty uruchamiają agentów</sub></td>
    <td align="center"><sub>Panel Git — diff, stage fragmentów, commit</sub></td>
  </tr>
</table>

---

## Czym jest ddagent?

ddagent działa na Twojej własnej maszynie lub VPS-ie i daje jeden dopracowany interfejs dla agentów do kodowania, których już używasz. Serwer odczytuje sesje każdego agenta bezpośrednio z jego własnej historii na dysku (`~/.claude`, `~/.codex`, `~/.cursor`, OpenCode, Devin, …), więc istniejące rozmowy pojawiają się bez żadnego importu. Lokalnie indeksowane są wyłącznie metadane sesji; nic nie trafia do podmiotów trzecich.

Łącz się z klienta Flutter na komputerze, telefonie lub w przeglądarce. Twoja maszyna, Twoi agenci, Twoje dane.

## Funkcje

- **Sesje multi-agent** — uruchamiaj i wznawiaj obok siebie sesje siedmiu CLI agentów, z live streamingiem przez WebSocket
- **Auto orchestrator** — sesje „Auto” kierują każde zadanie do odpowiedniego agenta i modelu, uwzględniając pozostały limit subskrypcji, i delegują pracę do sesji podrzędnych
- **Podzielony workspace** — do sześciu paneli (czat, terminal, przeglądarka, podgląd, edytor, git, notatki) w jednym oknie
- **Eksplorator i edytor plików** — przeglądaj workspace i edytuj kod we wbudowanym edytorze
- **Panel Git** — stage'uj pliki lub pojedyncze fragmenty zmian (hunki), commituj (z wiadomościami generowanymi przez AI), przeglądaj diff, przełączaj branche, rób pull/push i przywracaj checkpointy bez wychodzenia z UI
- **Zintegrowany terminal** — pełna powłoka dla każdego workspace
- **Tablica kanban** — przesuń kartę, aby uruchomić na niej agenta (opcjonalnie we własnym worktree); agent zgłasza się, gdy skończy
- **TaskMaster** — zamieniaj PRD-y na zadania i śledź je na tablicy zadań
- **Kolejka wiadomości** — wiadomości wysłane, gdy agent jest zajęty, czekają w kolejce na serwerze i przetrwają odświeżenie strony oraz zmianę urządzenia
- **Zarządzanie MCP** — dodawaj, edytuj i synchronizuj serwery MCP między agentami
- **Baza wiedzy** — jedna lokalna, przeszukiwalna pamięć dla każdego agenta: reguły, skille, wspomnienia i informacje osobiste, pobierane na żądanie przez MCP ([dokumentacja](KNOWLEDGE.pl.md))
- **Skille i reguły** — zarządzaj skillami agentów i wspólnymi regułami z jednego miejsca
- **Limity i zużycie** — zużycie tokenów i limity subskrypcji per agent, na pierwszy rzut oka
- **Browser-use** — sesje przeglądarki sterowane przez agenta do researchu i testów, z panelem przeglądarki na żywo
- **Worktree** — twórz izolowane worktree git per zadanie, ze skryptami setup/run per worktree i uwierzytelnionym podglądem dev-servera na żywo
- **Zdalne zatwierdzanie** — zatwierdzaj uprawnienia narzędzi z Telegrama, Discorda lub aplikacji na Androida ([dokumentacja](https://github.com/Zakwei/ddagent/blob/main/docs/remote-approvals.md))
- **Wprowadzanie głosowe** — dyktuj prompty przez endpoint speech-to-text kompatybilny z Whisper
- **Broadcast do agentów i współdzielona pamięć** — wysyłaj wiadomość do wszystkich agentów naraz i prowadź notatki per projekt, które wszyscy czytają
- **Przełączanie wielu kont** — nazwane konta per provider z nadpisaniami zmiennych środowiskowych per sesja
- **Scheduler** — bezobsługowe uruchomienia agentów według crona, z opcją utrzymywania urządzenia w stanie aktywnym, dopóki trwają uruchomienia
- **Współpraca w zespole** — role (owner/member/viewer), linki z zaproszeniami, przypisania, komentarze, obecność i feed aktywności na tablicy ([dokumentacja](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md))
- **Serwer MCP** — pozwól zewnętrznym klientom MCP (Claude Desktop, OpenClaw) listować sesje, tworzyć zadania i wysyłać wiadomości do sesji ([dokumentacja](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Powiadomienia i TTS** — powiadomienia push, na Telegramie i Discordzie, gdy sesja Cię potrzebuje, plus opcjonalne odczytywanie odpowiedzi na głos
- **Paleta poleceń** — `Ctrl/Cmd+Shift+K`, aby przeszukiwać sesje i wiadomości, przejść do dowolnej strony lub wykonać szybkie akcje
- **Sandboxy Docker** — uruchamiaj agentów w Docker Sandboxes izolowanych przez microVM ([dokumentacja](https://github.com/Zakwei/ddagent/blob/main/docker/README.md))
- **Klient Flutter** — jedna baza kodu dla web, Linuksa, Windowsa i Androida; **12 języków**, motywy ciemny i jasny

## Obsługiwani agenci

| Agent | Jak się łączy |
|---|---|
| **Claude Code** | Claude Agent SDK; automatycznie wykrywa sesje z `~/.claude`; synchronizacja MCP i ustawień z natywnym CLI |
| **Codex** | Codex SDK; lokalne sesje i transkrypty z `~/.codex` |
| **Cursor CLI** | `cursor-agent` ze strumieniowym wyjściem JSON; lokalne czaty z `~/.cursor` |
| **OpenCode** | `opencode serve`; lokalne sesje z bazy danych OpenCode |
| **Devin** | `devin acp` (Agent Client Protocol); lokalne transkrypty |
| **Command Code** | `command-code acp` (Agent Client Protocol); transkrypty z `~/.commandcode` |
| **Antigravity** | CLI `agy` w trybie headless; rozmowy indeksowane z `~/.gemini/antigravity-cli` |

CLI agentów muszą być zainstalowane i zalogowane na maszynie serwera. Przynosisz własne subskrypcje — ddagent dostarcza środowisko, nie AI.

## Instalacja

ddagent składa się z dwóch części: **serwera**, który działa obok Twoich agentów i udostępnia API REST/WebSocket, oraz **klienta**, który się z nim łączy. Serwer wymaga **Node.js 22+** (gotowe tarballe wymagają Node.js 22.x, ponieważ ich natywne moduły są pod niego budowane).

### Serwer — skrypt instalacyjny

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

Wymaga `git`, Node.js 22+ i `npm`. Skrypt klonuje tag release'u do `~/.ddagent/app`, instaluje zależności, buduje backend i tworzy launcher `start.sh`. Opcje podaj po `bash -s --`:

| Opcja | Opis |
|---|---|
| `--version vX.Y.Z` | Instaluje konkretny release (domyślnie: najnowszy) |
| `--dir <path>` | Katalog instalacji (domyślnie: `~/.ddagent/app`) |
| `--systemd` | Instaluje i włącza userową usługę systemd o nazwie `ddagent` |
| `--port <port>` | Port usługi systemd (domyślnie: `3001`) |

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash -s -- --systemd --port 3001
```

Aby zaktualizować, uruchom skrypt ponownie z `--version vX.Y.Z`; zaktualizuje checkout w miejscu. Następnie uruchom serwer:

```bash
~/.ddagent/app/start.sh        # API on http://<host>:3001 (set SERVER_PORT to change)
```

### Serwer — gotowy tarball

Bez kroku budowania: pobierz `ddagent-server-<version>-<os>-<arch>.tar.gz` (`linux-x64`, `mac-arm64` lub `win-x64`) z [Releases](https://github.com/Zakwei/ddagent/releases), rozpakuj i uruchom launcher:

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh             # start.bat on Windows
```

Do każdego tarballa dołączona jest suma kontrolna `.sha256`. Ustawienia umieszczasz w opcjonalnym pliku `.env` obok `start.sh`.

### Klient

Pobierz gotowego klienta z [Releases](https://github.com/Zakwei/ddagent/releases):

| Platforma | Plik |
|---|---|
| Windows x64 | `ddagent-flutter-windows-x64-<tag>-setup.exe` (instalator) lub `.zip` (wersja przenośna) |
| Linux x64 | `ddagent-flutter-linux-x64-<tag>.deb` lub `.tar.gz` |
| Android | `ddagent-flutter-android-<tag>.apk` |
| Web | `ddagent-flutter-web-<tag>.zip` |

Przy pierwszym uruchomieniu wpisz URL serwera (na przykład `http://my-vps:3001`) i utwórz pierwsze konto. Na Windowsie i Linuksie x64 klient desktopowy może też sam pobrać i uruchomić lokalny serwer („To urządzenie” na ekranie połączenia).

Wersja web nie ma ekranu logowania i wywołuje API pod własnym originem, więc musi być serwowana za reverse proxy przed serwerem działającym w jednoużytkownikowym trybie platformy (`VITE_IS_PLATFORM=true`, co wyłącza uwierzytelnianie). W checkoutcie ze źródeł `node scripts/serve-flutter-web.cjs` serwuje `flutter/build/web` na porcie 8085 i przekazuje API oraz WebSockety do serwera na `FLUTTER_BACKEND_PORT` (domyślnie `10087`). Udostępniaj taką konfigurację wyłącznie w zaufanej sieci.

Aby samodzielnie zbudować klienta:

```bash
cd flutter
flutter pub get
flutter build linux --release      # or: windows, apk, web
```

### Ze źródeł

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run build && node dist-server/server/index.js   # API on http://localhost:3001
```

### Docker sandbox (eksperymentalny)

```bash
ddagent sandbox ~/my-project
```

Uruchamia ddagent i agenta (Claude Code lub Codex) w Docker Sandbox izolowanym przez microVM. Wymaga CLI `sbx` — zobacz [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md).

## CLI

W checkoutcie ze źródeł lub po `install.sh`, `ddagent` poniżej oznacza `node dist-server/server/modules/cli/cli.js` (ma shebang, więc działa też `./dist-server/server/modules/cli/cli.js`).

| Komenda | Opis |
|---|---|
| `ddagent` / `ddagent start` | Uruchamia serwer (komenda domyślna) |
| `ddagent status` | Pokazuje wersję oraz lokalizacje pliku konfiguracyjnego, bazy danych i projektów Claude |
| `ddagent sandbox <workspace>` | Tworzy i uruchamia Docker sandbox; `ddagent sandbox help` wymienia `ls`, `start`, `stop`, `rm`, `logs` |
| `ddagent browser-use-mcp` | Uruchamia serwer MCP browser-use przez stdio |
| `ddagent version` | Wypisuje wersję |
| `ddagent help` | Pokazuje pomoc |

| Opcja | Opis |
|---|---|
| `-p, --port <port>` | Port serwera (nadpisuje `SERVER_PORT`) |
| `--database-path <path>` | Własna lokalizacja bazy danych (nadpisuje `DATABASE_PATH`) |

## Konfiguracja

Serwer czyta opcjonalny plik `.env` ze swojego katalogu instalacji (obok `start.sh`); prawdziwe zmienne środowiskowe mają pierwszeństwo. Uruchom `ddagent status`, aby sprawdzić, który plik jest używany.

| Zmienna | Domyślna | Opis |
|---|---|---|
| `SERVER_PORT` | `3001` | Port API + WebSocket (`PORT` jest akceptowany jako starszy alias) |
| `HOST` | `0.0.0.0` | Adres bind (`127.0.0.1` tylko dla localhosta) |
| `DATABASE_PATH` | `~/.ddagent/auth.db` | Baza SQLite (użytkownicy, ustawienia, tokeny) |
| `WORKSPACES_ROOT` | katalog domowy | Projekty muszą znajdować się w tym katalogu |
| `JWT_SECRET` | generowany automatycznie | Sekret do podpisywania tokenów logowania (generowany i zapisywany dla każdej instalacji) |
| `API_KEY` | nieustawiony | Gdy ustawiony, żądania API muszą przesyłać go w nagłówku `x-api-key` |
| `CLAUDE_CLI_PATH` | `claude` | Własna binarka Claude Code CLI |
| `CONTEXT_WINDOW` | `200000` | Zapasowe okno kontekstu Claude, używane, dopóki SDK nie zgłosi rzeczywistego okna modelu |
| `STT_ENDPOINT_URL` / `STT_API_KEY` / `STT_MODEL` | `https://api.openai.com/v1` / nieustawiony / `whisper-1` | Speech-to-text dla wprowadzania głosowego (konfigurowalne też w Ustawieniach) |
| `VITE_IS_PLATFORM` | `false` | Jednoużytkownikowy tryb platformy: pomija uwierzytelnianie (wymagany przez klienta web) |

Więcej w [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example).

## Rozwój

```bash
npm install
npm run dev               # start the backend from source (tsx, no reload)
npm run server:dev-watch  # same, restarting on file changes
npm run build             # compile the server to dist-server/
npm test                  # backend tests
npm run typecheck         # TypeScript check
npm run lint              # ESLint
```

Klient (Flutter 3.47.5 stable):

```bash
cd flutter
flutter pub get
flutter run -d linux --dart-define=DEFAULT_SERVER_URL=http://localhost:3001
dart format --line-length 100 lib test
flutter analyze
flutter test
```

Kod backendu stosuje architekturę modułową z `server/modules/`; szczegóły wewnętrzne providerów opisuje [`server/modules/providers/README.md`](https://github.com/Zakwei/ddagent/blob/main/server/modules/providers/README.md).

## Współpraca

Poprawki błędów są mile widziane — zobacz [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md). Aby zgłosić podatność, zobacz [SECURITY.md](https://github.com/Zakwei/ddagent/blob/main/SECURITY.md).

---

<div align="center">
  <sub>Zbudowane dla społeczności Claude Code, Codex, Cursor, OpenCode, Devin, Command Code i Antigravity.</sub>
</div>
