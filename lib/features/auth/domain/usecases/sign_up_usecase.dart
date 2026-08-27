import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase implements UseCase<UserEntity, SignUpParams> {
  final AuthRepository repository;
  const SignUpUseCase(this.repository);

  @override
  Future<Result<UserEntity>> call(SignUpParams params) {
    return repository.signUp(email: params.email, password: params.password);
  }
}

class SignUpParams {
  final String email;
  final String password;
  const SignUpParams({required this.email, required this.password});
}