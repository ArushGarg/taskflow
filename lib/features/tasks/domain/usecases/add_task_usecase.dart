import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class AddTaskUseCase implements UseCase<void, TaskEntity> {
  final TaskRepository repository;
  const AddTaskUseCase(this.repository);

  @override
  Future<Result<void>> call(TaskEntity params) => repository.addTask(params);
}