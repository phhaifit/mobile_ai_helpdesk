# Ticket Management UI Chỉnh Sửa - Kế Hoạch

Dựa vào `UI.md` và hình giao diện, đây là kế hoạch chỉnh sửa các components trong Ticket Management để phù hợp với Design System.

---

## 1. Colors & Theme Updates

### Hiện trạng
- `AppColors` chỉ định nghĩa blue palette
- Các status/priority color được hardcode trong `TicketCardWidget`

### Kế hoạch
**Cập nhật `lib/constants/colors.dart`:**

```dart
// Thêm các color palette từ UI.md
static const Color primaryBlue = Color(0xFF0084FF);      // #0084FF
static const Color primaryPurple = Color(0xFF5E5CE6);   // #5E5CE6
static const Color darkBlue = Color(0xFF0D1B3E);        // #0D1B3E
static const Color backgroundGrey = Color(0xFFF8F9FD);   // #F8F9FD
static const Color textPrimary = Color(0xFF1C1E21);      // #1C1E21
static const Color inputBackground = Color(0xFFF0F2F5); // #F0F2F5
static const Color bubbleGrey = Color(0xFFE9E9EB);      // #E9E9EB
static const Color dividerColor = Color(0xFFE0E0E0);    // #E0E0E0

// Status colors
static const Color successGreen = Color(0xFF31A24C);    // #31A24C
static const Color warningOrange = Color(0xFFFF9500);   // #FF9500
static const Color errorRed = Color(0xFFE4163A);        // #E4163A

// Mapping status/priority -> colors
static Color getStatusColor(TicketStatus status) {
  switch (status) {
    case TicketStatus.open:
      return primaryBlue;
    case TicketStatus.inProgress:
      return warningOrange;
    case TicketStatus.resolved:
      return successGreen;
    case TicketStatus.closed:
      return Color(0xFF999999);
  }
}

static Color getPriorityColor(TicketPriority priority) {
  switch (priority) {
    case TicketPriority.low:
      return successGreen;
    case TicketPriority.medium:
      return primaryBlue;
    case TicketPriority.high:
      return warningOrange;
    case TicketPriority.urgent:
      return errorRed;
  }
}
```

**Priority:** ⭐⭐ (cơ bản, dễ)

---

## 2. Reusable Components

### 2.1 Badge Component
**File:** `lib/core/widgets/badge_widget.dart`

### Hiện trạng
- Badge được hardcode trong `TicketCardWidget`

### Kế hoạch
```dart
class BadgeWidget extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsets? padding;

  const BadgeWidget({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
```

**Priority:** ⭐⭐⭐ (dùng lại cho Status & Priority)

---

### 2.2 Status Badge Component
**File:** `lib/presentation/ticket/widgets/status_badge_widget.dart`

```dart
class StatusBadgeWidget extends StatelessWidget {
  final TicketStatus status;

  const StatusBadgeWidget({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    return BadgeWidget(
      label: status.displayName,
      backgroundColor: AppColors.getStatusColor(status),
      textColor: Colors.white,
    );
  }
}
```

**Priority:** ⭐⭐⭐ (cao, cần ngay)

---

### 2.3 Priority Badge Component
**File:** `lib/presentation/ticket/widgets/priority_badge_widget.dart`

```dart
class PriorityBadgeWidget extends StatelessWidget {
  final TicketPriority priority;

  const PriorityBadgeWidget({required this.priority, super.key});

  @override
  Widget build(BuildContext context) {
    return BadgeWidget(
      label: priority.englishName,
      backgroundColor: AppColors.getPriorityColor(priority),
      textColor: Colors.white,
    );
  }
}
```

**Priority:** ⭐⭐⭐ (cao, cần ngay)

---

## 3. Ticket Card Widget Refinements

**File:** `lib/presentation/ticket/widgets/ticket_card_widget.dart`

### Hiện trạng
- Có card, status/priority badges, customer, assigned agent, created date
- Hardcode colors cho status/priority

### Kế hoạch - Cập nhật
1. **Thay thế hardcode colors** bằng `AppColors.getStatusColor()` & `AppColors.getPriorityColor()`
2. **Sử dụng `StatusBadgeWidget` & `PriorityBadgeWidget`** thay vì hardcode badge
3. **Cải thiện Layout** để match UI.md:
   - Cột: Tiêu đề | Trạng thái & Độ ưu tiên | Khách hàng | Người tiếp nhận | Ngày tạo
   - Áp dụng spacing từ `lib/constants/dimens.dart`
   - Cấu trúc: Header row (Title) → Metadata rows (Customer, Agent, Date) → Status/Priority badges

4. **Typography** từ UI.md:
   - Tiêu đề: H3 (16px, 600 weight)
   - Customer/Agent: Body Medium (13px)
   - Timestamps: Body Small (12px, grey)

### Code Update Example:
```dart
// Thay hardcode color bằng:
StatusBadgeWidget(status: ticket.status),
PriorityBadgeWidget(priority: ticket.priority),

// Thay vì:
Container(
  decoration: BoxDecoration(color: _getStatusColor(...)),
  child: Text(ticket.status.displayName),
),
```

**Priority:** ⭐⭐⭐⭐ (cao nhất, ảnh hưởng trực tiếp)

---

## 4. Ticket List Screen Layout

**File:** `lib/presentation/ticket/screens/ticket_list_screen.dart`

### Hiện trạng
- Chỉ có AppBar + ListView với card
- Chưa có: Tabs, Search, Filter, Export, Add button
- Empty state đơn giản

### Kế hoạch - Chỉ cập nhật những gì có trên hình & code

#### 4.1 AppBar Refinements
```dart
AppBar(
  title: const Text('Phiếu hỗ trợ'),              // Dùng localization
  elevation: 1,                                     // Từ UI: 1px border-bottom
  backgroundColor: Colors.white,
  foregroundColor: AppColors.textPrimary,
  // Thêm action buttons (nếu cần - nhưng focus vào những có code)
)
```

#### 4.2 Tabs Widget (có trên hình - pending implementation)
**File:** `lib/presentation/ticket/widgets/ticket_filter_tabs.dart`

```dart
// Hỗ trợ 3 tab từ hình:
// - "Phiếu hỗ trợ của tôi"
// - "Phiếu chưa tiếp nhận"
// - "Tất cả phiếu hỗ trợ"

// Chỉ implement tab UI, delegate filtering logic to Store
class TicketFilterTabsWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: [
        Tab(text: AppLocalizations.of(context)!.myTickets),
        Tab(text: AppLocalizations.of(context)!.unassignedTickets),
        Tab(text: AppLocalizations.of(context)!.allTickets),
      ],
    );
  }
}
```

**Priority:** ⭐⭐ (có trên hình nhưng chưa critical)

#### 4.3 Empty State Widget
**File:** `lib/presentation/ticket/widgets/empty_state_widget.dart`

```dart
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon!,
          SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
```

**Priority:** ⭐⭐ (UX improvement)

---

## 5. Theming & Constants

### Typography (`lib/constants/app_theme.dart`)
**Cập nhật ThemeData để match UI.md:**

```dart
// H3 (subsection title)
headlineSmall: TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  height: 1.3,
  color: AppColors.textPrimary,
),

// Body Medium
labelMedium: TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w400,
  height: 1.5,
  color: AppColors.textPrimary,
),

// Label (medium weight)
labelSmall: TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w500,
  height: 1.4,
  color: AppColors.textPrimary,
),

// Body Small (grey)
bodySmall: TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  height: 1.4,
  color: Color(0xFF666666),
),
```

**Priority:** ⭐⭐ (consistency)

### Dimens (`lib/constants/dimens.dart`)
**Thêm spacing constants từ UI.md 8px Grid:**

```dart
static const double spacingXs = 4;      // xs
static const double spacingS = 8;       // s
static const double spacingM = 12;      // m
static const double spacingL = 16;      // l
static const double spacingXl = 24;     // xl
static const double spacing2xl = 32;    // 2xl

// Card padding (từ UI)
static const double cardPadding = 16;
static const double cardBorderRadius = 8;
```

**Priority:** ⭐⭐

---

## 6. Files to Create/Modify

### New Files
- [ ] `lib/core/widgets/badge_widget.dart` — Reusable badge
- [ ] `lib/presentation/ticket/widgets/status_badge_widget.dart`
- [ ] `lib/presentation/ticket/widgets/priority_badge_widget.dart`
- [ ] `lib/presentation/ticket/widgets/empty_state_widget.dart`
- [ ] `lib/presentation/ticket/widgets/ticket_filter_tabs.dart` (optional - pending)

### Modified Files
- [ ] `lib/constants/colors.dart` — Thêm color palette & helper methods
- [ ] `lib/constants/app_theme.dart` — Cập nhật typography
- [ ] `lib/constants/dimens.dart` — Thêm spacing constants
- [ ] `lib/presentation/ticket/widgets/ticket_card_widget.dart` — Sử dụng badges, remove hardcode
- [ ] `lib/presentation/ticket/screens/ticket_list_screen.dart` — Improve AppBar & empty state

---

## 7. Implementation Priority & Order

### Phase 1 (⭐⭐⭐⭐ Cao)
1. Update `colors.dart` với color helper methods
2. Create `badge_widget.dart`
3. Create `status_badge_widget.dart` & `priority_badge_widget.dart`
4. Update `ticket_card_widget.dart` để sử dụng badge widgets
5. Update `app_theme.dart` typography

### Phase 2 (⭐⭐⭐ Trung)
6. Create `empty_state_widget.dart`
7. Update `ticket_list_screen.dart` để sử dụng empty state
8. Update `dimens.dart` với spacing constants

### Phase 3 (⭐⭐ Optional - Pending)
9. Create `ticket_filter_tabs.dart` (chỉ UI)
10. Integrate tab filtering logic vào Store

---

## 8. Localization Notes

Tất cả user-facing strings cần đi vào `assets/lang/en.json` & `assets/lang/vi.json`:

```json
{
  "myTickets": "Phiếu hỗ trợ của tôi",
  "unassignedTickets": "Phiếu chưa tiếp nhận",
  "allTickets": "Tất cả phiếu hỗ trợ",
  "noTickets": "Không có phiếu nào",
  "emptyStateSubtitle": "Bắm vào nút 'Thêm phiếu' phía trên để tạo phiếu mới cho khách hàng bạn nhé!",
  "createdBy": "Được tạo bởi",
  "assignedTo": "Giao cho",
  "unassigned": "Chưa giao"
}
```

---

## 9. UI Checklist

- [ ] Colors match `UI.md` palette (#0084FF, #31A24C, #E4163A, etc.)
- [ ] Typography matches H3, Body Medium, Body Small specs
- [ ] Spacing follows 8px grid (4, 8, 12, 16, 24, 32px)
- [ ] Status badges: Open=Blue, InProgress=Orange, Resolved=Green, Closed=Grey
- [ ] Priority badges: Low=Green, Medium=Blue, High=Orange, Urgent=Red
- [ ] Card border-radius = 8px, shadows = subtle (0 2px 8px rgba)
- [ ] All text uses `AppLocalizations`
- [ ] Card hover state có shadow effect
- [ ] Empty state có icon & descriptive text

