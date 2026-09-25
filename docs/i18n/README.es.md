<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>Una sola UI para todos tus agentes de código con IA.</strong><br>
  Interfaz web y móvil autoalojada para Claude Code, Codex, Cursor CLI, OpenCode y Devin — sesiones, archivos, git, terminales y tareas en un solo lugar.</p>

  <p>
    <img src="https://img.shields.io/badge/version-0.5.9-0066FF" alt="versión">
    <img src="https://img.shields.io/badge/license-AGPL--3.0-blue" alt="licencia: AGPL-3.0">
    <img src="https://img.shields.io/badge/node-%E2%89%A522-339933" alt="node >= 22">
    <img src="https://img.shields.io/badge/self--hosted-yes-success" alt="self-hosted">
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

---

## ¿Qué es ddagent?

ddagent se ejecuta en tu propia máquina o VPS y te ofrece una interfaz web pulida sobre los agentes de código que ya usas. Descubre sus sesiones directamente desde el disco — tu historial de `~/.claude`, Codex y Devin aparece al instante, nada se duplica ni se sincroniza con terceros.

Ábrelo desde cualquier navegador de tu red o desde tu teléfono. Tu máquina, tus agentes, tus datos.

## Características

- **Sesiones multiagente** — ejecuta y reanuda sesiones de Claude Code, Codex, Cursor CLI, OpenCode y Devin en paralelo, con streaming en vivo por WebSocket
- **Paneles divididos** — paneles de chat, terminal, navegador y archivos en un solo workspace
- **Explorador y editor de archivos** — navega por el workspace, edita código con CodeMirror
- **Panel Git** — stage, commit, diff y cambio de ramas sin salir de la UI
- **Shell integrada** — terminal completo por workspace, más una pestaña de shell independiente
- **Tablero de tareas** — vista kanban impulsada por TaskMaster; convierte PRDs en tareas ejecutables
- **Gestión de MCP** — añade, edita y sincroniza servidores MCP entre agentes
- **Navegador de skills** — gestiona las skills de los agentes desde la UI
- **Cuota y uso** — uso de tokens y límites de suscripción por agente, de un vistazo
- **Browser-use** — sesiones de navegador dirigidas por el agente para investigación y pruebas
- **Worktrees** — crea worktrees de git aislados por tarea, con scripts de setup/run por worktree y una vista previa autenticada del dev-server en vivo
- **Aprobaciones remotas** — aprueba permisos de herramientas desde Telegram, Discord o la app móvil
- **Entrada de voz** — dicta prompts mediante un endpoint STT compatible con Whisper
- **Broadcast a agentes y memoria compartida** — envía mensajes a todos los agentes a la vez y mantén notas por proyecto que todos leen
- **Cambio multicuenta** — cuentas con nombre por proveedor con overrides de env por sesión
- **Programador** — ejecuciones de agentes por cron, con keep-awake en web/escritorio
- **Colaboración en equipo** — roles (owner/member/viewer), enlaces de invitación, asignados, comentarios, presencia y feed de actividad en el tablero ([documentación](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md))
- **Servidor MCP** — permite que clientes MCP externos (Claude Desktop, OpenClaw) creen tareas y envíen mensajes a sesiones ([documentación](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Notificaciones y TTS** — recibe un aviso (o lectura en voz alta) cuando una sesión te necesita
- **Sandboxes Docker** — ejecuta agentes en entornos aislados por microVM ([documentación](https://github.com/Zakwei/ddagent/blob/main/docker/README.md))
- **Compañero de escritorio** — app Electron opcional; **12 idiomas**, temas oscuro y claro

## Agentes compatibles

| Agente | Cómo se conecta |
|---|---|
| **Claude Code** | Descubre automáticamente las sesiones de `~/.claude`; sincronización de MCP y ajustes con el CLI nativo |
| **Codex** | Sesiones CLI locales y transcripciones |
| **Cursor CLI** | Sesiones CLI locales |
| **OpenCode** | Sesiones locales y ubicaciones de skills |
| **Devin** | Sesiones CLI/ACP mediante sincronización local |

Tú aportas tus propias suscripciones — ddagent proporciona el entorno, no la IA.

## Instalación

Requiere **Node.js 22+** en la máquina que ejecuta el servidor. El servidor sirve la interfaz web y la API REST/WS a la que se conectan remotamente las apps de escritorio y móvil.

### Servidor autoalojado — script de instalación

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

Clona el último tag de release en `~/.ddagent/app`, compila la UI web + backend y deja un launcher `start.sh`. Opciones: `--version vX.Y.Z` · `--dir <path>` · `--port <port>` · `--systemd` (instala y habilita una unidad systemd de usuario). Vuelve a ejecutarlo con `--version` para actualizar en el mismo lugar.

Después:

```bash
~/.ddagent/app/start.sh        # → http://localhost:3001
```

### Servidor autoalojado — tarball precompilado

Sin paso de compilación — descarga `ddagent-server-<version>-<os>-<arch>.tar.gz` desde [Releases](https://github.com/Zakwei/ddagent/releases), descomprímelo y ejecútalo:

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh           # start.bat on Windows
```

### App de escritorio

Descarga el instalador para tu SO desde [Releases](https://github.com/Zakwei/ddagent/releases): `.dmg` (macOS) · `.exe` (Windows) · `.AppImage` / `.deb` (Linux).

Funciona standalone — el servidor está embebido, nada más que instalar — o en modo remoto contra la URL de un servidor autoalojado. Actualizaciones automáticas mediante los feeds `latest*.yml` del release.

### App móvil (vista previa)

Descarga `ddagent-mobile-<version>.apk` desde [Releases](https://github.com/Zakwei/ddagent/releases) e instálalo en tu dispositivo Android; la app se conecta a la URL de un servidor autoalojado.

### Desde el código fuente

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run dev        # server :3001 + Vite :5173 with HMR
```

### Sandbox Docker (experimental)

```bash
ddagent sandbox ~/my-project
```

Ejecuta el agente en un sandbox aislado por hipervisor. Consulta [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md).

## CLI

En un checkout del código fuente o de `install.sh`, `ddagent` abajo significa `node dist-server/server/modules/cli/cli.js` (tiene shebang, así que `./dist-server/server/modules/cli/cli.js` también funciona).

| Comando | Descripción |
|---|---|
| `ddagent` | Inicia el servidor |
| `ddagent start` | Inicia el servidor |
| `ddagent status` | Muestra las ubicaciones de configuración y datos |
| `ddagent version` | Imprime la versión |
| `ddagent help` | Muestra la ayuda |

## Configuración

Todos los ajustes viven en un solo archivo env — ejecuta `ddagent status` para ver desde dónde se lee el tuyo.

| Variable | Por defecto | Descripción |
|---|---|---|
| `SERVER_PORT` | `3001` | Puerto de API + WebSocket |
| `VITE_PORT` | `5173` | Puerto del dev-server |
| `HOST` | `0.0.0.0` | Dirección de bind (`127.0.0.1` solo para localhost) |
| `DATABASE_PATH` | auto | Ubicación de la base de datos de autenticación |
| `CONTEXT_WINDOW` | `160000` | Tokens máximos por sesión |
| `CLAUDE_CLI_PATH` | `claude` | Ruta personalizada del binario de Claude CLI |

Lista completa en [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example).

## Desarrollo

```bash
npm run dev            # dev mode (server :3001 + vite :5173)
npm run build          # client + server production build
npm run test:client    # frontend tests
npm test               # backend tests
npm run typecheck      # TypeScript check
```

El código de backend sigue la arquitectura de módulos descrita en `server/modules/` — consulta `server/modules/providers/README.md` para los detalles internos de los providers.

## Contribuir

Los bugfixes son bienvenidos — consulta [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md).

---

<div align="center">
  <sub>Construido para la comunidad de Claude Code, Cursor, Codex, OpenCode y Devin.</sub>
</div>
