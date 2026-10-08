<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="DDAgent" width="72" height="72">
  <h1>DDAgent</h1>
  <p><strong>Un'unica UI per tutti i tuoi agenti di coding AI.</strong><br>
  Server self-hosted e client Flutter (web, Linux, Windows &amp; Android) per Claude Code, Codex, Cursor CLI, OpenCode, Devin, Command Code e Antigravity — sessioni, file, git, terminali e task in un unico posto.</p>

  <p>
    <img src="https://img.shields.io/github/v/release/Zakwei/ddagent?label=versione&amp;color=0066FF" alt="versione">
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
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/desktop-main.png" alt="vista chat di DDAgent" width="78%">&nbsp;
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/mobile-chat.png" alt="vista mobile di DDAgent" width="20%">
</p>

<table>
  <tr>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/sessions.png" alt="Sessioni recenti di Claude Code e Codex"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/kanban-board.png" alt="Bacheca kanban che guida le esecuzioni degli agenti"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/git-panel.png" alt="Pannello Git con staging per hunk"></td>
  </tr>
  <tr>
    <td align="center"><sub>Le sessioni di tutti gli agenti in un'unica lista</sub></td>
    <td align="center"><sub>Bacheca kanban — le schede avviano le esecuzioni degli agenti</sub></td>
    <td align="center"><sub>Pannello Git — diff, staging degli hunk, commit</sub></td>
  </tr>
</table>

---

## Cos'è DDAgent?

DDAgent gira sulla tua macchina o sul tuo VPS e offre un'unica UI curata sopra gli agenti di coding che già usi. Il server legge le sessioni di ogni agente direttamente dalla sua cronologia su disco (`~/.claude`, `~/.codex`, `~/.cursor`, OpenCode, Devin, …), quindi le conversazioni esistenti compaiono senza dover importare nulla. Solo i metadati delle sessioni vengono indicizzati in locale; nulla viene inviato a terze parti.

Collegati dal client Flutter su desktop, telefono o browser. La tua macchina, i tuoi agenti, i tuoi dati.

## Funzionalità

- **Sessioni multi-agente** — avvia e riprendi fianco a fianco sessioni di sette CLI di agenti, con streaming in tempo reale via WebSocket
- **Orchestratore automatico** — le sessioni "Auto" assegnano ogni task a un agente e a un modello adatti, tenendo conto della quota di abbonamento residua, e delegano il lavoro a sessioni figlie
- **Workspace diviso** — fino a sei pannelli (chat, terminale, browser, anteprima, editor, git, note) in un'unica finestra
- **Esplora file & editor** — sfoglia il workspace e modifica il codice nell'editor integrato
- **Pannello Git** — metti in stage file o singoli hunk, fai commit (con messaggi generati dall'AI), consulta i diff, cambia branch, esegui pull/push e ripristina i checkpoint senza uscire dalla UI
- **Terminale integrato** — una shell completa per ogni workspace
- **Bacheca kanban** — sposta una scheda per avviare un agente su di essa (facoltativamente nel suo worktree); l'agente riferisce quando ha finito
- **TaskMaster** — trasforma i PRD in task e seguili su una bacheca dei task
- **Coda dei messaggi** — i messaggi inviati mentre un agente è occupato vengono accodati sul server e sopravvivono ai refresh e ai cambi di dispositivo
- **Gestione MCP** — aggiungi, modifica e sincronizza i server MCP tra gli agenti
- **Knowledge base** — un'unica memoria locale e ricercabile per tutti gli agenti: regole, skill, memorie e informazioni personali, recuperate su richiesta via MCP ([documentazione](KNOWLEDGE.it.md))
- **Skill & regole** — gestisci le skill degli agenti e le regole condivise da un unico posto
- **Quota & utilizzo** — consumo di token e limiti di abbonamento per agente, a colpo d'occhio
- **Browser-use** — sessioni browser pilotate dall'agente per ricerca e test, con un pannello browser dal vivo
- **Worktree** — crea worktree git isolati per ogni task, con script setup/run per worktree e un'anteprima autenticata del dev server in tempo reale
- **Approvazioni da remoto** — approva i permessi degli strumenti da Telegram, Discord o dall'app Android ([documentazione](https://github.com/Zakwei/ddagent/blob/main/docs/remote-approvals.md))
- **Input vocale** — detta i prompt tramite un endpoint di speech-to-text compatibile con Whisper
- **Broadcast agli agenti & memoria condivisa** — invia un messaggio a tutti gli agenti contemporaneamente e tieni note per progetto che tutti leggono
- **Cambio multi-account** — account con nome per ogni provider, con override delle variabili d'ambiente per sessione
- **Scheduler** — esecuzioni di agenti non presidiate pilotate da cron, con l'opzione di tenere sveglio il dispositivo mentre le esecuzioni sono attive
- **Collaborazione in team** — ruoli (owner/member/viewer), link di invito, assegnatari, commenti, presenza e feed delle attività sulla bacheca ([documentazione](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md))
- **Server MCP** — consenti a client MCP esterni (Claude Desktop, OpenClaw) di elencare le sessioni, creare task e inviare messaggi alle sessioni ([documentazione](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Notifiche & TTS** — notifiche push, Telegram e Discord quando una sessione ha bisogno di te, più la lettura ad alta voce delle risposte, facoltativa
- **Palette dei comandi** — `Ctrl/Cmd+Shift+K` per cercare tra sessioni e messaggi, saltare a qualsiasi pagina o eseguire azioni rapide
- **Sandbox Docker** — esegui gli agenti in Docker Sandbox isolate tramite microVM ([documentazione](https://github.com/Zakwei/ddagent/blob/main/docker/README.md))
- **Client Flutter** — un'unica codebase per web, Linux, Windows e Android; **12 lingue**, temi scuro e chiaro

## Agenti supportati

| Agente | Come si collega |
|---|---|
| **Claude Code** | Claude Agent SDK; rileva automaticamente le sessioni in `~/.claude`; MCP e impostazioni sincronizzati con la CLI nativa |
| **Codex** | Codex SDK; sessioni locali e trascrizioni da `~/.codex` |
| **Cursor CLI** | `cursor-agent` con output JSON in streaming; chat locali da `~/.cursor` |
| **OpenCode** | `opencode serve`; sessioni locali dal database di OpenCode |
| **Devin** | `devin acp` (Agent Client Protocol); trascrizioni locali |
| **Command Code** | `command-code acp` (Agent Client Protocol); trascrizioni da `~/.commandcode` |
| **Antigravity** | CLI `agy` in modalità headless; conversazioni indicizzate da `~/.gemini/antigravity-cli` |

Le CLI degli agenti devono essere installate e autenticate sulla macchina server. Gli abbonamenti sono i tuoi — DDAgent fornisce l'ambiente, non l'AI.

## Installazione

DDAgent è composto da due parti: il **server**, che gira accanto ai tuoi agenti ed espone un'API REST/WebSocket, e il **client**, che vi si collega. Il server richiede **Node.js 22+** (i tarball precompilati richiedono Node.js 22.x, perché i loro moduli nativi sono compilati per questa versione).

### Server — script di installazione

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

Richiede `git`, Node.js 22+ e `npm`. Lo script clona un tag di release in `~/.ddagent/app`, installa le dipendenze, compila il backend e crea un launcher `start.sh`. Passa le opzioni dopo `bash -s --`:

| Opzione | Descrizione |
|---|---|
| `--version vX.Y.Z` | Installa una release specifica (predefinito: l'ultima) |
| `--dir <path>` | Directory di installazione (predefinito: `~/.ddagent/app`) |
| `--systemd` | Installa e abilita un servizio utente systemd chiamato `ddagent` |
| `--port <port>` | Porta del servizio systemd (predefinito: `3001`) |

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash -s -- --systemd --port 3001
```

Poi avvia il server:

```bash
~/.ddagent/app/start.sh        # API on http://<host>:3001 (set SERVER_PORT to change)
```

### Server — tarball precompilato

Nessuna fase di build: scarica `ddagent-server-<version>-<os>-<arch>.tar.gz` (`linux-x64`, `mac-arm64` o `win-x64`) da [Releases](https://github.com/Zakwei/ddagent/releases), estrailo ed esegui il launcher:

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh             # start.bat on Windows
```

Ogni tarball è accompagnato da un checksum `.sha256`. Le impostazioni vanno in un file `.env` facoltativo accanto a `start.sh`.

### Client

Scarica un client precompilato da [Releases](https://github.com/Zakwei/ddagent/releases):

| Piattaforma | File |
|---|---|
| Windows x64 | `ddagent-flutter-windows-x64-<tag>-setup.exe` (installer) o `.zip` (portable) |
| Linux x64 | `ddagent-flutter-linux-x64-<tag>.deb` o `.tar.gz` |
| Android | `ddagent-flutter-android-<tag>.apk` |
| Web | `ddagent-flutter-web-<tag>.zip` |

Al primo avvio, inserisci l'URL del tuo server (ad esempio `http://my-vps:3001`) e crea il primo account. Su Windows e Linux x64 il client desktop può anche scaricare ed eseguire un server locale per te ("Questo dispositivo" nella schermata di connessione).

La build web non ha una schermata di login e chiama l'API sulla propria origine, quindi deve essere servita dietro un reverse proxy davanti a un server in modalità piattaforma single-user (`VITE_IS_PLATFORM=true`, che disattiva l'autenticazione). In un checkout dei sorgenti, `node scripts/serve-flutter-web.cjs` serve `flutter/build/web` sulla porta 8085 e inoltra l'API e i WebSocket al server su `FLUTTER_BACKEND_PORT` (predefinito `10087`). Esponi questa configurazione solo su una rete fidata.

Per compilare il client da solo:

```bash
cd flutter
flutter pub get
flutter build linux --release      # or: windows, apk, web
```

### Aggiornamento

Nel client, **Impostazioni → Informazioni → Aggiornamenti** ha un pulsante separato per ogni parte:

| Parte | Come si aggiorna |
|---|---|
| **Server** | Le installazioni tramite script di installazione o git passano all'ultima release; le installazioni da tarball scaricano il tarball successivo, lo verificano (`.sha256`) e lo installano al riavvio, con rollback automatico se il server non si avvia. `start.sh` / `start.bat` riavviano il server da soli — systemd non serve. Il server locale di un client desktop ("Questo dispositivo") viene reinstallato dall'app. |
| **Interfaccia web** | Viene sostituita con lo zip web della release quando è il server a ospitarla (`DDAGENT_WEB_DIR`, oppure `flutter/build/web` servito da `scripts/serve-flutter-web.cjs`); viene inoltre aggiornata a ogni aggiornamento del server. |
| **Questa app** | Android installa il nuovo APK; Windows e Linux scaricano la nuova build in background e la installano quando chiudi l'app. |

I tarball delle release sono compilati per Node.js 22 — il server rifiuta un tarball compilato per una versione major diversa di Node.js. I server alla 0.8.12 o precedenti (script di installazione o tarball) vanno aggiornati a 0.8.13 a mano una sola volta — riesegui `install.sh --version v0.8.13` o estrai il nuovo tarball sopra quello vecchio — e da lì in poi dall'interfaccia.

### Da sorgente

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run build && node dist-server/server/index.js   # API on http://localhost:3001
```

### Sandbox Docker (sperimentale)

```bash
ddagent sandbox ~/my-project
```

Esegue DDAgent e un agente (Claude Code o Codex) all'interno di una Docker Sandbox isolata tramite microVM. Richiede la CLI `sbx` — vedi [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md).

## CLI

In un checkout dei sorgenti o di `install.sh`, `ddagent` qui sotto indica `node dist-server/server/modules/cli/cli.js` (ha uno shebang, quindi funziona anche `./dist-server/server/modules/cli/cli.js`).

| Comando | Descrizione |
|---|---|
| `ddagent` / `ddagent start` | Avvia il server (comando predefinito) |
| `ddagent status` | Mostra la versione e i percorsi del file di configurazione, del database e dei progetti Claude |
| `ddagent sandbox <workspace>` | Crea e avvia una sandbox Docker; `ddagent sandbox help` elenca `ls`, `start`, `stop`, `rm`, `logs` |
| `ddagent browser-use-mcp` | Esegue il server MCP browser-use via stdio |
| `ddagent version` | Stampa la versione |
| `ddagent help` | Mostra l'aiuto |

| Opzione | Descrizione |
|---|---|
| `-p, --port <port>` | Porta del server (sovrascrive `SERVER_PORT`) |
| `--database-path <path>` | Percorso personalizzato del database (sovrascrive `DATABASE_PATH`) |

## Configurazione

Il server legge un file `.env` facoltativo dalla propria directory di installazione (accanto a `start.sh`); le variabili d'ambiente reali hanno la precedenza. Esegui `ddagent status` per vedere quale file viene usato.

| Variabile | Predefinito | Descrizione |
|---|---|---|
| `SERVER_PORT` | `3001` | Porta API + WebSocket (`PORT` è accettato come alias legacy) |
| `HOST` | `0.0.0.0` | Indirizzo di bind (`127.0.0.1` per il solo localhost) |
| `DATABASE_PATH` | `~/.ddagent/auth.db` | Database SQLite (utenti, impostazioni, token) |
| `WORKSPACES_ROOT` | directory home | I progetti devono trovarsi all'interno di questa directory |
| `JWT_SECRET` | generato automaticamente | Segreto per firmare i token di login (generato e salvato per ogni installazione) |
| `API_KEY` | non impostato | Se impostato, le richieste API devono inviarlo nell'header `x-api-key` |
| `CLAUDE_CLI_PATH` | `claude` | Binario personalizzato della CLI di Claude Code |
| `CONTEXT_WINDOW` | `200000` | Finestra di contesto di riserva per Claude, usata finché l'SDK non comunica la finestra reale del modello |
| `STT_ENDPOINT_URL` / `STT_API_KEY` / `STT_MODEL` | `https://api.openai.com/v1` / non impostato / `whisper-1` | Speech-to-text per l'input vocale (configurabile anche nelle Impostazioni) |
| `VITE_IS_PLATFORM` | `false` | Modalità piattaforma single-user: salta l'autenticazione (richiesta dal client web) |

Vedi [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example) per altre opzioni.

## Sviluppo

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

Il codice backend segue l'architettura modulare in `server/modules/`; vedi [`server/modules/providers/README.md`](https://github.com/Zakwei/ddagent/blob/main/server/modules/providers/README.md) per i dettagli interni dei provider.

## Contribuire

Le correzioni di bug sono benvenute — vedi [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md). Per segnalare una vulnerabilità, vedi [SECURITY.md](https://github.com/Zakwei/ddagent/blob/main/SECURITY.md).

---

<div align="center">
  <sub>Creato per la community di Claude Code, Codex, Cursor, OpenCode, Devin, Command Code e Antigravity.</sub>
</div>
