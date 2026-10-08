<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>一个 UI，管理你所有的 AI 编程智能体。</strong><br>
  为 Claude Code、Codex、Cursor CLI、OpenCode、Devin、Command Code 和 Antigravity 打造的自托管服务器与 Flutter 客户端（网页、Linux、Windows 与 Android）—— 会话、文件、git、终端和任务，尽在一处。</p>

  <p>
    <img src="https://img.shields.io/github/v/release/Zakwei/ddagent?label=版本&amp;color=0066FF" alt="版本">
    <img src="https://img.shields.io/badge/license-AGPL--3.0-blue" alt="许可证: AGPL-3.0">
    <img src="https://img.shields.io/badge/node-%E2%89%A522-339933" alt="node >= 22">
    <img src="https://img.shields.io/badge/self--hosted-yes-success" alt="自托管">
  </p>

  <p>
    <a href="#安装">安装</a> ·
    <a href="https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md">贡献</a> ·
    <a href="https://github.com/Zakwei/ddagent/issues">问题反馈</a>
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
    <a href="README.ru.md">Русский</a> ·
    <a href="README.tr.md">Türkçe</a> ·
    <strong>简体中文</strong> ·
    <a href="README.zh-TW.md">繁體中文</a>
  </p>
</div>

<p align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/desktop-main.png" alt="ddagent 聊天视图" width="78%">&nbsp;
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/mobile-chat.png" alt="ddagent 移动端视图" width="20%">
</p>

<table>
  <tr>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/sessions.png" alt="来自 Claude Code 和 Codex 的最近会话"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/kanban-board.png" alt="驱动智能体运行的看板"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/git-panel.png" alt="支持按代码块暂存的 Git 面板"></td>
  </tr>
  <tr>
    <td align="center"><sub>所有智能体的会话汇聚于一个列表</sub></td>
    <td align="center"><sub>看板 —— 卡片即可启动智能体运行</sub></td>
    <td align="center"><sub>Git 面板 —— 查看 diff、暂存代码块、提交</sub></td>
  </tr>
</table>

---

## ddagent 是什么？

ddagent 运行在你自己的机器或 VPS 上，为你已在使用的编程智能体提供一个精致统一的 UI。服务器直接从各智能体自己的磁盘历史记录（`~/.claude`、`~/.codex`、`~/.cursor`、OpenCode、Devin 等）读取会话，因此已有的对话无需任何导入即可显示。只有会话元数据会在本地建立索引，不会向任何第三方发送数据。

在桌面、手机或浏览器上通过 Flutter 客户端连接即可。你的机器，你的智能体，你的数据。

## 功能特性

- **多智能体会话** —— 并排运行和恢复来自七种智能体 CLI 的会话，通过 WebSocket 实时流式传输
- **自动编排器** —— “Auto” 会话会结合剩余的订阅配额，将每个任务分派给合适的智能体和模型，并把工作委派给子会话
- **分栏工作区** —— 在一个窗口中最多容纳六个面板（聊天、终端、浏览器、预览、编辑器、git、笔记）
- **文件浏览器与编辑器** —— 浏览工作区，用内置编辑器编辑代码
- **Git 面板** —— 无需离开界面即可暂存文件或单个代码块、提交（支持 AI 生成提交信息）、查看 diff、切换分支、pull/push 以及恢复检查点
- **集成终端** —— 每个工作区都有完整的 shell
- **看板** —— 移动卡片即可在其上启动智能体运行（可选在独立的 worktree 中）；智能体完成后会回报结果
- **TaskMaster** —— 将 PRD 转化为任务，并在任务看板上跟踪
- **消息队列** —— 智能体忙碌时发送的消息会在服务器端排队，刷新页面或切换设备后依然保留
- **MCP 管理** —— 在智能体之间添加、编辑和同步 MCP 服务器
- **知识库** —— 为每个智能体提供本地、可搜索的统一记忆：规则、技能、记忆和个人信息，通过 MCP 按需检索（[文档](KNOWLEDGE.zh-CN.md)）
- **技能与规则** —— 在一处统一管理智能体技能和共享规则
- **配额与用量** —— 各智能体的 token 用量和订阅额度一目了然
- **Browser-use** —— 由智能体驱动的浏览器会话，用于调研和测试，并配有实时浏览器面板
- **Worktree** —— 为每个任务创建隔离的 git worktree，支持按 worktree 配置安装/运行脚本，以及带鉴权的开发服务器实时预览
- **远程审批** —— 通过 Telegram、Discord 或 Android 应用批准工具权限（[文档](https://github.com/Zakwei/ddagent/blob/main/docs/remote-approvals.md)）
- **语音输入** —— 通过兼容 Whisper 的语音转文字端点口述提示词
- **智能体广播与共享记忆** —— 一次向所有智能体发送消息，并维护它们都会读取的项目笔记
- **多账户切换** —— 每个提供商支持命名账户，可按会话覆盖环境变量
- **调度器** —— 由 cron 驱动、无人值守的智能体运行，可选在运行期间保持设备唤醒
- **团队协作** —— 角色（owner/member/viewer）、邀请链接、负责人、评论、在线状态以及看板上的动态流（[文档](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md)）
- **MCP 服务器** —— 让外部 MCP 客户端（Claude Desktop、OpenClaw）列出会话、创建任务并向会话发送消息（[文档](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md)）
- **通知与 TTS** —— 当会话需要你时，通过推送、Telegram 和 Discord 发送通知，还可选择朗读回复
- **命令面板** —— 按 `Ctrl/Cmd+Shift+K` 搜索会话和消息、跳转到任意页面或执行快捷操作
- **Docker 沙箱** —— 在 microVM 隔离的 Docker Sandboxes 中运行智能体（[文档](https://github.com/Zakwei/ddagent/blob/main/docker/README.md)）
- **Flutter 客户端** —— 网页、Linux、Windows 和 Android 共用一套代码库；**12 种语言**，深色与浅色主题

## 支持的智能体

| 智能体 | 连接方式 |
|---|---|
| **Claude Code** | Claude Agent SDK；自动发现 `~/.claude` 会话；MCP 和设置与原生 CLI 同步 |
| **Codex** | Codex SDK；来自 `~/.codex` 的本地会话与转录 |
| **Cursor CLI** | 带流式 JSON 输出的 `cursor-agent`；来自 `~/.cursor` 的本地聊天 |
| **OpenCode** | `opencode serve`；来自 OpenCode 数据库的本地会话 |
| **Devin** | `devin acp`（Agent Client Protocol）；本地转录 |
| **Command Code** | `command-code acp`（Agent Client Protocol）；来自 `~/.commandcode` 的转录 |
| **Antigravity** | 无头模式下的 `agy` CLI；从 `~/.gemini/antigravity-cli` 索引的对话 |

各智能体 CLI 必须已在服务器所在机器上安装并登录。你需要自备订阅 —— ddagent 提供的是环境，而非 AI 本身。

## 安装

ddagent 由两部分组成：**服务器**，与你的智能体运行在同一台机器上，提供 REST/WebSocket API；以及连接到服务器的**客户端**。服务器需要 **Node.js 22+**（预构建 tarball 需要 Node.js 22.x，因为其中的原生模块是针对该版本构建的）。

### 服务器 —— 安装脚本

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

需要 `git`、Node.js 22+ 和 `npm`。该脚本会将某个发布标签克隆到 `~/.ddagent/app`，安装依赖，构建后端，并生成 `start.sh` 启动器。可在 `bash -s --` 之后传入选项：

| 选项 | 说明 |
|---|---|
| `--version vX.Y.Z` | 安装指定版本（默认：最新版） |
| `--dir <path>` | 安装目录（默认：`~/.ddagent/app`） |
| `--systemd` | 安装并启用名为 `ddagent` 的 systemd 用户服务 |
| `--port <port>` | systemd 服务使用的端口（默认：`3001`） |

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash -s -- --systemd --port 3001
```

然后启动服务器：

```bash
~/.ddagent/app/start.sh        # API on http://<host>:3001 (set SERVER_PORT to change)
```

### 服务器 —— 预构建 tarball

无需构建步骤：从 [Releases](https://github.com/Zakwei/ddagent/releases) 下载 `ddagent-server-<version>-<os>-<arch>.tar.gz`（`linux-x64`、`mac-arm64` 或 `win-x64`），解压后运行启动器：

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh             # start.bat on Windows
```

每个 tarball 都附带 `.sha256` 校验和。设置写在 `start.sh` 旁边一个可选的 `.env` 文件中。

### 客户端

从 [Releases](https://github.com/Zakwei/ddagent/releases) 下载预构建的客户端：

| 平台 | 文件 |
|---|---|
| Windows x64 | `ddagent-flutter-windows-x64-<tag>-setup.exe`（安装程序）或 `.zip`（便携版） |
| Linux x64 | `ddagent-flutter-linux-x64-<tag>.deb` 或 `.tar.gz` |
| Android | `ddagent-flutter-android-<tag>.apk` |
| Web | `ddagent-flutter-web-<tag>.zip` |

首次启动时，输入你的服务器 URL（例如 `http://my-vps:3001`）并创建第一个账户。在 Windows 和 Linux x64 上，桌面客户端还可以为你下载并运行本地服务器（连接界面中的“本设备”）。

网页版没有登录界面，且会调用同源的 API，因此必须通过反向代理提供服务，后端服务器需以单用户平台模式运行（`VITE_IS_PLATFORM=true`，该模式会禁用身份验证）。在源码检出目录中，`node scripts/serve-flutter-web.cjs` 会在 8085 端口提供 `flutter/build/web`，并将 API 和 WebSocket 代理到运行在 `FLUTTER_BACKEND_PORT`（默认 `10087`）上的服务器。请仅在可信网络中暴露这种部署方式。

自行构建客户端：

```bash
cd flutter
flutter pub get
flutter build linux --release      # or: windows, apk, web
```

### 更新

客户端的 **设置 → 关于 → 更新** 为每个部分分别提供一个按钮：

| 部分 | 更新方式 |
|---|---|
| **服务器** | 通过安装脚本或 git 安装的会切换到最新版本；通过发布版 tarball 安装的会下载下一个 tarball，校验（`.sha256`）后在重启时安装，若服务器无法启动则自动回滚。`start.sh` / `start.bat` 会自行重启服务器，无需 systemd。桌面客户端的本地服务器（“本设备”）由应用重新安装。 |
| **Web 界面** | 由服务器托管时（`DDAGENT_WEB_DIR`，或由 `scripts/serve-flutter-web.cjs` 提供的 `flutter/build/web`），会用发布版的 web zip 替换；每次更新服务器时也会随之刷新。 |
| **此应用** | Android 会安装新的 APK；Windows 和 Linux 会在后台下载新版本，并在你退出应用时安装。 |

发布版 tarball 针对 Node.js 22 构建——服务器会拒绝为其他 Node.js 主版本构建的 tarball。0.8.12 及更早版本的服务器（通过安装脚本或 tarball 安装）需要手动更新一次到 0.8.13——重新运行 `install.sh --version v0.8.13`，或将新 tarball 解压覆盖旧版本——之后即可在界面中更新。

### 从源码构建

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run build && node dist-server/server/index.js   # API on http://localhost:3001
```

### Docker 沙箱（实验性）

```bash
ddagent sandbox ~/my-project
```

在 microVM 隔离的 Docker Sandbox 中运行 ddagent 和一个智能体（Claude Code 或 Codex）。需要 `sbx` CLI —— 参见 [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md)。

## CLI

在源码或 `install.sh` 检出目录中，下文的 `ddagent` 指 `node dist-server/server/modules/cli/cli.js`（它带有 shebang，因此 `./dist-server/server/modules/cli/cli.js` 也可以直接运行）。

| 命令 | 说明 |
|---|---|
| `ddagent` / `ddagent start` | 启动服务器（默认命令） |
| `ddagent status` | 显示版本、配置文件、数据库以及 Claude 项目的位置 |
| `ddagent sandbox <workspace>` | 创建并启动 Docker 沙箱；`ddagent sandbox help` 会列出 `ls`、`start`、`stop`、`rm`、`logs` |
| `ddagent browser-use-mcp` | 通过 stdio 运行 browser-use MCP 服务器 |
| `ddagent version` | 打印版本号 |
| `ddagent help` | 显示帮助 |

| 选项 | 说明 |
|---|---|
| `-p, --port <port>` | 服务器端口（覆盖 `SERVER_PORT`） |
| `--database-path <path>` | 自定义数据库位置（覆盖 `DATABASE_PATH`） |

## 配置

服务器会从其安装目录（`start.sh` 旁边）读取可选的 `.env` 文件；实际的环境变量优先级更高。运行 `ddagent status` 可查看使用的是哪个文件。

| 变量 | 默认值 | 说明 |
|---|---|---|
| `SERVER_PORT` | `3001` | API + WebSocket 端口（`PORT` 作为旧版别名仍可使用） |
| `HOST` | `0.0.0.0` | 绑定地址（仅限本机访问时使用 `127.0.0.1`） |
| `DATABASE_PATH` | `~/.ddagent/auth.db` | SQLite 数据库（用户、设置、令牌） |
| `WORKSPACES_ROOT` | 主目录 | 项目必须位于此目录之内 |
| `JWT_SECRET` | 自动生成 | 用于签发登录令牌的密钥（每个安装实例自动生成并保存） |
| `API_KEY` | 未设置 | 设置后，API 请求必须在 `x-api-key` 请求头中携带该值 |
| `CLAUDE_CLI_PATH` | `claude` | 自定义 Claude Code CLI 二进制文件 |
| `CONTEXT_WINDOW` | `200000` | Claude 上下文窗口的回退值，在 SDK 报告模型的实际窗口大小之前使用 |
| `STT_ENDPOINT_URL` / `STT_API_KEY` / `STT_MODEL` | `https://api.openai.com/v1` / 未设置 / `whisper-1` | 语音输入使用的语音转文字服务（也可在设置中配置） |
| `VITE_IS_PLATFORM` | `false` | 单用户平台模式：跳过身份验证（网页客户端必需） |

更多内容参见 [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example)。

## 开发

```bash
npm install
npm run dev               # start the backend from source (tsx, no reload)
npm run server:dev-watch  # same, restarting on file changes
npm run build             # compile the server to dist-server/
npm test                  # backend tests
npm run typecheck         # TypeScript check
npm run lint              # ESLint
```

客户端（Flutter 3.47.5 stable）：

```bash
cd flutter
flutter pub get
flutter run -d linux --dart-define=DEFAULT_SERVER_URL=http://localhost:3001
dart format --line-length 100 lib test
flutter analyze
flutter test
```

后端代码遵循 `server/modules/` 中的模块化架构；提供商内部实现参见 [`server/modules/providers/README.md`](https://github.com/Zakwei/ddagent/blob/main/server/modules/providers/README.md)。

## 贡献

欢迎提交 bug 修复 —— 参见 [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md)。如需报告安全漏洞，请参见 [SECURITY.md](https://github.com/Zakwei/ddagent/blob/main/SECURITY.md)。

---

<div align="center">
  <sub>为 Claude Code、Codex、Cursor、OpenCode、Devin、Command Code 和 Antigravity 社区打造。</sub>
</div>
