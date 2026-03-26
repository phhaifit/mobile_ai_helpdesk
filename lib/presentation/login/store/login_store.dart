import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

import '/constants/analytics_events.dart';
import '/domain/analytics/analytics_service.dart';

part 'login_store.g.dart';

/// MobX Store for managing login functionality.
///
/// Responsibilities:
/// - Manage login form state (loading, error, success)
/// - Handle login action with validation
/// - Track analytics events for user authentication
///
/// Analytics Events Tracked:
/// - user_login: Fired on every login attempt with success/failure status
/// - error_occurred: Fired if validation or network errors occur
class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  final AnalyticsService _analyticsService;

  _LoginStoreBase({required AnalyticsService analyticsService})
    : _analyticsService = analyticsService;

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

  // ============================================================================
  // Computed Properties
  // ============================================================================

  /// True if login form is currently loading.
  @computed
  bool get isLoading => loginFuture.status == FutureStatus.pending;

  /// True if login form can be submitted (emails and password are valid).
  @computed
  bool get canSubmit =>
      email.isNotEmpty &&
      password.isNotEmpty &&
      _isValidEmail(email) &&
      password.length >= 6;

  // ============================================================================
  // Actions (Mutations)
  // ============================================================================

  /// Updates the email field value.
  @action
  void setEmail(String value) {
    email = value.trim();
  }

  /// Updates the password field value.
  @action
  void setPassword(String value) {
    password = value;
  }

  /// Toggles password visibility.
  @action
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
  }

  /// Attempts to login with the provided email and password.
  ///
  /// Performs:
  /// 1. Validation of input
  /// 2. API call (mocked for now)
  /// 3. Analytics tracking
  /// 4. Error handling
  ///
  /// Tracks analytics events:
  /// - user_login: Success or failure event with method and error code (if failed)
  /// - error_occurred: If validation fails
  @action
  Future<void> login() async {
    // Clear previous error
    errorMessage = null;

    // Validate form
    if (!_isValidEmail(email)) {
      errorMessage = 'Invalid email format';

      // Track validation error
      await _analyticsService.trackEvent(
        AnalyticsEvents.errorOccurred,
        parameters: {
          'error_type': 'validation_error',
          'error_field': 'email',
          'screen_name': 'login_screen',
        },
      );

      return;
    }

    if (password.length < 6) {
      errorMessage = 'Password must be at least 6 characters';

      // Track validation error
      await _analyticsService.trackEvent(
        AnalyticsEvents.errorOccurred,
        parameters: {
          'error_type': 'validation_error',
          'error_field': 'password',
          'screen_name': 'login_screen',
        },
      );

      return;
    }

    // Set loading state
    loginFuture = ObservableFuture(_performLogin());
    await loginFuture;
  }

  /// Performs the actual login operation.
  ///
  /// This is separated from the action to allow for clean separation of concerns.
  /// The actual implementation would call a use case or repository.
  Future<void> _performLogin() async {
    try {
      // TODO: Replace with actual authentication use case
      // For now, simulate a network call
      await Future.delayed(const Duration(seconds: 1));

      // For demo, only allow specific credentials to succeed
      final isSuccess = email == 'test@example.com' && password == 'password';

      if (isSuccess) {
        // Track successful login
        await _analyticsService.trackEvent(
          AnalyticsEvents.userLogin,
          parameters: {'method': 'email', 'success': 'true'},
        );

        // Set user properties
        await _analyticsService.setUserProperty('user_type', 'customer');

        debugPrint('[LoginStore] Login successful');
      } else {
        // Track failed login
        await _analyticsService.trackEvent(
          AnalyticsEvents.userLogin,
          parameters: {
            'method': 'email',
            'success': 'false',
            'error_code': 'invalid_credentials',
          },
        );

        errorMessage = 'Invalid email or password';
        debugPrint('[LoginStore] Login failed: Invalid credentials');
      }
    } catch (e) {
      // Track error
      await _analyticsService.trackEvent(
        AnalyticsEvents.userLogin,
        parameters: {
          'method': 'email',
          'success': 'false',
          'error_code': 'network_error',
        },
      );

      await _analyticsService.trackEvent(
        AnalyticsEvents.errorOccurred,
        parameters: {
          'error_type': 'login_error',
          'error_message': 'Network error occurred',
          'screen_name': 'login_screen',
        },
      );

      errorMessage = 'An error occurred during login. Please try again.';
      debugPrint('[LoginStore] Login error: $e');
    }
  }

  /// Clears all form data and errors.
  @action
  void clear() {
    email = '';
    password = '';
    password = '';
    errorMessage = null;
    loginFuture = ObservableFuture.value(null);
  }

  // ============================================================================
  // Helper Methods
  // ============================================================================

  /// Validates email format using a simple regex pattern.
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}
