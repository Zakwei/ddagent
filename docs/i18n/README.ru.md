<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>Один интерфейс для всех ваших ИИ-агентов для программирования.</strong><br>
  Self-hosted сервер и Flutter-клиент (веб, Linux, Windows и Android) для Claude Code, Codex, Cursor CLI, OpenCode, Devin, Command Code и Antigravity — сессии, файлы, git, терминалы и задачи в одном месте.</p>

  <p>
    <img src="https://img.shields.io/github/v/release/Zakwei/ddagent?label=версия&amp;color=0066FF" alt="версия">
    <img src="https://img.shields.io/badge/license-AGPL--3.0-blue" alt="лицензия: AGPL-3.0">
    <img src="https://img.shields.io/badge/node-%E2%89%A522-339933" alt="node >= 22">
    <img src="https://img.shields.io/badge/self--hosted-yes-success" alt="self-hosted">
  </p>

  <p>
    <a href="#установка">Установка</a> ·
    <a href="https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md">Участие в разработке</a> ·
    <a href="https://github.com/Zakwei/ddagent/issues">Сообщить об ошибке</a>
  </p>

  <p>
    <a href="../../README.md">English</a> ·
    <a href="README.pl.md">Polski</a> ·
    <a href="README.de.md">Deutsch</a> ·
    <a href="README.es.md">Español</a> ·
    <a href="README.fr.md">Français</a> ·
    <a href="README.it.md">Italiano</a> ·
    <a href="README.ja.md">日本語</a> ·
    <a href="README.ko.md">한국어</a> ·
    <strong>Русский</strong> ·
    <a href="README.tr.md">Türkçe</a> ·
    <a href="README.zh-CN.md">简体中文</a> ·
    <a href="README.zh-TW.md">繁體中文</a>
  </p>
</div>

<p align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/desktop-main.png" alt="Окно чата ddagent" width="78%">&nbsp;
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/mobile-chat.png" alt="Мобильная версия ddagent" width="20%">
</p>

<table>
  <tr>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/sessions.png" alt="Последние сессии Claude Code и Codex"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/kanban-board.png" alt="Канбан-доска, запускающая агентов"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/git-panel.png" alt="Git-панель с индексацией отдельных фрагментов"></td>
  </tr>
  <tr>
    <td align="center"><sub>Сессии всех агентов в одном списке</sub></td>
    <td align="center"><sub>Канбан-доска — карточки запускают агентов</sub></td>
    <td align="center"><sub>Git-панель — diff, индексация фрагментов, коммит</sub></td>
  </tr>
</table>

---

## Что такое ddagent?

ddagent работает на вашем компьютере или VPS и объединяет агентов для программирования, которыми вы уже пользуетесь, в одном продуманном интерфейсе. Сервер читает сессии каждого агента прямо из его собственной истории на диске (`~/.claude`, `~/.codex`, `~/.cursor`, OpenCode, Devin, …), поэтому существующие диалоги появляются сразу, без какого-либо импорта. Локально индексируются только метаданные сессий; никакие данные не передаются третьим лицам.

Подключайтесь через Flutter-клиент с компьютера, телефона или из браузера. Ваша машина, ваши агенты, ваши данные.

## Возможности

- **Мультиагентные сессии** — запускайте и возобновляйте сессии семи CLI-агентов бок о бок, с потоковой передачей в реальном времени через WebSocket
- **Автоматический оркестратор** — сессии «Auto» направляют каждую задачу подходящему агенту и модели с учётом оставшейся квоты подписки и делегируют работу дочерним сессиям
- **Разделённое рабочее пространство** — до шести панелей (чат, терминал, браузер, предпросмотр, редактор, git, заметки) в одном окне
- **Файловый менеджер и редактор** — просматривайте рабочее пространство и правьте код во встроенном редакторе
- **Git-панель** — индексируйте файлы или отдельные фрагменты, делайте коммиты (с сообщениями, сгенерированными ИИ), смотрите diff, работайте с ветками, выполняйте pull/push и восстанавливайте контрольные точки, не покидая интерфейса
- **Встроенный терминал** — полноценная оболочка для каждого рабочего пространства
- **Канбан-доска** — переместите карточку, чтобы запустить по ней агента (при желании — в отдельном worktree); по завершении агент сообщит о результате
- **TaskMaster** — превращайте PRD в задачи и отслеживайте их на доске задач
- **Очередь сообщений** — сообщения, отправленные, пока агент занят, ставятся в очередь на сервере и сохраняются после обновления страницы и смены устройства
- **Управление MCP** — добавляйте, редактируйте и синхронизируйте MCP-серверы между агентами
- **База знаний** — единая локальная память с поиском для всех агентов: правила, навыки, воспоминания и личная информация, которые извлекаются по запросу через MCP ([документация](KNOWLEDGE.ru.md))
- **Навыки и правила** — управляйте навыками агентов и общими правилами из одного места
- **Квоты и использование** — расход токенов и лимиты подписок каждого агента с первого взгляда
- **Browser-use** — браузерные сессии под управлением агента для исследований и тестирования, с живой панелью браузера
- **Worktree** — создавайте изолированные git worktree под каждую задачу, со своими скриптами настройки и запуска и с защищённым живым предпросмотром dev-сервера
- **Удалённое подтверждение** — разрешайте использование инструментов из Telegram, Discord или Android-приложения ([документация](https://github.com/Zakwei/ddagent/blob/main/docs/remote-approvals.md))
- **Голосовой ввод** — диктуйте запросы через совместимый с Whisper сервис распознавания речи
- **Рассылка агентам и общая память** — отправляйте сообщение всем агентам сразу и ведите заметки по проекту, которые читают все они
- **Переключение между аккаунтами** — именованные аккаунты для каждого провайдера с переопределением переменных окружения на уровне сессии
- **Планировщик** — автономные запуски агентов по cron, с возможностью не давать устройству засыпать, пока они выполняются
- **Командная работа** — роли (owner/member/viewer), ссылки-приглашения, исполнители, комментарии, статус присутствия и лента активности на доске ([документация](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md))
- **MCP-сервер** — внешние MCP-клиенты (Claude Desktop, OpenClaw) могут получать список сессий, создавать задачи и отправлять сообщения в сессии ([документация](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Уведомления и TTS** — push-уведомления, а также уведомления в Telegram и Discord, когда сессии нужно ваше внимание, плюс озвучивание ответов по желанию
- **Палитра команд** — `Ctrl/Cmd+Shift+K` для поиска по сессиям и сообщениям, перехода на любую страницу или выполнения быстрых действий
- **Docker-песочницы** — запускайте агентов в Docker Sandboxes с изоляцией на уровне microVM ([документация](https://github.com/Zakwei/ddagent/blob/main/docker/README.md))
- **Flutter-клиент** — единая кодовая база для веба, Linux, Windows и Android; **12 языков**, тёмная и светлая темы

## Поддерживаемые агенты

| Агент | Способ подключения |
|---|---|
| **Claude Code** | Claude Agent SDK; автоматически находит сессии в `~/.claude`; MCP и настройки синхронизируются с нативным CLI |
| **Codex** | Codex SDK; локальные сессии и транскрипты из `~/.codex` |
| **Cursor CLI** | `cursor-agent` с потоковым выводом JSON; локальные чаты из `~/.cursor` |
| **OpenCode** | `opencode serve`; локальные сессии из базы данных OpenCode |
| **Devin** | `devin acp` (Agent Client Protocol); локальные транскрипты |
| **Command Code** | `command-code acp` (Agent Client Protocol); транскрипты из `~/.commandcode` |
| **Antigravity** | CLI `agy` в headless-режиме; диалоги индексируются из `~/.gemini/antigravity-cli` |

CLI агентов должны быть установлены на сервере, и в них должен быть выполнен вход. Подписки — ваши собственные: ddagent предоставляет среду, а не ИИ.

## Установка

ddagent состоит из двух частей: **сервера**, который работает рядом с вашими агентами и предоставляет REST/WebSocket API, и **клиента**, который к нему подключается. Серверу нужен **Node.js 22+** (готовым tarball-архивам нужен именно Node.js 22.x, поскольку их нативные модули собраны под эту версию).

### Сервер — скрипт установки

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

Требуются `git`, Node.js 22+ и `npm`. Скрипт клонирует тег релиза в `~/.ddagent/app`, устанавливает зависимости, собирает бэкенд и создаёт скрипт запуска `start.sh`. Параметры передаются после `bash -s --`:

| Параметр | Описание |
|---|---|
| `--version vX.Y.Z` | Установить конкретный релиз (по умолчанию — последний) |
| `--dir <path>` | Каталог установки (по умолчанию `~/.ddagent/app`) |
| `--systemd` | Установить и включить пользовательский сервис systemd с именем `ddagent` |
| `--port <port>` | Порт для сервиса systemd (по умолчанию `3001`) |

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash -s -- --systemd --port 3001
```

Чтобы обновиться, запустите скрипт повторно с `--version vX.Y.Z` — он обновит существующую копию на месте. Затем запустите сервер:

```bash
~/.ddagent/app/start.sh        # API on http://<host>:3001 (set SERVER_PORT to change)
```

### Сервер — готовый tarball

Без сборки: скачайте `ddagent-server-<version>-<os>-<arch>.tar.gz` (`linux-x64`, `mac-arm64` или `win-x64`) со страницы [Releases](https://github.com/Zakwei/ddagent/releases), распакуйте и запустите скрипт запуска:

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh             # start.bat on Windows
```

К каждому архиву прилагается контрольная сумма `.sha256`. Настройки задаются в необязательном файле `.env` рядом с `start.sh`.

### Клиент

Скачайте готовый клиент со страницы [Releases](https://github.com/Zakwei/ddagent/releases):

| Платформа | Файл |
|---|---|
| Windows x64 | `ddagent-flutter-windows-x64-<tag>-setup.exe` (установщик) или `.zip` (портативная версия) |
| Linux x64 | `ddagent-flutter-linux-x64-<tag>.deb` или `.tar.gz` |
| Android | `ddagent-flutter-android-<tag>.apk` |
| Web | `ddagent-flutter-web-<tag>.zip` |

При первом запуске введите URL сервера (например, `http://my-vps:3001`) и создайте первую учётную запись. В Windows и Linux x64 десктопный клиент также может сам скачать и запустить локальный сервер («Это устройство» на экране подключения).

У веб-сборки нет экрана входа, и она обращается к API на том же origin, поэтому её нужно отдавать через обратный прокси перед сервером, работающим в однопользовательском платформенном режиме (`VITE_IS_PLATFORM=true`, что отключает аутентификацию). В копии исходников команда `node scripts/serve-flutter-web.cjs` раздаёт `flutter/build/web` на порту 8085 и проксирует API и WebSocket на сервер, работающий на порту `FLUTTER_BACKEND_PORT` (по умолчанию `10087`). Открывайте такую конфигурацию только в доверенной сети.

Чтобы собрать клиент самостоятельно:

```bash
cd flutter
flutter pub get
flutter build linux --release      # or: windows, apk, web
```

### Из исходников

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run build && node dist-server/server/index.js   # API on http://localhost:3001
```

### Docker-песочница (экспериментально)

```bash
ddagent sandbox ~/my-project
```

Запускает ddagent и агента (Claude Code или Codex) внутри Docker Sandbox с изоляцией на уровне microVM. Требуется CLI `sbx` — см. [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md).

## CLI

В копии исходников или установке через `install.sh` под `ddagent` ниже подразумевается `node dist-server/server/modules/cli/cli.js` (у файла есть shebang, так что `./dist-server/server/modules/cli/cli.js` тоже работает).

| Команда | Описание |
|---|---|
| `ddagent` / `ddagent start` | Запустить сервер (команда по умолчанию) |
| `ddagent status` | Показать версию и расположение файла конфигурации, базы данных и проектов Claude |
| `ddagent sandbox <workspace>` | Создать и запустить Docker-песочницу; `ddagent sandbox help` выводит `ls`, `start`, `stop`, `rm`, `logs` |
| `ddagent browser-use-mcp` | Запустить MCP-сервер browser-use через stdio |
| `ddagent version` | Вывести версию |
| `ddagent help` | Показать справку |

| Параметр | Описание |
|---|---|
| `-p, --port <port>` | Порт сервера (переопределяет `SERVER_PORT`) |
| `--database-path <path>` | Своё расположение базы данных (переопределяет `DATABASE_PATH`) |

## Конфигурация

Сервер читает необязательный файл `.env` из каталога установки (рядом с `start.sh`); настоящие переменные окружения имеют приоритет. Запустите `ddagent status`, чтобы узнать, какой файл используется.

| Переменная | По умолчанию | Описание |
|---|---|---|
| `SERVER_PORT` | `3001` | Порт API + WebSocket (`PORT` поддерживается как устаревший псевдоним) |
| `HOST` | `0.0.0.0` | Адрес привязки (`127.0.0.1` — только localhost) |
| `DATABASE_PATH` | `~/.ddagent/auth.db` | База данных SQLite (пользователи, настройки, токены) |
| `WORKSPACES_ROOT` | домашний каталог | Проекты должны находиться внутри этого каталога |
| `JWT_SECRET` | генерируется автоматически | Секрет для подписи токенов входа (генерируется и сохраняется для каждой установки) |
| `API_KEY` | не задан | Если задан, запросы к API должны передавать его в заголовке `x-api-key` |
| `CLAUDE_CLI_PATH` | `claude` | Свой исполняемый файл Claude Code CLI |
| `CONTEXT_WINDOW` | `200000` | Резервный размер контекстного окна Claude, используется, пока SDK не сообщит реальный размер окна модели |
| `STT_ENDPOINT_URL` / `STT_API_KEY` / `STT_MODEL` | `https://api.openai.com/v1` / не задан / `whisper-1` | Распознавание речи для голосового ввода (также настраивается в Настройках) |
| `VITE_IS_PLATFORM` | `false` | Однопользовательский платформенный режим: аутентификация отключена (требуется для веб-клиента) |

Подробнее — в [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example).

## Разработка

```bash
npm install
npm run dev               # start the backend from source (tsx, no reload)
npm run server:dev-watch  # same, restarting on file changes
npm run build             # compile the server to dist-server/
npm test                  # backend tests
npm run typecheck         # TypeScript check
npm run lint              # ESLint
```

Клиент (Flutter 3.47.5 stable):

```bash
cd flutter
flutter pub get
flutter run -d linux --dart-define=DEFAULT_SERVER_URL=http://localhost:3001
dart format --line-length 100 lib test
flutter analyze
flutter test
```

Код бэкенда следует модульной архитектуре в `server/modules/`; об устройстве провайдеров см. [`server/modules/providers/README.md`](https://github.com/Zakwei/ddagent/blob/main/server/modules/providers/README.md).

## Участие в разработке

Исправления ошибок приветствуются — см. [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md). Чтобы сообщить об уязвимости, см. [SECURITY.md](https://github.com/Zakwei/ddagent/blob/main/SECURITY.md).

---

<div align="center">
  <sub>Создано для сообщества Claude Code, Codex, Cursor, OpenCode, Devin, Command Code и Antigravity.</sub>
</div>
