<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>Un'unica UI per tutti i tuoi agenti di coding AI.</strong><br>
  Interfaccia web &amp; mobile self-hosted per Claude Code, Codex, Cursor CLI, OpenCode e Devin — sessioni, file, git, terminali e task in un unico posto.</p>

  <p>
    <img src="https://img.shields.io/badge/version-0.5.9-0066FF" alt="versione">
    <img src="https://img.shields.io/badge/license-AGPL--3.0-blue" alt="licenza: AGPL-3.0">
    <img src="https://img.shields.io/badge/node-%E2%89%A522-339933" alt="node >= 22">
    <img src="https://img.shields.io/badge/self--hosted-yes-success" alt="self-hosted">
  </p>

  <p>
    <a href="#installazione">Installazione</a> ·
    <a href="https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md">Contribuire</a> ·
    <a href="https://github.com/Zakwei/ddagent/issues">Segnalazioni di bug</a>
  </p>

  <p>
    <a href="../../README.md">English</a> ·
    <a href="README.pl.md">Polski</a> ·
    <a href="README.de.md">Deutsch</a> ·
    <a href="README.es.md">Español</a> ·
    <a href="README.fr.md">Français</a> ·
    <strong>Italiano</strong> ·
    <a href="README.ja.md">日本語</a> ·
    <a href="README.ko.md">한국어</a> ·
    <a href="README.ru.md">Русский</a> ·
    <a href="README.tr.md">Türkçe</a> ·
    <a href="README.zh-CN.md">简体中文</a> ·
    <a href="README.zh-TW.md">繁體中文</a>
  </p>
</div>

<p align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/desktop-main.png" alt="vista chat di ddagent" width="78%">&nbsp;
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/mobile-chat.png" alt="vista mobile di ddagent" width="20%">
</p>

---

## Cos'è ddagent?

ddagent gira sulla tua macchina o sul tuo VPS e ti offre un'interfaccia web curata sopra gli agenti di coding che già usi. Scopre le loro sessioni direttamente dal disco — la tua cronologia `~/.claude`, Codex e Devin compare all'istante, niente viene duplicato o sincronizzato verso terze parti.

Aprilo da qualsiasi browser nella tua rete, o dal telefono. La tua macchina, i tuoi agenti, i tuoi dati.

## Funzionalità

- **Sessioni multi-agent** — avvia e riprendi sessioni di Claude Code, Codex, Cursor CLI, OpenCode e Devin fianco a fianco, con streaming live via WebSocket
- **Pannelli divisi** — pannelli chat, terminale, browser e file in un unico workspace
- **Esploratore & editor di file** — naviga il workspace, modifica il codice con CodeMirror
- **Pannello Git** — stage, commit, diff e cambio di branch senza lasciare la UI
- **Shell integrata** — terminale completo per workspace, più una scheda shell standalone
- **Bacheca dei task** — vista kanban alimentata da TaskMaster; trasforma i PRD in task eseguibili
- **Gestione MCP** — aggiungi, modifica e sincronizza i server MCP tra gli agenti
- **Browser delle skill** — gestisci le skill degli agenti dalla UI
- **Quota & utilizzo** — uso dei token e limiti dell'abbonamento per agente, a colpo d'occhio
- **Browser-use** — sessioni di browser guidate dall'agente per ricerca e test
- **Worktree** — crea worktree git isolati per task, con script setup/run per worktree e un'anteprima autenticata del dev-server live
- **Approvazioni remote** — approva i permessi dei tool da Telegram, Discord o dall'app mobile
- **Input vocale** — detta i prompt tramite un endpoint STT compatibile con Whisper
- **Broadcast agli agenti & memoria condivisa** — invia un messaggio a tutti gli agenti contemporaneamente e mantieni note per progetto che tutti leggono
- **Cambio multi-account** — account con nome per provider con override di env per sessione
- **Scheduler** — esecuzioni degli agenti pilotate da cron, con keep-awake su web/desktop
- **Collaborazione di team** — ruoli (owner/member/viewer), link di invito, assegnatari, commenti, presenza e feed di attività sulla bacheca ([documentazione](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md))
- **Server MCP** — permetti a client MCP esterni (Claude Desktop, OpenClaw) di creare task e inviare messaggi alle sessioni ([documentazione](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Notifiche & TTS** — ricevi un ping (o lettura ad alta voce) quando una sessione ha bisogno di te
- **Sandbox Docker** — esegui gli agenti in ambienti isolati da microVM ([documentazione](https://github.com/Zakwei/ddagent/blob/main/docker/README.md))
- **Companion desktop** — app Electron opzionale; **12 lingue**, temi scuro e chiaro

## Agenti supportati

| Agente | Come si connette |
|---|---|
| **Claude Code** | Scopre automaticamente le sessioni `~/.claude`; sincronizzazione MCP & impostazioni con il CLI nativo |
| **Codex** | Sessioni CLI locali e trascrizioni |
| **Cursor CLI** | Sessioni CLI locali |
| **OpenCode** | Sessioni locali e posizioni delle skill |
| **Devin** | Sessioni CLI/ACP tramite sync locale |

Porti le tue sottoscrizioni — ddagent fornisce l'ambiente, non l'IA.

## Installazione

Richiede **Node.js 22+** sulla macchina che esegue il server. Il server serve la UI web e l'API REST/WS a cui le app desktop e mobile si connettono in remoto.

### Server self-hosted — script di installazione

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

Clona l'ultimo tag di release in `~/.ddagent/app`, compila la UI web + backend e lascia un launcher `start.sh`. Opzioni: `--version vX.Y.Z` · `--dir <path>` · `--port <port>` · `--systemd` (installa e abilita una unit systemd utente). Rilancia con `--version` per aggiornare sul posto.

Poi:

```bash
~/.ddagent/app/start.sh        # → http://localhost:3001
```

### Server self-hosted — tarball precompilato

Nessun passo di build — scarica `ddagent-server-<version>-<os>-<arch>.tar.gz` da [Releases](https://github.com/Zakwei/ddagent/releases), decomprimi, esegui:

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh           # start.bat on Windows
```

### App desktop

Scarica l'installer per il tuo OS da [Releases](https://github.com/Zakwei/ddagent/releases): `.dmg` (macOS) · `.exe` (Windows) · `.AppImage` / `.deb` (Linux).

Funziona standalone — il server è integrato, nient'altro da installare — oppure in modalità remota contro l'URL di un server self-hosted. Aggiornamenti automatici tramite i feed `latest*.yml` del release.

### App mobile (anteprima)

Scarica `ddagent-mobile-<version>.apk` da [Releases](https://github.com/Zakwei/ddagent/releases) e installala sul tuo dispositivo Android; l'app si connette all'URL di un server self-hosted.

### Da sorgente

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run dev        # server :3001 + Vite :5173 with HMR
```

### Sandbox Docker (sperimentale)

```bash
ddagent sandbox ~/my-project
```

Esegue l'agente in una sandbox isolata da hypervisor. Vedi [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md).

## CLI

In un checkout da sorgente o da `install.sh`, `ddagent` sotto significa `node dist-server/server/modules/cli/cli.js` (ha uno shebang, quindi funziona anche `./dist-server/server/modules/cli/cli.js`).

| Comando | Descrizione |
|---|---|
| `ddagent` | Avvia il server |
| `ddagent start` | Avvia il server |
| `ddagent status` | Mostra le posizioni di config e dati |
| `ddagent version` | Stampa la versione |
| `ddagent help` | Mostra l'aiuto |

## Configurazione

Tutte le impostazioni vivono in un unico file env — esegui `ddagent status` per vedere da dove viene letto il tuo.

| Variabile | Predefinito | Descrizione |
|---|---|---|
| `SERVER_PORT` | `3001` | Porta API + WebSocket |
| `VITE_PORT` | `5173` | Porta del dev-server |
| `HOST` | `0.0.0.0` | Indirizzo di bind (`127.0.0.1` solo per localhost) |
| `DATABASE_PATH` | auto | Posizione del database di autenticazione |
| `CONTEXT_WINDOW` | `160000` | Token max per sessione |
| `CLAUDE_CLI_PATH` | `claude` | Percorso personalizzato del binario Claude CLI |

Vedi [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example) per la lista completa.

## Sviluppo

```bash
npm run dev            # dev mode (server :3001 + vite :5173)
npm run build          # client + server production build
npm run test:client    # frontend tests
npm test               # backend tests
npm run typecheck      # TypeScript check
```

Il codice backend segue l'architettura a moduli descritta in `server/modules/` — vedi `server/modules/providers/README.md` per gli internals dei provider.

## Contribuire

I bugfix sono benvenuti — vedi [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md).

---

<div align="center">
  <sub>Costruito per la community di Claude Code, Cursor, Codex, OpenCode e Devin.</sub>
</div>
