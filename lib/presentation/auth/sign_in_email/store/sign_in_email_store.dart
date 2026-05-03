import 'package:ai_helpdesk/constants/analytics_events.dart';
import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/domain/analytics/analytics_service.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_failure.dart';
import 'package:ai_helpdesk/domain/usecase/account/get_current_account_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/send_otp_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/sign_in_with_google_usecase.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:mobx/mobx.dart';

part 'sign_in_email_store.g.dart';

// ignore: library_private_types_in_public_api
class SignInEmailStore = _SignInEmailStoreBase with _$SignInEmailStore;

abstract class _SignInEmailStoreBase with Store {
  final SendOtpUseCase _sendOtpUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final GetCurrentAccountUseCase _getCurrentAccountUseCase;
  final AuthStore _authStore;
  final AnalyticsService _analyticsService;

  _SignInEmailStoreBase({
    required SendOtpUseCase sendOtpUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required GetCurrentAccountUseCase getCurrentAccountUseCase,
    required AuthStore authStore,
    required AnalyticsService analyticsService,
  })  : _sendOtpUseCase = sendOtpUseCase,
        _signInWithGoogleUseCase = signInWithGoogleUseCase,
        _getCurrentAccountUseCase = getCurrentAccountUseCase,
        _authStore = authStore,
        _analyticsService = analyticsService;

  @observable
  String email = '';

  @observable
  ObservableFuture<void>? _sendFuture;

  @observable
  ObservableFuture<void>? _googleFuture;

  /// Localization key describing the latest error, or null when clean.
  @observable
  String? errorKey;

  /// The nonce returned by the backend on the most recent successful send.
  /// Read by the screen to pass into the OTP verification route.
  @observable
  String? issuedNonce;

  /// Set to true after a successful Google sign-in so the screen can
  /// `pushNamedAndRemoveUntil` to home.
  @observable
  bool googleSignInSucceeded = false;

  @computed
  bool get isLoading => _sendFuture?.status == FutureStatus.pending;

  @computed
  bool get isGoogleSignInLoading =>
      _googleFuture?.status == FutureStatus.pending;

  /// Disables both buttons while either flow is in flight.
  @computed
  bool get isAnyFlowInFlight => isLoading || isGoogleSignInLoading;

  @computed
  bool get canSubmit => !isAnyFlowInFlight && email.trim().isNotEmpty;

  @computed
  bool get canStartGoogleSignIn => !isAnyFlowInFlight;

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

  /// Runs the Google OAuth flow end-to-end. Returns true on success so the
  /// screen can navigate to home.
  ///
  /// When [forceAccountChooser] is true, cached Google cookies are cleared
  /// before the WebView loads so the user can pick a different account.
  @action
  Future<bool> signInWithGoogle({bool forceAccountChooser = false}) async {
    if (!canStartGoogleSignIn) return false;
    errorKey = null;
    googleSignInSucceeded = false;
    final future = ObservableFuture<void>(
      _performGoogleSignIn(forceAccountChooser: forceAccountChooser),
    );
    _googleFuture = future;
    await future;
    return googleSignInSucceeded;
  }

  Future<void> _performGoogleSignIn({required bool forceAccountChooser}) async {
    final result = await _signInWithGoogleUseCase.call(
      params: SignInWithGoogleParams(
        forceAccountChooser: forceAccountChooser,
      ),
    );
    await result.fold<Future<void>>(
      (failure) async {
        // Cancellations are silent — no error banner — but we do clear
        // any stale `googleSignInSucceeded` flag.
        if (failure is OAuthCancelledFailure) {
          return;
        }
        errorKey = _messageKeyFor(failure);
        _analyticsService.trackEvent(
          AnalyticsEvents.userLogin,
          parameters: {
            'method': 'google_oauth',
            'success': 'false',
            'stage': 'oauth',
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
            googleSignInSucceeded = true;
            _analyticsService.trackEvent(
              AnalyticsEvents.userLogin,
              parameters: {
                'method': 'google_oauth',
                'success': 'true',
                'is_new_user': session.isNewUser ? 'true' : 'false',
              },
            );
          },
        );
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
