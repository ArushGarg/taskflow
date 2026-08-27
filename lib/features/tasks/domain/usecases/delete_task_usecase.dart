import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/task_repository.dart';

class DeleteTaskUseCase implements UseCase<void, DeleteTaskParams> {
  final TaskRepository repository;
  const DeleteTaskUseCase(this.repository);

  @override
  Future<Result<void>> call(DeleteTaskParams params) {
    return repository.deleteTask(userId: params.userId, taskId: params.taskId);
  }
}

class DeleteTaskParams {
  final String userId;
  final String taskId;
  const DeleteTaskParams({required this.userId, required this.taskId});
}