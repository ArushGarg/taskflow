import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../../../core/usecases/usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;

  StreamSubscription<UserEntity?>? _authSubscription;

  AuthBloc({
    required this.authRepository,
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
  }) : super(const AuthState.unknown()) {
    on<AuthUserChanged>(_onUserChanged);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);

    _authSubscription = authRepository.authStateChanges.listen(
          (user) => add(AuthUserChanged(user)),
    );
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(
      status: event.user != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated,
      user: event.user,
      clearError: true,
    ));
  }

  Future<void> _onSignInRequested(
      AuthSignInRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    final result = await signInUseCase(
      SignInParams(email: event.email, password: event.password),
    );
    result.fold(
          (failure) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: failure.message,
      )),
          (user) => emit(state.copyWith(isSubmitting: false)),
    );
  }

  Future<void> _onSignUpRequested(
      AuthSignUpRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    final result = await signUpUseCase(
      SignUpParams(email: event.email, password: event.password),
    );
    result.fold(
          (failure) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: failure.message,
      )),
          (user) => emit(state.copyWith(isSubmitting: false)),
    );
  }

  Future<void> _onSignOutRequested(
      AuthSignOutRequested event,
      Emitter<AuthState> emit,
      ) async {
    await signOutUseCase(const NoParams());
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}