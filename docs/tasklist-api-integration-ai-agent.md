# Tasklist: API Integration — AI Agent & Playground

> Plan: [`docs/plan-api-integration-ai-agent.md`](./plan-api-integration-ai-agent.md)  
> Branch: `feature/12-ai-agent-system-sub-issue-A-api-integration`

Trong cùng một wave → tất cả task làm **song song**. Wave sau phụ thuộc wave trước.

---

## Wave 1 — Foundation *(tất cả độc lập)*

> Status: ✅ Done

- [x] **T1** — Extend `AiAgent` entity với fields: `toneOfAI?`, `language?`, `includeReference?`, `autoResponse?`, `autoDraftResponse?`, `enableTemplate?`  
  `lib/domain/entity/ai_agent/ai_agent.dart`

- [x] **T2** — Thêm `tenantId` vào SharedPreferences  
  `lib/data/sharedpref/constants/preferences.dart`  
  `lib/data/sharedpref/shared_preference_helper.dart`

- [x] **T3** — Cập nhật `endpoints.dart` sang paths `/api/v1/` thực  
  `lib/data/network/constants/endpoints.dart`

- [x] **T4a** — Tạo `chat_message.dart` (reusable history item)  
  `lib/data/network/models/request/chat_message.dart`

- [x] **T4b** — Tạo `update_ai_agent_request.dart`  
  `lib/data/network/models/request/update_ai_agent_request.dart`

- [x] **T4c** — Tạo `ask_question_request.dart`  
  `lib/data/network/models/request/ask_question_request.dart`

- [x] **T4d** — Tạo `chat_completion_request.dart`  
  `lib/data/network/models/request/chat_completion_request.dart`

- [x] **T4e** — Tạo `draft_response_request.dart`  
  `lib/data/network/models/request/draft_response_request.dart`

---

## Wave 2 — Network API classes + Domain interface *(sau Wave 1)*

> Status: ✅ Done

- [x] **T5** — Tạo `AiAgentApi` (6 methods: getByTenant, create, updateByTenant, updateById, delete, updateInfo)  
  `lib/data/network/apis/ai_agent/ai_agent_api.dart`

- [x] **T6** — Tạo `PlaygroundApi` (askAgent, chatComplete, getDraftResponse, streamDraftResponse SSE)  
  `lib/data/network/apis/playground/playground_api.dart`

- [x] **T9** — Extend `PlaygroundRepository` interface + 2 draft response methods  
  `lib/domain/repository/playground/playground_repository.dart`

---

## Wave 3 — Repository impls + Use cases *(sau Wave 2)*

> Status: ✅ Done

- [x] **T7** — Tạo `AiAgentRepositoryImpl` (inject `AiAgentApi` + `SharedPreferenceHelper`)  
  `lib/data/repository/ai_agent/ai_agent_repository_impl.dart`

- [x] **T8** — Cập nhật `PlaygroundRepositoryImpl` (inject `PlaygroundApi`, thay `sendMessage()`, thêm draft methods)  
  `lib/data/repository/playground/playground_repository_impl.dart`

- [x] **T10** — Tạo `GetDraftResponseUseCase`  
  `lib/domain/usecase/playground/get_draft_response_usecase.dart`

- [x] **T11** — Tạo `StreamDraftResponseUseCase`  
  `lib/domain/usecase/playground/stream_draft_response_usecase.dart`

---

## Wave 4 — Store update *(sau T10, T11)*

> Status: ✅ Done

- [x] **T12** — Cập nhật `PlaygroundStore`: inject 2 use case mới, thêm observables `draftResponse / isDraftLoading / isDraftStreaming`, thêm actions `fetchDraftResponse` + `startDraftStream`  
  `lib/presentation/playground/store/playground_store.dart`

---

## Wave 5 — DI Wiring *(sau Wave 3 + Wave 4, tất cả song song)*

> Status: ✅ Done

- [x] **T14** — Đăng ký `AiAgentApi` + `PlaygroundApi`  
  `lib/data/di/module/network_module.dart`

- [x] **T15** — Swap mock → `AiAgentRepositoryImpl`; cập nhật `PlaygroundRepositoryImpl` factory  
  `lib/data/di/module/repository_module.dart`

- [x] **T16** — Đăng ký `GetDraftResponseUseCase` + `StreamDraftResponseUseCase`  
  `lib/domain/di/module/usecase_module.dart`

- [x] **T17** — Cập nhật `PlaygroundStore` factory với 2 use case mới  
  `lib/presentation/di/module/store_module.dart`

---

## Wave 6 — Build & Verify *(sau tất cả)*

> Status: 🔶 In Progress — automated done, manual pending

- [x] **T18** — `flutter packages pub run build_runner build --delete-conflicting-outputs` → 72 outputs generated
- [x] **V1** — `flutter analyze` không có lỗi mới → 0 errors, 0 warnings
- [x] **V2** — `flutter test` pass → 8/8 unit tests pass
- [ ] **V3** — Manual: Agent list load từ real API
- [ ] **V4** — Manual: Create → Edit → Delete agent round-trip API
- [ ] **V5** — Manual: Playground gửi tin → LLM response thực với char-by-char animation
- [ ] **V6** — Manual: Draft response panel stream SSE chunks
- [ ] **V7** — Manual: Toggle auto ↔ semi-auto → `autoResponse` gửi đúng lên API

---

## Dependency Graph

```
Wave 1:  T1  T2  T3  T4a T4b T4c T4d T4e   ← all parallel
                  ↓
Wave 2:          T5   T6   T9              ← all parallel
                  ↓    ↓    ↓
Wave 3:          T7   T8  T10  T11         ← all parallel
                              ↓
Wave 4:                      T12
                  ↓    ↓    ↓    ↓
Wave 5:         T14  T15  T16  T17         ← all parallel
                  ↓
Wave 6:         T18  V1..V7
```
