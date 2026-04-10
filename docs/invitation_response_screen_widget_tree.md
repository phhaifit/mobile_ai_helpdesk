# Widget tree — `InvitationResponseScreen`

Source: `lib/presentation/tenant/invitation_response_screen.dart`  
State: `_InvitationResponseScreenState` · Stores: `TeamStore`, `TenantStore` (wrapped in `Observer`); `InvitationRepository` used for accept/decline (not a widget child)

```
Scaffold (backgroundColor: white)
└── body: SafeArea
    └── Stack
        ├── [0] Observer
        │   └── SingleChildScrollView (padding)
        │       └── Center → ConstrainedBox (maxWidth: 480)
        │           └── Column
        │               ├── _buildBrandHeader(l) → Column
        │               │   ├── Row [circle gradient Container + Text brand]
        │               │   ├── SizedBox
        │               │   ├── Text (welcome title)
        │               │   ├── SizedBox
        │               │   └── Text (welcome subtitle)
        │               ├── SizedBox
        │               └── if _finished → _buildResultCard(l)
        │                   | else → _buildConfirmCard(l, orgName, roleLabel)
        └── [1] Positioned → IconButton (close)
```

## `_buildConfirmCard`

```
Container (card decoration)
└── Column (crossAxis: stretch)
    ├── Text (confirm title)
    ├── SizedBox
    ├── Text (organization name, large)
    ├── SizedBox
    ├── Text.rich (body with bold spans)
    ├── ? if _errorMessage != null → Text (error)
    ├── SizedBox
    └── if _isSubmitting → Center → CircularProgressIndicator
        | else → Row
            ├── Expanded → OutlinedButton (Decline)
            └── Expanded → DecoratedBox (gradient) → Material → InkWell (Join)
```

## `_buildResultCard`

```
Container (card decoration)
└── Column
    ├── Icon (success | declined)
    ├── SizedBox
    ├── Text (result message)
    ├── SizedBox
    └── SizedBox (width: infinity) → OutlinedButton (Close → maybePop)
```
