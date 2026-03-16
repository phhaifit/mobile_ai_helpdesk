# Detailed Implementation Plan: [Phase[+] 1] Ticket Management UI & Offline Flow
**Created: 2026-03-14**
## 1. Overview & Objectives
Build a high-fidelity UI and offline simulation for the core Ticket Management system of the Mobile AI Helpdesk. The focus is on implementing accurate user interfaces reflecting the web dashboard (My Tickets, Unassigned, All Tickets), managing state efficiently using the project's boilerplate standards, and simulating full CRUD (Create, Read, Update, Delete) operations and ticket assignments using mock data.
---
## 2. Architecture & Tech Stack
- **Framework:** Flutter
- **Architecture:** Clean Architecture (Data → Domain → Presentation)
- **State Management:** MobX (as per flutter_boilerplate_project structure)
- **Local Data:** Static JSON Mocking & `faker` library to generate realistic agents, customers, and ticket content
- **Dependency Injection:** GetIt (Service Locator)
---
## 3. Work Breakdown Structure (WBS)
### Task 1: Data & Domain Layer (Mocking Logic)
#### 1.1 Entities & Models
- Define `Ticket`, `Agent`, `Customer`, `Comment`, and `TicketHistory` entities
- Include Enums:
- `TicketStatus` (Open, In-progress, Resolved, Closed)
- `TicketPriority` (Low, Medium, High, Urgent)
- `TicketCategory` (Technical, Billing, General, etc.)
#### 1.2 Repository Interface
- Define `TicketRepository` in the domain layer with abstract methods:
- `Future<List<Ticket>> getTickets({required TicketStatus? status, String? filter})`
- `Future<Ticket> getTicketById(String id)`
- `Future<Ticket> createTicket(Ticket ticket)`
- `Future<Ticket> updateTicket(Ticket ticket)`
- `Future<void> deleteTicket(String id)`
- `Future<void> assignAgent(String ticketId, String agentId)`
- `Future<void> addComment(String ticketId, Comment comment)`
#### 1.3 Mock Implementation
- Implement `MockTicketRepositoryImpl` in the data layer
- Maintain mutable `List<Ticket>` in memory for session-persistent CRUD operations
- Use `faker` library for generating realistic data
- Simulate network latency with `Future.delayed(Duration(seconds: 1))`
#### 1.4 Use Cases
Implement the following use cases:
- `GetTicketsUseCase` - Retrieve tickets with optional filters (status, agent assignment)
- `GetTicketByIdUseCase` - Fetch single ticket details
- `CreateTicketUseCase` - Create new ticket with validation
- `UpdateTicketUseCase` - Update ticket details
- `DeleteTicketUseCase` - Delete a ticket
- `AssignAgentUseCase` - Assign or unassign a CS agent
- `AddCommentUseCase` - Add comment/internal note to ticket
- `GetCustomerHistoryUseCase` - Retrieve all tickets for a specific customer
---
### Task 2: UI Development (High Fidelity)
#### 2.1 Ticket List Screen (Main Dashboard)
**Layout:**
- DefaultTabController with 3 tabs:
1. "My Tickets - Assigned to current user
2. Unassigned - Not assigned to anyone
3. All Tickets - Complete list
**Components:**
- **Filter Panel (Advanced Filtering):**
- Search box: Search by title
- Dropdown: "Select Status: Open, In-progress, Resolved, Closed
- Dropdown: Select Priority: Low, Medium, High
- Dropdown: Search Customer
- Dropdown: Select Source/Channel
- Dropdown: Creator/Author
- Dropdown: Select Ticket Type/Category
- Date Picker: Created Date
- Button: Reset Filters
- Collapsible filter panel with minimize/expand toggle
- **Tab Bar Widgets:**
- 3 main tabs:
1. My Tickets
2. Unassigned
3. All Tickets
- Badge counter on each tab showing ticket count
- **Ticket List Items:**
- Ticket title
- Status badge (color-coded)
- Priority indicator (icon + label)
- Customer name
- Request receiving source
- Assigned agent (or "Unassigned" label)
- Created date
- Unread count badge (if applicable)
- **Empty State UI:**
- Illustration for empty list
- Action button (e.g., "Create Ticket")
- **FAB Button:**
- Floating action button to create new ticket
#### 2.2 Ticket Creation Screen
**Form Fields:**
- Title (required, text input)
- Description (required, multi-line text area)
- Customer selection (dropdown with search)
- Priority (dropdown: Low, Medium, High, Urgent)
- Category (dropdown: Technical, Billing, etc.)
- Attachments (optional file picker)
**Features:**
- Form validation with error messages
- "Create" button with loading state (spinner)
- "Cancel" button
- Success confirmation with option to view ticket or create another
#### 2.3 Ticket Detail Screen
**Layout Structure:**
1. **AppBar:**
- Ticket ID/Title
- Status badge
- Action menu (edit, delete, mark as...)
2. **Header Section:**
- Full ticket title
- Ticket ID
- Created date & time
- Priority tag (color-coded)
- Category label
3. **Assignment Section:**
- Current assigned agent (with avatar)
- Reassign button → Bottom sheet with agent list
- Unassign button (if assigned)
- Edit status dropdown
4. **Customer Info Panel:**
- Customer name
- Contact information (phone, email)
- Link to "Customer Ticket History"
5. **Description Section:**
- Full ticket description
- Attachments display (if any)
6. **Comments/Thread Section:**
- Scrollable list of comments
- Each comment shows:
- Author avatar
- Author name
- Timestamp
- Comment text
- Optional: reply/edit/delete actions
- Input field at bottom to add new comment
- Send button
7. **Ticket History Tab (Optional):**
- Timeline of status changes
- Who changed it and when
#### 2.4 Customer Ticket History Screen
**Layout:**
- Header: Customer name and contact info
- Timeline or list view of all tickets:
- Ticket ID
- Title
- Status
- Created date
- Last updated date
- Quick view button to open full ticket detail
---
### Task 3: Offline Flow & Simulation
#### 3.1 CRUD Operations
- When a user creates a ticket:
- Update MobX store immediately (optimistic update)
- Add to in-memory MockTicketRepository list
- Show success toast/snackbar
- When a user edits a ticket:
- Update store and repository in real-time
- Reflect changes instantly in the UI
- When a user deletes a ticket:
- Remove from list with confirmation dialog
- Show undo option (optional)
#### 3.2 Simulated Delays
- Wrap all repository calls in `Future.delayed(Duration(seconds: 1))`
- Display loading spinners during the simulated delay
- Show network-like behavior for realistic UX testing
#### 3.3 Dynamic State Updates
- **Assignment Logic:**
- When an agent is assigned to an unassigned ticket:
- Move ticket from "Unassigned" tab to "My Tickets" tab
- Update agent field in real-time
- Show success notification
- **Status Changes:**
- When ticket status changes:
- Update status badge immediately
- Move ticket between filter views dynamically
- Log change in ticket history
#### 3.4 Search & Filter Logic
- Search by ticket ID, title, or customer name
- Filter by status across all tabs
- Local search using `.contains()` on in-memory data
- Search results update in real-time
