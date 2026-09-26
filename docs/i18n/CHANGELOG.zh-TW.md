# 更新日誌

ddagent 的所有重要變更都記錄在此。

格式遵循 [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)，
本專案遵循 [Semantic Versioning](https://semver.org/)。

<p>
  <a href="../../CHANGELOG.md">English</a> ·
  <a href="CHANGELOG.pl.md">Polski</a> ·
  <a href="CHANGELOG.de.md">Deutsch</a> ·
  <a href="CHANGELOG.es.md">Español</a> ·
  <a href="CHANGELOG.fr.md">Français</a> ·
  <a href="CHANGELOG.it.md">Italiano</a> ·
  <a href="CHANGELOG.ja.md">日本語</a> ·
  <a href="CHANGELOG.ko.md">한국어</a> ·
  <a href="CHANGELOG.ru.md">Русский</a> ·
  <a href="CHANGELOG.tr.md">Türkçe</a> ·
  <a href="CHANGELOG.zh-CN.md">简体中文</a> ·
  <strong>繁體中文</strong>
</p>

## [0.6.2] - 2026-09-26

### 問題修復

- 行動端：設定中顯示硬編碼的「0.1.0 (mobile scaffold)」標籤 — 現已顯示真實應用程式版本；正式版 APK 帶有發佈版本號，Android 可就地更新

## [0.6.1] - 2026-09-26

### 問題修復

- 行動端：新聊天中模型選擇器不可用，無法存取多面板工作區
- 行動端：分割工作區窗格現在嵌入真實的聊天檢視

## [0.6.0] - 2026-09-26

### 新增功能

- **Auto 編排提供者** — 模型路由、規劃器 DAG 和委派；聊天中提供路由/計畫/委派/摘要卡片，設定中新增編排分頁
- **行動端：全面原生化** — 所有畫面均已原生實現：Files（CRUD、搜尋、燈箱）、Source Control（程式碼區塊暫存、分割 diff、提交圖、工作樹）、Tasks（PRD 編輯器、詳細資料編輯）、Agent Board、Quota & Usage、終端機、編輯器和所有設定分頁
- **行動端：** 引導精靈、專案建立精靈（資料夾瀏覽器、GitHub 複製、檢查）、帶全域搜尋的命令面板、分割工作區網格、快捷設定面板、browser-use 即時面板
- **行動端：** 離線訊息佇列、聊天匯出（PDF/md/html/text）、對話記錄搜尋、工作階段比較

### 問題修復

- OpenCode：串流文字快照導致工作階段列重複，question 工具提示未顯示
- 固定的 Review/Search 列遮擋第一條訊息

## [0.5.9] - 2026-09-25

首個公開開源版本 — **AGPL-3.0-only**。

### 新增功能

- **團隊協作** — 共享工作階段、廣播訊息、代理收件匣、按專案共享記憶
- **MCP 伺服器** — 外部 MCP 用戶端（Claude Desktop、OpenClaw）可透過 `POST /mcp` 建立任務並向工作階段傳送訊息（[文件](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md)）
- **遠端審批** — 從 Telegram 或 Discord 核准代理操作（[文件](https://github.com/Zakwei/ddagent/blob/main/docs/remote-approvals.md)）
- **排程器** — 帶防睡眠功能的代理執行 cron 排程
- **命名提供者帳戶** — 按工作階段覆寫環境變數/憑證
- **語音輸入（STT）** — 輸入框中的 Whisper 相容端點
- **工作樹** — 帶 dev-server 執行器的按儲存庫設定/執行腳本
- **預覽** — 帶 WS 隧道的經身分驗證 dev-server 預覽代理
- **行動端** — 工作階段搜尋、可操作的審批推播通知（FCM）
- `SECURITY.md` — 私密漏洞回報政策

### 問題修復

- 配額分頁的資料和顯示錯誤
- 聊天：離線佇列和草稿在重新載入後保留；重新擷取時捲動位置穩定
- 工作階段：已刪除的工作階段不再在其他用戶端留下殘留
- 看板：代理面板上的派發競態和洩漏
- 行動端：原始鍵盤高度內邊距，用 ActionSheet 取代溢位警示

## [0.5.8] - 2026-09-23

### 新增功能

- `install.sh` — 基於 git 的伺服器安裝程式（`--version`、`--dir`、`--port`、`--systemd`）
- 在 `v*` 標籤上發佈的獨立和本地伺服器 tarball

### 問題修復

- 行動鍵盤遮擋輸入框和系統導覽列下的內容（Android）

## [0.5.7] - 2026-09-23

### 問題修復

- 桌面 CI 建置（套件平台旗標、原生重新編譯、冒煙測試逾時）
- 聊天記錄中串流助理訊息重複

## [0.5.6] - 2026-09-23

### 問題修復

- 桌面 CI：缺少 Apple 金鑰時 macOS 建置未簽名、Windows 範圍套件暫存

## [0.5.5] - 2026-09-23

### 新增功能

- **桌面應用程式（預覽）** — 用於本地或遠端伺服器的 Electron 啟動器、內嵌後端、自動更新、dmg/NSIS/AppImage/deb 建置
- **行動應用程式（預覽）** — Expo/React Native 伴侶應用：工作階段、帶模型選擇器和斜線命令的聊天、終端機、檔案、設定 WebView
- 有未讀輸出的工作階段上的未讀指示器；任務面板 ↔ 工作階段關聯
- 聊天中的 KaTeX 和 Mermaid 島嶼

### 問題修復

- 行動檢視區的觸控目標和版面配置；命令面板、看板和設定改善

## [0.5.4] - 2026-09-21

### 新增功能

- 帶全螢幕進度遮罩的重新啟動伺服器按鈕（設定 → 關於）
- 設定 → 關於中的本地化 GitHub 版本更新日誌
- 瀏覽器分頁標題中顯示執行中的工作階段數
- 使用趨勢圖表的 Y 軸刻度和懸停提示

### 問題修復

- 開啟模態框時觸發設定自動儲存；多列分割中的精簡聊天版面

## [0.5.3] - 2026-09-21

### 問題修復

- 更新可用對話框被側邊欄遮擋（portal 修復）

## [0.5.2] - 2026-09-21

### 問題修復

- 更新檢查改為透過伺服器進行

## [0.5.1] - 2026-09-21

### 新增功能

- 帶一鍵自我更新的更新可用徽章
- 按工作階段的朗讀語音；語音選擇器移至外觀設定

### 問題修復

- 聊天橫幅顯示工作階段的實際提供者

## [0.5.0] - 2026-09-21

**ddagent** 的首個獨立版本 — 面向 AI 編碼代理的自我託管 Web 和行動 UI。

### 亮點

- **多代理工作階段** — Claude Code、Codex、Cursor CLI、OpenCode 和 Devin 並排執行，支援即時串流和恢復
- **工作區版面配置** — 聊天、終端機、瀏覽器和檔案的分割窗格
- **檔案瀏覽器和編輯器** — 在 UI 中瀏覽和編輯工作區
- **Git 面板** — 暫存、提交、差異、切換分支、管理工作樹
- **任務面板** — 由 TaskMaster 驅動的看板；從 PRD 產生可執行任務
- **MCP 管理** — 跨代理新增和同步 MCP 伺服器
- **技能瀏覽器** — 探索和管理代理技能
- **配額與用量** — 各代理的權杖用量和訂閱限額
- **Browser-use** — 用於研究和測試的代理驅動瀏覽器工作階段
- **通知與 TTS** — 提醒和朗讀回覆
- **Docker 沙箱** — 實驗性虛擬機管理程式隔離的代理執行
- **桌面伴侶應用** — macOS/Windows 選用 Electron 應用程式
- **i18n** — 11 種 UI 語言、明暗主題

### CLI

- `ddagent` / `ddagent start` — 啟動伺服器
- `ddagent status` — 顯示設定與資料位置
- `ddagent version` / `ddagent help`
