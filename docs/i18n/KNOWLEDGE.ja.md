# ナレッジベース

<p>
  <a href="../../KNOWLEDGE.md">English</a> ·
  <a href="KNOWLEDGE.pl.md">Polski</a> ·
  <a href="KNOWLEDGE.de.md">Deutsch</a> ·
  <a href="KNOWLEDGE.es.md">Español</a> ·
  <a href="KNOWLEDGE.fr.md">Français</a> ·
  <a href="KNOWLEDGE.it.md">Italiano</a> ·
  <strong>日本語</strong> ·
  <a href="KNOWLEDGE.ko.md">한국어</a> ·
  <a href="KNOWLEDGE.ru.md">Русский</a> ·
  <a href="KNOWLEDGE.tr.md">Türkçe</a> ·
  <a href="KNOWLEDGE.zh-CN.md">简体中文</a> ·
  <a href="KNOWLEDGE.zh-TW.md">繁體中文</a>
</p>

ddagent はエージェント向けに**ローカルファーストのナレッジベース**を提供します。メモリ、ルール、
スキル、個人情報、さらにタグとリレーションです。ddagent の他のデータと同じ
SQLite データベース（`auth.db`）に FTS5 全文インデックスを伴って存在し、
クライアントの **Knowledge** 画面から管理でき、エージェントから MCP 経由で
読み書きできます。緩やかに
[Contexta](https://github.com/XFABISIEK/Contexta) に着想を得ています。

要点はシンプルです。ルールやプロジェクトの知識は、ツールごとのファイル
（`AGENTS.md`、`CLAUDE.md`、`.cursorrules`、`skills/` など）に散らばるのをやめ、
すべてのエージェントが使える単一の、厳選された検索可能な場所になります — ファイルを
読むエージェントも、MCP を話すエージェントも同じです。

## エージェントから実際にどう見えるか

3 つのレイヤーがあり、どれがどれかを知っておくと役立ちます。

- **CLI ネイティブのファイル** — 各ツールは自分の設定を自分で読みます。Claude Code は
  `CLAUDE.md` を読み、Codex/Cursor は `AGENTS.md` を読み、Cursor は `.cursorrules` を読み、
  いくつかは `skills/` と `.agents/skills/` を読みます。これは CLI の仕事であり、
  モデルの選択ではありません — ddagent はそれを止めません。
- **ddagent による注入** — セッションの最初のターンで、ddagent は
  `<knowledge>` ブロックを先頭に付けます（詳細は後述）。これはすべてのプロバイダーで機能し、
  エージェント側の設定は不要です。
- **MCP ツール** — エージェントに ddagent の MCP サーバーをインストールすると、そのツール
  一覧に `knowledge_search` などが含まれます。モデルはツールの説明と、ナレッジベースに
  保管した指示ルールに導かれて、いつ呼び出すかを決めます。

つまり「ひとつの場所」とは、**注入コンテンツを管理するひとつの場所とひとつの予算**
という意味です — CLI が独自のネイティブファイルを読むのを止めるものではありません（止められません）。
重複を避けるため、ワークスペースの `AGENTS.md` は優先度 `high` に保ち、ナレッジ
ブロックが unified-rules の注入内容を繰り返さないようにしています。

## エンティティ

| エンティティ | スコープ | 備考 |
|---|---|---|
| メモリ | プロジェクトまたはグローバル | `memory_type`（`fact`/`decision`/`note`/`reference`）、`priority`、`source`、タグ |
| ルール | プロジェクトまたはグローバル | `enabled` トグル；`critical` ルールはセッションに注入される |
| スキル | グローバル | 一意な名前、カテゴリ、任意のアイコン（base64 data URL） |
| 個人情報 | グローバル | 一意な `key` |
| タグ / 接続 | — | メモリ上のタグ；接続は任意の 2 エンティティを結ぶ |
| 履歴 | — | 書き込みごとにエンティティをスナップショットし、確認・復元できる |

優先度：`critical > high > normal > low`。エンティティは 1 つの
プロジェクトに限定するか、グローバル（どこでも適用）にできます。`project_id` は単なるカラムです（外部
キーではありません）。プロジェクトテーブルはマイグレーション中に再構築されるためです。

## 初回ターンの注入（すべてのエージェントが自動的に受け取るもの）

セッションの**最初の**送信メッセージで、ddagent は以下を含む `<knowledge>`
ブロックを先頭に付けます。

- `critical` の**ルール**（プロジェクト + グローバル、有効なもののみ）、
- `critical` の**メモリ**、
- すべての**個人情報**エントリ、
- 含まれるメモリの**1 ホップ隣接**（明示的な
  接続を通じて到達）。

ブロック全体は約 4000 トークンに制限されます。`.ddagent/shared-context.md` と unified rules と
同じ初回ターンのゲートを通るため、ターンごとのトークンは消費しません。
`DDAGENT_KNOWLEDGE=0` で無効化できます。

ダッシュボードは選択中のプロジェクトについて**注入コンテキストメーター**（`~X / 4000 tok`）を
表示するので、コンテキストに何が入るかを確認して制御できます。

## MCP ツール（オンデマンド）

ddagent の MCP サーバー（`POST /mcp`）はナレッジベースを任意の MCP クライアントに公開します。
読み取りツールは `read` スコープのトークンで動作し、書き込みツールは `write` を必要とします。書き込み
ツールは UI と同じ検証を実行し、履歴を記録します。

読み取り：`knowledge_search`、`knowledge_get_context`、`knowledge_get_memories`、
`knowledge_get_rules`、`knowledge_get_skills`、`knowledge_get_personal`、
`knowledge_get_graph`、`knowledge_history`。

書き込み：`knowledge_add_memory`、`knowledge_update_memory`、
`knowledge_delete_memory`、および `rule`、`skill`、`personal` について同じ 3 点セット。
さらに `knowledge_link` / `knowledge_unlink`。

ツールは `projectId` か、ddagent がすでに知っている `projectPath` のいずれかを受け付けます。

### エージェントへのサーバーインストール

プロバイダー設定を手で編集する必要はありません。**Settings → MCP →
Install ddagent MCP server**（オンボーディングの手順としても提示されます）を使い、
エージェントを選びます — すべてにインストールすることもできます。`<server>/mcp` を指す
`ddagent` HTTP MCP エントリ（ユーザースコープ）を、再利用可能な `ddagent-mcp` bearer トークンとともに
書き込みます（再インストールすると以前のものは失効します）。インストール後、そのエージェントのツールには
`knowledge_*` グループが `create_task`、`send_message` などと並んで含まれます。

エージェントは*いつ* MCP を使うべきかをどう知るのでしょうか？ 推測はしません — 教えてください。
`critical` ルールとして次のように保ちます：*「このプロジェクトに関する質問に答える前に
`knowledge_search` を呼び出すこと。決定を下したら `knowledge_add_memory` で
永続化すること。」* このルールは毎回の初回ターンで注入されるため、すべての
エージェントが同じ運用指示を受け取ります。

## プロジェクトスキャン

`POST /api/knowledge/scan` はプロジェクトの AI コンテキストファイルを意図別に
分類してインポートします。

- `AGENTS.md`、`CLAUDE.md`、`MUSE.md`、`GEMINI.md`、`CODEX.md`、`.cursorrules`、
  `.muserules`、および `.cursor/rules` 配下の markdown/`.mdc` は**ルール**になります
  （critical + enabled で、エージェントコンテキストに届きます。ワークスペースの `AGENTS.md`
  は unified-rules との二重注入を避けるため `high` です）。
- `skills` / `.agents/skills` 配下の `SKILL.md` ファイルは**スキル**になります
  （frontmatter から名前/説明を取得）。
- それ以外のスキャンされた markdown は**参照メモリ**になります。

各ファイルは `kb_scan_state` に内容ハッシュで記録されるため、再スキャンは
変更されたファイルだけに触れ、ソースが消えたエンティティを削除します。

## クライアント

**Knowledge** 画面（ナビゲーションレール → Knowledge）には Dashboard、Memories、
Rules、Skills、Personal、Graph タブ、プロジェクトスコープフィルター、モーダルの
作成/編集フォーム、エンティティごとのバージョン履歴と復元、スキルアイコンのアップロード、
JSON エクスポート/インポートがあります。Memories タブにはタグフィルターバー（タグ管理付き）、
アプリバーには全文検索、リンク作成ダイアログ、マイグレーション操作があり、
Graph タブは pan/zoom、ノードのドラッグ、エンティティタイプフィルター、隣接ハイライトを備えた
力学指向のリレーションビューです。Settings → Knowledge
から同じ画面へ直接移動できます。

## うまく管理するには

1. 各アクティブプロジェクトを一度**スキャン**します（Knowledge → プロジェクトを選択 → scan）。
   指示ファイルに大きな変更があったら再スキャンします。
2. **意図的に昇格**します。真に拘束力のあるルールだけを `critical` にします
   （注入されます）。行の星を使って、予算メーターを監視します。
3. **残りは `high`/`normal` に保ちます** — 依然として検索可能で MCP 経由で利用でき、
   毎ターンのコンテキストを消費しません。
4. プロジェクト横断の設定（タイムゾーン、エディタ、命名）には**個人情報**を使います。
5. **関連するメモリをリンク**して、1 ホップ隣接を一緒に運びます。
6. ナレッジベースを検索し学びを永続化すべきエージェントには **MCP をインストール**します。
   ほとんどには `read` スコープを、信頼するエージェントには `write` を与えます。

## マイグレーション

Knowledge → メニュー → **Migrate existing rules** は **dry-run** レポートを実行します。
すべてのプロジェクトをスキャンし、プロジェクト間で存在する重複（同じ正規化された
タイトル + 内容）を見つけ、ルール数を表示します。そこから **Merge duplicates**
（1 つのグローバル行に統合）や **Make all rules critical** を実行できます。確認するまで
何も書き込まれません — 破壊的操作は明示的です。

同じメニューに**エージェントのスキルをインポート**があります。エージェントがすでに同梱しているかインストール済みのグローバル/デフォルトのスキル（ユーザー / システム / プラグインのスコープ）を一覧表示し、不足しているものをスキルとしてナレッジベースにインポートします。まず dry-run で、冪等です — すでに存在する名前はスキップされます。プロジェクトスコープのスキルは代わりにプロジェクトスキャンでインポートされます。

## 知っておくとよいこと

- すべてはこの ddagent インスタンスに**ローカル**です。クラウドも同期もありません。
- 注入は**セッションごとに 1 回**（初回ターン）行われます — 新しいセッションが
  変更を拾います。
- スキャンされたスキルは**注入されません**。MCP 検索から到達でき、
  常時オンのコンテキストを軽く保ちます。
- ルールやメモリはエージェントが MCP 経由で編集できます。変更はエンティティの
  **History** で確認し、必要なら以前のバージョンに復元してください。

## REST API

認証の背後で `/api/knowledge` にマウントされます。

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

`projectId=global` はリストをグローバル行に制限します。プロジェクト id に `includeGlobal=true`
を付けると、プロジェクト行とグローバル行を返します。

## 関連

- [MCP サーバーとしての ddagent](mcp-server.md) — ツールカタログとトークン設定
- [チームコラボレーション](teams.md) · [リモート承認](remote-approvals.md)
