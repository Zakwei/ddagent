<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>모든 AI 코딩 에이전트를 위한 하나의 UI.</strong><br>
  Claude Code, Codex, Cursor CLI, OpenCode, Devin, Command Code, Antigravity를 위한 셀프호스팅 서버와 Flutter 클라이언트(웹, Linux, Windows 및 Android) — 세션, 파일, git, 터미널, 작업을 한곳에서.</p>

  <p>
    <img src="https://img.shields.io/github/v/release/Zakwei/ddagent?label=버전&amp;color=0066FF" alt="버전">
    <img src="https://img.shields.io/badge/license-AGPL--3.0-blue" alt="라이선스: AGPL-3.0">
    <img src="https://img.shields.io/badge/node-%E2%89%A522-339933" alt="node >= 22">
    <img src="https://img.shields.io/badge/self--hosted-yes-success" alt="셀프호스트">
  </p>

  <p>
    <a href="#설치">설치</a> ·
    <a href="https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md">기여하기</a> ·
    <a href="https://github.com/Zakwei/ddagent/issues">버그 신고</a>
  </p>

  <p>
    <a href="../../README.md">English</a> ·
    <a href="README.pl.md">Polski</a> ·
    <a href="README.de.md">Deutsch</a> ·
    <a href="README.es.md">Español</a> ·
    <a href="README.fr.md">Français</a> ·
    <a href="README.it.md">Italiano</a> ·
    <a href="README.ja.md">日本語</a> ·
    <strong>한국어</strong> ·
    <a href="README.ru.md">Русский</a> ·
    <a href="README.tr.md">Türkçe</a> ·
    <a href="README.zh-CN.md">简体中文</a> ·
    <a href="README.zh-TW.md">繁體中文</a>
  </p>
</div>

<p align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/desktop-main.png" alt="ddagent 채팅 화면" width="78%">&nbsp;
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/mobile-chat.png" alt="ddagent 모바일 화면" width="20%">
</p>

<table>
  <tr>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/sessions.png" alt="Claude Code와 Codex의 최근 세션"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/kanban-board.png" alt="에이전트 실행을 이끄는 칸반 보드"></td>
    <td width="33%"><img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/screenshots/git-panel.png" alt="hunk 단위 스테이징을 지원하는 Git 패널"></td>
  </tr>
  <tr>
    <td align="center"><sub>모든 에이전트의 세션을 하나의 목록으로</sub></td>
    <td align="center"><sub>칸반 보드 — 카드가 에이전트 실행을 시작</sub></td>
    <td align="center"><sub>Git 패널 — diff, hunk 스테이징, 커밋</sub></td>
  </tr>
</table>

---

## ddagent란?

ddagent는 사용자의 머신이나 VPS에서 실행되며, 이미 사용 중인 코딩 에이전트 위에 세련된 UI 하나를 얹어 줍니다. 서버는 각 에이전트의 세션을 디스크에 저장된 자체 기록(`~/.claude`, `~/.codex`, `~/.cursor`, OpenCode, Devin, …)에서 직접 읽어 오므로, 따로 가져오기 작업을 하지 않아도 기존 대화가 그대로 표시됩니다. 로컬에는 세션 메타데이터만 인덱싱되며, 제3자에게 전송되는 데이터는 없습니다.

데스크톱, 휴대폰 또는 브라우저의 Flutter 클라이언트로 접속하세요. 당신의 머신, 당신의 에이전트, 당신의 데이터.

## 기능

- **멀티 에이전트 세션** — 7개 에이전트 CLI의 세션을 나란히 실행하고 재개하며, WebSocket을 통한 실시간 스트리밍 지원
- **자동 오케스트레이터** — "Auto" 세션은 남은 구독 할당량을 고려해 각 작업을 적합한 에이전트와 모델로 라우팅하고, 작업을 하위 세션에 위임
- **분할 워크스페이스** — 하나의 창에 최대 6개 패인(채팅, 터미널, 브라우저, 미리보기, 편집기, git, 노트)
- **파일 탐색기 및 편집기** — 워크스페이스를 탐색하고 내장 편집기에서 코드 편집
- **Git 패널** — UI를 벗어나지 않고 파일 또는 개별 hunk 스테이징, 커밋(AI 생성 메시지 지원), diff, 브랜치, pull/push, 체크포인트 복원
- **통합 터미널** — 워크스페이스마다 완전한 셸 제공
- **칸반 보드** — 카드를 옮기면 해당 카드에 대한 에이전트 실행이 시작되고(선택적으로 전용 worktree에서), 작업이 끝나면 에이전트가 결과를 보고
- **TaskMaster** — PRD를 작업으로 변환하고 작업 보드에서 추적
- **메시지 대기열** — 에이전트가 작업 중일 때 보낸 메시지는 서버에 대기열로 저장되며, 새로고침이나 기기 전환 후에도 유지
- **MCP 관리** — 에이전트 간 MCP 서버 추가, 편집, 동기화
- **지식 베이스** — 모든 에이전트가 공유하는 하나의 로컬 검색 가능 메모리: 규칙, 스킬, 메모리, 개인 정보를 MCP를 통해 필요할 때 검색 ([문서](KNOWLEDGE.ko.md))
- **스킬 및 규칙** — 에이전트 스킬과 공유 규칙을 한곳에서 관리
- **할당량 및 사용량** — 에이전트별 토큰 사용량과 구독 한도를 한눈에
- **Browser-use** — 조사와 테스트를 위한 에이전트 주도 브라우저 세션, 실시간 브라우저 패인 제공
- **Worktree** — 작업별로 격리된 git worktree를 생성하고, worktree별 설정/실행 스크립트와 인증된 실시간 개발 서버 미리보기 제공
- **원격 승인** — Telegram, Discord 또는 Android 앱에서 도구 권한 승인 ([문서](https://github.com/Zakwei/ddagent/blob/main/docs/remote-approvals.md))
- **음성 입력** — Whisper 호환 음성 인식(STT) 엔드포인트로 프롬프트 받아쓰기
- **에이전트 브로드캐스트 및 공유 메모리** — 모든 에이전트에 한 번에 메시지를 보내고, 모두가 읽는 프로젝트별 노트 유지
- **멀티 계정 전환** — 프로바이더별 이름 있는 계정과 세션별 환경 변수 재정의
- **스케줄러** — cron 기반 무인 에이전트 실행, 실행 중에는 기기가 절전 모드로 들어가지 않도록 유지하는 옵션 제공
- **팀 협업** — 역할(owner/member/viewer), 초대 링크, 담당자, 댓글, 접속 상태 표시, 보드 활동 피드 ([문서](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md))
- **MCP 서버** — 외부 MCP 클라이언트(Claude Desktop, OpenClaw)가 세션 목록 조회, 작업 생성, 세션에 메시지 전송 가능 ([문서](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **알림 및 TTS** — 세션에 사용자 입력이 필요할 때 푸시, Telegram, Discord 알림 전송, 선택적으로 응답 소리 내어 읽기
- **명령 팔레트** — `Ctrl/Cmd+Shift+K`로 세션과 메시지를 검색하고, 원하는 페이지로 이동하거나 빠른 작업 실행
- **Docker 샌드박스** — microVM으로 격리된 Docker Sandboxes에서 에이전트 실행 ([문서](https://github.com/Zakwei/ddagent/blob/main/docker/README.md))
- **Flutter 클라이언트** — 웹, Linux, Windows, Android를 위한 하나의 코드베이스; **12개 언어**, 다크 및 라이트 테마

## 지원 에이전트

| 에이전트 | 연결 방식 |
|---|---|
| **Claude Code** | Claude Agent SDK; `~/.claude` 세션 자동 검색; MCP 및 설정을 네이티브 CLI와 동기화 |
| **Codex** | Codex SDK; `~/.codex`의 로컬 세션 및 트랜스크립트 |
| **Cursor CLI** | 스트리밍 JSON 출력을 사용하는 `cursor-agent`; `~/.cursor`의 로컬 채팅 |
| **OpenCode** | `opencode serve`; OpenCode 데이터베이스의 로컬 세션 |
| **Devin** | `devin acp`(Agent Client Protocol); 로컬 트랜스크립트 |
| **Command Code** | `command-code acp`(Agent Client Protocol); `~/.commandcode`의 트랜스크립트 |
| **Antigravity** | 헤드리스 모드의 `agy` CLI; `~/.gemini/antigravity-cli`에서 인덱싱한 대화 |

에이전트 CLI는 서버 머신에 설치되어 있고 로그인된 상태여야 합니다. 구독은 직접 준비하세요 — ddagent는 AI가 아닌 환경을 제공합니다.

## 설치

ddagent는 두 부분으로 구성됩니다. 에이전트와 같은 머신에서 실행되며 REST/WebSocket API를 제공하는 **서버**, 그리고 서버에 연결하는 **클라이언트**입니다. 서버에는 **Node.js 22+**가 필요합니다(사전 빌드 tarball은 네이티브 모듈이 Node.js 22.x 기준으로 빌드되므로 Node.js 22.x가 필요합니다).

### 서버 — 설치 스크립트

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

`git`, Node.js 22+, `npm`이 필요합니다. 스크립트는 릴리스 태그를 `~/.ddagent/app`에 클론하고, 의존성을 설치하고, 백엔드를 빌드한 뒤 `start.sh` 런처를 생성합니다. 옵션은 `bash -s --` 뒤에 전달합니다:

| 옵션 | 설명 |
|---|---|
| `--version vX.Y.Z` | 특정 릴리스 설치(기본값: 최신) |
| `--dir <path>` | 설치 디렉터리(기본값: `~/.ddagent/app`) |
| `--systemd` | `ddagent`라는 이름의 systemd 사용자 서비스를 설치하고 활성화 |
| `--port <port>` | systemd 서비스 포트(기본값: `3001`) |

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash -s -- --systemd --port 3001
```

그런 다음 서버를 시작합니다:

```bash
~/.ddagent/app/start.sh        # API on http://<host>:3001 (set SERVER_PORT to change)
```

### 서버 — 사전 빌드 tarball

빌드 과정이 필요 없습니다. [Releases](https://github.com/Zakwei/ddagent/releases)에서 `ddagent-server-<version>-<os>-<arch>.tar.gz`(`linux-x64`, `mac-arm64` 또는 `win-x64`)를 다운로드해 압축을 풀고 런처를 실행하세요:

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh             # start.bat on Windows
```

각 tarball에는 `.sha256` 체크섬이 함께 제공됩니다. 설정은 `start.sh` 옆의 선택적 `.env` 파일에 넣습니다.

### 클라이언트

[Releases](https://github.com/Zakwei/ddagent/releases)에서 사전 빌드된 클라이언트를 다운로드하세요:

| 플랫폼 | 파일 |
|---|---|
| Windows x64 | `ddagent-flutter-windows-x64-<tag>-setup.exe`(설치 프로그램) 또는 `.zip`(포터블) |
| Linux x64 | `ddagent-flutter-linux-x64-<tag>.deb` 또는 `.tar.gz` |
| Android | `ddagent-flutter-android-<tag>.apk` |
| Web | `ddagent-flutter-web-<tag>.zip` |

처음 실행할 때 서버 URL(예: `http://my-vps:3001`)을 입력하고 첫 계정을 만드세요. Windows와 Linux x64에서는 데스크톱 클라이언트가 로컬 서버를 직접 다운로드해 실행해 줄 수도 있습니다(연결 화면의 "이 기기").

웹 빌드에는 로그인 화면이 없고 자신과 같은 오리진의 API를 호출하므로, 단일 사용자 플랫폼 모드(`VITE_IS_PLATFORM=true`, 인증 비활성화)로 실행 중인 서버 앞에 리버스 프록시를 두고 제공해야 합니다. 소스 체크아웃에서는 `node scripts/serve-flutter-web.cjs`가 `flutter/build/web`을 포트 8085로 제공하고, API와 WebSocket을 `FLUTTER_BACKEND_PORT`(기본값 `10087`)의 서버로 프록시합니다. 이 구성은 신뢰할 수 있는 네트워크에서만 노출하세요.

클라이언트를 직접 빌드하려면:

```bash
cd flutter
flutter pub get
flutter build linux --release      # or: windows, apk, web
```

### 업데이트

클라이언트의 **설정 → 정보 → 업데이트**에는 구성 요소마다 별도의 버튼이 있습니다:

| 구성 요소 | 업데이트 방식 |
|---|---|
| **서버** | 설치 스크립트나 git으로 설치한 경우 최신 릴리스로 전환됩니다. 릴리스 tarball로 설치한 경우 다음 tarball을 다운로드해 검증(`.sha256`)한 뒤 재시작할 때 설치하며, 서버가 시작되지 않으면 자동으로 롤백합니다. `start.sh` / `start.bat`이 알아서 서버를 재시작하므로 systemd가 필요 없습니다. 데스크톱 클라이언트의 로컬 서버("이 기기")는 앱이 다시 설치합니다. |
| **웹 인터페이스** | 서버가 호스팅하는 경우(`DDAGENT_WEB_DIR`, 또는 `scripts/serve-flutter-web.cjs`가 제공하는 `flutter/build/web`) 릴리스의 웹 zip으로 교체됩니다. 서버를 업데이트할 때마다 함께 갱신됩니다. |
| **이 앱** | Android는 새 APK를 설치합니다. Windows와 Linux는 새 빌드를 백그라운드에서 다운로드하고 앱을 종료할 때 설치합니다. |

릴리스 tarball은 Node.js 22용으로 빌드되며, 서버는 다른 Node.js 메이저 버전용으로 빌드된 tarball을 거부합니다. 0.8.12 이하 버전의 서버(설치 스크립트 또는 tarball)는 0.8.13으로 한 번만 직접 업데이트해야 합니다. `install.sh --version v0.8.13`을 다시 실행하거나 새 tarball을 기존 설치 위에 풀면 되고, 그 이후로는 UI에서 업데이트할 수 있습니다.

### 소스에서

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run build && node dist-server/server/index.js   # API on http://localhost:3001
```

### Docker 샌드박스(실험적)

```bash
ddagent sandbox ~/my-project
```

ddagent와 에이전트(Claude Code 또는 Codex)를 microVM으로 격리된 Docker Sandbox 안에서 실행합니다. `sbx` CLI가 필요합니다 — [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md)를 참조하세요.

## CLI

소스 또는 `install.sh` 체크아웃에서 아래의 `ddagent`는 `node dist-server/server/modules/cli/cli.js`를 의미합니다(shebang이 있으므로 `./dist-server/server/modules/cli/cli.js`도 작동합니다).

| 명령 | 설명 |
|---|---|
| `ddagent` / `ddagent start` | 서버 시작(기본 명령) |
| `ddagent status` | 버전, 설정 파일, 데이터베이스, Claude 프로젝트 위치 표시 |
| `ddagent sandbox <workspace>` | Docker 샌드박스 생성 및 시작; `ddagent sandbox help`로 `ls`, `start`, `stop`, `rm`, `logs` 확인 |
| `ddagent browser-use-mcp` | stdio로 browser-use MCP 서버 실행 |
| `ddagent version` | 버전 출력 |
| `ddagent help` | 도움말 표시 |

| 옵션 | 설명 |
|---|---|
| `-p, --port <port>` | 서버 포트(`SERVER_PORT`보다 우선) |
| `--database-path <path>` | 사용자 지정 데이터베이스 위치(`DATABASE_PATH`보다 우선) |

## 구성

서버는 설치 디렉터리(`start.sh` 옆)에 있는 선택적 `.env` 파일을 읽으며, 실제 환경 변수가 우선합니다. 어떤 파일이 사용되는지 확인하려면 `ddagent status`를 실행하세요.

| 변수 | 기본값 | 설명 |
|---|---|---|
| `SERVER_PORT` | `3001` | API + WebSocket 포트(`PORT`도 레거시 별칭으로 허용) |
| `HOST` | `0.0.0.0` | 바인드 주소(localhost 전용은 `127.0.0.1`) |
| `DATABASE_PATH` | `~/.ddagent/auth.db` | SQLite 데이터베이스(사용자, 설정, 토큰) |
| `WORKSPACES_ROOT` | 홈 디렉터리 | 프로젝트는 이 디렉터리 안에 있어야 함 |
| `JWT_SECRET` | 자동 생성 | 로그인 토큰 서명용 시크릿(설치마다 생성 및 저장) |
| `API_KEY` | 미설정 | 설정하면 API 요청은 `x-api-key` 헤더에 이 값을 보내야 함 |
| `CLAUDE_CLI_PATH` | `claude` | 사용자 지정 Claude Code CLI 바이너리 |
| `CONTEXT_WINDOW` | `200000` | Claude 컨텍스트 윈도 대체값, SDK가 모델의 실제 윈도를 보고할 때까지 사용 |
| `STT_ENDPOINT_URL` / `STT_API_KEY` / `STT_MODEL` | `https://api.openai.com/v1` / 미설정 / `whisper-1` | 음성 입력용 음성 인식(설정에서도 구성 가능) |
| `VITE_IS_PLATFORM` | `false` | 단일 사용자 플랫폼 모드: 인증 생략(웹 클라이언트에 필요) |

자세한 내용은 [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example)을 참조하세요.

## 개발

```bash
npm install
npm run dev               # start the backend from source (tsx, no reload)
npm run server:dev-watch  # same, restarting on file changes
npm run build             # compile the server to dist-server/
npm test                  # backend tests
npm run typecheck         # TypeScript check
npm run lint              # ESLint
```

클라이언트(Flutter 3.47.5 stable):

```bash
cd flutter
flutter pub get
flutter run -d linux --dart-define=DEFAULT_SERVER_URL=http://localhost:3001
dart format --line-length 100 lib test
flutter analyze
flutter test
```

백엔드 코드는 `server/modules/`의 모듈 아키텍처를 따릅니다. 프로바이더 내부 구조는 [`server/modules/providers/README.md`](https://github.com/Zakwei/ddagent/blob/main/server/modules/providers/README.md)를 참조하세요.

## 기여하기

버그 수정은 언제나 환영합니다 — [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md)를 참조하세요. 취약점을 신고하려면 [SECURITY.md](https://github.com/Zakwei/ddagent/blob/main/SECURITY.md)를 참조하세요.

---

<div align="center">
  <sub>Claude Code, Codex, Cursor, OpenCode, Devin, Command Code, Antigravity 커뮤니티를 위해 만들어졌습니다.</sub>
</div>
