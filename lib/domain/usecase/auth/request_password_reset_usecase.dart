import 'package:dartz/dartz.dart';

import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/repository/auth/auth_repository.dart';

class RequestPasswordResetUseCase
    extends UseCase<Either<Failure, void>, String> {
  final AuthRepository _repository;

  RequestPasswordResetUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call({required String params}) async {
    if (params.trim().isEmpty || !params.contains('@')) {
      return const Left(ValidationFailure('Please enter a valid email'));
    }

    return _repository.requestPasswordReset(params.trim());
  }
}
