<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>Eine UI für alle deine AI-Coding-Agenten.</strong><br>
  Selbst gehostetes Web- &amp; Mobile-Interface für Claude Code, Codex, Cursor CLI, OpenCode und Devin — Sessions, Dateien, Git, Terminals und Tasks an einem Ort.</p>

  <p>
    <img src="https://img.shields.io/badge/version-0.5.9-0066FF" alt="Version">
    <img src="https://img.shields.io/badge/license-AGPL--3.0-blue" alt="Lizenz: AGPL-3.0">
    <img src="https://img.shields.io/badge/node-%E2%89%A522-339933" alt="node >= 22">
    <img src="https://img.shields.io/badge/self--hosted-yes-success" alt="self-hosted">
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
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/desktop-main.png" alt="ddagent Chat-Ansicht" width="78%">&nbsp;
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/mobile-chat.png" alt="ddagent Mobile-Ansicht" width="20%">
</p>

---

## Was ist ddagent?

ddagent läuft auf deinem eigenen Rechner oder VPS und liefert dir eine ausgefeilte Web-UI über den Coding-Agenten, die du bereits nutzt. Es erkennt ihre Sessions direkt von der Festplatte — deine `~/.claude`-, Codex- und Devin-Historie erscheint sofort, nichts wird dupliziert oder an Dritte synchronisiert.

Öffne es in jedem Browser in deinem Netzwerk oder auf dem Handy. Deine Maschine, deine Agenten, deine Daten.

## Funktionen

- **Multi-Agent-Sessions** — Claude-Code-, Codex-, Cursor-CLI-, OpenCode- und Devin-Sessions parallel starten und fortsetzen, mit Live-Streaming über WebSocket
- **Geteilte Panes** — Chat-, Terminal-, Browser- und Datei-Panes in einem Workspace
- **Datei-Explorer & Editor** — Workspace durchsuchen, Code mit CodeMirror bearbeiten
- **Git-Panel** — Stage, Commit, Diff und Branch-Wechsel, ohne die UI zu verlassen
- **Integrierte Shell** — vollständiges Terminal pro Workspace plus ein eigenständiger Shell-Tab
- **Task-Board** — Kanban-Ansicht auf Basis von TaskMaster; PRDs in ausführbare Tasks verwandeln
- **MCP-Verwaltung** — MCP-Server hinzufügen, bearbeiten und agentenübergreifend synchronisieren
- **Skills-Browser** — Agent-Skills direkt in der UI verwalten
- **Quota & Nutzung** — Token-Verbrauch und Abo-Limits pro Agent auf einen Blick
- **Browser-use** — agentengesteuerte Browser-Sessions für Recherche und Tests
- **Worktrees** — isolierte Git-Worktrees pro Task erstellen, mit Setup-/Run-Skripten pro Worktree und authentifizierter Live-Dev-Server-Vorschau
- **Remote-Freigaben** — Tool-Berechtigungen per Telegram, Discord oder der mobilen App genehmigen
- **Spracheingabe** — Prompts über einen Whisper-kompatiblen STT-Endpunkt diktieren
- **Agent-Broadcast & gemeinsamer Speicher** — alle Agenten gleichzeitig anschreiben und projektbezogene Notizen pflegen, die alle lesen
- **Multi-Account-Wechsel** — benannte Konten pro Provider mit Env-Overrides pro Session
- **Scheduler** — cron-gesteuerte Agent-Läufe, mit Keep-Awake auf Web/Desktop
- **Teamzusammenarbeit** — Rollen (Owner/Member/Viewer), Einladungslinks, Zuweisungen, Kommentare, Presence und Activity-Feed auf dem Board ([Doku](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md))
- **MCP-Server** — externe MCP-Clients (Claude Desktop, OpenClaw) Tasks erstellen und Sessions anschreiben lassen ([Doku](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Benachrichtigungen & TTS** — gepingt (oder vorgelesen) werden, wenn eine Session dich braucht
- **Docker-Sandboxes** — Agenten in microVM-isolierten Umgebungen ausführen ([Doku](https://github.com/Zakwei/ddagent/blob/main/docker/README.md))
- **Desktop-Companion** — optionale Electron-App; **12 Sprachen**, Dark- & Light-Theme

## Unterstützte Agenten

| Agent | Anbindung |
|---|---|
| **Claude Code** | Erkennt `~/.claude`-Sessions automatisch; MCP- & Settings-Sync mit dem nativen CLI |
| **Codex** | Lokale CLI-Sessions und Transkripte |
| **Cursor CLI** | Lokale CLI-Sessions |
| **OpenCode** | Lokale Sessions und Skill-Speicherorte |
| **Devin** | CLI-/ACP-Sessions via lokalem Sync |

Du bringst deine eigenen Abos mit — ddagent liefert die Umgebung, nicht die KI.

## Installation

Benötigt **Node.js 22+** auf der Maschine, die den Server ausführt. Der Server stellt die Web-UI sowie die REST/WS-API bereit, mit der sich die Desktop- und Mobile-Apps remote verbinden.

### Selbst gehosteter Server — Installer-Skript

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

Klont den neuesten Release-Tag nach `~/.ddagent/app`, baut die Web-UI + das Backend und hinterlässt einen `start.sh`-Launcher. Optionen: `--version vX.Y.Z` · `--dir <path>` · `--port <port>` · `--systemd` (installiert und aktiviert eine User-Systemd-Unit). Mit `--version` erneut ausführen, um vor Ort zu aktualisieren.

Danach:

```bash
~/.ddagent/app/start.sh        # → http://localhost:3001
```

### Selbst gehosteter Server — vorgefertigter Tarball

Kein Build-Schritt — `ddagent-server-<version>-<os>-<arch>.tar.gz` von [Releases](https://github.com/Zakwei/ddagent/releases) herunterladen, entpacken, starten:

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh           # start.bat on Windows
```

### Desktop-App

Lade den Installer für dein OS von [Releases](https://github.com/Zakwei/ddagent/releases) herunter: `.dmg` (macOS) · `.exe` (Windows) · `.AppImage` / `.deb` (Linux).

Läuft standalone — der Server ist eingebettet, nichts weiter zu installieren — oder im Remote-Modus gegen eine selbst gehostete Server-URL. Auto-Updates über die `latest*.yml`-Feeds des Releases.

### Mobile-App (Preview)

Lade `ddagent-mobile-<version>.apk` von [Releases](https://github.com/Zakwei/ddagent/releases) herunter und installiere sie auf deinem Android-Gerät; die App verbindet sich mit einer selbst gehosteten Server-URL.

### Aus dem Quellcode

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run dev        # server :3001 + Vite :5173 with HMR
```

### Docker-Sandbox (experimentell)

```bash
ddagent sandbox ~/my-project
```

Führt den Agenten in einer hypervisor-isolierten Sandbox aus. Siehe [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md).

## CLI

In einem Source- oder `install.sh`-Checkout bedeutet `ddagent` unten `node dist-server/server/modules/cli/cli.js` (hat einen Shebang, also funktioniert auch `./dist-server/server/modules/cli/cli.js`).

| Befehl | Beschreibung |
|---|---|
| `ddagent` | Server starten |
| `ddagent start` | Server starten |
| `ddagent status` | Konfig- und Datenpfade anzeigen |
| `ddagent version` | Version ausgeben |
| `ddagent help` | Hilfe anzeigen |

## Konfiguration

Alle Einstellungen liegen in einer einzigen Env-Datei — `ddagent status` zeigt, wo deine gelesen wird.

| Variable | Standard | Beschreibung |
|---|---|---|
| `SERVER_PORT` | `3001` | API- + WebSocket-Port |
| `VITE_PORT` | `5173` | Dev-Server-Port |
| `HOST` | `0.0.0.0` | Bind-Adresse (`127.0.0.1` für nur localhost) |
| `DATABASE_PATH` | auto | Speicherort der Auth-Datenbank |
| `CONTEXT_WINDOW` | `160000` | Max. Tokens pro Session |
| `CLAUDE_CLI_PATH` | `claude` | Eigener Pfad zur Claude-CLI-Binary |

Vollständige Liste siehe [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example).

## Entwicklung

```bash
npm run dev            # dev mode (server :3001 + vite :5173)
npm run build          # client + server production build
npm run test:client    # frontend tests
npm test               # backend tests
npm run typecheck      # TypeScript check
```

Der Backend-Code folgt der in `server/modules/` beschriebenen Modularchitektur — siehe `server/modules/providers/README.md` für Provider-Internals.

## Mitwirken

Bugfixes sind willkommen — siehe [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md).

---

<div align="center">
  <sub>Gebaut für die Claude-Code-, Cursor-, Codex-, OpenCode- und Devin-Community.</sub>
</div>
