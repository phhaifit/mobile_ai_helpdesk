import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_failure.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_session.dart';
import 'package:ai_helpdesk/domain/repository/auth/auth_repository.dart';
import 'package:dartz/dartz.dart';

class VerifyOtpParams {
  final String code;
  final String nonce;

  const VerifyOtpParams({required this.code, required this.nonce});
}

class VerifyOtpUseCase
    extends UseCase<Either<Failure, AuthSession>, VerifyOtpParams> {
  final AuthRepository _repository;

  VerifyOtpUseCase(this._repository);

  @override
  Future<Either<Failure, AuthSession>> call({
    required VerifyOtpParams params,
  }) {
    final code = params.code.trim();
    final nonce = params.nonce.trim();
    if (code.length != 6 || nonce.isEmpty) {
      return Future.value(const Left(InvalidOtpFormatFailure()));
    }
    // Stack Auth expects `code.toLowerCase() + nonce` (45 chars total).
    return _repository.signInWithOtp(code: code.toLowerCase(), nonce: nonce);
  }
}
