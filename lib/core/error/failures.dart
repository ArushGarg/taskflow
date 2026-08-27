import 'package:equatable/equatable.dart';

/// Base failure returned by repositories to the domain/presentation layer.
/// Keeping this decoupled from FirebaseException etc. is what lets the
/// bloc stay agnostic of which backend is actually plugged in.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}