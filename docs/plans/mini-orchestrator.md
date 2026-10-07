# Mini orchestrator — plan implementacji

Drugi, lekki silnik obok dużego orchestratora. Używa **dokładnie dwóch ról modeli**:

- **thinker** — model nie-flash do myślenia: planowanie, decyzje, review, raport.
- **worker** — model flash do roboty: wykonywanie kroków.

Domyślnie: `thinker = glm-5-3-high`, `worker = glm-5-3-flash-high` (dokładne uid-y Devin).

Per **typ zadania** konfigurujesz, która rola (czyli który model) bierze udział.
Streaming działa identycznie jak w dużym orchestratorze — te same ramki `status`
(`routing` / `plan` / `delegation` / `summary`), więc istniejące karty klienta
renderują się bez zmian.

Decyzja architektoniczna: **osobny provider `'mini-orchestrator'` + osobny moduł**
z reużyciem współdzielonych elementów dużego orchestratora (delegacja, transkrypt,
ramki statusu, run registry).

---

## 1. Stan obecny (co reużywamy)

| Element | Plik | Rola |
|---|---|---|
| Stała providera | `server/shared/utils.ts:56` `ORCHESTRATOR_PROVIDER = 'orchestrator'` | rozpoznanie sesji |
| Ramka statusu | `server/shared/utils.ts:776` `createOrchestratorStatusFrame` | jeden format eventu live |
| Delegacja + mirror streamu | `server/modules/orchestrator/services/orchestrator-delegation.service.ts` | uruchamia child-run i strumieniuje podglądy do wiersza transkryptu |
| Transkrypt | `server/modules/database/repositories/orchestrator-messages.db.ts` (`orchestrator_messages`) | `session_id` — działa dla dowolnego providera bez migracji |
| Klasyfikacja zadania | `server/modules/orchestrator/services/orchestrator-router.service.ts` (`classifyTaskType`) | typ zadania z treści |
| Config store | `server/modules/orchestrator/services/orchestrator-config.service.ts` | wzorzec `appConfigDb.get/set` + walidacja |
| Composition root | `server/modules/orchestrator/orchestrator.module.ts` (`publishEntry`) | fan-out ramek + runtime entry |

Wniosek: mini to ten sam mechanizm co duży, ale z pulą 2 kandydatów i mapą
**typ zadania → rola** zamiast listy failover per typ.

---

## 2. Struktura modułu backendu

Zgodnie z `backend-module-standards` (`server/modules/<feature>/`, TypeScript,
`index.ts` jako jedyny publiczny API, import innych modułów tylko przez barrel).

```
server/modules/mini-orchestrator/
  index.ts                              # barrel: miniOrchestratorRoutes, miniOrchestratorRuntime
  mini-orchestrator.module.ts           # composition root (config + role-router + executor + runtime + routes)
  mini-orchestrator.routes.ts           # HTTP /api/mini-orchestrator
  services/
    mini-orchestrator-config.service.ts # walidacja + persist `mini-orchestrator:config`
    mini-orchestrator.service.ts        # silnik: classify -> plan (thinker) -> kroki (role) -> raport
  tests/
    mini-orchestrator.test.ts           # silnik + wybór roli per typ
    mini-orchestrator-config.test.ts    # walidacja configu
```

### Współdzielone dodatki (bez duplikacji)

- `server/shared/utils.ts`
  - `export const MINI_ORCHESTRATOR_PROVIDER = 'mini-orchestrator';`
  - `export function isOrchestratorProvider(p): boolean` — używane w serwerze i do uogólnienia warunków.
  - `createOrchestratorStatusFrame` przestaje hardkodować `ORCHESTRATOR_PROVIDER` — bierze provider z wiersza.
- `server/shared/types.ts`
  - `export type MiniOrchestratorRole = 'thinker' | 'worker';`
  - `export type MiniOrchestratorConfig = { ... }` (patrz sekcja 3).
  - Reużycie istniejącego `OrchestratorCandidate` (id/provider/model/effort/accountId/fallbackAccountIds/tier/label).
- **`classifyTaskType` przenosimy do `server/shared/utils.ts`** — jest używany przez 2 moduły,
  więc zgodnie ze standardem ląduje w shared (nie w routerze orchestratora).
- Reuse z barrela `@/modules/orchestrator/index.js`: `createOrchestratorDelegationService`.

> Uwaga: `LLMProvider` (unia realnych providerów) **nie** zmieniamy — `'orchestrator'`
> też nie jest w tej unii; sesje mini tworzymy z castem, jak duży orchestrator.

---

## 3. Konfiguracja (mini)

```ts
export type MiniOrchestratorRole = 'thinker' | 'worker';

export type MiniOrchestratorConfig = {
  enabled: boolean;

  /** Model nie-flash: planuje, decyduje, robi review/raport. Primary + opcjonalne fallbacki (quota out). */
  thinker: OrchestratorCandidate[];

  /** Model flash: wykonuje kroki. Primary + opcjonalne fallbacki. */
  worker: OrchestratorCandidate[];

  /** Który model (rola) gra w danym typie zadania — główny knob "kto bierze udział". */
  roles: Record<OrchestratorTaskType, MiniOrchestratorRole>;

  planner: {
    mode: 'auto' | 'off';   // off = pomiń planowanie, leć od razu workerem
    requireConfirm: boolean;
  };

  execution: {
    maxParallel: number;    // 1..4
    maxSteps: number;       // twardy limit kroków planu
    stepTimeoutMs: number;  // 0 = brak
    runTimeoutMs: number;   // 0 = brak
  };
};
```

Domyślny config:

```ts
{
  enabled: true,
  thinker: [candidate('glm53-high',  'glm-5-3-high',       'mid',   'GLM-5.3 High')],
  worker:  [candidate('glm53f-high', 'glm-5-3-flash-high', 'cheap', 'GLM-5.3 Flash High')],
  roles: {
    plan: 'thinker', quick: 'worker', research: 'thinker', docs: 'worker',
    code: 'worker', 'code-hard': 'thinker', test: 'worker',
    review: 'thinker', gate: 'worker', report: 'worker',
  },
  planner: { mode: 'auto', requireConfirm: false },
  execution: { maxParallel: 2, maxSteps: 12, stepTimeoutMs: 30 * 60_000, runTimeoutMs: 0 },
}
```

Persist: `appConfigDb` pod kluczem `mini-orchestrator:config`, z fallbackiem do
defaultów przy braku/uszkodzonym wpisie (wzorzec `createOrchestratorConfigService`).

---

## 4. Przepływ silnika (`mini-orchestrator.service.ts`)

Reużywa: `chatRunRegistry`, `createOrchestratorStatusFrame` (+ `publishEntry`-like fan-out),
`createOrchestratorDelegationService`, `orchestratorMessagesDb`, `classifyTaskType`.

1. **Wejście** — `handleMessage({ sessionId, content, options, connection })`:
   - sprawdź `config.enabled`; zarejestruj parent run w `chatRunRegistry` (`provider = MINI_ORCHESTRATOR_PROVIDER`).
   - append wiersz `user`; `cwd` = `project_path` sesji.
2. **Klasyfikacja** — `classifyTaskType(content)` → `OrchestratorTaskType`.
3. **Plan**:
   - `planner.mode === 'off'` lub zadanie trywialne → jeden krok `worker`.
   - inaczej **thinker** (ukryty child run) zwraca JSON kroków `{ id, type, title, instructions, dependsOn? }`.
   - emituj wiersz `plan` (+ `awaitingConfirm` gdy `requireConfirm`);
     `POST /plan/confirm` wznawia wykonanie.
4. **Wykonanie** — dla każdego kroku:
   - rola = `roles[step.type]` → lista kandydatów (primary→fallback przy quota/rate limit);
   - delegacja istniejącym serwisem → mirror streamu do wiersza `delegation`;
   - `maxParallel`, `maxSteps`, `stepTimeoutMs`, `runTimeoutMs` z `execution`.
5. **Raport** — rola wg `roles.report` → wiersz `summary` z podsumowaniem runu.
6. **Abort/resume** — jak w dużym: `abort(sessionId)`, `resume(sessionId)` re-czytają stan z transkryptu.

Świadomie **bez** supervised-loop, checkpointów, taskmastera i gate'ów — to trzyma mini małym.

---

## 5. Punkty integracji — serwer

| Plik | Zmiana |
|---|---|
| `server/services.ts` | montaż `miniOrchestratorRoutes` pod `/api/mini-orchestrator` (+ ewentualny `setQuotaSource`) |
| `websocket/services/chat-dispatch.service.ts:349` | nowa gałąź: `provider === MINI_ORCHESTRATOR_PROVIDER` → `miniOrchestratorRuntime.handleMessage` |
| `websocket/services/chat-websocket.service.ts:196` | uogólnić przez `isOrchestratorProvider` |
| `providers/services/sessions.service.ts` | `createAppSession` (wariant mini), `fetchHistory` (mapowanie wierszy transkryptu dla mini), `archive/delete/restore` (kaskada na dzieci) — uogólnić warunki |
| `shared/utils.ts` | `MINI_ORCHESTRATOR_PROVIDER`, `isOrchestratorProvider`, parametryzacja `createOrchestratorStatusFrame` |
| `shared/types.ts` | `MiniOrchestratorRole`, `MiniOrchestratorConfig` |
| `orchestrator/index.ts` | wyeksportować `createOrchestratorDelegationService` (i ewent. `classifyTaskType`, jeśli nie przeniesiony do shared) |

Bez nowej tabeli (reuse `orchestrator_messages`) → **bez migracji**.

---

## 6. Klient (Flutter)

**Nowy provider w listach „nowa sesja"** (dodać `'mini-orchestrator'`, nazwa np. `Auto (mini)`):
- `features/sessions/view/sessions_screen.dart:569/593/616`
- `features/workspace/view/session_picker.dart:157` (+ `:180`)
- `features/sessions/view/provider_logo.dart:20`
- `features/chat/view/chat_utilities.dart:461`
- `features/chat/view/session_subheader.dart:107`
- `features/workspace/view/pane_session_header.dart:101`
- `features/workspace/view/workspace_dialogs.dart:263` (`_isOrchestrator`)
- `features/workspace/state/split_workspace.dart:313`, `workspace_screen.dart:609`
- `features/mcp/data/mcp_constants.dart`, `features/skills/data/skills_constants.dart`

**Nowa sekcja ustawień** (wzór: `orchestration_config.dart` / `orchestration_section.dart`):
```
features/mini_orchestrator/
  data/mini_orchestrator_config.dart      # model danych + repo REST
  data/mini_orchestrator_repository.dart
  state/mini_orchestrator_config_controller.dart
  view/mini_orchestration_section.dart    # 2 sloty (thinker/worker) + tabela roles per typ
```
- Transkrypt: `features/orchestrator/view/orchestrator_cards.dart` renderuje bez zmian
  (przełącza po `context.orchestratorKind`).
- i18n: klucze dla wszystkich 12 locale + regeneracja `strings_*.g.dart` (slang).

---

## 7. Testy i wdrożenie

- **Unit (serwer)**: walidacja configu (dokładnie 2 role, `roles` wskazuje poprawne typy),
  wybór roli per typ zadania, parsowanie planu, parsowanie tras.
- **Checki**: `npm test`, `npm run typecheck`, `npx eslint <files>`, `flutter analyze`, `flutter test`.
- **Deploy**: `npm run build:server` → moduł nie dotyka `claude-runtime`/`devin-sessions`,
  więc patch-mirror (`/workspace/.ddagent-patch/`) **niepotrzebny** → restart `ddagent`
  **tylko za wyraźną zgodą**.
- **Commit**: conventional commit, bez pusha.

---

## 8. Fazy (checklista)

- [ ] **Faza 1 — shared**: `MINI_ORCHESTRATOR_PROVIDER`, `isOrchestratorProvider`,
      parametryzacja `createOrchestratorStatusFrame`, przeniesienie `classifyTaskType`,
      typy `MiniOrchestratorConfig`.
- [ ] **Faza 2 — moduł**: config service + walidacja + persist.
- [ ] **Faza 3 — silnik**: `mini-orchestrator.service.ts` (classify → plan → kroki → raport)
      + streaming przez delegację i ramki.
- [ ] **Faza 4 — integracja serwer**: module/routes, montaż, dispatch, sessions/history/lifecycle.
- [ ] **Faza 5 — testy serwera**.
- [ ] **Faza 6 — klient**: provider w listach + sekcja ustawień + i18n.
- [ ] **Faza 7 — checki i commit**.
