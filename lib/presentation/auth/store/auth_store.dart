import 'package:ai_helpdesk/constants/analytics_events.dart';
import 'package:ai_helpdesk/core/monitoring/sentry/sentry_service.dart';
import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/data/models/auth/change_password_request.dart';
import 'package:ai_helpdesk/data/models/auth/login_request.dart';
import 'package:ai_helpdesk/data/models/auth/register_request.dart';
import 'package:ai_helpdesk/data/models/auth/reset_password_request.dart';
import 'package:ai_helpdesk/domain/analytics/analytics_service.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_response.dart';
import 'package:ai_helpdesk/domain/entity/auth/user.dart';
import 'package:ai_helpdesk/domain/usecase/auth/change_password_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/get_current_user_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/login_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/logout_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/register_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/request_password_reset_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/reset_password_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'auth_store.g.dart';

// ignore: library_private_types_in_public_api
class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final RequestPasswordResetUseCase _requestPasswordResetUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final AnalyticsService _analyticsService;
  final SentryService _sentryService;

  _AuthStoreBase(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._getCurrentUserUseCase,
    this._changePasswordUseCase,
    this._requestPasswordResetUseCase,
    this._resetPasswordUseCase,
    this._analyticsService,
    this._sentryService,
  );

  // ============================================================================
  // Observables
  // ============================================================================

  /// Current authenticated user
  @observable
  User? currentUser;

  /// Auth response (token + user)
  @observable
  AuthResponse? authResponse;

  /// Error message from last operation
  @observable
  String? errorMessage;

  /// Success message to show to user
  @observable
  String? successMessage;

  /// Loading state for login operation
  @observable
  ObservableFuture<void> loginFuture = ObservableFuture.value(null);

  /// Loading state for register operation
  @observable
  ObservableFuture<void> registerFuture = ObservableFuture.value(null);

  /// Loading state for logout operation
  @observable
  ObservableFuture<void> logoutFuture = ObservableFuture.value(null);

  /// Loading state for get current user operation
  @observable
  ObservableFuture<void> getCurrentUserFuture = ObservableFuture.value(null);

  /// Loading state for change password operation
  @observable
  ObservableFuture<void> changePasswordFuture = ObservableFuture.value(null);

  /// Loading state for request password reset operation
  @observable
  ObservableFuture<void> requestPasswordResetFuture = ObservableFuture.value(null);

  /// Loading state for reset password operation
  @observable
  ObservableFuture<void> resetPasswordFuture = ObservableFuture.value(null);

  // ============================================================================
  // Computed
  // ============================================================================

  /// Check if user is authenticated
  @computed
  bool get isAuthenticated =>
      authResponse != null && authResponse!.token.isNotEmpty;

  /// Check if login is loading
  @computed
  bool get isLoginLoading => loginFuture.status == FutureStatus.pending;

  /// Check if register is loading
  @computed
  bool get isRegisterLoading => registerFuture.status == FutureStatus.pending;

  /// Check if logout is loading
  @computed
  bool get isLogoutLoading => logoutFuture.status == FutureStatus.pending;

  /// Check if get current user is loading
  @computed
  bool get isGetCurrentUserLoading =>
      getCurrentUserFuture.status == FutureStatus.pending;

  /// Check if change password is loading
  @computed
  bool get isChangePasswordLoading =>
      changePasswordFuture.status == FutureStatus.pending;

  /// Check if request password reset is loading
  @computed
  bool get isRequestPasswordResetLoading =>
      requestPasswordResetFuture.status == FutureStatus.pending;

  /// Check if reset password is loading
  @computed
  bool get isResetPasswordLoading =>
      resetPasswordFuture.status == FutureStatus.pending;

  /// Check if any operation is loading
  @computed
  bool get isLoading =>
      isLoginLoading ||
      isRegisterLoading ||
      isLogoutLoading ||
      isGetCurrentUserLoading ||
      isChangePasswordLoading ||
      isResetPasswordLoading;

  // ============================================================================
  // Actions - Login & Register
  // ============================================================================

  /// Login with email and password
  @action
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) async {
    errorMessage = null;
    successMessage = null;

    _sentryService.addBreadcrumb(
      message: 'User submitted login form',
      category: 'auth',
      data: {'email': email, 'action': 'login_attempt'},
      type: 'user',
    );

    loginFuture = ObservableFuture(
      _loginUseCase
          .call(
            params: LoginRequest(email: email, password: password),
          )
          .then((result) {
            result.fold(
              (failure) {
                errorMessage = failure.message;
                _analyticsService.trackEvent(
                  AnalyticsEvents.userLogin,
                  parameters: {
                    'method': 'email',
                    'success': 'false',
                    'error_code': 'auth_failure',
                  },
                );
                _sentryService.addBreadcrumb(
                  message: 'Login failed',
                  category: 'auth',
                  level: SentryLevel.warning,
                  data: {'reason': failure.message},
                  type: 'user',
                );
              },
              (authResp) {
                authResponse = authResp;
                currentUser = authResp.user;
                successMessage = 'Login successful!';

                final uid = authResp.userId ?? authResp.user?.id ?? '';
                final userEmail = authResp.user?.email ?? '';

                // Track successful login & set user properties
                _analyticsService.trackEvent(
                  AnalyticsEvents.userLogin,
                  parameters: {'method': 'email', 'success': 'true'},
                );
                if (uid.isNotEmpty) {
                  _analyticsService.setUserProperties(
                    uid,
                    userProperties: {
                      'user_role': 'agent',
                      'plan_type': 'free',
                      'tenant_id': 'default_tenant',
                    },
                  );
                }
                _sentryService.setUserContext(
                  userId: uid,
                  email: userEmail,
                  tenantId: SentryService.defaultTenantId,
                );
                _sentryService.addBreadcrumb(
                  message: 'Login successful',
                  category: 'auth',
                  data: {'user_id': uid},
                  type: 'user',
                );
                debugPrint(
                  '[AuthStore] User properties set for $uid',
                );
              },
            );
          }),
    );

    await loginFuture;
    return isAuthenticated
        ? const Right(null)
        : Left(UnknownFailure(errorMessage ?? 'Login failed'));
  }

  /// Register new account
  @action
  Future<Either<Failure, void>> register({
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    errorMessage = null;
    successMessage = null;

    registerFuture = ObservableFuture(
      _registerUseCase
          .call(
            params: RegisterRequest(
              email: email,
              username: username,
              password: password,
              confirmPassword: confirmPassword,
            ),
          )
          .then((result) {
            result.fold((failure) => errorMessage = failure.message, (
              authResp,
            ) {
              authResponse = authResp;
              currentUser = authResp.user;
              successMessage = 'Registration successful!';
            });
          }),
    );

    await registerFuture;
    return isAuthenticated
        ? const Right(null)
        : Left(UnknownFailure(errorMessage ?? 'Registration failed'));
  }

  // ============================================================================
  // Actions - User Management
  // ============================================================================

  /// Get current logged-in user
  @action
  Future<Either<Failure, void>> getCurrentUser() async {
    errorMessage = null;

    getCurrentUserFuture = ObservableFuture(
      _getCurrentUserUseCase.call(params: null).then((result) {
        result.fold(
          (failure) => errorMessage = failure.message,
          (user) => currentUser = user,
        );
      }),
    );

    await getCurrentUserFuture;
    return currentUser != null
        ? const Right(null)
        : Left(UnknownFailure(errorMessage ?? 'Failed to get user'));
  }

  /// Logout current user
  @action
  Future<Either<Failure, void>> logout() async {
    errorMessage = null;
    successMessage = null;

    logoutFuture = ObservableFuture(
      _logoutUseCase.call(params: null).then((result) {
        result.fold((failure) => errorMessage = failure.message, (_) {
          _analyticsService.trackEvent(AnalyticsEvents.userLogout);
          _sentryService.addBreadcrumb(
            message: 'User logged out',
            category: 'auth',
            type: 'user',
          );
          _sentryService.clearUserContext();
          authResponse = null;
          currentUser = null;
          successMessage = 'Logged out successfully';
        });
      }),
    );

    await logoutFuture;
    return !isAuthenticated
        ? const Right(null)
        : Left(UnknownFailure(errorMessage ?? 'Logout failed'));
  }

  // ============================================================================
  // Actions - Password Management
  // ============================================================================

  /// Change current password
  @action
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    errorMessage = null;
    successMessage = null;

    changePasswordFuture = ObservableFuture(
      _changePasswordUseCase
          .call(
            params: ChangePasswordRequest(
              currentPassword: currentPassword,
              newPassword: newPassword,
              confirmPassword: confirmPassword,
            ),
          )
          .then((result) {
            result.fold(
              (failure) => errorMessage = failure.message,
              (_) => successMessage = 'Password changed successfully',
            );
          }),
    );

    await changePasswordFuture;
    return errorMessage == null
        ? const Right(null)
        : Left(UnknownFailure(errorMessage ?? 'Failed to change password'));
  }

  /// Reset password with reset token
  @action
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    errorMessage = null;
    successMessage = null;

    resetPasswordFuture = ObservableFuture(
      _resetPasswordUseCase
          .call(
            params: ResetPasswordRequest(
              email: email,
              token: token,
              newPassword: newPassword,
              confirmPassword: confirmPassword,
            ),
          )
          .then((result) {
            result.fold(
              (failure) => errorMessage = failure.message,
              (_) => successMessage = 'Password reset successfully',
            );
          }),
    );

    await resetPasswordFuture;
    return errorMessage == null
        ? const Right(null)
        : Left(UnknownFailure(errorMessage ?? 'Failed to reset password'));
  }

  // ============================================================================
  // Actions - Request Password Reset
  // ============================================================================

  /// Request password reset email
  @action
  Future<Either<Failure, void>> requestPasswordReset({
    required String email,
  }) async {
    errorMessage = null;
    successMessage = null;

    requestPasswordResetFuture = ObservableFuture(
      _requestPasswordResetUseCase
          .call(params: email)
          .then((result) {
            result.fold(
              (failure) => errorMessage = failure.message,
              (_) => successMessage = 'Reset link sent to your email',
            );
          }),
    );

    await requestPasswordResetFuture;
    return errorMessage == null
        ? const Right(null)
        : Left(UnknownFailure(errorMessage ?? 'Failed to send reset email'));
  }

  // ============================================================================
  // Actions - Sync from external login
  // ============================================================================

  /// Set auth response from an external login (e.g. LoginStore)
  @action
  void setAuthFromResponse(AuthResponse response) {
    authResponse = response;
    currentUser = response.user;
  }

  // ============================================================================
  // Clear Messages
  // ============================================================================

  /// Clear error message
  @action
  void clearErrorMessage() => errorMessage = null;

  /// Clear success message
  @action
  void clearSuccessMessage() => successMessage = null;

  /// Clear all messages
  @action
  void clearAllMessages() {
    errorMessage = null;
    successMessage = null;
  }
}
