import 'dart:io';

import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/domain/entity/account/account.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_failure.dart';
import 'package:ai_helpdesk/domain/repository/account/account_repository.dart';
import 'package:ai_helpdesk/domain/usecase/account/delete_avatar_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/account/update_account_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/account/upload_avatar_usecase.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:mobx/mobx.dart';

part 'profile_store.g.dart';

// ignore: library_private_types_in_public_api
class ProfileStore = _ProfileStoreBase with _$ProfileStore;

/// Backs the (single) profile screen. The screen edits the account inline —
/// `fullname` and `phoneNumber` are mutable; `email` and `role` are shown
/// read-only because the backend keys records by email and roles are managed
/// elsewhere. Avatar uploads go through the same store so the screen stays
/// stateless. Reads the current account reactively from [AuthStore].
abstract class _ProfileStoreBase with Store {
  final UpdateAccountUseCase _updateAccountUseCase;
  final UploadAvatarUseCase _uploadAvatarUseCase;
  final DeleteAvatarUseCase _deleteAvatarUseCase;
  final AuthStore _authStore;

  _ProfileStoreBase({
    required UpdateAccountUseCase updateAccountUseCase,
    required UploadAvatarUseCase uploadAvatarUseCase,
    required DeleteAvatarUseCase deleteAvatarUseCase,
    required AuthStore authStore,
  })  : _updateAccountUseCase = updateAccountUseCase,
        _uploadAvatarUseCase = uploadAvatarUseCase,
        _deleteAvatarUseCase = deleteAvatarUseCase,
        _authStore = authStore;

  @observable
  String fullname = '';

  @observable
  String phoneNumber = '';

  @observable
  String? errorKey;

  @observable
  bool savedSuccessfully = false;

  @observable
  ObservableFuture<void>? _saveFuture;

  /// One in-flight avatar mutation at a time — either an upload or a removal.
  @observable
  ObservableFuture<bool>? _avatarFuture;

  @computed
  Account? get account => _authStore.account;

  @computed
  bool get isSaving => _saveFuture?.status == FutureStatus.pending;

  /// True while an avatar upload or removal is in progress.
  @computed
  bool get isAvatarBusy => _avatarFuture?.status == FutureStatus.pending;

  @computed
  bool get hasAvatar {
    final picture = account?.profilePicture;
    return picture != null && picture.isNotEmpty;
  }

  @computed
  bool get isDirty {
    final current = _authStore.account;
    if (current == null) return false;
    return fullname.trim() != (current.fullname ?? '') ||
        phoneNumber.trim() != (current.phoneNumber ?? '');
  }

  @computed
  bool get canSubmit => !isSaving && isDirty && fullname.trim().isNotEmpty;

  @action
  void seedFrom(Account account) {
    fullname = account.fullname ?? '';
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
    final future = ObservableFuture<void>(_performSave(account));
    _saveFuture = future;
    await future;
    return savedSuccessfully;
  }

  Future<void> _performSave(Account account) async {
    final params = AccountUpdateParams(
      fullname: fullname.trim(),
      phoneNumber: phoneNumber.trim().isEmpty ? null : phoneNumber.trim(),
      // email keys the record; `name`/`username` are left as-is (not editable
      // on this screen) but echoed back so a full-replace backend is happy.
      email: account.email,
      name: account.username,
      username: account.username,
    );
    final result = await _updateAccountUseCase.call(params: params);
    await result.fold<Future<void>>(
      (failure) async {
        errorKey = _messageKeyFor(failure);
      },
      (_) async {
        // Re-fetch canonical account so every cached consumer stays in sync,
        // then re-seed the editable fields off whatever the backend stored.
        await _authStore.refreshAccount();
        final refreshed = _authStore.account;
        if (refreshed != null) {
          fullname = refreshed.fullname ?? '';
          phoneNumber = refreshed.phoneNumber ?? '';
        }
        errorKey = null;
        savedSuccessfully = true;
      },
    );
  }

  @action
  Future<bool> uploadAvatar(File file) {
    if (isAvatarBusy) return Future<bool>.value(false);
    final future = ObservableFuture<bool>(_performAvatarUpload(file));
    _avatarFuture = future;
    return future;
  }

  Future<bool> _performAvatarUpload(File file) async {
    final result = await _uploadAvatarUseCase.call(params: file);
    return result.fold<Future<bool>>(
      (_) async => false,
      (_) async {
        await _authStore.refreshAccount();
        return true;
      },
    );
  }

  @action
  Future<bool> removeAvatar() {
    if (isAvatarBusy || !hasAvatar) return Future<bool>.value(false);
    final future = ObservableFuture<bool>(_performAvatarRemoval());
    _avatarFuture = future;
    return future;
  }

  Future<bool> _performAvatarRemoval() async {
    final result = await _deleteAvatarUseCase.call(params: null);
    return result.fold<Future<bool>>(
      (_) async => false,
      (_) async {
        await _authStore.refreshAccount();
        return true;
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
