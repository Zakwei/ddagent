<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>Eine UI für alle deine AI-Coding-Agenten.</strong><br>
  Selbst gehosteter Server und Flutter-Client (Web, Linux, Windows &amp; Android) für Claude Code, Codex, Cursor CLI, OpenCode, Devin, Command Code und Antigravity — Sessions, Dateien, Git, Terminals und Tasks an einem Ort.</p>

  <p>
    <img src="https://img.shields.io/github/v/release/Zakwei/ddagent?label=Version&amp;color=0066FF" alt="Version">
    <img src="https://img.shields.io/badge/license-AGPL--3.0-blue" alt="Lizenz: AGPL-3.0">
    <img src="https://img.shields.io/badge/node-%E2%89%A522-339933" alt="node >= 22">
    <img src="https://img.shields.io/badge/self--hosted-yes-success" alt="selbst gehostet">
  </p>

  <p>
    <a href="#installation">Installation</a> ·
    <a href="https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md">Mitwirken</a> ·
    <a href="https://github.com/Zakwei/ddagent/issues">Bug-Reports</a>
  </p>

  <p>
    <a href="../../README.md">English</a> ·
    <a href="README.pl.md">Polski</a> ·
    <strong>Deutsch</strong> ·
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
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/desktop-main.png" alt="ddagent-Chatansicht" width="78%">&nbsp;
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/mobile-chat.png" alt="ddagent-Mobilansicht" width="20%">
</p>

<table>
  <tr>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/sessions.png" alt="Letzte Sessions aus Claude Code und Codex"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/kanban-board.png" alt="Kanban-Board, das Agenten-Läufe steuert"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/git-panel.png" alt="Git-Panel mit Hunk-Staging"></td>
  </tr>
  <tr>
    <td align="center"><sub>Sessions aller Agenten in einer Liste</sub></td>
    <td align="center"><sub>Kanban-Board — Karten starten Agenten-Läufe</sub></td>
    <td align="center"><sub>Git-Panel — Diff, Hunks stagen, Commit</sub></td>
  </tr>
</table>

---

## Was ist ddagent?

ddagent läuft auf deinem eigenen Rechner oder VPS und legt eine durchdachte UI über die Coding-Agenten, die du bereits nutzt. Der Server liest die Sessions jedes Agenten direkt aus dessen eigenem Verlauf auf der Festplatte (`~/.claude`, `~/.codex`, `~/.cursor`, OpenCode, Devin, …), sodass bestehende Unterhaltungen ohne jeglichen Import erscheinen. Lokal werden nur Session-Metadaten indexiert; nichts wird an Dritte gesendet.

Verbinde dich über den Flutter-Client auf deinem Desktop, Smartphone oder im Browser. Dein Rechner, deine Agenten, deine Daten.

## Funktionen

- **Multi-Agent-Sessions** — Sessions aus sieben Agenten-CLIs nebeneinander starten und fortsetzen, mit Live-Streaming über WebSocket
- **Auto-Orchestrator** — „Auto“-Sessions leiten jede Aufgabe an einen passenden Agenten und ein passendes Modell weiter, berücksichtigen dabei das verbleibende Abo-Kontingent und delegieren Arbeit an Child-Sessions
- **Geteilter Arbeitsbereich** — bis zu sechs Panels (Chat, Terminal, Browser, Vorschau, Editor, Git, Notizen) in einem Fenster
- **Datei-Explorer & Editor** — den Workspace durchsuchen und Code im integrierten Editor bearbeiten
- **Git-Panel** — Dateien oder einzelne Hunks stagen, committen (mit KI-generierten Nachrichten), Diffs ansehen, Branches wechseln, Pull/Push und Checkpoints wiederherstellen, ohne die UI zu verlassen
- **Integriertes Terminal** — eine vollwertige Shell pro Workspace
- **Kanban-Board** — eine Karte verschieben, um einen Agenten-Lauf darauf zu starten (optional in einem eigenen Worktree); der Agent meldet sich, sobald er fertig ist
- **TaskMaster** — PRDs in Tasks verwandeln und auf einem Task-Board verfolgen
- **Nachrichten-Queue** — Nachrichten, die gesendet werden, während ein Agent beschäftigt ist, landen serverseitig in einer Warteschlange und überstehen Neuladen und Gerätewechsel
- **MCP-Verwaltung** — MCP-Server agentenübergreifend hinzufügen, bearbeiten und synchronisieren
- **Wissensdatenbank** — ein lokales, durchsuchbares Gedächtnis für alle Agenten: Regeln, Skills, Erinnerungen und persönliche Infos, bei Bedarf über MCP abgerufen ([Doku](KNOWLEDGE.de.md))
- **Skills & Regeln** — Agenten-Skills und gemeinsame Regeln an einem Ort verwalten
- **Kontingent & Nutzung** — Token-Verbrauch und Abo-Limits pro Agent auf einen Blick
- **Browser-use** — agentengesteuerte Browser-Sessions für Recherche und Tests, mit einem Live-Browser-Panel
- **Worktrees** — isolierte Git-Worktrees pro Task anlegen, mit Setup-/Run-Skripten pro Worktree und einer authentifizierten Live-Vorschau des Dev-Servers
- **Remote-Freigaben** — Tool-Berechtigungen über Telegram, Discord oder die Android-App freigeben ([Doku](https://github.com/Zakwei/ddagent/blob/main/docs/remote-approvals.md))
- **Spracheingabe** — Prompts über einen Whisper-kompatiblen Speech-to-Text-Endpunkt diktieren
- **Agenten-Broadcast & gemeinsames Gedächtnis** — allen Agenten gleichzeitig eine Nachricht senden und projektbezogene Notizen pflegen, die alle lesen
- **Multi-Account-Wechsel** — benannte Accounts pro Provider mit Env-Overrides pro Session
- **Scheduler** — cron-gesteuerte, unbeaufsichtigte Agenten-Läufe, optional mit Wachhalten des Geräts, solange Läufe aktiv sind
- **Team-Zusammenarbeit** — Rollen (owner/member/viewer), Einladungslinks, Zuständige, Kommentare, Präsenz und ein Aktivitätsfeed auf dem Board ([Doku](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md))
- **MCP-Server** — externe MCP-Clients (Claude Desktop, OpenClaw) können Sessions auflisten, Tasks anlegen und Sessions Nachrichten senden ([Doku](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Benachrichtigungen & TTS** — Push-, Telegram- und Discord-Benachrichtigungen, wenn eine Session dich braucht, plus optionales Vorlesen der Antworten
- **Befehlspalette** — `Ctrl/Cmd+Shift+K`, um Sessions und Nachrichten zu durchsuchen, zu jeder Seite zu springen oder Schnellaktionen auszuführen
- **Docker-Sandboxes** — Agenten in microVM-isolierten Docker Sandboxes ausführen ([Doku](https://github.com/Zakwei/ddagent/blob/main/docker/README.md))
- **Flutter-Client** — eine Codebasis für Web, Linux, Windows und Android; **12 Sprachen**, dunkles und helles Theme

## Unterstützte Agenten

| Agent | Anbindung |
|---|---|
| **Claude Code** | Claude Agent SDK; erkennt `~/.claude`-Sessions automatisch; MCP- und Einstellungs-Sync mit der nativen CLI |
| **Codex** | Codex SDK; lokale Sessions und Transkripte aus `~/.codex` |
| **Cursor CLI** | `cursor-agent` mit Streaming-JSON-Ausgabe; lokale Chats aus `~/.cursor` |
| **OpenCode** | `opencode serve`; lokale Sessions aus der OpenCode-Datenbank |
| **Devin** | `devin acp` (Agent Client Protocol); lokale Transkripte |
| **Command Code** | `command-code acp` (Agent Client Protocol); Transkripte aus `~/.commandcode` |
| **Antigravity** | `agy`-CLI im Headless-Modus; Unterhaltungen indexiert aus `~/.gemini/antigravity-cli` |

Die Agenten-CLIs müssen auf dem Server-Rechner installiert und angemeldet sein. Deine Abos bringst du selbst mit — ddagent stellt die Umgebung bereit, nicht die KI.

## Installation

ddagent besteht aus zwei Teilen: dem **Server**, der neben deinen Agenten läuft und eine REST/WebSocket-API bereitstellt, und dem **Client**, der sich mit ihm verbindet. Der Server benötigt **Node.js 22+** (die vorgefertigten Tarballs benötigen Node.js 22.x, da ihre nativen Module dagegen gebaut sind).

### Server — Installer-Skript

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

Benötigt `git`, Node.js 22+ und `npm`. Das Skript klont ein Release-Tag nach `~/.ddagent/app`, installiert die Abhängigkeiten, baut das Backend und erzeugt einen `start.sh`-Launcher. Optionen übergibst du nach `bash -s --`:

| Option | Beschreibung |
|---|---|
| `--version vX.Y.Z` | Bestimmtes Release installieren (Standard: neuestes) |
| `--dir <path>` | Installationsverzeichnis (Standard: `~/.ddagent/app`) |
| `--systemd` | Einen systemd-User-Service namens `ddagent` installieren und aktivieren |
| `--port <port>` | Port für den systemd-Service (Standard: `3001`) |

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash -s -- --systemd --port 3001
```

Zum Aktualisieren führst du das Skript erneut mit `--version vX.Y.Z` aus; es aktualisiert den Checkout an Ort und Stelle. Danach startest du den Server:

```bash
~/.ddagent/app/start.sh        # API on http://<host>:3001 (set SERVER_PORT to change)
```

### Server — vorgefertigter Tarball

Kein Build-Schritt: Lade `ddagent-server-<version>-<os>-<arch>.tar.gz` (`linux-x64`, `mac-arm64` oder `win-x64`) unter [Releases](https://github.com/Zakwei/ddagent/releases) herunter, entpacke es und starte den Launcher:

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh             # start.bat on Windows
```

Zu jedem Tarball gibt es eine `.sha256`-Prüfsumme. Einstellungen kommen in eine optionale `.env`-Datei neben `start.sh`.

### Client

Lade einen vorgefertigten Client unter [Releases](https://github.com/Zakwei/ddagent/releases) herunter:

| Plattform | Datei |
|---|---|
| Windows x64 | `ddagent-flutter-windows-x64-<tag>-setup.exe` (Installer) oder `.zip` (portabel) |
| Linux x64 | `ddagent-flutter-linux-x64-<tag>.deb` oder `.tar.gz` |
| Android | `ddagent-flutter-android-<tag>.apk` |
| Web | `ddagent-flutter-web-<tag>.zip` |

Gib beim ersten Start die URL deines Servers ein (zum Beispiel `http://my-vps:3001`) und lege das erste Konto an. Unter Windows und Linux x64 kann der Desktop-Client auch einen lokalen Server für dich herunterladen und ausführen („Dieses Gerät“ auf dem Verbindungsbildschirm).

Der Web-Build hat keinen Login-Bildschirm und ruft die API auf seinem eigenen Origin auf. Er muss daher hinter einem Reverse Proxy ausgeliefert werden, der vor einem Server im Single-User-Plattformmodus steht (`VITE_IS_PLATFORM=true`, was die Authentifizierung deaktiviert). In einem Quellcode-Checkout liefert `node scripts/serve-flutter-web.cjs` `flutter/build/web` auf Port 8085 aus und leitet API und WebSockets an den Server auf `FLUTTER_BACKEND_PORT` weiter (Standard `10087`). Stelle dieses Setup nur in einem vertrauenswürdigen Netzwerk bereit.

Um den Client selbst zu bauen:

```bash
cd flutter
flutter pub get
flutter build linux --release      # or: windows, apk, web
```

### Aus dem Quellcode

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run build && node dist-server/server/index.js   # API on http://localhost:3001
```

### Docker-Sandbox (experimentell)

```bash
ddagent sandbox ~/my-project
```

Führt ddagent und einen Agenten (Claude Code oder Codex) in einer microVM-isolierten Docker Sandbox aus. Benötigt die `sbx`-CLI — siehe [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md).

## CLI

In einem Quellcode- oder `install.sh`-Checkout steht `ddagent` im Folgenden für `node dist-server/server/modules/cli/cli.js` (die Datei hat einen Shebang, daher funktioniert auch `./dist-server/server/modules/cli/cli.js`).

| Befehl | Beschreibung |
|---|---|
| `ddagent` / `ddagent start` | Server starten (Standardbefehl) |
| `ddagent status` | Version sowie Speicherorte von Konfigurationsdatei, Datenbank und Claude-Projekten anzeigen |
| `ddagent sandbox <workspace>` | Docker-Sandbox anlegen und starten; `ddagent sandbox help` listet `ls`, `start`, `stop`, `rm`, `logs` |
| `ddagent browser-use-mcp` | Den browser-use-MCP-Server über stdio ausführen |
| `ddagent version` | Version ausgeben |
| `ddagent help` | Hilfe anzeigen |

| Option | Beschreibung |
|---|---|
| `-p, --port <port>` | Server-Port (überschreibt `SERVER_PORT`) |
| `--database-path <path>` | Eigener Speicherort der Datenbank (überschreibt `DATABASE_PATH`) |

## Konfiguration

Der Server liest eine optionale `.env`-Datei aus seinem Installationsverzeichnis (neben `start.sh`); echte Umgebungsvariablen haben Vorrang. Mit `ddagent status` siehst du, welche Datei verwendet wird.

| Variable | Standard | Beschreibung |
|---|---|---|
| `SERVER_PORT` | `3001` | Port für API + WebSocket (`PORT` wird als Legacy-Alias akzeptiert) |
| `HOST` | `0.0.0.0` | Bind-Adresse (`127.0.0.1` nur für localhost) |
| `DATABASE_PATH` | `~/.ddagent/auth.db` | SQLite-Datenbank (Benutzer, Einstellungen, Tokens) |
| `WORKSPACES_ROOT` | Home-Verzeichnis | Projekte müssen innerhalb dieses Verzeichnisses liegen |
| `JWT_SECRET` | automatisch generiert | Secret zum Signieren von Login-Tokens (pro Installation generiert und gespeichert) |
| `API_KEY` | nicht gesetzt | Wenn gesetzt, müssen API-Anfragen ihn im Header `x-api-key` mitsenden |
| `CLAUDE_CLI_PATH` | `claude` | Eigenes Claude-Code-CLI-Binary |
| `CONTEXT_WINDOW` | `200000` | Fallback für das Claude-Kontextfenster, verwendet, bis das SDK das tatsächliche Fenster des Modells meldet |
| `STT_ENDPOINT_URL` / `STT_API_KEY` / `STT_MODEL` | `https://api.openai.com/v1` / nicht gesetzt / `whisper-1` | Speech-to-Text für die Spracheingabe (auch in den Einstellungen konfigurierbar) |
| `VITE_IS_PLATFORM` | `false` | Single-User-Plattformmodus: überspringt die Authentifizierung (vom Web-Client benötigt) |

Mehr dazu in [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example).

## Entwicklung

```bash
npm install
npm run dev               # start the backend from source (tsx, no reload)
npm run server:dev-watch  # same, restarting on file changes
npm run build             # compile the server to dist-server/
npm test                  # backend tests
npm run typecheck         # TypeScript check
npm run lint              # ESLint
```

Client (Flutter 3.47.5 stable):

```bash
cd flutter
flutter pub get
flutter run -d linux --dart-define=DEFAULT_SERVER_URL=http://localhost:3001
dart format --line-length 100 lib test
flutter analyze
flutter test
```

Der Backend-Code folgt der Modularchitektur in `server/modules/`; Details zu den Provider-Interna findest du in [`server/modules/providers/README.md`](https://github.com/Zakwei/ddagent/blob/main/server/modules/providers/README.md).

## Mitwirken

Bugfixes sind willkommen — siehe [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md). Um eine Sicherheitslücke zu melden, siehe [SECURITY.md](https://github.com/Zakwei/ddagent/blob/main/SECURITY.md).

---

<div align="center">
  <sub>Entwickelt für die Community von Claude Code, Codex, Cursor, OpenCode, Devin, Command Code und Antigravity.</sub>
</div>
