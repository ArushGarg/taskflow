import '../error/failures.dart';

/// A tiny Either<Failure, T> replacement so the project doesn't need the
/// full `dartz` dependency just for two constructors.
sealed class Result<T> {
  const Result();

  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = Error<T>;

  R fold<R>(R Function(Failure failure) onFailure, R Function(T data) onSuccess) {
    final self = this;
    if (self is Success<T>) return onSuccess(self.data);
    if (self is Error<T>) return onFailure(self.failure);
    throw StateError('Unreachable');
  }

  bool get isSuccess => this is Success<T>;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);
}