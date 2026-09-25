# Registro delle modifiche

Tutte le modifiche rilevanti a ddagent sono documentate qui.

Il formato segue [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
e questo progetto aderisce al [Semantic Versioning](https://semver.org/).

<p>
  <a href="../../CHANGELOG.md">English</a> ·
  <a href="CHANGELOG.pl.md">Polski</a> ·
  <a href="CHANGELOG.de.md">Deutsch</a> ·
  <a href="CHANGELOG.es.md">Español</a> ·
  <a href="CHANGELOG.fr.md">Français</a> ·
  <strong>Italiano</strong> ·
  <a href="CHANGELOG.ja.md">日本語</a> ·
  <a href="CHANGELOG.ko.md">한국어</a> ·
  <a href="CHANGELOG.ru.md">Русский</a> ·
  <a href="CHANGELOG.tr.md">Türkçe</a> ·
  <a href="CHANGELOG.zh-CN.md">简体中文</a> ·
  <a href="CHANGELOG.zh-TW.md">繁體中文</a>
</p>

## [0.5.9] - 2026-09-25

Prima versione pubblica open source — **AGPL-3.0-only**.

### Novità

- **Collaborazione di team** — sessioni condivise, messaggi broadcast, casella di posta dell'agente, memoria condivisa per progetto
- **Server MCP** — i client MCP esterni (Claude Desktop, OpenClaw) possono creare attività e inviare messaggi alle sessioni tramite `POST /mcp` ([documentazione](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Approvazioni remote** — approva le azioni dell'agente da Telegram o Discord ([documentazione](https://github.com/Zakwei/ddagent/blob/main/docs/remote-approvals.md))
- **Pianificatore** — pianificazioni cron per le esecuzioni dell'agente con prevenzione della sospensione
- **Account provider denominati** — override di ambiente e credenziali per sessione
- **Input vocale (STT)** — endpoint compatibile con Whisper nel composer
- **Worktree** — script di configurazione ed esecuzione per repository con runner del server di sviluppo
- **Anteprima** — proxy di anteprima del server di sviluppo autenticato con tunnel WS
- **Mobile** — ricerca sessioni, notifiche push di approvazione azionabili (FCM)
- `SECURITY.md` — politica di segnalazione privata delle vulnerabilità

### Correzioni

- Bug di dati e visualizzazione nella scheda Quota
- Chat: la coda offline e le bozze sopravvivono ai ricaricamenti; posizione di scorrimento stabile tra i recuperi dei dati
- Sessioni: le sessioni eliminate non lasciano più fantasmi su altri client
- Kanban: race condition e perdite nell'assegnazione sulla bacheca degli agenti
- Mobile: padding grezzo dell'altezza della tastiera, ActionSheet sostituisce gli avvisi di overflow

## [0.5.8] - 2026-09-23

### Novità

- `install.sh` — programma di installazione del server basato su git (`--version`, `--dir`, `--port`, `--systemd`)
- Tarball del server standalone e locale pubblicati sui tag `v*`

### Correzioni

- La tastiera mobile copriva il composer e i contenuti sotto la barra di navigazione di sistema (Android)

## [0.5.7] - 2026-09-23

### Correzioni

- Build CI desktop (flag della piattaforma del bundle, rebuild nativi, timeout degli smoke test)
- Messaggi dell'assistente in streaming duplicati nelle trascrizioni della chat

## [0.5.6] - 2026-09-23

### Correzioni

- CI desktop: build macOS non firmate quando mancano i secret Apple, staging dei pacchetti con scope su Windows

## [0.5.5] - 2026-09-23

### Novità

- **App desktop (anteprima)** — launcher Electron per server locali o remoti, backend integrato, aggiornamento automatico, build dmg/NSIS/AppImage/deb
- **App mobile (anteprima)** — companion Expo/React Native: sessioni, chat con selettore di modello e comandi slash, terminale, file, WebView delle impostazioni
- Indicatore di non letto sulle sessioni con output non visualizzato; collegamento bacheca attività ↔ sessione
- Isole KaTeX e Mermaid nella chat

### Correzioni

- Target tattili e layout su viewport mobili; rifinitura della palette dei comandi, della kanban e delle impostazioni

## [0.5.4] - 2026-09-21

### Novità

- Pulsante di riavvio del server con overlay di avanzamento a schermo intero (Impostazioni → Informazioni)
- Changelog localizzato delle release GitHub in Impostazioni → Informazioni
- Numero di sessioni attive nel titolo della scheda del browser
- Scala dell'asse Y e tooltip al passaggio del mouse sul grafico dell'andamento dell'utilizzo

### Correzioni

- Il salvataggio automatico delle impostazioni si attivava all'apertura delle finestre modali; layout compatto della chat nelle divisioni multi-riga

## [0.5.3] - 2026-09-21

### Correzioni

- La finestra di aggiornamento disponibile era nascosta dietro la barra laterale (correzione del portal)

## [0.5.2] - 2026-09-21

### Correzioni

- Il controllo degli aggiornamenti viene instradato attraverso il server

## [0.5.1] - 2026-09-21

### Novità

- Badge di aggiornamento disponibile con aggiornamento automatico in un clic
- Voce di lettura ad alta voce per sessione; selettore della voce spostato nelle impostazioni Aspetto

### Correzioni

- Il banner della chat mostra il provider effettivo della sessione

## [0.5.0] - 2026-09-21

Prima release standalone di **ddagent** — un'interfaccia web e mobile self-hosted per agenti di codifica AI.

### In evidenza

- **Sessioni multi-agente** — Claude Code, Codex, Cursor CLI, OpenCode e Devin fianco a fianco, con streaming live e ripresa
- **Layout del workspace** — riquadri divisi per chat, terminale, browser e file
- **Esplora file ed editor** — sfoglia e modifica il workspace nell'interfaccia
- **Pannello Git** — staging, commit, diff, cambio di branch, gestione dei worktree
- **Bacheca attività** — kanban alimentato da TaskMaster; genera attività eseguibili dai PRD
- **Gestione MCP** — aggiungi e sincronizza i server MCP tra gli agenti
- **Browser delle skill** — scopri e gestisci le skill degli agenti
- **Quota e utilizzo** — utilizzo di token per agente e limiti di abbonamento
- **Browser-use** — sessioni del browser guidate dall'agente per ricerca e test
- **Notifiche e TTS** — avvisi e risposte lette ad alta voce
- **Sandbox Docker** — esecuzioni sperimentali di agenti isolate da hypervisor
- **Companion desktop** — app Electron opzionale per macOS/Windows
- **i18n** — 11 lingue dell'interfaccia, temi scuro e chiaro

### CLI

- `ddagent` / `ddagent start` — avvia il server
- `ddagent status` — mostra la configurazione e le posizioni dei dati
- `ddagent version` / `ddagent help`
