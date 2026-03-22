import 'package:dartz/dartz.dart';

import 'package:mobile_ai_helpdesk/core/domain/error/failure.dart';
import 'package:mobile_ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:mobile_ai_helpdesk/domain/repository/auth/auth_repository.dart';

class LogoutUseCase extends UseCase<Either<Failure, void>, void> {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call({required void params}) async {
    return _repository.logout();
  }
}
