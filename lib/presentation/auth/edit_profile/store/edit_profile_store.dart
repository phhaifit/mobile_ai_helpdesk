import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/domain/entity/account/account.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_failure.dart';
import 'package:ai_helpdesk/domain/repository/account/account_repository.dart';
import 'package:ai_helpdesk/domain/usecase/account/update_account_usecase.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:mobx/mobx.dart';

part 'edit_profile_store.g.dart';

// ignore: library_private_types_in_public_api
class EditProfileStore = _EditProfileStoreBase with _$EditProfileStore;

abstract class _EditProfileStoreBase with Store {
  final UpdateAccountUseCase _updateAccountUseCase;
  final AuthStore _authStore;

  _EditProfileStoreBase({
    required UpdateAccountUseCase updateAccountUseCase,
    required AuthStore authStore,
  })  : _updateAccountUseCase = updateAccountUseCase,
        _authStore = authStore;

  @observable
  String fullname = '';

  @observable
  String username = '';

  @observable
  String phoneNumber = '';

  @observable
  String? errorKey;

  @observable
  bool savedSuccessfully = false;

  @observable
  ObservableFuture<void>? _saveFuture;

  @computed
  bool get isSaving => _saveFuture?.status == FutureStatus.pending;

  @computed
  bool get isDirty {
    final account = _authStore.account;
    if (account == null) return false;
    return fullname.trim() != (account.fullname ?? '') ||
        username.trim() != account.username ||
        phoneNumber.trim() != (account.phoneNumber ?? '');
  }

  @computed
  bool get canSubmit =>
      !isSaving &&
      isDirty &&
      fullname.trim().isNotEmpty &&
      username.trim().isNotEmpty;

  @action
  void seedFrom(Account account) {
    fullname = account.fullname ?? '';
    username = account.username;
    phoneNumber = account.phoneNumber ?? '';
    errorKey = null;
    savedSuccessfully = false;
  }

  @action
  void setFullname(String value) {
    fullname = value;
    if (errorKey != null) errorKey = null;
  }

  @action
  void setUsername(String value) {
    username = value;
    if (errorKey != null) errorKey = null;
  }

  @action
  void setPhoneNumber(String value) {
    phoneNumber = value;
    if (errorKey != null) errorKey = null;
  }

  @action
  Future<bool> save() async {
    final account = _authStore.account;
    if (account == null || !canSubmit) return false;
    errorKey = null;
    savedSuccessfully = false;
    final future = ObservableFuture<void>(_perform(account));
    _saveFuture = future;
    await future;
    return savedSuccessfully;
  }

  Future<void> _perform(Account account) async {
    final params = AccountUpdateParams(
      fullname: fullname.trim(),
      username: username.trim(),
      phoneNumber: phoneNumber.trim().isEmpty ? null : phoneNumber.trim(),
      // Backend mirrors `name` off the username in the sample payload.
      name: username.trim(),
      email: account.email,
    );
    final result = await _updateAccountUseCase.call(params: params);
    await result.fold<Future<void>>(
      (failure) async {
        errorKey = _messageKeyFor(failure);
      },
      (_) async {
        // Re-fetch canonical account so every cached consumer stays in sync.
        await _authStore.refreshAccount();
        savedSuccessfully = true;
      },
    );
  }

  String _messageKeyFor(Failure failure) {
    if (failure is AuthFailure) return failure.code;
    if (failure is NetworkFailure) return 'common_error_network';
    if (failure is ServerFailure) return 'common_error_server';
    if (failure is ValidationFailure) return 'common_error_unknown';
    return 'common_error_unknown';
  }
}
