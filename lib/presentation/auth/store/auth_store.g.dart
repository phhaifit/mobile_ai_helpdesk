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

  late final _$sessionAtom = Atom(
    name: '_AuthStoreBase.session',
    context: context,
  );

  @override
  AuthSession? get session {
    _$sessionAtom.reportRead();
    return super.session;
  }

  @override
  set session(AuthSession? value) {
    _$sessionAtom.reportWrite(value, super.session, () {
      super.session = value;
    });
  }

  late final _$accountAtom = Atom(
    name: '_AuthStoreBase.account',
    context: context,
  );

  @override
  Account? get account {
    _$accountAtom.reportRead();
    return super.account;
  }

  @override
  set account(Account? value) {
    _$accountAtom.reportWrite(value, super.account, () {
      super.account = value;
    });
  }

  late final _$isSigningOutAtom = Atom(
    name: '_AuthStoreBase.isSigningOut',
    context: context,
  );

  @override
  bool get isSigningOut {
    _$isSigningOutAtom.reportRead();
    return super.isSigningOut;
  }

  @override
  set isSigningOut(bool value) {
    _$isSigningOutAtom.reportWrite(value, super.isSigningOut, () {
      super.isSigningOut = value;
    });
  }

  late final _$signOutAsyncAction = AsyncAction(
    '_AuthStoreBase.signOut',
    context: context,
  );

  @override
  Future<void> signOut() {
    return _$signOutAsyncAction.run(() => super.signOut());
  }

  late final _$refreshAccountAsyncAction = AsyncAction(
    '_AuthStoreBase.refreshAccount',
    context: context,
  );

  @override
  Future<bool> refreshAccount() {
    return _$refreshAccountAsyncAction.run(() => super.refreshAccount());
  }

  late final _$_AuthStoreBaseActionController = ActionController(
    name: '_AuthStoreBase',
    context: context,
  );

  @override
  void hydrate({required AuthSession session, required Account account}) {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
      name: '_AuthStoreBase.hydrate',
    );
    try {
      return super.hydrate(session: session, account: account);
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onSignedIn({
    required AuthSession session,
    required Account account,
    bool isNewUser = false,
  }) {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
      name: '_AuthStoreBase.onSignedIn',
    );
    try {
      return super.onSignedIn(
        session: session,
        account: account,
        isNewUser: isNewUser,
      );
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onAccessTokenRefreshed(String newAccessToken) {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
      name: '_AuthStoreBase.onAccessTokenRefreshed',
    );
    try {
      return super.onAccessTokenRefreshed(newAccessToken);
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onSignedOut({String reason = 'unknown'}) {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
      name: '_AuthStoreBase.onSignedOut',
    );
    try {
      return super.onSignedOut(reason: reason);
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
session: ${session},
account: ${account},
isSigningOut: ${isSigningOut},
isAuthenticated: ${isAuthenticated}
    ''';
  }
}
