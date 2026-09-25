<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>一個 UI，管理你所有的 AI 程式代理。</strong><br>
  為 Claude Code、Codex、Cursor CLI、OpenCode 和 Devin 打造的自架網頁與行動介面 —— 工作階段、檔案、git、終端機和任務，全部集中在一處。</p>

  <p>
    <img src="https://img.shields.io/badge/version-0.5.9-0066FF" alt="版本">
    <img src="https://img.shields.io/badge/license-AGPL--3.0-blue" alt="授權: AGPL-3.0">
    <img src="https://img.shields.io/badge/node-%E2%89%A522-339933" alt="node >= 22">
    <img src="https://img.shields.io/badge/self--hosted-yes-success" alt="自架">
  </p>

  <p>
    <a href="#安裝">安裝</a> ·
    <a href="https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md">貢獻</a> ·
    <a href="https://github.com/Zakwei/ddagent/issues">回報錯誤</a>
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
    <a href="README.zh-CN.md">简体中文</a> ·
    <strong>繁體中文</strong>
  </p>
</div>

<p align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/desktop-main.png" alt="ddagent 聊天畫面" width="78%">&nbsp;
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/mobile-chat.png" alt="ddagent 行動裝置畫面" width="20%">
</p>

---

## ddagent 是什麼？

ddagent 運行在你自己的機器或 VPS 上，為你已在使用的程式代理提供精緻的網頁 UI。它直接從磁碟發現代理的工作階段 —— 你的 `~/.claude`、Codex 和 Devin 歷史記錄會立即顯示，不會複製任何內容，也不會同步給第三方。

可從網路中的任何瀏覽器或手機開啟。你的機器、你的代理、你的資料。

## 功能特色

- **多代理工作階段** —— 並排執行和恢復 Claude Code、Codex、Cursor CLI、OpenCode 和 Devin 工作階段，透過 WebSocket 即時串流
- **分割面板** —— 在同一工作區中整合聊天、終端機、瀏覽器和檔案面板
- **檔案瀏覽器與編輯器** —— 瀏覽工作區，用 CodeMirror 編輯程式碼
- **Git 面板** —— 不必離開介面即可暫存、提交、查看 diff 和切換分支
- **整合終端機** —— 每個工作區都有完整終端機，外加獨立的 shell 分頁
- **任務看板** —— 由 TaskMaster 驅動的看板檢視；將 PRD 轉換為可執行任務
- **MCP 管理** —— 在代理之間新增、編輯和同步 MCP 伺服器
- **技能瀏覽器** —— 在介面中管理代理技能
- **配額與用量** —— 各代理的 token 用量和訂閱額度一目瞭然
- **Browser-use** —— 由代理驅動的瀏覽器工作階段，用於研究和測試
- **Worktree** —— 為每個任務建立獨立的 git worktree，支援每個 worktree 的安裝/執行腳本和需驗證的開發伺服器即時預覽
- **遠端核准** —— 透過 Telegram、Discord 或行動應用程式核准工具權限
- **語音輸入** —— 透過相容 Whisper 的 STT 端點口述提示詞
- **代理廣播與共享記憶** —— 一次向所有代理傳送訊息，並維護所有代理都能讀取的專案筆記
- **多帳號切換** —— 每個供應商支援具名帳號，可按工作階段覆寫環境變數
- **排程器** —— cron 驅動的代理執行，網頁/桌面端支援 keep-awake
- **團隊協作** —— 角色（owner/member/viewer）、邀請連結、負責人、留言、在線狀態和看板動態（[文件](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md)）
- **MCP 伺服器** —— 讓外部 MCP 用戶端（Claude Desktop、OpenClaw）建立任務並向工作階段傳送訊息（[文件](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md)）
- **通知與 TTS** —— 當工作階段需要你時收到提醒（或語音播報）
- **Docker 沙箱** —— 在 microVM 隔離環境中執行代理（[文件](https://github.com/Zakwei/ddagent/blob/main/docker/README.md)）
- **桌面夥伴應用程式** —— 可選的 Electron 應用程式；**12 種語言**，深色與淺色主題

## 支援的代理

| 代理 | 連接方式 |
|---|---|
| **Claude Code** | 自動發現 `~/.claude` 工作階段；MCP 和設定與原生 CLI 同步 |
| **Codex** | 本機 CLI 工作階段與逐字稿 |
| **Cursor CLI** | 本機 CLI 工作階段 |
| **OpenCode** | 本機工作階段與技能位置 |
| **Devin** | 透過本機同步的 CLI/ACP 工作階段 |

你需要自備訂閱 —— ddagent 提供的是環境，而非 AI 本身。

## 安裝

執行伺服器的機器需要 **Node.js 22+**。伺服器提供網頁 UI 以及供桌面和行動應用程式遠端連接的 REST/WS API。

### 自架伺服器 —— 安裝腳本

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

將最新的發行標籤複製到 `~/.ddagent/app`，建置網頁 UI 和後端，並留下 `start.sh` 啟動器。選項：`--version vX.Y.Z` · `--dir <path>` · `--port <port>` · `--systemd`（安裝並啟用使用者級 systemd 單元）。使用 `--version` 重新執行即可就地更新。

然後：

```bash
~/.ddagent/app/start.sh        # → http://localhost:3001
```

### 自架伺服器 —— 預建 tarball

無需建置步驟 —— 從 [Releases](https://github.com/Zakwei/ddagent/releases) 下載 `ddagent-server-<version>-<os>-<arch>.tar.gz`，解壓縮並執行：

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh           # start.bat on Windows
```

### 桌面應用程式

從 [Releases](https://github.com/Zakwei/ddagent/releases) 下載適合你作業系統的安裝程式：`.dmg`（macOS）· `.exe`（Windows）· `.AppImage` / `.deb`（Linux）。

可獨立執行 —— 伺服器已內嵌，無需安裝其他元件 —— 也可以遠端模式連接自架伺服器 URL。透過發行中的 `latest*.yml` 來源自動更新。

### 行動應用程式（預覽）

從 [Releases](https://github.com/Zakwei/ddagent/releases) 下載 `ddagent-mobile-<version>.apk` 並安裝到你的 Android 裝置；應用程式會連接到自架伺服器 URL。

### 從原始碼建置

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run dev        # server :3001 + Vite :5173 with HMR
```

### Docker 沙箱（實驗性）

```bash
ddagent sandbox ~/my-project
```

在虛擬機器管理程式隔離的沙箱中執行代理。參見 [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md)。

## CLI

在原始碼或 `install.sh` 安裝目錄中，下面的 `ddagent` 指 `node dist-server/server/modules/cli/cli.js`（帶有 shebang，因此 `./dist-server/server/modules/cli/cli.js` 也可用）。

| 指令 | 說明 |
|---|---|
| `ddagent` | 啟動伺服器 |
| `ddagent start` | 啟動伺服器 |
| `ddagent status` | 顯示設定和資料位置 |
| `ddagent version` | 顯示版本號 |
| `ddagent help` | 顯示說明 |

## 設定

所有設定都在單一 env 檔案中 —— 執行 `ddagent status` 可查看你的設定從何處讀取。

| 變數 | 預設值 | 說明 |
|---|---|---|
| `SERVER_PORT` | `3001` | API + WebSocket 連接埠 |
| `VITE_PORT` | `5173` | 開發伺服器連接埠 |
| `HOST` | `0.0.0.0` | 綁定位址（僅本機使用 `127.0.0.1`） |
| `DATABASE_PATH` | auto | 驗證資料庫位置 |
| `CONTEXT_WINDOW` | `160000` | 每個工作階段的最大 token 數 |
| `CLAUDE_CLI_PATH` | `claude` | 自訂 Claude CLI 執行檔路徑 |

完整列表參見 [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example)。

## 開發

```bash
npm run dev            # dev mode (server :3001 + vite :5173)
npm run build          # client + server production build
npm run test:client    # frontend tests
npm test               # backend tests
npm run typecheck      # TypeScript check
```

後端程式碼遵循 `server/modules/` 中描述的模組化架構 —— 供應商內部實作參見 [`server/modules/providers/README.md`](https://github.com/Zakwei/ddagent/blob/main/server/modules/providers/README.md)。

## 貢獻

歡迎修正錯誤 —— 參見 [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md)。

---

<div align="center">
  <sub>為 Claude Code、Cursor、Codex、OpenCode 和 Devin 社群打造。</sub>
</div>
