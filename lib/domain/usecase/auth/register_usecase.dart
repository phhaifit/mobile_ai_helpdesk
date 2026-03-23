import 'package:dartz/dartz.dart';

import 'package:mobile_ai_helpdesk/core/domain/error/failure.dart';
import 'package:mobile_ai_helpdesk/core/domain/usecase/use_case.dart';
import 'package:mobile_ai_helpdesk/data/models/auth/register_request.dart';
import 'package:mobile_ai_helpdesk/domain/entity/auth/auth_response.dart';
import 'package:mobile_ai_helpdesk/domain/repository/auth/auth_repository.dart';

class RegisterUseCase
    extends UseCase<Either<Failure, AuthResponse>, RegisterRequest> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, AuthResponse>> call({
    required RegisterRequest params,
  }) async {
    // Validate passwords match
    if (params.password != params.confirmPassword) {
      return const Left(ValidationFailure('Passwords do not match'));
    }

    // Validate new password strength
    if (!_isPasswordStrong(params.password)) {
      return const Left(
        ValidationFailure(
          'Password must be at least 8 characters with uppercase, lowercase, number and special character',
        ),
      );
    }

    return _repository.register(params);
  }

  bool _isPasswordStrong(String password) {
    // Minimum 8 characters
    if (password.length < 8) return false;
    // Has uppercase
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    // Has lowercase
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    // Has number
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    // Has special character
    if (!password.contains(RegExp(r'[@#$%^&*]'))) return false;
    return true;
  }
}
