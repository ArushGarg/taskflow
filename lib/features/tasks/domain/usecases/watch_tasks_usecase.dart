import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

/// Not a standard UseCase<> since it exposes a Stream rather than a
/// one-shot Future, but kept in the usecases layer for consistency with
/// the rest of the domain boundary.
class WatchTasksUseCase {
  final TaskRepository repository;
  const WatchTasksUseCase(this.repository);

  Stream<List<TaskEntity>> call(String userId) => repository.watchTasks(userId);
}