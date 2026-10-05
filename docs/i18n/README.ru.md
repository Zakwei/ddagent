<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>Один интерфейс для всех ваших ИИ-агентов для кодирования.</strong><br>
  Self-hosted интерфейс (веб, десктоп и мобильный) для Claude Code, Codex, Cursor CLI, OpenCode и Devin — сессии, файлы, git, терминалы и задачи в одном месте.</p>

  <p>
    <img src="https://img.shields.io/github/v/release/Zakwei/ddagent?label=версия&amp;color=0066FF" alt="версия">
    <img src="https://img.shields.io/badge/license-AGPL--3.0-blue" alt="лицензия: AGPL-3.0">
    <img src="https://img.shields.io/badge/node-%E2%89%A522-339933" alt="node >= 22">
    <img src="https://img.shields.io/badge/self--hosted-yes-success" alt="self-hosted">
  </p>

  <p>
    <a href="#установка">Установка</a> ·
    <a href="https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md">Участие в разработке</a> ·
    <a href="https://github.com/Zakwei/ddagent/issues">Отчёты об ошибках</a>
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
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/desktop-main.png" alt="окно чата ddagent" width="78%">&nbsp;
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/mobile-chat.png" alt="мобильный вид ddagent" width="20%">
</p>

---

## Что такое ddagent?

ddagent работает на вашей машине или VPS и предоставляет отточенный интерфейс (Flutter: веб, десктоп и мобильный) поверх уже используемых вами агентов для кодирования. Он находит их сессии прямо на диске — история `~/.claude`, Codex и Devin появляется мгновенно, ничего не дублируется и не синхронизируется с третьими сторонами.

Открывайте из любого браузера в вашей сети или с телефона. Ваша машина, ваши агенты, ваши данные.

## Возможности

- **Сессии нескольких агентов** — запускайте и возобновляйте сессии Claude Code, Codex, Cursor CLI, OpenCode и Devin параллельно, с live-стримингом через WebSocket
- **Разделённые панели** — чат, терминал, браузер и файловые панели в одном рабочем пространстве
- **Файловый менеджер и редактор** — просматривайте рабочее пространство и редактируйте код во встроенном редакторе
- **Панель Git** — stage, commit, diff и переключение веток, не выходя из интерфейса
- **Встроенный терминал** — полноценный терминал для каждого рабочего пространства плюс отдельная вкладка shell
- **Доска задач** — kanban-представление на базе TaskMaster; превращайте PRD в исполняемые задачи
- **Управление MCP** — добавляйте, редактируйте и синхронизируйте MCP-серверы между агентами
- **База знаний** — одна локальная, доступная для поиска память для каждого агента: правила, навыки, воспоминания и личная информация, получается через MCP по запросу (модель Contexta) ([документация](KNOWLEDGE.ru.md))
- **Браузер скиллов** — управляйте скиллами агентов из интерфейса
- **Квоты и использование** — расход токенов и лимиты подписки по каждому агенту с первого взгляда
- **Browser-use** — управляемые агентом браузерные сессии для исследований и тестирования
- **Worktree'ы** — изолированные git worktree для каждой задачи, со скриптами настройки/запуска для каждого worktree и аутентифицированным live-превью dev-сервера
- **Удалённые подтверждения** — одобряйте разрешения инструментов из Telegram, Discord или мобильного приложения
- **Голосовой ввод** — диктуйте промпты через Whisper-совместимый STT-эндпоинт
- **Рассылка агентам и общая память** — отправляйте сообщение всем агентам сразу и ведите заметки проекта, которые читают все
- **Переключение между аккаунтами** — именованные аккаунты для каждого провайдера с переопределением env-переменных для каждой сессии
- **Планировщик** — запуск агентов по cron, с keep-awake на веб и десктопе
- **Командная работа** — роли (owner/member/viewer), ссылки-приглашения, исполнители, комментарии, присутствие и лента активности на доске ([документация](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md))
- **MCP-сервер** — позвольте внешним MCP-клиентам (Claude Desktop, OpenClaw) создавать задачи и писать в сессии ([документация](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **Уведомления и TTS** — получайте пинг (или озвучку), когда сессии нужны вы
- **Docker-песочницы** — запускайте агентов в изолированных microVM-окружениях ([документация](https://github.com/Zakwei/ddagent/blob/main/docker/README.md))
- **Flutter-клиент** — одна кодовая база для веба, десктопа и мобильных; **12 языков**, тёмная и светлая темы

## Поддерживаемые агенты

| Агент | Как подключается |
|---|---|
| **Claude Code** | Автоматически находит сессии `~/.claude`; синхронизация MCP и настроек с нативным CLI |
| **Codex** | Локальные CLI-сессии и транскрипты |
| **Cursor CLI** | Локальные CLI-сессии |
| **OpenCode** | Локальные сессии и расположение скиллов |
| **Devin** | CLI/ACP-сессии через локальную синхронизацию |

Вы используете свои подписки — ddagent предоставляет окружение, а не ИИ.

## Установка

Требуется **Node.js 22+** на машине, где работает сервер. Сервер отдаёт REST/WS API, к которому удалённо подключается Flutter-клиент (веб, десктоп, мобильный).

### Self-hosted сервер — скрипт установки

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

Клонирует тег последнего релиза в `~/.ddagent/app`, собирает бэкенд и оставляет лаунчер `start.sh`. Опции: `--version vX.Y.Z` · `--dir <path>` · `--port <port>` · `--systemd` (устанавливает и включает пользовательский systemd-юнит). Повторный запуск с `--version` обновляет на месте.

Затем:

```bash
~/.ddagent/app/start.sh        # → http://localhost:3001
```

### Self-hosted сервер — готовый tarball

Без шага сборки — скачайте `ddagent-server-<version>-<os>-<arch>.tar.gz` со страницы [Releases](https://github.com/Zakwei/ddagent/releases), распакуйте и запустите:

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh           # start.bat on Windows
```

### Flutter-клиент (веб · десктоп · мобильный)

Клиент — это приложение Flutter (`flutter/`) — одна кодовая база для веба, десктопа (Linux/Windows) и мобильных. Сборка из исходников:

```bash
cd flutter
flutter build web        # → build/web (serve with scripts/serve-flutter-web.cjs)
```

Клиент подключается к URL self-hosted сервера.

### Из исходников

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run dev        # backend dev mode (tsx) with HMR
```

### Docker-песочница (экспериментально)

```bash
ddagent sandbox ~/my-project
```

Запускает агента в изолированной гипервизором песочнице. См. [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md).

## CLI

В исходном или установленном через `install.sh` каталоге `ddagent` ниже означает `node dist-server/server/modules/cli/cli.js` (у него есть shebang, так что `./dist-server/server/modules/cli/cli.js` тоже работает).

| Команда | Описание |
|---|---|
| `ddagent` | Запустить сервер |
| `ddagent start` | Запустить сервер |
| `ddagent status` | Показать расположение конфигурации и данных |
| `ddagent version` | Показать версию |
| `ddagent help` | Показать справку |

## Конфигурация

Все настройки находятся в одном env-файле — выполните `ddagent status`, чтобы увидеть, откуда читается ваш.

| Переменная | По умолчанию | Описание |
|---|---|---|
| `SERVER_PORT` | `3001` | Порт API + WebSocket |
| `HOST` | `0.0.0.0` | Адрес привязки (`127.0.0.1` — только localhost) |
| `DATABASE_PATH` | auto | Расположение базы данных аутентификации |
| `CONTEXT_WINDOW` | `160000` | Максимум токенов на сессию |
| `CLAUDE_CLI_PATH` | `claude` | Путь к пользовательскому бинарнику Claude CLI |

Полный список см. в [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example).

## Разработка

```bash
npm run dev            # backend dev mode (tsx)
npm run build          # server production build
npm test               # backend tests
npm run typecheck      # TypeScript check
```

Код бэкенда следует модульной архитектуре, описанной в `server/modules/` — внутренности провайдеров см. в [`server/modules/providers/README.md`](https://github.com/Zakwei/ddagent/blob/main/server/modules/providers/README.md).

## Участие в разработке

Исправления ошибок приветствуются — см. [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md).

---

<div align="center">
  <sub>Создано для сообщества Claude Code, Cursor, Codex, OpenCode и Devin.</sub>
</div>
