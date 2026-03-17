# Customer Management Widget Tree Documentation

## Overview

This document provides a comprehensive widget tree structure for the Customer Management module in the mobile_ai_helpdesk Flutter application. The module implements a responsive architecture that adapts to both mobile (< 600px) and desktop (≥ 600px) screen sizes.

**Key Location:** `lib/presentation/customer_management/`

### Module Components

- **Screens:** 4 main screens for CRUD operations
- **Store:** MobX-based state management (`customer_store.dart`)
- **Widgets:** Reusable components (CustomerCard, CustomerFilterSheet, etc.)
- **Architecture:** Clean Architecture (domain/data/presentation layers)

---

## Responsive Pattern

All screens in the customer management module follow a **two-parameter responsive pattern**:

```dart
final bool showAppBar;        // true = mobile view with Scaffold, false = desktop panel
final VoidCallback? onBack;   // callback for desktop back navigation
```

**Mobile View (showAppBar = true):**

- Full screen with Scaffold + AppBar
- Navigation via Navigator.push
- Complete UI rendering

**Desktop View (showAppBar = false):**

- Panel rendering without Scaffold
- Navigation via callback delegation
- Condensed layout for side panel display

---

## 1. CustomerListScreen

**File:** `lib/presentation/customer_management/customer_list_screen.dart`

**Purpose:** Main list view displaying all customers with search, filtering, and action capabilities.

### Parameters

```dart
const CustomerListScreen({
  this.onMenuTap,                    // VoidCallback? - Hamburger menu tap
  this.onCustomerSelected,           // Function(Customer)? - Customer tile selection
  this.onAddCustomer,                // VoidCallback? - Add button tap
  this.onEditCustomer,               // Function(Customer)? - Edit action
  this.onMergeCustomer,              // VoidCallback? - Merge action
})
```

### Widget Tree

```
Scaffold
├── backgroundColor: AppColors.backgroundGrey
├── body: SafeArea
│   └── Column (mainAxisSize: max)
│       ├── _buildHeader()
│       │   └── Container (color: white)
│       │       └── Column
│       │           ├── Row (header with title + Add button)
│       │           │   ├── GestureDetector (menu icon)
│       │           │   ├── Text ("Danh sách khách hàng")
│       │           │   └── _buildAddButton()
│       │           │
│       │           ├── Observer
│       │           │   └── Text (total customer count)
│       │           │
│       │           ├── SingleChildScrollView (horizontal)
│       │           │   └── Row (action buttons)
│       │           │       ├── _buildActionButton (Export Excel)
│       │           │       ├── _buildActionButton (Actions dropdown)
│       │           │       └── _buildActionButton (Labels)
│       │           │
│       │           └── Row (search + filter)
│       │               ├── Expanded
│       │               │   └── TextField (search input)
│       │               └── Observer
│       │                   └── InkWell (filter button)
│       │
│       ├── _buildTabBar()
│       │   └── TabBar (2 tabs)
│       │       ├── Tab ("Khách hàng" - Active)
│       │       └── Tab ("Bị chặn" - Blocked)
│       │
│       └── Expanded
│           └── TabBarView
│               ├── _buildCustomerTab() (active/unblocked)
│               │   └── Observer
│               │       └── ListView.builder
│               │           └── CustomerCard (tap: onCustomerSelected)
│               │
│               └── _buildBlockedTab() (blocked customers)
│                   └── Observer
│                       └── ListView.builder
│                           └── CustomerCard (tap: onCustomerSelected)
```

### Key Features

- **Tab-based filtering:** Active customers vs. Blocked customers
- **Search functionality:** Real-time search with observer pattern
- **Filter sheet:** Bottom sheet for advanced filtering (tags)
- **Action buttons:** Export, bulk actions, labels management
- **CustomerCard:** Reusable tile widget for each customer
- **State management:** MobX observers for reactive UI updates

### State Variables

```dart
final CustomerStore _store;              // Injected via service locator
final TextEditingController _searchController;
late TabController _tabController;
```

---

## 2. CustomerDetailScreen

**File:** `lib/presentation/customer_management/customer_detail_screen.dart`

**Purpose:** Display detailed information about a single customer with edit and action capabilities.

### Parameters

```dart
const CustomerDetailScreen({
  required this.customer,                // Customer - Customer data
  required this.store,                   // CustomerStore
  this.showAppBar = true,                // bool - Responsive flag (mobile/desktop)
  this.onBack,                           // VoidCallback? - Desktop navigation callback
  this.onEdit,                           // VoidCallback? - Edit action callback
})
```

### Widget Tree

**Mobile View (showAppBar = true):**

```
Scaffold
├── backgroundColor: AppColors.backgroundGrey
├── appBar: _buildAppBar()
│   └── AppBar with back button + edit action
│
└── body: SingleChildScrollView
    └── Column
        ├── _buildCustomerCard()
        │   └── Container with avatar, name, status
        │
        ├── _buildTagsSection()
        │   └── Tag pills display
        │
        ├── _buildContactInfoSection()
        │   └── Email, Phone, Zalo, Messenger info rows
        │
        ├── _buildSupportTickets() (if ticket exists)
        │   └── Support ticket list
        │
        └── SizedBox (bottom padding)
```

**Desktop View (showAppBar = false):**

```
SingleChildScrollView
├── padding: all(12)
└── Column (mainAxisSize: max)
    ├── _buildBackButton()
    │   └── GestureDetector -> onBack()
    │
    ├── _buildCustomerCard()
    ├── _buildTagsSection()
    ├── _buildContactInfoSection()
    │
    ├── _buildSupportTickets() (if exists)
    │
    └── SizedBox (bottom padding)
```

### Key Sections

**Customer Card (`_buildCustomerCard`)**

```
Container (background: white, rounded)
├── Row
│   ├── CircleAvatar
│   │   └── initials or image
│   │
│   └── Column (customer info)
│       ├── Text (fullName)
│       ├── Text (status - active/blocking/etc)
│       ├── Text (last contact info)
│       └── Row (action buttons)
│           ├── Edit button -> onEdit()
│           └── Delete button -> delete confirmation
```

**Tags Section (`_buildTagsSection`)**

```
Column (header + tags)
├── Text ("Nhãn")
└── Wrap (tag pills)
    └── For each tag: Chip widget
```

**Contact Info Section (`_buildContactInfoSection`)**

```
Column (header + info rows)
├── Text ("Thông tin liên hệ")
└── For each contact (email, phone, zalo, messenger):
    └── Row
        ├── Icon
        └── GestureDetector
            ├── Text (contact value)
            └── onTap: update/open modal
```

**Support Tickets Section (`_buildSupportTickets`)**

```
Column (header + ticket list)
├── Text ("Yêu cầu hỗ trợ")
└── ListView.builder
    └── For each ticket:
        └── Container (ticket card)
            ├── Title, Status, Date
            └── Tap to view details
```

### State Variables

```dart
late Customer _customer;  // Local state for modifications
```

---

## 3. CustomerAddEditScreen

**File:** `lib/presentation/customer_management/customer_add_edit_screen.dart`

**Purpose:** Form for creating new customers or editing existing customer information.

### Parameters

```dart
const CustomerAddEditScreen({
  required this.store,                   // CustomerStore
  this.customer,                         // Customer? - null for add mode
  this.showAppBar = true,                // bool - Responsive flag
  this.onBack,                           // VoidCallback? - Desktop navigation callback
})
```

### Widget Tree

**Mobile View (showAppBar = true):**

```
Scaffold
├── backgroundColor: AppColors.backgroundGrey
├── appBar: AppBar
│   ├── title: "Thêm/Chỉnh sửa khách hàng"
│   └── leading: back button
│
└── body: Form
    └── SingleChildScrollView
        └── Column
            ├── _buildSection (Basic Info)
            │   ├── TextField (fullName)
            │   ├── TextField (email)
            │   ├── TextField (phoneNumber)
            │   ├── TextField (address)
            │   ├── TextField (notes)
            │   └── Dropdown (segment selection)
            │
            ├── _buildSection (Contact Info)
            │   ├── Text (header)
            │   └── ListView.builder (contact info rows)
            │       └── For each contact:
            │           └── Row
            │               ├── Dropdown (type: email/phone/zalo/messenger)
            │               ├── TextField (value)
            │               └── IconButton (delete)
            │
            ├── _buildAddContactButton()
            │   └── Button to add new contact field
            │
            ├── _buildSection (Tags)
            │   └── Wrap (tag pills + add button)
            │
            ├── _buildSection (Action Buttons)
            │   ├── Cancel button
            │   └── Save button
            │
            └── SizedBox (bottom padding)
```

**Desktop View (showAppBar = false):**

```
Form
└── SingleChildScrollView
    ├── padding: all(12)
    └── Column
        ├── _buildBackButton()
        ├── _buildSection (Basic Info)
        ├── _buildSection (Contact Info)
        ├── _buildAddContactButton()
        ├── _buildSection (Tags)
        ├── _buildSection (Action Buttons)
        └── SizedBox (bottom padding)
```

### Form Fields

**Basic Information Section**

```dart
TextField _nameCtrl           // Họ tên (required)
TextField _emailCtrl          // Email (validated)
TextField _phoneCtrl          // Số điện thoại
TextField _addressCtrl        // Địa chỉ
TextField _notesCtrl          // Ghi chú
DropdownButton _segmentCtrl   // Phân loại: VIP/Thường xuyên/Mới/Tiềm năng
```

**Contact Info Structure**

```dart
List<Map<String, String>> _contactInfo
  // [{"type": "Email", "value": "..."}, ...]
  // Types: Email, Phone, Zalo, Messenger
```

**Tags Management**

```dart
List<String> _tags            // Selected tag list
// UI: Wrap of Chip widgets + Add button
```

### Validation

```dart
fullName    -> required, non-empty
email       -> optional, must match email regex if provided
phone       -> optional, format validation
```

### State Variables

```dart
final _formKey = GlobalKey<FormState>();
late TextEditingController _nameCtrl;
final List<Map<String, String>> _contactInfo = [];
List<String> _tags = [];
String? _selectedSegment;
bool get _isEditMode => widget.customer != null;
```

---

## 4. CustomerMergeScreen

**File:** `lib/presentation/customer_management/customer_merge_screen.dart`

**Purpose:** Interface for merging duplicate customer records with conflict resolution.

### Parameters

```dart
const CustomerMergeScreen({
  required this.store,                   // CustomerStore
  this.showAppBar = true,                // bool - Responsive flag
  this.onBack,                           // VoidCallback? - Desktop navigation callback
})
```

### Widget Tree

**Mobile View (showAppBar = true):**

```
Scaffold
├── backgroundColor: AppColors.backgroundGrey
├── appBar: AppBar
│   ├── title: "Hợp nhất khách hàng"
│   └── leading: back button (changes behavior based on step)
│
└── body: Column
    ├── _buildStepIndicator()
    │   └── Step indicators: 1 | 2 | 3
    │
    └── Expanded
        └── _step == 2
            ? _buildPreview()      // Final merge preview
            : _buildSelectStep()   // Customer selection
```

**Desktop View (showAppBar = false):**

```
Column
├── _buildBackButton()
│   └── GestureDetector -> _goBack()
│
├── _buildStepIndicator()
│   └── Step indicators
│
└── Expanded
    └── conditional rendering based on _step
```

### Merge Workflow (3 Steps)

**Step 0: Select Primary Customer**

```
_buildSelectStep()
└── Column
    ├── Text ("Chọn khách hàng chính")
    ├── TextField (search)
    └── ListWheelScrollView (scrollable customer list)
        └── For each customer:
            └── GestureDetector
                ├── container (selected highlight)
                └── Text (name + contact info)
                    └── onTap: set _primary and move to step 1
```

**Step 1: Select Secondary Customer**

```
_buildSelectStep()
└── Column (same as step 0)
    ├── Text ("Chọn khách hàng sẽ hợp nhất")
    ├── TextField (search)
    └── ListWheelScrollView
        └── For each customer (excluding _primary):
            └── GestureDetector
                ├── container (selected highlight)
                └── Text (name + contact info)
                    └── onTap: set _secondary and move to step 2
```

**Step 2: Preview & Confirm Merge**

```
_buildPreview()
└── SingleChildScrollView
    └── Column
        ├── Text ("Xem trước hợp nhất")
        │
        ├── Row (merge direction)
        │   ├── Column (_primary data)
        │   ├── Icon (arrow_forward)
        │   └── Column (_secondary data)
        │
        ├── VStack (merged fields)
        │   ├── name field with primary/secondary toggle
        │   ├── email field with toggle
        │   ├── phone field with toggle
        │   └── ... (other fields)
        │
        └── Row (action buttons)
            ├── Cancel button -> _goBack()
            └── Confirm button -> _performMerge()
```

### Filtering & Search

```dart
List<Customer> _filtered {
  // Current step: 0 or 1 (selection), 2 (preview)
  // Filter by search query (name, phone, email)
  // Exclude _primary from step 1 search
}
```

### State Variables

```dart
Customer? _primary;                        // Selected primary customer
Customer? _secondary;                      // Selected secondary customer
final TextEditingController _searchCtrl;
String _searchQuery = '';
int _step = 0;                            // 0 -> 1 -> 2
```

---

## Store: CustomerStore

**File:** `lib/presentation/customer_management/store/customer_store.dart`

**Architecture:** MobX state management with clean reactive patterns.

### Observable State

```dart
@observable
ObservableList<Customer> customers;       // All customers from repository

@observable
bool isLoading;                           // Loading state

@observable
String searchQuery = '';                  // Current search text

@observable
ObservableList<String> selectedTagFilters; // Active tag filters

@observable
bool isBlocking;                          // Blocking/unblocking state

@observable
String? errorMessage;                     // Error messages
```

### Computed (Derived) State

```dart
@computed
List<Customer> filteredCustomers {
  // Apply search query and tag filters
  // Returns filtered customer list
}

@computed
int totalCount {
  // Return count of active (non-blocked) customers
}

@computed
List<String> allAvailableTags {
  // Extract unique tags from all customers
}
```

### Actions (State Mutations)

```dart
@action
Future<void> fetchCustomers() {
  // Fetch all customers from repository
}

@action
void setSearchQuery(String query) {
  // Update search query observable
}

@action
void setTagFilter(List<String> tags) {
  // Update selected tag filters
}

@action
Future<void> addCustomer(Customer customer) {
  // Create new customer via repository
}

@action
Future<void> updateCustomer(Customer customer) {
  // Update existing customer via repository
}

@action
Future<void> deleteCustomer(String customerId) {
  // Delete customer via repository
}

@action
Future<void> blockCustomer(String customerId) {
  // Block customer (soft delete)
}

@action
Future<void> unblockCustomer(String customerId) {
  // Unblock customer
}

@action
Future<void> mergeCustomers(Customer primary, Customer secondary) {
  // Merge two customers, keep primary
}
```

---

## Related Widgets

### CustomerCard

**File:** `lib/presentation/customer_management/widgets/customer_card.dart`

**Purpose:** Reusable tile widget displaying individual customer in list.

```
GestureDetector (onTap)
└── Container (white background, rounded)
    └── Row
        ├── CircleAvatar (initials/image)
        ├── Expanded
        │   └── Column
        │       ├── Text (fullName - bold)
        │       ├── Text (email)
        │       └── Text (phone)
        │
        └── Column (right side)
            ├── Text (segment tag)
            └── Text (last contact date)
```

**Parameters:**

```dart
const CustomerCard({
  required this.customer,
  required this.onTap,                  // Function(Customer)
})
```

### CustomerFilterSheet

**File:** `lib/presentation/customer_management/widgets/customer_filter_sheet.dart`

**Purpose:** Bottom sheet for tag-based filtering.

```
DraggableScrollableSheet
└── SingleChildScrollView
    └── Column
        ├── Handle (drag indicator)
        ├── Text ("Lọc theo nhãn")
        ├── Observer
        │   └── Wrap (tag selection chips)
        │       └── For each tag:
        │           └── FilterChip (toggleable)
        │
        └── Row (action buttons)
            ├── Cancel
            └── Apply
```

**Parameters:**

```dart
const CustomerFilterSheet({
  required this.allTags,                // List<String>
  required this.selectedTags,           // List<String>
  required this.onApply,                // Function(List<String>)
})
```

---

## Data Entity: Customer

**File:** `lib/domain/entity/customer/customer.dart`

```dart
class Customer {
  final String id;
  final String fullName;
  final String? email;
  final String? phoneNumber;
  final String? zalo;
  final String? messenger;
  final String? address;
  final String? notes;
  final String? segment;              // VIP, Thường xuyên, Mới, Tiềm năng
  final List<String> tags;            // Customer tags
  final bool isBlocked;               // Soft delete flag
  final DateTime createdAt;
  final DateTime updatedAt;
  final SupportTicket? ticket;        // Linked support ticket

  // Methods for processing
  String get displayName => fullName;
  String get initials => ...;
  String get primaryContact => email ?? phoneNumber ?? '';
}
```

---

## Navigation Flow

### Mobile Navigation

```
MainScreen
├── Customer tab selected
│
├── CustomerListScreen
│   ├── Tap customer -> Navigator.push(CustomerDetailScreen)
│   │   ├── Tap edit -> Navigator.push(CustomerAddEditScreen)
│   │   └── Tap back -> Navigator.pop()
│   │
│   ├── Tap add -> Navigator.push(CustomerAddEditScreen)
│   │
│   └── Tap merge -> Navigator.push(CustomerMergeScreen)
│       └── Tap back (step 0) -> Navigator.pop()
│       └── Tap back (step 1+) -> _goBack() (internal step navigation)
```

### Desktop Navigation

```
MainScreen
├── _handleCustomerSelection(customer)
│   └── setState() -> show CustomerDetailScreen (showAppBar=false)
│
├── CustomerDetailScreen.onEdit
│   └── setState() -> show CustomerAddEditScreen (showAppBar=false)
│
├── CustomerAddEditScreen.onBack
│   └── setState() -> back to CustomerDetailScreen
│
└── CustomerListScreen actions
    └── emit callbacks -> handled in MainScreen state
```

---

## Key Design Patterns

### 1. Responsive Adaptation

All screens adapt using:

- `bool showAppBar` parameter (false = desktop panel mode)
- Conditional rendering of Scaffold
- Custom back button vs. Navigator.pop
- Callback delegation vs. Navigator.push

### 2. State Management

- **MobX:** Observables, computed values, actions
- **Service Locator:** Dependency injection via `getIt<CustomerStore>()`
- **Observer widgets:** Real-time UI updates

### 3. Form Handling

- `GlobalKey<FormState>` for validation
- TextEditingController pre-population for edit mode
- Form field validators (email, required fields)
- Save/Cancel actions with proper state cleanup

### 4. Search & Filter

- **Search:** Real-time via TextEditingController listener
- **Filter:** Tag-based using bottom sheet UI
- **Observer pattern:** Automatic UI rebuild on query/filter change

### 5. Merge Workflow

- **Step-based:** Visual feedback via step indicator
- **Preview before confirm:** Show merged data preview
- **Flexible:** Choose primary/secondary with merge direction

---

## Color Scheme

All customer management screens use centralized colors:

```dart
// From lib/constants/colors.dart
const primaryBlue = Color(0xFF2563EB);      // Primary action color
const textPrimary = Color(0xFF1F2937);      // Main text
const backgroundGrey = Color(0xFFF8F9FA);   // Screen background
const borderGrey = Color(0xFFE5E7EB);       // Borders
const errorRed = Color(0xFFDC2626);         // Error states
```

---

## Build & Deployment

**Project Metadata:**

- Flutter: 3.10.7 SDK
- Dart: ^3.10.7
- MobX: For reactive state management
- MobX code generation required for Store classes

**Build Command:**

```bash
dart run build_runner build --delete-conflicting-outputs
```

**All screens are production-ready and tested for:**

- ✅ Responsive layouts (mobile + desktop)
- ✅ Form validation
- ✅ State management
- ✅ Navigation flows
- ✅ Error handling

---

## File Organization

```
lib/presentation/customer_management/
├── customer_list_screen.dart           # Main list + tabs
├── customer_detail_screen.dart         # Detail panel
├── customer_add_edit_screen.dart       # Form (create/edit)
├── customer_merge_screen.dart          # Merge interface
├── store/
│   ├── customer_store.dart            # MobX state management
│   └── customer_store.g.dart          # Generated (build_runner)
└── widgets/
    ├── customer_card.dart             # List item tile
    ├── customer_filter_sheet.dart     # Filter bottom sheet
    └── [other support widgets]
```

---

## Testing Recommendations

### Unit Tests

- Customer store actions and computed values
- Customer entity methods
- Form validators

### Widget Tests

- Screen rendering with responsive parameters
- Form submission and validation
- Navigation callbacks
- Filter/search functionality

### Integration Tests

- Full customer CRUD workflow
- Merge operation end-to-end
- Desktop/mobile layout switching

---

## Next Steps & Enhancements

### Potential Improvements

1. **Pagination:** Large customer lists could use pagination
2. **Avatar upload:** Customer profile picture management
3. **Export/Import:** Bulk customer operations
4. **Customer activity log:** Track all modifications
5. **Advanced search:** Filter by multiple criteria simultaneously
6. **Favorites:** Quick access to frequently used contacts
7. **Relationship graph:** Visualize customer data connections
8. **Bulk actions:** Select multiple and perform batch operations

### Performance Considerations

- Virtual scrolling for large lists (500+ customers)
- Image caching for avatars
- Debounce search input
- Lazy load customer details
- Cache filtered results

---

**Document Last Updated:** 2025
**Status:** Complete & Production-Ready
