import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_failure.dart';
import 'package:ai_helpdesk/domain/entity/auth/otp_send_result.dart';
import 'package:ai_helpdesk/domain/repository/auth/auth_repository.dart';
import 'package:dartz/dartz.dart';

class SendOtpUseCase extends UseCase<Either<Failure, OtpSendResult>, String> {
  final AuthRepository _repository;

  SendOtpUseCase(this._repository);

  static final _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  Future<Either<Failure, OtpSendResult>> call({required String params}) {
    final email = params.trim();
    if (!_emailRegex.hasMatch(email)) {
      return Future.value(const Left(InvalidEmailFailure()));
    }
    return _repository.sendOtp(email: email);
  }
}
