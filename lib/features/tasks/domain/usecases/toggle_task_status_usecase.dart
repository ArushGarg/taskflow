import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/task_repository.dart';

class ToggleTaskStatusUseCase implements UseCase<void, ToggleTaskStatusParams> {
  final TaskRepository repository;
  const ToggleTaskStatusUseCase(this.repository);

  @override
  Future<Result<void>> call(ToggleTaskStatusParams params) {
    return repository.toggleComplete(
      userId: params.userId,
      taskId: params.taskId,
      isCompleted: params.isCompleted,
    );
  }
}

class ToggleTaskStatusParams {
  final String userId;
  final String taskId;
  final bool isCompleted;
  const ToggleTaskStatusParams({
    required this.userId,
    required this.taskId,
    required this.isCompleted,
  });
}