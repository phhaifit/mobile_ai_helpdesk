import 'package:dartz/dartz.dart';

import 'package:mobile_ai_helpdesk/core/domain/error/failure.dart';
import 'package:mobile_ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:mobile_ai_helpdesk/domain/entity/auth/user.dart';
import 'package:mobile_ai_helpdesk/domain/repository/auth/auth_repository.dart';

class GetCurrentUserUseCase extends UseCase<Either<Failure, User>, void> {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  @override
  Future<Either<Failure, User>> call({required void params}) async {
    return _repository.getCurrentUser();
  }
}
