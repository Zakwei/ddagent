# Base de connaissances

<p>
  <a href="../../KNOWLEDGE.md">English</a> ·
  <a href="KNOWLEDGE.pl.md">Polski</a> ·
  <a href="KNOWLEDGE.de.md">Deutsch</a> ·
  <a href="KNOWLEDGE.es.md">Español</a> ·
  <strong>Français</strong> ·
  <a href="KNOWLEDGE.it.md">Italiano</a> ·
  <a href="KNOWLEDGE.ja.md">日本語</a> ·
  <a href="KNOWLEDGE.ko.md">한국어</a> ·
  <a href="KNOWLEDGE.ru.md">Русский</a> ·
  <a href="KNOWLEDGE.tr.md">Türkçe</a> ·
  <a href="KNOWLEDGE.zh-CN.md">简体中文</a> ·
  <a href="KNOWLEDGE.zh-TW.md">繁體中文</a>
</p>

ddagent embarque une **base de connaissances locale** pour vos agents : mémoires, règles,
skills et informations personnelles, plus des étiquettes et des relations. Elle vit dans la
même base SQLite que le reste de ddagent (`auth.db`) derrière un index
plein texte FTS5, se gère depuis l’écran **Knowledge** du client, et est lisible et
modifiable par vos agents via MCP. Elle est librement inspirée de
[Contexta](https://github.com/XFABISIEK/Contexta).

L’idée est simple : vos règles et la connaissance projet cessent d’être éparpillées
dans les fichiers de chaque outil (`AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `skills/`, …)
et deviennent un seul endroit curé et interrogeable que chaque agent peut utiliser — ceux
qui lisent des fichiers et ceux qui parlent MCP.

## Comment un agent le voit réellement

Il y a trois couches, et il est utile de savoir laquelle est laquelle :

- **Fichiers natifs du CLI** — chaque outil lit sa propre configuration de son côté :
  Claude Code lit `CLAUDE.md`, Codex/Cursor lisent `AGENTS.md`, Cursor lit
  `.cursorrules`, et plusieurs lisent `skills/` et `.agents/skills/`. C’est le travail du
  CLI, pas le choix du modèle — ddagent ne le désactive pas.
- **Récupération via MCP (à la demande)** — dès que vous installez le serveur MCP de
  ddagent dans un agent, sa liste d’outils inclut `knowledge_get_context`,
  `knowledge_search` et compagnie. Comme chez Contexta, rien n’est injecté
  automatiquement : l’agent appelle le constructeur de contexte avec une requête et
  reçoit en retour les règles `critical` plus tout ce qui correspond. Le modèle décide
  quand l’appeler, guidé par les descriptions des outils et par les règles
  d’instruction que vous gardez dans la base de connaissances.

Donc « un seul endroit » signifie **un seul endroit pour curer la connaissance**
— cela n’empêche pas (et ne peut pas empêcher) un CLI de lire ses propres fichiers
natifs. ddagent n’injecte pas du tout la base de connaissances automatiquement dans
les sessions.

## Entités

| Entité | Portée | Remarques |
|---|---|---|
| Mémoire | projet ou global | `memory_type` (`fact`/`decision`/`note`/`reference`), `priority`, `source`, étiquettes |
| Règle | projet ou global | bascule `enabled` ; les règles `critical` sont toujours renvoyées en premier par le constructeur de contexte |
| Skill | global | nom unique, catégorie, icône optionnelle (base64 data URL) |
| Informations personnelles | global | `key` unique |
| Étiquette / Connexion | — | étiquettes sur les mémoires ; les connexions relient deux entités quelconques |
| Historique | — | chaque écriture capture un instantané de l’entité pour pouvoir la revoir et la restaurer |

Priorités : `critical > high > normal > low`. Une entité peut être limitée à un
projet ou être globale (s’applique partout). `project_id` est une simple colonne (pas de
clé étrangère) car la table des projets est reconstruite pendant les migrations.

## Récupérer le contexte (à la demande)

Les agents récupèrent le contexte via l’outil MCP `knowledge_get_context` (le modèle
Contexta). Pour un projet et une requête donnés, il renvoie, dans l’ordre :

- les **règles** `critical` du projet (toujours),
- les **règles** correspondant à la requête,
- les **mémoires** pertinentes (classées par FTS, plus leurs voisins à 1 saut
  atteints via les connexions),
- les **skills** dont le nom/la description/la catégorie correspond à la requête,
- les **informations personnelles** uniquement quand la requête y correspond,

le tout rendu sous forme de bloc Markdown à budget de tokens (`maxTokens`, ~4000 par
défaut). Sans requête, il renvoie les règles `critical` plus les meilleures mémoires.

Le tableau de bord affiche un **compteur de contexte critique** (`~X / 4000 tok`) pour le
projet sélectionné — la taille de ce que chaque appel à `knowledge_get_context`
inclut toujours. Rien n’est injecté automatiquement dans les sessions.

## Outils MCP (à la demande)

Le serveur MCP de ddagent (`POST /mcp`) expose la base de connaissances à tout client
MCP. Les outils de lecture fonctionnent avec un jeton de portée `read` ; les outils d’écriture
exigent `write`. Les outils d’écriture appliquent la même validation que l’UI et consignent
l’historique.

Lecture : `knowledge_search`, `knowledge_get_context`, `knowledge_get_memories`,
`knowledge_get_rules`, `knowledge_get_skills`, `knowledge_get_personal`,
`knowledge_get_graph`, `knowledge_history`.

Écriture : `knowledge_add_memory`, `knowledge_update_memory`,
`knowledge_delete_memory`, et le même trio pour `rule`, `skill` et `personal` ;
plus `knowledge_link` / `knowledge_unlink`.

Les outils acceptent soit un `projectId`, soit un `projectPath` que ddagent connaît déjà.

### Installer le serveur dans vos agents

Vous n’avez pas à modifier les configurations des fournisseurs à la main. Utilisez **Settings → MCP →
Install ddagent MCP server** (également proposé comme étape de l’onboarding) et choisissez les
agents — ou installez pour tous. Cela écrit une entrée HTTP MCP `ddagent` (portée
utilisateur) pointant vers `<server>/mcp` avec un jeton bearer `ddagent-mcp` réutilisable
(une réinstallation révoque le précédent). Une fois installé, les outils de cet agent
incluent le groupe `knowledge_*` aux côtés de `create_task`, `send_message`, etc.

Comment un agent sait-il *quand* utiliser MCP ? Il ne devine pas — dites-le-lui. Gardez une
règle `critical` telle que : *« Avant de répondre aux questions sur ce projet, appelle
`knowledge_get_context` ; quand tu tranches une décision, persiste-la avec
`knowledge_add_memory`. »* Comme les règles `critical` sont toujours renvoyées par le
constructeur de contexte, chaque agent qui appelle l’outil reçoit les mêmes
instructions de fonctionnement.

## Analyse de projet

`POST /api/knowledge/scan` importe les fichiers de contexte IA d’un projet, classés par
intention :

- `AGENTS.md`, `CLAUDE.md`, `MUSE.md`, `GEMINI.md`, `CODEX.md`, `.cursorrules`,
  `.muserules` et le markdown/`.mdc` sous `.cursor/rules` deviennent des **règles**
  (critical + enabled, afin d’atteindre le contexte de l’agent ; l’`AGENTS.md` du
  workspace est `high` pour éviter la double injection avec unified-rules),
- les fichiers `SKILL.md` sous `skills` / `.agents/skills` deviennent des **skills**
  (nom/description depuis le frontmatter),
- tout autre markdown analysé devient une **mémoire de référence**.

Chaque fichier est suivi par hash de contenu dans `kb_scan_state`, donc une nouvelle analyse ne
touche que les fichiers modifiés et supprime les entités dont la source a disparu.

## Client

L’écran **Knowledge** (rail de navigation → Knowledge) a des onglets Dashboard, Memories,
Rules, Skills, Personal et Graph, un filtre de portée projet, un formulaire modal de
création/édition, un historique de versions par entité avec restauration, l’upload d’icône de
skill et l’export/import JSON. L’onglet Memories a une barre de filtre d’étiquettes (avec
gestion des étiquettes), la barre d’app a une recherche plein texte, une boîte de dialogue de
création de lien et une action de migration, et l’onglet Graph est une vue de relations dirigée
par les forces avec pan/zoom, glisser-déposer des nœuds, filtres par type d’entité et mise en
évidence des voisins.
Le graphe dessine vos liens explicites ainsi que les hubs implicites — chaque entité de portée projet se connecte à son projet, et les mémoires partageant une étiquette se connectent à un nœud d’étiquette — il montre donc toujours la structure.

## Bien la curer

1. **Analysez** chaque projet actif une fois (Knowledge → sélectionnez le projet → scan) ;
   réanalysez après de gros changements de ses fichiers d’instructions.
2. **Promouvez délibérément** : seules les règles réellement contraignantes devraient être
   `critical` (elles sont toujours servies par le constructeur de contexte). Utilisez
   l’étoile sur une ligne et surveillez le compteur de contexte critique.
3. **Gardez le reste en `high`/`normal`** — toujours interrogeable et disponible via MCP
   uniquement lorsqu’une requête correspond, donc elles ne coûtent rien quand elles sont hors sujet.
4. **Informations personnelles** pour les préférences inter-projets (fuseau horaire, éditeur, nommage).
5. **Reliez les mémoires liées** pour que les voisins à 1 saut suivent.
6. **Installez MCP** pour les agents qui doivent interroger la base et persister
   les apprentissages ; donnez la portée `read` à la plupart, `write` là où vous faites confiance à l’agent.

## Migration

Knowledge → menu → **Migrate existing rules** lance un rapport **dry-run** : il
analyse tous les projets, trouve les doublons qui existent entre projets (même titre
normalisé + contenu) et affiche les comptes de règles. De là, vous pouvez **Merge duplicates**
(les fusionne en une seule ligne globale) et/ou **Make all rules critical**. Rien
n’est écrit avant votre confirmation — les actions destructrices sont explicites.

Le **Dashboard** dispose aussi d’un unique bouton **Tout importer dans ddagent** : il exécute l’analyse de projet et l’import des skills d’agents en une seule action, avec le même aperçu dry-run et les bascules optionnelles de fusion des doublons / promotion. Il ne fait que lire les fichiers de vos agents et écrire dans la base de données propre à ddagent — aucun fichier ni configuration de la CLI n’est touché (la seule action qui écrit dans la configuration d’un agent est le "Install ddagent MCP server" séparé).

Le même menu contient **Importer les skills des agents** : il liste les skills globales/par défaut que vos agents fournissent déjà ou ont installées (portées utilisateur / système / plugin) et importe les manquantes dans la base de connaissances en tant que skills. C’est d’abord un dry-run, et c’est idempotent — un nom qui existe déjà est ignoré. Les skills de portée projet sont importées par l’analyse de projet.

## Bon à savoir

- Tout est **local** à cette instance ddagent ; pas de cloud, pas de sync.
- La base de connaissances n’est **pas injectée automatiquement** — les agents la
  récupèrent via MCP à la demande (modèle Contexta). Les agents sans le serveur MCP
  installé n’en tirent rien.
- Les skills analysées sont accessibles via MCP (`knowledge_get_context` /
  `knowledge_search`), elles ne sont pas poussées dans le contexte.
- Une règle ou une mémoire peut être modifiée par un agent via MCP ; consultez les changements dans
  l’**History** de l’entité et restaurez une version précédente si besoin.

## API REST

Montée sur `/api/knowledge` derrière l’authentification :

```
GET    /memories            ?projectId=&includeGlobal=&priority=&tag=&memoryType=&limit=&offset=
POST   /memories            PATCH /memories/:id   DELETE /memories/:id
GET    /rules               ?projectId=&includeGlobal=&priority=&enabledOnly=
POST   /rules               PATCH /rules/:id       DELETE /rules/:id
GET    /skills              ?category=
POST   /skills              PATCH /skills/:id      DELETE /skills/:id
GET    /personal            POST /personal         PATCH/DELETE /personal/:id
GET    /search              ?q=&type=&projectId=&limit=
GET    /graph               ?projectId=&types=&limit=
GET    /context             ?projectId=            (taille du contexte critique + budget)
GET    /tags                DELETE /tags/:id
GET    /connections         POST /connections      DELETE /connections/:id
GET    /history             ?entityType=&entityId=&limit=
GET    /stats
GET    /export              POST /import
POST   /scan                { projectId }
POST   /migrate             { projectIds?, dryRun?, dedupe?, promoteRules? }
POST   /import-skills       { providers?, scopes?, dryRun? }
POST   /import-all          { dryRun?, dedupe?, promoteRules? }
```

`projectId=global` limite une liste aux lignes globales ; ajouter `includeGlobal=true`
à un id de projet renvoie les lignes du projet plus les globales.

## Voir aussi

- [ddagent comme serveur MCP](mcp-server.md) — le catalogue d’outils et la configuration du jeton
- [Collaboration d’équipe](teams.md) · [Approbations à distance](remote-approvals.md)
