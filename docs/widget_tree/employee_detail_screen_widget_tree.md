# Widget tree — `EmployeeDetailScreen`

Source: `lib/presentation/tenant/employee_detail_screen.dart`  
State: `_EmployeeDetailScreenState` · Store: `TeamStore` (wrapped in `Observer`)

```
Scaffold (backgroundColor: AppColors.backgroundGrey)
├── ? appBar: AppBar (only if width < 700)
└── body: Observer
    └── if member not found in teamMembers
        └── Center → Padding → Column [Text, OutlinedButton back]
        | else
        └── SingleChildScrollView (padding)
            └── Center → ConstrainedBox (maxWidth: 720)
                └── Column (crossAxis: start)
                    ├── ? if !isMobile → Row [IconButton back]
                    ├── Text (title with name)
                    ├── SizedBox
                    ├── Text (subtitle)
                    ├── SizedBox
                    ├── _sectionCard → Container (shadow)
                    │   └── Column (spacing: 12)
                    │       ├── _labeledRow (profile) → Align → CircleAvatar
                    │       ├── _divider
                    │       ├── SizedBox
                    │       ├── _labeledRow (email) → Text
                    │       ├── _divider
                    │       ├── _labeledRow (position) → InputDecorator → DropdownButtonHideUnderline → DropdownButton<TeamRole>
                    │       ├── _divider
                    │       ├── _labeledRow (full name) → TextField
                    │       ├── _divider
                    │       ├── _labeledRow (phone) → TextField
                    │       ├── SizedBox
                    │       └── Align → FilledButton | CircularProgressIndicator
                    ├── SizedBox
                    ├── _sectionCard
                    │   └── Column [section Text, Center → Padding → empty-state Text]
                    ├── SizedBox
                    └── _sectionCard
                        └── Column [section Text, warning Text, FilledButton delete | progress]
```

## `_labeledRow`

- **Mobile:** `Column` — label `Text`, `SizedBox`, field.
- **Desktop:** `Row` — fixed-width label, `Expanded` field.

## Overlays

- `AlertDialog` — delete member confirmation.
- `SnackBar` — after save or delete.
