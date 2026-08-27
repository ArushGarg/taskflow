import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;

  UserEntity? get currentUser;

  Future<Result<UserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Result<UserEntity>> signUp({
    required String email,
    required String password,
  });

  Future<Result<void>> signOut();
}