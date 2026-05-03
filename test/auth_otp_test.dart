import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/data/network/stack_error_mapper.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_failure.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_session.dart';
import 'package:ai_helpdesk/domain/entity/auth/otp_send_result.dart';
import 'package:ai_helpdesk/domain/repository/auth/auth_repository.dart';
import 'package:ai_helpdesk/domain/usecase/auth/send_otp_usecase.dart';
import 'package:ai_helpdesk/domain/usecase/auth/verify_otp_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  String? capturedEmail;
  String? capturedCode;
  String? capturedNonce;
  Either<Failure, AuthSession> signInResult = const Right(
    AuthSession(
      accessToken: 'access',
      refreshToken: 'refresh',
      userId: 'u1',
      isNewUser: false,
    ),
  );

  @override
  Future<Either<Failure, OtpSendResult>> sendOtp({required String email}) async {
    capturedEmail = email;
    return const Right(OtpSendResult(nonce: 'n0nce'));
  }

  @override
  Future<Either<Failure, AuthSession>> signInWithOtp({
    required String code,
    required String nonce,
  }) async {
    capturedCode = code;
    capturedNonce = nonce;
    return signInResult;
  }

  @override
  Future<Either<Failure, String>> refreshAccessToken() async =>
      const Right('new_access');

  @override
  Future<Either<Failure, AuthSession>> signInWithGoogle({
    bool forceAccountChooser = false,
  }) async => signInResult;

  @override
  Future<Either<Failure, void>> signOut() async => const Right(null);

  @override
  Future<AuthSession?> loadSession() async => null;

  @override
  Future<bool> isAuthenticated() async => false;
}

DioException _dioErr(int status, Map<String, dynamic>? body) => DioException(
      requestOptions: RequestOptions(path: '/x'),
      response: Response<dynamic>(
        requestOptions: RequestOptions(path: '/x'),
        statusCode: status,
        data: body,
      ),
      type: DioExceptionType.badResponse,
    );

void main() {
  group('SendOtpUseCase', () {
    test('rejects invalid email', () async {
      final repo = _FakeAuthRepository();
      final useCase = SendOtpUseCase(repo);
      final result = await useCase.call(params: 'not-an-email');
      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<InvalidEmailFailure>()),
        (_) => fail('expected Left'),
      );
      expect(repo.capturedEmail, isNull);
    });

    test('forwards valid email (trimmed) to repository', () async {
      final repo = _FakeAuthRepository();
      final useCase = SendOtpUseCase(repo);
      await useCase.call(params: '  user@example.com  ');
      expect(repo.capturedEmail, 'user@example.com');
    });
  });

  group('VerifyOtpUseCase', () {
    test('rejects short code', () async {
      final repo = _FakeAuthRepository();
      final useCase = VerifyOtpUseCase(repo);
      final result = await useCase.call(
        params: const VerifyOtpParams(code: 'ABC', nonce: 'n0nce'),
      );
      result.fold(
        (f) => expect(f, isA<InvalidOtpFormatFailure>()),
        (_) => fail('expected Left'),
      );
      expect(repo.capturedCode, isNull);
    });

    test('lowercases the code before concatenation', () async {
      final repo = _FakeAuthRepository();
      final useCase = VerifyOtpUseCase(repo);
      await useCase.call(
        params: const VerifyOtpParams(code: '83Z55R', nonce: 'abc'),
      );
      expect(repo.capturedCode, '83z55r');
      expect(repo.capturedNonce, 'abc');
    });
  });

  group('StackErrorMapper', () {
    test('maps VERIFICATION_CODE_ALREADY_USED', () {
      final f = StackErrorMapper.map(_dioErr(400, {
        'code': 'VERIFICATION_CODE_ALREADY_USED',
        'error': 'The verification link has already been used.',
      }));
      expect(f, isA<OtpAlreadyUsedFailure>());
      expect((f as AuthFailure).code, 'auth_error_otp_used');
    });

    test('maps VERIFICATION_CODE_NOT_FOUND', () {
      final f = StackErrorMapper.map(_dioErr(400, {
        'code': 'VERIFICATION_CODE_NOT_FOUND',
        'error': '…',
      }));
      expect(f, isA<OtpNotFoundFailure>());
    });

    test('maps SCHEMA_ERROR to InvalidOtpFormatFailure', () {
      final f = StackErrorMapper.map(_dioErr(400, {
        'code': 'SCHEMA_ERROR',
        'details': {
          'message': 'body.code must be exactly 45 characters',
        },
        'error': '…',
      }));
      expect(f, isA<InvalidOtpFormatFailure>());
    });

    test('maps REFRESH_TOKEN_NOT_FOUND_OR_EXPIRED to SessionExpiredFailure',
        () {
      final f = StackErrorMapper.map(_dioErr(401, {
        'code': 'REFRESH_TOKEN_NOT_FOUND_OR_EXPIRED',
        'error': '…',
      }));
      expect(f, isA<SessionExpiredFailure>());
    });

    test('maps 429 without code to RateLimitFailure', () {
      final f = StackErrorMapper.map(_dioErr(429, <String, dynamic>{}));
      expect(f, isA<RateLimitFailure>());
    });

    test('maps 5xx without code to ServerFailure', () {
      final f = StackErrorMapper.map(_dioErr(503, <String, dynamic>{}));
      expect(f, isA<ServerFailure>());
    });
  });
}
