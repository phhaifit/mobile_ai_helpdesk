/// Auth-specific failures
abstract class AuthFailure {
  final String message;

  const AuthFailure(this.message);

  @override
  String toString() => message;
}

class InvalidEmailFailure extends AuthFailure {
  const InvalidEmailFailure([String message = 'Email address is not valid'])
    : super(message);
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure([
    String message =
        'Password must be at least 8 characters with uppercase, lowercase, number and special character (@#\$%^&*)',
  ]) : super(message);
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure([
    String message = 'Email or password is incorrect',
  ]) : super(message);
}

class EmailAlreadyExistsFailure extends AuthFailure {
  const EmailAlreadyExistsFailure([
    String message = 'Email is already registered',
  ]) : super(message);
}

class UsernameTakenFailure extends AuthFailure {
  const UsernameTakenFailure([String message = 'Username is already taken'])
    : super(message);
}

class PasswordsDoNotMatchFailure extends AuthFailure {
  const PasswordsDoNotMatchFailure([String message = 'Passwords do not match'])
    : super(message);
}

class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure([
    String message = 'Your session has expired. Please login again',
  ]) : super(message);
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure([String message = 'User not found'])
    : super(message);
}

class InvalidTokenFailure extends AuthFailure {
  const InvalidTokenFailure([String message = 'Invalid or expired token'])
    : super(message);
}

class NetworkAuthFailure extends AuthFailure {
  const NetworkAuthFailure([
    String message = 'Network error. Please check your internet connection',
  ]) : super(message);
}
