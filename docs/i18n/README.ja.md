<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>すべての AI コーディングエージェントをひとつの UI で。</strong><br>
  Claude Code、Codex、Cursor CLI、OpenCode、Devin のためのセルフホスト型 Web＆モバイルインターフェース — セッション、ファイル、git、ターミナル、タスクをひとつの場所に。</p>

  <p>
    <img src="https://img.shields.io/badge/version-0.5.9-0066FF" alt="バージョン">
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

---

## ddagent とは？

ddagent はあなた自身のマシンや VPS 上で動作し、すでに使っているコーディングエージェントの上に洗練された Web UI を提供します。エージェントのセッションをディスクから直接検出します — `~/.claude`、Codex、Devin の履歴が即座に表示され、何も複製されたり第三者へ同期されたりしません。

ネットワーク上の任意のブラウザ、またはスマートフォンから開けます。あなたのマシン、あなたのエージェント、あなたのデータ。

## 機能

- **マルチエージェントセッション** — Claude Code、Codex、Cursor CLI、OpenCode、Devin のセッションを並行して実行・再開。WebSocket 経由でライブストリーミング
- **分割ペイン** — チャット、ターミナル、ブラウザ、ファイルペインをひとつのワークスペースに
- **ファイルエクスプローラー＆エディター** — ワークスペースを閲覧し、CodeMirror でコードを編集
- **Git パネル** — UI を離れずにステージ、コミット、diff、ブランチ切り替え
- **統合シェル** — ワークスペースごとのフルターミナルに加え、独立したシェルタブ
- **タスクボード** — TaskMaster 駆動のカンバンビュー。PRD を実行可能なタスクに変換
- **MCP 管理** — エージェント間で MCP サーバーを追加・編集・同期
- **スキルブラウザ** — UI からエージェントのスキルを管理
- **クォータ＆使用量** — エージェントごとのトークン使用量とサブスクリプション上限を一目で
- **Browser-use** — 調査やテストのためのエージェント駆動ブラウザセッション
- **Worktree** — タスクごとに独立した git worktree を作成。worktree ごとのセットアップ／実行スクリプトと認証付きライブ開発サーバープレビュー付き
- **リモート承認** — Telegram、Discord、モバイルアプリからツール権限を承認
- **音声入力** — Whisper 互換 STT エンドポイント経由でプロンプトを音声入力
- **エージェント一斉送信＆共有メモリ** — すべてのエージェントに一度にメッセージを送り、全員が読むプロジェクトごとのメモを保持
- **マルチアカウント切替** — プロバイダーごとの名前付きアカウントと、セッションごとの環境変数オーバーライド
- **スケジューラー** — cron 駆動のエージェント実行。Web/デスクトップでの keep-awake 付き
- **チームコラボレーション** — ロール（owner/member/viewer）、招待リンク、担当者、コメント、プレゼンス、ボード上のアクティビティフィード（[ドキュメント](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md)）
- **MCP サーバー** — 外部 MCP クライアント（Claude Desktop、OpenClaw）にタスク作成やセッションへのメッセージ送信を許可（[ドキュメント](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md)）
- **通知＆TTS** — セッションがあなたを必要としたときに通知（または音声読み上げ）
- **Docker サンドボックス** — microVM 分離環境でエージェントを実行（[ドキュメント](https://github.com/Zakwei/ddagent/blob/main/docker/README.md)）
- **デスクトップコンパニオン** — オプションの Electron アプリ。**12 言語**、ダーク＆ライトテーマ

## 対応エージェント

| エージェント | 接続方法 |
|---|---|
| **Claude Code** | `~/.claude` セッションを自動検出。MCP＆設定をネイティブ CLI と同期 |
| **Codex** | ローカル CLI セッションとトランスクリプト |
| **Cursor CLI** | ローカル CLI セッション |
| **OpenCode** | ローカルセッションとスキルの場所 |
| **Devin** | ローカル同期経由の CLI/ACP セッション |

サブスクリプションはご自身でご用意ください — ddagent が提供するのは環境であり、AI ではありません。

## インストール

サーバーを実行するマシンに **Node.js 22+** が必要です。サーバーは Web UI と、デスクトップ・モバイルアプリがリモートで接続する REST/WS API を提供します。

### セルフホストサーバー — インストーラースクリプト

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

最新のリリースタグを `~/.ddagent/app` にクローンし、Web UI＋バックエンドをビルドして、`start.sh` ランチャーを残します。オプション: `--version vX.Y.Z` · `--dir <path>` · `--port <port>` · `--systemd`（ユーザー systemd ユニットをインストールして有効化）。`--version` で再実行するとその場で更新できます。

その後:

```bash
~/.ddagent/app/start.sh        # → http://localhost:3001
```

### セルフホストサーバー — ビルド済み tarball

ビルド手順は不要 — [Releases](https://github.com/Zakwei/ddagent/releases) から `ddagent-server-<version>-<os>-<arch>.tar.gz` をダウンロードして展開し、実行します:

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh           # start.bat on Windows
```

### デスクトップアプリ

[Releases](https://github.com/Zakwei/ddagent/releases) からお使いの OS 向けインストーラーをダウンロード: `.dmg`（macOS）· `.exe`（Windows）· `.AppImage` / `.deb`（Linux）。

スタンドアロンで動作 — サーバーが内蔵されているため他にインストールするものはありません — またはセルフホストサーバーの URL に対するリモートモードでも動作します。リリースの `latest*.yml` フィード経由で自動更新されます。

### モバイルアプリ（プレビュー）

[Releases](https://github.com/Zakwei/ddagent/releases) から `ddagent-mobile-<version>.apk` をダウンロードして Android デバイスにインストールします。アプリはセルフホストサーバーの URL に接続します。

### ソースから

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run dev        # server :3001 + Vite :5173 with HMR
```

### Docker サンドボックス（実験的）

```bash
ddagent sandbox ~/my-project
```

エージェントをハイパーバイザー分離されたサンドボックスで実行します。[docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md) を参照してください。

## CLI

ソースまたは `install.sh` のチェックアウトでは、以下の `ddagent` は `node dist-server/server/modules/cli/cli.js` を意味します（shebang があるため `./dist-server/server/modules/cli/cli.js` でも動作します）。

| コマンド | 説明 |
|---|---|
| `ddagent` | サーバーを起動 |
| `ddagent start` | サーバーを起動 |
| `ddagent status` | 設定とデータの場所を表示 |
| `ddagent version` | バージョンを表示 |
| `ddagent help` | ヘルプを表示 |

## 設定

すべての設定は単一の env ファイルにあります — `ddagent status` を実行すると、どこから読み込まれているかが表示されます。

| 変数 | デフォルト | 説明 |
|---|---|---|
| `SERVER_PORT` | `3001` | API＋WebSocket ポート |
| `VITE_PORT` | `5173` | 開発サーバーポート |
| `HOST` | `0.0.0.0` | バインドアドレス（localhost のみなら `127.0.0.1`） |
| `DATABASE_PATH` | auto | 認証データベースの場所 |
| `CONTEXT_WINDOW` | `160000` | セッションあたりの最大トークン数 |
| `CLAUDE_CLI_PATH` | `claude` | カスタム Claude CLI バイナリパス |

完全なリストは [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example) を参照してください。

## 開発

```bash
npm run dev            # dev mode (server :3001 + vite :5173)
npm run build          # client + server production build
npm run test:client    # frontend tests
npm test               # backend tests
npm run typecheck      # TypeScript check
```

バックエンドコードは `server/modules/` に記述されたモジュールアーキテクチャに従います — プロバイダーの内部については [`server/modules/providers/README.md`](https://github.com/Zakwei/ddagent/blob/main/server/modules/providers/README.md) を参照してください。

## コントリビュート

バグ修正を歓迎します — [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md) を参照してください。

---

<div align="center">
  <sub>Claude Code、Cursor、Codex、OpenCode、Devin コミュニティのために構築。</sub>
</div>
