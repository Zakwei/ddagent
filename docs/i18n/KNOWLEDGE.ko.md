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
- **ddagent 주입** — 세션의 첫 턴에 ddagent는 `<knowledge>` 블록을
  앞에 붙입니다(아래 세부 사항). 이는 모든 제공자에서 작동하며
  에이전트의 설정이 필요하지 않습니다.
- **MCP 도구** — 에이전트에 ddagent의 MCP 서버를 설치하면 도구
  목록에 `knowledge_search` 등이 포함됩니다. 모델은 도구 설명과 지식 베이스에
  보관한 지침 규칙에 따라 언제 호출할지 결정합니다.

따라서 "한 곳"이란 **주입되는 내용을 관리하는 한 곳과 하나의 예산**을
의미합니다 — CLI가 자체 네이티브 파일을 읽는 것을 막지 않으며(막을 수도 없습니다). 중복을
피하기 위해 워크스페이스 `AGENTS.md`를 `high` 우선순위로 유지하여 지식
블록이 unified-rules가 이미 주입하는 내용을 반복하지 않게 합니다.

## 엔티티

| 엔티티 | 범위 | 비고 |
|---|---|---|
| 메모리 | 프로젝트 또는 전역 | `memory_type`(`fact`/`decision`/`note`/`reference`), `priority`, `source`, 태그 |
| 규칙 | 프로젝트 또는 전역 | `enabled` 토글; `critical` 규칙은 세션에 주입됨 |
| 스킬 | 전역 | 고유한 이름, 카테고리, 선택적 아이콘(base64 data URL) |
| 개인 정보 | 전역 | 고유 `key` |
| 태그 / 연결 | — | 메모리의 태그; 연결은 임의의 두 엔티티를 잇음 |
| 기록 | — | 모든 쓰기는 엔티티를 스냅샷하므로 검토하고 복원할 수 있음 |

우선순위: `critical > high > normal > low`. 엔티티는 하나의
프로젝트로 범위를 정하거나 전역(어디에나 적용)일 수 있습니다. `project_id`는 일반 컬럼입니다(외래
키 아님). 프로젝트 테이블이 마이그레이션 중에 재구성되기 때문입니다.

## 첫 턴 주입 (모든 에이전트가 자동으로 받는 것)

세션의 **첫** 발신 메시지에서 ddagent는 다음을 포함하는 `<knowledge>`
블록을 앞에 붙입니다:

- `critical` **규칙**(프로젝트 + 전역, 활성화된 것만),
- `critical` **메모리**,
- 모든 **개인 정보** 항목,
- 포함된 메모리의 **1홉 이웃**(명시적 연결을 통해
  도달).

전체 블록은 약 4000 토큰으로 제한됩니다. `.ddagent/shared-context.md`와 unified rules와
같은 첫 턴 게이트를 타므로 턴당 토큰을 소비하지 않습니다.
`DDAGENT_KNOWLEDGE=0`으로 끌 수 있습니다.

대시보드는 선택한 프로젝트에 대해 **주입된 컨텍스트 미터**(`~X / 4000 tok`)를
표시하므로 컨텍스트에 무엇이 들어가는지 보고 제어할 수 있습니다.

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
`knowledge_search`를 호출하라; 결정을 내리면 `knowledge_add_memory`로
영속화하라."* 이 규칙은 매 첫 턴마다 주입되므로 모든
에이전트가 동일한 운영 지침을 받습니다.

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
힘 기반 관계 뷰입니다. Settings → Knowledge
에서 같은 화면으로 바로 이동합니다.

## 잘 관리하기

1. 각 활성 프로젝트를 한 번 **스캔**하세요(Knowledge → 프로젝트 선택 → scan);
   지침 파일에 큰 변경이 있으면 다시 스캔하세요.
2. **의도적으로 승격**하세요: 정말 구속력 있는 규칙만 `critical`이어야 합니다
   (주입됩니다). 행의 별을 사용하고 예산 미터를 지켜보세요.
3. **나머지는 `high`/`normal`로 유지**하세요 — 여전히 검색 가능하고 MCP로 사용할 수 있으며
   매 턴 컨텍스트를 소비하지 않습니다.
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

## 알아 두면 좋은 것

- 모든 것은 이 ddagent 인스턴스에 **로컬**입니다; 클라우드도, 동기화도 없습니다.
- 주입은 **세션당 한 번**(첫 턴) 일어납니다 — 새 세션이
  변경을 반영합니다.
- 스캔된 스킬은 **주입되지 않습니다**; MCP 검색을 통해 도달할 수 있어
  상시 켜진 컨텍스트를 가볍게 유지합니다.
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
GET    /context             ?projectId=            (injection preview + budget)
GET    /tags                DELETE /tags/:id
GET    /connections         POST /connections      DELETE /connections/:id
GET    /history             ?entityType=&entityId=&limit=
GET    /stats
GET    /export              POST /import
POST   /scan                { projectId }
POST   /migrate             { projectIds?, dryRun?, dedupe?, promoteRules? }
```

`projectId=global`은 목록을 전역 행으로 제한합니다; 프로젝트 id에 `includeGlobal=true`를
추가하면 프로젝트 행과 전역 행을 반환합니다.

## 관련 항목

- [MCP 서버로서의 ddagent](mcp-server.md) — 도구 카탈로그와 토큰 설정
- [팀 협업](teams.md) · [원격 승인](remote-approvals.md)
