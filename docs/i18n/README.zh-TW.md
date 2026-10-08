<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>一個介面，統整你所有的 AI 程式開發代理。</strong><br>
  為 Claude Code、Codex、Cursor CLI、OpenCode、Devin、Command Code 和 Antigravity 打造的自架伺服器與 Flutter 用戶端（網頁、Linux、Windows 與 Android）—— 工作階段、檔案、git、終端機和任務，全部集中在一處。</p>

  <p>
    <img src="https://img.shields.io/github/v/release/Zakwei/ddagent?label=版本&amp;color=0066FF" alt="版本">
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
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/mobile-chat.png" alt="ddagent 行動版畫面" width="20%">
</p>

<table>
  <tr>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/sessions.png" alt="來自 Claude Code 與 Codex 的最近工作階段"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/kanban-board.png" alt="驅動代理執行的看板"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/git-panel.png" alt="可逐一暫存程式碼區塊的 Git 面板"></td>
  </tr>
  <tr>
    <td align="center"><sub>所有代理的工作階段都在同一份清單中</sub></td>
    <td align="center"><sub>看板 —— 用卡片啟動代理執行</sub></td>
    <td align="center"><sub>Git 面板 —— 檢視 diff、暫存區塊、提交</sub></td>
  </tr>
</table>

---

## ddagent 是什麼？

ddagent 在你自己的電腦或 VPS 上執行，為你平常使用的程式開發代理提供一套精緻、統一的介面。伺服器會直接從各代理自己的磁碟歷史紀錄（`~/.claude`、`~/.codex`、`~/.cursor`、OpenCode、Devin 等）讀取工作階段，因此既有的對話不必匯入就會直接出現。只有工作階段的中繼資料會在本機建立索引，任何資料都不會傳送給第三方。

透過 Flutter 用戶端，就能從桌機、手機或瀏覽器連線。你的電腦、你的代理、你的資料。

## 功能特色

- **多代理工作階段** —— 並列執行並繼續七種代理 CLI 的工作階段，透過 WebSocket 即時串流
- **自動調度器** —— 「Auto」工作階段會考量剩餘的訂閱額度，把每項任務分派給合適的代理與模型，並將工作委派給子工作階段
- **分割工作區** —— 單一視窗最多可放六個窗格（聊天、終端機、瀏覽器、預覽、編輯器、git、筆記）
- **檔案總管與編輯器** —— 瀏覽工作區，並在內建編輯器中編輯程式碼
- **Git 面板** —— 不必離開介面，就能暫存檔案或個別程式碼區塊、提交（可由 AI 產生提交訊息）、檢視 diff、切換分支、pull/push 以及還原檢查點
- **整合式終端機** —— 每個工作區都有完整的 shell
- **看板** —— 移動卡片即可針對該卡片啟動代理執行（可選擇在獨立的 worktree 中進行）；代理完成後會回報結果
- **TaskMaster** —— 將 PRD 轉換成任務，並在任務看板上追蹤
- **訊息佇列** —— 代理忙碌時送出的訊息會在伺服器端排入佇列，重新整理頁面或切換裝置後仍會保留
- **MCP 管理** —— 在各代理之間新增、編輯與同步 MCP 伺服器
- **知識庫** —— 所有代理共用的單一本機記憶，可供搜尋：規則、技能、記憶與個人資訊，透過 MCP 依需求擷取（[說明文件](KNOWLEDGE.zh-TW.md)）
- **技能與規則** —— 在同一處管理代理技能與共用規則
- **額度與用量** —— 各代理的 token 用量與訂閱限制一目瞭然
- **Browser-use** —— 由代理操控的瀏覽器工作階段，用於研究與測試，並附有即時瀏覽器窗格
- **Worktree** —— 為每項任務建立隔離的 git worktree，可為每個 worktree 設定安裝/執行指令碼，並提供經過驗證的開發伺服器即時預覽
- **遠端核准** —— 透過 Telegram、Discord 或 Android 應用程式核准工具權限（[說明文件](https://github.com/Zakwei/ddagent/blob/main/docs/remote-approvals.md)）
- **語音輸入** —— 透過相容 Whisper 的語音轉文字端點以口述方式輸入提示詞
- **代理廣播與共用記憶** —— 一次傳訊息給所有代理，並維護一份大家都會讀取的專案筆記
- **多帳號切換** —— 每個供應商可設定具名帳號，並可針對個別工作階段覆寫環境變數
- **排程器** —— 由 cron 驅動、無人值守的代理執行，並可選擇在執行期間讓裝置保持喚醒
- **團隊協作** —— 角色（owner/member/viewer）、邀請連結、負責人、留言、上線狀態，以及看板上的動態消息（[說明文件](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md)）
- **MCP 伺服器** —— 讓外部 MCP 用戶端（Claude Desktop、OpenClaw）列出工作階段、建立任務並傳送訊息給工作階段（[說明文件](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md)）
- **通知與 TTS** —— 當工作階段需要你處理時，透過推播、Telegram 與 Discord 通知你，也可選擇朗讀回覆
- **命令選擇區** —— 按 `Ctrl/Cmd+Shift+K` 搜尋工作階段與訊息、跳至任一頁面或執行快速動作
- **Docker 沙箱** —— 在以 microVM 隔離的 Docker Sandboxes 中執行代理（[說明文件](https://github.com/Zakwei/ddagent/blob/main/docker/README.md)）
- **Flutter 用戶端** —— 網頁、Linux、Windows 與 Android 共用同一套程式碼；支援 **12 種語言**，以及深色與淺色主題

## 支援的代理

| 代理 | 連線方式 |
|---|---|
| **Claude Code** | Claude Agent SDK；自動探索 `~/.claude` 工作階段；MCP 與設定會和原生 CLI 同步 |
| **Codex** | Codex SDK；來自 `~/.codex` 的本機工作階段與對話紀錄 |
| **Cursor CLI** | 具串流 JSON 輸出的 `cursor-agent`；來自 `~/.cursor` 的本機聊天 |
| **OpenCode** | `opencode serve`；來自 OpenCode 資料庫的本機工作階段 |
| **Devin** | `devin acp`（Agent Client Protocol）；本機對話紀錄 |
| **Command Code** | `command-code acp`（Agent Client Protocol）；來自 `~/.commandcode` 的對話紀錄 |
| **Antigravity** | 以 headless 模式執行的 `agy` CLI；從 `~/.gemini/antigravity-cli` 建立索引的對話 |

各代理 CLI 必須已安裝在伺服器所在的電腦上並完成登入。訂閱需自備 —— ddagent 提供的是環境，而不是 AI 本身。

## 安裝

ddagent 由兩部分組成：與代理在同一台電腦上執行、提供 REST/WebSocket API 的**伺服器**，以及連線到伺服器的**用戶端**。伺服器需要 **Node.js 22+**（預先建置的 tarball 則需要 Node.js 22.x，因為其中的原生模組是針對該版本建置的）。

### 伺服器 —— 安裝指令碼

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

需要 `git`、Node.js 22+ 與 `npm`。這個指令碼會將某個發行標籤複製到 `~/.ddagent/app`、安裝相依套件、建置後端，並產生 `start.sh` 啟動器。選項請接在 `bash -s --` 之後：

| 選項 | 說明 |
|---|---|
| `--version vX.Y.Z` | 安裝指定版本（預設：最新版） |
| `--dir <path>` | 安裝目錄（預設：`~/.ddagent/app`） |
| `--systemd` | 安裝並啟用名為 `ddagent` 的 systemd 使用者服務 |
| `--port <port>` | systemd 服務使用的連接埠（預設：`3001`） |

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash -s -- --systemd --port 3001
```

若要更新，請加上 `--version vX.Y.Z` 重新執行指令碼，它會直接就地更新現有的副本。接著啟動伺服器：

```bash
~/.ddagent/app/start.sh        # API on http://<host>:3001 (set SERVER_PORT to change)
```

### 伺服器 —— 預先建置的 tarball

不需建置：從 [Releases](https://github.com/Zakwei/ddagent/releases) 下載 `ddagent-server-<version>-<os>-<arch>.tar.gz`（`linux-x64`、`mac-arm64` 或 `win-x64`），解壓縮後執行啟動器：

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh             # start.bat on Windows
```

每個 tarball 都附有 `.sha256` 總和檢查碼。設定請寫在 `start.sh` 旁一個選用的 `.env` 檔案中。

### 用戶端

從 [Releases](https://github.com/Zakwei/ddagent/releases) 下載預先建置的用戶端：

| 平台 | 檔案 |
|---|---|
| Windows x64 | `ddagent-flutter-windows-x64-<tag>-setup.exe`（安裝程式）或 `.zip`（免安裝版） |
| Linux x64 | `ddagent-flutter-linux-x64-<tag>.deb` 或 `.tar.gz` |
| Android | `ddagent-flutter-android-<tag>.apk` |
| Web | `ddagent-flutter-web-<tag>.zip` |

第一次啟動時，輸入你的伺服器網址（例如 `http://my-vps:3001`）並建立第一個帳號。在 Windows 與 Linux x64 上，桌面用戶端也能替你下載並執行本機伺服器（連線畫面中的「這部裝置」）。

網頁版沒有登入畫面，且會呼叫同一來源（origin）上的 API，因此必須透過反向代理提供服務，而後方的伺服器需以單一使用者平台模式執行（`VITE_IS_PLATFORM=true`，此模式會停用身分驗證）。在原始碼副本中，`node scripts/serve-flutter-web.cjs` 會在 8085 連接埠提供 `flutter/build/web`，並將 API 與 WebSocket 代理到在 `FLUTTER_BACKEND_PORT`（預設 `10087`）上執行的伺服器。請只在可信任的網路中開放這種部署方式。

自行建置用戶端：

```bash
cd flutter
flutter pub get
flutter build linux --release      # or: windows, apk, web
```

### 從原始碼建置

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run build && node dist-server/server/index.js   # API on http://localhost:3001
```

### Docker 沙箱（實驗性）

```bash
ddagent sandbox ~/my-project
```

在以 microVM 隔離的 Docker Sandbox 中執行 ddagent 與一個代理（Claude Code 或 Codex）。需要 `sbx` CLI —— 請參閱 [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md)。

## CLI

在原始碼或 `install.sh` 安裝的副本中，下文的 `ddagent` 指的是 `node dist-server/server/modules/cli/cli.js`（檔案帶有 shebang，所以也可以直接執行 `./dist-server/server/modules/cli/cli.js`）。

| 指令 | 說明 |
|---|---|
| `ddagent` / `ddagent start` | 啟動伺服器（預設指令） |
| `ddagent status` | 顯示版本，以及設定檔、資料庫與 Claude 專案的位置 |
| `ddagent sandbox <workspace>` | 建立並啟動 Docker 沙箱；`ddagent sandbox help` 會列出 `ls`、`start`、`stop`、`rm`、`logs` |
| `ddagent browser-use-mcp` | 透過 stdio 執行 browser-use MCP 伺服器 |
| `ddagent version` | 輸出版本號 |
| `ddagent help` | 顯示說明 |

| 選項 | 說明 |
|---|---|
| `-p, --port <port>` | 伺服器連接埠（覆寫 `SERVER_PORT`） |
| `--database-path <path>` | 自訂資料庫位置（覆寫 `DATABASE_PATH`） |

## 設定

伺服器會讀取安裝目錄中（`start.sh` 旁）選用的 `.env` 檔案；實際的環境變數優先順序較高。執行 `ddagent status` 即可查看目前使用的是哪個檔案。

| 變數 | 預設值 | 說明 |
|---|---|---|
| `SERVER_PORT` | `3001` | API + WebSocket 連接埠（仍接受舊版別名 `PORT`） |
| `HOST` | `0.0.0.0` | 繫結位址（僅限本機存取時使用 `127.0.0.1`） |
| `DATABASE_PATH` | `~/.ddagent/auth.db` | SQLite 資料庫（使用者、設定、權杖） |
| `WORKSPACES_ROOT` | 家目錄 | 專案必須位於此目錄之下 |
| `JWT_SECRET` | 自動產生 | 用於簽署登入權杖的密鑰（每個安裝個別產生並儲存） |
| `API_KEY` | 未設定 | 設定後，API 請求必須在 `x-api-key` 標頭中附上此金鑰 |
| `CLAUDE_CLI_PATH` | `claude` | 自訂 Claude Code CLI 執行檔 |
| `CONTEXT_WINDOW` | `200000` | Claude 上下文視窗的備用值，在 SDK 回報模型實際的視窗大小之前使用 |
| `STT_ENDPOINT_URL` / `STT_API_KEY` / `STT_MODEL` | `https://api.openai.com/v1` / 未設定 / `whisper-1` | 語音輸入所用的語音轉文字服務（也可在「設定」中調整） |
| `VITE_IS_PLATFORM` | `false` | 單一使用者平台模式：略過身分驗證（網頁用戶端必須啟用） |

更多內容請參閱 [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example)。

## 開發

```bash
npm install
npm run dev               # start the backend from source (tsx, no reload)
npm run server:dev-watch  # same, restarting on file changes
npm run build             # compile the server to dist-server/
npm test                  # backend tests
npm run typecheck         # TypeScript check
npm run lint              # ESLint
```

用戶端（Flutter 3.47.5 stable）：

```bash
cd flutter
flutter pub get
flutter run -d linux --dart-define=DEFAULT_SERVER_URL=http://localhost:3001
dart format --line-length 100 lib test
flutter analyze
flutter test
```

後端程式碼遵循 `server/modules/` 中的模組化架構；供應商的內部實作請參閱 [`server/modules/providers/README.md`](https://github.com/Zakwei/ddagent/blob/main/server/modules/providers/README.md)。

## 貢獻

歡迎提交錯誤修正 —— 請參閱 [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md)。若要回報安全性漏洞，請參閱 [SECURITY.md](https://github.com/Zakwei/ddagent/blob/main/SECURITY.md)。

---

<div align="center">
  <sub>為 Claude Code、Codex、Cursor、OpenCode、Devin、Command Code 和 Antigravity 社群打造。</sub>
</div>
