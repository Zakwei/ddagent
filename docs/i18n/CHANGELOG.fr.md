# Journal des modifications

Toutes les modifications notables de ddagent sont documentées ici.

Le format suit [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
et ce projet adhère au [Semantic Versioning](https://semver.org/).

<p>
  <a href="../../CHANGELOG.md">English</a> ·
  <a href="CHANGELOG.pl.md">Polski</a> ·
  <a href="CHANGELOG.de.md">Deutsch</a> ·
  <a href="CHANGELOG.es.md">Español</a> ·
  <strong>Français</strong> ·
  <a href="CHANGELOG.it.md">Italiano</a> ·
  <a href="CHANGELOG.ja.md">日本語</a> ·
  <a href="CHANGELOG.ko.md">한국어</a> ·
  <a href="CHANGELOG.ru.md">Русский</a> ·
  <a href="CHANGELOG.tr.md">Türkçe</a> ·
  <a href="CHANGELOG.zh-CN.md">简体中文</a> ·
  <a href="CHANGELOG.zh-TW.md">繁體中文</a>
</p>

## [0.6.2] - 2026-09-26

### Corrections

- Mobile : les Paramètres affichaient un libellé codé en dur « 0.1.0 (mobile scaffold) » — ils montrent désormais la vraie version de l'app ; les APK de release portent la version du release, Android peut donc mettre à jour en place

## [0.6.1] - 2026-09-26

### Corrections

- Mobile : le sélecteur de modèle était indisponible sur les nouveaux chats, workspace multi-panneaux inaccessible
- Mobile : les panneaux du split workspace intègrent désormais de vraies vues de chat

## [0.6.0] - 2026-09-26

### Nouveautés

- **Fournisseur orchestré Auto** — routage des modèles, DAG du planificateur et délégation avec cartes routage/plan/délégation/résumé dans le chat, plus un onglet d'orchestration dans les Paramètres
- **Mobile : parité native complète** — chaque écran est désormais natif : Fichiers (CRUD, recherche, lightbox), Contrôle de code source (staging de hunks, diff fractionné, graphe de commits, worktrees), Tâches (éditeur PRD, édition des détails), Tableau des agents, Quota et utilisation, terminal, éditeur et tous les onglets des Paramètres
- **Mobile :** assistant d'intégration, assistant de création de projet (navigateur de dossiers, clonage GitHub, révision), palette de commandes avec recherche globale, grille d'espace de travail fractionnée, panneau de paramètres rapides, panneau live browser-use
- **Mobile :** file de messages hors ligne, export de chat (PDF/md/html/text), recherche dans les transcriptions, comparaison de sessions

### Corrections

- OpenCode : lignes de session en double provenant d'instantanés de texte streamés, invites de l'outil de questions non affichées
- La barre fixe Révision/Recherche rognait le premier message

## [0.5.9] - 2026-09-25

Première version publique open source — **AGPL-3.0-only**.

### Nouveautés

- **Collaboration en équipe** — sessions partagées, messages de diffusion, boîte de réception de l'agent, mémoire partagée par projet
- **Serveur MCP** — les clients MCP externes (Claude Desktop, OpenClaw) peuvent créer des tâches et envoyer des messages aux sessions via `POST /mcp` ([documentation](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Approbations à distance** — approuvez les actions de l'agent depuis Telegram ou Discord ([documentation](https://github.com/Zakwei/ddagent/blob/main/docs/remote-approvals.md))
- **Planificateur** — planifications cron pour les exécutions de l'agent avec prévention de la mise en veille
- **Comptes de fournisseur nommés** — remplacements d'environnement et d'identifiants par session
- **Saisie vocale (STT)** — endpoint compatible Whisper dans le composeur
- **Worktrees** — scripts d'installation et d'exécution par dépôt avec exécuteur de serveur de développement
- **Aperçu** — proxy d'aperçu du serveur de développement authentifié avec tunnel WS
- **Mobile** — recherche de sessions, notifications push d'approbation interactives (FCM)
- `SECURITY.md` — politique de signalement privé des vulnérabilités

### Corrections

- Bogues de données et d'affichage dans l'onglet Quota
- Chat : la file hors ligne et les brouillons survivent aux rechargements ; position de défilement stable entre les rafraîchissements
- Sessions : les sessions supprimées ne laissent plus de fantômes sur les autres clients
- Kanban : conditions de course et fuites lors de la distribution sur le tableau des agents
- Mobile : padding brut de la hauteur du clavier, ActionSheet remplace les alertes de débordement

## [0.5.8] - 2026-09-23

### Nouveautés

- `install.sh` — installateur de serveur basé sur git (`--version`, `--dir`, `--port`, `--systemd`)
- Archives tar de serveur autonome et local publiées sur les tags `v*`

### Corrections

- Le clavier mobile recouvrait le composeur et le contenu sous la barre de navigation système (Android)

## [0.5.7] - 2026-09-23

### Corrections

- Builds CI de bureau (flag de plateforme du bundle, rebuilds natifs, timeouts des smoke tests)
- Messages de l'assistant diffusés en double dans les transcriptions du chat

## [0.5.6] - 2026-09-23

### Corrections

- CI bureau : builds macOS non signés quand les secrets Apple sont absents, staging des packages à portée sous Windows

## [0.5.5] - 2026-09-23

### Nouveautés

- **Application de bureau (aperçu)** — lanceur Electron pour serveurs locaux ou distants, backend embarqué, mise à jour automatique, builds dmg/NSIS/AppImage/deb
- **Application mobile (aperçu)** — compagnon Expo/React Native : sessions, chat avec sélecteur de modèle et commandes slash, terminal, fichiers, WebViews de paramètres
- Indicateur de non-lu sur les sessions avec sortie non vue ; liaison tableau de tâches ↔ session
- Îlots KaTeX et Mermaid dans le chat

### Corrections

- Zones tactiles et mises en page sur les viewports mobiles ; peaufinage de la palette de commandes, du kanban et des paramètres

## [0.5.4] - 2026-09-21

### Nouveautés

- Bouton de redémarrage du serveur avec superposition de progression plein écran (Paramètres → À propos)
- Journal des modifications localisé des versions GitHub dans Paramètres → À propos
- Nombre de sessions actives dans le titre de l'onglet du navigateur
- Échelle de l'axe Y et infobulles au survol sur le graphique de tendance d'utilisation

### Corrections

- La sauvegarde automatique des paramètres se déclenchait à l'ouverture des fenêtres modales ; mise en page compacte du chat dans les divisions multi-lignes

## [0.5.3] - 2026-09-21

### Corrections

- La boîte de dialogue de mise à jour disponible était cachée derrière le rail latéral (correctif de portal)

## [0.5.2] - 2026-09-21

### Corrections

- La vérification des mises à jour passe désormais par le serveur

## [0.5.1] - 2026-09-21

### Nouveautés

- Badge de mise à jour disponible avec mise à jour automatique en un clic
- Voix de lecture à voix haute par session ; sélecteur de voix déplacé dans les paramètres d'apparence

### Corrections

- La bannière du chat affiche le fournisseur réel de la session

## [0.5.0] - 2026-09-21

Première version autonome de **ddagent** — une interface web et mobile auto-hébergée pour les agents de codage IA.

### Points forts

- **Sessions multi-agents** — Claude Code, Codex, Cursor CLI, OpenCode et Devin côte à côte, avec streaming en direct et reprise
- **Disposition de l'espace de travail** — panneaux divisés pour le chat, le terminal, le navigateur et les fichiers
- **Explorateur et éditeur de fichiers** — parcourez et modifiez l'espace de travail dans l'interface
- **Panneau Git** — indexation, commit, diff, changement de branches, gestion des worktrees
- **Tableau des tâches** — kanban propulsé par TaskMaster ; générez des tâches exécutables à partir de PRD
- **Gestion MCP** — ajoutez et synchronisez les serveurs MCP entre agents
- **Navigateur de skills** — découvrez et gérez les skills des agents
- **Quota et utilisation** — utilisation de tokens par agent et limites d'abonnement
- **Browser-use** — sessions de navigateur pilotées par l'agent pour la recherche et les tests
- **Notifications et TTS** — alertes et réponses lues à voix haute
- **Bacs à sable Docker** — exécutions expérimentales d'agents isolées par hyperviseur
- **Compagnon de bureau** — application Electron optionnelle pour macOS/Windows
- **i18n** — 11 langues d'interface, thèmes sombre et clair

### CLI

- `ddagent` / `ddagent start` — démarre le serveur
- `ddagent status` — affiche la configuration et les emplacements des données
- `ddagent version` / `ddagent help`
