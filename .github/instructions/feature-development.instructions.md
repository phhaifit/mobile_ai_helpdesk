---
applyTo: "**"
description: "Apply when adding a new feature, screen, module, or domain entity to the ai_helpdesk project."
---

# Feature Development Checklist

Use this checklist every time you scaffold a new feature in **ai_helpdesk**.
Replace `<feature>` with the feature name in `snake_case` (e.g., `ticket`, `user_profile`).
Replace `<Feature>` with the feature name in `PascalCase` (e.g., `Ticket`, `UserProfile`).

---

## Step-by-Step Scaffold (create in this order)

### 1. Entity — `lib/domain/entity/<feature>/<feature>.dart`

```dart
import 'package:json_annotation/json_annotation.dart';

part '<feature>.g.dart';

@JsonSerializable()
class <Feature> {
  final String id;
  // add fields

  const <Feature>({required this.id});

  factory <Feature>.fromJson(Map<String, dynamic> json) =>
      _$<Feature>FromJson(json);

  Map<String, dynamic> toJson() => _$<Feature>ToJson(this);
}
```

### 2. Repository Interface — `lib/domain/repository/<feature>/<feature>_repository.dart`

```dart
import 'package:dartz/dartz.dart';

abstract class <Feature>Repository {
  Future<Either<Failure, <Feature>>> get<Feature>(String id);
  Future<Either<Failure, List<<Feature>>>> getAll<Feature>s();
}
```

### 3. Use Case(s) — `lib/domain/usecase/<feature>/`

Create one file per operation:

```dart
// get_<feature>_usecase.dart
class Get<Feature>UseCase extends UseCase<<Feature>, String> {
  final <Feature>Repository _repository;
  Get<Feature>UseCase(this._repository);

  @override
  Future<Either<Failure, <Feature>>> call(String id) =>
      _repository.get<Feature>(id);
}
```

### 4. API — `lib/data/network/apis/<feature>/<feature>_api.dart`

```dart
class <Feature>Api {
  final Dio _dio;
  <Feature>Api(this._dio);

  Future<<Feature>> get<Feature>(String id) async {
    final response = await _dio.get(Endpoints.<feature>(id));
    return <Feature>.fromJson(response.data);
  }
}
```

Add the endpoint constant to `lib/data/network/constants/endpoints.dart`:

```dart
static String <feature>(String id) => '/api/<feature>s/$id';
```

### 5. Repository Implementation — `lib/data/repository/<feature>/<feature>_repository_impl.dart`

```dart
class <Feature>RepositoryImpl implements <Feature>Repository {
  final <Feature>Api _api;
  <Feature>RepositoryImpl(this._api);

  @override
  Future<Either<Failure, <Feature>>> get<Feature>(String id) async {
    try {
      return Right(await _api.get<Feature>(id));
    } on DioException catch (e) {
      return Left(NetworkExceptions.getDioException(e));
    }
  }
}
```

### 6. MobX Store — `lib/presentation/<feature>/store/<feature>_store.dart`

```dart
part '<feature>_store.g.dart';

class <Feature>Store = _<Feature>StoreBase with _$<Feature>Store;

abstract class _<Feature>StoreBase with Store {
  final Get<Feature>UseCase _get<Feature>UseCase;
  _<Feature>StoreBase(this._get<Feature>UseCase);

  @observable
  ObservableFuture<void> fetchFuture = ObservableFuture.value(null);

  @observable
  <Feature>? <feature>;

  @observable
  String? errorMessage;

  @computed
  bool get isLoading => fetchFuture.status == FutureStatus.pending;

  @action
  Future<void> fetch<Feature>(String id) async {
    errorMessage = null;
    fetchFuture = ObservableFuture(
      _get<Feature>UseCase.call(id).then((result) {
        result.fold(
          (failure) => errorMessage = failure.message,
          (data) => <feature> = data,
        );
      }),
    );
    await fetchFuture;
  }
}
```

Run build_runner after creating the store:
```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 7. Screen UI — `lib/presentation/<feature>/<feature>_screen.dart`

```dart
class <Feature>Screen extends StatefulWidget {
  const <Feature>Screen({super.key});

  @override
  State<<Feature>Screen> createState() => _<Feature>ScreenState();
}

class _<Feature>ScreenState extends State<<Feature>Screen> {
  late final <Feature>Store _store;

  @override
  void initState() {
    super.initState();
    _store = getIt<<Feature>Store>();
    _store.fetch<Feature>('some-id'); // or read from route args
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.<feature>Title)),
      body: Observer(
        builder: (_) {
          if (_store.isLoading) return const Center(child: CircularProgressIndicator());
          if (_store.errorMessage != null) {
            return Center(child: Text(_store.errorMessage!));
          }
          return <Feature>Body(<feature>: _store.<feature>);
        },
      ),
    );
  }
}
```

### 8. Register in DI + Routing

**`lib/data/di/data_layer_injection.dart`:**
```dart
getIt.registerLazySingleton(() => <Feature>Api(getIt<Dio>()));
getIt.registerLazySingleton<<Feature>Repository>(
  () => <Feature>RepositoryImpl(getIt<<Feature>Api>()),
);
```

**`lib/domain/di/domain_layer_injection.dart`:**
```dart
getIt.registerLazySingleton(() => Get<Feature>UseCase(getIt<<Feature>Repository>()));
```

**`lib/presentation/di/presentation_layer_injection.dart`:**
```dart
getIt.registerFactory(() => <Feature>Store(getIt<Get<Feature>UseCase>()));
```

**`lib/utils/routes/routes.dart`:**
```dart
static const String <feature>Screen = '/<feature>';
```

Add route handler in the `onGenerateRoute` switch/case.

---

## Validation Checklist

Before considering the feature complete, verify:

- [ ] Entity has `@JsonSerializable()` and run build_runner
- [ ] Repository interface is in `lib/domain/` (no Dio or Flutter imports)
- [ ] Repository impl wraps errors with `NetworkExceptions`
- [ ] Use case extends `UseCase` base class
- [ ] Store uses `ObservableFuture` for async state
- [ ] Store has no `BuildContext` references
- [ ] All 3 DI modules updated
- [ ] Route added to `routes.dart`
- [ ] All user-facing strings use `AppLocalization`
- [ ] No hardcoded colors, dimensions, or API URLs in any file
- [ ] build_runner executed after store/model changes

---

## Localization

Add all new strings to `assets/lang/en.json` (and `da.json`, `es.json`):

```json
{
  "<feature>Title": "<Feature> Title",
  "<feature>ErrorMessage": "Failed to load <feature>."
}
```

Access via `AppLocalizations.of(context)!.<feature>Title`.
