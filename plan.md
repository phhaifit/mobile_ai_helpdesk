# Plan Implement Full UI + Offline Flow for Ticket Management (Mock Data)

Created: 2026-03-20
Owner: Frontend (Flutter)
Scope: Ticket list, create ticket, ticket detail, customer history, offline-first mock flow.

## 1. Mục tiêu

1. Hoàn thiện toàn bộ UI quản lý phiếu theo luồng nghiệp vụ chính.
2. Chạy được đầy đủ offline flow khi chưa có backend thật.
3. Kiến trúc sẵn sàng chuyển sang backend mà không phải đập lại presentation.

## 2. Nguyên tắc triển khai

1. Presentation chỉ gọi Store -> UseCase -> Repository interface.
2. Không hardcode user rải rác; dùng currentAgentId từ session/mock auth store.
3. Mock repository là nguồn dữ liệu duy nhất cho toàn bộ ticket flow.
4. UI cập nhật theo optimistic update, có loading và error state rõ ràng.

## 3. Deliverables

1. Ticket list screen hoàn thiện tab/filter/search/sort/column toggle.
2. Create ticket flow hoàn chỉnh và đẩy ticket mới vào danh sách.
3. Ticket detail screen với edit status/assign agent/comment.
4. Customer history screen.
5. Offline persistence local (Sembast hoặc local datasource hiện có).
6. Test checklist + manual QA script cho offline flow.

## 4. Kế hoạch theo phase

### Phase 1: Chuẩn hóa dữ liệu và hợp đồng domain

1. Rà soát entity đang có: Ticket, Agent, Customer, Comment, ContactInfo.
2. Bổ sung field còn thiếu cho offline flow:
	- localId/isSynced/pendingAction/lastModifiedAt (nếu cần).
3. Chuẩn hóa TicketRepository để bao phủ đủ use case UI:
	- getTickets/getTicketById/create/update/delete/assign/addComment/getCustomerHistory.
4. Chuẩn hóa params object cho filter query:
	- tab, search, statuses, priorities, category, source, customerId, createdById, dateRange.

Acceptance:

1. Domain không phụ thuộc Flutter/Dio.
2. Usecase đủ cho mọi hành động từ UI ticket.

### Phase 2: Mock repository + offline datasource

1. Tách lớp dữ liệu giả thành 2 phần:
	- seed data generator (khởi tạo ban đầu).
	- mutable local datasource (CRUD thật trong app).
2. Cài đặt MockTicketRepositoryImpl đọc/ghi local datasource.
3. Giả lập delay cho các hành động async (200-800ms).
4. Đảm bảo đồng nhất ID, timestamp và lịch sử thay đổi khi create/update/delete.

Acceptance:

1. CRUD chạy được 100% không cần mạng.
2. Dữ liệu không mất trong vòng đời app session.

### Phase 3: Session user và logic "Phiếu của tôi"

1. Tạo nguồn currentAgentId mock (ví dụ agent_1) ở store/session layer.
2. Cập nhật tab logic:
	- My Tickets: assignedAgentId == currentAgentId.
	- Unassigned: assignedAgentId == null.
	- All Tickets: tất cả.
3. Tách tab/filter logic thành method testable trong TicketTabStore.

Acceptance:

1. Tab My Tickets chỉ hiện phiếu đúng agent hiện tại.
2. Chuyển tab không phá filter/search đang active.

### Phase 4: Hoàn thiện Ticket List UI

1. Hoàn thiện top section:
	- tab bar desktop, tab chips mobile, header count.
2. Hoàn thiện search + advanced filter dialog:
	- filter reset, filter badge count, date range.
3. Hoàn thiện table/card view:
	- header và rows scroll ngang đồng bộ.
	- empty state rõ ràng.
4. Hoàn thiện hành động row:
	- tiếp nhận phiếu.
	- xem chi tiết.

Acceptance:

1. Header/row luôn thẳng cột khi bật tắt cột.
2. Tất cả thao tác cập nhật danh sách ngay lập tức.

### Phase 5: Hoàn thiện Create Ticket flow

1. Nối CreateTicketStore -> CreateTicketUseCase.
2. Validate bắt buộc:
	- title, customerName/contact, mô tả tối thiểu (nếu có rule).
3. Khi tạo thành công:
	- lưu local repository.
	- cập nhật TicketTabStore.
	- quay lại list và hiển thị snackbar.
4. Chuẩn hóa dropdown/customer/source/priority theo enum/domain.

Acceptance:

1. Tạo phiếu xong xuất hiện đúng tab tương ứng.
2. Không cần restart app để thấy dữ liệu mới.

### Phase 6: Ticket Detail + Customer History

1. Tạo TicketDetailScreen:
	- metadata, status, priority, assignment, description.
	- comments thread + add comment.
2. Tạo CustomerHistoryScreen:
	- danh sách phiếu theo customerId.
3. Hành động detail:
	- đổi trạng thái.
	- gán/bỏ gán agent.
	- ghi comment.

Acceptance:

1. Mọi thay đổi từ detail phản ánh ngay về list.
2. Điều hướng list -> detail -> history -> back mượt, không mất state chính.

### Phase 7: Offline persistence thật

1. Chuyển dữ liệu mutable từ in-memory sang local db (ưu tiên Sembast).
2. Boot app:
	- nếu local rỗng: seed dữ liệu mock lần đầu.
	- nếu có dữ liệu: load dữ liệu cũ.
3. Tạo migration version đơn giản cho schema local.

Acceptance:

1. Đóng/mở app vẫn giữ dữ liệu đã tạo/chỉnh sửa.
2. Không nhân bản seed data sau mỗi lần mở app.

### Phase 8: UX states + chất lượng

1. Thêm loading/error/empty cho các action chính.
2. Chuẩn hóa localization cho string hiển thị.
3. Chuẩn hóa snackbar/thông báo lỗi.
4. Tối ưu hiệu năng list lớn:
	- builder list, debounce search, tránh rebuild thừa.

Acceptance:

1. Không có thao tác im lặng, user luôn thấy trạng thái.
2. UI responsive tốt mobile/tablet/desktop web.

## 5. Task breakdown theo file

### Domain/Data

1. lib/domain/entity/ticket/*
2. lib/domain/repository/ticket/ticket_repository.dart
3. lib/domain/usecase/ticket/*
4. lib/data/repository/ticket/mock_ticket_repository_impl.dart
5. lib/data/local/mock_data.dart

### Presentation

1. lib/presentation/ticket/store/ticket_tab_store.dart
2. lib/presentation/ticket/store/create_ticket_store.dart
3. lib/presentation/ticket/screens/ticket_list_screen.dart
4. lib/presentation/ticket/screens/create_ticket_screen.dart
5. lib/presentation/ticket/screens/ticket_detail_screen.dart (new)
6. lib/presentation/ticket/screens/customer_ticket_history_screen.dart (new)
7. lib/presentation/ticket/widgets/*

### DI/Route

1. lib/presentation/di/module/store_module.dart
2. lib/domain/di/domain_layer_injection.dart
3. lib/data/di/data_layer_injection.dart
4. lib/utils/routes/routes.dart

## 6. Test checklist

1. Create ticket -> ticket xuất hiện đúng tab.
2. Assign ticket cho currentAgent -> chuyển từ Unassigned sang My Tickets.
3. Unassign -> chuyển ngược lại.
4. Đổi status/priority từ detail -> list cập nhật tức thì.
5. Search + filter + tab hoạt động đồng thời, không conflict.
6. Tắt app mở lại, dữ liệu offline còn nguyên.
7. Không có lỗi layout khi đổi cột, đổi kích thước màn hình.

## 7. Mốc thực thi đề xuất

1. Sprint A (1-2 ngày): Phase 1-3.
2. Sprint B (2-3 ngày): Phase 4-5.
3. Sprint C (2-3 ngày): Phase 6-7.
4. Sprint D (1 ngày): Phase 8 + QA + bugfix.

## 8. Definition of Done

1. Ticket module chạy đầy đủ UI + offline CRUD không cần backend.
2. Luồng My Tickets dựa trên currentAgentId, không hardcode rời rạc trong UI.
3. Dễ thay mock repository bằng API repository mà không đổi logic màn hình.
4. Pass toàn bộ test checklist ở mục 6.
