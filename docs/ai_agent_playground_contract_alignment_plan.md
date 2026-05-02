# AI Agent + Playground Contract Alignment Plan

Date: 2026-05-02
Status: Implemented (Verification Complete)

## Context
- Align app request/response contracts with latest AI Agent and Playground API docs.
- Keep backend host aligned with current backend docs and endpoint ownership.

## Host Decision
- Use `https://ai-service.jarvis.cx` for AI Agent/Playground base host in env.
- Keep `https://helpdesk-api.jarvis.cx` for `ssoValidate` only.

## Scope
1. Update env host for AI APIs.
2. Refactor AI Agent create flow:
- `POST /ai-agents/tenants/{tenantId}` without request body.
- Follow with config/info updates where needed.
3. Extend AI config contract fields:
- `organizationDescription`
- `responseFormatGuide`
4. Extend domain/entity mapping for new response fields:
- agent level: `websiteUrl`, `updatedAt`
- configs level: `organizationDescription`, `responseFormatGuide`
5. Remove hardcoded Playground draft tenant ID from UI flow.
6. Update tests and API testcase docs.

## File-Level Change Plan
- `lib/constants/env.dart`
- `lib/data/network/apis/ai_agent/ai_agent_api.dart`
- `lib/data/network/models/request/update_ai_agent_request.dart`
- `lib/domain/entity/ai_agent/ai_agent.dart`
- `lib/data/repository/ai_agent/ai_agent_repository_impl.dart`
- `lib/presentation/playground/playground_screen.dart`
- `test/data/repository/ai_agent/ai_agent_repository_impl_test.dart`
- `docs/ai_agent_playground_api_testcases.md`

## Verification
- Run: `flutter analyze`
- Run focused tests:
- `flutter test test/data/repository/ai_agent/ai_agent_repository_impl_test.dart`
- `flutter test test/data/repository/playground/playground_repository_impl_test.dart`

## Verification Result
- `flutter analyze`: passed (info-level warnings exist in unrelated files).
- `flutter test test/data/repository/ai_agent/ai_agent_repository_impl_test.dart`: passed.
- `flutter test test/data/repository/playground/playground_repository_impl_test.dart`: skipped (file does not exist in repo).

## Progress
- [x] Plan created
- [x] Env host updated
- [x] AI Agent create flow updated
- [x] Config/entity fields updated
- [x] Playground hardcoded tenant removed
- [x] Tests/docs updated
- [x] Analyze/tests passing
