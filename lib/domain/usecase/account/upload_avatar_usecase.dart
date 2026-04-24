import 'dart:io';

import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/domain/repository/account/account_repository.dart';
import 'package:dartz/dartz.dart';

class UploadAvatarUseCase extends UseCase<Either<Failure, void>, File> {
  final AccountRepository _repository;

  UploadAvatarUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call({required File params}) {
    return _repository.uploadAvatar(params);
  }
}
