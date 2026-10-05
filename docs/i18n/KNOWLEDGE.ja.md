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
- **MCP による取得（オンデマンド）** — エージェントに ddagent の MCP サーバーを
  インストールすると、そのツール一覧に `knowledge_get_context`、`knowledge_search`
  などが含まれます。Contexta に倣い、自動的に注入されるものは何もありません。
  エージェントはクエリを渡してコンテキストビルダーを呼び出し、`critical` ルールと
  一致したものを返してもらいます。モデルはツールの説明と、ナレッジベースに
  保管した指示ルールに導かれて、いつ呼び出すかを決めます。

つまり「ひとつの場所」とは、**知識を管理するひとつの場所**という意味です
— CLI が独自のネイティブファイルを読むのを止めるものではありません（止められません）。
ddagent はナレッジベースをセッションに自動注入することは一切ありません。

## エンティティ

| エンティティ | スコープ | 備考 |
|---|---|---|
| メモリ | プロジェクトまたはグローバル | `memory_type`（`fact`/`decision`/`note`/`reference`）、`priority`、`source`、タグ |
| ルール | プロジェクトまたはグローバル | `enabled` トグル；`critical` ルールはコンテキストビルダーによって常に最初に返される |
| スキル | グローバル | 一意な名前、カテゴリ、任意のアイコン（base64 data URL） |
| 個人情報 | グローバル | 一意な `key` |
| タグ / 接続 | — | メモリ上のタグ；接続は任意の 2 エンティティを結ぶ |
| 履歴 | — | 書き込みごとにエンティティをスナップショットし、確認・復元できる |

優先度：`critical > high > normal > low`。エンティティは 1 つの
プロジェクトに限定するか、グローバル（どこでも適用）にできます。`project_id` は単なるカラムです（外部
キーではありません）。プロジェクトテーブルはマイグレーション中に再構築されるためです。

## コンテキストの取得（オンデマンド）

エージェントは MCP ツール `knowledge_get_context` を通じてコンテキストを取得します
（Contexta の ContextBuilder の忠実な移植です）。プロジェクトとクエリを渡すと、
次の順で返します。

- **有効なすべてのルール**（プロジェクト + グローバル）、`critical` が先頭（上限 20）、
- **メモリ**をクエリで順位付け（FTS）、さらに接続を通じて到達する 1 ホップ隣接
  （上限 5）。クエリがない場合は、プロジェクトの優先度上位のメモリ、
- **スキル**をクエリで順位付け。クエリがない場合は最新のスキル、
- クエリが一致した場合のみの**個人情報**（上限 3）、

セクションごとに項目が切り詰められ（800/1000/600 文字）、`maxTokens`（既定は約 4000）で
上限が設けられた Markdown ブロックとしてレンダリングされます。収まらなくなった項目は
省略として数えられます。

ダッシュボードは選択中のプロジェクトについて**ルールコンテキストメーター**
（`~X / 4000 tok`）を表示します — すべての `knowledge_get_context` 呼び出しが常に含む
ルールブロックのサイズです。セッションに自動的に注入されるものは何もありません。

検索ランキングはハイブリッドです。Contexta の `search.rs` と同様に、FTS5 の **prefix** 一致（`auth` は `authentication` にも一致）に加え、タイプミスや準同義語を拾うあいまいな **trigram** パスを行い、その後 `bm25 + priority + recency` で再ランクします。

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
`knowledge_get_context` を呼び出すこと。決定を下したら `knowledge_add_memory` で
永続化すること。」* `critical` ルールはコンテキストビルダーによって常に返されるため、
このツールを呼び出すすべてのエージェントが同じ運用指示を受け取ります。

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
力学指向のリレーションビューです。
グラフは明示的なリンクに加えて暗黙のハブを描画します — プロジェクトスコープのすべてのエンティティはそのプロジェクトに接続し、タグを共有するメモリはタグノードに接続します — そのため常に構造を示します。

## うまく管理するには

1. 各アクティブプロジェクトを一度**スキャン**します（Knowledge → プロジェクトを選択 → scan）。
   指示ファイルに大きな変更があったら再スキャンします。
2. **意図的に昇格**します。真に拘束力のあるルールだけを `critical` にします
   （コンテキストビルダーによって常に提供されます）。行の星を使って、
   クリティカルコンテキストメーターを監視します。
3. **残りは `high`/`normal` に保ちます** — 依然として検索可能で MCP 経由で利用でき、
   クエリが一致したときだけなので、無関係なときはコストがかかりません。
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

**Dashboard** には単一の **ddagent にすべてをインポート**ボタンもあります。プロジェクトスキャンとエージェントスキルのインポートを 1 つの操作で実行し、同じ dry-run プレビューと任意の重複マージ / 昇格トグルを備えています。あなたのエージェントのファイルを読み取って ddagent 自身のデータベースに書き込むだけで、CLI のファイルや設定には一切触れません（エージェントの設定に書き込む唯一の操作は、別途の "Install ddagent MCP server" です）。

同じメニューに**エージェントのスキルをインポート**があります。エージェントがすでに同梱しているかインストール済みのグローバル/デフォルトのスキル（ユーザー / システム / プラグインのスコープ）を一覧表示し、不足しているものをスキルとしてナレッジベースにインポートします。まず dry-run で、冪等です — すでに存在する名前はスキップされます。プロジェクトスコープのスキルは代わりにプロジェクトスキャンでインポートされます。

## 知っておくとよいこと

- すべてはこの ddagent インスタンスに**ローカル**です。クラウドも同期もありません。
- ナレッジベースは**自動注入されません** — エージェントは MCP 経由でオンデマンドに
  取得します（Contexta モデル）。MCP サーバーをインストールしていないエージェントは
  何も得られません。
- スキャンされたスキルは MCP（`knowledge_get_context` / `knowledge_search`）から
  到達でき、コンテキストに押し込まれることはありません。
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
GET    /context             ?projectId=            (クリティカルコンテキストのサイズ + 予算)
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

`projectId=global` はリストをグローバル行に制限します。プロジェクト id に `includeGlobal=true`
を付けると、プロジェクト行とグローバル行を返します。

## 関連

- [MCP サーバーとしての ddagent](mcp-server.md) — ツールカタログとトークン設定
- [チームコラボレーション](teams.md) · [リモート承認](remote-approvals.md)
