<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>Une seule UI pour tous vos agents de codage IA.</strong><br>
  Serveur auto-hébergé et client Flutter (web, Linux, Windows &amp; Android) pour Claude Code, Codex, Cursor CLI, OpenCode, Devin, Command Code et Antigravity — sessions, fichiers, git, terminaux et tâches au même endroit.</p>

  <p>
    <img src="https://img.shields.io/github/v/release/Zakwei/ddagent?label=version&amp;color=0066FF" alt="version">
    <img src="https://img.shields.io/badge/license-AGPL--3.0-blue" alt="licence : AGPL-3.0">
    <img src="https://img.shields.io/badge/node-%E2%89%A522-339933" alt="node >= 22">
    <img src="https://img.shields.io/badge/self--hosted-yes-success" alt="auto-hébergé">
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

<table>
  <tr>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/sessions.png" alt="Sessions récentes de Claude Code et Codex"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/kanban-board.png" alt="Tableau kanban qui pilote les exécutions d'agents"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/git-panel.png" alt="Panneau Git avec staging par hunk"></td>
  </tr>
  <tr>
    <td align="center"><sub>Les sessions de tous les agents dans une seule liste</sub></td>
    <td align="center"><sub>Tableau kanban — les cartes lancent des exécutions d'agents</sub></td>
    <td align="center"><sub>Panneau Git — diff, staging de hunks, commit</sub></td>
  </tr>
</table>

---

## Qu'est-ce que ddagent ?

ddagent tourne sur votre propre machine ou VPS et place une UI soignée au-dessus des agents de codage que vous utilisez déjà. Le serveur lit les sessions de chaque agent directement depuis son propre historique sur disque (`~/.claude`, `~/.codex`, `~/.cursor`, OpenCode, Devin, …) : vos conversations existantes apparaissent sans rien importer. Seules les métadonnées des sessions sont indexées localement ; rien n'est envoyé à un tiers.

Connectez-vous depuis le client Flutter sur votre ordinateur, votre téléphone ou votre navigateur. Votre machine, vos agents, vos données.

## Fonctionnalités

- **Sessions multi-agents** — lancez et reprenez côte à côte des sessions de sept CLI d'agents, avec streaming en direct via WebSocket
- **Orchestrateur automatique** — les sessions « Auto » confient chaque tâche à un agent et à un modèle adaptés, en tenant compte du quota d'abonnement restant, et délèguent le travail à des sessions enfants
- **Espace de travail divisé** — jusqu'à six panneaux (chat, terminal, navigateur, aperçu, éditeur, git, notes) dans une seule fenêtre
- **Explorateur & éditeur de fichiers** — parcourez le workspace et éditez le code dans l'éditeur intégré
- **Panneau Git** — stagez des fichiers ou des hunks individuels, commitez (avec des messages générés par l'IA), consultez les diffs, changez de branche, faites pull/push et restaurez des checkpoints sans quitter l'UI
- **Terminal intégré** — un shell complet par workspace
- **Tableau kanban** — déplacez une carte pour lancer un agent dessus (éventuellement dans son propre worktree) ; l'agent rend compte une fois le travail terminé
- **TaskMaster** — transformez des PRD en tâches et suivez-les sur un tableau de tâches
- **File de messages** — les messages envoyés pendant qu'un agent est occupé sont mis en file d'attente sur le serveur et survivent aux rafraîchissements comme aux changements d'appareil
- **Gestion MCP** — ajoutez, modifiez et synchronisez les serveurs MCP entre agents
- **Base de connaissances** — une mémoire locale et interrogeable pour tous les agents : règles, skills, mémoires et informations personnelles, récupérées à la demande via MCP ([documentation](KNOWLEDGE.fr.md))
- **Skills & règles** — gérez les skills des agents et les règles partagées depuis un seul endroit
- **Quota & utilisation** — consommation de tokens et limites d'abonnement par agent, en un coup d'œil
- **Browser-use** — sessions de navigateur pilotées par l'agent pour la recherche et les tests, avec un panneau de navigateur en direct
- **Worktrees** — créez des worktrees git isolés par tâche, avec des scripts setup/run par worktree et un aperçu authentifié du dev-server en direct
- **Approbations à distance** — approuvez les permissions d'outils depuis Telegram, Discord ou l'app Android ([documentation](https://github.com/Zakwei/ddagent/blob/main/docs/remote-approvals.md))
- **Saisie vocale** — dictez vos prompts via un endpoint de reconnaissance vocale compatible Whisper
- **Broadcast agents & mémoire partagée** — envoyez un message à tous les agents à la fois et gardez des notes par projet qu'ils lisent tous
- **Changement multi-comptes** — comptes nommés par provider avec des overrides de variables d'environnement par session
- **Planificateur** — exécutions d'agents sans surveillance pilotées par cron, avec une option pour garder l'appareil éveillé pendant les exécutions
- **Collaboration en équipe** — rôles (owner/member/viewer), liens d'invitation, assignés, commentaires, présence et flux d'activité sur le tableau ([documentation](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md))
- **Serveur MCP** — permettez à des clients MCP externes (Claude Desktop, OpenClaw) de lister les sessions, de créer des tâches et d'envoyer des messages aux sessions ([documentation](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Notifications & TTS** — notifications push, Telegram et Discord quand une session a besoin de vous, plus la lecture à voix haute des réponses en option
- **Palette de commandes** — `Ctrl/Cmd+Shift+K` pour rechercher dans les sessions et les messages, accéder à n'importe quelle page ou lancer des actions rapides
- **Sandboxes Docker** — exécutez les agents dans des Docker Sandboxes isolées par microVM ([documentation](https://github.com/Zakwei/ddagent/blob/main/docker/README.md))
- **Client Flutter** — une seule base de code pour web, Linux, Windows et Android ; **12 langues**, thèmes sombre et clair

## Agents pris en charge

| Agent | Mode de connexion |
|---|---|
| **Claude Code** | Claude Agent SDK ; découvre automatiquement les sessions `~/.claude` ; synchronisation MCP et réglages avec le CLI natif |
| **Codex** | Codex SDK ; sessions locales et transcriptions depuis `~/.codex` |
| **Cursor CLI** | `cursor-agent` avec sortie JSON en streaming ; chats locaux depuis `~/.cursor` |
| **OpenCode** | `opencode serve` ; sessions locales depuis la base de données OpenCode |
| **Devin** | `devin acp` (Agent Client Protocol) ; transcriptions locales |
| **Command Code** | `command-code acp` (Agent Client Protocol) ; transcriptions depuis `~/.commandcode` |
| **Antigravity** | CLI `agy` en mode headless ; conversations indexées depuis `~/.gemini/antigravity-cli` |

Les CLI des agents doivent être installés et connectés sur la machine serveur. Vous apportez vos propres abonnements — ddagent fournit l'environnement, pas l'IA.

## Installation

ddagent se compose de deux parties : le **serveur**, qui tourne à côté de vos agents et expose une API REST/WebSocket, et le **client**, qui s'y connecte. Le serveur nécessite **Node.js 22+** (les tarballs précompilés exigent Node.js 22.x, car leurs modules natifs sont compilés pour cette version).

### Serveur — script d'installation

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

Nécessite `git`, Node.js 22+ et `npm`. Le script clone un tag de release dans `~/.ddagent/app`, installe les dépendances, compile le backend et génère un lanceur `start.sh`. Passez les options après `bash -s --` :

| Option | Description |
|---|---|
| `--version vX.Y.Z` | Installe une release précise (par défaut : la dernière) |
| `--dir <path>` | Répertoire d'installation (par défaut : `~/.ddagent/app`) |
| `--systemd` | Installe et active un service systemd utilisateur nommé `ddagent` |
| `--port <port>` | Port du service systemd (par défaut : `3001`) |

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash -s -- --systemd --port 3001
```

Pour mettre à jour, relancez le script avec `--version vX.Y.Z` ; il met à jour le checkout sur place. Démarrez ensuite le serveur :

```bash
~/.ddagent/app/start.sh        # API on http://<host>:3001 (set SERVER_PORT to change)
```

### Serveur — tarball précompilé

Aucune étape de build : téléchargez `ddagent-server-<version>-<os>-<arch>.tar.gz` (`linux-x64`, `mac-arm64` ou `win-x64`) depuis [Releases](https://github.com/Zakwei/ddagent/releases), décompressez-le et lancez le lanceur :

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh             # start.bat on Windows
```

Chaque tarball est accompagné d'une somme de contrôle `.sha256`. Les réglages se placent dans un fichier `.env` facultatif à côté de `start.sh`.

### Client

Téléchargez un client précompilé depuis [Releases](https://github.com/Zakwei/ddagent/releases) :

| Plateforme | Fichier |
|---|---|
| Windows x64 | `ddagent-flutter-windows-x64-<tag>-setup.exe` (installateur) ou `.zip` (portable) |
| Linux x64 | `ddagent-flutter-linux-x64-<tag>.deb` ou `.tar.gz` |
| Android | `ddagent-flutter-android-<tag>.apk` |
| Web | `ddagent-flutter-web-<tag>.zip` |

Au premier lancement, saisissez l'URL de votre serveur (par exemple `http://my-vps:3001`) et créez le premier compte. Sous Windows et Linux x64, le client desktop peut aussi télécharger et exécuter un serveur local pour vous (« Cet appareil » sur l'écran de connexion).

La version web n'a pas d'écran de connexion et appelle l'API sur sa propre origine : elle doit donc être servie derrière un reverse proxy placé devant un serveur en mode plateforme mono-utilisateur (`VITE_IS_PLATFORM=true`, qui désactive l'authentification). Dans un checkout des sources, `node scripts/serve-flutter-web.cjs` sert `flutter/build/web` sur le port 8085 et relaie l'API et les WebSockets vers le serveur sur `FLUTTER_BACKEND_PORT` (par défaut `10087`). N'exposez cette configuration que sur un réseau de confiance.

Pour compiler le client vous-même :

```bash
cd flutter
flutter pub get
flutter build linux --release      # or: windows, apk, web
```

### Depuis les sources

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run build && node dist-server/server/index.js   # API on http://localhost:3001
```

### Sandbox Docker (expérimental)

```bash
ddagent sandbox ~/my-project
```

Exécute ddagent et un agent (Claude Code ou Codex) dans une Docker Sandbox isolée par microVM. Nécessite le CLI `sbx` — voir [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md).

## CLI

Dans un checkout des sources ou `install.sh`, `ddagent` ci-dessous désigne `node dist-server/server/modules/cli/cli.js` (il a un shebang, donc `./dist-server/server/modules/cli/cli.js` fonctionne aussi).

| Commande | Description |
|---|---|
| `ddagent` / `ddagent start` | Démarre le serveur (commande par défaut) |
| `ddagent status` | Affiche la version et les emplacements du fichier de configuration, de la base de données et des projets Claude |
| `ddagent sandbox <workspace>` | Crée et démarre un sandbox Docker ; `ddagent sandbox help` liste `ls`, `start`, `stop`, `rm`, `logs` |
| `ddagent browser-use-mcp` | Lance le serveur MCP browser-use via stdio |
| `ddagent version` | Affiche la version |
| `ddagent help` | Affiche l'aide |

| Option | Description |
|---|---|
| `-p, --port <port>` | Port du serveur (remplace `SERVER_PORT`) |
| `--database-path <path>` | Emplacement personnalisé de la base de données (remplace `DATABASE_PATH`) |

## Configuration

Le serveur lit un fichier `.env` facultatif dans son répertoire d'installation (à côté de `start.sh`) ; les vraies variables d'environnement sont prioritaires. Lancez `ddagent status` pour voir quel fichier est utilisé.

| Variable | Défaut | Description |
|---|---|---|
| `SERVER_PORT` | `3001` | Port API + WebSocket (`PORT` est accepté comme alias historique) |
| `HOST` | `0.0.0.0` | Adresse d'écoute (`127.0.0.1` pour localhost uniquement) |
| `DATABASE_PATH` | `~/.ddagent/auth.db` | Base de données SQLite (utilisateurs, réglages, tokens) |
| `WORKSPACES_ROOT` | répertoire personnel | Les projets doivent se trouver dans ce répertoire |
| `JWT_SECRET` | généré automatiquement | Secret de signature des tokens de connexion (généré et stocké pour chaque installation) |
| `API_KEY` | non défini | S'il est défini, les requêtes API doivent l'envoyer dans l'en-tête `x-api-key` |
| `CLAUDE_CLI_PATH` | `claude` | Binaire Claude Code CLI personnalisé |
| `CONTEXT_WINDOW` | `200000` | Fenêtre de contexte Claude de repli, utilisée tant que le SDK n'a pas communiqué la fenêtre réelle du modèle |
| `STT_ENDPOINT_URL` / `STT_API_KEY` / `STT_MODEL` | `https://api.openai.com/v1` / non défini / `whisper-1` | Reconnaissance vocale pour la saisie vocale (également configurable dans les Réglages) |
| `VITE_IS_PLATFORM` | `false` | Mode plateforme mono-utilisateur : désactive l'authentification (requis par le client web) |

Voir [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example) pour plus de détails.

## Développement

```bash
npm install
npm run dev               # start the backend from source (tsx, no reload)
npm run server:dev-watch  # same, restarting on file changes
npm run build             # compile the server to dist-server/
npm test                  # backend tests
npm run typecheck         # TypeScript check
npm run lint              # ESLint
```

Client (Flutter 3.47.5 stable) :

```bash
cd flutter
flutter pub get
flutter run -d linux --dart-define=DEFAULT_SERVER_URL=http://localhost:3001
dart format --line-length 100 lib test
flutter analyze
flutter test
```

Le code backend suit l'architecture modulaire de `server/modules/` ; voir [`server/modules/providers/README.md`](https://github.com/Zakwei/ddagent/blob/main/server/modules/providers/README.md) pour le fonctionnement interne des providers.

## Contribuer

Les corrections de bugs sont les bienvenues — voir [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md). Pour signaler une vulnérabilité, voir [SECURITY.md](https://github.com/Zakwei/ddagent/blob/main/SECURITY.md).

---

<div align="center">
  <sub>Conçu pour la communauté Claude Code, Codex, Cursor, OpenCode, Devin, Command Code et Antigravity.</sub>
</div>
