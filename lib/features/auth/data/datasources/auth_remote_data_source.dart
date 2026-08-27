import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';

/// Thin wrapper around FirebaseAuth. Throws FirebaseAuthException on
/// failure so the repository can map codes to friendly messages.
class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSource({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Stream<UserEntity?> get authStateChanges => _firebaseAuth
      .authStateChanges()
      .map((user) => user == null ? null : _toEntity(user));

  UserEntity? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user == null ? null : _toEntity(user);
  }

  Future<UserEntity> signIn(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return _toEntity(credential.user!);
  }

  Future<UserEntity> signUp(String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return _toEntity(credential.user!);
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  UserEntity _toEntity(User user) => UserEntity(uid: user.uid, email: user.email);
}