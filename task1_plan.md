# Task 1 Plan - Data and Domain Layer (Mocking Logic)

Ngay lap: 2026-03-15
Pham vi: Chi cho Task 1 trong Ticket_Management_Plan.md

## 1. Muc tieu

Xay dung day du Data + Domain cho ticket management de UI o Task 2 co the dung ngay voi mock data offline, bao gom:
- Entity va enum cho ticket lifecycle
- Repository interface theo Clean Architecture
- Mock repository co CRUD + assign + comment + simulated delay
- Use case day du cho cac thao tac can dung
- Dang ky DI cho data va domain

## 2. Nguyen tac bat buoc

- Tuan thu 3 layer: Presentation -> Domain -> Data
- Domain phai pure Dart, khong import Flutter, Dio, Sembast
- Repository interface nam o domain, implementation nam o data
- Repository implementation tra ve Either<Failure, T>, khong throw ra ngoai
- Moi call tu repository mock deu co Future.delayed 1 giay de mo phong network
- Dat ten file theo snake_case, class theo PascalCase
- Neu co model su dung json_serializable hoac MobX store thi chay build_runner

## 3. Scope ky thuat cua Task 1

### 3.1 Domain entities va enums
Tao moi cac entity trong nhom ticket:
- Ticket
- Agent
- Customer
- Comment
- TicketHistory
- TicketStatus enum
- TicketPriority enum
- TicketCategory enum

De xuat thu muc:
- lib/domain/entity/ticket/ticket.dart
- lib/domain/entity/ticket/agent.dart
- lib/domain/entity/ticket/customer.dart
- lib/domain/entity/ticket/comment.dart
- lib/domain/entity/ticket/ticket_history.dart
- lib/domain/entity/ticket/ticket_enums.dart

### 3.2 Repository interface
Tao interface TicketRepository trong domain.

Luu y de dong bo voi boilerplate hien tai, uu tien dinh nghia theo Either<Failure, T>:
- getTickets
- getTicketById
- createTicket
- updateTicket
- deleteTicket
- assignAgent
- addComment
- getCustomerHistory

De xuat file:
- lib/domain/repository/ticket/ticket_repository.dart

### 3.3 Data models va mapper
Tao model o data layer de phuc vu mock + mapping voi entity.

De xuat file:
- lib/data/models/ticket/ticket_model.dart
- lib/data/models/ticket/agent_model.dart
- lib/data/models/ticket/customer_model.dart
- lib/data/models/ticket/comment_model.dart
- lib/data/models/ticket/ticket_history_model.dart

Neu can toJson/fromJson thi dung json_serializable va mapping ro rang model <-> entity.

### 3.4 Mock repository implementation
Implement TicketRepositoryImpl (mock in-memory) voi cac yeu cau:
- Giu mutable list in-memory cho tickets, agents, customers
- Khoi tao mock data bang faker
- Delay 1 giay cho moi method
- CRUD day du + assign/unassign + add comment
- Cap nhat ticket history khi doi status/agent
- Loc ticket theo status, filter text, customer
- Dong bo truong updatedAt

De xuat file:
- lib/data/repository/ticket/ticket_repository_impl.dart
- lib/data/local/ticket/ticket_mock_seed.dart

### 3.5 Use cases
Tao tung use case rieng, moi file 1 hanh dong:
- get_tickets_usecase.dart
- get_ticket_by_id_usecase.dart
- create_ticket_usecase.dart
- update_ticket_usecase.dart
- delete_ticket_usecase.dart
- assign_agent_usecase.dart
- add_comment_usecase.dart
- get_customer_history_usecase.dart

De xuat thu muc:
- lib/domain/usecase/ticket/

## 4. Ke hoach thuc thi theo thu tu

1. Khao sat code hien tai
- Kiem tra xem ticket feature da co file nao chua de tranh trung lap
- Kiem tra base class UseCase, Failure, NetworkExceptions, typedef Either

2. Tao enums va entities
- Tao enum truoc de entities dung chung
- Dinh nghia cac field toi thieu phuc vu UI Task 2 (title, status, priority, assignee, createdAt, comments, history)

3. Tao repository interface
- Chot signatures theo Either<Failure, T>
- Them params cho filter linh hoat (status, query, assigneeId, customerId)

4. Tao models + mapping
- Dam bao mapper 2 chieu model <-> entity
- Chuan hoa parse DateTime va list lồng nhau (comments, history)

5. Implement mock repository
- Seed du lieu ban dau bang faker
- Viet logic CRUD va assign/comment
- Them helper private cho lookup, validation, copy/update list

6. Tao use cases
- Moi use case goi 1 method repository
- Khong chen business logic vao use case, chi orchestration nhe

7. Dang ky DI
- Data layer: register repository implementation
- Domain layer: register 8 use case
- Kiem tra service locator bootstrap khong loi

8. Validate
- Chay flutter analyze
- Chay flutter test (neu co test lien quan)
- Chay build_runner neu da dung json_serializable

## 5. Definition of Done

- Day du entities, enums, repository interface, repository impl mock, use cases
- Tat ca import dependencies dung layer
- Khong co loi analyze moi do Task 1 tao ra
- Cac method repository tra ve Either<Failure, T>
- Simulated delay 1 giay cho toan bo repository calls
- Mock data tao du de hien thi 3 tab o Task 2 (my, unassigned, all)
- DI da register day du va resolve duoc trong runtime

## 6. Ranh gioi ngoai pham vi Task 1

- Chua lam UI man hinh list/detail/create/history
- Chua lam widget tree markdown cho Task 4
- Chua toi uu animation, style, responsive UI

## 7. Risk va cach giam thieu

- Risk: Signature repository trong plan goc khac boilerplate (co/khong Either)
  - Mitigation: Chuan hoa theo Either<Failure, T> de khop kien truc du an

- Risk: Model/entity trung lap voi code da co san
  - Mitigation: Khao sat truoc, tai su dung neu da ton tai

- Risk: Faker sinh data khong on dinh cho test
  - Mitigation: Seed gia tri co kiem soat cho cac case can xac dinh

## 8. Prompt san sang cho agent code

Muc tieu: Implement Task 1 (Data + Domain Mocking) cho ticket management theo file task1_plan.md.

Yeu cau thuc hien:
- Tao entities, enums, repository interface, mock repository impl, 8 use cases, va cap nhat DI
- Tuan thu Clean Architecture va Flutter boilerplate conventions
- Repository implementation phai tra ve Either<Failure, T> va co Future.delayed 1 giay cho moi method
- Su dung faker de seed du lieu mau cho tickets, agents, customers
- Khong code UI trong task nay
- Sau khi code xong, chay flutter analyze va bao cao cac loi (neu co)

Dau ra mong doi:
- Danh sach file da tao/sua
- Tom tat logic chinh cua mock repository
- Ket qua analyze/build_runner/test co chay duoc hay khong
