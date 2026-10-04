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
- **Inyección de ddagent** — en el primer turno de una sesión ddagent antepone un
  bloque `<knowledge>` (detalles abajo). Funciona para todos los proveedores y no
  necesita configuración por parte del agente.
- **Herramientas MCP** — cuando instalas el servidor MCP de ddagent en un agente, su lista
  de herramientas incluye `knowledge_search` y compañía. El modelo decide cuándo
  llamarlas, guiado por las descripciones de las herramientas y por las reglas de
  instrucción que guardes en la base de conocimiento.

Así que «un solo lugar» significa **un solo lugar donde curar el contenido inyectado y un solo presupuesto**
— no impide (ni puede impedir) que un CLI lea sus propios archivos nativos. Para evitar
duplicados mantenemos el `AGENTS.md` del workspace en prioridad `high`, de modo que el bloque
de conocimiento nunca repita lo que unified-rules ya inyecta.

## Entidades

| Entidad | Ámbito | Notas |
|---|---|---|
| Memoria | proyecto o global | `memory_type` (`fact`/`decision`/`note`/`reference`), `priority`, `source`, etiquetas |
| Regla | proyecto o global | conmutador `enabled`; las reglas `critical` se inyectan en las sesiones |
| Skill | global | nombre único, categoría, icono opcional (base64 data URL) |
| Información personal | global | `key` única |
| Etiqueta / Conexión | — | etiquetas en las memorias; las conexiones enlazan dos entidades cualesquiera |
| Historial | — | cada escritura guarda una instantánea de la entidad para poder revisarla y restaurarla |

Prioridades: `critical > high > normal > low`. Una entidad puede limitarse a un
proyecto o ser global (se aplica en todas partes). `project_id` es una columna normal (sin
clave foránea) porque la tabla de proyectos se reconstruye durante las migraciones.

## Inyección en el primer turno (lo que recibe todo agente, automáticamente)

En el **primer** mensaje saliente de una sesión, ddagent antepone un bloque
`<knowledge>` que contiene:

- **reglas** `critical` (de proyecto + globales, solo habilitadas),
- **memorias** `critical`,
- todas las entradas de **información personal**,
- los **vecinos a 1 salto** de las memorias incluidas (alcanzados a través de
  conexiones explícitas).

Todo el bloque está limitado a ~4000 tokens. Viaja por la misma puerta del primer turno que
`.ddagent/shared-context.md` y unified rules, así que no cuesta tokens por turno.
Define `DDAGENT_KNOWLEDGE=0` para desactivarlo.

El panel muestra un **medidor de contexto inyectado** (`~X / 4000 tok`) para el
proyecto seleccionado, así puedes ver y controlar qué entra en el contexto.

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

No tienes que editar las configuraciones de los proveedores a mano. Usa **Settings → MCP →
Install ddagent MCP server** (también se ofrece como paso del onboarding) y elige los
agentes — o instálalo para todos. Escribe una entrada HTTP MCP `ddagent` (ámbito de
usuario) que apunta a `<server>/mcp` con un token bearer `ddagent-mcp` reutilizable
(reinstalar revoca el anterior). Una vez instalado, las herramientas de ese agente
incluyen el grupo `knowledge_*` junto a `create_task`, `send_message`, etc.

¿Cómo sabe un agente *cuándo* usar MCP? No lo adivina — díselo. Guarda una regla
`critical` como: *«Antes de responder preguntas sobre este proyecto, llama a
`knowledge_search`; cuando cierres una decisión, persístela con
`knowledge_add_memory`.»* Como esa regla se inyecta en cada primer turno, todos
tus agentes reciben las mismas instrucciones de funcionamiento.

## Escaneo de proyecto

`POST /api/knowledge/scan` importa los archivos de contexto de IA de un proyecto,
clasificados por intención:

- `AGENTS.md`, `CLAUDE.md`, `MUSE.md`, `GEMINI.md`, `CODEX.md`, `.cursorrules`,
  `.muserules` y markdown/`.mdc` bajo `.cursor/rules` se convierten en **reglas**
  (critical + enabled, para que lleguen al contexto del agente; el `AGENTS.md` del
  workspace es `high` para evitar la doble inyección con unified-rules),
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
de vecinos. Settings → Knowledge enlaza directamente con la misma pantalla.

## Curarlo bien

1. **Escanea** cada proyecto activo una vez (Knowledge → selecciona proyecto → scan);
   vuelve a escanear tras cambios grandes en sus archivos de instrucciones.
2. **Promociona con criterio**: solo las reglas realmente vinculantes deberían ser `critical`
   (se inyectan). Usa la estrella de una fila y vigila el medidor de presupuesto.
3. **Mantén el resto en `high`/`normal`** — siguen siendo consultables y disponibles por MCP
   sin gastar contexto en cada turno.
4. **Información personal** para preferencias entre proyectos (zona horaria, editor, nomenclatura).
5. **Enlaza memorias relacionadas** para que los vecinos a 1 salto viajen con ellas.
6. **Instala MCP** en los agentes que deban consultar la base y persistir
   aprendizajes; da ámbito `read` a la mayoría y `write` donde confíes en el agente.

## Migración

Knowledge → menú → **Migrate existing rules** ejecuta un informe **dry-run**: escanea
todos los proyectos, encuentra duplicados que existen entre proyectos (mismo título
normalizado + contenido) y muestra recuentos de reglas. Desde ahí puedes **Merge duplicates**
(los fusiona en una sola fila global) y/o **Make all rules critical**. No se
escribe nada hasta que confirmes — las acciones destructivas son explícitas.

## Conviene saberlo

- Todo es **local** a esta instancia de ddagent; sin nube, sin sincronización.
- La inyección ocurre **una vez por sesión** (primer turno) — las sesiones nuevas recogen
  los cambios.
- Las skills escaneadas **no se inyectan**; son accesibles mediante la búsqueda MCP,
  lo que mantiene ligero el contexto siempre activo.
- Un agente puede editar una regla o una memoria por MCP; revisa los cambios en el
  **History** de la entidad y restaura una versión anterior si hace falta.

## API REST

Montada en `/api/knowledge` detrás de autenticación:

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

`projectId=global` restringe una lista a las filas globales; añadir `includeGlobal=true`
a un id de proyecto devuelve las filas del proyecto más las globales.

## Relacionado

- [ddagent como servidor MCP](mcp-server.md) — el catálogo de herramientas y la configuración del token
- [Colaboración en equipo](teams.md) · [Aprobaciones remotas](remote-approvals.md)
