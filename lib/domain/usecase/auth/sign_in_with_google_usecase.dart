import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_session.dart';
import 'package:ai_helpdesk/domain/repository/auth/auth_repository.dart';
import 'package:dartz/dartz.dart';

class SignInWithGoogleUseCase
    extends UseCase<Either<Failure, AuthSession>, void> {
  final AuthRepository _repository;

  SignInWithGoogleUseCase(this._repository);

  @override
  Future<Either<Failure, AuthSession>> call({required void params}) {
    return _repository.signInWithGoogle();
  }
}
