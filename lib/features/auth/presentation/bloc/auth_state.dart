part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final bool isSubmitting;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.isSubmitting = false,
    this.errorMessage,
  });

  const AuthState.unknown() : this(status: AuthStatus.unknown);

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, user, isSubmitting, errorMessage];
}