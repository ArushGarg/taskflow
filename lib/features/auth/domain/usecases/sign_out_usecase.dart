import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class SignOutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;
  const SignOutUseCase(this.repository);

  @override
  Future<Result<void>> call(NoParams params) {
    return repository.signOut();
  }
}