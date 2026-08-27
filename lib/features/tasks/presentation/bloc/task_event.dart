part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object?> get props => [];
}

/// Started by the page for the given user; keeps a live subscription to
/// Firestore so the list updates in real time.
class TasksSubscriptionRequested extends TaskEvent {
  final String userId;
  const TasksSubscriptionRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}

class _TasksUpdated extends TaskEvent {
  final List<TaskEntity> tasks;
  const _TasksUpdated(this.tasks);
  @override
  List<Object?> get props => [tasks];
}

class _TasksFailed extends TaskEvent {
  final String message;
  const _TasksFailed(this.message);
  @override
  List<Object?> get props => [message];
}

class TaskAdded extends TaskEvent {
  final TaskEntity task;
  const TaskAdded(this.task);
  @override
  List<Object?> get props => [task];
}

class TaskUpdated extends TaskEvent {
  final TaskEntity task;
  const TaskUpdated(this.task);
  @override
  List<Object?> get props => [task];
}

class TaskDeleted extends TaskEvent {
  final String taskId;
  const TaskDeleted(this.taskId);
  @override
  List<Object?> get props => [taskId];
}

class TaskCompletionToggled extends TaskEvent {
  final String taskId;
  final bool isCompleted;
  const TaskCompletionToggled({required this.taskId, required this.isCompleted});
  @override
  List<Object?> get props => [taskId, isCompleted];
}

class TaskPriorityFilterChanged extends TaskEvent {
  final TaskPriority? priority;
  const TaskPriorityFilterChanged(this.priority);
  @override
  List<Object?> get props => [priority];
}

class TaskStatusFilterChanged extends TaskEvent {
  final StatusFilter status;
  const TaskStatusFilterChanged(this.status);
  @override
  List<Object?> get props => [status];
}