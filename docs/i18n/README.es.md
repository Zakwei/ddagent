<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>Una sola UI para todos tus agentes de código con IA.</strong><br>
  Servidor autoalojado y cliente Flutter (web, Linux, Windows y Android) para Claude Code, Codex, Cursor CLI, OpenCode, Devin, Command Code y Antigravity — sesiones, archivos, git, terminales y tareas en un solo lugar.</p>

  <p>
    <img src="https://img.shields.io/github/v/release/Zakwei/ddagent?label=versión&amp;color=0066FF" alt="versión">
    <img src="https://img.shields.io/badge/license-AGPL--3.0-blue" alt="licencia: AGPL-3.0">
    <img src="https://img.shields.io/badge/node-%E2%89%A522-339933" alt="node >= 22">
    <img src="https://img.shields.io/badge/self--hosted-yes-success" alt="autoalojado">
  </p>

  <p>
    <a href="#instalación">Instalación</a> ·
    <a href="https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md">Contribuir</a> ·
    <a href="https://github.com/Zakwei/ddagent/issues">Informes de errores</a>
  </p>

  <p>
    <a href="../../README.md">English</a> ·
    <a href="README.pl.md">Polski</a> ·
    <a href="README.de.md">Deutsch</a> ·
    <strong>Español</strong> ·
    <a href="README.fr.md">Français</a> ·
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
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/desktop-main.png" alt="vista de chat de ddagent" width="78%">&nbsp;
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/mobile-chat.png" alt="vista móvil de ddagent" width="20%">
</p>

<table>
  <tr>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/sessions.png" alt="Sesiones recientes de Claude Code y Codex"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/kanban-board.png" alt="Tablero kanban que dirige las ejecuciones de agentes"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/git-panel.png" alt="Panel de Git con staging por hunks"></td>
  </tr>
  <tr>
    <td align="center"><sub>Las sesiones de todos los agentes en una sola lista</sub></td>
    <td align="center"><sub>Tablero kanban — las tarjetas lanzan ejecuciones de agentes</sub></td>
    <td align="center"><sub>Panel de Git — diff, staging de hunks, commit</sub></td>
  </tr>
</table>

---

## ¿Qué es ddagent?

ddagent se ejecuta en tu propia máquina o VPS y coloca una UI pulida sobre los agentes de código que ya usas. El servidor lee las sesiones de cada agente directamente de su propio historial en disco (`~/.claude`, `~/.codex`, `~/.cursor`, OpenCode, Devin, …), así que tus conversaciones existentes aparecen sin necesidad de importar nada. Solo se indexan localmente los metadatos de las sesiones; no se envía nada a terceros.

Conéctate desde el cliente Flutter en tu ordenador, tu móvil o el navegador. Tu máquina, tus agentes, tus datos.

## Características

- **Sesiones multiagente** — inicia y retoma en paralelo sesiones de siete CLI de agentes, con streaming en directo por WebSocket
- **Orquestador automático** — las sesiones «Auto» asignan cada tarea a un agente y un modelo adecuados, teniendo en cuenta la cuota de suscripción restante, y delegan trabajo en sesiones hijas
- **Espacio de trabajo dividido** — hasta seis paneles (chat, terminal, navegador, vista previa, editor, git, notas) en una sola ventana
- **Explorador y editor de archivos** — recorre el workspace y edita código en el editor integrado
- **Panel de Git** — haz staging de archivos o de hunks individuales, commit (con mensajes generados por IA), diff, cambio de rama, pull/push y restauración de checkpoints sin salir de la UI
- **Terminal integrada** — una shell completa por workspace
- **Tablero kanban** — mueve una tarjeta para lanzar un agente sobre ella (opcionalmente en su propio worktree); el agente informa cuando termina
- **TaskMaster** — convierte PRD en tareas y haz su seguimiento en un tablero de tareas
- **Cola de mensajes** — los mensajes enviados mientras un agente está ocupado se encolan en el servidor y sobreviven a recargas y cambios de dispositivo
- **Gestión de MCP** — añade, edita y sincroniza servidores MCP entre agentes
- **Base de conocimiento** — una memoria local y consultable para todos los agentes: reglas, skills, recuerdos e información personal, recuperados bajo demanda mediante MCP ([documentación](KNOWLEDGE.es.md))
- **Skills y reglas** — gestiona las skills de los agentes y las reglas compartidas desde un solo lugar
- **Cuota y uso** — consumo de tokens y límites de suscripción por agente, de un vistazo
- **Browser-use** — sesiones de navegador controladas por el agente para investigación y pruebas, con un panel de navegador en directo
- **Worktrees** — crea worktrees de git aislados por tarea, con scripts de setup/run por worktree y una vista previa autenticada del dev-server en directo
- **Aprobaciones remotas** — aprueba permisos de herramientas desde Telegram, Discord o la app de Android ([documentación](https://github.com/Zakwei/ddagent/blob/main/docs/remote-approvals.md))
- **Entrada de voz** — dicta prompts a través de un endpoint de voz a texto compatible con Whisper
- **Difusión a agentes y memoria compartida** — envía un mensaje a todos los agentes a la vez y mantén notas por proyecto que todos leen
- **Cambio entre varias cuentas** — cuentas con nombre por proveedor, con overrides de variables de entorno por sesión
- **Planificador** — ejecuciones de agentes desatendidas basadas en cron, con la opción de mantener el dispositivo despierto mientras haya ejecuciones activas
- **Colaboración en equipo** — roles (owner/member/viewer), enlaces de invitación, responsables, comentarios, presencia y un feed de actividad en el tablero ([documentación](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md))
- **Servidor MCP** — permite que clientes MCP externos (Claude Desktop, OpenClaw) listen sesiones, creen tareas y envíen mensajes a sesiones ([documentación](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Notificaciones y TTS** — notificaciones push, de Telegram y de Discord cuando una sesión te necesita, además de lectura en voz alta opcional de las respuestas
- **Paleta de comandos** — `Ctrl/Cmd+Shift+K` para buscar en sesiones y mensajes, saltar a cualquier página o ejecutar acciones rápidas
- **Sandboxes de Docker** — ejecuta agentes en Docker Sandboxes aisladas mediante microVM ([documentación](https://github.com/Zakwei/ddagent/blob/main/docker/README.md))
- **Cliente Flutter** — una sola base de código para web, Linux, Windows y Android; **12 idiomas**, temas oscuro y claro

## Agentes compatibles

| Agente | Cómo se conecta |
|---|---|
| **Claude Code** | Claude Agent SDK; descubre automáticamente las sesiones de `~/.claude`; sincronización de MCP y ajustes con la CLI nativa |
| **Codex** | Codex SDK; sesiones locales y transcripciones de `~/.codex` |
| **Cursor CLI** | `cursor-agent` con salida JSON en streaming; chats locales de `~/.cursor` |
| **OpenCode** | `opencode serve`; sesiones locales de la base de datos de OpenCode |
| **Devin** | `devin acp` (Agent Client Protocol); transcripciones locales |
| **Command Code** | `command-code acp` (Agent Client Protocol); transcripciones de `~/.commandcode` |
| **Antigravity** | CLI `agy` en modo headless; conversaciones indexadas desde `~/.gemini/antigravity-cli` |

Las CLI de los agentes deben estar instaladas y con la sesión iniciada en la máquina del servidor. Tú aportas tus propias suscripciones — ddagent proporciona el entorno, no la IA.

## Instalación

ddagent tiene dos partes: el **servidor**, que se ejecuta junto a tus agentes y expone una API REST/WebSocket, y el **cliente**, que se conecta a él. El servidor necesita **Node.js 22+** (los tarballs precompilados requieren Node.js 22.x, porque sus módulos nativos están compilados para esa versión).

### Servidor — script de instalación

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

Requiere `git`, Node.js 22+ y `npm`. El script clona una etiqueta de release en `~/.ddagent/app`, instala las dependencias, compila el backend y genera un lanzador `start.sh`. Pasa las opciones después de `bash -s --`:

| Opción | Descripción |
|---|---|
| `--version vX.Y.Z` | Instala una release concreta (por defecto: la más reciente) |
| `--dir <path>` | Directorio de instalación (por defecto: `~/.ddagent/app`) |
| `--systemd` | Instala y habilita un servicio de usuario de systemd llamado `ddagent` |
| `--port <port>` | Puerto del servicio systemd (por defecto: `3001`) |

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash -s -- --systemd --port 3001
```

Después, inicia el servidor:

```bash
~/.ddagent/app/start.sh        # API on http://<host>:3001 (set SERVER_PORT to change)
```

### Servidor — tarball precompilado

Sin paso de compilación: descarga `ddagent-server-<version>-<os>-<arch>.tar.gz` (`linux-x64`, `mac-arm64` o `win-x64`) desde [Releases](https://github.com/Zakwei/ddagent/releases), descomprímelo y ejecuta el lanzador:

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh             # start.bat on Windows
```

Cada tarball incluye una suma de comprobación `.sha256`. Los ajustes van en un archivo `.env` opcional junto a `start.sh`.

### Cliente

Descarga un cliente precompilado desde [Releases](https://github.com/Zakwei/ddagent/releases):

| Plataforma | Archivo |
|---|---|
| Windows x64 | `ddagent-flutter-windows-x64-<tag>-setup.exe` (instalador) o `.zip` (portable) |
| Linux x64 | `ddagent-flutter-linux-x64-<tag>.deb` o `.tar.gz` |
| Android | `ddagent-flutter-android-<tag>.apk` |
| Web | `ddagent-flutter-web-<tag>.zip` |

En el primer inicio, introduce la URL de tu servidor (por ejemplo `http://my-vps:3001`) y crea la primera cuenta. En Windows y Linux x64, el cliente de escritorio también puede descargar y ejecutar un servidor local por ti («Este dispositivo» en la pantalla de conexión).

La versión web no tiene pantalla de inicio de sesión y llama a la API en su propio origen, así que debe servirse detrás de un proxy inverso situado delante de un servidor en modo plataforma de un solo usuario (`VITE_IS_PLATFORM=true`, que desactiva la autenticación). En un checkout del código fuente, `node scripts/serve-flutter-web.cjs` sirve `flutter/build/web` en el puerto 8085 y redirige la API y los WebSockets al servidor en `FLUTTER_BACKEND_PORT` (por defecto `10087`). Expón esta configuración solo en una red de confianza.

Para compilar el cliente tú mismo:

```bash
cd flutter
flutter pub get
flutter build linux --release      # or: windows, apk, web
```

### Actualización

En el cliente, **Ajustes → Acerca de → Actualizaciones** tiene un botón independiente para cada parte:

| Parte | Cómo se actualiza |
|---|---|
| **Servidor** | Las instalaciones con el script de instalación o con git pasan a la release más reciente; las instalaciones desde tarball descargan el siguiente tarball, lo verifican (`.sha256`) y lo instalan al reiniciar, y vuelven atrás automáticamente si el servidor no arranca. `start.sh` / `start.bat` reinician el servidor por sí solos — no hace falta systemd. La app reinstala el servidor local de un cliente de escritorio («Este dispositivo»). |
| **Interfaz web** | Se sustituye con el zip web de la release cuando la sirve el servidor (`DDAGENT_WEB_DIR`, o `flutter/build/web` servido por `scripts/serve-flutter-web.cjs`); además se actualiza con cada actualización del servidor. |
| **Esta app** | Android instala el nuevo APK; Windows y Linux descargan la nueva versión en segundo plano y la instalan al salir de la app. |

Los tarballs de las releases se compilan para Node.js 22 — el servidor rechaza un tarball compilado para otra versión mayor de Node.js. Los servidores con 0.8.12 o anterior (script de instalación o tarball) se actualizan a 0.8.13 una sola vez a mano — vuelve a ejecutar `install.sh --version v0.8.13` o descomprime el nuevo tarball sobre el anterior — y, a partir de ahí, desde la interfaz.

### Desde el código fuente

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run build && node dist-server/server/index.js   # API on http://localhost:3001
```

### Sandbox de Docker (experimental)

```bash
ddagent sandbox ~/my-project
```

Ejecuta ddagent y un agente (Claude Code o Codex) dentro de una Docker Sandbox aislada mediante microVM. Requiere la CLI `sbx` — consulta [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md).

## CLI

En un checkout del código fuente o de `install.sh`, `ddagent` a continuación significa `node dist-server/server/modules/cli/cli.js` (tiene shebang, así que `./dist-server/server/modules/cli/cli.js` también funciona).

| Comando | Descripción |
|---|---|
| `ddagent` / `ddagent start` | Inicia el servidor (comando por defecto) |
| `ddagent status` | Muestra la versión y las ubicaciones del archivo de configuración, la base de datos y los proyectos de Claude |
| `ddagent sandbox <workspace>` | Crea e inicia un sandbox de Docker; `ddagent sandbox help` lista `ls`, `start`, `stop`, `rm`, `logs` |
| `ddagent browser-use-mcp` | Ejecuta el servidor MCP de browser-use por stdio |
| `ddagent version` | Muestra la versión |
| `ddagent help` | Muestra la ayuda |

| Opción | Descripción |
|---|---|
| `-p, --port <port>` | Puerto del servidor (sobrescribe `SERVER_PORT`) |
| `--database-path <path>` | Ubicación personalizada de la base de datos (sobrescribe `DATABASE_PATH`) |

## Configuración

El servidor lee un archivo `.env` opcional de su directorio de instalación (junto a `start.sh`); las variables de entorno reales tienen prioridad. Ejecuta `ddagent status` para ver qué archivo se está usando.

| Variable | Valor por defecto | Descripción |
|---|---|---|
| `SERVER_PORT` | `3001` | Puerto de API + WebSocket (`PORT` se acepta como alias heredado) |
| `HOST` | `0.0.0.0` | Dirección de escucha (`127.0.0.1` solo para localhost) |
| `DATABASE_PATH` | `~/.ddagent/auth.db` | Base de datos SQLite (usuarios, ajustes, tokens) |
| `WORKSPACES_ROOT` | directorio personal | Los proyectos deben estar dentro de este directorio |
| `JWT_SECRET` | generado automáticamente | Secreto para firmar los tokens de inicio de sesión (se genera y guarda por instalación) |
| `API_KEY` | sin definir | Si se define, las peticiones a la API deben enviarla en la cabecera `x-api-key` |
| `CLAUDE_CLI_PATH` | `claude` | Binario personalizado de la CLI de Claude Code |
| `CONTEXT_WINDOW` | `200000` | Ventana de contexto de Claude de respaldo, usada hasta que el SDK informa de la ventana real del modelo |
| `STT_ENDPOINT_URL` / `STT_API_KEY` / `STT_MODEL` | `https://api.openai.com/v1` / sin definir / `whisper-1` | Voz a texto para la entrada de voz (también configurable en Ajustes) |
| `VITE_IS_PLATFORM` | `false` | Modo plataforma de un solo usuario: omite la autenticación (necesario para el cliente web) |

Consulta [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example) para más detalles.

## Desarrollo

```bash
npm install
npm run dev               # start the backend from source (tsx, no reload)
npm run server:dev-watch  # same, restarting on file changes
npm run build             # compile the server to dist-server/
npm test                  # backend tests
npm run typecheck         # TypeScript check
npm run lint              # ESLint
```

Cliente (Flutter 3.47.5 stable):

```bash
cd flutter
flutter pub get
flutter run -d linux --dart-define=DEFAULT_SERVER_URL=http://localhost:3001
dart format --line-length 100 lib test
flutter analyze
flutter test
```

El código del backend sigue la arquitectura modular de `server/modules/`; consulta [`server/modules/providers/README.md`](https://github.com/Zakwei/ddagent/blob/main/server/modules/providers/README.md) para los detalles internos de los proveedores.

## Contribuir

Las correcciones de errores son bienvenidas — consulta [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md). Para informar de una vulnerabilidad, consulta [SECURITY.md](https://github.com/Zakwei/ddagent/blob/main/SECURITY.md).

---

<div align="center">
  <sub>Creado para la comunidad de Claude Code, Codex, Cursor, OpenCode, Devin, Command Code y Antigravity.</sub>
</div>
