import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class UpdateTaskUseCase implements UseCase<void, TaskEntity> {
  final TaskRepository repository;
  const UpdateTaskUseCase(this.repository);

  @override
  Future<Result<void>> call(TaskEntity params) => repository.updateTask(params);
}