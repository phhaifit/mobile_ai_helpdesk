// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EditProfileStore on _EditProfileStoreBase, Store {
  Computed<bool>? _$isSavingComputed;

  @override
  bool get isSaving =>
      (_$isSavingComputed ??= Computed<bool>(
            () => super.isSaving,
            name: '_EditProfileStoreBase.isSaving',
          ))
          .value;
  Computed<bool>? _$isDirtyComputed;

  @override
  bool get isDirty =>
      (_$isDirtyComputed ??= Computed<bool>(
            () => super.isDirty,
            name: '_EditProfileStoreBase.isDirty',
          ))
          .value;
  Computed<bool>? _$canSubmitComputed;

  @override
  bool get canSubmit =>
      (_$canSubmitComputed ??= Computed<bool>(
            () => super.canSubmit,
            name: '_EditProfileStoreBase.canSubmit',
          ))
          .value;

  late final _$fullnameAtom = Atom(
    name: '_EditProfileStoreBase.fullname',
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

  late final _$usernameAtom = Atom(
    name: '_EditProfileStoreBase.username',
    context: context,
  );

  @override
  String get username {
    _$usernameAtom.reportRead();
    return super.username;
  }

  @override
  set username(String value) {
    _$usernameAtom.reportWrite(value, super.username, () {
      super.username = value;
    });
  }

  late final _$phoneNumberAtom = Atom(
    name: '_EditProfileStoreBase.phoneNumber',
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
    name: '_EditProfileStoreBase.errorKey',
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
    name: '_EditProfileStoreBase.savedSuccessfully',
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
    name: '_EditProfileStoreBase._saveFuture',
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

  late final _$saveAsyncAction = AsyncAction(
    '_EditProfileStoreBase.save',
    context: context,
  );

  @override
  Future<bool> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  late final _$_EditProfileStoreBaseActionController = ActionController(
    name: '_EditProfileStoreBase',
    context: context,
  );

  @override
  void seedFrom(Account account) {
    final _$actionInfo = _$_EditProfileStoreBaseActionController.startAction(
      name: '_EditProfileStoreBase.seedFrom',
    );
    try {
      return super.seedFrom(account);
    } finally {
      _$_EditProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFullname(String value) {
    final _$actionInfo = _$_EditProfileStoreBaseActionController.startAction(
      name: '_EditProfileStoreBase.setFullname',
    );
    try {
      return super.setFullname(value);
    } finally {
      _$_EditProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUsername(String value) {
    final _$actionInfo = _$_EditProfileStoreBaseActionController.startAction(
      name: '_EditProfileStoreBase.setUsername',
    );
    try {
      return super.setUsername(value);
    } finally {
      _$_EditProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPhoneNumber(String value) {
    final _$actionInfo = _$_EditProfileStoreBaseActionController.startAction(
      name: '_EditProfileStoreBase.setPhoneNumber',
    );
    try {
      return super.setPhoneNumber(value);
    } finally {
      _$_EditProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fullname: ${fullname},
username: ${username},
phoneNumber: ${phoneNumber},
errorKey: ${errorKey},
savedSuccessfully: ${savedSuccessfully},
isSaving: ${isSaving},
isDirty: ${isDirty},
canSubmit: ${canSubmit}
    ''';
  }
}
