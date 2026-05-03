# Widget tree — `EmployeeScreen`

Source: `lib/presentation/tenant/employee_screen.dart`  
State: `_EmployeeScreenState` · Stores: `TeamStore`, `TenantStore` (body wrapped in `Observer`)

```
Scaffold (backgroundColor: white)
├── ? appBar: AppBar (only if width < 700)
│   ├── title: Text
│   └── ? leading: IconButton (menu)
└── body: Observer
    └── SingleChildScrollView (padding)
        └── ConstrainedBox (maxWidth: 1200)
            └── Column (crossAxis: start)
                ├── _buildTabs(l) → Row
                │   ├── _tabButton (tab 0) → InkWell → Column [Text, SizedBox, Container underline]
                │   ├── SizedBox
                │   └── _tabButton (tab 1)
                ├── SizedBox
                └── if _selectedTab == 0 → _buildEmployeeContent
                    | else → _buildInvitationContent
```

## Tab 0 — `_buildEmployeeContent`

```
Column
├── _buildHeader (mobile: Column title/subtitle/Row buttons | desktop: Row + buttons)
│   └── ElevatedButton.icon (Export) | ElevatedButton.icon (Add employee)
├── SizedBox
└── _panel → Container (bordered)
    └── Column
        ├── _employeeFilters → Column | Row
        │   ├── TextField (search)
        │   └── DropdownButtonFormField<TeamRole?> (role filter)
        ├── SizedBox
        └── if isMobile → _employeeCards → Column of Card → ListTile [TextButton Details]
            | else → _employeeTable → Column
                ├── _tableHeader → Container → Row of Expanded Text
                └── ... _tableRow → Container → Row of Expanded (Text | Align OutlinedButton)
```

## Tab 1 — `_buildInvitationContent`

Same shell as tab 0 (`_buildHeader` + `_panel`), inner:

```
Column
├── _invitationFilters (search + DropdownButtonFormField<InvitationStatus?>)
└── if isMobile → _invitationCards → Column of Card → Padding → Column [Texts, Row buttons]
    | else → _invitationTable → _tableHeader + _tableRow... + optional _invitationActions Row
```

## Shared helpers

- `_tableHeader` / `_tableRow` — header strip and data rows.
- `_detailsButton` — `OutlinedButton` opening member detail.
- `_invitationActions` — `Row` of Resend / Delete for pending invites.

## Overlays and navigation

- `AlertDialog` + `StatefulBuilder` — “Add employee” (`TextField`, role `DropdownButtonFormField`, actions).
- `MaterialPageRoute` → `EmployeeDetailScreen` from Details.
