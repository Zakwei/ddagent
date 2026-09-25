<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>Une seule UI pour tous vos agents de codage IA.</strong><br>
  Interface web &amp; mobile auto-hébergée pour Claude Code, Codex, Cursor CLI, OpenCode et Devin — sessions, fichiers, git, terminaux et tâches au même endroit.</p>

  <p>
    <img src="https://img.shields.io/badge/version-0.5.9-0066FF" alt="version">
    <img src="https://img.shields.io/badge/license-AGPL--3.0-blue" alt="licence : AGPL-3.0">
    <img src="https://img.shields.io/badge/node-%E2%89%A522-339933" alt="node >= 22">
    <img src="https://img.shields.io/badge/self--hosted-yes-success" alt="self-hosted">
  </p>

  <p>
    <a href="#installation">Installation</a> ·
    <a href="https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md">Contribuer</a> ·
    <a href="https://github.com/Zakwei/ddagent/issues">Rapports de bugs</a>
  </p>

  <p>
    <a href="../../README.md">English</a> ·
    <a href="README.pl.md">Polski</a> ·
    <a href="README.de.md">Deutsch</a> ·
    <a href="README.es.md">Español</a> ·
    <strong>Français</strong> ·
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
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/desktop-main.png" alt="vue de chat ddagent" width="78%">&nbsp;
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/mobile-chat.png" alt="vue mobile ddagent" width="20%">
</p>

---

## Qu'est-ce que ddagent ?

ddagent tourne sur votre propre machine ou VPS et vous offre une interface web soignée par-dessus les agents de codage que vous utilisez déjà. Il découvre leurs sessions directement sur le disque — votre historique `~/.claude`, Codex et Devin apparaît instantanément, rien n'est dupliqué ni synchronisé vers un tiers.

Ouvrez-le depuis n'importe quel navigateur de votre réseau, ou depuis votre téléphone. Votre machine, vos agents, vos données.

## Fonctionnalités

- **Sessions multi-agents** — lancez et reprenez des sessions Claude Code, Codex, Cursor CLI, OpenCode et Devin côte à côte, avec streaming en direct via WebSocket
- **Panneaux divisés** — panneaux chat, terminal, navigateur et fichiers dans un seul workspace
- **Explorateur & éditeur de fichiers** — parcourez le workspace, éditez le code avec CodeMirror
- **Panneau Git** — stage, commit, diff et changement de branche sans quitter l'UI
- **Shell intégré** — terminal complet par workspace, plus un onglet shell autonome
- **Tableau de tâches** — vue kanban propulsée par TaskMaster ; transformez des PRDs en tâches exécutables
- **Gestion MCP** — ajoutez, modifiez et synchronisez les serveurs MCP entre agents
- **Navigateur de skills** — gérez les skills des agents depuis l'UI
- **Quota & utilisation** — consommation de tokens et limites d'abonnement par agent, en un coup d'œil
- **Browser-use** — sessions de navigateur pilotées par l'agent pour la recherche et les tests
- **Worktrees** — créez des worktrees git isolés par tâche, avec des scripts setup/run par worktree et un aperçu authentifié du dev-server en direct
- **Approbations à distance** — approuvez les permissions d'outils depuis Telegram, Discord ou l'app mobile
- **Saisie vocale** — dictez vos prompts via un endpoint STT compatible Whisper
- **Broadcast agents & mémoire partagée** — envoyez un message à tous les agents à la fois et gardez des notes par projet qu'ils lisent tous
- **Changement multi-comptes** — comptes nommés par provider avec des overrides d'env par session
- **Planificateur** — exécutions d'agents pilotées par cron, avec keep-awake sur web/desktop
- **Collaboration en équipe** — rôles (owner/member/viewer), liens d'invitation, assignés, commentaires, présence et flux d'activité sur le tableau ([documentation](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md))
- **Serveur MCP** — laissez des clients MCP externes (Claude Desktop, OpenClaw) créer des tâches et envoyer des messages aux sessions ([documentation](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Notifications & TTS** — soyez alerté (ou lisez à voix haute) quand une session a besoin de vous
- **Sandboxes Docker** — exécutez les agents dans des environnements isolés par microVM ([documentation](https://github.com/Zakwei/ddagent/blob/main/docker/README.md))
- **Compagnon desktop** — app Electron optionnelle ; **12 langues**, thèmes sombre et clair

## Agents pris en charge

| Agent | Comment il se connecte |
|---|---|
| **Claude Code** | Découvre automatiquement les sessions `~/.claude` ; synchronisation MCP & réglages avec le CLI natif |
| **Codex** | Sessions CLI locales et transcriptions |
| **Cursor CLI** | Sessions CLI locales |
| **OpenCode** | Sessions locales et emplacements des skills |
| **Devin** | Sessions CLI/ACP via synchronisation locale |

Vous apportez vos propres abonnements — ddagent fournit l'environnement, pas l'IA.

## Installation

Nécessite **Node.js 22+** sur la machine qui exécute le serveur. Le serveur sert l'interface web et l'API REST/WS à laquelle les apps desktop et mobile se connectent à distance.

### Serveur auto-hébergé — script d'installation

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

Clone le dernier tag de release dans `~/.ddagent/app`, compile l'UI web + le backend et laisse un lanceur `start.sh`. Options : `--version vX.Y.Z` · `--dir <path>` · `--port <port>` · `--systemd` (installe et active une unité systemd utilisateur). Relancez avec `--version` pour mettre à jour sur place.

Ensuite :

```bash
~/.ddagent/app/start.sh        # → http://localhost:3001
```

### Serveur auto-hébergé — tarball précompilé

Pas d'étape de build — téléchargez `ddagent-server-<version>-<os>-<arch>.tar.gz` depuis [Releases](https://github.com/Zakwei/ddagent/releases), décompressez, lancez :

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh           # start.bat on Windows
```

### App desktop

Téléchargez l'installateur pour votre OS depuis [Releases](https://github.com/Zakwei/ddagent/releases) : `.dmg` (macOS) · `.exe` (Windows) · `.AppImage` / `.deb` (Linux).

Fonctionne en standalone — le serveur est embarqué, rien d'autre à installer — ou en mode distant contre l'URL d'un serveur auto-hébergé. Mises à jour automatiques via les feeds `latest*.yml` du release.

### App mobile (aperçu)

Téléchargez `ddagent-mobile-<version>.apk` depuis [Releases](https://github.com/Zakwei/ddagent/releases) et installez-la sur votre appareil Android ; l'app se connecte à l'URL d'un serveur auto-hébergé.

### Depuis les sources

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run dev        # server :3001 + Vite :5173 with HMR
```

### Sandbox Docker (expérimental)

```bash
ddagent sandbox ~/my-project
```

Exécute l'agent dans un sandbox isolé par hyperviseur. Voir [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md).

## CLI

Dans un checkout source ou `install.sh`, `ddagent` ci-dessous désigne `node dist-server/server/modules/cli/cli.js` (il a un shebang, donc `./dist-server/server/modules/cli/cli.js` fonctionne aussi).

| Commande | Description |
|---|---|
| `ddagent` | Démarre le serveur |
| `ddagent start` | Démarre le serveur |
| `ddagent status` | Affiche les emplacements de config et de données |
| `ddagent version` | Affiche la version |
| `ddagent help` | Affiche l'aide |

## Configuration

Tous les réglages vivent dans un seul fichier env — lancez `ddagent status` pour voir d'où le vôtre est lu.

| Variable | Défaut | Description |
|---|---|---|
| `SERVER_PORT` | `3001` | Port API + WebSocket |
| `VITE_PORT` | `5173` | Port du dev-server |
| `HOST` | `0.0.0.0` | Adresse de bind (`127.0.0.1` pour localhost uniquement) |
| `DATABASE_PATH` | auto | Emplacement de la base d'authentification |
| `CONTEXT_WINDOW` | `160000` | Tokens max par session |
| `CLAUDE_CLI_PATH` | `claude` | Chemin personnalisé du binaire Claude CLI |

Voir [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example) pour la liste complète.

## Développement

```bash
npm run dev            # dev mode (server :3001 + vite :5173)
npm run build          # client + server production build
npm run test:client    # frontend tests
npm test               # backend tests
npm run typecheck      # TypeScript check
```

Le code backend suit l'architecture modulaire décrite dans `server/modules/` — voir `server/modules/providers/README.md` pour les internals des providers.

## Contribuer

Les corrections de bugs sont les bienvenues — voir [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md).

---

<div align="center">
  <sub>Conçu pour la communauté Claude Code, Cursor, Codex, OpenCode et Devin.</sub>
</div>
