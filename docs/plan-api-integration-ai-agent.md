# Implementation Plan: API Integration — AI Agent & Playground

## Overview

Replace all mock/in-memory data with real backend API calls for two features — **AI Agent Management** and the **AI Chat Playground** — including SSE streaming for draft responses.

---

## Tech Stack

| Layer | Technology | Version |
|---|---|---|
| Framework | Flutter / Dart | SDK `>=3.7.0 <4.0.0` |
| State Management | MobX + flutter_mobx | `^2.6.0` / `^2.3.0` |
| Dependency Injection | get_it | `^9.2.1` |

---

## Architecture

The project follows **Clean Architecture** with strict layer dependencies:

```
Presentation  →  Domain  ←  Data
   (MobX stores)  (use cases,      (Dio API classes,
                   entities,        repository impls,
                   repo interfaces) request models)
```

```
lib/
├── domain/
│   ├── entity/ai_agent/          # AiAgent entity (extended in this plan)
│   ├── entity/playground/        # PlaygroundSession, PlaygroundMessage
│   ├── repository/ai_agent/      # AiAgentRepository (interface)
│   ├── repository/playground/    # PlaygroundRepository (interface, extended)
│   ├── usecase/ai_agent/         # 5 existing + 1 optional new use case
│   └── usecase/playground/       # 3 existing + 2 new use cases
├── data/
│   ├── network/
│   │   ├── apis/ai_agent/        # AiAgentApi (NEW)
│   │   ├── apis/playground/      # PlaygroundApi (NEW)
│   │   ├── models/request/       # 5 request DTOs (NEW)
│   │   └── constants/endpoints.dart  # Updated to real /api/v1/ paths
│   ├── repository/ai_agent/      # AiAgentRepositoryImpl (NEW, replaces mock)
│   ├── repository/playground/    # PlaygroundRepositoryImpl (MODIFIED)
│   ├── sharedpref/               # Add tenantId
│   └── di/module/                # DI wiring updates
└── presentation/
    └── playground/store/         # PlaygroundStore (MODIFIED, add draft observables)
```

---

## API Endpoints (Scoped to this Feature)

| Verb | Path | Purpose |
|---|---|---|
| `GET` | `/api/v1/ai-agents/tenants/{tenantId}` | Get active agent by tenant |
| `POST` | `/api/v1/ai-agents/tenants/{tenantId}` | Create agent |
| `PATCH` | `/api/v1/ai-agents/tenants/{tenantId}` | Update config by tenant |
| `PATCH` | `/api/v1/ai-agents/{aiAgentId}` | Update config by agent ID |
| `DELETE` | `/api/v1/ai-agents/{aiAgentId}` | Delete agent |
| `PATCH` | `/api/v1/ai-agents/{aiAgentId}/information` | Update profile (name / description / avatar) |
| `POST` | `/api/v1/ai-agents/{aiAgentId}/ask` | Playground Q&A (`AskQuestionDto`) |
| `POST` | `/api/v1/ai-agents/{aiAgentId}/chat-complete` | Playground chat completion (`ChatCompletionDto`) |
| `POST` | `/api/v1/ai-agents/{tenantId}/draft-response` | Draft response — non-streaming |
| `POST` | `/api/v1/ai-agents/{tenantId}/draft-response/stream` | Draft response — SSE streaming |

### Key DTOs

```
UpdateAiAgentDto     { toneOfAI?, language?, includeReference?, autoResponse?,
                       autoDraftResponse?, enableTemplate?, responseFormatGuide? }

AskQuestionDto       { question* , chatHistory? }

ChatCompletionDto    { prompt* , chatHistory* }

DraftResponseDto     { chatHistory*, channel*, type*, defaultConfigType*[],
                       tenantID*, ticketID*, chatRoomID*, customerID*,
                       channelProfileOverrides? }
```
`*` = required field

---

## Implementation Steps

### Phase 1 — Entity & SharedPrefs Extension

**Step 1** — Extend `AiAgent` entity (`lib/domain/entity/ai_agent/ai_agent.dart`):
- Add nullable API config fields: `toneOfAI?`, `language?`, `includeReference?`, `autoResponse?`, `autoDraftResponse?`, `enableTemplate?`
- Keep existing `AgentMode mode` for UI; implementation derives `autoResponse` from `mode` when missing
- Update `copyWith()` — re-run build_runner to regenerate `ai_agent.g.dart`

**Step 2** — Add `tenantId` to SharedPreferences:
- `lib/data/sharedpref/constants/preferences.dart` → add `static const String tenantId = 'tenantId'`
- `lib/data/sharedpref/shared_preference_helper.dart` → add `Future<String?> get tenantId` and `Future<bool> saveTenantId(String id)`

---

### Phase 2 — Update Endpoints

**Step 3** — Rewrite `lib/data/network/constants/endpoints.dart`:

| Method | Real Path |
|---|---|
| `agentsByTenant(tenantId)` | `/api/v1/ai-agents/tenants/{tenantId}` |
| `agentById(id)` | `/api/v1/ai-agents/{id}` |
| `agentInfo(id)` | `/api/v1/ai-agents/{id}/information` |
| `agentAsk(id)` | `/api/v1/ai-agents/{id}/ask` |
| `agentChatComplete(id)` | `/api/v1/ai-agents/{id}/chat-complete` |
| `agentDraftResponse(tenantId)` | `/api/v1/ai-agents/{tenantId}/draft-response` |
| `agentDraftResponseStream(tenantId)` | `/api/v1/ai-agents/{tenantId}/draft-response/stream` |

---

### Phase 3 — Request Models

**Step 4** — Create `lib/data/network/models/request/`:

| File | Maps to |
|---|---|
| `chat_message.dart` | Reusable `{ role, content }` history item |
| `update_ai_agent_request.dart` | `UpdateAiAgentDto` |
| `ask_question_request.dart` | `AskQuestionDto` |
| `chat_completion_request.dart` | `ChatCompletionDto` |
| `draft_response_request.dart` | `DraftResponseDto` (all required fields) |

---

### Phase 4 — Network API Classes

**Step 5** — Create `lib/data/network/apis/ai_agent/ai_agent_api.dart`:
- Inject `DioClient`
- `getAgentByTenant(tenantId)` → GET
- `createAgent(tenantId, dto)` → POST
- `updateAgentByTenant(tenantId, dto)` → PATCH
- `updateAgentById(agentId, dto)` → PATCH
- `deleteAgent(agentId)` → DELETE
- `updateAgentInfo(agentId, {name?, description?, avatar?})` → PATCH

**Step 6** — Create `lib/data/network/apis/playground/playground_api.dart`:
- Inject `DioClient`
- `askAgent(agentId, req)` → POST `/ask` — returns `Map<String, dynamic>`
- `chatComplete(agentId, req)` → POST `/chat-complete` — returns `Map<String, dynamic>`
- `getDraftResponse(tenantId, req)` → POST — returns `String`
- `streamDraftResponse(tenantId, req)` → POST with `ResponseType.stream`, parses SSE `data:` lines, returns `Stream<String>`

---

### Phase 5 — Repository Implementations

**Step 7** — Create `lib/data/repository/ai_agent/ai_agent_repository_impl.dart` *(replaces mock)*:
- Inject `AiAgentApi` + `SharedPreferenceHelper` (reads `tenantId` internally)
- `createAgent(agent)` → POST then PATCH `/information` (two sequential API calls)
- `updateAgent(agent)` → PATCH config + PATCH info
- Error handling: catch `DioException`, rethrow as domain `Exception`
- `MockAiAgentRepositoryImpl` and `AiAgentDataSource` are **kept but unregistered** from DI

**Step 8** — Modify `lib/data/repository/playground/playground_repository_impl.dart`:
- Also inject `PlaygroundApi`
- Session management (`getSessions`, `createSession`, `getSessionById`, `editMessage`) remain local
- `sendMessage()`: persist user message locally → call `PlaygroundApi.chatComplete()` for AI response
- Add `getDraftResponse()` and `streamDraftResponse()` delegating to `PlaygroundApi`

**Step 9** — Extend `lib/domain/repository/playground/playground_repository.dart` interface:
- Add `Future<String> getDraftResponse(String tenantId, DraftResponseParams params)`
- Add `Stream<String> streamDraftResponse(String tenantId, DraftResponseParams params)`

---

### Phase 6 — New Domain Use Cases

**Step 10** — `lib/domain/usecase/playground/get_draft_response_usecase.dart`  
Calls `PlaygroundRepository.getDraftResponse()`, params: `DraftResponseParams`

**Step 11** — `lib/domain/usecase/playground/stream_draft_response_usecase.dart`  
Calls `PlaygroundRepository.streamDraftResponse()`, returns `Stream<String>`

---

### Phase 7 — Store Updates

**Step 12** — Modify `lib/presentation/playground/store/playground_store.dart`:
- Inject `GetDraftResponseUseCase` and `StreamDraftResponseUseCase`
- Add observables:
  ```dart
  @observable String? draftResponse;
  @observable bool isDraftLoading = false;
  @observable bool isDraftStreaming = false;
  ```
- Add actions:
  - `fetchDraftResponse(DraftResponseParams)` — populates `draftResponse` from non-streaming endpoint
  - `startDraftStream(DraftResponseParams)` — listens to `Stream<String>`, appends chunks to `draftResponse`
- `sendMessage()` feeds real `chatComplete()` response into the existing char-by-char reveal timer *(UX preserved, source changed)*
- Re-run build_runner after changes

**Step 13** — `lib/presentation/ai_agent/store/ai_agent_store.dart`:  
No structural changes needed — the store interface maps directly to the new repository impl.

---

### Phase 8 — DI Wiring

**Step 14** — `lib/data/di/module/network_module.dart`:
- Register `AiAgentApi(getIt<DioClient>())` as singleton
- Register `PlaygroundApi(getIt<DioClient>())` as singleton

**Step 15** — `lib/data/di/module/repository_module.dart`:
- Swap `MockAiAgentRepositoryImpl` → `AiAgentRepositoryImpl(getIt<AiAgentApi>(), getIt<SharedPreferenceHelper>())`
- Update `PlaygroundRepositoryImpl` factory: inject `PlaygroundApi` in addition to `PlaygroundDataSource`

**Step 16** — `lib/domain/di/module/usecase_module.dart`:
- Register `GetDraftResponseUseCase` and `StreamDraftResponseUseCase`

**Step 17** — `lib/presentation/di/module/store_module.dart`:
- Update `PlaygroundStore` factory to inject two new use cases

---

### Phase 9 — Code Generation

**Step 18**:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

---

## File Change Summary

| File | Action |
|---|---|
| `lib/domain/entity/ai_agent/ai_agent.dart` | MODIFY — add API config fields |
| `lib/domain/repository/playground/playground_repository.dart` | MODIFY — add draft response methods |
| `lib/domain/usecase/playground/get_draft_response_usecase.dart` | NEW |
| `lib/domain/usecase/playground/stream_draft_response_usecase.dart` | NEW |
| `lib/data/network/constants/endpoints.dart` | MODIFY — real `/api/v1/` paths |
| `lib/data/sharedpref/constants/preferences.dart` | MODIFY — add tenantId key |
| `lib/data/sharedpref/shared_preference_helper.dart` | MODIFY — add tenantId getter/setter |
| `lib/data/network/models/request/chat_message.dart` | NEW |
| `lib/data/network/models/request/update_ai_agent_request.dart` | NEW |
| `lib/data/network/models/request/ask_question_request.dart` | NEW |
| `lib/data/network/models/request/chat_completion_request.dart` | NEW |
| `lib/data/network/models/request/draft_response_request.dart` | NEW |
| `lib/data/network/apis/ai_agent/ai_agent_api.dart` | NEW |
| `lib/data/network/apis/playground/playground_api.dart` | NEW |
| `lib/data/repository/ai_agent/ai_agent_repository_impl.dart` | NEW (replaces mock in DI) |
| `lib/data/repository/playground/playground_repository_impl.dart` | MODIFY — real AI response + draft |
| `lib/presentation/playground/store/playground_store.dart` | MODIFY — draft observables + new use cases |
| `lib/data/di/module/network_module.dart` | MODIFY — register API classes |
| `lib/data/di/module/repository_module.dart` | MODIFY — swap mock → real impl |
| `lib/domain/di/module/usecase_module.dart` | MODIFY — register new use cases |
| `lib/presentation/di/module/store_module.dart` | MODIFY — update PlaygroundStore factory |

**Untouched (kept for reference):**
- `lib/data/local/datasources/ai_agent/ai_agent_datasource.dart`
- `lib/data/repository/ai_agent/mock_ai_agent_repository_impl.dart`
- All 5 existing AI agent use cases
- `lib/presentation/ai_agent/store/ai_agent_store.dart`
- All AI agent and playground screens / widgets

---

## Verification Checklist

- [ ] `flutter analyze` — zero new errors
- [ ] `flutter packages pub run build_runner build` — builds cleanly, `ai_agent.g.dart` updated
- [ ] `flutter test` — existing widget tests pass
- [ ] Manual: Agent list screen loads real data from API
- [ ] Manual: Create → Edit → Delete agent — full round-trip with API confirmed
- [ ] Manual: Send message in Playground → real LLM response with char-by-char animation
- [ ] Manual: Open draft response panel → SSE chunks stream in progressively
- [ ] Manual: Toggle auto ↔ semi-auto mode → `autoResponse` field sent correctly in API call
