import 'package:fpdart/fpdart.dart';

typedef Result<T> = Either<Failure, T>;
typedef FutureResult<T> = Future<Either<Failure, T>>;

class Failure {
  final String message;
  final String? code;
  final Exception? exception;

  const Failure({required this.message, this.code, this.exception});

  factory Failure.auth(String message, {String? code, Exception? exception}) {
    return Failure(message: message, code: code ?? 'auth_error', exception: exception);
  }

  factory Failure.network([String? message]) {
    return Failure(
      message: message ?? 'No internet connection. Please check your network.',
      code: 'network_error',
    );
  }

  factory Failure.server([String? message, Exception? exception]) {
    return Failure(
      message: message ?? 'Server error. Please try again later.',
      code: 'server_error',
      exception: exception,
    );
  }

  factory Failure.validation(String message) {
    return Failure(message: message, code: 'validation_error');
  }

  factory Failure.permission([String? message]) {
    return Failure(message: message ?? 'Permission denied.', code: 'permission_error');
  }

  factory Failure.notFound([String? message]) {
    return Failure(message: message ?? 'Resource not found.', code: 'not_found');
  }

  factory Failure.unexpected([String? message, Exception? exception]) {
    return Failure(
      message: message ?? 'An unexpected error occurred.',
      code: 'unexpected_error',
      exception: exception,
    );
  }

  @override
  String toString() => 'Failure(message: $message, code: $code)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Failure) return false;
    return message == other.message && code == other.code;
  }

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

extension ResultX<T> on Result<T> {
  R when<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    return fold(onFailure, onSuccess);
  }
}

extension FutureResultX<T> on FutureResult<T> {
  Future<R> when<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) async {
    Either<Failure, T> result = await this;
    return result.fold(onFailure, onSuccess);
  }
}
