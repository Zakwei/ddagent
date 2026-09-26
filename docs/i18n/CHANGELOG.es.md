# Registro de cambios

Todos los cambios importantes de ddagent se documentan aquí.

El formato sigue [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
y este proyecto se adhiere a [Semantic Versioning](https://semver.org/).

<p>
  <a href="../../CHANGELOG.md">English</a> ·
  <a href="CHANGELOG.pl.md">Polski</a> ·
  <a href="CHANGELOG.de.md">Deutsch</a> ·
  <strong>Español</strong> ·
  <a href="CHANGELOG.fr.md">Français</a> ·
  <a href="CHANGELOG.it.md">Italiano</a> ·
  <a href="CHANGELOG.ja.md">日本語</a> ·
  <a href="CHANGELOG.ko.md">한국어</a> ·
  <a href="CHANGELOG.ru.md">Русский</a> ·
  <a href="CHANGELOG.tr.md">Türkçe</a> ·
  <a href="CHANGELOG.zh-CN.md">简体中文</a> ·
  <a href="CHANGELOG.zh-TW.md">繁體中文</a>
</p>

## [0.6.2] - 2026-09-26

### Correcciones

- Móvil: Ajustes mostraba una etiqueta fija «0.1.0 (mobile scaffold)» — ahora muestra la versión real de la app; los APK de release llevan la versión del release, así Android puede actualizar in situ

## [0.6.1] - 2026-09-26

### Correcciones

- Móvil: el selector de modelo no estaba disponible en chats nuevos, workspace multipanel inalcanzable
- Móvil: los paneles del split workspace ahora incrustan vistas de chat reales

## [0.6.0] - 2026-09-26

### Novedades

- **Proveedor orquestado Auto** — enrutamiento de modelos, DAG del planificador y delegación con tarjetas de enrutamiento/plan/delegación/resumen en el chat, además de una pestaña de orquestación en Configuración
- **Móvil: paridad nativa completa** — cada pantalla es ahora nativa: Archivos (CRUD, búsqueda, lightbox), Control de código fuente (staging de hunks, diff dividido, grafo de commits, worktrees), Tareas (editor PRD, edición de detalles), Tablero de agentes, Cuota y uso, terminal, editor y todas las pestañas de Configuración
- **Móvil:** asistente de incorporación, asistente de creación de proyectos (explorador de carpetas, clonación desde GitHub, revisión), paleta de comandos con búsqueda global, cuadrícula dividida del espacio de trabajo, panel de configuración rápida, panel en vivo de browser-use
- **Móvil:** cola de mensajes sin conexión, exportación de chat (PDF/md/html/text), búsqueda en transcripciones, comparación de sesiones

### Correcciones

- OpenCode: filas de sesión duplicadas por instantáneas de texto transmitidas, los prompts de la herramienta de preguntas no aparecían
- La barra fija de Revisión/Búsqueda recortaba el primer mensaje

## [0.5.9] - 2026-09-25

Primera versión pública de código abierto — **AGPL-3.0-only**.

### Novedades

- **Colaboración en equipo** — sesiones compartidas, mensajes de difusión, bandeja de entrada del agente, memoria compartida por proyecto
- **Servidor MCP** — los clientes MCP externos (Claude Desktop, OpenClaw) pueden crear tareas y enviar mensajes a las sesiones mediante `POST /mcp` ([documentación](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Aprobaciones remotas** — aprueba acciones del agente desde Telegram o Discord ([documentación](https://github.com/Zakwei/ddagent/blob/main/docs/remote-approvals.md))
- **Programador** — programaciones cron para ejecuciones del agente con prevención de suspensión
- **Cuentas de proveedor nombradas** — anulaciones de variables de entorno y credenciales por sesión
- **Entrada de voz (STT)** — endpoint compatible con Whisper en el compositor
- **Worktrees** — scripts de configuración y ejecución por repositorio con ejecutor de servidor de desarrollo
- **Vista previa** — proxy de vista previa del servidor de desarrollo autenticado con túnel WS
- **Móvil** — búsqueda de sesiones, notificaciones push de aprobación accionables (FCM)
- `SECURITY.md` — política de reporte privado de vulnerabilidades

### Correcciones

- Errores de datos y visualización en la pestaña de cuota
- Chat: la cola sin conexión y los borradores sobreviven a las recargas; posición de desplazamiento estable entre recuperaciones de datos
- Sesiones: las sesiones eliminadas ya no dejan fantasmas en otros clientes
- Kanban: condiciones de carrera y fugas en el despacho del tablero de agentes
- Móvil: padding de altura de teclado sin procesar, ActionSheet reemplaza las alertas de desbordamiento

## [0.5.8] - 2026-09-23

### Novedades

- `install.sh` — instalador de servidor basado en git (`--version`, `--dir`, `--port`, `--systemd`)
- Tarballs de servidor independiente y local publicados en las etiquetas `v*`

### Correcciones

- El teclado móvil cubre el compositor y el contenido bajo la barra de navegación del sistema (Android)

## [0.5.7] - 2026-09-23

### Correcciones

- Compilaciones CI de escritorio (flag de plataforma del paquete, recompilaciones nativas, timeouts de smoke tests)
- Mensajes del asistente transmitidos duplicados en las transcripciones del chat

## [0.5.6] - 2026-09-23

### Correcciones

- CI de escritorio: compilaciones de macOS sin firmar cuando faltan los secretos de Apple, staging de paquetes con ámbito en Windows

## [0.5.5] - 2026-09-23

### Novedades

- **Aplicación de escritorio (vista previa)** — lanzador Electron para servidores locales o remotos, backend integrado, actualización automática, compilaciones dmg/NSIS/AppImage/deb
- **Aplicación móvil (vista previa)** — compañera Expo/React Native: sesiones, chat con selector de modelo y comandos slash, terminal, archivos, WebViews de ajustes
- Indicador de no leído en sesiones con salida nueva; vinculación tablero de tareas ↔ sesión
- Islas de KaTeX y Mermaid en el chat

### Correcciones

- Objetivos táctiles y diseños en viewports móviles; pulido de la paleta de comandos, el kanban y los ajustes

## [0.5.4] - 2026-09-21

### Novedades

- Botón de reinicio del servidor con superposición de progreso a pantalla completa (Ajustes → Acerca de)
- Registro de cambios localizado de las versiones de GitHub en Ajustes → Acerca de
- Número de sesiones activas en el título de la pestaña del navegador
- Escala del eje Y y tooltips al pasar el cursor en el gráfico de tendencia de uso

### Correcciones

- El autoguardado de ajustes se disparaba al abrir ventanas modales; diseño de chat compacto en divisiones de varias filas

## [0.5.3] - 2026-09-21

### Correcciones

- El diálogo de actualización disponible quedaba oculto detrás del rail lateral (corrección de portal)

## [0.5.2] - 2026-09-21

### Correcciones

- La comprobación de actualizaciones se enruta a través del servidor

## [0.5.1] - 2026-09-21

### Novedades

- Insignia de actualización disponible con autoactualización de un clic
- Voz de lectura en voz alta por sesión; el selector de voz se movió a los ajustes de Apariencia

### Correcciones

- El banner del chat muestra el proveedor real de la sesión

## [0.5.0] - 2026-09-21

Primera versión independiente de **ddagent** — una interfaz web y móvil autoalojada para agentes de codificación con IA.

### Destacados

- **Sesiones multiagente** — Claude Code, Codex, Cursor CLI, OpenCode y Devin lado a lado, con streaming en vivo y reanudación
- **Diseño del espacio de trabajo** — paneles divididos para chat, terminal, navegador y archivos
- **Explorador y editor de archivos** — navega y edita el espacio de trabajo en la interfaz
- **Panel Git** — preparar, confirmar, diff, cambiar de ramas, gestionar worktrees
- **Tablero de tareas** — kanban impulsado por TaskMaster; genera tareas ejecutables a partir de PRDs
- **Gestión de MCP** — añade y sincroniza servidores MCP entre agentes
- **Explorador de skills** — descubre y gestiona las skills de los agentes
- **Cuota y uso** — uso de tokens por agente y límites de suscripción
- **Browser-use** — sesiones de navegador dirigidas por agentes para investigación y pruebas
- **Notificaciones y TTS** — alertas y respuestas leídas en voz alta
- **Sandboxes de Docker** — ejecuciones experimentales de agentes aisladas por hipervisor
- **Compañero de escritorio** — aplicación Electron opcional para macOS/Windows
- **i18n** — 11 idiomas de interfaz, temas oscuro y claro

### CLI

- `ddagent` / `ddagent start` — inicia el servidor
- `ddagent status` — muestra la configuración y las ubicaciones de los datos
- `ddagent version` / `ddagent help`
