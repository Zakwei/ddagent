# 知識庫

<p>
  <a href="../../KNOWLEDGE.md">English</a> ·
  <a href="KNOWLEDGE.pl.md">Polski</a> ·
  <a href="KNOWLEDGE.de.md">Deutsch</a> ·
  <a href="KNOWLEDGE.es.md">Español</a> ·
  <a href="KNOWLEDGE.fr.md">Français</a> ·
  <a href="KNOWLEDGE.it.md">Italiano</a> ·
  <a href="KNOWLEDGE.ja.md">日本語</a> ·
  <a href="KNOWLEDGE.ko.md">한국어</a> ·
  <a href="KNOWLEDGE.ru.md">Русский</a> ·
  <a href="KNOWLEDGE.tr.md">Türkçe</a> ·
  <a href="KNOWLEDGE.zh-CN.md">简体中文</a> ·
  <strong>繁體中文</strong>
</p>

ddagent 為你的代理提供一個**本地優先的知識庫**：記憶、規則、技能和個人資訊，
外加標籤和關係。它存在於與 ddagent 其餘部分相同的 SQLite 資料庫（`auth.db`）中，
背後是 FTS5 全文索引，可從用戶端的 **Knowledge** 介面管理，並可由你的代理
透過 MCP 讀寫。它鬆散地受到
[Contexta](https://github.com/XFABISIEK/Contexta) 的啟發。

要點很簡單：你的規則和專案知識不再分散在各個工具的檔案
（`AGENTS.md`、`CLAUDE.md`、`.cursorrules`、`skills/` 等）中，
而是成為一個經過精心整理、可搜尋的單一位置，每個代理都能使用它——無論是
讀取檔案的代理，還是透過 MCP 通訊的代理。

## 代理實際看到的樣子

共有三層，弄清楚哪層是哪層很有幫助：

- **CLI 原生檔案** — 每個工具各自讀取自己的設定：Claude Code
  讀取 `CLAUDE.md`，Codex/Cursor 讀取 `AGENTS.md`，Cursor 讀取 `.cursorrules`，
  還有一些讀取 `skills/` 和 `.agents/skills/`。這是 CLI 的職責，而非
  模型的選擇——ddagent 不會關閉它。
- **ddagent 注入** — 在對話的第一輪，ddagent 會在前面加上一個
  `<knowledge>` 區塊（詳見下文）。這對所有供應商都有效，且
  無需代理做任何設定。
- **MCP 工具** — 一旦你把 ddagent 的 MCP 伺服器安裝到某個代理，它的工具
  清單就會包含 `knowledge_search` 之類。模型會根據工具描述以及你在
  知識庫中保存的指令規則，決定何時呼叫它們。

所以「一個位置」意味著**一個整理注入內容的位置和一個預算**
——它不會（也無法）阻止 CLI 讀取自己的原生檔案。為了避免
重複，我們把工作區的 `AGENTS.md` 保持在 `high` 優先級，這樣知識
區塊永遠不會重複 unified-rules 已經注入的內容。

## 實體

| 實體 | 範圍 | 說明 |
|---|---|---|
| 記憶 | 專案或全域 | `memory_type`（`fact`/`decision`/`note`/`reference`）、`priority`、`source`、標籤 |
| 規則 | 專案或全域 | `enabled` 開關；`critical` 規則會注入工作階段 |
| 技能 | 全域 | 唯一名稱、分類、可選圖示（base64 data URL） |
| 個人資訊 | 全域 | 唯一 `key` |
| 標籤 / 連接 | — | 記憶上的標籤；連接可連接任意兩個實體 |
| 歷史 | — | 每次寫入都會為實體建立快照，便於檢視和還原 |

優先級：`critical > high > normal > low`。實體可以限定到一個
專案，也可以是全域的（適用於所有地方）。`project_id` 是普通欄（沒有
外鍵），因為專案表在遷移期間會被重建。

## 首輪注入（每個代理自動獲得的內容）

在對話的**第一**則外送訊息中，ddagent 會在前面加上一個 `<knowledge>`
區塊，包含：

- `critical` **規則**（專案 + 全域，僅啟用的），
- `critical` **記憶**，
- 每一條**個人資訊**項目，
- 所含記憶的**1 跳鄰居**（透過明確
  連接到達）。

整個區塊上限約為 4000 個 token。它走與
`.ddagent/shared-context.md` 和 unified rules 相同的首輪閘門，因此不會消耗每輪 token。
設定 `DDAGENT_KNOWLEDGE=0` 可退出。

儀表板會為所選專案顯示一個**注入上下文計量表**（`~X / 4000 tok`），
這樣你可以看到並控制進入上下文的內容。

## MCP 工具（隨需）

ddagent 的 MCP 伺服器（`POST /mcp`）把知識庫暴露給任何 MCP 用戶端。
讀取工具使用 `read` 範圍的 token；寫入工具需要 `write`。寫入
工具執行與 UI 相同的驗證並記錄歷史。

讀取：`knowledge_search`、`knowledge_get_context`、`knowledge_get_memories`、
`knowledge_get_rules`、`knowledge_get_skills`、`knowledge_get_personal`、
`knowledge_get_graph`、`knowledge_history`。

寫入：`knowledge_add_memory`、`knowledge_update_memory`、
`knowledge_delete_memory`，以及 `rule`、`skill` 和 `personal` 的同樣三件套；
外加 `knowledge_link` / `knowledge_unlink`。

工具接受 `projectId`，或 ddagent 已經知道的 `projectPath`。

### 把伺服器安裝到你的代理

你不必手動編輯供應商設定。使用 **Settings → MCP →
Install ddagent MCP server**（在引導流程中也會作為一步提供）並選擇
代理——或為所有代理安裝。它會寫入一個 `ddagent` HTTP MCP 項目（使用者
範圍），指向 `<server>/mcp`，並帶一個可重複使用的 `ddagent-mcp` bearer token
（重新安裝會撤銷上一個）。安裝後，該代理的工具
會包含 `knowledge_*` 群組，以及 `create_task`、`send_message` 等。

代理怎麼知道*何時*使用 MCP？它不會猜——告訴它。保存一條
`critical` 規則，例如：*「在回答關於此專案的問題之前，呼叫
`knowledge_search`；當你定下一項決定時，用
`knowledge_add_memory` 將其持久化。」* 因為這條規則在每輪首輪都會注入，所有
代理都會得到相同的操作指令。

## 專案掃描

`POST /api/knowledge/scan` 按意圖分類匯入專案的 AI 上下文檔案：

- `AGENTS.md`、`CLAUDE.md`、`MUSE.md`、`GEMINI.md`、`CODEX.md`、`.cursorrules`、
  `.muserules` 以及 `.cursor/rules` 下的 markdown/`.mdc` 成為**規則**
  （critical + enabled，因此會進入代理上下文；工作區 `AGENTS.md`
  為 `high`，以避免與 unified-rules 重複注入），
- `skills` / `.agents/skills` 下的 `SKILL.md` 檔案成為**技能**
  （名稱/描述來自 frontmatter），
- 掃描到的任何其他 markdown 成為**參考記憶**。

每個檔案透過內容雜湊記錄在 `kb_scan_state` 中，因此重新掃描只會
觸及已變更的檔案，並刪除來源已消失的實體。

## 用戶端

**Knowledge** 介面（導覽列 → Knowledge）有 Dashboard、Memories、
Rules、Skills、Personal 和 Graph 分頁，一個專案範圍篩選器，一個彈窗
建立/編輯表單，帶還原的按實體版本歷史，技能圖示上傳以及
JSON 匯出/匯入。Memories 分頁有標籤篩選列（帶標籤管理），
應用列有全文搜尋、建立連接對話框和遷移操作，
Graph 分頁是一個力導向關係檢視，帶平移/縮放、節點
拖曳、實體類型篩選和鄰居突顯。Settings → Knowledge
會深度連結到同一介面。

## 好好整理它

1. 對每個使用中的專案**掃描**一次（Knowledge → 選擇專案 → scan）；
   在其指令檔案發生大改動後重新掃描。
2. **有意識地提升**：只有真正有約束力的規則才應該是 `critical`
   （它們會被注入）。使用列上的星號，並留意預算計量表。
3. **其餘保持 `high`/`normal`**——仍然可搜尋、可透過 MCP 使用，
   而不在每輪消耗上下文。
4. 用**個人資訊**存跨專案偏好（時區、編輯器、命名）。
5. **連結相關記憶**，讓 1 跳鄰居一起帶上。
6. 對應當搜尋知識庫並持久化所學內容的代理**安裝 MCP**；
   給大多數 `read` 範圍，在信任的代理上給 `write`。

## 遷移

Knowledge → 選單 → **Migrate existing rules** 會執行一份 **dry-run** 報告：它
掃描所有專案，找出跨專案存在的重複項（相同的正規化
標題 + 內容），並顯示規則數量。你可以從這裡**Merge duplicates**
（把它們合併為一個全域列）和/或 **Make all rules critical**。在你確認之前
不會寫入任何內容——破壞性操作都是明確的。

同一個選單裡還有**匯入代理技能**：它會列出你的代理已經自帶或已安裝的全域/預設技能（使用者 / 系統 / 外掛範圍），並把缺少的技能作為技能匯入知識庫。它會先進行 dry-run，而且是冪等的——已存在的名稱會被略過。專案範圍的技能則由專案掃描匯入。

## 須知

- 一切都**本地**於這個 ddagent 實例；沒有雲端，沒有同步。
- 注入**每個工作階段一次**（首輪）——新工作階段會取得
  變更。
- 掃描到的技能**不會注入**；它們可透過 MCP 搜尋到達，
   這讓常駐上下文保持精簡。
- 規則或記憶可由代理透過 MCP 編輯；在實體的 **History** 中檢視
  變更，必要時還原之前的版本。

## REST API

掛載在 `/api/knowledge`，位於驗證之後：

```
GET    /memories            ?projectId=&includeGlobal=&priority=&tag=&memoryType=&limit=&offset=
POST   /memories            PATCH /memories/:id   DELETE /memories/:id
GET    /rules               ?projectId=&includeGlobal=&priority=&enabledOnly=
POST   /rules               PATCH /rules/:id       DELETE /rules/:id
GET    /skills              ?category=
POST   /skills              PATCH /skills/:id      DELETE /skills/:id
GET    /personal            POST /personal         PATCH/DELETE /personal/:id
GET    /search              ?q=&type=&projectId=&limit=
GET    /graph               ?projectId=&types=&limit=
GET    /context             ?projectId=            (injection preview + budget)
GET    /tags                DELETE /tags/:id
GET    /connections         POST /connections      DELETE /connections/:id
GET    /history             ?entityType=&entityId=&limit=
GET    /stats
GET    /export              POST /import
POST   /scan                { projectId }
POST   /migrate             { projectIds?, dryRun?, dedupe?, promoteRules? }
POST   /import-skills       { providers?, scopes?, dryRun? }
```

`projectId=global` 將清單限制為全域列；把 `includeGlobal=true`
加到專案 id 上會回傳專案列加上全域列。

## 相關

- [作為 MCP 伺服器的 ddagent](mcp-server.md) — 工具目錄和 token 設定
- [團隊協作](teams.md) · [遠端核准](remote-approvals.md)
