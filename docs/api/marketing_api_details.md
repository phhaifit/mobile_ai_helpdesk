# Marketing API - Chi tiet endpoint

Tai lieu nay tong hop chi tiet cac API trong folder Marketing tren Apidog, bao gom: method, URL, input, response thanh cong, va loi.

## 1) Thong tin chung

- Nhom API: [IN PROGRESS] Helpdesk API/Marketing
- Prefix endpoint: /api/v1/marketing
- Auth: Bearer JWT (Authorization: Bearer <access_token>)
- Cac endpoint list co the dung phan trang voi offset, limit

Ghi chu ve URL:

- URL thatuc te khi goi API: https://<backend-host>/api/v1/marketing/...
- URL tai lieu Apidog duoc liet ke tai moi endpoint ben duoi.

## 2) Error response chung

Tat ca API loi tu BE follow dang chung:

```json
{
  "status": "FORBIDDEN",
  "message": "Forbidden: Insufficient privileges",
  "code": "SUBSCRIPTION_REQUIRED",
  "details": {},
  "timestamp": "2026-04-21T00:00:00.000Z"
}
```

Y nghia cac field:

- status: ma trang thai theo enum he thong (VD: INVALID_INPUT, UNAUTHORIZED, FORBIDDEN, NOT_FOUND...)
- message: thong diep loi
- code: ma loi may-doc, chi xuat hien trong mot so truong hop (VD: SUBSCRIPTION_REQUIRED)
- details: chi tiet bo sung (neu co)
- timestamp: thoi diem phat sinh loi (neu co)

## 3) Danh sach nhanh cac API Marketing

**Ghi chu:** Danh sach duoi day (17 endpoint) la cac endpoint co tai lieu chi tiet tren Apidog. Them 7 endpoint khac (Phase D + Phase G, chua co trong Apidog) xem section 5.

| #   | API                                | Method | URL path                                           |
| --- | ---------------------------------- | ------ | -------------------------------------------------- |
| 1   | Get marketing templates            | GET    | /api/v1/marketing/templates                        |
| 2   | Create marketing template          | POST   | /api/v1/marketing/templates                        |
| 3   | Get template details               | GET    | /api/v1/marketing/templates/{templateID}           |
| 4   | Update template                    | PUT    | /api/v1/marketing/templates/{templateID}           |
| 5   | Delete template                    | DELETE | /api/v1/marketing/templates/{templateID}           |
| 6   | Get broadcast list                 | GET    | /api/v1/marketing/broadcasts                       |
| 7   | Create broadcast                   | POST   | /api/v1/marketing/broadcasts                       |
| 8   | Get broadcast details              | GET    | /api/v1/marketing/broadcasts/{broadcastID}         |
| 9   | Update broadcast                   | PUT    | /api/v1/marketing/broadcasts/{broadcastID}         |
| 10  | Delete broadcast                   | DELETE | /api/v1/marketing/broadcasts/{broadcastID}         |
| 11  | Get recipients for broadcast       | POST   | /api/v1/marketing/broadcasts/recipients            |
| 12  | Execute (start) broadcast          | POST   | /api/v1/marketing/broadcasts/{broadcastID}/execute |
| 13  | Stop broadcast                     | POST   | /api/v1/marketing/broadcasts/{broadcastID}/stop    |
| 14  | Resume broadcast                   | POST   | /api/v1/marketing/broadcasts/{broadcastID}/resume  |
| 15  | Fetch admin accounts from Facebook | GET    | /api/v1/marketing/ad-accounts/fetch                |
| 16  | Create admin (ad) account          | POST   | /api/v1/marketing/ad-accounts                      |
| 17  | Get admin (ad) account list        | GET    | /api/v1/marketing/ad-accounts                      |

## 4) Chi tiet tung API

### 4.1 Get marketing templates

- Method: GET
- URL: /api/v1/marketing/templates
- Query params:
  - offset (integer, mac dinh 0)
  - limit (integer, mac dinh 20)
  - search (string, optional)
- Success response:
  - HTTP 200
  - Mo ta: Template list
- Apidog doc:
  - https://033thw3m9z.apidog.io/get-marketing-templates-32922584e0.md

### 4.2 Create marketing template

- Method: POST
- URL: /api/v1/marketing/templates
- Request body (application/json):
  - name (string, required)
  - content (string, required)
  - channelType (string, required)
- Success response:
  - HTTP 201
  - Mo ta: Template created
- Apidog doc:
  - https://033thw3m9z.apidog.io/create-marketing-template-32922585e0.md

### 4.3 Get template details

- Method: GET
- URL: /api/v1/marketing/templates/{templateID}
- Path params:
  - templateID (string, required)
- Success response:
  - HTTP 200
  - Mo ta: Template detail
- Apidog doc:
  - https://033thw3m9z.apidog.io/get-template-details-32922586e0.md

### 4.4 Update template

- Method: PUT
- URL: /api/v1/marketing/templates/{templateID}
- Path params:
  - templateID (string, required)
- Request body (application/json):
  - name (string, optional)
  - content (string, optional)
- Success response:
  - HTTP 200
  - Mo ta: Template updated
- Apidog doc:
  - https://033thw3m9z.apidog.io/update-template-32922587e0.md

### 4.5 Delete template

- Method: DELETE
- URL: /api/v1/marketing/templates/{templateID}
- Path params:
  - templateID (string, required)
- Success response:
  - HTTP 200
  - Mo ta: Template deleted
- Apidog doc:
  - https://033thw3m9z.apidog.io/delete-template-32922588e0.md

### 4.6 Get broadcast list

- Method: GET
- URL: /api/v1/marketing/broadcasts
- Query params:
  - offset (integer, mac dinh 0)
  - limit (integer, mac dinh 20)
- Success response:
  - HTTP 200
  - Mo ta: Broadcast list
- Apidog doc:
  - https://033thw3m9z.apidog.io/get-broadcast-list-32922589e0.md

### 4.7 Create broadcast

- Method: POST
- URL: /api/v1/marketing/broadcasts
- Request body (application/json):
  - name (string, required)
  - templateId (string, required)
  - scheduledAt (string, date-time, optional)
- Success response:
  - HTTP 201
  - Mo ta: Broadcast created
- Apidog doc:
  - https://033thw3m9z.apidog.io/create-broadcast-32922590e0.md

### 4.8 Get broadcast details

- Method: GET
- URL: /api/v1/marketing/broadcasts/{broadcastID}
- Path params:
  - broadcastID (string, required)
- Success response:
  - HTTP 200
  - Mo ta: Broadcast detail
- Apidog doc:
  - https://033thw3m9z.apidog.io/get-broadcast-details-32922591e0.md

### 4.9 Update broadcast

- Method: PUT
- URL: /api/v1/marketing/broadcasts/{broadcastID}
- Path params:
  - broadcastID (string, required)
- Request body (application/json):
  - name (string, optional)
  - templateId (string, optional)
- Success response:
  - HTTP 200
  - Mo ta: Broadcast updated
- Apidog doc:
  - https://033thw3m9z.apidog.io/update-broadcast-32922592e0.md

### 4.10 Delete broadcast

- Method: DELETE
- URL: /api/v1/marketing/broadcasts/{broadcastID}
- Path params:
  - broadcastID (string, required)
- Success response:
  - HTTP 200
  - Mo ta: Broadcast deleted
- Apidog doc:
  - https://033thw3m9z.apidog.io/delete-broadcast-32922593e0.md

### 4.11 Get recipients for broadcast

- Method: POST
- URL: /api/v1/marketing/broadcasts/recipients
- Request body (application/json):
  - broadcastId (string, optional)
  - filters (object, optional)
- Success response:
  - HTTP 200
  - Mo ta: Recipient list
- Apidog doc:
  - https://033thw3m9z.apidog.io/get-recipients-for-broadcast-32922594e0.md

### 4.12 Execute (start) broadcast

- Method: POST
- URL: /api/v1/marketing/broadcasts/{broadcastID}/execute
- Path params:
  - broadcastID (string, required)
- Success response:
  - HTTP 200
  - Mo ta: Broadcast started
- Apidog doc:
  - https://033thw3m9z.apidog.io/execute-start-broadcast-32922595e0.md

### 4.13 Stop broadcast

- Method: POST
- URL: /api/v1/marketing/broadcasts/{broadcastID}/stop
- Path params:
  - broadcastID (string, required)
- Success response:
  - HTTP 200
  - Mo ta: Broadcast stopped
- Apidog doc:
  - https://033thw3m9z.apidog.io/stop-broadcast-32922596e0.md

### 4.14 Resume broadcast

- Method: POST
- URL: /api/v1/marketing/broadcasts/{broadcastID}/resume
- Path params:
  - broadcastID (string, required)
- Success response:
  - HTTP 200
  - Mo ta: Broadcast resumed
- Apidog doc:
  - https://033thw3m9z.apidog.io/resume-broadcast-32922597e0.md

### 4.15 Fetch admin accounts from Facebook

- Method: GET
- URL: /api/v1/marketing/ad-accounts/fetch
- Success response:
  - HTTP 200
  - Mo ta: Ad account list from Facebook
- Apidog doc:
  - https://033thw3m9z.apidog.io/fetch-admin-accounts-from-facebook-32922598e0.md

### 4.16 Create admin (ad) account

- Method: POST
- URL: /api/v1/marketing/ad-accounts
- Request body (application/json):
  - accountId (string, required)
  - name (string, required)
- Success response:
  - HTTP 201
  - Mo ta: Ad account created
- Apidog doc:
  - https://033thw3m9z.apidog.io/create-admin-ad-account-32922599e0.md

### 4.17 Get admin (ad) account list

- Method: GET
- URL: /api/v1/marketing/ad-accounts
- Success response:
  - HTTP 200
  - Mo ta: Ad account list
- Apidog doc:
  - https://033thw3m9z.apidog.io/get-admin-ad-account-list-32922600e0.md

## 5) Additional endpoints (Chuyen cho Phase D + Phase G, chua co trong Apidog)

Cac endpoint duoi day da duoc trien khai trong code va dang duoc goi thuc toi, nhung chua duoc tai lieu hoa chi tiet trong section 4. Chung ho tro cac yeu cau tu issue_52_marketing_broadcasting va plan (Phase D - Realtime infrastructure, Phase G - Facebook admin connectivity hardening).

### 5.1 Danh sach nhanh cac endpoint them

| #   | API                                    | Method | URL path                                                          | Phase | Requirement                         |
| --- | -------------------------------------- | ------ | ----------------------------------------------------------------- | ----- | ----------------------------------- |
| 18  | Get broadcast delivery receipts        | GET    | /api/v1/marketing/broadcasts/{broadcastID}/receipts               | D     | Handle delivery status and receipts |
| 19  | Get broadcast status timeline          | GET    | /api/v1/marketing/broadcasts/{broadcastID}/status-timeline        | D     | Track campaign status real-time     |
| 20  | Subscribe broadcast status (WebSocket) | WS     | /ws/v1/marketing/broadcasts/{broadcastID}/status                  | D     | Real-time campaign status updates   |
| 21  | Disconnect Facebook admin account      | POST   | /api/v1/marketing/facebook-admin/accounts/{accountID}/disconnect  | G     | Facebook admin account management   |
| 22  | Re-authenticate Facebook admin account | POST   | /api/v1/marketing/facebook-admin/accounts/{accountID}/reauth      | G     | Facebook token refresh              |
| 23  | Get Facebook admin pages               | GET    | /api/v1/marketing/facebook-admin/accounts/{accountID}/pages       | G     | Page listing for admin account      |
| 24  | Select Facebook admin page             | POST   | /api/v1/marketing/facebook-admin/accounts/{accountID}/select-page | G     | Bind page to admin account          |

### 5.2 Chi tiet tung endpoint them

#### 5.2.1 Get broadcast delivery receipts

**Requirement:**

- [issue_52_marketing_broadcasting.md](../issue/issue_52_marketing_broadcasting.md) - "Handle broadcast delivery status and delivery receipts from API"
- [issue_52_marketing_broadcasting_plan.md](../plan/issue_52_marketing_broadcasting_plan.md) Phase D, Phase I

**Details:**

- Method: GET
- URL: /api/v1/marketing/broadcasts/{broadcastID}/receipts
- Query params:
  - offset (integer, mac dinh 0)
  - limit (integer, mac dinh 20)
- Success response:
  - HTTP 200
  - Mo ta: Paginated list of delivery receipts (sent, delivered, failed) for broadcast
- Response schema:
  - items (array): List of receipt objects
    - id (string): Receipt ID
    - broadcastId (string): Broadcast ID
    - recipientId (string): Recipient ID
    - status (string): "sent", "delivered", "failed"
    - channelMessageId (string, nullable): Message ID from delivery channel
    - errorCode (string, nullable): Error code if failed
    - errorMessage (string, nullable): Error description
    - createdAt (datetime): When receipt was recorded
  - total (integer): Total receipt count
  - offset (integer): Pagination offset
  - limit (integer): Pagination limit

**Implementation status:**

- Implemented in: [lib/data/network/apis/marketing/marketing_broadcast_api.dart#L172-L181](../../lib/data/network/apis/marketing/marketing_broadcast_api.dart#L172-L181)
- Called by: [lib/data/repository/marketing/marketing_broadcast_repository_impl.dart#L145-L157](../../lib/data/repository/marketing/marketing_broadcast_repository_impl.dart#L145-L157)

#### 5.2.2 Get broadcast status timeline

**Requirement:**

- [issue_52_marketing_broadcasting_plan.md](../plan/issue_52_marketing_broadcasting_plan.md) Phase D - "Realtime infrastructure for campaign status", Phase I - "cập nhật timeline trạng thái campaign"

**Details:**

- Method: GET
- URL: /api/v1/marketing/broadcasts/{broadcastID}/status-timeline
- Query params:
  - offset (integer, mac dinh 0)
  - limit (integer, mac dinh 20)
- Success response:
  - HTTP 200
  - Mo ta: Ordered list of status change events for broadcast (recent first)
- Response schema:
  - items (array): List of timeline events
    - id (string): Event ID
    - broadcastId (string): Broadcast ID
    - status (string): New status ("running", "paused", "completed", "failed")
    - sentCount (integer): Total sent at this point
    - deliveredCount (integer): Total delivered at this point
    - failedCount (integer): Total failed at this point
    - occurredAt (datetime): When status changed
  - total (integer): Total event count
  - offset (integer): Pagination offset
  - limit (integer): Pagination limit

**Implementation status:**

- Declared in: [lib/data/network/constants/endpoints.dart#L53-L54](../../lib/data/network/constants/endpoints.dart#L53-L54)
- Called by: [lib/data/network/realtime/marketing_broadcast_realtime_service.dart#L213-L230](../../lib/data/network/realtime/marketing_broadcast_realtime_service.dart#L213-L230) (fallback polling)

#### 5.2.3 Subscribe broadcast status (WebSocket)

**Requirement:**

- [issue_52_marketing_broadcasting.md](../issue/issue_52_marketing_broadcasting.md) - "Campaign status (running, paused, completed) tracked in real time"
- [issue_52_marketing_broadcasting_plan.md](../plan/issue_52_marketing_broadcasting_plan.md) Phase D - "WebSocket/SSE...để vẫn đảm bảo trạng thái running/paused/completed được cập nhật liên tục"

**Details:**

- Protocol: WebSocket
- URL: /ws/v1/marketing/broadcasts/{broadcastID}/status
- Connection:
  - Use scheme: `wss` for HTTPS base URL, `ws` for HTTP
  - Auth: Bearer JWT token in query param or header (per backend)
- Message format (from server):
  - Single object: `{status, sentCount, deliveredCount, failedCount, occurredAt}`
  - Or array of objects: `[{...}, {...}, ...]`
- Expected messages:
  - Status updates whenever counts change or status transitions
  - Reconnect with exponential backoff (max 30s) on disconnect
  - Fallback to polling GET /api/v1/marketing/broadcasts/{broadcastID}/status-timeline if WS unavailable

**Implementation status:**

- Endpoint builder: [lib/data/network/constants/endpoints.dart#L110-L118](../../lib/data/network/constants/endpoints.dart#L110-L118)
- Service: [lib/data/network/realtime/marketing_broadcast_realtime_service.dart#L104-L105](../../lib/data/network/realtime/marketing_broadcast_realtime_service.dart#L104-L105)
- Session management + reconnect logic at [lib/data/network/realtime/marketing_broadcast_realtime_service.dart#L94-L192](../../lib/data/network/realtime/marketing_broadcast_realtime_service.dart#L94-L192)

#### 5.2.4 Disconnect Facebook admin account

**Requirement:**

- [issue_52_marketing_broadcasting_plan.md](../plan/issue_52_marketing_broadcasting_plan.md) Phase G - "flow connect/disconnect/reauth/list pages/select page cho Facebook Messenger admin account"

**Details:**

- Method: POST
- URL: /api/v1/marketing/facebook-admin/accounts/{accountID}/disconnect
- Path params:
  - accountID (string, required): Account ID to disconnect
- Request body: (empty or optional metadata)
- Success response:
  - HTTP 200
  - Mo ta: Account disconnected successfully
- Response schema:
  - success (boolean): true
  - message (string): "Account disconnected"

**Implementation status:**

- Implemented in: [lib/data/network/apis/marketing/marketing_broadcast_api.dart#L219-L226](../../lib/data/network/apis/marketing/marketing_broadcast_api.dart#L219-L226)
- Called by: [lib/data/repository/marketing/marketing_broadcast_repository_impl.dart#L213-L221](../../lib/data/repository/marketing/marketing_broadcast_repository_impl.dart#L213-L221)
- UI trigger: [lib/presentation/marketing/facebook_admin_setup_screen.dart](../../lib/presentation/marketing/facebook_admin_setup_screen.dart) "Ngắt kết nối" button

#### 5.2.5 Re-authenticate Facebook admin account

**Requirement:**

- [issue_52_marketing_broadcasting_plan.md](../plan/issue_52_marketing_broadcasting_plan.md) Phase G - "flow connect/disconnect/reauth/list pages"

**Details:**

- Method: POST
- URL: /api/v1/marketing/facebook-admin/accounts/{accountID}/reauth
- Path params:
  - accountID (string, required): Account ID to re-authenticate
- Request body (application/json):
  - accessToken (string, required): New Facebook access token
- Success response:
  - HTTP 200
  - Mo ta: Account re-authenticated with new token
- Response schema:
  - id (string): Account ID
  - status (string): "connected"
  - accessToken (string): Refreshed token (may be masked)
  - tokenExpiresAt (datetime): Token expiry time
  - pageId (string, nullable): Currently selected page
  - pageName (string, nullable): Currently selected page name

**Implementation status:**

- Implemented in: [lib/data/network/apis/marketing/marketing_broadcast_api.dart#L228-L237](../../lib/data/network/apis/marketing/marketing_broadcast_api.dart#L228-L237)
- Called by: [lib/presentation/marketing/facebook_admin_setup_screen.dart](../../lib/presentation/marketing/facebook_admin_setup_screen.dart) "Xác thực lại" button

#### 5.2.6 Get Facebook admin pages

**Requirement:**

- [issue_52_marketing_broadcasting_plan.md](../plan/issue_52_marketing_broadcasting_plan.md) Phase G - "list pages/select page cho Facebook Messenger admin account"

**Details:**

- Method: GET
- URL: /api/v1/marketing/facebook-admin/accounts/{accountID}/pages
- Path params:
  - accountID (string, required): Account ID to fetch pages for
- Success response:
  - HTTP 200
  - Mo ta: List of Facebook pages accessible by admin account
- Response schema:
  - items (array): List of page objects
    - id (string): Page ID
    - name (string): Page name
    - category (string, nullable): Page category (e.g., "business", "community")
    - accessLevel (string, nullable): Admin permission level
    - isSelected (boolean, nullable): Whether this page is currently bound

**Implementation status:**

- Implemented in: [lib/data/network/apis/marketing/marketing_broadcast_api.dart#L239-L246](../../lib/data/network/apis/marketing/marketing_broadcast_api.dart#L239-L246)
- UI display: [lib/presentation/marketing/facebook_admin_setup_screen.dart](../../lib/presentation/marketing/facebook_admin_setup_screen.dart) "Chọn trang" dropdown

#### 5.2.7 Select Facebook admin page

**Requirement:**

- [issue_52_marketing_broadcasting_plan.md](../plan/issue_52_marketing_broadcasting_plan.md) Phase G - "đồng bộ trạng thái oauth/token expiry/page binding về store để campaign chỉ cho phép dispatch khi integration hợp lệ"

**Details:**

- Method: POST
- URL: /api/v1/marketing/facebook-admin/accounts/{accountID}/select-page
- Path params:
  - accountID (string, required): Admin account ID
- Request body (application/json):
  - pageId (string, required): Facebook page ID to bind
- Success response:
  - HTTP 200
  - Mo ta: Page selected and bound to admin account
- Response schema:
  - id (string): Account ID
  - status (string): "connected"
  - pageId (string): Selected page ID
  - pageName (string): Selected page name
  - tokenExpiresAt (datetime): Token expiry time

**Implementation status:**

- Implemented in: [lib/data/network/apis/marketing/marketing_broadcast_api.dart#L248-L258](../../lib/data/network/apis/marketing/marketing_broadcast_api.dart#L248-L258)
- Called by: [lib/presentation/marketing/facebook_admin_setup_screen.dart](../../lib/presentation/marketing/facebook_admin_setup_screen.dart) "Chọn trang" action
- Validation: [lib/presentation/marketing/store/marketing_broadcast_store.dart#L136-L152](../../lib/presentation/marketing/store/marketing_broadcast_store.dart#L136-L152) `hasValidFacebookIntegration` computed property

## 6) Error status thuong gap

- 400 BAD_REQUEST / INVALID_INPUT / EXISTED
- 401 UNAUTHORIZED / TOKEN_EXPIRED
- 403 FORBIDDEN (co the kem code SUBSCRIPTION_REQUIRED)
- 404 NOT_FOUND
- 409 CONFLICT
- 422 UNPROCESSABLE_ENTITY
- 429 TOO_MANY_REQUESTS
- 500 INTERNAL_ERROR
- 502 BAD_GATEWAY
- 503 SERVICE_UNAVAILABLE

## 6) Vi du goi API

### Vi du tao template

Request:

```http
POST /api/v1/marketing/templates HTTP/1.1
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "name": "Promo 30-4",
  "content": "Xin chao {{customerName}}, uu dai hom nay...",
  "channelType": "MESSENGER"
}
```

Response thanh cong:

```http
HTTP/1.1 201 Created
```

Response loi mau:

```json
{
  "status": "INVALID_INPUT",
  "message": "name khong duoc de trong"
}
```
