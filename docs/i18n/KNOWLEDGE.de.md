# Wissensbasis

<p>
  <a href="../../KNOWLEDGE.md">English</a> ·
  <a href="KNOWLEDGE.pl.md">Polski</a> ·
  <strong>Deutsch</strong> ·
  <a href="KNOWLEDGE.es.md">Español</a> ·
  <a href="KNOWLEDGE.fr.md">Français</a> ·
  <a href="KNOWLEDGE.it.md">Italiano</a> ·
  <a href="KNOWLEDGE.ja.md">日本語</a> ·
  <a href="KNOWLEDGE.ko.md">한국어</a> ·
  <a href="KNOWLEDGE.ru.md">Русский</a> ·
  <a href="KNOWLEDGE.tr.md">Türkçe</a> ·
  <a href="KNOWLEDGE.zh-CN.md">简体中文</a> ·
  <a href="KNOWLEDGE.zh-TW.md">繁體中文</a>
</p>

ddagent liefert eine **lokale Wissensbasis** für deine Agenten: Memories, Regeln,
Skills und persönliche Informationen, dazu Tags und Relationen. Sie liegt in
derselben SQLite-Datenbank wie der Rest von ddagent (`auth.db`) hinter einem
FTS5-Volltextindex, wird über den Bildschirm **Knowledge** im Client verwaltet und
ist für deine Agenten über MCP les- und schreibbar. Sie ist lose von
[Contexta](https://github.com/XFABISIEK/Contexta) inspiriert.

Der Punkt ist einfach: Deine Regeln und dein Projektwissen liegen nicht mehr verstreut
über Dateien einzelner Tools (`AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `skills/`, …),
sondern werden ein kuratierter, durchsuchbarer Ort, den jeder Agent nutzen kann — die,
die Dateien lesen, und die, die MCP sprechen.

## Wie ein Agent es tatsächlich sieht

Es gibt drei Ebenen, und es hilft zu wissen, welche welche ist:

- **CLI-native Dateien** — jedes Tool liest seine eigene Konfiguration selbst: Claude
  Code liest `CLAUDE.md`, Codex/Cursor lesen `AGENTS.md`, Cursor liest `.cursorrules`,
  und einige lesen `skills/` und `.agents/skills/`. Das ist Aufgabe des CLI, nicht
  die Wahl des Modells — ddagent schaltet es nicht ab.
- **MCP-Abruf (auf Abruf)** — sobald du den MCP-Server von ddagent in einen Agenten
  installierst, enthält seine Tool-Liste `knowledge_get_context`, `knowledge_search`
  und Verwandte. Nach dem Contexta-Modell wird nichts automatisch injiziert: Der
  Agent ruft den Kontext-Builder mit einer Anfrage auf und bekommt die
  `critical`-Regeln plus alles, was passt, zurück. Das Modell entscheidet, wann es
  ihn aufruft, geleitet von den Tool-Beschreibungen und von allen
  Instruktionsregeln, die du in der Wissensbasis hältst.

„Ein Ort“ heißt also **ein Ort zum Kuratieren des Wissens**
— es hindert ein CLI nicht (und kann es nicht) daran, seine eigenen nativen Dateien
zu lesen. ddagent injiziert die Wissensbasis überhaupt nicht automatisch in Sitzungen.

## Entitäten

| Entität | Geltungsbereich | Hinweise |
|---|---|---|
| Memory | projektbezogen oder global | `memory_type` (`fact`/`decision`/`note`/`reference`), `priority`, `source`, Tags |
| Regel | projektbezogen oder global | `enabled`-Schalter; `critical`-Regeln werden vom Kontext-Builder immer zuerst zurückgegeben |
| Skill | global | eindeutiger Name, Kategorie, optionales Symbol (base64 data URL) |
| Persönliche Infos | global | eindeutiger `key` |
| Tag / Verbindung | — | Tags an Memories; Verbindungen verknüpfen zwei beliebige Entitäten |
| Historie | — | jeder Schreibvorgang erstellt einen Snapshot der Entität, damit er geprüft und wiederhergestellt werden kann |

Prioritäten: `critical > high > normal > low`. Eine Entität kann auf ein Projekt
beschränkt oder global sein (gilt überall). `project_id` ist eine einfache Spalte (kein
Fremdschlüssel), weil die Projekttabelle bei Migrationen neu aufgebaut wird.

## Kontext abrufen (auf Abruf)

Agenten holen Kontext über das MCP-Tool `knowledge_get_context` (eine getreue
Portierung von Contextas ContextBuilder). Für ein Projekt und eine Anfrage gibt
es der Reihe nach zurück:

- **alle aktivierten Regeln** (Projekt- + globale Regeln), `critical` zuerst (Limit 20),
- **Memories**, nach der Anfrage gereiht (FTS), plus ihre 1-Hop-Nachbarn, die über
  Verbindungen erreicht werden (Limit 5); ohne Anfrage die Top-Memories des Projekts
  nach Priorität,
- **Skills**, nach der Anfrage gereiht; ohne Anfrage die neuesten Skills,
- **persönliche Informationen** nur, wenn die Anfrage darauf passt (Limit 3),

gerendert als Markdown-Block, dessen Elemente pro Abschnitt gekürzt werden
(800/1000/600 Zeichen) und durch `maxTokens` begrenzt sind (Standard ~4000);
Elemente, die nicht mehr passen, werden als ausgelassen gezählt.

Das Dashboard zeigt einen **Regelkontext-Meter** (`~X / 4000 tok`) für das
ausgewählte Projekt — die Größe des Regelblocks, den jeder
`knowledge_get_context`-Aufruf immer enthält. In Sitzungen wird nichts
automatisch injiziert.

Das Such-Ranking ist hybrid, wie in Contextas `search.rs`: FTS5 **prefix**-Abgleich
(`auth` passt auch auf `authentication`) plus ein unscharfer **trigram**-Durchlauf,
der Tippfehler und Quasi-Synonyme erfasst, danach ein Rerank nach
`bm25 + priority + recency`.

## MCP-Tools (auf Abruf)

Der MCP-Server von ddagent (`POST /mcp`) stellt die Wissensbasis jedem MCP-Client
bereit. Lesetools arbeiten mit einem `read`-skopierten Token; Schreibtools erfordern `write`.
Schreibtools führen dieselbe Validierung wie die UI aus und zeichnen Historie auf.

Lesen: `knowledge_search`, `knowledge_get_context`, `knowledge_get_memories`,
`knowledge_get_rules`, `knowledge_get_skills`, `knowledge_get_personal`,
`knowledge_get_graph`, `knowledge_history`.

Schreiben: `knowledge_add_memory`, `knowledge_update_memory`,
`knowledge_delete_memory`, und dasselbe Trio für `rule`, `skill` und `personal`;
plus `knowledge_link` / `knowledge_unlink`.

Tools akzeptieren entweder `projectId` oder einen `projectPath`, den ddagent bereits kennt.

### Den Server in deine Agenten installieren

Du musst Provider-Konfigurationen nicht von Hand bearbeiten. Nutze **Settings → MCP →
Install ddagent MCP server** (auch als Schritt im Onboarding angeboten) und wähle die
Agenten — oder installiere für alle. Es schreibt einen `ddagent` HTTP-MCP-Eintrag
(User-Scope), der auf `<server>/mcp` zeigt, mit einem wiederverwendbaren `ddagent-mcp`
Bearer-Token (eine Neuinstallation widerruft den vorherigen). Nach der Installation
enthalten die Tools dieses Agenten die `knowledge_*`-Gruppe neben `create_task`,
`send_message` usw.

Woher weiß ein Agent, *wann* er MCP nutzen soll? Er rät nicht — sag es ihm. Halte eine
`critical`-Regel wie: *„Bevor du Fragen zu diesem Projekt beantwortest, rufe
`knowledge_get_context` auf; wenn du eine Entscheidung triffst, halte sie mit
`knowledge_add_memory` fest.“* Weil `critical`-Regeln immer vom Kontext-Builder
zurückgegeben werden, bekommt jeder Agent, der das Tool aufruft, dieselben
Betriebsanweisungen.

## Projekt-Scan

`POST /api/knowledge/scan` importiert die AI-Kontextdateien eines Projekts,
klassifiziert nach Absicht:

- `AGENTS.md`, `CLAUDE.md`, `MUSE.md`, `GEMINI.md`, `CODEX.md`, `.cursorrules`,
  `.muserules` und Markdown/`.mdc` unter `.cursor/rules` werden **Regeln**
  (critical + enabled, damit sie den Agentenkontext erreichen; die Workspace-`AGENTS.md`
  ist `high`, um doppelte Injektion mit unified-rules zu vermeiden),
- `SKILL.md`-Dateien unter `skills` / `.agents/skills` werden **Skills**
  (Name/Beschreibung aus dem Frontmatter),
- jedes andere gescannte Markdown wird eine **Referenz-Memory**.

Jede Datei wird über einen Inhalts-Hash in `kb_scan_state` verfolgt, sodass ein Rescan
nur geänderte Dateien anfasst und die Entitäten löscht, deren Quelle verschwunden ist.

## Client

Der Bildschirm **Knowledge** (Navigationsleiste → Knowledge) hat die Tabs Dashboard,
Memories, Rules, Skills, Personal und Graph, einen Projekt-Geltungsbereichsfilter, ein
modales Erstellen/Bearbeiten-Formular, Versionshistorie pro Entität mit
Wiederherstellung, Skill-Icon-Upload und JSON-Export/-Import. Der Memories-Tab hat eine
Tag-Filterleiste (mit Tag-Verwaltung), die App-Leiste hat Volltextsuche, einen
Link-erstellen-Dialog und eine Migrationsaktion, und der Graph-Tab ist eine
kraftgerichtete Relationsansicht mit Pan/Zoom, Knoten-Ziehen, Entitätstyp-Filtern und
Nachbar-Hervorhebung.
Der Graph zeichnet deine expliziten Links plus implizite Hubs — jede projektbezogene Entität verbindet sich mit ihrem Projekt, und Memories, die sich einen Tag teilen, verbinden sich mit einem Tag-Knoten — sodass er immer Struktur zeigt.

## Gut kuratieren

1. **Scanne** jedes aktive Projekt einmal (Knowledge → Projekt wählen → scan);
   scanne nach großen Änderungen an seinen Instruktionsdateien erneut.
2. **Befördere bewusst**: nur wirklich bindende Regeln sollten `critical` sein
   (sie werden immer vom Kontext-Builder ausgeliefert). Nutze den Stern in einer
   Zeile und beobachte den Critical-Context-Meter.
3. **Halte den Rest auf `high`/`normal`** — weiterhin durchsuchbar und über MCP
   verfügbar, nur wenn eine Anfrage passt, kosten also nichts, wenn sie irrelevant sind.
4. **Persönliche Infos** für projektübergreifende Präferenzen (Zeitzone, Editor, Benennung).
5. **Verknüpfe verwandte Memories**, damit 1-Hop-Nachbarn mitfahren.
6. **Installiere MCP** für die Agenten, die die Basis durchsuchen und Erkenntnisse
   festhalten sollen; gib den meisten `read`-Scope, `write` dort, wo du dem Agenten vertraust.

## Migration

Knowledge → Menü → **Migrate existing rules** führt einen **Dry-Run**-Bericht aus: er
scannt alle Projekte, findet Duplikate, die über Projekte hinweg existieren (gleicher
normalisierter Titel + Inhalt), und zeigt Regelzahlen. Von dort kannst du **Merge duplicates**
(führt sie zu einer globalen Zeile zusammen) und/oder **Make all rules critical**. Nichts
wird geschrieben, bis du bestätigst — destruktive Aktionen sind explizit.

Das **Dashboard** hat außerdem eine einzelne Schaltfläche **Alles in ddagent importieren**: sie führt den Projekt-Scan und den Agenten-Skill-Import in einer Aktion aus, mit derselben Dry-Run-Vorschau und optionalen Schaltern für Duplikat-Zusammenführung / Hochstufung. Sie liest nur die Dateien deiner Agenten und schreibt in ddagents eigene Datenbank — weder eine CLI-Datei noch eine Konfiguration wird berührt (die einzige Aktion, die in die Konfiguration eines Agenten schreibt, ist das separate "Install ddagent MCP server").

Dasselbe Menü enthält **Agenten-Skills importieren**: es listet die globalen/Standard-Skills auf, die deine Agenten bereits mitbringen oder installiert haben (User-, System- und Plugin-Scope), und importiert die fehlenden als Skills in die Wissensbasis. Es ist zuerst ein Dry-Run und idempotent — ein Name, der bereits existiert, wird übersprungen. Projektbezogene Skills werden stattdessen vom Projekt-Scan importiert.

## Gut zu wissen

- Alles ist **lokal** zu dieser ddagent-Instanz; keine Cloud, kein Sync.
- Die Wissensbasis wird **nicht automatisch injiziert** — Agenten rufen sie über
  MCP auf Abruf ab (Contexta-Modell). Agenten ohne installierten MCP-Server bekommen
  nichts daraus.
- Gescannte Skills sind über MCP erreichbar (`knowledge_get_context` /
  `knowledge_search`) und werden nicht in den Kontext gedrückt.
- Eine Regel oder Memory kann von einem Agenten über MCP bearbeitet werden; prüfe
  Änderungen in der **History** der Entität und stelle bei Bedarf eine frühere Version wieder her.

## REST-API

Eingehängt unter `/api/knowledge` hinter Authentifizierung:

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
GET    /context             ?projectId=            (Größe des kritischen Kontexts + Budget)
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

`projectId=global` beschränkt eine Liste auf globale Zeilen; das Hinzufügen von
`includeGlobal=true` zu einer Projekt-ID liefert die Projekt- plus die globalen Zeilen.

## Verwandt

- [ddagent als MCP-Server](mcp-server.md) — der Tool-Katalog und das Token-Setup
- [Team-Zusammenarbeit](teams.md) · [Remote-Genehmigungen](remote-approvals.md)
