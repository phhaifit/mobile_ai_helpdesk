# Incremental Flow Plan: Ticket Management Implementation
**Strategy:** Bottom-up development with UI testing checkpoint at each flow

---

## Flow Overview

```
Flow 1: Setup Basic Entity & Enums (No UI)
  ↓
Flow 2: Mock Data Generator (No UI)
  ↓
Flow 3: Repository Interface & Mock Impl (No UI)
  ↓
Flow 4: Use Cases Registration (No UI)
  ↓
Flow 5: Dummy Ticket List Screen (Show hardcoded mock data)
  ↓
Flow 6: Ticket Store + Real Data Binding (Test data in UI)
  ↓
Flow 7: Tab Navigation (My Tickets, Unassigned, All)
  ↓
Flow 8: List Filtering & Search
  ↓
Flow 9: Ticket Detail Screen (View single ticket)
  ↓
Flow 10: Create Ticket Form
  ↓
Flow 11: Edit Ticket Form
  ↓
Flow 12: Delete Ticket with Confirmation
  ↓
Flow 13: Assign Agent Feature
  ↓
Flow 14: Comments/Thread System
  ↓
Flow 15: Advanced Filters
```

---

## Detailed Flows

### **FLOW 1: Setup Basic Entity & Enums**

**Objective:** Create all domain entities and enums (no UI yet)

**Deliverables:**
1. `lib/domain/entity/enums.dart` - All enums
2. `lib/domain/entity/customer/customer.dart`
3. `lib/domain/entity/agent/agent.dart`
4. `lib/domain/entity/comment/comment.dart`
5. `lib/domain/entity/ticket_history/ticket_history.dart`
6. `lib/domain/entity/ticket/ticket.dart`

**Test Method:**
- Verify imports succeed in `main.dart`
- Run `flutter pub get`
- No compile errors

**Time Estimate:** 15 mins

---

### **FLOW 2: Mock Data Generator**

**Objective:** Create mock data generation logic using `faker`

**Deliverables:**
1. `lib/data/local/mock_data.dart` - Static mock data generator
   - Function to generate mock agents (8 items)
   - Function to generate mock customers (15 items)
   - Function to generate mock tickets (50 items)
   - Ensure UTF-8 Vietnamese support

**Code Structure:**
```dart
// lib/data/local/mock_data.dart

class MockDataGenerator {
  static List<Agent> generateAgents() { ... }
  static List<Customer> generateCustomers() { ... }
  static List<Ticket> generateTickets(
    List<Agent> agents,
    List<Customer> customers,
  ) { ... }
}
```

**Test Method:**
- Create a temporary test widget that prints mock data to console
- Verify 8 agents, 15 customers, 50 tickets are generated
- Verify Vietnamese characters render correctly
- Check data structure is valid (all required fields populated)

**Time Estimate:** 20 mins

---

### **FLOW 3: Repository Interface & Mock Implementation**

**Objective:** Create repository interface and mock implementation

**Deliverables:**
1. `lib/domain/repository/ticket/ticket_repository.dart` - Abstract interface
2. `lib/data/repository/ticket/ticket_repository_mock_impl.dart` - Implementation

**Key Methods (implement in order):**
1. `getTickets()` - Get filtered list
2. `getTicketById(String id)` - Get single ticket
3. `createTicket(Ticket ticket)` - Create (with UUID generation)
4. `updateTicket(Ticket ticket)` - Update existing
5. `deleteTicket(String id)` - Delete
6. `getAvailableAgents()` - Get agent list

**Test Method:**
- Create a test Dart file (not a widget test)
- Call each method and verify results
- Check errors are wrapped with `Failure`
- Verify simulated delays work (1 second)

```dart
// lib/data/repository/ticket/ticket_repository_mock_impl_test.dart
void main() {
  final repo = TicketRepositoryMockImpl();
  
  test('getTickets returns list', () async {
    final result = await repo.getTickets();
    expect(result.isRight(), true);
  });
  
  test('createTicket adds new ticket', () async {
    final newTicket = Ticket(...);
    final result = await repo.createTicket(newTicket);
    expect(result.isRight(), true);
  });
}
```

**Time Estimate:** 30 mins

---

### **FLOW 4: Use Cases & DI Setup**

**Objective:** Create all use cases and register in DI

**Deliverables:**
1. All 10 use case files in `lib/domain/usecase/ticket/`
2. Update `lib/data/di/data_layer_injection.dart`
3. Update `lib/domain/di/domain_layer_injection.dart`
4. Update `lib/presentation/di/presentation_layer_injection.dart`

**Use Cases (minimal implementation):**
- GetTicketsUseCase
- GetTicketByIdUseCase
- CreateTicketUseCase
- UpdateTicketUseCase
- DeleteTicketUseCase
- GetAvailableAgentsUseCase
- AssignAgentUseCase
- AddCommentUseCase
- GetCustomerHistoryUseCase
- UpdateTicketStatusUseCase

**Test Method:**
- Dart test: Call GetTicketsUseCase and verify result
- Log output to console
- Verify DI properly injects dependencies

```dart
void main() {
  setUp(() {
    setupServiceLocator();
  });
  
  test('GetTicketsUseCase returns tickets', () async {
    final usecase = getIt<GetTicketsUseCase>();
    final result = await usecase.call(GetTicketsParams());
    expect(result.isRight(), true);
  });
}
```

**Time Estimate:** 25 mins

---

### **FLOW 5: Dummy Ticket List Screen (Hardcoded)**

**Objective:** Create a basic ticket list screen showing hardcoded mock tickets

**Deliverables:**
1. `lib/presentation/ticket/screens/ticket_list_screen.dart` (basic version)
2. Add route to `lib/utils/routes/routes.dart`
3. Update navigation in `my_app.dart`

**UI Components:**
- Scaffold with AppBar
- ListView showing 50 mock tickets
- Each item shows:
  - Ticket ID
  - Title
  - Status (color badge)
  - Customer name
  - Assigned agent

**Test Method:**
- Run app
- Navigate to ticket list screen
- Verify 50 tickets display
- Verify scroll works
- Verify colors and text render correctly

**Code Structure:**
```dart
// lib/presentation/ticket/screens/ticket_list_screen.dart
class TicketListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mockTickets = MockDataGenerator.generateTickets(...);
    
    return Scaffold(
      appBar: AppBar(title: Text('Tickets')),
      body: ListView.builder(
        itemCount: mockTickets.length,
        itemBuilder: (_, i) => TicketCardWidget(ticket: mockTickets[i]),
      ),
    );
  }
}
```

**Time Estimate:** 20 mins

---

### **FLOW 6: Ticket Card Widget & Mock Store (Basic)**

**Objective:** Create reusable ticket card widget and basic MobX store

**Deliverables:**
1. `lib/presentation/ticket/widgets/ticket_card_widget.dart`
2. `lib/presentation/ticket/stores/ticket_list_store.dart` (basic)

**Ticket Card Widget:**
- Displays: ID, Title, Status badge, Priority, Customer, Agent, Created date
- Tap to navigate to detail screen
- Nice UI with proper spacing and colors

**Basic Ticket List Store (MobX):**
```dart
@observable
List<Ticket> tickets = [];

@action
Future<void> loadTickets() async {
  final result = await getIt<GetTicketsUseCase>().call(GetTicketsParams());
  result.fold(
    (failure) => print('Error: ${failure.message}'),
    (data) => tickets = data,
  );
}
```

**Test Method:**
- Run app
- Verify ticket card displays all fields correctly
- Click on a ticket (navigate if implemented)
- Verify MobX observer works (update list dynamically)

**Time Estimate:** 25 mins

---

### **FLOW 7: Ticket List Store + Real Data Binding**

**Objective:** Wire up store to repository and test real data flow

**Deliverables:**
1. Complete `TicketListStore` with MobX
   - `loadTickets()` action
   - `isLoading` computed
   - `errorMessage` observable
   - `filteredTickets` computed (for future filtering)
2. Update `TicketListScreen` to use store
3. Register store in DI

**Store Features:**
```dart
@observable
ObservableFuture<void> fetchFuture = ObservableFuture.value(null);

@observable
List<Ticket> tickets = [];

@observable
String? errorMessage;

@computed
bool get isLoading => fetchFuture.status == FutureStatus.pending;

@action
Future<void> loadTickets() async {
  errorMessage = null;
  fetchFuture = ObservableFuture(_load());
  await fetchFuture;
}

Future<void> _load() async {
  final result = await getIt<GetTicketsUseCase>().call(GetTicketsParams());
  result.fold(
    (failure) => errorMessage = failure.message,
    (data) => tickets = data,
  );
}
```

**Update Screen:**
```dart
@override
void initState() {
  super.initState();
  _store = getIt<TicketListStore>();
  _store.loadTickets();
}

@override
Widget build(BuildContext context) {
  return Observer(
    builder: (_) {
      if (_store.isLoading) return LoadingWidget();
      if (_store.errorMessage != null) return ErrorWidget(_store.errorMessage);
      return ListView.builder(
        itemCount: _store.tickets.length,
        itemBuilder: (_, i) => TicketCardWidget(ticket: _store.tickets[i]),
      );
    },
  );
}
```

**Test Method:**
- Run app
- Verify loading spinner shows for ~1 second (simulated delay)
- Verify 50 tickets load and display
- Verify screen is responsive during loading

**Time Estimate:** 20 mins

---

### **FLOW 8: Tab Navigation (My Tickets, Unassigned, All)**

**Objective:** Implement 3-tab interface

**Deliverables:**
1. Update `TicketListStore`:
   - `myTickets` computed (filter by current agent)
   - `unassignedTickets` computed (where assignedAgentId == null)
   - `allTickets` observable (all tickets)
   - `selectedTab` observable (0, 1, 2)
2. Update `TicketListScreen` with DefaultTabController

**Tab Logic:**
- Tab 0: My Tickets (assume current user is Agent ID "agent_1")
- Tab 1: Unassigned (assignedAgentId == null)
- Tab 2: All Tickets

**Test Method:**
- Run app
- Verify 3 tabs display with badge counters
- Swipe/tap to switch tabs
- Verify correct tickets show in each tab
- Verify data persists when switching tabs

**Time Estimate:** 25 mins

---

### **FLOW 9: Search Widget**

**Objective:** Add search box that filters tickets by title/ID

**Deliverables:**
1. Update `TicketListStore`:
   - `searchQuery` observable
   - `getFilteredTickets()` computed
2. Add search TextField in UI
3. Update store method to filter in-memory list

**Search Implementation:**
```dart
@observable
String searchQuery = '';

@computed
List<Ticket> get filteredTickets {
  if (searchQuery.isEmpty) return tickets;
  return tickets.where((t) {
    return t.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
           t.id.toLowerCase().contains(searchQuery.toLowerCase()) ||
           t.customerName.toLowerCase().contains(searchQuery.toLowerCase());
  }).toList();
}

@action
void updateSearchQuery(String query) {
  searchQuery = query;
}
```

**Test Method:**
- Run app
- Type in search box
- Verify list filters in real-time
- Clear search and verify all tickets return

**Time Estimate:** 15 mins

---

### **FLOW 10: Status & Priority Filter Dropdowns**

**Objective:** Add filter dropdowns for status and priority

**Deliverables:**
1. Update `TicketListStore`:
   - `selectedStatus` observable
   - `selectedPriority` observable
   - Update `getFilteredTickets()` computed to include filters
2. Add dropdowns to UI

**Filter Logic:**
```dart
@observable
TicketStatus? selectedStatus;

@observable
TicketPriority? selectedPriority;

@computed
List<Ticket> get filteredTickets {
  var result = tickets;
  
  if (searchQuery.isNotEmpty) {
    result = result.where((t) => t.title.toLowerCase()
      .contains(searchQuery.toLowerCase())).toList();
  }
  
  if (selectedStatus != null) {
    result = result.where((t) => t.status == selectedStatus).toList();
  }
  
  if (selectedPriority != null) {
    result = result.where((t) => t.priority == selectedPriority).toList();
  }
  
  return result;
}

@action
void setStatusFilter(TicketStatus? status) => selectedStatus = status;

@action
void setPriorityFilter(TicketPriority? priority) => selectedPriority = priority;

@action
void resetFilters() {
  selectedStatus = null;
  selectedPriority = null;
  searchQuery = '';
}
```

**Test Method:**
- Run app
- Test status filter (should show only tickets with selected status)
- Test priority filter
- Test combination of filters
- Test reset button

**Time Estimate:** 20 mins

---

### **FLOW 11: Ticket Detail Screen (View Only)**

**Objective:** Create detail screen showing full ticket info

**Deliverables:**
1. `lib/presentation/ticket/screens/ticket_detail_screen.dart`
2. `lib/presentation/ticket/stores/ticket_detail_store.dart`
3. Add route and navigation

**Detail Screen Layout:**
- AppBar with ticket ID
- Header section (title, status, priority, created date)
- Customer info panel
- Description section
- (Comments section - can be empty for now)

**Store:**
```dart
@observable
Ticket? ticket;

@observable
String? errorMessage;

@observable
ObservableFuture<void> fetchFuture = ObservableFuture.value(null);

@computed
bool get isLoading => fetchFuture.status == FutureStatus.pending;

@action
Future<void> loadTicket(String ticketId) async {
  errorMessage = null;
  fetchFuture = ObservableFuture(_load(ticketId));
  await fetchFuture;
}

Future<void> _load(String ticketId) async {
  final result = await getIt<GetTicketByIdUseCase>().call(ticketId);
  result.fold(
    (failure) => errorMessage = failure.message,
    (data) => ticket = data,
  );
}
```

**Navigation:**
From ticket list → tap card → navigate to detail with ID parameter

**Test Method:**
- Run app
- Tap on a ticket in the list
- Verify detail screen shows with loading state
- Verify all ticket information displays correctly
- Navigate back

**Time Estimate:** 25 mins

---

### **FLOW 12: Create Ticket Form**

**Objective:** Build form to create new ticket

**Deliverables:**
1. `lib/presentation/ticket/screens/ticket_create_screen.dart`
2. `lib/presentation/ticket/stores/ticket_create_store.dart`
3. Add route and FAB button navigation

**Form Fields:**
- Title (TextFormField, required)
- Description (TextFormField multi-line, required)
- Customer dropdown
- Priority dropdown
- Category dropdown
- Submit button

**Store:**
```dart
@observable
String title = '';

@observable
String description = '';

@observable
String? selectedCustomerId;

@observable
TicketPriority? selectedPriority;

@observable
TicketCategory? selectedCategory;

@observable
bool isSubmitting = false;

@observable
String? errorMessage;

@action
Future<void> createTicket() async {
  if (title.isEmpty || description.isEmpty) {
    errorMessage = 'Please fill all required fields';
    return;
  }
  
  isSubmitting = true;
  final newTicket = Ticket(
    id: '', // Will be generated by repo
    title: title,
    description: description,
    customerId: selectedCustomerId!,
    priority: selectedPriority ?? TicketPriority.medium,
    category: selectedCategory ?? TicketCategory.general,
    status: TicketStatus.open,
    // ... other required fields
  );
  
  final result = await getIt<CreateTicketUseCase>().call(newTicket);
  isSubmitting = false;
  
  result.fold(
    (failure) => errorMessage = failure.message,
    (data) {
      // Navigate back with success
      Get.back(); // or alternative navigation
    },
  );
}
```

**Test Method:**
- Run app
- Click FAB button
- Fill in form
- Submit
- Verify success notification
- Verify new ticket appears in list
- Navigate back to main list

**Time Estimate:** 30 mins

---

### **FLOW 13: Delete Ticket**

**Objective:** Add delete functionality with confirmation

**Deliverables:**
1. Add delete action to `TicketListStore`
2. Add delete button to ticket card
3. Show confirmation dialog before deleting
4. Remove ticket from list after deletion

**Store Action:**
```dart
@action
Future<void> deleteTicket(String ticketId) async {
  final result = await getIt<DeleteTicketUseCase>().call(ticketId);
  result.fold(
    (failure) => errorMessage = failure.message,
    (_) {
      // Remove from local list
      tickets.removeWhere((t) => t.id == ticketId);
    },
  );
}
```

**UI Confirmation:**
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Confirm Delete'),
    content: Text('Are you sure?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          store.deleteTicket(ticket.id);
          Navigator.pop(context);
        },
        child: Text('Delete'),
      ),
    ],
  ),
);
```

**Test Method:**
- Run app
- Long-press or tap delete button on a ticket
- Confirm deletion
- Verify ticket disappears from list
- Verify in-memory state updated

**Time Estimate:** 15 mins

---

### **FLOW 14: Update Ticket Status**

**Objective:** Add ability to change ticket status from detail screen

**Deliverables:**
1. Add status dropdown to detail screen
2. Update `TicketDetailStore` with status update action
3. Show confirmation before status change

**Store Action:**
```dart
@action
Future<void> updateStatus(TicketStatus newStatus) async {
  final result = await getIt<UpdateTicketStatusUseCase>()
    .call(UpdateTicketStatusParams(
      ticketId: ticket!.id,
      newStatus: newStatus,
    ));
  
  result.fold(
    (failure) => errorMessage = failure.message,
    (_) {
      ticket = ticket!.copyWith(status: newStatus);
      // Refresh from repo if needed
      loadTicket(ticket!.id);
    },
  );
}
```

**Test Method:**
- Run app
- Open ticket detail
- Change status via dropdown
- Verify status updates in detail view
- Go back to list and verify status changed there too

**Time Estimate:** 20 mins

---

### **FLOW 15: Assign Agent**

**Objective:** Assign/reassign agents to tickets

**Deliverables:**
1. Add agent assignment UI to detail screen (button + bottom sheet)
2. Update `TicketDetailStore` with assignment action
3. Load agent list when opening assignment modal

**Store:**
```dart
@observable
List<Agent> availableAgents = [];

@action
Future<void> loadAgents() async {
  final result = await getIt<GetAvailableAgentsUseCase>().call(null);
  result.fold(
    (failure) => errorMessage = failure.message,
    (data) => availableAgents = data,
  );
}

@action
Future<void> assignAgent(String agentId) async {
  final result = await getIt<AssignAgentUseCase>()
    .call(AssignAgentParams(
      ticketId: ticket!.id,
      agentId: agentId,
    ));
  
  result.fold(
    (failure) => errorMessage = failure.message,
    (_) {
      loadTicket(ticket!.id); // Refresh
    },
  );
}
```

**Test Method:**
- Run app
- Open unassigned ticket
- Click "Assign Agent" button
- Select agent from list
- Verify ticket's assigned agent updates
- Go back to list and verify change persisted

**Time Estimate:** 25 mins

---

### **FLOW 16: Comments System (Basic)**

**Objective:** Display comments and add new comments

**Deliverables:**
1. `lib/presentation/ticket/widgets/comment_widget.dart`
2. `lib/presentation/ticket/widgets/comment_thread.dart`
3. Update `TicketDetailStore` with comment actions
4. Add comment input to detail screen

**Store:**
```dart
@observable
List<Comment> comments = [];

@action
Future<void> loadComments(String ticketId) async {
  final result = await getIt<GetTicketCommentsUseCase>().call(ticketId);
  result.fold(
    (failure) => errorMessage = failure.message,
    (data) => comments = data,
  );
}

@action
Future<void> addComment(String content) async {
  final newComment = Comment(
    id: '', // Generated by repo
    ticketId: ticket!.id,
    authorId: 'current_user', // From auth
    content: content,
    createdAt: DateTime.now(),
  );
  
  final result = await getIt<AddCommentUseCase>()
    .call(AddCommentParams(ticketId: ticket!.id, comment: newComment));
  
  result.fold(
    (failure) => errorMessage = failure.message,
    (data) {
      comments.add(data);
      // Clear input field
    },
  );
}
```

**Test Method:**
- Run app
- Open ticket detail
- Verify existing comments load and display
- Add a new comment
- Verify it appears in thread immediately
- Refresh page and verify comment persists

**Time Estimate:** 30 mins

---

### **FLOW 17: Advanced Filters Panel (Collapsible)**

**Objective:** Build collapsible filter panel with all filters

**Deliverables:**
1. `lib/presentation/ticket/widgets/advanced_filter_panel.dart`
2. Update TicketListStore with all filter observables
3. Integrate into ticket list screen

**Filters Include:**
- Search
- Status dropdown
- Priority dropdown
- Customer dropdown
- Category dropdown
- Source dropdown
- Date picker (created date)
- Reset button

**Test Method:**
- Run app
- Click filter button to expand panel
- Test each filter independently
- Test combination of filters
- Verify count updates on tab badges
- Test collapse/expand animation

**Time Estimate:** 30 mins

---

## Testing Checklist Per Flow

Each flow should pass these checks before moving to next:

```
✅ Code compiles without errors
✅ App runs without crashes
✅ UI renders correctly
✅ Data displays accurately
✅ No console errors or warnings
✅ Responsive to user input
✅ Loading states show properly
✅ Error states show properly
✅ Navigation works as expected
```

---

## Estimated Total Time

| Flow | Time | Cumulative |
|------|------|-----------|
| 1: Entities | 15 min | 15 min |
| 2: Mock Data | 20 min | 35 min |
| 3: Repository | 30 min | 65 min |
| 4: Use Cases & DI | 25 min | 90 min |
| 5: Dummy UI | 20 min | 110 min |
| 6: Card Widget & Store | 25 min | 135 min |
| 7: Real Data Binding | 20 min | 155 min |
| 8: Tabs | 25 min | 180 min |
| 9: Search | 15 min | 195 min |
| 10: Filter Dropdowns | 20 min | 215 min |
| 11: Detail Screen | 25 min | 240 min |
| 12: Create Form | 30 min | 270 min |
| 13: Delete | 15 min | 285 min |
| 14: Status Update | 20 min | 305 min |
| 15: Assign Agent | 25 min | 330 min |
| 16: Comments | 30 min | 360 min |
| 17: Advanced Filters | 30 min | 390 min |

**Total: ~6.5 hours of incremental development**

---

## Key Principles

1. **Test Early & Often:** UI validation at every step
2. **Small Increments:** Each flow is independent and testable
3. **No Skipping:** Complete one flow before starting next
4. **Real Data:** Use actual mock repo data, not hardcoded
5. **Error Handling:** Test both success and error states
6. **Performance:** Monitor for delays or janky animations

