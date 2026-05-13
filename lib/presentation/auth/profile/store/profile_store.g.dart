// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProfileStore on _ProfileStoreBase, Store {
  Computed<Account?>? _$accountComputed;

  @override
  Account? get account =>
      (_$accountComputed ??= Computed<Account?>(
            () => super.account,
            name: '_ProfileStoreBase.account',
          ))
          .value;
  Computed<bool>? _$isSavingComputed;

  @override
  bool get isSaving =>
      (_$isSavingComputed ??= Computed<bool>(
            () => super.isSaving,
            name: '_ProfileStoreBase.isSaving',
          ))
          .value;
  Computed<bool>? _$isAvatarBusyComputed;

  @override
  bool get isAvatarBusy =>
      (_$isAvatarBusyComputed ??= Computed<bool>(
            () => super.isAvatarBusy,
            name: '_ProfileStoreBase.isAvatarBusy',
          ))
          .value;
  Computed<bool>? _$hasAvatarComputed;

  @override
  bool get hasAvatar =>
      (_$hasAvatarComputed ??= Computed<bool>(
            () => super.hasAvatar,
            name: '_ProfileStoreBase.hasAvatar',
          ))
          .value;
  Computed<bool>? _$isDirtyComputed;

  @override
  bool get isDirty =>
      (_$isDirtyComputed ??= Computed<bool>(
            () => super.isDirty,
            name: '_ProfileStoreBase.isDirty',
          ))
          .value;
  Computed<bool>? _$canSubmitComputed;

  @override
  bool get canSubmit =>
      (_$canSubmitComputed ??= Computed<bool>(
            () => super.canSubmit,
            name: '_ProfileStoreBase.canSubmit',
          ))
          .value;

  late final _$fullnameAtom = Atom(
    name: '_ProfileStoreBase.fullname',
    context: context,
  );

  @override
  String get fullname {
    _$fullnameAtom.reportRead();
    return super.fullname;
  }

  @override
  set fullname(String value) {
    _$fullnameAtom.reportWrite(value, super.fullname, () {
      super.fullname = value;
    });
  }

  late final _$phoneNumberAtom = Atom(
    name: '_ProfileStoreBase.phoneNumber',
    context: context,
  );

  @override
  String get phoneNumber {
    _$phoneNumberAtom.reportRead();
    return super.phoneNumber;
  }

  @override
  set phoneNumber(String value) {
    _$phoneNumberAtom.reportWrite(value, super.phoneNumber, () {
      super.phoneNumber = value;
    });
  }

  late final _$errorKeyAtom = Atom(
    name: '_ProfileStoreBase.errorKey',
    context: context,
  );

  @override
  String? get errorKey {
    _$errorKeyAtom.reportRead();
    return super.errorKey;
  }

  @override
  set errorKey(String? value) {
    _$errorKeyAtom.reportWrite(value, super.errorKey, () {
      super.errorKey = value;
    });
  }

  late final _$savedSuccessfullyAtom = Atom(
    name: '_ProfileStoreBase.savedSuccessfully',
    context: context,
  );

  @override
  bool get savedSuccessfully {
    _$savedSuccessfullyAtom.reportRead();
    return super.savedSuccessfully;
  }

  @override
  set savedSuccessfully(bool value) {
    _$savedSuccessfullyAtom.reportWrite(value, super.savedSuccessfully, () {
      super.savedSuccessfully = value;
    });
  }

  late final _$_saveFutureAtom = Atom(
    name: '_ProfileStoreBase._saveFuture',
    context: context,
  );

  @override
  ObservableFuture<void>? get _saveFuture {
    _$_saveFutureAtom.reportRead();
    return super._saveFuture;
  }

  @override
  set _saveFuture(ObservableFuture<void>? value) {
    _$_saveFutureAtom.reportWrite(value, super._saveFuture, () {
      super._saveFuture = value;
    });
  }

  late final _$_avatarFutureAtom = Atom(
    name: '_ProfileStoreBase._avatarFuture',
    context: context,
  );

  @override
  ObservableFuture<bool>? get _avatarFuture {
    _$_avatarFutureAtom.reportRead();
    return super._avatarFuture;
  }

  @override
  set _avatarFuture(ObservableFuture<bool>? value) {
    _$_avatarFutureAtom.reportWrite(value, super._avatarFuture, () {
      super._avatarFuture = value;
    });
  }

  late final _$saveAsyncAction = AsyncAction(
    '_ProfileStoreBase.save',
    context: context,
  );

  @override
  Future<bool> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  late final _$_ProfileStoreBaseActionController = ActionController(
    name: '_ProfileStoreBase',
    context: context,
  );

  @override
  void seedFrom(Account account) {
    final _$actionInfo = _$_ProfileStoreBaseActionController.startAction(
      name: '_ProfileStoreBase.seedFrom',
    );
    try {
      return super.seedFrom(account);
    } finally {
      _$_ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFullname(String value) {
    final _$actionInfo = _$_ProfileStoreBaseActionController.startAction(
      name: '_ProfileStoreBase.setFullname',
    );
    try {
      return super.setFullname(value);
    } finally {
      _$_ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPhoneNumber(String value) {
    final _$actionInfo = _$_ProfileStoreBaseActionController.startAction(
      name: '_ProfileStoreBase.setPhoneNumber',
    );
    try {
      return super.setPhoneNumber(value);
    } finally {
      _$_ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<bool> uploadAvatar(File file) {
    final _$actionInfo = _$_ProfileStoreBaseActionController.startAction(
      name: '_ProfileStoreBase.uploadAvatar',
    );
    try {
      return super.uploadAvatar(file);
    } finally {
      _$_ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<bool> removeAvatar() {
    final _$actionInfo = _$_ProfileStoreBaseActionController.startAction(
      name: '_ProfileStoreBase.removeAvatar',
    );
    try {
      return super.removeAvatar();
    } finally {
      _$_ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fullname: ${fullname},
phoneNumber: ${phoneNumber},
errorKey: ${errorKey},
savedSuccessfully: ${savedSuccessfully},
account: ${account},
isSaving: ${isSaving},
isAvatarBusy: ${isAvatarBusy},
hasAvatar: ${hasAvatar},
isDirty: ${isDirty},
canSubmit: ${canSubmit}
    ''';
  }
}
