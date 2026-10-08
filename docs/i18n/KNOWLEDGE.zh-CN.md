# 知识库

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
  <strong>简体中文</strong> ·
  <a href="KNOWLEDGE.zh-TW.md">繁體中文</a>
</p>

DDAgent 为你的智能体提供一个**本地优先的知识库**：记忆、规则、技能和个人信息，
外加标签和关系。它存在于与 DDAgent 其余部分相同的 SQLite 数据库（`auth.db`）中，
背后是 FTS5 全文索引，可从客户端的 **Knowledge** 界面管理，并可由你的智能体
通过 MCP 读写。它松散地受到
[Contexta](https://github.com/XFABISIEK/Contexta) 的启发。

要点很简单：你的规则和项目知识不再分散在各个工具的文件
（`AGENTS.md`、`CLAUDE.md`、`.cursorrules`、`skills/` 等）中，
而是成为一个经过精心整理、可搜索的单一位置，每个智能体都能使用它——无论是
读取文件的智能体，还是通过 MCP 通信的智能体。

## 智能体实际看到的样子

共有三层，弄清楚哪层是哪层很有帮助：

- **CLI 原生文件** — 每个工具各自读取自己的配置：Claude Code
  读取 `CLAUDE.md`，Codex/Cursor 读取 `AGENTS.md`，Cursor 读取 `.cursorrules`，
  还有一些读取 `skills/` 和 `.agents/skills/`。这是 CLI 的职责，而非
  模型的选择——DDAgent 不会关闭它。
- **DDAgent 的首轮前缀** — 在会话的第一条消息中，DDAgent 会在前面加上项目的
  `.ddagent/shared-context.md` 和一个 `<unified-rules>` 块（工作区 `AGENTS.md`、
  `~/.agents/AGENTS.md` 以及一条简短的规范提示；设置 `DDAGENT_UNIFIED_RULES=0`
  可去掉它）。这基于文件，与知识库相互独立。
- **MCP 检索（按需）** — 一旦你把 DDAgent 的 MCP 服务器安装到某个智能体，它的
  工具列表就会包含 `knowledge_get_context`、`knowledge_search` 之类。遵循
  Contexta，不会有任何东西被自动注入：智能体用查询调用上下文构建器，取回
  `critical` 规则以及所有匹配的内容。模型会根据工具描述以及你在知识库中保存的
  指令规则，决定何时调用它。

所以“一个位置”意味着**一个整理知识的位置**——它不会（也无法）阻止 CLI
读取自己的原生文件。DDAgent 完全不会把知识库自动注入会话。

## 实体

| 实体 | 范围 | 说明 |
|---|---|---|
| 记忆 | 项目或全局 | `memory_type`（`fact`/`decision`/`note`/`reference`）、`priority`、`source`、标签 |
| 规则 | 项目或全局 | `enabled` 开关；`critical` 规则总是由上下文构建器优先返回 |
| 技能 | 全局 | 唯一名称、分类、可选图标（base64 data URL） |
| 个人信息 | 全局 | 唯一 `key` |
| 标签 / 连接 | — | 记忆上的标签；连接可连接任意两个实体 |
| 历史 | — | 每次写入都会为实体创建快照，便于查看和恢复 |

优先级：`critical > high > normal > low`。实体可以限定到一个
项目，也可以是全局的（适用于所有地方）。`project_id` 是普通列（没有
外键），因为项目表在迁移期间会被重建。

## 检索上下文（按需）

智能体通过 MCP 工具 `knowledge_get_context` 获取上下文（Contexta
ContextBuilder 的忠实移植）。给定项目和查询，它会按顺序返回：

- **所有启用的规则**（项目 + 全局），`critical` 优先（上限 20），
- 按查询排序的**记忆**（FTS），外加通过连接到达的 1 跳邻居（上限 5）；
  没有查询时，按优先级返回项目的靠前记忆，
- 按查询排序的**技能**；没有查询时，返回最近的技能，
- 仅在查询匹配时才返回的**个人信息**（上限 3），

渲染为一个 Markdown 块，其中的条目按区段截断（800/1000/600 字符），并受
`maxTokens` 限制（默认约 4000）；不再放得下的条目计为省略。

仪表盘会为所选项目显示一个**规则上下文计量表**（`~X / 4000 tok`）——
每次 `knowledge_get_context` 调用始终包含的规则块大小。不会向会话自动注入任何内容。

搜索排名是混合式的，就像 Contexta 的 `search.rs`：FTS5 **prefix** 匹配（`auth` 也会匹配 `authentication`），加上一遍模糊的 **trigram** 处理，用来捕捉拼写错误和近义词，然后按 `bm25 + priority + recency` 重新排序。

## MCP 工具（按需）

DDAgent 的 MCP 服务器（`POST /mcp`）把知识库暴露给任何 MCP 客户端。
读取工具使用 `read` 范围的 token；写入工具需要 `write`。写入
工具执行与 UI 相同的校验并记录历史。

读取：`knowledge_search`、`knowledge_get_context`、`knowledge_get_memories`、
`knowledge_get_rules`、`knowledge_get_skills`、`knowledge_get_personal`、
`knowledge_get_graph`、`knowledge_history`。

写入：`knowledge_add_memory`、`knowledge_update_memory`、
`knowledge_delete_memory`，以及 `rule`、`skill` 和 `personal` 的同样三件套；
外加 `knowledge_link` / `knowledge_unlink`。

工具接受 `projectId`，或 DDAgent 已经知道的 `projectPath`。

### 把服务器安装到你的智能体

你不必手动编辑提供商配置。使用 **Settings → Agents →
（智能体） → MCP → Install DDAgent MCP server**（在引导流程中也会作为一步提供）并选择
智能体——或为所有智能体安装。它会写入一个 `ddagent` HTTP MCP 条目（用户
范围），指向 `<server>/mcp`，并带一个可复用、具有 `write` 范围的 `ddagent-mcp` bearer token
（重新安装会吊销上一个）。安装后，该智能体的工具
会包含 `knowledge_*` 组，以及 `create_task`、`send_message` 等。

智能体怎么知道*何时*使用 MCP？它不会猜——告诉它。保存一条
`critical` 规则，例如：*“在回答关于此项目的问题之前，调用
`knowledge_get_context`；当你定下一项决定时，用
`knowledge_add_memory` 将其持久化。”* 因为 `critical` 规则总是由上下文构建器返回，
每个调用该工具的智能体都会得到相同的操作指令。

## 项目扫描

`POST /api/knowledge/scan` 按意图分类导入项目的 AI 上下文文件：

- `AGENTS.md`、`CLAUDE.md`、`MUSE.md`、`GEMINI.md`、`CODEX.md`、`.cursorrules`、
  `.muserules` 以及 `.cursor/rules` 下的 markdown/`.mdc` 成为**规则**
  （critical + enabled，因此 `knowledge_get_context` 总会返回它们；工作区
  `AGENTS.md` 以 `high` 导入，因为首轮的 `<unified-rules>` 前缀已经提供了它），
- `skills` / `.agents/skills` 下的 `SKILL.md` 文件成为**技能**
  （名称/描述来自 frontmatter），
- 扫描到的任何其他 markdown 成为**参考记忆**。

每个文件通过内容哈希记录在 `kb_scan_state` 中，因此重新扫描只会
触及已更改的文件，并删除来源已消失的实体。

## 客户端

**Knowledge** 界面（导航栏 → Knowledge）有 Dashboard、Memories、
Rules、Skills、Personal 和 Graph 标签页，一个项目范围筛选器，一个弹窗
创建/编辑表单，带恢复的按实体版本历史，技能图标上传以及
JSON 导出/导入。Memories 标签页有标签筛选栏（带标签管理），
应用栏有全文搜索、创建连接对话框和迁移操作，
Graph 标签页是一个力导向关系视图，带平移/缩放、节点
拖拽、实体类型筛选和邻居高亮。
图会绘制你的显式连接以及隐式枢纽——项目范围内的每个实体都连接到其项目，共享标签的记忆连接到标签节点——因此它始终展示结构。

## 好好整理它

1. 对每个活跃项目**扫描**一次（Knowledge → 选择项目 → scan）；
   在其指令文件发生大改动后重新扫描。
2. **有意识地提升**：只有真正有约束力的规则才应该是 `critical`
   （总是由上下文构建器提供）。使用行上的星标，并留意规则上下文计量表。
3. **其余保持 `high`/`normal`**——仍然可搜索、可通过 MCP 使用，
   只在查询匹配时才可用，因此在无关时不会产生任何成本。
4. 用**个人信息**存跨项目偏好（时区、编辑器、命名）。
5. **链接相关记忆**，让 1 跳邻居一起带上。
6. 对应当搜索知识库并持久化所学内容的智能体**安装 MCP**。
   一键安装使用 `write` token；对于只读智能体，请在 DDAgent MCP 服务器 token 中
   创建一个 `read` token，并手动配置该智能体（参见
   [作为 MCP 服务器的 DDAgent](../mcp-server.md#manual-client-config)）。

## 迁移

Knowledge → 菜单 → **Migrate existing rules** 会运行一份 **dry-run** 报告：它
扫描所有项目，找出跨项目存在的重复项（相同的规范化
标题 + 内容），并显示规则数量。你可以从这里**Merge duplicates**
（把它们合并为一个全局行）和/或 **Make all rules critical**。在你确认之前
不会写入任何内容——破坏性操作都是显式的。

**Dashboard** 还有一个单独的 **把所有内容导入 DDAgent** 按钮：它用一个操作运行项目扫描和智能体技能导入，并带有相同的 dry-run 预览以及可选的重复合并 / 提升开关。它只读取你的智能体的文件并写入 DDAgent 自己的数据库——不会触碰任何 CLI 文件或配置（唯一会写入智能体配置的操作是单独的 "Install DDAgent MCP server"）。

同一个菜单里还有**导入智能体技能**：它会列出你的智能体已经自带或已安装的全局/默认技能（用户 / 系统 / 插件范围），并把缺失的技能作为技能导入知识库。它先进行 dry-run，而且是幂等的——已存在的名称会被跳过。项目范围的技能则由项目扫描导入。

## 须知

- 一切都**本地**于这个 DDAgent 实例；没有云，没有同步。
- 知识库**不会自动注入**——智能体通过 MCP 按需检索（Contexta 模型）。
  没有安装 MCP 服务器的智能体不会从中获得任何内容。
- 扫描到的技能可通过 MCP（`knowledge_get_context` / `knowledge_search`）到达，
  而不会被推入上下文。
- 规则或记忆可由智能体通过 MCP 编辑；在实体的 **History** 中查看
  更改，必要时恢复之前的版本。

## REST API

挂载在 `/api/knowledge`，位于认证之后：

```
GET    /memories            ?projectId=&includeGlobal=&priority=&tag=&memoryType=&limit=&offset=
POST   /memories            PATCH /memories/:id   DELETE /memories/:id
GET    /rules               ?projectId=&includeGlobal=&priority=&enabledOnly=&limit=&offset=
POST   /rules               PATCH /rules/:id       DELETE /rules/:id
GET    /skills              ?category=&limit=&offset=
POST   /skills              PATCH /skills/:id      DELETE /skills/:id
GET    /personal            POST /personal         PATCH/DELETE /personal/:id
GET    /search              ?q=&type=&projectId=&limit=
GET    /graph               ?projectId=&types=&limit=
GET    /context             ?projectId=            （规则上下文预览：大小 + 预算）
GET    /tags                DELETE /tags/:id
GET    /connections         POST /connections      DELETE /connections/:id
GET    /history             ?entityType=&entityId=&limit=
GET    /stats
GET    /export              POST /import
POST   /scan                { projectId }
POST   /migrate             { projectIds?, dryRun?, dedupe?, promoteRules? }
POST   /import-skills       { providers?, scopes?, dryRun? }
POST   /import-all          { dryRun?, dedupe?, promoteRules? }
```

`projectId=global` 将列表限制为全局行；把 `includeGlobal=true`
加到项目 id 上会返回项目行加上全局行。

## 相关

- [作为 MCP 服务器的 DDAgent](../mcp-server.md) — 工具目录和 token 设置
- [团队协作](../teams.md) · [远程审批](../remote-approvals.md)
