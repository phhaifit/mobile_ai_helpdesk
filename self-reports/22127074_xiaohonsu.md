# Báo cáo cá nhân — Phase 1 & Phase 2

> Mục tiêu: em tự xác nhận phần đóng góp của mình ở Phase 1 và Phase 2. Đặc biệt quan trọng cho các ticket co-assigned (chia điểm), API thêm/sửa, và những công việc không nằm trong ticket chính thức.

---

## 1. Thông tin cá nhân

| Field | Giá trị |
|---|---|
| Họ tên | Võ Hoàng Đức |
| MSSV | 22127074 |
| GitHub ID | xiaohonsu |
| Email | vhduc22@clc.fitus.edu.vn |
| Đề tài | Helpdesk |
| Nhóm | Nhóm 2 |
| Repo đề tài | https://github.com/phhaifit/mobile_ai_helpdesk |

---

## 2. Phase 1 — UI + Mock data

### 2.1 Ticket em là người implement

> Liệt kê tất cả ticket Phase 1 mà em được assign (hoặc đồng-assign). Với mỗi ticket, kê khai phần điểm em nhận. Nếu co-assigned, ghi rõ cách chia với bạn cùng đề tài.

| # | Issue | Tiêu đề | Estimate | Co-assignee (nếu có) | % chia của em | Điểm em nhận | PR (link) | Demo / Video |
|---|---|---|---|---|---|---|---|---|
| 1 | [#14](https://github.com/phhaifit/mobile_ai_helpdesk/issues/14) | [Phase 1] Knowledge Base Management | 20 | @nban22 | 50% | **10** | [#45](https://github.com/phhaifit/mobile_ai_helpdesk/pull/45) |  |

**Ghi chú thêm về co-assignee split:**
> Ticket #14 em co-assigned với @nban22 (Nguyễn Bá An), thống nhất chia 50/50 (mỗi người 10 điểm). Phần em phụ trách: scaffold toàn bộ Knowledge Base UI Phase 1 (commit [`f1d3811`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/f1d3811) — implement knowledge base management UI offline), tích hợp Knowledge vào sidebar và sửa layout/SafeArea ([`7563357`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/7563357)), resolve conflicts khi merge với main ([`0def8de`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/0def8de), [`b6b6849`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/b6b6849), [`e2c0ce4`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/e2c0ce4)). Phần @nban22 phụ trách: mock DB connection test flow ([`3ad604e`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/3ad604e)), crawl interval config + offline persistence ([`e94f83b`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/e94f83b)), widget tree documentation ([`56fecd4`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/56fecd4)). Hai bên không trùng scope.

### 2.2 PR em đã review trong Phase 1

> Liệt kê các PR em đã review approve trong Phase 1. Theo rule: reviewer được +10% estimate ticket được review (chỉ tính PR đã merge).

| # | PR | Author | Issue được close | Estimate issue | Reviewer bonus (10%) | Trạng thái |
|---|---|---|---|---|---|---|
| 1 | [#47](https://github.com/phhaifit/mobile_ai_helpdesk/pull/47) | @nqdoan22 (Nguyen Quang Doan) | #20 — Sentry Error Tracking | 2 | 0.2 | APPROVED — merged |
|   |   |   | **Tổng reviewer bonus** |   | **0.2** |   |

### 2.3 Tổng kết Phase 1 (tự chấm)

| Mục | Điểm |
|---|---|
| Implementer | **10** |
| Reviewer bonus | **0.2** (xem bảng §2.2) |
| **Tổng (uncapped)** | **10.2** |
| **Capped @10** | **10** |

---

## 3. Phase 2 — Full-flow integration với API

### 3.1 Ticket em là người implement

> Bao gồm cả sub-issue nếu em nhận sub-issue thay vì parent. Nếu nhận parent ticket co-assigned, ghi cả parent và sub-issue tương ứng.

| # | Issue | Tiêu đề | Estimate | Co-assignee | % chia của em | Điểm em nhận | PR (link) | Demo / Video |
|---|---|---|---|---|---|---|---|---|
| 1 | [#58](https://github.com/phhaifit/mobile_ai_helpdesk/issues/58) | Knowledge Base Management — Full Integration | 20 | @nban22 | 50% | **10** | [#84](https://github.com/phhaifit/mobile_ai_helpdesk/pull/84) | https://youtu.be/79uXIPWNxdw |
| 2 | [#53](https://github.com/phhaifit/mobile_ai_helpdesk/issues/53) (sub-issue [#60](https://github.com/phhaifit/mobile_ai_helpdesk/issues/60)) | Ticket Management — Full Integration (Sub-B: Customer History & Realtime Comments) | 20 | @nqdoan22 | 25% | **5** | [#99](https://github.com/phhaifit/mobile_ai_helpdesk/pull/99) | |

**Ghi chú co-assignee split / sub-issue split:**

> **Ticket #58 (Knowledge Base — co-assigned với @nban22, 50/50):** hai bên làm **chung trên cùng feature branch** (`feature/58-integration-knowledge-base-management`), không tách sub-issue chính thức. Thống nhất chia scope từ đầu để không đụng commit của nhau và tổng workload chia 50/50. **Phần em phụ trách:** lớp `KnowledgeApi` (Dio) + `KnowledgeRepositoryImpl` + use case + SSE subscription ([`d6010b2`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/d6010b2), [`6ca3ecb`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/6ca3ecb)) — bao gồm `GET /sources` list + pagination, `POST /web` (single page + whole-site), SSE `/status-sse` stream với reconnect + polling fallback. Update source status ([`20f98ac`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/20f98ac), [`58876a8`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/58876a8)). Wire real BE responses cho source list + imports ([`3de7b87`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/3de7b87), [`f027733`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/f027733)). Kebab-case type mapping + SessionStore DI ([`f389238`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/f389238)). DB query integration: `POST /database-query` + `POST /test-database-query` + connection test flow + preview dialog + handle list response ([`45575b0`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/45575b0)). **Phần Google Drive integration (OAuth PKCE + `POST /google-drive`) cùng các phần còn lại thuộc @nban22.** Đóng góp thêm ngoài scope ban đầu của #58 — endpoint `GET /sources/{type}` filter source by type — kê ở **§4 Kê khai bổ sung** (không claim BE bonus ở §3.2 do implement gộp chung commit/PR với các endpoint trong scope).

> **Ticket #53 (Ticket Management — co-assigned với @nqdoan22, 5/15):** parent #53 được chia thành 2 sub-issue. @nqdoan22 nhận sub-A (#59 — Core API Integration, est lớn hơn), em nhận sub-B (#60 — Customer History & Realtime Comments). Hai bên thống nhất chia 5/15 (em 25%, @nqdoan22 75%) phản ánh đúng tỉ lệ workload giữa core CRUD + assignment (sub-A) và customer history timeline + realtime comments (sub-B). Phần em làm (commits): customer history timeline + comments với realtime WebSocket ([`0c5b97e`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/0c5b97e)), DI cho `TicketApi` + `TicketRepositoryImpl` + `TicketWebSocketService` ([`4817bf9`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/4817bf9)), DI/navigation fixes + mobile UI improvements ([`4052d64`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/4052d64)), dedup `chatRoomId` + align `FakeTicketApi` signature sau khi merge main ([`88bc34a`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/88bc34a)). Phần @nqdoan22 làm (PR [#86](https://github.com/phhaifit/mobile_ai_helpdesk/pull/86)): core ticket CRUD + list pagination + status tabs + assignment APIs. Hai bên không trùng scope.

### 3.2 API em đã thêm hoặc chỉnh sửa (Phase 2 BE bonus)

> Theo rule Phase 2: +2đ cho mỗi API thêm mới, +1đ cho mỗi API chỉnh sửa. **Bắt buộc** phải có ticket BE riêng + PR có ≥2 approval.

Không có entry nào đủ điều kiện claim ở mục này. Endpoint `GET /sources/{type}` (filter source by type) em có đóng góp thêm ngoài scope #58, nhưng được implement gộp chung với các endpoint trong scope (cùng commit/PR, không có ticket BE riêng + PR BE riêng), nên không đáp ứng yêu cầu "ticket BE riêng + PR có ≥2 approval". Em kê khai ở **§4 Kê khai bổ sung** để thầy ghi nhận đóng góp ngoài scope, không claim điểm bonus.

### 3.3 PR em đã review trong Phase 2

> Phase 2: reviewer được +10% estimate của issue tương ứng (chỉ tính PR merged). Loại trừ PR cho ticket co-assigned của chính em (PR #84 đóng #58 — đã tính phần điểm implementer ở §3.1).

| # | PR | Author | Issue được close | Estimate issue | Reviewer bonus (10%) | Trạng thái |
|---|---|---|---|---|---|---|
| 1 | [#82](https://github.com/phhaifit/mobile_ai_helpdesk/pull/82) | @nban22 (Nguyễn Bá An) | #50 — Auth API Integration (Google OAuth PKCE) | 10 | 1.0 | APPROVED — merged |
| 2 | [#76](https://github.com/phhaifit/mobile_ai_helpdesk/pull/76) | @nban22 (Nguyễn Bá An) | #50 — Auth API Integration (hotfix) | 10 | — | APPROVED — merged (cùng đóng #50, không cộng dồn bonus) |
|   |  |  | **Tổng reviewer bonus** |  | **1.0** |  |

### 3.4 Tổng kết Phase 2 (tự chấm)

| Mục | Điểm |
|---|---|
| Implementer (FE ticket) | 10 + 5 = **15** |
| API bonus (BE work) | 0 (không có entry đủ điều kiện — xem §3.2 + §4) |
| Reviewer bonus | **1.0** (xem bảng §3.3) |
| **Tổng (uncapped)** | **16.0** |
| **Capped @10** | **10** |

---

## 4. Kê khai bổ sung (nếu có)

> Phần này dành cho các đóng góp **không nằm trong ticket chính thức** nhưng em muốn thầy ghi nhận.

| # | Mô tả | Bằng chứng (PR/commit/Slack link) |
|---|---|---|
| 1 | **Thêm endpoint `GET /api/v1/knowledges/{tenantId}/sources/{type}` (filter source by type)** — không nằm trong scope ban đầu của ticket #58. Em đề xuất thêm để UI có thể filter server-side theo loại nguồn (web / whole-site / file / google-drive / database-query) thay vì client-side filter trên toàn bộ list. Endpoint này em implement cùng lúc với các endpoint trong scope (gộp chung commit/PR, không tách ticket BE riêng) nên không claim được BE bonus ở §3.2 — em kê khai ở đây để thầy ghi nhận đóng góp ngoài scope. Mobile wiring tương ứng ở `KnowledgeApi.getSourcesByType`. | Mobile commit [`20f98ac`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/20f98ac), [`58876a8`](https://github.com/phhaifit/mobile_ai_helpdesk/commit/58876a8). Wrap-up PR #84. |

> Đóng góp ngoài scope này em đã thống nhất với @nban22: hai bên đều thêm 1 endpoint ngoài scope #58 (em: filter-by-type; @nban22: delete source). Cùng phương án implement (gộp với commit/PR scope chính), nên cả hai cùng kê ở §4 thay vì §3.2.

---

## 5. Đề xuất điều chỉnh điểm (nếu có)

> Phần này để em báo các trường hợp ticket / PR mà em nghĩ phần kê khai ở §2–§4 chưa phản ánh đúng đóng góp.

**Ticket / PR cần điều chỉnh:**

| Ticket / PR | Vấn đề | Đề xuất sửa |
|---|---|---|
| — | — | — |

> Không có ticket / PR nào em thấy kê khai chưa phản ánh đúng đóng góp. Tất cả tỉ lệ chia điểm co-assignee ở §2–§3 đã thống nhất với @nban22 và @nqdoan22 trước khi nộp.

---

## 6. Tự đánh giá & rút kinh nghiệm (tùy chọn)

> Phần optional, không tính điểm — nhưng giúp thầy hiểu hơn về quá trình em làm việc.

### Điều em làm tốt:

>

### Khó khăn em gặp phải:

>

### Em sẽ làm khác đi điều gì nếu được làm lại:

>

---

## 7. Cam kết

- [x] Các thông tin trên là chính xác. Em sẽ chịu trách nhiệm nếu phát hiện kê khai sai sự thật (sao chép code, lấy điểm thay người khác, v.v.).
- [x] Em đồng ý cho thầy dùng dữ liệu này để chấm điểm môn LTDDNC 2026.

| Ký tên (gõ tên) | Ngày |
|---|---|
| Võ Hoàng Đức | 17/05/2026 |
