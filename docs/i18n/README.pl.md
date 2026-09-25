<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>Jeden interfejs dla wszystkich Twoich agentów AI do kodowania.</strong><br>
  Self-hosted interfejs webowy i mobilny dla Claude Code, Codex, Cursor CLI, OpenCode i Devin — sesje, pliki, git, terminale i zadania w jednym miejscu.</p>

  <p>
    <img src="https://img.shields.io/badge/version-0.5.9-0066FF" alt="wersja">
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

---

## Czym jest ddagent?

ddagent działa na Twojej własnej maszynie lub VPS-ie i daje dopracowany interfejs webowy ponad agentami do kodowania, których już używasz. Odkrywa ich sesje bezpośrednio z dysku — Twoja historia z `~/.claude`, Codex i Devin pojawia się natychmiast, nic nie jest duplikowane ani synchronizowane z podmiotami trzecimi.

Otwórz go w dowolnej przeglądarce w swojej sieci albo na telefonie. Twoja maszyna, Twoi agenci, Twoje dane.

## Funkcje

- **Sesje multi-agent** — uruchamiaj i wznawiaj sesje Claude Code, Codex, Cursor CLI, OpenCode i Devin obok siebie, z live streamingiem przez WebSocket
- **Podział okien** — panele czatu, terminala, przeglądarki i plików w jednym workspace
- **Eksplorator i edytor plików** — przeglądaj workspace, edytuj kod w CodeMirror
- **Panel Git** — stage, commit, diff i przełączanie branchy bez wychodzenia z UI
- **Zintegrowana powłoka** — pełny terminal dla każdego workspace plus osobna karta powłoki
- **Tablica zadań** — widok kanban napędzany przez TaskMaster; zamieniaj PRD-y na wykonywalne zadania
- **Zarządzanie MCP** — dodawaj, edytuj i synchronizuj serwery MCP między agentami
- **Przeglądarka skilli** — zarządzaj skillami agentów z poziomu UI
- **Limity i zużycie** — zużycie tokenów i limity subskrypcji per agent, na pierwszy rzut oka
- **Browser-use** — sesje przeglądarki sterowane przez agenta do researchu i testów
- **Worktree** — twórz izolowane worktree git per zadanie, ze skryptami setup/run per worktree i uwierzytelnionym podglądem dev-servera na żywo
- **Zdalne zatwierdzanie** — zatwierdzaj uprawnienia narzędzi z Telegrama, Discorda lub aplikacji mobilnej
- **Wprowadzanie głosowe** — dyktuj prompty przez endpoint STT kompatybilny z Whisper
- **Broadcast do agentów i współdzielona pamięć** — wysyłaj wiadomość do wszystkich agentów naraz i prowadź notatki per projekt, które wszyscy czytają
- **Przełączanie wielu kont** — nazwane konta per provider z nadpisaniami zmiennych środowiskowych per sesja
- **Scheduler** — uruchamianie agentów wg crona, z keep-awake w web/desktop
- **Współpraca w zespole** — role (owner/member/viewer), linki z zaproszeniami, przypisania, komentarze, obecność i feed aktywności na tablicy ([dokumentacja](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md))
- **Serwer MCP** — pozwól zewnętrznym klientom MCP (Claude Desktop, OpenClaw) tworzyć zadania i wysyłać wiadomości do sesji ([dokumentacja](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Powiadomienia i TTS** — otrzymuj ping (lub odczyt na głos), gdy sesja Cię potrzebuje
- **Sandboxy Docker** — uruchamiaj agentów w środowiskach izolowanych przez microVM ([dokumentacja](https://github.com/Zakwei/ddagent/blob/main/docker/README.md))
- **Aplikacja desktopowa** — opcjonalna aplikacja Electron; **12 języków**, motywy ciemny i jasny

## Obsługiwani agenci

| Agent | Jak się łączy |
|---|---|
| **Claude Code** | Automatycznie wykrywa sesje z `~/.claude`; synchronizacja MCP i ustawień z natywnym CLI |
| **Codex** | Lokalne sesje CLI i transkrypty |
| **Cursor CLI** | Lokalne sesje CLI |
| **OpenCode** | Lokalne sesje i lokalizacje skilli |
| **Devin** | Sesje CLI/ACP przez lokalną synchronizację |

Przynosisz własne subskrypcje — ddagent dostarcza środowisko, nie AI.

## Instalacja

Wymaga **Node.js 22+** na maszynie, na której działa serwer. Serwer serwuje interfejs webowy oraz REST/WS API, z którymi łączą się zdalnie aplikacje desktopowa i mobilna.

### Serwer self-hosted — skrypt instalacyjny

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

Klonuje tag najnowszego release'u do `~/.ddagent/app`, buduje web UI + backend i zostawia launcher `start.sh`. Opcje: `--version vX.Y.Z` · `--dir <path>` · `--port <port>` · `--systemd` (instaluje i włącza userową jednostkę systemd). Uruchom ponownie z `--version`, aby zaktualizować w miejscu.

Następnie:

```bash
~/.ddagent/app/start.sh        # → http://localhost:3001
```

### Serwer self-hosted — gotowy tarball

Bez kroku budowania — pobierz `ddagent-server-<version>-<os>-<arch>.tar.gz` z [Releases](https://github.com/Zakwei/ddagent/releases), rozpakuj, uruchom:

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh           # start.bat on Windows
```

### Aplikacja desktopowa

Pobierz instalator dla swojego systemu z [Releases](https://github.com/Zakwei/ddagent/releases): `.dmg` (macOS) · `.exe` (Windows) · `.AppImage` / `.deb` (Linux).

Działa standalone — serwer jest wbudowany, nic więcej do instalacji — albo w trybie zdalnym względem URL serwera self-hosted. Auto-aktualizacje przez feedy `latest*.yml` z release'u.

### Aplikacja mobilna (wersja poglądowa)

Pobierz `ddagent-mobile-<version>.apk` z [Releases](https://github.com/Zakwei/ddagent/releases) i zainstaluj ją na urządzeniu z Androidem; aplikacja łączy się z URL serwera self-hosted.

### Ze źródeł

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run dev        # server :3001 + Vite :5173 with HMR
```

### Docker sandbox (eksperymentalny)

```bash
ddagent sandbox ~/my-project
```

Uruchamia agenta w sandboxie izolowanym przez hypervisor. Zobacz [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md).

## CLI

W checkoutcie ze źródeł lub po `install.sh`, `ddagent` poniżej oznacza `node dist-server/server/modules/cli/cli.js` (ma shebang, więc działa też `./dist-server/server/modules/cli/cli.js`).

| Komenda | Opis |
|---|---|
| `ddagent` | Uruchamia serwer |
| `ddagent start` | Uruchamia serwer |
| `ddagent status` | Pokazuje lokalizacje konfiguracji i danych |
| `ddagent version` | Wypisuje wersję |
| `ddagent help` | Pokazuje pomoc |

## Konfiguracja

Wszystkie ustawienia znajdują się w jednym pliku env — uruchom `ddagent status`, żeby zobaczyć, skąd jest czytany Twój.

| Zmienna | Domyślna | Opis |
|---|---|---|
| `SERVER_PORT` | `3001` | Port API + WebSocket |
| `VITE_PORT` | `5173` | Port dev-servera |
| `HOST` | `0.0.0.0` | Adres bind (`127.0.0.1` tylko dla localhosta) |
| `DATABASE_PATH` | auto | Lokalizacja bazy danych auth |
| `CONTEXT_WINDOW` | `160000` | Maks. tokenów per sesja |
| `CLAUDE_CLI_PATH` | `claude` | Własna ścieżka do binarki Claude CLI |

Pełna lista w [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example).

## Rozwój

```bash
npm run dev            # dev mode (server :3001 + vite :5173)
npm run build          # client + server production build
npm run test:client    # frontend tests
npm test               # backend tests
npm run typecheck      # TypeScript check
```

Kod backendu stosuje architekturę modułową opisaną w `server/modules/` — patrz `server/modules/providers/README.md` dla wnętrzności providerów.

## Współpraca

Poprawki błędów są mile widziane — zobacz [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md).

---

<div align="center">
  <sub>Zbudowane dla społeczności Claude Code, Cursor, Codex, OpenCode i Devin.</sub>
</div>
