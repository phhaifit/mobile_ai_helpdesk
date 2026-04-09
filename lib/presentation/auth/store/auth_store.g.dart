// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStoreBase, Store {
  Computed<bool>? _$isAuthenticatedComputed;

  @override
  bool get isAuthenticated =>
      (_$isAuthenticatedComputed ??= Computed<bool>(
            () => super.isAuthenticated,
            name: '_AuthStoreBase.isAuthenticated',
          ))
          .value;
  Computed<bool>? _$isLoginLoadingComputed;

  @override
  bool get isLoginLoading =>
      (_$isLoginLoadingComputed ??= Computed<bool>(
            () => super.isLoginLoading,
            name: '_AuthStoreBase.isLoginLoading',
          ))
          .value;
  Computed<bool>? _$isRegisterLoadingComputed;

  @override
  bool get isRegisterLoading =>
      (_$isRegisterLoadingComputed ??= Computed<bool>(
            () => super.isRegisterLoading,
            name: '_AuthStoreBase.isRegisterLoading',
          ))
          .value;
  Computed<bool>? _$isLogoutLoadingComputed;

  @override
  bool get isLogoutLoading =>
      (_$isLogoutLoadingComputed ??= Computed<bool>(
            () => super.isLogoutLoading,
            name: '_AuthStoreBase.isLogoutLoading',
          ))
          .value;
  Computed<bool>? _$isGetCurrentUserLoadingComputed;

  @override
  bool get isGetCurrentUserLoading =>
      (_$isGetCurrentUserLoadingComputed ??= Computed<bool>(
            () => super.isGetCurrentUserLoading,
            name: '_AuthStoreBase.isGetCurrentUserLoading',
          ))
          .value;
  Computed<bool>? _$isChangePasswordLoadingComputed;

  @override
  bool get isChangePasswordLoading =>
      (_$isChangePasswordLoadingComputed ??= Computed<bool>(
            () => super.isChangePasswordLoading,
            name: '_AuthStoreBase.isChangePasswordLoading',
          ))
          .value;
  Computed<bool>? _$isRequestPasswordResetLoadingComputed;

  @override
  bool get isRequestPasswordResetLoading =>
      (_$isRequestPasswordResetLoadingComputed ??= Computed<bool>(
            () => super.isRequestPasswordResetLoading,
            name: '_AuthStoreBase.isRequestPasswordResetLoading',
          ))
          .value;
  Computed<bool>? _$isResetPasswordLoadingComputed;

  @override
  bool get isResetPasswordLoading =>
      (_$isResetPasswordLoadingComputed ??= Computed<bool>(
            () => super.isResetPasswordLoading,
            name: '_AuthStoreBase.isResetPasswordLoading',
          ))
          .value;
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(
            () => super.isLoading,
            name: '_AuthStoreBase.isLoading',
          ))
          .value;

  late final _$currentUserAtom = Atom(
    name: '_AuthStoreBase.currentUser',
    context: context,
  );

  @override
  User? get currentUser {
    _$currentUserAtom.reportRead();
    return super.currentUser;
  }

  @override
  set currentUser(User? value) {
    _$currentUserAtom.reportWrite(value, super.currentUser, () {
      super.currentUser = value;
    });
  }

  late final _$authResponseAtom = Atom(
    name: '_AuthStoreBase.authResponse',
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

  late final _$errorMessageAtom = Atom(
    name: '_AuthStoreBase.errorMessage',
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

  late final _$successMessageAtom = Atom(
    name: '_AuthStoreBase.successMessage',
    context: context,
  );

  @override
  String? get successMessage {
    _$successMessageAtom.reportRead();
    return super.successMessage;
  }

  @override
  set successMessage(String? value) {
    _$successMessageAtom.reportWrite(value, super.successMessage, () {
      super.successMessage = value;
    });
  }

  late final _$loginFutureAtom = Atom(
    name: '_AuthStoreBase.loginFuture',
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

  late final _$registerFutureAtom = Atom(
    name: '_AuthStoreBase.registerFuture',
    context: context,
  );

  @override
  ObservableFuture<void> get registerFuture {
    _$registerFutureAtom.reportRead();
    return super.registerFuture;
  }

  @override
  set registerFuture(ObservableFuture<void> value) {
    _$registerFutureAtom.reportWrite(value, super.registerFuture, () {
      super.registerFuture = value;
    });
  }

  late final _$logoutFutureAtom = Atom(
    name: '_AuthStoreBase.logoutFuture',
    context: context,
  );

  @override
  ObservableFuture<void> get logoutFuture {
    _$logoutFutureAtom.reportRead();
    return super.logoutFuture;
  }

  @override
  set logoutFuture(ObservableFuture<void> value) {
    _$logoutFutureAtom.reportWrite(value, super.logoutFuture, () {
      super.logoutFuture = value;
    });
  }

  late final _$getCurrentUserFutureAtom = Atom(
    name: '_AuthStoreBase.getCurrentUserFuture',
    context: context,
  );

  @override
  ObservableFuture<void> get getCurrentUserFuture {
    _$getCurrentUserFutureAtom.reportRead();
    return super.getCurrentUserFuture;
  }

  @override
  set getCurrentUserFuture(ObservableFuture<void> value) {
    _$getCurrentUserFutureAtom.reportWrite(
      value,
      super.getCurrentUserFuture,
      () {
        super.getCurrentUserFuture = value;
      },
    );
  }

  late final _$changePasswordFutureAtom = Atom(
    name: '_AuthStoreBase.changePasswordFuture',
    context: context,
  );

  @override
  ObservableFuture<void> get changePasswordFuture {
    _$changePasswordFutureAtom.reportRead();
    return super.changePasswordFuture;
  }

  @override
  set changePasswordFuture(ObservableFuture<void> value) {
    _$changePasswordFutureAtom.reportWrite(
      value,
      super.changePasswordFuture,
      () {
        super.changePasswordFuture = value;
      },
    );
  }

  late final _$requestPasswordResetFutureAtom = Atom(
    name: '_AuthStoreBase.requestPasswordResetFuture',
    context: context,
  );

  @override
  ObservableFuture<void> get requestPasswordResetFuture {
    _$requestPasswordResetFutureAtom.reportRead();
    return super.requestPasswordResetFuture;
  }

  @override
  set requestPasswordResetFuture(ObservableFuture<void> value) {
    _$requestPasswordResetFutureAtom.reportWrite(
      value,
      super.requestPasswordResetFuture,
      () {
        super.requestPasswordResetFuture = value;
      },
    );
  }

  late final _$resetPasswordFutureAtom = Atom(
    name: '_AuthStoreBase.resetPasswordFuture',
    context: context,
  );

  @override
  ObservableFuture<void> get resetPasswordFuture {
    _$resetPasswordFutureAtom.reportRead();
    return super.resetPasswordFuture;
  }

  @override
  set resetPasswordFuture(ObservableFuture<void> value) {
    _$resetPasswordFutureAtom.reportWrite(value, super.resetPasswordFuture, () {
      super.resetPasswordFuture = value;
    });
  }

  late final _$loginAsyncAction = AsyncAction(
    '_AuthStoreBase.login',
    context: context,
  );

  @override
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) {
    return _$loginAsyncAction.run(
      () => super.login(email: email, password: password),
    );
  }

  late final _$registerAsyncAction = AsyncAction(
    '_AuthStoreBase.register',
    context: context,
  );

  @override
  Future<Either<Failure, void>> register({
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
  }) {
    return _$registerAsyncAction.run(
      () => super.register(
        email: email,
        username: username,
        password: password,
        confirmPassword: confirmPassword,
      ),
    );
  }

  late final _$getCurrentUserAsyncAction = AsyncAction(
    '_AuthStoreBase.getCurrentUser',
    context: context,
  );

  @override
  Future<Either<Failure, void>> getCurrentUser() {
    return _$getCurrentUserAsyncAction.run(() => super.getCurrentUser());
  }

  late final _$logoutAsyncAction = AsyncAction(
    '_AuthStoreBase.logout',
    context: context,
  );

  @override
  Future<Either<Failure, void>> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  late final _$changePasswordAsyncAction = AsyncAction(
    '_AuthStoreBase.changePassword',
    context: context,
  );

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    return _$changePasswordAsyncAction.run(
      () => super.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      ),
    );
  }

  late final _$resetPasswordAsyncAction = AsyncAction(
    '_AuthStoreBase.resetPassword',
    context: context,
  );

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) {
    return _$resetPasswordAsyncAction.run(
      () => super.resetPassword(
        email: email,
        token: token,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      ),
    );
  }

  late final _$requestPasswordResetAsyncAction = AsyncAction(
    '_AuthStoreBase.requestPasswordReset',
    context: context,
  );

  @override
  Future<Either<Failure, void>> requestPasswordReset({required String email}) {
    return _$requestPasswordResetAsyncAction.run(
      () => super.requestPasswordReset(email: email),
    );
  }

  late final _$_AuthStoreBaseActionController = ActionController(
    name: '_AuthStoreBase',
    context: context,
  );

  @override
  void setAuthFromResponse(AuthResponse response) {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
      name: '_AuthStoreBase.setAuthFromResponse',
    );
    try {
      return super.setAuthFromResponse(response);
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearErrorMessage() {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
      name: '_AuthStoreBase.clearErrorMessage',
    );
    try {
      return super.clearErrorMessage();
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSuccessMessage() {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
      name: '_AuthStoreBase.clearSuccessMessage',
    );
    try {
      return super.clearSuccessMessage();
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearAllMessages() {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
      name: '_AuthStoreBase.clearAllMessages',
    );
    try {
      return super.clearAllMessages();
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentUser: ${currentUser},
authResponse: ${authResponse},
errorMessage: ${errorMessage},
successMessage: ${successMessage},
loginFuture: ${loginFuture},
registerFuture: ${registerFuture},
logoutFuture: ${logoutFuture},
getCurrentUserFuture: ${getCurrentUserFuture},
changePasswordFuture: ${changePasswordFuture},
requestPasswordResetFuture: ${requestPasswordResetFuture},
resetPasswordFuture: ${resetPasswordFuture},
isAuthenticated: ${isAuthenticated},
isLoginLoading: ${isLoginLoading},
isRegisterLoading: ${isRegisterLoading},
isLogoutLoading: ${isLogoutLoading},
isGetCurrentUserLoading: ${isGetCurrentUserLoading},
isChangePasswordLoading: ${isChangePasswordLoading},
isRequestPasswordResetLoading: ${isRequestPasswordResetLoading},
isResetPasswordLoading: ${isResetPasswordLoading},
isLoading: ${isLoading}
    ''';
  }
}
