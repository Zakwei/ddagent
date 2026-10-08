# Base de conocimiento

<p>
  <a href="../../KNOWLEDGE.md">English</a> ·
  <a href="KNOWLEDGE.pl.md">Polski</a> ·
  <a href="KNOWLEDGE.de.md">Deutsch</a> ·
  <strong>Español</strong> ·
  <a href="KNOWLEDGE.fr.md">Français</a> ·
  <a href="KNOWLEDGE.it.md">Italiano</a> ·
  <a href="KNOWLEDGE.ja.md">日本語</a> ·
  <a href="KNOWLEDGE.ko.md">한국어</a> ·
  <a href="KNOWLEDGE.ru.md">Русский</a> ·
  <a href="KNOWLEDGE.tr.md">Türkçe</a> ·
  <a href="KNOWLEDGE.zh-CN.md">简体中文</a> ·
  <a href="KNOWLEDGE.zh-TW.md">繁體中文</a>
</p>

ddagent incluye una **base de conocimiento local** para tus agentes: memorias, reglas,
skills e información personal, además de etiquetas y relaciones. Vive en la misma
base de datos SQLite que el resto de ddagent (`auth.db`) detrás de un índice
de texto completo FTS5, se gestiona desde la pantalla **Knowledge** del cliente y
tus agentes pueden leerla y escribirla a través de MCP. Está libremente inspirada en
[Contexta](https://github.com/XFABISIEK/Contexta).

La idea es simple: tus reglas y el conocimiento del proyecto dejan de estar dispersos
por archivos de cada herramienta (`AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `skills/`, …)
y pasan a ser un único lugar curado y consultable que todos los agentes pueden usar — los
que leen archivos y los que hablan MCP.

## Cómo lo ve realmente un agente

Hay tres capas, y conviene saber cuál es cuál:

- **Archivos nativos del CLI** — cada herramienta lee su propia configuración por su
  cuenta: Claude Code lee `CLAUDE.md`, Codex/Cursor leen `AGENTS.md`, Cursor lee
  `.cursorrules`, y varias leen `skills/` y `.agents/skills/`. Esto es trabajo del CLI, no
  una decisión del modelo — ddagent no lo desactiva.
- **El prefijo del primer turno de ddagent** — en el primer mensaje de una sesión,
  ddagent antepone el `.ddagent/shared-context.md` del proyecto y un bloque
  `<unified-rules>` (el `AGENTS.md` del workspace, `~/.agents/AGENTS.md` y una breve
  nota de higiene; define `DDAGENT_UNIFIED_RULES=0` para omitirlo). Se basa en
  archivos y es independiente de la base de conocimiento.
- **Recuperación por MCP (bajo demanda)** — cuando instalas el servidor MCP de
  ddagent en un agente, su lista de herramientas incluye `knowledge_get_context`,
  `knowledge_search` y compañía. Siguiendo a Contexta, no se inyecta nada
  automáticamente: el agente llama al constructor de contexto con una consulta y
  recibe de vuelta las reglas `critical` más todo lo que coincida. El modelo decide
  cuándo llamarlo, guiado por las descripciones de las herramientas y por las reglas
  de instrucción que guardes en la base de conocimiento.

Así que «un solo lugar» significa **un solo lugar donde curar el conocimiento**
— no impide (ni puede impedir) que un CLI lea sus propios archivos nativos.
ddagent no inyecta automáticamente la base de conocimiento en las sesiones.

## Entidades

| Entidad | Ámbito | Notas |
|---|---|---|
| Memoria | proyecto o global | `memory_type` (`fact`/`decision`/`note`/`reference`), `priority`, `source`, etiquetas |
| Regla | proyecto o global | conmutador `enabled`; las reglas `critical` siempre las devuelve primero el constructor de contexto |
| Skill | global | nombre único, categoría, icono opcional (base64 data URL) |
| Información personal | global | `key` única |
| Etiqueta / Conexión | — | etiquetas en las memorias; las conexiones enlazan dos entidades cualesquiera |
| Historial | — | cada escritura guarda una instantánea de la entidad para poder revisarla y restaurarla |

Prioridades: `critical > high > normal > low`. Una entidad puede limitarse a un
proyecto o ser global (se aplica en todas partes). `project_id` es una columna normal (sin
clave foránea) porque la tabla de proyectos se reconstruye durante las migraciones.

## Recuperar contexto (bajo demanda)

Los agentes obtienen contexto a través de la herramienta MCP
`knowledge_get_context` (un port fiel del ContextBuilder de Contexta). Dado un
proyecto y una consulta, devuelve, en orden:

- **todas las reglas habilitadas** (de proyecto + globales), `critical` primero (límite 20),
- **memorias** clasificadas por la consulta (FTS), más sus vecinos a 1 salto
  alcanzados a través de conexiones (límite 5); sin consulta, las mejores memorias
  del proyecto por prioridad,
- **skills** clasificadas por la consulta; sin consulta, las skills más recientes,
- **información personal** solo cuando la consulta coincide con ella (límite 3),

renderizado como un bloque Markdown cuyos elementos se truncan por sección
(800/1000/600 caracteres) y se limitan por `maxTokens` (por defecto ~4000); los
elementos que ya no caben se cuentan como omitidos.

El panel muestra un **medidor de contexto de reglas** (`~X / 4000 tok`) para el
proyecto seleccionado: el tamaño del bloque de reglas que toda llamada a
`knowledge_get_context` incluye siempre. No se inyecta nada automáticamente en las
sesiones.

La ordenación de la búsqueda es híbrida, como en `search.rs` de Contexta:
coincidencia **prefix** de FTS5 (`auth` también coincide con `authentication`)
más una pasada difusa por **trigram** que captura erratas y cuasi sinónimos, luego
un rerank por `bm25 + priority + recency`.

## Herramientas MCP (bajo demanda)

El servidor MCP de ddagent (`POST /mcp`) expone la base de conocimiento a cualquier
cliente MCP. Las herramientas de lectura funcionan con un token de ámbito `read`; las de
escritura requieren `write`. Las herramientas de escritura ejecutan la misma validación
que la interfaz y registran historial.

Lectura: `knowledge_search`, `knowledge_get_context`, `knowledge_get_memories`,
`knowledge_get_rules`, `knowledge_get_skills`, `knowledge_get_personal`,
`knowledge_get_graph`, `knowledge_history`.

Escritura: `knowledge_add_memory`, `knowledge_update_memory`,
`knowledge_delete_memory`, y el mismo trío para `rule`, `skill` y `personal`;
más `knowledge_link` / `knowledge_unlink`.

Las herramientas aceptan `projectId` o un `projectPath` que ddagent ya conozca.

### Instalar el servidor en tus agentes

No tienes que editar las configuraciones de los proveedores a mano. Usa **Settings → Agents →
(agente) → MCP → Install ddagent MCP server** (también se ofrece como paso del
onboarding) y elige los agentes — o instálalo para todos. Escribe una entrada HTTP MCP
`ddagent` (ámbito de usuario) que apunta a `<server>/mcp` con un token bearer
`ddagent-mcp` reutilizable de ámbito `write` (reinstalar revoca el anterior). Una vez instalado, las herramientas de ese agente
incluyen el grupo `knowledge_*` junto a `create_task`, `send_message`, etc.

¿Cómo sabe un agente *cuándo* usar MCP? No lo adivina — díselo. Guarda una regla
`critical` como: *«Antes de responder preguntas sobre este proyecto, llama a
`knowledge_get_context`; cuando cierres una decisión, persístela con
`knowledge_add_memory`.»* Como el constructor de contexto siempre devuelve las reglas
`critical`, todos los agentes que llamen a la herramienta reciben las mismas
instrucciones de funcionamiento.

## Escaneo de proyecto

`POST /api/knowledge/scan` importa los archivos de contexto de IA de un proyecto,
clasificados por intención:

- `AGENTS.md`, `CLAUDE.md`, `MUSE.md`, `GEMINI.md`, `CODEX.md`, `.cursorrules`,
  `.muserules` y markdown/`.mdc` bajo `.cursor/rules` se convierten en **reglas**
  (critical + enabled, así que `knowledge_get_context` siempre las devuelve; el
  `AGENTS.md` del workspace se importa como `high` porque el prefijo
  `<unified-rules>` del primer turno ya lo entrega),
- los archivos `SKILL.md` bajo `skills` / `.agents/skills` se convierten en **skills**
  (nombre/descripción del frontmatter),
- cualquier otro markdown escaneado se convierte en **memoria de referencia**.

Cada archivo se rastrea por hash de contenido en `kb_scan_state`, así que un reescaneo solo
toca los archivos cambiados y elimina las entidades cuya fuente desapareció.

## Cliente

La pantalla **Knowledge** (barra de navegación → Knowledge) tiene las pestañas Dashboard,
Memories, Rules, Skills, Personal y Graph, un filtro de ámbito de proyecto, un formulario
modal de crear/editar, historial de versiones por entidad con restauración, subida de iconos de
skills y exportación/importación JSON. La pestaña Memories tiene una barra de filtro de
etiquetas (con gestión de etiquetas), la barra de la app tiene búsqueda de texto completo, un
diálogo de crear enlace y una acción de migración, y la pestaña Graph es una vista de relaciones
dirigida por fuerzas con pan/zoom, arrastre de nodos, filtros por tipo de entidad y resaltado
de vecinos.
El grafo dibuja tus enlaces explícitos más los hubs implícitos — cada entidad con ámbito de proyecto se conecta a su proyecto, y las memorias que comparten una etiqueta se conectan a un nodo de etiqueta — así que siempre muestra estructura.

## Curarlo bien

1. **Escanea** cada proyecto activo una vez (Knowledge → selecciona proyecto → scan);
   vuelve a escanear tras cambios grandes en sus archivos de instrucciones.
2. **Promociona con criterio**: solo las reglas realmente vinculantes deberían ser `critical`
   (siempre las sirve el constructor de contexto). Usa la estrella de una fila y
   vigila el medidor de contexto de reglas.
3. **Mantén el resto en `high`/`normal`** — siguen siendo consultables y disponibles por MCP
   solo cuando una consulta coincide, así que no cuestan nada cuando son irrelevantes.
4. **Información personal** para preferencias entre proyectos (zona horaria, editor, nomenclatura).
5. **Enlaza memorias relacionadas** para que los vecinos a 1 salto viajen con ellas.
6. **Instala MCP** en los agentes que deban consultar la base y persistir
   aprendizajes. La instalación con un clic usa un token `write`; para un agente de
   solo lectura, crea un token `read` en los tokens del servidor MCP de ddagent y
   configura ese agente a mano (consulta
   [ddagent como servidor MCP](../mcp-server.md#manual-client-config)).

## Migración

Knowledge → menú → **Migrate existing rules** ejecuta un informe **dry-run**: escanea
todos los proyectos, encuentra duplicados que existen entre proyectos (mismo título
normalizado + contenido) y muestra recuentos de reglas. Desde ahí puedes **Merge duplicates**
(los fusiona en una sola fila global) y/o **Make all rules critical**. No se
escribe nada hasta que confirmes — las acciones destructivas son explícitas.

El **Dashboard** también tiene un único botón **Importar todo en ddagent**: ejecuta el escaneo del proyecto y la importación de skills de agentes en una sola acción, con la misma vista previa dry-run y los toggles opcionales de fusión de duplicados / promoción. Solo lee los archivos de tus agentes y escribe en la propia base de datos de ddagent — no se toca ningún archivo ni configuración de la CLI (la única acción que escribe en la configuración de un agente es la separada "Install ddagent MCP server").

El mismo menú tiene **Importar skills de agentes**: lista las skills globales/predeterminadas que tus agentes ya incluyen o tienen instaladas (ámbitos de usuario / sistema / plugin) e importa las que faltan a la base de conocimiento como skills. Primero es un dry-run, e idempotente — un nombre que ya existe se omite. Las skills de ámbito de proyecto las importa el escaneo de proyecto.

## Conviene saberlo

- Todo es **local** a esta instancia de ddagent; sin nube, sin sincronización.
- La base de conocimiento **no se inyecta automáticamente** — los agentes la recuperan
  por MCP bajo demanda (modelo Contexta). Los agentes sin el servidor MCP instalado no
  obtienen nada de ella.
- Las skills escaneadas son accesibles a través de MCP (`knowledge_get_context` /
  `knowledge_search`), no se empujan al contexto.
- Un agente puede editar una regla o una memoria por MCP; revisa los cambios en el
  **History** de la entidad y restaura una versión anterior si hace falta.

## API REST

Montada en `/api/knowledge` detrás de autenticación:

```
GET    /memories            ?projectId=&includeGlobal=&priority=&tag=&memoryType=&limit=&offset=
POST   /memories            PATCH /memories/:id   DELETE /memories/:id
GET    /rules               ?projectId=&includeGlobal=&priority=&enabledOnly=&limit=&offset=
POST   /rules               PATCH /rules/:id       DELETE /rules/:id
GET    /skills              ?category=&limit=&offset=
POST   /skills              PATCH /skills/:id      DELETE /skills/:id
GET    /personal            POST /personal         PATCH/DELETE /personal/:id
GET    /search              ?q=&type=&projectId=&limit=
GET    /graph               ?projectId=&types=&limit=
GET    /context             ?projectId=            (vista previa del contexto de reglas: tamaño + presupuesto)
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

`projectId=global` restringe una lista a las filas globales; añadir `includeGlobal=true`
a un id de proyecto devuelve las filas del proyecto más las globales.

## Relacionado

- [ddagent como servidor MCP](../mcp-server.md) — el catálogo de herramientas y la configuración del token
- [Colaboración en equipo](../teams.md) · [Aprobaciones remotas](../remote-approvals.md)
