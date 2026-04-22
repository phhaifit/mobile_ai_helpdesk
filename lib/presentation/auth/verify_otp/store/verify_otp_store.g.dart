// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VerifyOtpStore on _VerifyOtpStoreBase, Store {
  Computed<bool>? _$isVerifyingComputed;

  @override
  bool get isVerifying =>
      (_$isVerifyingComputed ??= Computed<bool>(
            () => super.isVerifying,
            name: '_VerifyOtpStoreBase.isVerifying',
          ))
          .value;
  Computed<bool>? _$isResendingComputed;

  @override
  bool get isResending =>
      (_$isResendingComputed ??= Computed<bool>(
            () => super.isResending,
            name: '_VerifyOtpStoreBase.isResending',
          ))
          .value;
  Computed<bool>? _$canSubmitComputed;

  @override
  bool get canSubmit =>
      (_$canSubmitComputed ??= Computed<bool>(
            () => super.canSubmit,
            name: '_VerifyOtpStoreBase.canSubmit',
          ))
          .value;
  Computed<bool>? _$canResendComputed;

  @override
  bool get canResend =>
      (_$canResendComputed ??= Computed<bool>(
            () => super.canResend,
            name: '_VerifyOtpStoreBase.canResend',
          ))
          .value;

  late final _$nonceAtom = Atom(
    name: '_VerifyOtpStoreBase.nonce',
    context: context,
  );

  @override
  String get nonce {
    _$nonceAtom.reportRead();
    return super.nonce;
  }

  @override
  set nonce(String value) {
    _$nonceAtom.reportWrite(value, super.nonce, () {
      super.nonce = value;
    });
  }

  late final _$codeAtom = Atom(
    name: '_VerifyOtpStoreBase.code',
    context: context,
  );

  @override
  String get code {
    _$codeAtom.reportRead();
    return super.code;
  }

  @override
  set code(String value) {
    _$codeAtom.reportWrite(value, super.code, () {
      super.code = value;
    });
  }

  late final _$errorKeyAtom = Atom(
    name: '_VerifyOtpStoreBase.errorKey',
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

  late final _$verifiedSuccessfullyAtom = Atom(
    name: '_VerifyOtpStoreBase.verifiedSuccessfully',
    context: context,
  );

  @override
  bool get verifiedSuccessfully {
    _$verifiedSuccessfullyAtom.reportRead();
    return super.verifiedSuccessfully;
  }

  @override
  set verifiedSuccessfully(bool value) {
    _$verifiedSuccessfullyAtom.reportWrite(
      value,
      super.verifiedSuccessfully,
      () {
        super.verifiedSuccessfully = value;
      },
    );
  }

  late final _$_verifyFutureAtom = Atom(
    name: '_VerifyOtpStoreBase._verifyFuture',
    context: context,
  );

  @override
  ObservableFuture<void>? get _verifyFuture {
    _$_verifyFutureAtom.reportRead();
    return super._verifyFuture;
  }

  @override
  set _verifyFuture(ObservableFuture<void>? value) {
    _$_verifyFutureAtom.reportWrite(value, super._verifyFuture, () {
      super._verifyFuture = value;
    });
  }

  late final _$_resendFutureAtom = Atom(
    name: '_VerifyOtpStoreBase._resendFuture',
    context: context,
  );

  @override
  ObservableFuture<void>? get _resendFuture {
    _$_resendFutureAtom.reportRead();
    return super._resendFuture;
  }

  @override
  set _resendFuture(ObservableFuture<void>? value) {
    _$_resendFutureAtom.reportWrite(value, super._resendFuture, () {
      super._resendFuture = value;
    });
  }

  late final _$resendCountdownAtom = Atom(
    name: '_VerifyOtpStoreBase.resendCountdown',
    context: context,
  );

  @override
  int get resendCountdown {
    _$resendCountdownAtom.reportRead();
    return super.resendCountdown;
  }

  @override
  set resendCountdown(int value) {
    _$resendCountdownAtom.reportWrite(value, super.resendCountdown, () {
      super.resendCountdown = value;
    });
  }

  late final _$verifyAsyncAction = AsyncAction(
    '_VerifyOtpStoreBase.verify',
    context: context,
  );

  @override
  Future<bool> verify() {
    return _$verifyAsyncAction.run(() => super.verify());
  }

  late final _$resendAsyncAction = AsyncAction(
    '_VerifyOtpStoreBase.resend',
    context: context,
  );

  @override
  Future<void> resend() {
    return _$resendAsyncAction.run(() => super.resend());
  }

  late final _$_VerifyOtpStoreBaseActionController = ActionController(
    name: '_VerifyOtpStoreBase',
    context: context,
  );

  @override
  void initialise({required String email, required String nonce}) {
    final _$actionInfo = _$_VerifyOtpStoreBaseActionController.startAction(
      name: '_VerifyOtpStoreBase.initialise',
    );
    try {
      return super.initialise(email: email, nonce: nonce);
    } finally {
      _$_VerifyOtpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCode(String value) {
    final _$actionInfo = _$_VerifyOtpStoreBaseActionController.startAction(
      name: '_VerifyOtpStoreBase.setCode',
    );
    try {
      return super.setCode(value);
    } finally {
      _$_VerifyOtpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setCountdown(int value) {
    final _$actionInfo = _$_VerifyOtpStoreBaseActionController.startAction(
      name: '_VerifyOtpStoreBase._setCountdown',
    );
    try {
      return super._setCountdown(value);
    } finally {
      _$_VerifyOtpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
nonce: ${nonce},
code: ${code},
errorKey: ${errorKey},
verifiedSuccessfully: ${verifiedSuccessfully},
resendCountdown: ${resendCountdown},
isVerifying: ${isVerifying},
isResending: ${isResending},
canSubmit: ${canSubmit},
canResend: ${canResend}
    ''';
  }
}
