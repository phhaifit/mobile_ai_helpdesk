/// Base failure class for error handling
abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Validation-related failures
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// General/unknown failures
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
