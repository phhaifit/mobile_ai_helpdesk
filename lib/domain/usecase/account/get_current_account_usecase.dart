import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/entity/account/account.dart';
import 'package:ai_helpdesk/domain/repository/account/account_repository.dart';
import 'package:dartz/dartz.dart';

class GetCurrentAccountUseCase
    extends UseCase<Either<Failure, Account>, void> {
  final AccountRepository _repository;

  GetCurrentAccountUseCase(this._repository);

  @override
  Future<Either<Failure, Account>> call({required void params}) {
    return _repository.getCurrent();
  }
}
