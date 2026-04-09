// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginStore on _LoginStoreBase, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(
            () => super.isLoading,
            name: '_LoginStoreBase.isLoading',
          ))
          .value;
  Computed<bool>? _$canSubmitComputed;

  @override
  bool get canSubmit =>
      (_$canSubmitComputed ??= Computed<bool>(
            () => super.canSubmit,
            name: '_LoginStoreBase.canSubmit',
          ))
          .value;
  Computed<bool>? _$isAuthenticatedComputed;

  @override
  bool get isAuthenticated =>
      (_$isAuthenticatedComputed ??= Computed<bool>(
            () => super.isAuthenticated,
            name: '_LoginStoreBase.isAuthenticated',
          ))
          .value;

  late final _$emailAtom = Atom(
    name: '_LoginStoreBase.email',
    context: context,
  );

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$passwordAtom = Atom(
    name: '_LoginStoreBase.password',
    context: context,
  );

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$loginFutureAtom = Atom(
    name: '_LoginStoreBase.loginFuture',
    context: context,
  );

  @override
  ObservableFuture<void> get loginFuture {
    _$loginFutureAtom.reportRead();
    return super.loginFuture;
  }

  @override
  set loginFuture(ObservableFuture<void> value) {
    _$loginFutureAtom.reportWrite(value, super.loginFuture, () {
      super.loginFuture = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_LoginStoreBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$isPasswordVisibleAtom = Atom(
    name: '_LoginStoreBase.isPasswordVisible',
    context: context,
  );

  @override
  bool get isPasswordVisible {
    _$isPasswordVisibleAtom.reportRead();
    return super.isPasswordVisible;
  }

  @override
  set isPasswordVisible(bool value) {
    _$isPasswordVisibleAtom.reportWrite(value, super.isPasswordVisible, () {
      super.isPasswordVisible = value;
    });
  }

  late final _$authResponseAtom = Atom(
    name: '_LoginStoreBase.authResponse',
    context: context,
  );

  @override
  AuthResponse? get authResponse {
    _$authResponseAtom.reportRead();
    return super.authResponse;
  }

  @override
  set authResponse(AuthResponse? value) {
    _$authResponseAtom.reportWrite(value, super.authResponse, () {
      super.authResponse = value;
    });
  }

  late final _$loginAsyncAction = AsyncAction(
    '_LoginStoreBase.login',
    context: context,
  );

  @override
  Future<void> login() {
    return _$loginAsyncAction.run(() => super.login());
  }

  late final _$_LoginStoreBaseActionController = ActionController(
    name: '_LoginStoreBase',
    context: context,
  );

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_LoginStoreBaseActionController.startAction(
      name: '_LoginStoreBase.setEmail',
    );
    try {
      return super.setEmail(value);
    } finally {
      _$_LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String value) {
    final _$actionInfo = _$_LoginStoreBaseActionController.startAction(
      name: '_LoginStoreBase.setPassword',
    );
    try {
      return super.setPassword(value);
    } finally {
      _$_LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void togglePasswordVisibility() {
    final _$actionInfo = _$_LoginStoreBaseActionController.startAction(
      name: '_LoginStoreBase.togglePasswordVisibility',
    );
    try {
      return super.togglePasswordVisibility();
    } finally {
      _$_LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$_LoginStoreBaseActionController.startAction(
      name: '_LoginStoreBase.clear',
    );
    try {
      return super.clear();
    } finally {
      _$_LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
email: ${email},
password: ${password},
loginFuture: ${loginFuture},
errorMessage: ${errorMessage},
isPasswordVisible: ${isPasswordVisible},
authResponse: ${authResponse},
isLoading: ${isLoading},
canSubmit: ${canSubmit},
isAuthenticated: ${isAuthenticated}
    ''';
  }
}
