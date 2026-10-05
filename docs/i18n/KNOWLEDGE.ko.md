# 지식 베이스

<p>
  <a href="../../KNOWLEDGE.md">English</a> ·
  <a href="KNOWLEDGE.pl.md">Polski</a> ·
  <a href="KNOWLEDGE.de.md">Deutsch</a> ·
  <a href="KNOWLEDGE.es.md">Español</a> ·
  <a href="KNOWLEDGE.fr.md">Français</a> ·
  <a href="KNOWLEDGE.it.md">Italiano</a> ·
  <a href="KNOWLEDGE.ja.md">日本語</a> ·
  <strong>한국어</strong> ·
  <a href="KNOWLEDGE.ru.md">Русский</a> ·
  <a href="KNOWLEDGE.tr.md">Türkçe</a> ·
  <a href="KNOWLEDGE.zh-CN.md">简体中文</a> ·
  <a href="KNOWLEDGE.zh-TW.md">繁體中文</a>
</p>

ddagent는 에이전트를 위한 **로컬 우선 지식 베이스**를 제공합니다: 메모리, 규칙,
스킬, 개인 정보, 그리고 태그와 관계입니다. ddagent의 나머지와 같은
SQLite 데이터베이스(`auth.db`)에 FTS5 전체 텍스트 인덱스와 함께 존재하며,
클라이언트의 **Knowledge** 화면에서 관리되고, 에이전트가 MCP를 통해 읽고
쓸 수 있습니다. [Contexta](https://github.com/XFABISIEK/Contexta)에서
느슨하게 영감을 받았습니다.

요점은 단순합니다. 규칙과 프로젝트 지식은 더 이상 도구별 파일
(`AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `skills/` 등)에 흩어져 있지 않고,
모든 에이전트가 사용할 수 있는 하나의 잘 정리된 검색 가능한 장소가 됩니다 — 파일을
읽는 에이전트도, MCP를 말하는 에이전트도 마찬가지입니다.

## 에이전트가 실제로 보는 방식

세 개의 계층이 있으며, 어느 것이 어느 것인지 알면 도움이 됩니다:

- **CLI 네이티브 파일** — 각 도구는 자체 설정을 스스로 읽습니다: Claude Code는
  `CLAUDE.md`를, Codex/Cursor는 `AGENTS.md`를, Cursor는 `.cursorrules`를 읽고,
  몇몇은 `skills/`와 `.agents/skills/`를 읽습니다. 이것은 CLI의 일이지
  모델의 선택이 아닙니다 — ddagent는 이를 끄지 않습니다.
- **MCP 검색(온디맨드)** — 에이전트에 ddagent의 MCP 서버를 설치하면 도구 목록에
  `knowledge_get_context`, `knowledge_search` 등이 포함됩니다. Contexta를 따라,
  자동으로 주입되는 것은 없습니다: 에이전트가 쿼리를 가지고 컨텍스트 빌더를
  호출하면 `critical` 규칙과 일치하는 내용을 돌려받습니다. 모델은 도구 설명과
  지식 베이스에 보관한 지침 규칙에 따라 언제 호출할지 결정합니다.

따라서 "한 곳"이란 **지식을 관리하는 한 곳**을 의미합니다
— CLI가 자체 네이티브 파일을 읽는 것을 막지 않으며(막을 수도 없습니다).
ddagent는 지식 베이스를 세션에 자동 주입하지 않습니다.

## 엔티티

| 엔티티 | 범위 | 비고 |
|---|---|---|
| 메모리 | 프로젝트 또는 전역 | `memory_type`(`fact`/`decision`/`note`/`reference`), `priority`, `source`, 태그 |
| 규칙 | 프로젝트 또는 전역 | `enabled` 토글; `critical` 규칙은 컨텍스트 빌더에 의해 항상 먼저 반환됨 |
| 스킬 | 전역 | 고유한 이름, 카테고리, 선택적 아이콘(base64 data URL) |
| 개인 정보 | 전역 | 고유 `key` |
| 태그 / 연결 | — | 메모리의 태그; 연결은 임의의 두 엔티티를 잇음 |
| 기록 | — | 모든 쓰기는 엔티티를 스냅샷하므로 검토하고 복원할 수 있음 |

우선순위: `critical > high > normal > low`. 엔티티는 하나의
프로젝트로 범위를 정하거나 전역(어디에나 적용)일 수 있습니다. `project_id`는 일반 컬럼입니다(외래
키 아님). 프로젝트 테이블이 마이그레이션 중에 재구성되기 때문입니다.

## 컨텍스트 검색(온디맨드)

에이전트는 MCP 도구 `knowledge_get_context`를 통해 컨텍스트를 가져옵니다
(Contexta의 ContextBuilder를 충실히 이식한 것입니다). 프로젝트와 쿼리를 주면
다음 순서로 반환합니다:

- **모든 활성화된 규칙**(프로젝트 + 전역), `critical` 우선(상한 20),
- 쿼리로 순위가 매겨진 **메모리**(FTS), 그리고 연결을 통해 도달한 1홉 이웃
  (상한 5); 쿼리가 없으면 우선순위별 프로젝트 상위 메모리,
- 쿼리로 순위가 매겨진 **스킬**; 쿼리가 없으면 가장 최근 스킬,
- 쿼리가 일치할 때만 **개인 정보**(상한 3),

섹션별로 항목이 잘리고(800/1000/600자) `maxTokens`(기본 약 4000)로 상한이 적용된
Markdown 블록으로 렌더링됩니다; 더 이상 들어가지 않는 항목은 생략으로 집계됩니다.

대시보드는 선택한 프로젝트에 대해 **규칙 컨텍스트 미터**(`~X / 4000 tok`)를
표시합니다 — 모든 `knowledge_get_context` 호출이 항상 포함하는 규칙 블록의
크기입니다. 세션에 자동으로 주입되는 것은 없습니다.

검색 순위는 하이브리드입니다. Contexta의 `search.rs`처럼 FTS5 **prefix** 매칭(`auth`는 `authentication`도 매칭)에 오타와 유사 동의어를 잡아내는 퍼지 **trigram** 패스를 더한 뒤 `bm25 + priority + recency`로 재정렬합니다.

## MCP 도구 (온디맨드)

ddagent의 MCP 서버(`POST /mcp`)는 지식 베이스를 모든 MCP 클라이언트에 노출합니다.
읽기 도구는 `read` 범위 토큰으로 작동하고, 쓰기 도구는 `write`가 필요합니다. 쓰기
도구는 UI와 동일한 검증을 실행하고 기록을 남깁니다.

읽기: `knowledge_search`, `knowledge_get_context`, `knowledge_get_memories`,
`knowledge_get_rules`, `knowledge_get_skills`, `knowledge_get_personal`,
`knowledge_get_graph`, `knowledge_history`.

쓰기: `knowledge_add_memory`, `knowledge_update_memory`,
`knowledge_delete_memory`, 그리고 `rule`, `skill`, `personal`에 대한 동일한 3종 세트;
추가로 `knowledge_link` / `knowledge_unlink`.

도구는 `projectId` 또는 ddagent가 이미 아는 `projectPath`를 받습니다.

### 에이전트에 서버 설치

제공자 설정을 직접 편집할 필요가 없습니다. **Settings → MCP →
Install ddagent MCP server**(온보딩 단계로도 제공됨)를 사용하고
에이전트를 선택하세요 — 또는 모두에 설치하세요. `<server>/mcp`를 가리키는
`ddagent` HTTP MCP 항목(사용자 범위)을 재사용 가능한 `ddagent-mcp` 베어러 토큰과 함께
기록합니다(재설치하면 이전 토큰은 폐기됩니다). 설치 후 해당 에이전트의 도구에는
`create_task`, `send_message` 등과 함께 `knowledge_*` 그룹이 포함됩니다.

에이전트는 언제 MCP를 써야 하는지 어떻게 알까요? 추측하지 않습니다 — 알려주세요.
`critical` 규칙을 유지하세요: *"이 프로젝트에 대한 질문에 답하기 전에
`knowledge_get_context`를 호출하라; 결정을 내리면 `knowledge_add_memory`로
영속화하라."* `critical` 규칙은 컨텍스트 빌더에 의해 항상 반환되므로,
이 도구를 호출하는 모든 에이전트가 동일한 운영 지침을 받습니다.

## 프로젝트 스캔

`POST /api/knowledge/scan`은 프로젝트의 AI 컨텍스트 파일을 의도별로
분류해 가져옵니다:

- `AGENTS.md`, `CLAUDE.md`, `MUSE.md`, `GEMINI.md`, `CODEX.md`, `.cursorrules`,
  `.muserules` 및 `.cursor/rules` 아래의 markdown/`.mdc`는 **규칙**이 됩니다
  (critical + enabled라서 에이전트 컨텍스트에 도달합니다; 워크스페이스 `AGENTS.md`는
  unified-rules와의 이중 주입을 피하기 위해 `high`입니다),
- `skills` / `.agents/skills` 아래의 `SKILL.md` 파일은 **스킬**이 됩니다
  (frontmatter의 이름/설명),
- 그 밖에 스캔된 markdown은 **참조 메모리**가 됩니다.

각 파일은 `kb_scan_state`에 내용 해시로 추적되므로, 재스캔은
변경된 파일만 건드리고 소스가 사라진 엔티티를 삭제합니다.

## 클라이언트

**Knowledge** 화면(내비게이션 레일 → Knowledge)에는 Dashboard, Memories,
Rules, Skills, Personal, Graph 탭, 프로젝트 범위 필터, 모달
생성/편집 양식, 복원이 있는 엔티티별 버전 기록, 스킬 아이콘 업로드,
JSON 내보내기/가져오기가 있습니다. Memories 탭에는 태그 필터 바(태그 관리 포함)가,
앱 바에는 전체 텍스트 검색, 링크 생성 대화상자, 마이그레이션 작업이 있으며,
Graph 탭은 팬/줌, 노드 드래그, 엔티티 유형 필터, 이웃 하이라이트가 있는
힘 기반 관계 뷰입니다.
그래프는 명시적 링크와 암시적 허브를 그립니다 — 프로젝트 범위의 모든 엔티티는 해당 프로젝트에 연결되고, 태그를 공유하는 메모리는 태그 노드에 연결됩니다 — 따라서 항상 구조를 보여줍니다.

## 잘 관리하기

1. 각 활성 프로젝트를 한 번 **스캔**하세요(Knowledge → 프로젝트 선택 → scan);
   지침 파일에 큰 변경이 있으면 다시 스캔하세요.
2. **의도적으로 승격**하세요: 정말 구속력 있는 규칙만 `critical`이어야 합니다
   (컨텍스트 빌더에 의해 항상 제공됩니다). 행의 별을 사용하고
   크리티컬 컨텍스트 미터를 지켜보세요.
3. **나머지는 `high`/`normal`로 유지**하세요 — 여전히 검색 가능하고 MCP로 사용할 수 있으며
   쿼리가 일치할 때만이므로 관련이 없을 때는 비용이 들지 않습니다.
4. 프로젝트 간 선호(시간대, 편집기, 명명)에는 **개인 정보**를 사용하세요.
5. **관련 메모리를 연결**하여 1홉 이웃이 함께 따라오게 하세요.
6. 지식 베이스를 검색하고 배운 것을 영속화해야 하는 에이전트에 **MCP를 설치**하세요;
   대부분에는 `read` 범위를, 신뢰하는 에이전트에는 `write`를 주세요.

## 마이그레이션

Knowledge → 메뉴 → **Migrate existing rules**는 **dry-run** 보고서를 실행합니다:
모든 프로젝트를 스캔하고, 프로젝트 간에 존재하는 중복(같은 정규화된
제목 + 내용)을 찾아 규칙 수를 보여줍니다. 여기서 **Merge duplicates**
(하나의 전역 행으로 병합) 및/또는 **Make all rules critical**을 실행할 수 있습니다. 확인하기
전에는 아무것도 기록되지 않습니다 — 파괴적 작업은 명시적입니다.

**Dashboard**에는 **모든 것을 ddagent로 가져오기** 버튼도 하나 있습니다. 프로젝트 스캔과 에이전트 스킬 가져오기를 한 번의 작업으로 실행하며, 동일한 dry-run 미리보기와 선택적 중복 병합 / 승격 토글을 제공합니다. 에이전트의 파일을 읽기만 하고 ddagent 자체 데이터베이스에 기록합니다 — CLI 파일이나 설정은 전혀 건드리지 않습니다(에이전트 설정에 기록하는 유일한 작업은 별도의 "Install ddagent MCP server"입니다).

같은 메뉴에 **에이전트 스킬 가져오기**가 있습니다: 에이전트가 이미 함께 제공하거나 설치한 전역/기본 스킬(사용자 / 시스템 / 플러그인 범위)을 나열하고, 없는 스킬을 지식 베이스에 스킬로 가져옵니다. 먼저 dry-run이며 멱등합니다 — 이미 존재하는 이름은 건너뜁니다. 프로젝트 범위 스킬은 대신 프로젝트 스캔에서 가져옵니다.

## 알아 두면 좋은 것

- 모든 것은 이 ddagent 인스턴스에 **로컬**입니다; 클라우드도, 동기화도 없습니다.
- 지식 베이스는 **자동 주입되지 않습니다** — 에이전트가 MCP를 통해 온디맨드로
  가져옵니다(Contexta 모델). MCP 서버를 설치하지 않은 에이전트는 아무것도 받지
  못합니다.
- 스캔된 스킬은 MCP(`knowledge_get_context` / `knowledge_search`)를 통해 도달할 수
  있으며, 컨텍스트에 밀어 넣어지지 않습니다.
- 규칙이나 메모리는 에이전트가 MCP를 통해 편집할 수 있습니다; 변경을
  엔티티의 **History**에서 검토하고 필요하면 이전 버전을 복원하세요.

## REST API

인증 뒤 `/api/knowledge`에 마운트됩니다:

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
GET    /context             ?projectId=            (크리티컬 컨텍스트 크기 + 예산)
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

`projectId=global`은 목록을 전역 행으로 제한합니다; 프로젝트 id에 `includeGlobal=true`를
추가하면 프로젝트 행과 전역 행을 반환합니다.

## 관련 항목

- [MCP 서버로서의 ddagent](mcp-server.md) — 도구 카탈로그와 토큰 설정
- [팀 협업](teams.md) · [원격 승인](remote-approvals.md)
