import 'package:ai_helpdesk/constants/analytics_events.dart';
import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/domain/analytics/analytics_service.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_failure.dart';
import 'package:ai_helpdesk/domain/usecase/auth/send_otp_usecase.dart';
import 'package:mobx/mobx.dart';

part 'sign_in_email_store.g.dart';

// ignore: library_private_types_in_public_api
class SignInEmailStore = _SignInEmailStoreBase with _$SignInEmailStore;

abstract class _SignInEmailStoreBase with Store {
  final SendOtpUseCase _sendOtpUseCase;
  final AnalyticsService _analyticsService;

  _SignInEmailStoreBase({
    required SendOtpUseCase sendOtpUseCase,
    required AnalyticsService analyticsService,
  })  : _sendOtpUseCase = sendOtpUseCase,
        _analyticsService = analyticsService;

  @observable
  String email = '';

  @observable
  ObservableFuture<void>? _sendFuture;

  /// Localization key describing the latest error, or null when clean.
  @observable
  String? errorKey;

  /// The nonce returned by the backend on the most recent successful send.
  /// Read by the screen to pass into the OTP verification route.
  @observable
  String? issuedNonce;

  @computed
  bool get isLoading => _sendFuture?.status == FutureStatus.pending;

  @computed
  bool get canSubmit => !isLoading && email.trim().isNotEmpty;

  @action
  void setEmail(String value) {
    email = value.trim();
    if (errorKey != null) errorKey = null;
  }

  @action
  Future<String?> sendOtp() async {
    errorKey = null;
    issuedNonce = null;
    final future = ObservableFuture<void>(_perform());
    _sendFuture = future;
    await future;
    return issuedNonce;
  }

  Future<void> _perform() async {
    final result = await _sendOtpUseCase.call(params: email);
    result.fold(
      (failure) {
        errorKey = _messageKeyFor(failure);
        _analyticsService.trackEvent(
          AnalyticsEvents.userLogin,
          parameters: {
            'method': 'otp',
            'success': 'false',
            'stage': 'send_code',
            'error_code': errorKey ?? 'unknown',
          },
        );
      },
      (otp) {
        issuedNonce = otp.nonce;
      },
    );
  }

  String _messageKeyFor(Failure failure) {
    if (failure is InvalidEmailFailure) return 'auth_error_invalid_email';
    if (failure is AuthFailure) return failure.code;
    if (failure is NetworkFailure) return 'common_error_network';
    if (failure is ServerFailure) return 'common_error_server';
    return 'common_error_unknown';
  }
}
