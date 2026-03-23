import 'package:dartz/dartz.dart';

import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/data/models/auth/login_request.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_response.dart';
import 'package:ai_helpdesk/domain/repository/auth/auth_repository.dart';

class LoginUseCase extends UseCase<Either<Failure, AuthResponse>, LoginRequest> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, AuthResponse>> call({required LoginRequest params}) async {
    return _repository.login(params);
  }
}
