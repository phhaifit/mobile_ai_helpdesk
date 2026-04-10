# Widget tree — `TenantInfoScreen`

Source: `lib/presentation/tenant/tenant_info_screen.dart`  
State: `_TenantInfoScreenState` · Store: `TenantStore` (wrapped in `Observer`)

```
Scaffold (backgroundColor: white)
├── ? appBar: AppBar (only if width < 600)
│   ├── title: Text (localized)
│   └── ? leading: IconButton (menu) if onMenuTap != null
└── body: Observer
    └── SingleChildScrollView (padding)
        └── ConstrainedBox (maxWidth: 1040)
            └── Column (crossAxis: start)
                ├── Text (page title)
                ├── SizedBox
                ├── Text (subtitle)
                ├── SizedBox
                ├── Text (section: General information)
                ├── SizedBox
                ├── _buildCard
                │   └── Column
                │       ├── if isMobile → Column [label Text, TextField]
                │       └── else → Row [SizedBox label, Expanded TextField]
                │       └── Row (end)
                │           ├── ElevatedButton (Cancel name)
                │           └── ElevatedButton | CircularProgressIndicator (Save)
                ├── SizedBox
                ├── Text (section: Ticket auto-resolution)
                ├── SizedBox
                ├── _buildCard
                │   └── Column
                │       ├── Text (description)
                │       ├── SizedBox
                │       ├── if isMobile → Column [label, Switch]
                │       └── else → Row [label, Spacer, Switch]
                ├── SizedBox
                ├── Text (section: Delete organization)
                ├── SizedBox
                └── _buildCard
                    └── if isMobile → Column [warning Text, SizedBox, full-width ElevatedButton Delete]
                        else → Row [Expanded warning Text, ElevatedButton Delete]
```

## Overlays (not in scaffold body)

- `AlertDialog` — delete organization confirmation.
- `SnackBar` — feedback via `ScaffoldMessenger`.
