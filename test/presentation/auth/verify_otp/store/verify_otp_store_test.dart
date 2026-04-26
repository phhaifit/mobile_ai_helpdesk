import 'dart:io';

import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/core/monitoring/sentry/sentry_service.dart';
import 'package:ai_helpdesk/domain/analytics/analytics_service.dart';
import 'package:ai_helpdesk/domain/entity/account/account.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_session.dart';
import 'package:ai_helpdesk/domain/entity/auth/otp_send_result.dart';
import 'package:ai_helpdesk/domain/repository/account/account_repository.dart';
import 'package:ai_helpdesk/domain/repository/auth/auth_repository.dart';
import 'package:ai_helpdesk/domain/usecase/account/get_current_account_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/send_otp_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/sign_out_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/verify_otp_usecase.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:ai_helpdesk/presentation/auth/verify_otp/store/verify_otp_store.dart';
import 'package:dartz/dartz.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, OtpSendResult>> sendOtp({
    required String email,
  }) async {
    return const Right(OtpSendResult(nonce: 'nonce-2'));
  }

  @override
  Future<Either<Failure, AuthSession>> signInWithOtp({
    required String code,
    required String nonce,
  }) async {
    return const Right(
      AuthSession(
        accessToken: 'access',
        refreshToken: 'refresh',
        userId: 'u1',
        isNewUser: false,
      ),
    );
  }

  @override
  Future<Either<Failure, String>> refreshAccessToken() async =>
      const Right('new-access');

  @override
  Future<Either<Failure, void>> signOut() async => const Right(null);

  @override
  Future<AuthSession?> loadSession() async => null;

  @override
  Future<bool> isAuthenticated() async => false;
}

class _FakeAccountRepository implements AccountRepository {
  @override
  Future<Either<Failure, Account>> getCurrent() async {
    return Right(
      Account.fromJson(<String, dynamic>{
        'accountID': 'acc-1',
        'tenantID': null,
        'email': 'user@example.com',
        'username': 'jarvis',
        'fullname': null,
        'role': 'agent',
        'isBlocked': false,
      }),
    );
  }

  @override
  Future<Account?> loadCached() async => null;

  @override
  Future<Either<Failure, void>> update(AccountUpdateParams params) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> uploadAvatar(File file) async =>
      const Right(null);
}

class _FakeAnalyticsService implements AnalyticsService {
  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {}

  @override
  Future<void> setUserProperties(
    String userId, {
    required Map<String, String> userProperties,
  }) async {}

  @override
  Future<void> setUserProperty(String name, String value) async {}

  @override
  Future<void> trackAppOpen({
    required String installSource,
    Map<String, String>? utmParams,
    String? sessionId,
  }) async {}

  @override
  Future<void> trackEvent(
    String eventName, {
    Map<String, String>? parameters,
  }) async {}

  @override
  Future<void> trackScreenView(
    String screenName, {
    String? screenClass,
    Map<String, String>? utmParams,
  }) async {}
}

class _FakeSentryService extends SentryService {
  @override
  Future<void> setUserContext({
    required String userId,
    String? email,
    String tenantId = SentryService.defaultTenantId,
  }) async {}

  @override
  Future<void> clearUserContext() async {}

  @override
  Future<void> addBreadcrumb({
    required String message,
    required String category,
    SentryLevel level = SentryLevel.info,
    Map<String, dynamic>? data,
    String? type,
  }) async {}
}

void main() {
  group('VerifyOtpStore', () {
    late VerifyOtpStore store;
    late AuthStore authStore;

    setUp(() {
      final authRepository = _FakeAuthRepository();
      final accountRepository = _FakeAccountRepository();
      final analyticsService = _FakeAnalyticsService();

      authStore = AuthStore(
        authRepository: authRepository,
        accountRepository: accountRepository,
        signOutUseCase: SignOutUseCase(authRepository),
        eventBus: EventBus(),
        analyticsService: analyticsService,
        sentryService: _FakeSentryService(),
      );

      store = VerifyOtpStore(
        verifyOtpUseCase: VerifyOtpUseCase(authRepository),
        sendOtpUseCase: SendOtpUseCase(authRepository),
        getCurrentAccountUseCase: GetCurrentAccountUseCase(accountRepository),
        authStore: authStore,
        analyticsService: analyticsService,
      );
    });

    tearDown(() {
      store.dispose();
      authStore.dispose();
    });

    test(
      'marks verification successful when account fields are nullable',
      () async {
        store.initialise(email: 'user@example.com', nonce: 'nonce-1');
        store.setCode('ABC123');

        final isSuccess = await store.verify();

        expect(isSuccess, isTrue);
        expect(store.errorKey, isNull);
        expect(store.verifiedSuccessfully, isTrue);
        expect(authStore.account, isNotNull);
        expect(authStore.account?.tenantId, '');
        expect(authStore.account?.fullname, '');
      },
    );
  });
}
