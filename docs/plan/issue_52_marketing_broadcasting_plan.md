# Plan: Phase 2 Marketing Broadcasting API Integration

Mục tiêu là nâng toàn bộ Marketing & Broadcasting từ placeholder/mô phỏng lên tích hợp API thật, gồm template CRUD, campaign lifecycle, audience API, Facebook admin linking, và realtime status qua WebSocket/SSE ngay từ đầu. Cách làm là bám đúng clean architecture hiện có của repo, thêm module marketing/broadcasting riêng, đồng thời nối vào menu/route/UI Phase 1 đã có để không phá vỡ luồng người dùng hiện tại.

---

## Steps

### 1. Phase A - Baseline and API mapping

Xác nhận mapping giữa màn hình Phase 1 và contract backend hiện có cho 7 cụm chức năng: template CRUD, template library search, campaign CRUD/lifecycle, audience filtering, recipient resolution, facebook admin auth/page management, delivery status/receipts. Chốt model request/response và quy ước lỗi dùng Failure + NetworkExceptions cho module mới. Đây là bước chặn cho toàn bộ phần code phía dưới.

### 2. Phase B - Domain modeling for Marketing/Broadcasting

Tạo nhóm entity/repository/usecase mới dưới domain cho template, campaign, audience, facebook admin, delivery receipt; tách rõ command use case (create/update/delete/start/stop/resume) và query use case (list/search/detail/status/receipts). Giữ store không phụ thuộc BuildContext và dùng ObservableFuture cho mọi call bất đồng bộ. Bước này phụ thuộc Step 1.

### 3. Phase C - Data/API integration

Tạo API clients theo từng cụm (templates, campaigns, audience, facebook admin), thêm endpoint constants mới, implement repositories gọi DioClient và chuyển lỗi DioException sang Failure qua NetworkExceptions. Đảm bảo token hiện tại được tái sử dụng qua AuthInterceptor sẵn có. Bước này phụ thuộc Step 1 và có thể làm song song nội bộ theo cụm API.

### 4. Phase D - Realtime infrastructure for campaign status

Bổ sung service realtime cho campaign status + delivery receipts bằng WebSocket/SSE (theo lựa chọn của bạn), có cơ chế reconnect/backoff và fallback polling khi kênh realtime gián đoạn để vẫn đảm bảo trạng thái running/paused/completed được cập nhật liên tục. Tầng data phát event lên store theo campaignId để UI phản ứng theo ngữ cảnh màn hình. Bước này song song được với Step 3 sau khi có schema status event từ Step 1.

### 5. Phase E - Presentation store integration

Tạo store riêng cho template library/editor, campaign list/detail/compose, audience targeting, facebook admin connection/page picker, delivery monitor; nối stores tới use cases mới. Chuẩn hóa các trạng thái loading/error/success và mapping lỗi backend thành message key localization. Bước này phụ thuộc Steps 2-4.

### 6. Phase F - Wire existing Marketing entry points

Nối menu Marketing hiện tại (Chiến dịch, Template) từ placeholder sang route/screen thật, thêm route constants + route builders cho template list/editor, campaign list/detail/create, audience filter, facebook admin setup nếu có luồng riêng. Bước này phụ thuộc Step 5.

### 7. Phase G - Facebook admin connectivity hardening

Triển khai đầy đủ flow connect/disconnect/reauth/list pages/select page cho Facebook Messenger admin account; đồng bộ trạng thái oauth/token expiry/page binding về store để campaign chỉ cho phép dispatch khi integration hợp lệ. Phần này phụ thuộc Steps 3 và 5.

### 8. Phase H - Audience and recipient targeting

Kết nối audience source hoàn toàn từ API mới (theo lựa chọn của bạn), hỗ trợ search/filter/paging/chọn segment và snapshot recipient count trước khi chạy campaign. Chốt hành vi validation khi audience rỗng hoặc recipient bị loại do channel constraints. Phụ thuộc Steps 3 và 5.

### 9. Phase I - Campaign execution controls

Nối start/stop/resume vào API thật, khóa trạng thái nút theo state machine backend, cập nhật timeline trạng thái campaign theo realtime stream; hiển thị progress, success/failed counts, và delivery receipts theo thời gian thực. Phụ thuộc Steps 4, 5, 7, 8.

### 10. Phase J - DI, localization, analytics, and observability

Đăng ký đầy đủ API/repository/usecase/store tại các module DI; thêm key localization cho en/da/es/vi cho toàn bộ thông điệp marketing/broadcasting/facebook/delivery; bổ sung analytics events và error telemetry cho các hành động quan trọng (create campaign, start, pause, resume, connect facebook, dispatch result). Phụ thuộc Steps 5-9.

### 11. Phase K - Tests and verification

Bổ sung unit test cho use case/repository/store (đặc biệt state transitions và lỗi mạng), integration test cho flow campaign end-to-end và manual QA checklist cho realtime status + delivery receipts. Bước này phụ thuộc toàn bộ các bước trước.

### 12. Phase L - Rollout gates and non-functional checks

Chạy build_runner, analyze, test; kiểm tra hiệu năng realtime stream, timeout/retry behavior, và tính nhất quán dữ liệu khi app foreground/background. Chỉ merge khi pass toàn bộ acceptance criteria của ticket #52.

---

## Verification

1. Chạy `flutter pub get` sau khi thêm dependencies realtime (nếu có).
2. Chạy `flutter packages pub run build_runner build --delete-conflicting-outputs` sau khi thêm model/store annotations.
3. Chạy `flutter analyze` và sửa toàn bộ warning/error mới phát sinh trong module marketing/broadcasting.
4. Chạy `flutter test` cho unit tests của repository/usecase/store và integration tests campaign flow.
5. **Manual E2E:** Tạo template, sửa, xóa, tìm kiếm template library từ API.
6. **Manual E2E:** Tạo campaign bằng template, chọn audience từ API mới, start campaign, nhận progress realtime, pause/resume thành công.
7. **Manual E2E:** Kết nối Facebook admin account, chọn page, dispatch campaign qua Facebook channel thành công.
8. **Manual E2E:** Xác thực delivery receipts hiển thị đúng sent/delivered/failed và campaign status chuyển đúng running/paused/completed theo realtime.
9. **Manual resilience:** Mất mạng khi campaign đang chạy, kiểm tra reconnect realtime/fallback polling và đồng bộ lại trạng thái sau khi mạng hồi phục.

---

## Decisions

- **Backend readiness:** Đã có contract + endpoint thật.
- **Delivery channel ưu tiên cho Phase 2:** Facebook Messenger.
- **Realtime mode:** WebSocket là primary, có fallback polling để an toàn vận hành.
- **Recipient source:** Lấy từ API audience mới hoàn toàn, không phụ thuộc module Customer hiện tại.
- **In scope:** Full API integration cho template/campaign/audience/facebook admin/delivery status.
- **Out of scope:** Mở rộng sang Zalo campaign delivery trong ticket #52 (có thể làm ticket tiếp theo).
- **Repository/use case convention:** Giữ chuẩn `Future` trực tiếp, không chuyển sang `Either<Failure, T>` cho module marketing ở các phase hiện tại.
- **Pagination defaults:** Mặc định `pageSize = 10` cho danh sách templates/campaigns/audience/receipts.
- **Campaign state transitions (default):**
  - `draft -> scheduled | running`
  - `scheduled -> running`
  - `running -> paused | completed | failed`
  - `paused -> running`
  - `completed`, `failed` là trạng thái kết thúc
- **UI control rule theo trạng thái:**
  - Nút `Start`: chỉ bật ở `draft`, `scheduled`
  - Nút `Stop`: chỉ bật ở `running`
  - Nút `Resume`: chỉ bật ở `paused`
- **Pass criteria tạm thời cho mỗi phase:** Chỉ cần `flutter analyze` pass (chưa bắt buộc test/manual gate).

---

## Further Considerations

1. Nên chuẩn hóa một convention thống nhất cho repository/usecase mới theo `Either<Failure, T>` để không gia tăng tình trạng mixed-pattern đang có trong repo.
2. Nên yêu cầu backend cung cấp campaign event schema versioned cho WebSocket/SSE để giảm break khi backend đổi payload.
3. Nên định nghĩa idempotency key cho start/stop/resume API để chống thao tác lặp khi người dùng bấm nhiều lần hoặc reconnect.
