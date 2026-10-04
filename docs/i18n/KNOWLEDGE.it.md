# Base di conoscenza

<p>
  <a href="../../KNOWLEDGE.md">English</a> ·
  <a href="KNOWLEDGE.pl.md">Polski</a> ·
  <a href="KNOWLEDGE.de.md">Deutsch</a> ·
  <a href="KNOWLEDGE.es.md">Español</a> ·
  <a href="KNOWLEDGE.fr.md">Français</a> ·
  <strong>Italiano</strong> ·
  <a href="KNOWLEDGE.ja.md">日本語</a> ·
  <a href="KNOWLEDGE.ko.md">한국어</a> ·
  <a href="KNOWLEDGE.ru.md">Русский</a> ·
  <a href="KNOWLEDGE.tr.md">Türkçe</a> ·
  <a href="KNOWLEDGE.zh-CN.md">简体中文</a> ·
  <a href="KNOWLEDGE.zh-TW.md">繁體中文</a>
</p>

ddagent include una **base di conoscenza locale** per i tuoi agenti: memorie, regole,
skill e informazioni personali, oltre a tag e relazioni. Vive nello stesso
database SQLite del resto di ddagent (`auth.db`) dietro un indice full-text
FTS5, si gestisce dalla schermata **Knowledge** nel client ed è leggibile
e scrivibile dai tuoi agenti via MCP. È liberamente ispirata a
[Contexta](https://github.com/XFABISIEK/Contexta).

Il punto è semplice: le tue regole e la conoscenza di progetto smettono di essere sparse
nei file di ogni strumento (`AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `skills/`, …)
e diventano un unico luogo curato e ricercabile che ogni agente può usare — quelli
che leggono i file e quelli che parlano MCP.

## Come lo vede davvero un agente

Ci sono tre livelli, ed è utile sapere qual è quale:

- **File nativi del CLI** — ogni strumento legge la propria configurazione per conto
  proprio: Claude Code legge `CLAUDE.md`, Codex/Cursor leggono `AGENTS.md`, Cursor legge
  `.cursorrules`, e diversi leggono `skills/` e `.agents/skills/`. Questo è compito del CLI, non
  una scelta del modello — ddagent non lo disattiva.
- **Iniezione di ddagent** — al primo turno di una sessione ddagent antepone un
  blocco `<knowledge>` (dettagli sotto). Funziona per ogni provider e non
  richiede configurazione da parte dell’agente.
- **Strumenti MCP** — una volta installato il server MCP di ddagent in un agente, la sua
  lista di strumenti include `knowledge_search` e simili. Il modello decide quando
  chiamarli, guidato dalle descrizioni degli strumenti e da eventuali regole
  di istruzione che tieni nella base di conoscenza.

Quindi «un solo posto» significa **un solo posto dove curare il contenuto iniettato e un solo budget**
— non impedisce (e non può impedire) a un CLI di leggere i propri file nativi. Per evitare
duplicati teniamo l’`AGENTS.md` del workspace a priorità `high`, così il blocco di
conoscenza non ripete mai ciò che unified-rules inietta già.

## Entità

| Entità | Ambito | Note |
|---|---|---|
| Memoria | progetto o globale | `memory_type` (`fact`/`decision`/`note`/`reference`), `priority`, `source`, tag |
| Regola | progetto o globale | interruttore `enabled`; le regole `critical` vengono iniettate nelle sessioni |
| Skill | globale | nome univoco, categoria, icona opzionale (base64 data URL) |
| Informazioni personali | globale | `key` univoca |
| Tag / Connessione | — | tag sulle memorie; le connessioni collegano due entità qualsiasi |
| Cronologia | — | ogni scrittura crea uno snapshot dell’entità, così può essere rivista e ripristinata |

Priorità: `critical > high > normal > low`. Un’entità può essere limitata a un
progetto o essere globale (vale ovunque). `project_id` è una colonna semplice (nessuna
chiave esterna) perché la tabella dei progetti viene ricostruita durante le migrazioni.

## Iniezione al primo turno (ciò che ogni agente riceve, automaticamente)

Al **primo** messaggio in uscita di una sessione, ddagent antepone un blocco
`<knowledge>` contenente:

- **regole** `critical` (di progetto + globali, solo abilitate),
- **memorie** `critical`,
- ogni voce di **informazioni personali**,
- i **vicini a 1 salto** delle memorie incluse (raggiunti tramite connessioni
  esplicite).

L’intero blocco è limitato a ~4000 token. Passa dallo stesso gate del primo turno di
`.ddagent/shared-context.md` e unified rules, quindi non costa token per turno.
Imposta `DDAGENT_KNOWLEDGE=0` per disattivarlo.

La dashboard mostra un **misuratore del contesto iniettato** (`~X / 4000 tok`) per il
progetto selezionato, così puoi vedere e controllare cosa entra nel contesto.

## Strumenti MCP (su richiesta)

Il server MCP di ddagent (`POST /mcp`) espone la base di conoscenza a qualsiasi client
MCP. Gli strumenti di lettura funzionano con un token con ambito `read`; quelli di scrittura
richiedono `write`. Gli strumenti di scrittura eseguono la stessa validazione dell’UI e
registrano la cronologia.

Lettura: `knowledge_search`, `knowledge_get_context`, `knowledge_get_memories`,
`knowledge_get_rules`, `knowledge_get_skills`, `knowledge_get_personal`,
`knowledge_get_graph`, `knowledge_history`.

Scrittura: `knowledge_add_memory`, `knowledge_update_memory`,
`knowledge_delete_memory`, e la stessa terna per `rule`, `skill` e `personal`;
più `knowledge_link` / `knowledge_unlink`.

Gli strumenti accettano un `projectId` oppure un `projectPath` che ddagent già conosce.

### Installare il server nei tuoi agenti

Non devi modificare a mano le configurazioni dei provider. Usa **Settings → MCP →
Install ddagent MCP server** (offerto anche come passo dell’onboarding) e scegli gli
agenti — oppure installa per tutti. Scrive una voce MCP HTTP `ddagent` (ambito
utente) che punta a `<server>/mcp` con un token bearer `ddagent-mcp` riutilizzabile
(reinstallare revoca il precedente). Una volta installato, gli strumenti di quell’agente
includono il gruppo `knowledge_*` accanto a `create_task`, `send_message`, ecc.

Come fa un agente a sapere *quando* usare MCP? Non tira a indovinare — diglielo. Tieni una
regola `critical` come: *«Prima di rispondere a domande su questo progetto, chiama
`knowledge_search`; quando prendi una decisione, rendila persistente con
`knowledge_add_memory`.»* Poiché quella regola viene iniettata a ogni primo turno, tutti
i tuoi agenti ricevono le stesse istruzioni operative.

## Scansione del progetto

`POST /api/knowledge/scan` importa i file di contesto AI di un progetto, classificati per
intento:

- `AGENTS.md`, `CLAUDE.md`, `MUSE.md`, `GEMINI.md`, `CODEX.md`, `.cursorrules`,
  `.muserules` e il markdown/`.mdc` sotto `.cursor/rules` diventano **regole**
  (critical + enabled, così raggiungono il contesto dell’agente; l’`AGENTS.md` del
  workspace è `high` per evitare la doppia iniezione con unified-rules),
- i file `SKILL.md` sotto `skills` / `.agents/skills` diventano **skill**
  (nome/descrizione dal frontmatter),
- qualsiasi altro markdown scansionato diventa una **memoria di riferimento**.

Ogni file è tracciato tramite hash del contenuto in `kb_scan_state`, quindi una nuova scansione
tocca solo i file modificati ed elimina le entità la cui origine è sparita.

## Client

La schermata **Knowledge** (rail di navigazione → Knowledge) ha le schede Dashboard, Memories,
Rules, Skills, Personal e Graph, un filtro di ambito progetto, un modulo modale di
creazione/modifica, la cronologia delle versioni per entità con ripristino, l’upload dell’icona
delle skill e l’export/import JSON. La scheda Memories ha una barra di filtro dei tag (con
gestione dei tag), la barra dell’app ha la ricerca full-text, una finestra di creazione link e
un’azione di migrazione, e la scheda Graph è una vista delle relazioni force-directed con
pan/zoom, trascinamento dei nodi, filtri per tipo di entità ed evidenziazione dei vicini.
Settings → Knowledge collega direttamente alla stessa schermata.

## Curarla bene

1. **Scansiona** ogni progetto attivo una volta (Knowledge → seleziona progetto → scan);
   ripeti la scansione dopo grandi cambiamenti ai suoi file di istruzioni.
2. **Promuovi con criterio**: solo le regole davvero vincolanti dovrebbero essere `critical`
   (vengono iniettate). Usa la stella su una riga e tieni d’occhio il misuratore del budget.
3. **Mantieni il resto su `high`/`normal`** — comunque ricercabile e disponibile via MCP
   senza spendere contesto a ogni turno.
4. **Informazioni personali** per preferenze trasversali ai progetti (fuso orario, editor, denominazione).
5. **Collega le memorie correlate** così i vicini a 1 salto viaggiano insieme.
6. **Installa MCP** per gli agenti che devono cercare nella base e rendere persistenti
   gli apprendimenti; dai l’ambito `read` ai più, `write` dove ti fidi dell’agente.

## Migrazione

Knowledge → menu → **Migrate existing rules** esegue un report **dry-run**: scansiona
tutti i progetti, trova i duplicati che esistono tra progetti (stesso titolo
normalizzato + contenuto) e mostra i conteggi delle regole. Da lì puoi **Merge duplicates**
(li fonde in un’unica riga globale) e/o **Make all rules critical**. Nulla
viene scritto finché non confermi — le azioni distruttive sono esplicite.

## Utile sapere

- Tutto è **locale** a questa istanza ddagent; niente cloud, niente sync.
- L’iniezione avviene **una volta per sessione** (primo turno) — le nuove sessioni recepiscono
  i cambiamenti.
- Le skill scansionate **non vengono iniettate**; sono raggiungibili tramite la ricerca
  MCP, il che mantiene snello il contesto sempre attivo.
- Una regola o una memoria può essere modificata da un agente via MCP; rivedi le modifiche nella
  **History** dell’entità e ripristina una versione precedente se serve.

## API REST

Montata su `/api/knowledge` dietro autenticazione:

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
GET    /context             ?projectId=            (injection preview + budget)
GET    /tags                DELETE /tags/:id
GET    /connections         POST /connections      DELETE /connections/:id
GET    /history             ?entityType=&entityId=&limit=
GET    /stats
GET    /export              POST /import
POST   /scan                { projectId }
POST   /migrate             { projectIds?, dryRun?, dedupe?, promoteRules? }
```

`projectId=global` limita una lista alle righe globali; aggiungere `includeGlobal=true`
a un id di progetto restituisce le righe del progetto più quelle globali.

## Correlati

- [ddagent come server MCP](mcp-server.md) — il catalogo degli strumenti e la configurazione del token
- [Collaborazione in team](teams.md) · [Approvazioni remote](remote-approvals.md)
