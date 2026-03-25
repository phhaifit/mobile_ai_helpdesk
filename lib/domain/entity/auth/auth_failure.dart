/// Auth-specific failures
abstract class AuthFailure {
  final String message;

  const AuthFailure(this.message);

  @override
  String toString() => message;
}

class InvalidEmailFailure extends AuthFailure {
  const InvalidEmailFailure([super.message = 'Email address is not valid']);
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure([
    super.message =
        'Password must be at least 8 characters with uppercase, lowercase, number and special character (@#\$%^&*)',
  ]);
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure([
    super.message = 'Email or password is incorrect',
  ]);
}

class EmailAlreadyExistsFailure extends AuthFailure {
  const EmailAlreadyExistsFailure([
    super.message = 'Email is already registered',
  ]);
}

class UsernameTakenFailure extends AuthFailure {
  const UsernameTakenFailure([super.message = 'Username is already taken']);
}

class PasswordsDoNotMatchFailure extends AuthFailure {
  const PasswordsDoNotMatchFailure([super.message = 'Passwords do not match']);
}

class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure([
    super.message = 'Your session has expired. Please login again',
  ]);
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure([super.message = 'User not found']);
}

class InvalidTokenFailure extends AuthFailure {
  const InvalidTokenFailure([super.message = 'Invalid or expired token']);
}

class NetworkAuthFailure extends AuthFailure {
  const NetworkAuthFailure([
    super.message = 'Network error. Please check your internet connection',
  ]);
}
