# Báo cáo cá nhân — Phase 1 & Phase 2

> Mục tiêu: bạn tự xác nhận phần đóng góp của mình ở Phase 1 và Phase 2. Đặc biệt quan trọng cho các ticket co-assigned (chia điểm), API thêm/sửa, và những công việc không nằm trong ticket chính thức.

---

## 1. Thông tin cá nhân

| Field | Giá trị |
|---|---|
| Họ tên | Nguyễn Phước Sang |
| MSSV | 22127362 |
| GitHub ID | Sang-Nguyen-Phuoc |
| Email | 22127362@student.hcmus.edu.vn |
| Đề tài | Helpdesk |
| Nhóm | Nhóm 1 |
| Repo đề tài | https://github.com/phhaifit/mobile_ai_helpdesk |

---

## 2. Phase 1 — UI + Mock data

### 2.1 Ticket em là người implement

> Liệt kê tất cả ticket Phase 1 mà bạn được assign (hoặc đồng-assign). Với mỗi ticket, kê khai phần điểm bạn nhận. Nếu co-assigned, ghi rõ cách chia với bạn cùng đề tài (vd `15/5`).

| # | Issue | Tiêu đề | Estimate | Co-assignee (nếu có) | % chia của em | Điểm em nhận | PR (link) | Demo / Video |
|---|---|---|---|---|---|---|---|---|
| 1 | #11 | [Phase 1] Monetization | 5 | solo | 100% | 5 | [#27](https://github.com/phhaifit/mobile_ai_helpdesk/pull/27) | [YouTube](https://youtu.be/hpUHcKosKaY) |
| 2 | #4 | [Phase 1] Omnichannel Integrations | 10 | solo | 100% | 10 | [#28](https://github.com/phhaifit/mobile_ai_helpdesk/pull/28) | [YouTube](https://youtu.be/HG7n-uv4OhI) |

**Ghi chú thêm về co-assignee split** (nếu có chia không 50/50):
> Cả hai ticket Phase 1 em đều làm solo, không chia với ai.

### 2.2 PR em đã review trong Phase 1

> Liệt kê các PR mà bạn đã review approve cho ticket Phase 1 của bạn khác. Theo rule: reviewer được +10% estimate ticket được review (chỉ tính PR đã merge).

| # | PR | Author | Issue được close | Estimate issue | Reviewer bonus (10%) | Trạng thái |
|---|---|---|---|---|---|---|
| 1 | [#24](https://github.com/phhaifit/mobile_ai_helpdesk/pull/24) | @tinpham (TIN PHAM) | #22 — Firebase Crashlytics | 2 | 0.2 | APPROVED — merged |
| 2 | [#30](https://github.com/phhaifit/mobile_ai_helpdesk/pull/30) | @Dinhkhoi2603 (Khoi Pham) | #15 — Prompt Management | 10 | 1.0 | APPROVED — merged |
| 3 | [#43](https://github.com/phhaifit/mobile_ai_helpdesk/pull/43) | @Dinhkhoi2603 (Khoi Pham) | #19 — Google Analytics Integration | 2 | 0.2 | APPROVED — merged |
| 4 | [#45](https://github.com/phhaifit/mobile_ai_helpdesk/pull/45) | @nban22 (Nguyễn Bá An) | #14 — Knowledge Base Management | 20 | 2.0 | APPROVED — merged |
|   |   |   | **Tổng reviewer bonus** |   | **3.4** |   |

### 2.3 Tổng kết Phase 1 (tự chấm)

| Mục | Điểm |
|---|---|
| Implementer | 5 + 10 = **15** |
| Reviewer bonus | **3.4** (xem bảng §2.2) |
| **Tổng (uncapped)** | **18.4** |
| **Capped @10** | **10** |

---

## 3. Phase 2 — Full-flow integration với API

### 3.1 Ticket em là người implement

> Bao gồm cả sub-issue nếu bạn nhận sub-issue thay vì parent. Nếu nhận parent ticket co-assigned, ghi cả parent và sub-issue tương ứng.

| # | Issue | Tiêu đề | Estimate | Co-assignee | % chia của em | Điểm em nhận | PR (link) | Demo / Video |
|---|---|---|---|---|---|---|---|---|
| 1 | [#54](https://github.com/phhaifit/mobile_ai_helpdesk/issues/54) | Customer Management Phase 2: Advanced Insights, Segmentation & Data Quality | 20 | @tinpham | 50% | **10** | [#93](https://github.com/phhaifit/mobile_ai_helpdesk/pull/93) | [YouTube](https://youtu.be/IAq6jRetlB8) |
| 2 | [#49](https://github.com/phhaifit/mobile_ai_helpdesk/issues/49) | Omnichannel Integrations (Phase 2 — Full Integration / Messengers) | 10 | @tinpham | 50% | **5** | [#67](https://github.com/phhaifit/mobile_ai_helpdesk/pull/67), [#77](https://github.com/phhaifit/mobile_ai_helpdesk/pull/77) | [YouTube](https://youtu.be/i3gJkH23kNo) |

**Ghi chú co-assignee split / sub-issue split:**
> Cả 2 ticket Phase 2 em co-assigned với @tinpham (TIN PHAM), chia 50/50.

### 3.2 API em đã thêm hoặc chỉnh sửa (Phase 2 BE bonus)

> Theo rule Phase 2: +2đ cho mỗi API thêm mới, +1đ cho mỗi API chỉnh sửa. **Bắt buộc** phải có ticket BE riêng + PR có ≥2 approval.

Không có. Em không thêm/chỉnh sửa API trên backend trong Phase 2.

### 3.3 PR em đã review trong Phase 2

> Phase 2: reviewer được +10% estimate của issue tương ứng (chỉ tính PR merged).

| # | PR | Author | Issue được close | Estimate issue | Reviewer bonus (10%) | Trạng thái |
|---|---|---|---|---|---|---|
| 1 | [#72](https://github.com/phhaifit/mobile_ai_helpdesk/pull/72) | @tinpham (TIN PHAM) | #65 — Zalo Integration | 10 | 1.0 | APPROVED — merged |
| 2 | [#75](https://github.com/phhaifit/mobile_ai_helpdesk/pull/75) | @nban22 (Nguyễn Bá An) | #50 — Auth API Integration | 10 | 1.0 | APPROVED — merged |
| 3 | [#78](https://github.com/phhaifit/mobile_ai_helpdesk/pull/78) | @Dinhkhoi2603 (Khoi Pham) | #56 — Prompt Management Integration | 10 | 1.0 | APPROVED — merged |
| 4 | [#79](https://github.com/phhaifit/mobile_ai_helpdesk/pull/79) | @tinpham (TIN PHAM) | #73 — Customer Mgmt Core Lifecycle & Discovery API | 5 | 0.5 | APPROVED — merged |
| 5 | [#86](https://github.com/phhaifit/mobile_ai_helpdesk/pull/86) | @nqdoan22 (Nguyen Quang Doan) | #59 — Ticket Management API Integration | 15 | 1.5 | APPROVED — merged |
| 6 | [#94](https://github.com/phhaifit/mobile_ai_helpdesk/pull/94) | @tinpham (TIN PHAM) | #65 — Zalo Integration (finalised) | 5 | 0.5 | APPROVED — merged |
|   |  |  | **Tổng reviewer bonus** |  | **5.5** |  |

### 3.4 Tổng kết Phase 2 (tự chấm)

| Mục | Điểm |
|---|---|
| Implementer (FE ticket) | 10 + 5 = **15** |
| API bonus (BE work) | 0 (không có) |
| Reviewer bonus | **5.5** (xem bảng §3.3) |
| **Tổng (uncapped)** | **20.5** |
| **Capped @10** | **10** |

---

## 4. Kê khai bổ sung (nếu có)

> Phần này dành cho các đóng góp **không nằm trong ticket chính thức** nhưng bạn muốn thầy ghi nhận. Vd: bug fix khẩn cấp, refactor lớn, viết docs/test mà nhóm có dùng, support team khác...

| # | Mô tả | Bằng chứng (PR/commit/Slack link) |
|---|---|---|
| 1 | **PR #32 — Đổi tên package + thống nhất import toàn repo (18 files thay đổi).** Pain point: package ban đầu đặt là `mobile_ai_helpdesk` không khớp với identifier `ai_helpdesk` mà các module cần dùng → imports trong codebase phân mảnh (chỗ dùng relative path, chỗ dùng tên package cũ), gây xung đột khi các thành viên merge nhánh Phase 1 và là blocker cho việc đi tiếp Phase 2. Em dọn 1 lần: rename package trong `pubspec.yaml` rồi sweep nhất quán đường dẫn import trên **toàn bộ 18 file** đụng tới (gồm cả `main.dart`, DI modules, data + presentation layer, routes, tests). Sau PR, các nhánh tính năng đang chờ merge có thể rebase sạch và không còn lỗi "package not found" do tên cũ. | [PR #32](https://github.com/phhaifit/mobile_ai_helpdesk/pull/32) — merged 2026-03-23 |

---

## 5. Đề xuất điều chỉnh điểm (nếu có)

> Phần này để bạn báo các trường hợp ticket / PR mà bạn nghĩ phần kê khai ở §2–§4 chưa phản ánh đúng đóng góp (vd: bạn cùng đề tài được ghi nhận điểm mà thực tế không làm, hoặc ngược lại).

**Ticket / PR cần điều chỉnh:**

| Ticket / PR | Vấn đề | Đề xuất sửa |
|---|---|---|
| — | — | — |

> Không có ticket / PR nào em thấy kê khai chưa phản ánh đúng đóng góp. Phần điểm ở §2–§4 đã thống nhất với @tinpham trước khi nộp.

---

## 6. Tự đánh giá & rút kinh nghiệm (tùy chọn)

> Phần optional, không tính điểm — nhưng giúp thầy hiểu hơn về quá trình bạn làm việc.

### Điều bạn làm tốt:

> Em chủ động kiểm thử lại các luồng Phase 1 trước khi bước sang Phase 2 nên kịp thời phát hiện một số bug tích hợp tồn đọng. Việc giải quyết sớm những bug này giúp Phase 2 trơn tru, các thành viên không bị block khi rebase, và team không phải tốn thời gian debug.

### Khó khăn bạn gặp phải:

> Khó khăn lớn nhất là **giao tiếp trong một project quy mô lớn**: nhóm em có 12 người cùng implement, lại phải đồng bộ với một team Backend riêng cho phần API. Việc 12 người cùng đụng vào codebase Flutter tạo ra rất nhiều xung đột merge và những quyết định kiến trúc bị mỗi người hiểu một kiểu. Phối hợp với team Backend càng phức tạp hơn: API spec thay đổi giữa chừng (ví dụ rename param `email → spamAddress`, đổi endpoint customer ticket), response shape không nhất quán giữa list/detail, một số endpoint chưa kịp deploy nhưng đã được liệt kê trong spec — khiến mobile mất thời gian đoán semantics và phải refactor lại nhiều lần. Thông tin còn phân tán trên nhiều kênh (GitHub issues / PR comments / Apidog / chat), nên đôi khi quyết định đã được chốt rồi mà một số thành viên vẫn không biết.

### Bạn sẽ làm khác đi điều gì nếu được làm lại:

> Em sẽ **đầu tư cho khâu giao tiếp ngay từ đầu sprint** thay vì để mỗi người tự xoay sở. Cụ thể: (1) thống nhất ngay 1 kênh chính cho từng loại thảo luận (vd: spec / decision log đẩy vào GitHub issues, ad-hoc Q&A để ở chat), tránh tình trạng phải tra ngược nhiều nơi; (2) lập lịch sync-up định kỳ với team Backend ngay từ đầu Phase 2 để bắt sớm các thay đổi API, có response mẫu trước khi mobile bắt tay implement; (3) khi nhận ticket co-assigned, em và bạn cùng nhận sẽ chia rõ scope ngay từ kick-off (ai làm data layer, ai làm UI, ai viết test) thay vì để work tự nhiên đụng vào nhau giữa chừng; (4) viết decision log ngắn cho các quyết định kiến trúc quan trọng để new joiner / reviewer onboard nhanh và bản thân em khi quay lại sau vài tuần không phải đọc lại toàn bộ commit history.

---

## 7. Cam kết

- [x] Các thông tin trên là chính xác. Em sẽ chịu trách nhiệm nếu phát hiện kê khai sai sự thật (sao chép code, lấy điểm thay người khác, v.v.).
- [x] Em đồng ý cho thầy dùng dữ liệu này để chấm điểm môn LTDDNC 2026.

| Ký tên (gõ tên) | Ngày |
|---|---|
| Nguyễn Phước Sang | 2026-05-16 |