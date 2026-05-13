# Widget tree — `CreateTenantScreen`

Source: `lib/presentation/tenant/create_tenant_screen.dart`  
State: `_CreateTenantScreenState` · Store: `TenantStore` (wrapped in `Observer`)

```
Scaffold (backgroundColor: white)
└── body: SafeArea
    └── Stack
        ├── [0] Observer
        │   └── LayoutBuilder
        │       └── SingleChildScrollView (padding)
        │           └── Center
        │               └── ConstrainedBox (maxWidth ~280–560)
        │                   └── Column (crossAxis: stretch)
        │                       ├── _buildBrandBlock(l) → Column
        │                       │   ├── Row [logo Container (gradient) + Text brand]
        │                       │   ├── SizedBox
        │                       │   ├── Text (welcome title)
        │                       │   ├── SizedBox
        │                       │   └── Text (welcome subtitle)
        │                       ├── SizedBox
        │                       ├── _buildStepperRow(l) → LayoutBuilder → Row
        │                       │   └── [per step] Padding? | Expanded → Column
        │                       │       ├── _stepCircle (Container circle / check / number)
        │                       │       ├── SizedBox
        │                       │       └── Text (step label)
        │                       ├── SizedBox
        │                       ├── _buildCard(l) → Container (card decoration)
        │                       │   └── Column
        │                       │       ├── AnimatedSwitcher
        │                       │       │   └── KeyedSubtree (ValueKey: _stepIndex)
        │                       │       │       └── _stepBody(l)  ← see table below
        │                       │       ├── SizedBox
        │                       │       └── _stepFooter(l) → Row | gradient SizedBox
        │                       │           ├── step 0: _gradientButton (Continue, full width)
        │                       │           ├── step 4: Row [_secondaryButton Skip | _gradientButton Finish]
        │                       │           └── else: Row [_secondaryButton Back | _gradientButton Continue]
        │                       └── ? if TenantStore.isLoading
        │                           ├── SizedBox
        │                           └── Center → SizedBox → CircularProgressIndicator
        └── [1] Positioned (top-right)
            └── IconButton (close → Navigator.pop)
```

## `_stepBody(l)` (inside `AnimatedSwitcher`)

| `_stepIndex` | Widget |
|--------------|--------|
| **0** | `_step1Info` → **Form** → `Column`: titles, `TextFormField` (org name), `TextField` (phone) |
| **1** | `_step2Personalize` → `Column`: titles, `InputDecorator` + `DropdownButton` (industry), same (scale), `Wrap` of `FilterChip`, `TextField` (other problems), optional custom problem rows |
| **2** | `_step3Data` → `Column`: titles, `TextField` (website), `Material` → `InkWell` → `CustomPaint` (`_DottedRectPainter`) + upload copy, optional `ListTile` rows for mock documents |
| **3** | `_step4Trial` → `Column`: titles, `Container` (chat shell) → `Column` → header `Container` (`Row` avatar + title), `Padding` → `Column` (`Text`, `Wrap`/`ActionChip`, `ConstrainedBox` → `ListView.builder` bubbles), `Padding` → `Row` (`Expanded` `TextField`, `Material`/`InkWell` send) |
| **4** | `_step5Upgrade` → `Column`: `Center` → gradient `Container` + `Icon`, titles, `Container` → `TextField` (optional website) + helper `Text` |

## Other types

- `_TrialBubble` — model for chat bubbles (not a `Widget`).
- `_DottedRectPainter` — `CustomPainter` for dashed upload border.
