# AI Agent & Playground API Test Cases (App Flow)

## Test Scope
- Module: AI Agents + Playground
- App flow: current screens in app (Agent List, Agent Create/Edit, Agent Detail, Team Assistant, Playground)
- API reference source: AI-Helpdesk-API-docs.txt
- TenantId for API testing: aca752db-91a4-4f6a-ac48-3c28989bdbd5

## Global Preconditions
1. Login successfully.
2. Ensure access token is valid (unless case is 401/403).
3. Ensure test tenant is active: aca752db-91a4-4f6a-ac48-3c28989bdbd5.
4. Build app in debug to observe logs:
   - [AiAgentApi] ... called
   - [PlaygroundApi] ... called
5. Clear stale app data before each suite when needed.

## Endpoint Coverage Map (Current App)
- GET /api/v1/ai-agents/tenants/{tenantId}: Covered by opening AI Agent list.
- POST /api/v1/ai-agents/tenants/{tenantId}: Covered by creating agent.
- PATCH /api/v1/ai-agents/{aiAgentId}: Covered by editing agent config.
- PATCH /api/v1/ai-agents/{aiAgentId}/information: Covered by create/edit profile data.
- DELETE /api/v1/ai-agents/{aiAgentId}: Covered by delete agent.
- POST /api/v1/ai-agents/{aiAgentId}/chat-complete: Covered by sending message in Playground (with selected agent).
- POST /api/v1/ai-agents/{tenantId}/draft-response: Covered after sending message in Playground.
- POST /api/v1/ai-agents/{tenantId}/draft-response/stream: Repository/use case available; no direct UI trigger in current screen.
- POST /api/v1/ai-agents/{aiAgentId}/ask: API class exists; no direct UI trigger in current screen.

## A. AI Agent Management Test Cases

### A1. Get active agent by tenant
| ID | App Steps | Expected API | Expected Result |
|---|---|---|---|
| AA-GET-01 | Open AI Agents screen | GET /ai-agents/tenants/{tenantId} | 200, list renders correctly |
| AA-GET-02 | Open AI Agents with tenant has no active agent | GET | 200 with empty payload, show empty state |
| AA-GET-03 | Remove tenant from storage, open AI Agents | GET not sent or sent invalid | UI shows error state, no crash |
| AA-GET-04 | Force expired token, open AI Agents | GET | 401 handled, user sees error/reauth flow |
| AA-GET-05 | Disable network, open AI Agents | GET fails | UI shows retry option |
| AA-GET-06 | Slow network (>10s) | GET delayed | Loading remains stable, no duplicate calls |

### A2. Create AI agent
| ID | App Steps | Expected API | Expected Result |
|---|---|---|---|
| AA-CRE-01 | Tap Create, fill valid fields, Save | POST /tenants/{tenantId} then PATCH /{id}/information | Agent created and appears in list |
| AA-CRE-02 | Create with name empty | No API | Client validation error shown |
| AA-CRE-03 | Create with max-length name/description | POST + PATCH | Success or server validation message |
| AA-CRE-04 | Create with unsupported payload values | POST | 400 handled and shown |
| AA-CRE-05 | Create when tenant invalid | POST | 404/400 shown |
| AA-CRE-06 | Create succeeds but info update fails | POST success, PATCH fail | Error shown, app stable, no crash |
| AA-CRE-07 | Double tap Save quickly | POST/PATCH | No duplicate inconsistent records |

### A3. Update AI agent
| ID | App Steps | Expected API | Expected Result |
|---|---|---|---|
| AA-UPD-01 | Open agent detail, edit valid fields, Save | PATCH /{id} and PATCH /{id}/information | Updated values shown in detail/list |
| AA-UPD-02 | Update with no changed fields | PATCH may still send | No regression, data unchanged |
| AA-UPD-03 | Update with invalid agent id | PATCH | 404 shown |
| AA-UPD-04 | Update with expired token | PATCH | 401 handled |
| AA-UPD-05 | Update under network loss | PATCH fails | Error shown, local UI not corrupted |

### A4. Delete AI agent
| ID | App Steps | Expected API | Expected Result |
|---|---|---|---|
| AA-DEL-01 | Open detail, Delete, Confirm | DELETE /{id} | Agent removed, back to list |
| AA-DEL-02 | Delete then Cancel in dialog | No API | Nothing deleted |
| AA-DEL-03 | Delete already removed agent | DELETE | 404 handled gracefully |
| AA-DEL-04 | Delete with insufficient permission | DELETE | 403 shown |
| AA-DEL-05 | Delete offline | DELETE fails | Error shown |

## B. Playground Chat + Draft Response Test Cases

### B1. Session and chat-complete
| ID | App Steps | Expected API | Expected Result |
|---|---|---|---|
| PG-CHAT-01 | Open Playground from Agent Detail, create session, send message | POST /{aiAgentId}/chat-complete | AI response appears in conversation |
| PG-CHAT-02 | Send message with attachments | POST chat-complete | Message and attachment chips render, response received |
| PG-CHAT-03 | Send very long prompt | POST chat-complete | No crash, response rendered |
| PG-CHAT-04 | Create session without agent then send | chat-complete may fail by design | Error shown, app remains usable |
| PG-CHAT-05 | chat-complete returns empty content | POST | Placeholder handling stable, no crash |
| PG-CHAT-06 | chat-complete returns markdown | POST | Markdown rendered correctly |
| PG-CHAT-07 | chat-complete 401 | POST | Error handling path works |
| PG-CHAT-08 | chat-complete 429 | POST | Rate-limit message/log visible |
| PG-CHAT-09 | chat-complete timeout | POST timeout | Error shown, retry possible |

### B2. Non-stream draft-response (must be called after send)
| ID | App Steps | Expected API | Expected Result |
|---|---|---|---|
| PG-DR-01 | Send message in Playground | POST /{tenantId}/draft-response | [PlaygroundApi] getDraftResponse called appears in console |
| PG-DR-02 | Verify request tenant | POST /draft-response | tenantId = aca752db-91a4-4f6a-ac48-3c28989bdbd5 |
| PG-DR-03 | Valid payload, normal response | POST | Draft panel appears with suggested text |
| PG-DR-04 | API returns empty string | POST | Draft panel hidden |
| PG-DR-05 | API returns message/content instead of text | POST | Extracted text still shown |
| PG-DR-06 | Missing required fields simulation | POST 400 | Error handled and app stable |
| PG-DR-07 | Invalid tenantId | POST 404/400 | Error handled and app stable |
| PG-DR-08 | Unauthorized token | POST 401 | Error path shown |
| PG-DR-09 | Server error 500 | POST 500 | Error path shown |
| PG-DR-10 | Network offline | POST fail | Error path shown |

### B3. Stream draft-response (SSE)
| ID | App Steps | Expected API | Expected Result |
|---|---|---|---|
| PG-STR-01 | Trigger stream draft mode (dev/feature toggle) | POST /draft-response/stream | [PlaygroundApi] streamDraftResponse called |
| PG-STR-02 | Server streams multiple chunks | SSE | Chunks appended in order |
| PG-STR-03 | Stream ends with [DONE] | SSE | Stream closed gracefully |
| PG-STR-04 | Stream sends malformed JSON line | SSE | Fallback raw text handling works |
| PG-STR-05 | Stream disconnect mid-way | SSE error | UI exits streaming state safely |

### B4. Ask endpoint (not wired to current UI)
| ID | App Steps | Expected API | Expected Result |
|---|---|---|---|
| PG-ASK-01 | Use dev action to test Ask | POST /{aiAgentId}/ask | Response returns and displays |
| PG-ASK-02 | Ask with invalid aiAgentId | POST | 404 handled |
| PG-ASK-03 | Ask with expired token | POST | 401 handled |
| PG-ASK-04 | Ask with large chatHistory | POST | No app crash, response/error handled |

## C. Cross-Cutting Cases
| ID | Scenario | Expected Result |
|---|---|---|
| CC-01 | Switch app language and repeat core flow | All new i18n labels render correctly |
| CC-02 | App restart and reopen modules | Behavior consistent, no stale crash |
| CC-03 | Rapid navigation between Agent and Playground | No duplicated API side effects |
| CC-04 | Background/resume during in-flight request | State remains recoverable |
| CC-05 | Error then retry | Retry path succeeds when backend recovers |

## Suggested Execution Order
1. Smoke: AA-GET-01, AA-CRE-01, AA-UPD-01, AA-DEL-01, PG-CHAT-01, PG-DR-01.
2. Auth/network failures.
3. Validation/edge payloads.
4. SSE and ask endpoint (dev flow).

## Pass Criteria
- All smoke cases pass.
- No crash or frozen UI in any negative case.
- Expected endpoint is hit with correct identifiers.
- For draft-response tests, tenantId used is exactly: aca752db-91a4-4f6a-ac48-3c28989bdbd5.
