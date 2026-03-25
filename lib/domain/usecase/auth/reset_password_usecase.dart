import 'package:dartz/dartz.dart';

import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:ai_helpdesk/data/models/auth/reset_password_request.dart';
import 'package:ai_helpdesk/domain/repository/auth/auth_repository.dart';

class ResetPasswordUseCase
    extends UseCase<Either<Failure, void>, ResetPasswordRequest> {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call({
    required ResetPasswordRequest params,
  }) async {
    // Validate passwords match
    if (params.newPassword != params.confirmPassword) {
      return const Left(ValidationFailure('Passwords do not match'));
    }

    // Validate new password strength
    if (!_isPasswordStrong(params.newPassword)) {
      return const Left(
        ValidationFailure(
          'Password must be at least 8 characters with uppercase, lowercase, number and special character',
        ),
      );
    }

    return _repository.resetPassword(params);
  }

  bool _isPasswordStrong(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp('[A-Z]'))) return false;
    if (!password.contains(RegExp('[a-z]'))) return false;
    if (!password.contains(RegExp('[0-9]'))) return false;
    if (!password.contains(RegExp(r'[@#$%^&*]'))) return false;
    return true;
  }
}
