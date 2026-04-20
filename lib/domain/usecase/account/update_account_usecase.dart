import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/repository/account/account_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateAccountUseCase
    extends UseCase<Either<Failure, void>, AccountUpdateParams> {
  final AccountRepository _repository;

  UpdateAccountUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call({required AccountUpdateParams params}) {
    return _repository.update(params);
  }
}
