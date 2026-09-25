<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>一个 UI，管理你所有的 AI 编程智能体。</strong><br>
  为 Claude Code、Codex、Cursor CLI、OpenCode 和 Devin 打造的自托管网页与移动端界面 —— 会话、文件、git、终端和任务，尽在一处。</p>

  <p>
    <img src="https://img.shields.io/badge/version-0.5.9-0066FF" alt="版本">
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

---

## ddagent 是什么？

ddagent 运行在你自己的机器或 VPS 上，为你已在使用的编程智能体提供一个精致的网页 UI。它直接从磁盘发现智能体会话 —— 你的 `~/.claude`、Codex 和 Devin 历史记录会立即显示，不会复制任何内容，也不会同步给第三方。

可从网络中的任意浏览器或手机打开。你的机器，你的智能体，你的数据。

## 功能特性

- **多智能体会话** —— 并排运行和恢复 Claude Code、Codex、Cursor CLI、OpenCode 和 Devin 会话，通过 WebSocket 实时流式传输
- **分栏面板** —— 在一个工作区内集成聊天、终端、浏览器和文件面板
- **文件浏览器与编辑器** —— 浏览工作区，用 CodeMirror 编辑代码
- **Git 面板** —— 无需离开界面即可暂存、提交、查看 diff 和切换分支
- **集成终端** —— 每个工作区都有完整终端，外加独立的 shell 标签页
- **任务看板** —— 由 TaskMaster 驱动的看板视图；将 PRD 转化为可执行任务
- **MCP 管理** —— 在智能体之间添加、编辑和同步 MCP 服务器
- **技能浏览器** —— 在界面中管理智能体技能
- **配额与用量** —— 各智能体的 token 用量和订阅额度一目了然
- **Browser-use** —— 由智能体驱动的浏览器会话，用于调研和测试
- **Worktree** —— 为每个任务创建独立的 git worktree，支持按 worktree 配置安装/运行脚本和带鉴权的开发服务器实时预览
- **远程审批** —— 通过 Telegram、Discord 或移动应用批准工具权限
- **语音输入** —— 通过兼容 Whisper 的 STT 端点口述提示词
- **智能体广播与共享记忆** —— 一次向所有智能体发送消息，并维护它们都能阅读的项目笔记
- **多账户切换** —— 每个提供商支持命名账户，可按会话覆盖环境变量
- **调度器** —— cron 驱动的智能体运行，网页/桌面端支持 keep-awake
- **团队协作** —— 角色（owner/member/viewer）、邀请链接、负责人、评论、在线状态和看板动态流（[文档](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md)）
- **MCP 服务器** —— 让外部 MCP 客户端（Claude Desktop、OpenClaw）创建任务并向会话发消息（[文档](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md)）
- **通知与 TTS** —— 当会话需要你时获得提醒（或语音播报）
- **Docker 沙箱** —— 在 microVM 隔离环境中运行智能体（[文档](https://github.com/Zakwei/ddagent/blob/main/docker/README.md)）
- **桌面伴侣应用** —— 可选的 Electron 应用；**12 种语言**，深色与浅色主题

## 支持的智能体

| 智能体 | 连接方式 |
|---|---|
| **Claude Code** | 自动发现 `~/.claude` 会话；MCP 和设置与原生 CLI 同步 |
| **Codex** | 本地 CLI 会话与转录 |
| **Cursor CLI** | 本地 CLI 会话 |
| **OpenCode** | 本地会话与技能位置 |
| **Devin** | 通过本地同步的 CLI/ACP 会话 |

你需要自备订阅 —— ddagent 提供的是环境，而非 AI 本身。

## 安装

运行服务器的机器需要 **Node.js 22+**。服务器提供网页 UI 以及供桌面和移动应用远程连接的 REST/WS API。

### 自托管服务器 —— 安装脚本

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

将最新的发布标签克隆到 `~/.ddagent/app`，构建网页 UI 和后端，并留下 `start.sh` 启动器。选项：`--version vX.Y.Z` · `--dir <path>` · `--port <port>` · `--systemd`（安装并启用用户级 systemd 单元）。使用 `--version` 重新运行即可原地更新。

然后：

```bash
~/.ddagent/app/start.sh        # → http://localhost:3001
```

### 自托管服务器 —— 预构建 tarball

无需构建步骤 —— 从 [Releases](https://github.com/Zakwei/ddagent/releases) 下载 `ddagent-server-<version>-<os>-<arch>.tar.gz`，解压并运行：

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh           # start.bat on Windows
```

### 桌面应用

从 [Releases](https://github.com/Zakwei/ddagent/releases) 下载适合你操作系统的安装包：`.dmg`（macOS）· `.exe`（Windows）· `.AppImage` / `.deb`（Linux）。

可独立运行 —— 服务器已内嵌，无需安装其他组件 —— 也可以远程模式连接到自托管服务器 URL。通过发布中的 `latest*.yml` 源自动更新。

### 移动应用（预览）

从 [Releases](https://github.com/Zakwei/ddagent/releases) 下载 `ddagent-mobile-<version>.apk` 并安装到你的 Android 设备；应用会连接到自托管服务器 URL。

### 从源码构建

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run dev        # server :3001 + Vite :5173 with HMR
```

### Docker 沙箱（实验性）

```bash
ddagent sandbox ~/my-project
```

在虚拟机管理程序隔离的沙箱中运行智能体。参见 [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md)。

## CLI

在源码或 `install.sh` 安装目录中，下面的 `ddagent` 指 `node dist-server/server/modules/cli/cli.js`（带有 shebang，因此 `./dist-server/server/modules/cli/cli.js` 也可用）。

| 命令 | 说明 |
|---|---|
| `ddagent` | 启动服务器 |
| `ddagent start` | 启动服务器 |
| `ddagent status` | 显示配置和数据位置 |
| `ddagent version` | 打印版本号 |
| `ddagent help` | 显示帮助 |

## 配置

所有设置都在单个 env 文件中 —— 运行 `ddagent status` 可查看你的配置从何处读取。

| 变量 | 默认值 | 说明 |
|---|---|---|
| `SERVER_PORT` | `3001` | API + WebSocket 端口 |
| `VITE_PORT` | `5173` | 开发服务器端口 |
| `HOST` | `0.0.0.0` | 绑定地址（仅本机使用 `127.0.0.1`） |
| `DATABASE_PATH` | auto | 认证数据库位置 |
| `CONTEXT_WINDOW` | `160000` | 每个会话的最大 token 数 |
| `CLAUDE_CLI_PATH` | `claude` | 自定义 Claude CLI 二进制路径 |

完整列表参见 [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example)。

## 开发

```bash
npm run dev            # dev mode (server :3001 + vite :5173)
npm run build          # client + server production build
npm run test:client    # frontend tests
npm test               # backend tests
npm run typecheck      # TypeScript check
```

后端代码遵循 `server/modules/` 中描述的模块化架构 —— 提供商内部实现参见 [`server/modules/providers/README.md`](https://github.com/Zakwei/ddagent/blob/main/server/modules/providers/README.md)。

## 贡献

欢迎修复 bug —— 参见 [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md)。

---

<div align="center">
  <sub>为 Claude Code、Cursor、Codex、OpenCode 和 Devin 社区打造。</sub>
</div>
