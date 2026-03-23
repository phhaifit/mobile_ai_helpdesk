/// Base failure class for error handling
abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

/// Validation-related failures
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

/// General/unknown failures
class UnknownFailure extends Failure {
  const UnknownFailure(String message) : super(message);
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}
