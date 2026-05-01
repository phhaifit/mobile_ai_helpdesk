import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/auth/auth_session.dart';
import 'package:ai_helpdesk/domain/repository/auth/auth_repository.dart';
import 'package:dartz/dartz.dart';

class SignInWithGoogleParams {
  final bool forceAccountChooser;

  const SignInWithGoogleParams({this.forceAccountChooser = false});
}

class SignInWithGoogleUseCase
    extends UseCase<Either<Failure, AuthSession>, SignInWithGoogleParams> {
  final AuthRepository _repository;

  SignInWithGoogleUseCase(this._repository);

  @override
  Future<Either<Failure, AuthSession>> call({
    SignInWithGoogleParams params = const SignInWithGoogleParams(),
  }) {
    return _repository.signInWithGoogle(
      forceAccountChooser: params.forceAccountChooser,
    );
  }
}
