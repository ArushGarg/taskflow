import '../../../../core/utils/result.dart';
import '../entities/task_entity.dart';

abstract class TaskRepository {
  /// Live stream of the current user's tasks, already sorted by due date
  /// (earliest first) at the data-source level.
  Stream<List<TaskEntity>> watchTasks(String userId);

  Future<Result<void>> addTask(TaskEntity task);

  Future<Result<void>> updateTask(TaskEntity task);

  Future<Result<void>> deleteTask({required String userId, required String taskId});

  Future<Result<void>> toggleComplete({
    required String userId,
    required String taskId,
    required bool isCompleted,
  });
}