import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/repository/account/account_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteAvatarUseCase extends UseCase<Either<Failure, void>, void> {
  final AccountRepository _repository;

  DeleteAvatarUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call({required void params}) {
    return _repository.deleteAvatar();
  }
}
