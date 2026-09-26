# Änderungsprotokoll

Alle wichtigen Änderungen an ddagent werden hier dokumentiert.

Das Format folgt [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
und dieses Projekt hält sich an [Semantic Versioning](https://semver.org/).

<p>
  <a href="../../CHANGELOG.md">English</a> ·
  <a href="CHANGELOG.pl.md">Polski</a> ·
  <strong>Deutsch</strong> ·
  <a href="CHANGELOG.es.md">Español</a> ·
  <a href="CHANGELOG.fr.md">Français</a> ·
  <a href="CHANGELOG.it.md">Italiano</a> ·
  <a href="CHANGELOG.ja.md">日本語</a> ·
  <a href="CHANGELOG.ko.md">한국어</a> ·
  <a href="CHANGELOG.ru.md">Русский</a> ·
  <a href="CHANGELOG.tr.md">Türkçe</a> ·
  <a href="CHANGELOG.zh-CN.md">简体中文</a> ·
  <a href="CHANGELOG.zh-TW.md">繁體中文</a>
</p>

## [0.6.1] - 2026-09-26

### Fehlerbehebungen

- Mobil: Modellauswahl war bei neuen Chats nicht verfügbar, Multi-Panel-Workspace nicht erreichbar
- Mobil: Split-Workspace-Panels betten jetzt echte Chat-Ansichten ein

## [0.6.0] - 2026-09-26

### Neuigkeiten

- **Auto-Orchestrierungs-Provider** — Modell-Routing, Planer-DAG und Delegation mit Routing-/Plan-/Delegations-/Zusammenfassungskarten im Chat, plus ein Orchestrierungs-Tab in den Einstellungen
- **Mobil: volle native Parität** — jeder Bildschirm ist jetzt nativ: Dateien (CRUD, Suche, Lightbox), Quellcodeverwaltung (Hunk-Staging, Split-Diff, Commit-Graph, Worktrees), Aufgaben (PRD-Editor, Detailbearbeitung), Agenten-Board, Kontingent & Nutzung, Terminal, Editor und alle Einstellungs-Tabs
- **Mobil:** Onboarding-Assistent, Projekterstellungs-Assistent (Ordnerbrowser, GitHub-Klon, Überprüfung), Befehlspalette mit globaler Suche, geteiltes Workspace-Raster, Schnelleinstellungen-Panel, Browser-Use-Live-Panel
- **Mobil:** Offline-Nachrichtenwarteschlange, Chat-Export (PDF/md/html/text), Transkriptsuche, Sitzungsvergleich

### Fehlerbehebungen

- OpenCode: doppelte Sitzungszeilen aus gestreamten Text-Snapshots, nicht angezeigte Prompts des Fragetools
- Sticky-Review-/Suchleiste schneidet die erste Nachricht ab

## [0.5.9] - 2026-09-25

Erste öffentliche Open-Source-Veröffentlichung — **AGPL-3.0-only**.

### Neuigkeiten

- **Teamzusammenarbeit** — gemeinsame Sitzungen, Broadcast-Nachrichten, Agenten-Posteingang, gemeinsamer Speicher pro Projekt
- **MCP-Server** — externe MCP-Clients (Claude Desktop, OpenClaw) können Aufgaben erstellen und Sitzungen über `POST /mcp` Nachrichten senden ([Doku](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Remote-Genehmigungen** — Agentenaktionen von Telegram oder Discord aus genehmigen ([Doku](https://github.com/Zakwei/ddagent/blob/main/docs/remote-approvals.md))
- **Scheduler** — Cron-Zeitpläne für Agentenläufe mit Ruhemodus-Verhinderung
- **Benannte Provider-Konten** — sitzungsbezogene Überschreibungen von Umgebungsvariablen und Zugangsdaten
- **Spracheingabe (STT)** — Whisper-kompatibler Endpunkt im Composer
- **Worktrees** — Setup- und Run-Skripte pro Repository mit Dev-Server-Runner
- **Vorschau** — authentifizierter Dev-Server-Vorschau-Proxy mit WS-Tunnel
- **Mobil** — Sitzungssuche, aktionsfähige Genehmigungs-Push-Benachrichtigungen (FCM)
- `SECURITY.md` — Richtlinie zur vertraulichen Meldung von Sicherheitslücken

### Fehlerbehebungen

- Daten- und Anzeigefehler im Kontingent-Tab
- Chat: Offline-Warteschlange und Entwürfe überstehen Neuladen; stabile Scrollposition über erneute Abrufe hinweg
- Sitzungen: gelöschte Sitzungen hinterlassen keine Geister mehr auf anderen Clients
- Kanban: Race Conditions und Leaks beim Dispatch auf dem Agenten-Board
- Mobil: unbearbeitetes Tastaturhöhen-Padding, ActionSheet ersetzt Überlauf-Warnungen

## [0.5.8] - 2026-09-23

### Neuigkeiten

- `install.sh` — git-basiertes Server-Installationsprogramm (`--version`, `--dir`, `--port`, `--systemd`)
- Eigenständige und lokale Server-Tarballs werden auf `v*`-Tags veröffentlicht

### Fehlerbehebungen

- Mobile Tastatur verdeckt den Composer und Inhalte unter der System-Navigationsleiste (Android)

## [0.5.7] - 2026-09-23

### Fehlerbehebungen

- Desktop-CI-Builds (Bundle-Plattform-Flag, native Rebuilds, Smoke-Timeouts)
- Doppelte gestreamte Assistenten-Nachrichten in Chat-Verläufen

## [0.5.6] - 2026-09-23

### Fehlerbehebungen

- Desktop-CI: unsignierte macOS-Builds bei fehlenden Apple-Secrets, Windows Scoped-Package-Staging

## [0.5.5] - 2026-09-23

### Neuigkeiten

- **Desktop-App (Vorschau)** — Electron-Launcher für lokale oder Remote-Server, eingebettetes Backend, Auto-Update, dmg/NSIS/AppImage/deb-Builds
- **Mobile App (Vorschau)** — Expo/React-Native-Begleiter: Sitzungen, Chat mit Modellauswahl und Slash-Befehlen, Terminal, Dateien, Einstellungs-WebViews
- Ungelesen-Indikator bei Sitzungen mit neuen Ausgaben; Verknüpfung Aufgabenboard ↔ Sitzung
- KaTeX- und Mermaid-Inseln im Chat

### Fehlerbehebungen

- Touch-Ziele und Layouts auf mobilen Viewports; Feinschliff an Befehlspalette, Kanban und Einstellungen

## [0.5.4] - 2026-09-21

### Neuigkeiten

- Server-Neustart-Schaltfläche mit Vollbild-Fortschritts-Overlay (Einstellungen → Über)
- Lokalisiertes GitHub-Releases-Changelog in Einstellungen → Über
- Anzahl laufender Sitzungen im Browser-Tab-Titel
- Y-Achsen-Skalierung und Hover-Tooltips im Nutzungstrend-Diagramm

### Fehlerbehebungen

- Einstellungs-Autosave wird beim Öffnen von Dialogen ausgelöst; kompaktes Chat-Layout in mehrzeiligen Splits

## [0.5.3] - 2026-09-21

### Fehlerbehebungen

- Update-verfügbar-Dialog hinter der Seitenleiste verborgen (Portal-Fix)

## [0.5.2] - 2026-09-21

### Fehlerbehebungen

- Update-Prüfung über den Server geleitet

## [0.5.1] - 2026-09-21

### Neuigkeiten

- Update-verfügbar-Badge mit Ein-Klick-Selbstaktualisierung
- Vorlesestimme pro Sitzung; Stimmenauswahl in die Darstellungseinstellungen verschoben

### Fehlerbehebungen

- Chat-Banner zeigt den tatsächlichen Provider der Sitzung

## [0.5.0] - 2026-09-21

Erste eigenständige Version von **ddagent** — eine selbstgehostete Web- und Mobile-UI für KI-Coding-Agenten.

### Highlights

- **Multi-Agenten-Sitzungen** — Claude Code, Codex, Cursor CLI, OpenCode und Devin Seite an Seite, mit Live-Streaming und Fortsetzen
- **Workspace-Layout** — geteilte Bereiche für Chat, Terminal, Browser und Dateien
- **Datei-Explorer & Editor** — Workspace in der UI durchsuchen und bearbeiten
- **Git-Panel** — Stagen, Committen, Diffs, Branches wechseln, Worktrees verwalten
- **Aufgabenboard** — Kanban powered by TaskMaster; ausführbare Aufgaben aus PRDs generieren
- **MCP-Verwaltung** — MCP-Server agentenübergreifend hinzufügen und synchronisieren
- **Skills-Browser** — Agenten-Skills entdecken und verwalten
- **Kontingent & Nutzung** — Token-Nutzung pro Agent und Abo-Limits
- **Browser-use** — agentengesteuerte Browser-Sitzungen für Recherche und Tests
- **Benachrichtigungen & TTS** — Warnungen und vorgelesene Antworten
- **Docker-Sandboxen** — experimentelle hypervisor-isolierte Agentenläufe
- **Desktop-Begleiter** — optionale Electron-App für macOS/Windows
- **i18n** — 11 UI-Sprachen, dunkle und helle Themes

### CLI

- `ddagent` / `ddagent start` — Server starten
- `ddagent status` — Konfiguration und Datenorte anzeigen
- `ddagent version` / `ddagent help`
