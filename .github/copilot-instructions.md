---
applyTo: "**"
---

# AI Helpdesk — GitHub Copilot Instructions

You are an expert Flutter mobile developer assistant for the **ai_helpdesk** project.
Always follow the architecture and conventions from this boilerplate:
https://github.com/zubairehman/flutter_boilerplate_project

---

## Architecture: Clean Architecture + MobX + Provider

The project follows a strict 3-layer architecture:

### Layer Structure (`lib/`)

```
lib/
├── constants/        # App-wide constants (theme, colors, strings, dimens, fonts, assets)
├── core/             # Shared base classes (widgets, stores, extensions, network base)
├── data/             # Data layer: local (Sembast), network (Dio), sharedpref, repository impl, DI
├── domain/           # Domain layer: entities, repository interfaces, use cases, DI
├── presentation/     # UI layer: screens, MobX stores per screen, DI
├── di/               # Root service locator (get_it)
├── utils/            # Utilities: routes, locale, dio helpers, device utils
└── main.dart         # Entry point
```

---

## Coding Rules

### State Management
- Use **MobX** for all reactive state. Every screen must have its own Store file.
- Store files follow naming: `<feature>_store.dart` with a corresponding `<feature>_store.g.dart` (code-gen).
- Use `@observable`, `@action`, `@computed` decorators properly.
- Use **Provider** to inject stores into the widget tree.
- Run `flutter packages pub run build_runner build --delete-conflicting-outputs` after modifying stores.

### Dependency Injection
- Use **get_it** as service locator. Register all dependencies in `lib/di/service_locator.dart`.
- Separate DI modules per layer: `data_layer_injection.dart`, `domain_layer_injection.dart`, `presentation_layer_injection.dart`.

### Networking
- Use **Dio** for all HTTP calls. Configure in `lib/data/network/dio_client.dart`.
- API endpoints go in `lib/data/network/constants/endpoints.dart`.
- Always add interceptors: auth, logging, retry (`lib/core/data/network/dio/interceptors/`).
- Wrap all API errors using `NetworkExceptions`.

### Local Storage
- Use **Sembast** for local database. Client configured in `lib/core/data/local/sembast/sembast_client.dart`.
- Use **SharedPreferences** via `SharedPreferenceHelper` for simple key-value storage.
- Store preference keys in `lib/data/sharedpref/constants/preferences.dart`.

### Repository Pattern
- Always define abstract repository interfaces in `lib/domain/repository/`.
- Implement them in `lib/data/repository/`.
- Business logic goes through **Use Cases** in `lib/domain/usecase/`. Each use case is a separate class extending `UseCase`.

### Routing
- All routes defined in `lib/utils/routes/routes.dart` as static constants.
- Use named routes only. Never use anonymous routes.

### Constants
- Colors → `lib/constants/colors.dart`
- Strings → `lib/constants/strings.dart`
- Dimensions → `lib/constants/dimens.dart`
- Font families → `lib/constants/font_family.dart`
- Asset paths → `lib/constants/assets.dart`
- Theme → `lib/constants/app_theme.dart`
- **Never hardcode colors, strings, or dimensions inline in widgets.**

### Assets
- Fonts: Product Sans (Regular, Bold, Italic, Bold Italic) — already in `assets/fonts/`
- Images in `assets/images/`, icons in `assets/icons/`
- Localization JSON in `assets/lang/` (`en.json`, `da.json`, `es.json`) — use `AppLocalization` for all displayed text.

### Widgets
- Reusable widgets go in `lib/core/widgets/`.
- Screen-specific widgets stay inside the screen's own folder under `lib/presentation/<feature>/`.

### Code Generation
- Models using `json_serializable`: annotate with `@JsonSerializable()`, run build_runner.
- MobX stores: annotate with `@store`, run build_runner.
- Never manually edit `.g.dart` files.

---

## Naming Conventions

| Target | Convention |
|---|---|
| Files | `snake_case.dart` |
| Classes | `PascalCase` |
| Variables / methods | `camelCase` |
| Constants | `camelCase` (not SCREAMING_SNAKE) |
| Store files | `<feature>_store.dart` |
| Use case files | `<feature>_usecase.dart` |
| Repository interfaces | `<name>_repository.dart` |
| Repository implementations | `<name>_repository_impl.dart` |

---

## Libraries in Use

| Purpose | Library |
|---|---|
| HTTP | `dio` |
| State Management | `mobx`, `flutter_mobx` |
| DI | `get_it` |
| Local DB | `sembast` |
| Preferences | `shared_preferences` |
| Encryption | `xxtea` |
| Validation | `validators` |
| Notifications | `flushbar` |
| JSON | `json_serializable`, `json_annotation` |
| Code Gen | `build_runner`, `mobx_codegen` |

---

## Do's and Don'ts

✅ Always use use cases to interact with repositories from stores  
✅ Always register new dependencies in `service_locator.dart`  
✅ Always use `AppLocalization` for user-facing strings  
✅ Run build_runner after every store or model change  
✅ Keep stores free of UI code (no `BuildContext` in stores)  
❌ Never put business logic directly in widgets  
❌ Never call repositories directly from UI — always go through use cases → stores  
❌ Never hardcode API URLs — use `endpoints.dart`  
❌ Never skip error handling in network calls — use `NetworkExceptions`  

---

## Feature Development Checklist

When adding a new feature (e.g., "ticket"), create all of the following in order:

1. `lib/domain/entity/<feature>/<feature>.dart` — entity
2. `lib/domain/repository/<feature>/<feature>_repository.dart` — interface
3. `lib/domain/usecase/<feature>/get_<feature>_usecase.dart` — use case
4. `lib/data/network/apis/<feature>/<feature>_api.dart` — API
5. `lib/data/repository/<feature>/<feature>_repository_impl.dart` — implementation
6. `lib/presentation/<feature>/store/<feature>_store.dart` — MobX store
7. `lib/presentation/<feature>/<feature>_screen.dart` — UI
8. Register all new classes in the appropriate DI module and add the route to `lib/utils/routes/routes.dart`
