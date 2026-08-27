import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<UserEntity?> get authStateChanges => remoteDataSource.authStateChanges;

  @override
  UserEntity? get currentUser => remoteDataSource.currentUser;

  @override
  Future<Result<UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signIn(email, password);
      return Result.success(user);
    } on FirebaseAuthException catch (e) {
      return Result.failure(AuthFailure(_mapAuthError(e)));
    } catch (_) {
      return const Result.failure(
        UnexpectedFailure('Something went wrong. Please try again.'),
      );
    }
  }

  @override
  Future<Result<UserEntity>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signUp(email, password);
      return Result.success(user);
    } on FirebaseAuthException catch (e) {
      return Result.failure(AuthFailure(_mapAuthError(e)));
    } catch (_) {
      return const Result.failure(
        UnexpectedFailure('Something went wrong. Please try again.'),
      );
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Result.success(null);
    } catch (_) {
      return const Result.failure(AuthFailure('Failed to sign out.'));
    }
  }

  /// Turns Firebase's error codes into copy a gig worker actually
  /// understands, instead of surfacing raw exception text.
  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}