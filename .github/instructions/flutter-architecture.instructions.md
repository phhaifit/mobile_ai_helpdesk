---
applyTo: "**/*.dart"
---

# Flutter Clean Architecture Rules

Apply these rules to every `.dart` file in the **ai_helpdesk** project.

---

## Layer Boundaries

Each layer may only depend on layers below it. Violations are bugs, not warnings.

| Layer | Location | May depend on |
|---|---|---|
| Presentation | `lib/presentation/` | Domain only |
| Domain | `lib/domain/` | Nothing (pure Dart) |
| Data | `lib/data/` | Domain only |
| Core | `lib/core/` | Nothing external |

- **Presentation** → never import from `lib/data/` directly.
- **Domain** → no Flutter imports, no Dio, no Sembast. Pure Dart classes only.
- **Data** → implements domain interfaces; never imports presentation.

---

## MobX Store Rules

Every screen gets exactly one store. Structure every store like this:

```dart
part '<feature>_store.g.dart';

class <Feature>Store = _<Feature>StoreBase with _$<Feature>Store;

abstract class _<Feature>StoreBase with Store {
  // Dependencies injected via constructor
  final Get<Feature>UseCase _get<Feature>UseCase;
  _<Feature>StoreBase(this._get<Feature>UseCase);

  @observable
  ObservableFuture<void> fetchFuture = ObservableFuture.value(null);

  @observable
  <Entity>? data;

  @observable
  String? errorMessage;

  @computed
  bool get isLoading => fetchFuture.status == FutureStatus.pending;

  @action
  Future<void> fetch<Feature>() async {
    fetchFuture = ObservableFuture(_get<Feature>UseCase.call(null));
    // handle result / error
  }
}
```

Rules:
- No `BuildContext` anywhere in a store.
- No `Navigator` calls in a store.
- Expose loading state via `@computed` from `ObservableFuture`, not a raw `@observable bool`.
- Always wrap async calls in `ObservableFuture` so reactions work.

---

## Use Case Rules

Each use case is a single class with one public method:

```dart
class Get<Feature>UseCase extends UseCase<<ReturnType>, <ParamsType>> {
  final <Feature>Repository _repository;
  Get<Feature>UseCase(this._repository);

  @override
  Future<Either<Failure, <ReturnType>>> call(<ParamsType> params) {
    return _repository.get<Feature>(params);
  }
}
```

- One use case = one action. Never combine multiple domain operations in one class.
- Use cases live in `lib/domain/usecase/<feature>/`.

---

## Repository Rules

**Interface** (`lib/domain/repository/<feature>/<feature>_repository.dart`):
```dart
abstract class <Feature>Repository {
  Future<Either<Failure, <ReturnType>>> get<Feature>(<Params>);
}
```

**Implementation** (`lib/data/repository/<feature>/<feature>_repository_impl.dart`):
```dart
class <Feature>RepositoryImpl implements <Feature>Repository {
  final <Feature>Api _api;
  <Feature>RepositoryImpl(this._api);

  @override
  Future<Either<Failure, <ReturnType>>> get<Feature>(<Params> params) async {
    try {
      final response = await _api.get<Feature>(params);
      return Right(response);
    } on DioException catch (e) {
      return Left(NetworkExceptions.getDioException(e));
    }
  }
}
```

- Always return `Either<Failure, T>` — never throw from a repository implementation.
- Always catch `DioException` and convert via `NetworkExceptions`.

---

## Dependency Injection Rules

Register every new class in the correct module file:

| Class type | Module file |
|---|---|
| API clients | `lib/data/di/data_layer_injection.dart` |
| Repository impls | `lib/data/di/data_layer_injection.dart` |
| Use cases | `lib/domain/di/domain_layer_injection.dart` |
| Stores | `lib/presentation/di/presentation_layer_injection.dart` |

Use `get_it` lazy singletons for everything except stores (use `Factory` for stores):

```dart
// Repository impl — singleton
getIt.registerLazySingleton<FeatureRepository>(
  () => FeatureRepositoryImpl(getIt<FeatureApi>()),
);

// Store — factory (new instance per screen)
getIt.registerFactory<FeatureStore>(
  () => FeatureStore(getIt<GetFeatureUseCase>()),
);
```

---

## Widget Rules

- Use `Observer` from `flutter_mobx` to react to store state. Never use `setState` for data from stores.
- Never access `getIt` in a widget constructor — receive the store via `Provider` or the widget's `build` method.
- Screen entry point widgets are stateless; use `StatefulWidget` only when lifecycle hooks (`initState`, `dispose`) are needed.
- Call store initialization (e.g., `store.fetchData()`) in `initState`, never in `build`.

```dart
class FeatureScreen extends StatefulWidget { ... }

class _FeatureScreenState extends State<FeatureScreen> {
  late final FeatureStore _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<FeatureStore>();
    _store.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (_store.isLoading) return const CircularProgressIndicator();
        if (_store.errorMessage != null) return ErrorWidget(_store.errorMessage!);
        return FeatureBody(data: _store.data);
      },
    );
  }
}
```

---

## Routing

```dart
// In routes.dart
static const String featureScreen = '/feature';

// Navigating
Navigator.pushNamed(context, Routes.featureScreen);

// Registering
case Routes.featureScreen:
  return MaterialPageRoute(builder: (_) => const FeatureScreen());
```

- Never use `MaterialPageRoute` inline at the call site — always route through named routes.
- Pass data via route arguments (`RouteSettings.arguments`), not constructor parameters on the screen widget.

---

## Code Generation Reminder

After modifying any store or `@JsonSerializable` model, run:

```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

Never edit `.g.dart` files manually.
