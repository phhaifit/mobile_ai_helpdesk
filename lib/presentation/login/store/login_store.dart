import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/data/models/auth/login_request.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_response.dart';
import 'package:ai_helpdesk/domain/usecase/auth/login_usecase.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:dartz/dartz.dart';

import '/constants/analytics_events.dart';
import '/domain/analytics/analytics_service.dart';

part 'login_store.g.dart';

/// MobX Store for managing login functionality.
///
/// Now delegates to [LoginUseCase] for real API authentication.
class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  final LoginUseCase _loginUseCase;
  final AnalyticsService _analyticsService;
  final AuthStore _authStore;

  _LoginStoreBase({
    required LoginUseCase loginUseCase,
    required AnalyticsService analyticsService,
    required AuthStore authStore,
  })  : _loginUseCase = loginUseCase,
        _analyticsService = analyticsService,
        _authStore = authStore;

  // ============================================================================
  // Observable State
  // ============================================================================

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  ObservableFuture<void> loginFuture = ObservableFuture.value(null);

  @observable
  String? errorMessage;

  @observable
  bool isPasswordVisible = false;

  /// Populated after a successful login.
  @observable
  AuthResponse? authResponse;

  // ============================================================================
  // Computed Properties
  // ============================================================================

  @computed
  bool get isLoading => loginFuture.status == FutureStatus.pending;

  @computed
  bool get canSubmit =>
      email.isNotEmpty &&
      password.isNotEmpty &&
      _isValidEmail(email) &&
      password.length >= 6;

  @computed
  bool get isAuthenticated =>
      authResponse != null && authResponse!.token.isNotEmpty;

  // ============================================================================
  // Actions
  // ============================================================================

  @action
  void setEmail(String value) => email = value.trim();

  @action
  void setPassword(String value) => password = value;

  @action
  void togglePasswordVisibility() => isPasswordVisible = !isPasswordVisible;

  @action
  Future<void> login() async {
    errorMessage = null;

    if (!_isValidEmail(email)) {
      errorMessage = 'Invalid email format';
      _trackValidationError('email');
      return;
    }

    if (password.length < 6) {
      errorMessage = 'Password must be at least 6 characters';
      _trackValidationError('password');
      return;
    }

    loginFuture = ObservableFuture(_performLogin());
    await loginFuture;
  }

  Future<void> _performLogin() async {
    try {
      final Either<Failure, AuthResponse> result = await _loginUseCase.call(
        params: LoginRequest(email: email, password: password),
      );

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
          debugPrint('[LoginStore] Login failed: ${failure.message}');
        },
        (response) {
          authResponse = response;
          // Sync to the global AuthStore singleton so sidebar/profile see the user
          _authStore.setAuthFromResponse(response);
          _analyticsService.trackEvent(
            AnalyticsEvents.userLogin,
            parameters: {'method': 'email', 'success': 'true'},
          );
          if (response.user != null) {
            _analyticsService.setUserProperties(
              response.user!.id,
              userProperties: {
                'user_role': 'agent',
                'plan_type': 'free',
                'tenant_id': 'default_tenant',
              },
            );
          }
          debugPrint('[LoginStore] Login successful');
        },
      );
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      errorMessage = msg.isNotEmpty ? msg : 'An error occurred during login. Please try again.';
      await _analyticsService.trackEvent(
        AnalyticsEvents.userLogin,
        parameters: {
          'method': 'email',
          'success': 'false',
          'error_code': 'network_error',
        },
      );
      debugPrint('[LoginStore] Login error: $e');
    }
  }

  @action
  void clear() {
    email = '';
    password = '';
    errorMessage = null;
    authResponse = null;
    loginFuture = ObservableFuture.value(null);
  }

  // ============================================================================
  // Helper Methods
  // ============================================================================

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  Future<void> _trackValidationError(String field) async {
    await _analyticsService.trackEvent(
      AnalyticsEvents.errorOccurred,
      parameters: {
        'error_type': 'validation_error',
        'error_field': field,
        'screen_name': 'login_screen',
      },
    );
  }
}
