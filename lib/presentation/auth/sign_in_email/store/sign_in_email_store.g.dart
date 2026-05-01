// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_email_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SignInEmailStore on _SignInEmailStoreBase, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading =>
      (_$isLoadingComputed ??= Computed<bool>(
            () => super.isLoading,
            name: '_SignInEmailStoreBase.isLoading',
          ))
          .value;
  Computed<bool>? _$isGoogleSignInLoadingComputed;

  @override
  bool get isGoogleSignInLoading =>
      (_$isGoogleSignInLoadingComputed ??= Computed<bool>(
            () => super.isGoogleSignInLoading,
            name: '_SignInEmailStoreBase.isGoogleSignInLoading',
          ))
          .value;
  Computed<bool>? _$isAnyFlowInFlightComputed;

  @override
  bool get isAnyFlowInFlight =>
      (_$isAnyFlowInFlightComputed ??= Computed<bool>(
            () => super.isAnyFlowInFlight,
            name: '_SignInEmailStoreBase.isAnyFlowInFlight',
          ))
          .value;
  Computed<bool>? _$canSubmitComputed;

  @override
  bool get canSubmit =>
      (_$canSubmitComputed ??= Computed<bool>(
            () => super.canSubmit,
            name: '_SignInEmailStoreBase.canSubmit',
          ))
          .value;
  Computed<bool>? _$canStartGoogleSignInComputed;

  @override
  bool get canStartGoogleSignIn =>
      (_$canStartGoogleSignInComputed ??= Computed<bool>(
            () => super.canStartGoogleSignIn,
            name: '_SignInEmailStoreBase.canStartGoogleSignIn',
          ))
          .value;

  late final _$emailAtom = Atom(
    name: '_SignInEmailStoreBase.email',
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

  late final _$_sendFutureAtom = Atom(
    name: '_SignInEmailStoreBase._sendFuture',
    context: context,
  );

  @override
  ObservableFuture<void>? get _sendFuture {
    _$_sendFutureAtom.reportRead();
    return super._sendFuture;
  }

  @override
  set _sendFuture(ObservableFuture<void>? value) {
    _$_sendFutureAtom.reportWrite(value, super._sendFuture, () {
      super._sendFuture = value;
    });
  }

  late final _$_googleFutureAtom = Atom(
    name: '_SignInEmailStoreBase._googleFuture',
    context: context,
  );

  @override
  ObservableFuture<void>? get _googleFuture {
    _$_googleFutureAtom.reportRead();
    return super._googleFuture;
  }

  @override
  set _googleFuture(ObservableFuture<void>? value) {
    _$_googleFutureAtom.reportWrite(value, super._googleFuture, () {
      super._googleFuture = value;
    });
  }

  late final _$errorKeyAtom = Atom(
    name: '_SignInEmailStoreBase.errorKey',
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

  late final _$issuedNonceAtom = Atom(
    name: '_SignInEmailStoreBase.issuedNonce',
    context: context,
  );

  @override
  String? get issuedNonce {
    _$issuedNonceAtom.reportRead();
    return super.issuedNonce;
  }

  @override
  set issuedNonce(String? value) {
    _$issuedNonceAtom.reportWrite(value, super.issuedNonce, () {
      super.issuedNonce = value;
    });
  }

  late final _$googleSignInSucceededAtom = Atom(
    name: '_SignInEmailStoreBase.googleSignInSucceeded',
    context: context,
  );

  @override
  bool get googleSignInSucceeded {
    _$googleSignInSucceededAtom.reportRead();
    return super.googleSignInSucceeded;
  }

  @override
  set googleSignInSucceeded(bool value) {
    _$googleSignInSucceededAtom.reportWrite(
      value,
      super.googleSignInSucceeded,
      () {
        super.googleSignInSucceeded = value;
      },
    );
  }

  late final _$sendOtpAsyncAction = AsyncAction(
    '_SignInEmailStoreBase.sendOtp',
    context: context,
  );

  @override
  Future<String?> sendOtp() {
    return _$sendOtpAsyncAction.run(() => super.sendOtp());
  }

  late final _$signInWithGoogleAsyncAction = AsyncAction(
    '_SignInEmailStoreBase.signInWithGoogle',
    context: context,
  );

  @override
  Future<bool> signInWithGoogle() {
    return _$signInWithGoogleAsyncAction.run(() => super.signInWithGoogle());
  }

  late final _$_SignInEmailStoreBaseActionController = ActionController(
    name: '_SignInEmailStoreBase',
    context: context,
  );

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_SignInEmailStoreBaseActionController.startAction(
      name: '_SignInEmailStoreBase.setEmail',
    );
    try {
      return super.setEmail(value);
    } finally {
      _$_SignInEmailStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
email: ${email},
errorKey: ${errorKey},
issuedNonce: ${issuedNonce},
googleSignInSucceeded: ${googleSignInSucceeded},
isLoading: ${isLoading},
isGoogleSignInLoading: ${isGoogleSignInLoading},
isAnyFlowInFlight: ${isAnyFlowInFlight},
canSubmit: ${canSubmit},
canStartGoogleSignIn: ${canStartGoogleSignIn}
    ''';
  }
}
