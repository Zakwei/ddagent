<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>すべての AI コーディングエージェントをひとつの UI で。</strong><br>
  Claude Code、Codex、Cursor CLI、OpenCode、Devin、Command Code、Antigravity のためのセルフホスト型サーバーと Flutter クライアント（Web、Linux、Windows &amp; Android）— セッション、ファイル、git、ターミナル、タスクをひとつの場所に。</p>

  <p>
    <img src="https://img.shields.io/github/v/release/Zakwei/ddagent?label=バージョン&amp;color=0066FF" alt="バージョン">
    <img src="https://img.shields.io/badge/license-AGPL--3.0-blue" alt="ライセンス: AGPL-3.0">
    <img src="https://img.shields.io/badge/node-%E2%89%A522-339933" alt="node >= 22">
    <img src="https://img.shields.io/badge/self--hosted-yes-success" alt="セルフホスト">
  </p>

  <p>
    <a href="#インストール">インストール</a> ·
    <a href="https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md">コントリビュート</a> ·
    <a href="https://github.com/Zakwei/ddagent/issues">バグ報告</a>
  </p>

  <p>
    <a href="../../README.md">English</a> ·
    <a href="README.pl.md">Polski</a> ·
    <a href="README.de.md">Deutsch</a> ·
    <a href="README.es.md">Español</a> ·
    <a href="README.fr.md">Français</a> ·
    <a href="README.it.md">Italiano</a> ·
    <strong>日本語</strong> ·
    <a href="README.ko.md">한국어</a> ·
    <a href="README.ru.md">Русский</a> ·
    <a href="README.tr.md">Türkçe</a> ·
    <a href="README.zh-CN.md">简体中文</a> ·
    <a href="README.zh-TW.md">繁體中文</a>
  </p>
</div>

<p align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/desktop-main.png" alt="ddagent チャット画面" width="78%">&nbsp;
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/mobile-chat.png" alt="ddagent モバイル画面" width="20%">
</p>

<table>
  <tr>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/sessions.png" alt="Claude Code と Codex の最近のセッション"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/kanban-board.png" alt="エージェントの実行を動かすカンバンボード"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/git-panel.png" alt="hunk 単位でステージできる Git パネル"></td>
  </tr>
  <tr>
    <td align="center"><sub>すべてのエージェントのセッションをひとつのリストに</sub></td>
    <td align="center"><sub>カンバンボード — カードからエージェントを実行</sub></td>
    <td align="center"><sub>Git パネル — diff、hunk のステージ、コミット</sub></td>
  </tr>
</table>

---

## ddagent とは？

ddagent はあなた自身のマシンや VPS 上で動作し、すでに使っているコーディングエージェントの上に洗練されたひとつの UI を提供します。サーバーは各エージェントのセッションを、それぞれのディスク上の履歴（`~/.claude`、`~/.codex`、`~/.cursor`、OpenCode、Devin など）から直接読み込むため、既存の会話は何もインポートせずにそのまま表示されます。ローカルにインデックスされるのはセッションのメタデータだけで、第三者には何も送信されません。

デスクトップ、スマートフォン、ブラウザの Flutter クライアントから接続できます。あなたのマシン、あなたのエージェント、あなたのデータ。

## 機能

- **マルチエージェントセッション** — 7 種類のエージェント CLI のセッションを並べて実行・再開。WebSocket 経由でライブストリーミング
- **自動オーケストレーター** — 「Auto」セッションは、残りのサブスクリプションのクォータを考慮して各タスクを適切なエージェントとモデルに振り分け、作業を子セッションに委任
- **分割ワークスペース** — 最大 6 つのペイン（チャット、ターミナル、ブラウザ、プレビュー、エディター、git、メモ）をひとつのウィンドウに
- **ファイルエクスプローラー＆エディター** — ワークスペースを閲覧し、内蔵エディターでコードを編集
- **Git パネル** — UI を離れずに、ファイルや個々の hunk のステージ、コミット（AI 生成メッセージ付き）、diff、ブランチ操作、pull/push、チェックポイントの復元が可能
- **統合ターミナル** — ワークスペースごとにフル機能のシェル
- **カンバンボード** — カードを移動するとそのカードでエージェントの実行を開始（専用の worktree での実行も可能）。完了するとエージェントが結果を報告
- **TaskMaster** — PRD をタスクに変換し、タスクボードで追跡
- **メッセージキュー** — エージェントが作業中に送ったメッセージはサーバー側のキューに入り、リロードやデバイスの切り替え後も失われない
- **MCP 管理** — エージェント間で MCP サーバーを追加・編集・同期
- **ナレッジベース** — すべてのエージェントのための、ローカルで検索可能な単一のメモリ。ルール、スキル、メモリ、個人情報を MCP 経由でオンデマンドに取得（[ドキュメント](KNOWLEDGE.ja.md)）
- **スキル＆ルール** — エージェントのスキルと共有ルールを一か所で管理
- **クォータ＆使用量** — エージェントごとのトークン使用量とサブスクリプション上限を一目で確認
- **Browser-use** — 調査やテストのためにエージェントが操作するブラウザセッション。ライブのブラウザペイン付き
- **Worktree** — タスクごとに分離された git worktree を作成。worktree ごとの setup/run スクリプトと、認証付きのライブ dev-server プレビューに対応
- **リモート承認** — Telegram、Discord、Android アプリからツールの権限を承認（[ドキュメント](https://github.com/Zakwei/ddagent/blob/main/docs/remote-approvals.md)）
- **音声入力** — Whisper 互換の音声認識エンドポイントでプロンプトを口述
- **エージェントへの一斉送信＆共有メモリ** — すべてのエージェントに一度にメッセージを送り、全員が読むプロジェクトごとのメモを保持
- **マルチアカウント切り替え** — プロバイダーごとの名前付きアカウントと、セッションごとの環境変数のオーバーライド
- **スケジューラー** — cron による無人のエージェント実行。実行中はデバイスをスリープさせないオプション付き
- **チームコラボレーション** — ロール（owner/member/viewer）、招待リンク、担当者、コメント、プレゼンス、ボード上のアクティビティフィード（[ドキュメント](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md)）
- **MCP サーバー** — 外部の MCP クライアント（Claude Desktop、OpenClaw）からセッションの一覧取得、タスクの作成、セッションへのメッセージ送信が可能（[ドキュメント](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md)）
- **通知＆TTS** — セッションが対応を必要とするときにプッシュ、Telegram、Discord で通知。返信の読み上げもオプションで利用可能
- **コマンドパレット** — `Ctrl/Cmd+Shift+K` でセッションやメッセージを検索し、任意のページへ移動したり、クイックアクションを実行
- **Docker サンドボックス** — microVM で分離された Docker Sandbox でエージェントを実行（[ドキュメント](https://github.com/Zakwei/ddagent/blob/main/docker/README.md)）
- **Flutter クライアント** — Web、Linux、Windows、Android をひとつのコードベースで。**12 言語**対応、ダーク／ライトテーマ

## 対応エージェント

| エージェント | 接続方法 |
|---|---|
| **Claude Code** | Claude Agent SDK。`~/.claude` のセッションを自動検出。MCP と設定をネイティブ CLI と同期 |
| **Codex** | Codex SDK。`~/.codex` のローカルセッションとトランスクリプト |
| **Cursor CLI** | ストリーミング JSON 出力の `cursor-agent`。`~/.cursor` のローカルチャット |
| **OpenCode** | `opencode serve`。OpenCode データベースのローカルセッション |
| **Devin** | `devin acp`（Agent Client Protocol）。ローカルのトランスクリプト |
| **Command Code** | `command-code acp`（Agent Client Protocol）。`~/.commandcode` のトランスクリプト |
| **Antigravity** | ヘッドレスモードの `agy` CLI。`~/.gemini/antigravity-cli` からインデックスした会話 |

エージェントの CLI は、サーバーマシンにインストールしてサインインしておく必要があります。サブスクリプションはご自身のものを使います — ddagent が提供するのは環境であり、AI ではありません。

## インストール

ddagent は 2 つの部分で構成されます。エージェントと同じマシンで動作し REST/WebSocket API を公開する**サーバー**と、そこに接続する**クライアント**です。サーバーには **Node.js 22+** が必要です（ビルド済み tarball はネイティブモジュールが Node.js 22.x 向けにビルドされているため、Node.js 22.x が必要です）。

### サーバー — インストーラースクリプト

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

`git`、Node.js 22+、`npm` が必要です。スクリプトはリリースタグを `~/.ddagent/app` にクローンし、依存関係をインストールしてバックエンドをビルドし、`start.sh` ランチャーを作成します。オプションは `bash -s --` の後に渡します:

| オプション | 説明 |
|---|---|
| `--version vX.Y.Z` | 特定のリリースをインストール（デフォルト: 最新） |
| `--dir <path>` | インストール先ディレクトリ（デフォルト: `~/.ddagent/app`） |
| `--systemd` | `ddagent` という名前の systemd ユーザーサービスをインストールして有効化 |
| `--port <port>` | systemd サービスのポート（デフォルト: `3001`） |

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash -s -- --systemd --port 3001
```

更新するには、`--version vX.Y.Z` を付けてスクリプトを再実行します。チェックアウトがその場で更新されます。その後、サーバーを起動します:

```bash
~/.ddagent/app/start.sh        # API on http://<host>:3001 (set SERVER_PORT to change)
```

### サーバー — ビルド済み tarball

ビルドは不要です。[Releases](https://github.com/Zakwei/ddagent/releases) から `ddagent-server-<version>-<os>-<arch>.tar.gz`（`linux-x64`、`mac-arm64`、`win-x64`）をダウンロードし、展開してランチャーを実行します:

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh             # start.bat on Windows
```

各 tarball には `.sha256` チェックサムが付属しています。設定は `start.sh` と同じ場所に置く任意の `.env` ファイルに記述します。

### クライアント

[Releases](https://github.com/Zakwei/ddagent/releases) からビルド済みクライアントをダウンロードします:

| プラットフォーム | ファイル |
|---|---|
| Windows x64 | `ddagent-flutter-windows-x64-<tag>-setup.exe`（インストーラー）または `.zip`（ポータブル） |
| Linux x64 | `ddagent-flutter-linux-x64-<tag>.deb` または `.tar.gz` |
| Android | `ddagent-flutter-android-<tag>.apk` |
| Web | `ddagent-flutter-web-<tag>.zip` |

初回起動時にサーバーの URL（例: `http://my-vps:3001`）を入力し、最初のアカウントを作成します。Windows と Linux x64 では、デスクトップクライアントがローカルサーバーをダウンロードして実行することもできます（接続画面の「このデバイス」）。

Web ビルドにはログイン画面がなく、自身のオリジン上の API を呼び出します。そのため、シングルユーザーのプラットフォームモード（`VITE_IS_PLATFORM=true`、認証を無効化）で動作するサーバーの前段にリバースプロキシを置き、その背後で配信する必要があります。ソースのチェックアウトでは、`node scripts/serve-flutter-web.cjs` が `flutter/build/web` をポート 8085 で配信し、API と WebSocket を `FLUTTER_BACKEND_PORT`（デフォルト `10087`）のサーバーへプロキシします。この構成は信頼できるネットワーク内でのみ公開してください。

クライアントを自分でビルドするには:

```bash
cd flutter
flutter pub get
flutter build linux --release      # or: windows, apk, web
```

### ソースから

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run build && node dist-server/server/index.js   # API on http://localhost:3001
```

### Docker サンドボックス（実験的）

```bash
ddagent sandbox ~/my-project
```

microVM で分離された Docker Sandbox 内で ddagent とエージェント（Claude Code または Codex）を実行します。`sbx` CLI が必要です — [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md) を参照してください。

## CLI

ソースまたは `install.sh` のチェックアウトでは、以下の `ddagent` は `node dist-server/server/modules/cli/cli.js` を指します（shebang があるため、`./dist-server/server/modules/cli/cli.js` でも動作します）。

| コマンド | 説明 |
|---|---|
| `ddagent` / `ddagent start` | サーバーを起動（デフォルトのコマンド） |
| `ddagent status` | バージョンと、設定ファイル・データベース・Claude プロジェクトの場所を表示 |
| `ddagent sandbox <workspace>` | Docker サンドボックスを作成して起動。`ddagent sandbox help` で `ls`、`start`、`stop`、`rm`、`logs` を一覧表示 |
| `ddagent browser-use-mcp` | browser-use MCP サーバーを stdio で実行 |
| `ddagent version` | バージョンを表示 |
| `ddagent help` | ヘルプを表示 |

| オプション | 説明 |
|---|---|
| `-p, --port <port>` | サーバーのポート（`SERVER_PORT` を上書き） |
| `--database-path <path>` | データベースの場所を指定（`DATABASE_PATH` を上書き） |

## 設定

サーバーはインストール先ディレクトリ（`start.sh` と同じ場所）にある任意の `.env` ファイルを読み込みます。実際の環境変数が優先されます。どのファイルが使われているかは `ddagent status` で確認できます。

| 変数 | デフォルト | 説明 |
|---|---|---|
| `SERVER_PORT` | `3001` | API + WebSocket のポート（`PORT` もレガシーなエイリアスとして利用可） |
| `HOST` | `0.0.0.0` | バインドアドレス（localhost のみにする場合は `127.0.0.1`） |
| `DATABASE_PATH` | `~/.ddagent/auth.db` | SQLite データベース（ユーザー、設定、トークン） |
| `WORKSPACES_ROOT` | ホームディレクトリ | プロジェクトはこのディレクトリ内に置く必要がある |
| `JWT_SECRET` | 自動生成 | ログイントークンの署名用シークレット（インストールごとに生成・保存） |
| `API_KEY` | 未設定 | 設定すると、API リクエストは `x-api-key` ヘッダーでこの値を送る必要がある |
| `CLAUDE_CLI_PATH` | `claude` | カスタムの Claude Code CLI バイナリ |
| `CONTEXT_WINDOW` | `200000` | Claude のコンテキストウィンドウのフォールバック値。SDK がモデルの実際のウィンドウを報告するまで使用 |
| `STT_ENDPOINT_URL` / `STT_API_KEY` / `STT_MODEL` | `https://api.openai.com/v1` / 未設定 / `whisper-1` | 音声入力用の音声認識（「設定」からも設定可能） |
| `VITE_IS_PLATFORM` | `false` | シングルユーザーのプラットフォームモード: 認証をスキップ（Web クライアントで必須） |

詳しくは [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example) を参照してください。

## 開発

```bash
npm install
npm run dev               # start the backend from source (tsx, no reload)
npm run server:dev-watch  # same, restarting on file changes
npm run build             # compile the server to dist-server/
npm test                  # backend tests
npm run typecheck         # TypeScript check
npm run lint              # ESLint
```

クライアント（Flutter 3.47.5 stable）:

```bash
cd flutter
flutter pub get
flutter run -d linux --dart-define=DEFAULT_SERVER_URL=http://localhost:3001
dart format --line-length 100 lib test
flutter analyze
flutter test
```

バックエンドのコードは `server/modules/` のモジュールアーキテクチャに従います。プロバイダーの内部構造については [`server/modules/providers/README.md`](https://github.com/Zakwei/ddagent/blob/main/server/modules/providers/README.md) を参照してください。

## コントリビュート

バグ修正を歓迎します — [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md) を参照してください。脆弱性の報告については [SECURITY.md](https://github.com/Zakwei/ddagent/blob/main/SECURITY.md) を参照してください。

---

<div align="center">
  <sub>Claude Code、Codex、Cursor、OpenCode、Devin、Command Code、Antigravity のコミュニティのために作られました。</sub>
</div>
