<div align="center">
  <img src="https://raw.githubusercontent.com/Zakwei/ddagent/main/public/logo.svg" alt="ddagent" width="72" height="72">
  <h1>ddagent</h1>
  <p><strong>모든 AI 코딩 에이전트를 위한 하나의 UI.</strong><br>
  Claude Code, Codex, Cursor CLI, OpenCode, Devin을 위한 셀프호스팅 웹 및 모바일 인터페이스 — 세션, 파일, git, 터미널, 작업을 한곳에서.</p>

  <p>
    <img src="https://img.shields.io/badge/version-0.5.9-0066FF" alt="버전">
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

---

## ddagent란?

ddagent는 사용자의 머신 또는 VPS에서 실행되며, 이미 사용 중인 코딩 에이전트 위에 세련된 웹 UI를 제공합니다. 디스크에서 에이전트 세션을 직접 검색합니다 — `~/.claude`, Codex, Devin 기록이 즉시 표시되며, 아무것도 복제되거나 제3자와 동기화되지 않습니다.

네트워크상의 모든 브라우저나 휴대폰에서 열 수 있습니다. 당신의 머신, 당신의 에이전트, 당신의 데이터.

## 기능

- **멀티 에이전트 세션** — Claude Code, Codex, Cursor CLI, OpenCode, Devin 세션을 나란히 실행하고 재개하며, WebSocket을 통한 라이브 스트리밍 지원
- **분할 패인** — 하나의 워크스페이스에 채팅, 터미널, 브라우저, 파일 패인
- **파일 탐색기 및 편집기** — 워크스페이스를 탐색하고 CodeMirror로 코드 편집
- **Git 패널** — UI를 떠나지 않고 스테이징, 커밋, diff, 브랜치 전환
- **통합 셸** — 워크스페이스별 전체 터미널과 독립 셸 탭
- **작업 보드** — TaskMaster 기반 칸반 보기; PRD를 실행 가능한 작업으로 변환
- **MCP 관리** — 에이전트 간 MCP 서버 추가, 편집, 동기화
- **스킬 브라우저** — UI에서 에이전트 스킬 관리
- **할당량 및 사용량** — 에이전트별 토큰 사용량과 구독 한도를 한눈에
- **Browser-use** — 조사 및 테스트를 위한 에이전트 주도 브라우저 세션
- **Worktree** — 작업별 격리된 git worktree 생성, worktree별 설정/실행 스크립트와 인증된 라이브 개발 서버 미리보기 제공
- **원격 승인** — Telegram, Discord 또는 모바일 앱에서 도구 권한 승인
- **음성 입력** — Whisper 호환 STT 엔드포인트로 프롬프트 받아쓰기
- **에이전트 브로드캐스트 및 공유 메모리** — 모든 에이전트에 한 번에 메시지를 보내고 모두가 읽는 프로젝트별 노트 유지
- **멀티 계정 전환** — 프로바이더별 명명된 계정과 세션별 환경 변수 재정의
- **스케줄러** — cron 기반 에이전트 실행, 웹/데스크톱에서 keep-awake 지원
- **팀 협업** — 역할(owner/member/viewer), 초대 링크, 담당자, 댓글, 프레즌스, 보드 활동 피드 ([문서](https://github.com/Zakwei/ddagent/blob/main/docs/teams.md))
- **MCP 서버** — 외부 MCP 클라이언트(Claude Desktop, OpenClaw)가 작업을 생성하고 세션에 메시지를 보낼 수 있도록 허용 ([문서](https://github.com/Zakwei/ddagent/blob/main/docs/mcp-server.md))
- **알림 및 TTS** — 세션이 당신을 필요로 할 때 알림 수신(또는 음성 안내)
- **Docker 샌드박스** — microVM으로 격리된 환경에서 에이전트 실행 ([문서](https://github.com/Zakwei/ddagent/blob/main/docker/README.md))
- **데스크톱 컴패니언** — 선택적 Electron 앱; **12개 언어**, 다크 및 라이트 테마

## 지원 에이전트

| 에이전트 | 연결 방식 |
|---|---|
| **Claude Code** | `~/.claude` 세션 자동 검색; MCP 및 설정을 네이티브 CLI와 동기화 |
| **Codex** | 로컬 CLI 세션 및 트랜스크립트 |
| **Cursor CLI** | 로컬 CLI 세션 |
| **OpenCode** | 로컬 세션 및 스킬 위치 |
| **Devin** | 로컬 동기화를 통한 CLI/ACP 세션 |

구독은 직접 준비하세요 — ddagent는 AI가 아닌 환경을 제공합니다.

## 설치

서버를 실행할 머신에 **Node.js 22+**가 필요합니다. 서버는 웹 UI와 데스크톱 및 모바일 앱이 원격으로 연결하는 REST/WS API를 제공합니다.

### 셀프호스트 서버 — 설치 스크립트

```bash
curl -fsSL https://github.com/Zakwei/ddagent/releases/latest/download/install.sh | bash
```

최신 릴리스 태그를 `~/.ddagent/app`에 클론하고, 웹 UI + 백엔드를 빌드한 뒤 `start.sh` 런처를 남깁니다. 옵션: `--version vX.Y.Z` · `--dir <path>` · `--port <port>` · `--systemd`(사용자 systemd 유닛 설치 및 활성화). `--version`으로 다시 실행하면 제자리에서 업데이트됩니다.

다음으로:

```bash
~/.ddagent/app/start.sh        # → http://localhost:3001
```

### 셀프호스트 서버 — 사전 빌드 tarball

빌드 단계 없음 — [Releases](https://github.com/Zakwei/ddagent/releases)에서 `ddagent-server-<version>-<os>-<arch>.tar.gz`를 다운로드하고 압축을 풀어 실행:

```bash
mkdir ddagent && tar xzf ddagent-server-*-linux-x64.tar.gz -C ddagent
./ddagent/start.sh           # start.bat on Windows
```

### 데스크톱 앱

[Releases](https://github.com/Zakwei/ddagent/releases)에서 OS용 설치 프로그램을 다운로드하세요: `.dmg`(macOS) · `.exe`(Windows) · `.AppImage` / `.deb`(Linux).

독립 실행 — 서버가 내장되어 있어 다른 설치가 필요 없음 — 또는 셀프호스트 서버 URL에 대한 원격 모드로 실행. 릴리스의 `latest*.yml` 피드를 통해 자동 업데이트됩니다.

### 모바일 앱(미리보기)

[Releases](https://github.com/Zakwei/ddagent/releases)에서 `ddagent-mobile-<version>.apk`를 다운로드하여 Android 기기에 설치하세요; 앱은 셀프호스트 서버 URL에 연결됩니다.

### 소스에서

```bash
git clone https://github.com/Zakwei/ddagent.git
cd ddagent
npm install
npm run dev        # server :3001 + Vite :5173 with HMR
```

### Docker 샌드박스(실험적)

```bash
ddagent sandbox ~/my-project
```

에이전트를 하이퍼바이저로 격리된 샌드박스에서 실행합니다. [docker/README.md](https://github.com/Zakwei/ddagent/blob/main/docker/README.md)를 참조하세요.

## CLI

소스 또는 `install.sh` 체크아웃에서 아래 `ddagent`는 `node dist-server/server/modules/cli/cli.js`를 의미합니다(shebang이 있으므로 `./dist-server/server/modules/cli/cli.js`도 작동합니다).

| 명령 | 설명 |
|---|---|
| `ddagent` | 서버 시작 |
| `ddagent start` | 서버 시작 |
| `ddagent status` | 설정 및 데이터 위치 표시 |
| `ddagent version` | 버전 출력 |
| `ddagent help` | 도움말 표시 |

## 구성

모든 설정은 하나의 env 파일에 있습니다 — `ddagent status`를 실행하면 어디서 읽는지 확인할 수 있습니다.

| 변수 | 기본값 | 설명 |
|---|---|---|
| `SERVER_PORT` | `3001` | API + WebSocket 포트 |
| `VITE_PORT` | `5173` | 개발 서버 포트 |
| `HOST` | `0.0.0.0` | 바인드 주소(localhost 전용은 `127.0.0.1`) |
| `DATABASE_PATH` | auto | 인증 데이터베이스 위치 |
| `CONTEXT_WINDOW` | `160000` | 세션당 최대 토큰 수 |
| `CLAUDE_CLI_PATH` | `claude` | 사용자 지정 Claude CLI 바이너리 경로 |

전체 목록은 [`.env.example`](https://github.com/Zakwei/ddagent/blob/main/.env.example)을 참조하세요.

## 개발

```bash
npm run dev            # dev mode (server :3001 + vite :5173)
npm run build          # client + server production build
npm run test:client    # frontend tests
npm test               # backend tests
npm run typecheck      # TypeScript check
```

백엔드 코드는 `server/modules/`에 설명된 모듈 아키텍처를 따릅니다 — 프로바이더 내부는 [`server/modules/providers/README.md`](https://github.com/Zakwei/ddagent/blob/main/server/modules/providers/README.md)를 참조하세요.

## 기여하기

버그 수정은 환영합니다 — [CONTRIBUTING.md](https://github.com/Zakwei/ddagent/blob/main/CONTRIBUTING.md)를 참조하세요.

---

<div align="center">
  <sub>Claude Code, Cursor, Codex, OpenCode, Devin 커뮤니티를 위해 만들어졌습니다.</sub>
</div>
