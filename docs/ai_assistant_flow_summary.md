# Tong hop kien truc va flow AI Assistant

## 1. Kien truc tong quan

App di theo mo hinh nhieu tang:

```text
UI
 -> Store
 -> UseCase
 -> Repository
 -> API
 -> Backend
```

Y nghia tung tang:

```text
UI:
- Hien thi man hinh.
- Nhan thao tac nguoi dung.
- Goi action trong Store.
- Render lai theo state observable.

Store:
- Quan ly state cho UI.
- Chua loading, error, selected item, list data.
- Goi UseCase, khong goi API truc tiep.

UseCase:
- Dai dien cho nghiep vu.
- La boundary giua presentation va domain/data.
- Co the validate input hoac dieu phoi rule nghiep vu.

Repository:
- Xu ly du lieu that.
- Lay token, tenantId tu local storage.
- Goi API.
- Bat loi.
- Normalize response.
- Map JSON/DTO thanh entity domain.

API:
- Chi phu trach HTTP.
- Biet endpoint, method, body, header.
- Tra raw data hoac payload da boc lop data.

Backend:
- Thuc thi nghiep vu that.
- Tra response cho mobile.
```

## 2. GetIt va DI

`GetIt` la service locator dung de noi cac tang lai voi nhau. App dang ky dependency theo thu tu:

```text
NetworkModule
 -> dang ky DioClient, API

RepositoryModule
 -> dang ky Repository implementation

UseCaseModule
 -> dang ky UseCase

StoreModule
 -> dang ky Store
```

Vi du AI Agent:

```text
AiAgentStore
 -> GetAgentsUseCase
 -> AiAgentRepository
 -> AiAgentRepositoryImpl
 -> AiAgentApi
 -> DioClient aiService
 -> /api/v1/ai-agents/tenants/{tenantId}
```

Loi ich:

```text
- UI khong can biet API.
- Repository khong phu thuoc UI.
- De thay mock/real implementation khi test.
- Tranh lap code khoi tao dependency o nhieu noi.
```

## 3. Vi du flow Agent List

Khi mo man hinh AI Agents:

```text
AgentListScreen.initState()
 -> getIt<AiAgentStore>()
 -> _store.fetchAgents()
 -> GetAgentsUseCase.call()
 -> AiAgentRepositoryImpl.getAgents()
 -> AiAgentApi.getAgentByTenant(tenantId)
 -> GET /api/v1/ai-agents/tenants/{tenantId}
 -> _extractPayloadMap()
 -> Repository _fromJson()
 -> Store cap nhat agents
 -> Observer rebuild ListView
```

Diem quan trong: backend tra agent theo tenant, con UI render dang list. Repository xu ly chenh lech nay bang cach boc agent thanh `List<AiAgent>`.

## 4. Vi du flow Playground Ask Agent

Khi user gui cau hoi trong Playground:

```text
PlaygroundScreen._onSend()
 -> upload attachment neu co
 -> PlaygroundStore.sendMessage()
 -> optimistic add user message vao UI
 -> SendPlaygroundMessageUseCase
 -> PlaygroundRepositoryImpl.sendMessage()
 -> lay session local
 -> lay tenantId
 -> lay activeAgentId qua AiAgentApi
 -> POST /api/v1/ai-agents/{agentId}/ask
 -> nhan response text
 -> luu user + assistant message vao PlaygroundDataSource
 -> Store render assistant message kieu streaming gia lap
```

Backend tra full response mot lan. Mobile tu tao hieu ung typing/streaming bang `Timer`.

## 5. Flow AI Assistant

AI Assistant la global assistant, xuat hien tren toan app bang floating button trong `MainScreen`.

UI flow:

```text
MainScreen
 -> AssistantFab
 -> AiAssistantStore.toggleChat()
 -> ChatBubbleSheet mo bubble chat
```

Khi user gui message:

```text
ChatBubbleSheet._handleSubmit()
 -> AiAssistantStore.sendMessage(text)
```

Trong Store:

```text
1. Trim message.
2. Neu rong hoac dang loading thi bo qua.
3. Add user message vao ObservableList.
4. Goi SendMessageUseCase voi toan bo history hien tai.
5. Nhan AgentResponse.
6. Add assistant/system message vao list.
7. Observer rebuild chat bubble.
```

Flow day du tu UI xuong backend:

```text
ChatBubbleSheet
 -> AiAssistantStore
 -> SendMessageUseCase
 -> AiAssistantRepositoryImpl
 -> AiAssistantApi
 -> POST /agent/chat
 -> agent_service FastAPI
 -> run_agent()
 -> route intent/domain
 -> resolve context
 -> chon tool
 -> validate args
 -> execute tool hoac yeu cau confirmation
 -> tra AgentResponse
 -> mobile render message/result
```

O Repository:

```text
AiAssistantRepositoryImpl.sendMessages()
 -> lay authToken tu SharedPreferenceHelper
 -> lay tenantId tu SharedPreferenceHelper
 -> convert ChatMessage entity thanh JSON
 -> goi AiAssistantApi.sendMessages()
```

Request gui backend:

```json
{
  "messages": [
    {
      "role": "user",
      "content": "tao ticket title: loi dang nhap description: khach khong dang nhap duoc priority: high"
    }
  ]
}
```

Header:

```text
Authorization: Bearer {token}
X-Tenant-Id: {tenantId}
```

API endpoint:

```text
POST /agent/chat
```

Endpoint nay di toi local FastAPI service trong `agent_service/main.py`.

## 6. Backend AI Assistant xu ly nhu the nao

Backend flow:

```text
1. Validate Bearer token.
2. Nhan danh sach messages.
3. Goi run_agent(messages, token, tenant_id).
4. Kiem tra user co dang xac nhan/huy thao tac pending khong.
5. Lay latest user message.
6. route_user_text() de xac dinh domain va intent.
7. resolve_context() de lay them tenantId/entity id neu can.
8. Neu thieu thong tin thi hoi lai user.
9. Neu du thong tin thi chon tool tu registry.
10. Validate arguments theo schema.
11. Neu tool critical_write thi tra confirmation.
12. Neu khong can confirmation thi execute_tool().
13. Tra response chuan ve mobile.
```

Response chuan co dang:

```json
{
  "source": "system",
  "type": "action_result",
  "text": "Minh da tao ticket ... thanh cong roi nhe.",
  "domain": "ticket_management",
  "tool_name": "create_ticket",
  "intent_type": "create",
  "confidence": 0.95,
  "payload": {
    "id": "...",
    "status": "...",
    "title": "..."
  }
}
```

Mobile map response nay vao `AgentResponse`, sau do add vao `messages`:

```text
type = message
 -> hien thi nhu tin nhan thuong

type = action_result
 -> hien thi ket qua thao tac

type = confirmation
 -> hien thi yeu cau xac nhan, co confirm token

missing_fields != null
 -> assistant hoi user bo sung field con thieu
```

## 7. Diem nhan khi trinh bay AI Assistant

```text
Playground la noi test agent theo mot agent cu the.

AI Assistant la orchestration assistant toan app:
- Hieu ngon ngu tu nhien.
- Phan loai domain.
- Chon tool/API phu hop.
- Validate du lieu.
- Goi API nghiep vu.
- Tra ket qua lai chat UI.
```

Hien backend assistant ho tro registry cho nhieu domain, nhung tool goi API that ro nhat la `create_ticket`; cac tool khac phan lon dang o muc simulated/contract.
