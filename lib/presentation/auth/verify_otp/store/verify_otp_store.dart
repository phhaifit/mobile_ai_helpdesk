import 'dart:async';

import 'package:ai_helpdesk/constants/analytics_events.dart';
import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/domain/analytics/analytics_service.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_failure.dart';
import 'package:ai_helpdesk/domain/usecase/account/get_current_account_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/send_otp_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/verify_otp_usecase.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:mobx/mobx.dart';

part 'verify_otp_store.g.dart';

// ignore: library_private_types_in_public_api
class VerifyOtpStore = _VerifyOtpStoreBase with _$VerifyOtpStore;

abstract class _VerifyOtpStoreBase with Store {
  final VerifyOtpUseCase _verifyOtpUseCase;
  final SendOtpUseCase _sendOtpUseCase;
  final GetCurrentAccountUseCase _getCurrentAccountUseCase;
  final AuthStore _authStore;
  final AnalyticsService _analyticsService;

  static const int _resendCooldownSeconds = 60;

  _VerifyOtpStoreBase({
    required VerifyOtpUseCase verifyOtpUseCase,
    required SendOtpUseCase sendOtpUseCase,
    required GetCurrentAccountUseCase getCurrentAccountUseCase,
    required AuthStore authStore,
    required AnalyticsService analyticsService,
  })  : _verifyOtpUseCase = verifyOtpUseCase,
        _sendOtpUseCase = sendOtpUseCase,
        _getCurrentAccountUseCase = getCurrentAccountUseCase,
        _authStore = authStore,
        _analyticsService = analyticsService;

  late String email;

  @observable
  String nonce = '';

  @observable
  String code = '';

  @observable
  String? errorKey;

  @observable
  bool verifiedSuccessfully = false;

  @observable
  ObservableFuture<void>? _verifyFuture;

  @observable
  ObservableFuture<void>? _resendFuture;

  @observable
  int resendCountdown = _resendCooldownSeconds;

  Timer? _timer;

  @computed
  bool get isVerifying => _verifyFuture?.status == FutureStatus.pending;

  @computed
  bool get isResending => _resendFuture?.status == FutureStatus.pending;

  @computed
  bool get canSubmit => code.length == 6 && !isVerifying && nonce.isNotEmpty;

  @computed
  bool get canResend => resendCountdown == 0 && !isResending;

  @action
  void initialise({required String email, required String nonce}) {
    this.email = email;
    this.nonce = nonce;
    _startResendCountdown();
  }

  @action
  void setCode(String value) {
    // Keep only the first 6 alphanumeric characters and normalise to upper
    // for display; conversion to lowercase happens inside the use case so
    // the user can see what they typed in a familiar form.
    code = value.replaceAll(RegExp('[^a-zA-Z0-9]'), '').toUpperCase();
    if (code.length > 6) code = code.substring(0, 6);
    if (errorKey != null) errorKey = null;
  }

  @action
  Future<bool> verify() async {
    if (!canSubmit) return false;
    errorKey = null;
    verifiedSuccessfully = false;
    final future = ObservableFuture<void>(_performVerify());
    _verifyFuture = future;
    await future;
    return verifiedSuccessfully;
  }

  Future<void> _performVerify() async {
    final verifyResult = await _verifyOtpUseCase.call(
      params: VerifyOtpParams(code: code, nonce: nonce),
    );
    await verifyResult.fold<Future<void>>(
      (failure) async {
        errorKey = _messageKeyFor(failure);
        _analyticsService.trackEvent(
          AnalyticsEvents.userLogin,
          parameters: {
            'method': 'otp',
            'success': 'false',
            'stage': 'verify_code',
            'error_code': errorKey ?? 'unknown',
          },
        );
      },
      (session) async {
        final accountResult =
            await _getCurrentAccountUseCase.call(params: null);
        accountResult.fold(
          (failure) {
            errorKey = _messageKeyFor(failure);
          },
          (account) {
            _authStore.onSignedIn(
              session: session,
              account: account,
              isNewUser: session.isNewUser,
            );
            verifiedSuccessfully = true;
          },
        );
      },
    );
  }

  @action
  Future<void> resend() async {
    if (!canResend) return;
    final future = ObservableFuture<void>(_performResend());
    _resendFuture = future;
    await future;
  }

  Future<void> _performResend() async {
    final result = await _sendOtpUseCase.call(params: email);
    result.fold(
      (failure) {
        errorKey = _messageKeyFor(failure);
      },
      (otp) {
        nonce = otp.nonce;
        code = '';
        errorKey = null;
        _startResendCountdown();
      },
    );
  }

  void _startResendCountdown() {
    _timer?.cancel();
    resendCountdown = _resendCooldownSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown <= 1) {
        timer.cancel();
        _setCountdown(0);
      } else {
        _setCountdown(resendCountdown - 1);
      }
    });
  }

  @action
  void _setCountdown(int value) {
    resendCountdown = value;
  }

  /// Gets the human-readable, masked version of [email] for display.
  String get maskedEmail {
    final at = email.indexOf('@');
    if (at <= 1) return email;
    final prefix = email.substring(0, at);
    final keep = prefix.length <= 2 ? prefix : prefix.substring(0, 2);
    return '$keep***${email.substring(at)}';
  }

  String _messageKeyFor(Failure failure) {
    if (failure is AuthFailure) return failure.code;
    if (failure is NetworkFailure) return 'common_error_network';
    if (failure is ServerFailure) return 'common_error_server';
    if (failure is ValidationFailure) return 'auth_error_otp_invalid';
    return 'common_error_unknown';
  }

  void dispose() {
    _timer?.cancel();
  }
}
