part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

/// Fired once at app start, and internally whenever FirebaseAuth's stream
/// emits — keeps the bloc's state in sync with the real session.
class AuthUserChanged extends AuthEvent {
  final UserEntity? user;
  const AuthUserChanged(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthSignInRequested({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthSignUpRequested({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}