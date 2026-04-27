import 'dart:async';

import 'package:ai_helpdesk/constants/analytics_events.dart';
import 'package:ai_helpdesk/core/events/auth_events.dart';
import 'package:ai_helpdesk/core/monitoring/sentry/sentry_service.dart';
import 'package:ai_helpdesk/domain/analytics/analytics_service.dart';
import 'package:ai_helpdesk/domain/entity/account/account.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_session.dart';
import 'package:ai_helpdesk/domain/repository/account/account_repository.dart';
import 'package:ai_helpdesk/domain/repository/auth/auth_repository.dart';
import 'package:ai_helpdesk/domain/usecase/auth/sign_out_usecase.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'auth_store.g.dart';

// ignore: library_private_types_in_public_api
class AuthStore = _AuthStoreBase with _$AuthStore;

/// App-wide auth session state. Individual screens own their own submit
/// stores (sign-in email, verify OTP); this store is the single source of
/// truth for "is the user signed in and who are they" once the app is past
/// the splash guard.
abstract class _AuthStoreBase with Store {
  final AuthRepository _authRepository;
  final AccountRepository _accountRepository;
  final SignOutUseCase _signOutUseCase;
  final AnalyticsService _analyticsService;
  final SentryService _sentryService;
  final EventBus _eventBus;
  StreamSubscription<AuthUnauthorizedEvent>? _unauthorizedSub;

  _AuthStoreBase({
    required AuthRepository authRepository,
    required AccountRepository accountRepository,
    required SignOutUseCase signOutUseCase,
    required EventBus eventBus,
    required AnalyticsService analyticsService,
    required SentryService sentryService,
  })  : _authRepository = authRepository,
        _accountRepository = accountRepository,
        _signOutUseCase = signOutUseCase,
        _eventBus = eventBus,
        _analyticsService = analyticsService,
        _sentryService = sentryService {
    _unauthorizedSub = _eventBus.on<AuthUnauthorizedEvent>().listen((event) {
      onSignedOut(reason: event.reason);
    });
  }

  @observable
  AuthSession? session;

  @observable
  Account? account;

  @observable
  bool isSigningOut = false;

  @computed
  bool get isAuthenticated => session != null && account != null;

  /// Called by the splash guard once it has loaded the persisted session +
  /// account from local storage.
  @action
  void hydrate({required AuthSession session, required Account account}) {
    this.session = session;
    this.account = account;
    _sentryService.setUserContext(
      userId: account.accountId,
      email: account.email,
      tenantId: account.tenantId ?? SentryService.defaultTenantId,
    );
  }

  /// Called by the sign-in flow immediately after a successful OTP exchange +
  /// `/sso-validate` round-trip.
  @action
  void onSignedIn({
    required AuthSession session,
    required Account account,
    bool isNewUser = false,
  }) {
    this.session = session;
    this.account = account;
    _analyticsService.trackEvent(
      AnalyticsEvents.userLogin,
      parameters: {
        'method': 'otp',
        'success': 'true',
        'is_new_user': isNewUser ? 'true' : 'false',
      },
    );
    _analyticsService.setUserProperties(
      account.accountId,
      userProperties: {
        'user_role': account.role,
        'tenant_id': account.tenantId ?? '',
      },
    );
    _sentryService.setUserContext(
      userId: account.accountId,
      email: account.email,
      tenantId: account.tenantId ?? SentryService.defaultTenantId,
    );
  }

  /// Keep cached access token fresh so reactive UI that reads from [session]
  /// does not show a stale value. Called by refresh flows.
  @action
  void onAccessTokenRefreshed(String newAccessToken) {
    final current = session;
    if (current != null) {
      session = current.copyWith(accessToken: newAccessToken);
    }
  }

  @action
  Future<void> signOut() async {
    isSigningOut = true;
    try {
      await _signOutUseCase.call(params: null);
      _analyticsService.trackEvent(AnalyticsEvents.userLogout);
    } catch (e, s) {
      debugPrint('[AuthStore] signOut error: $e\n$s');
    } finally {
      onSignedOut(reason: 'user_initiated');
      isSigningOut = false;
    }
  }

  /// Tear down session state — called by explicit sign-out and by the
  /// unauthorized event listener. Safe to call multiple times.
  @action
  void onSignedOut({String reason = 'unknown'}) {
    if (session == null && account == null) return;
    session = null;
    account = null;
    _sentryService.clearUserContext();
    _sentryService.addBreadcrumb(
      message: 'User signed out',
      category: 'auth',
      data: {'reason': reason},
      level: SentryLevel.info,
    );
  }

  /// Refresh the account payload in the background (called opportunistically
  /// by screens that need the latest tenant/role info). Returns true on
  /// success; callers can ignore failures since a cached Account is still
  /// served.
  @action
  Future<bool> refreshAccount() async {
    final result = await _accountRepository.getCurrent();
    return result.fold((_) => false, (a) {
      account = a;
      return true;
    });
  }

  /// Expose the repository for the splash guard without leaking it across
  /// the UI layer more broadly.
  AuthRepository get authRepository => _authRepository;
  AccountRepository get accountRepository => _accountRepository;

  void dispose() {
    _unauthorizedSub?.cancel();
  }
}
