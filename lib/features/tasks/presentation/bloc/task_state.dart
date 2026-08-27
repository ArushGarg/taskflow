part of 'task_bloc.dart';

enum TaskLoadStatus { initial, loading, success, failure }

class TaskState extends Equatable {
  final TaskLoadStatus status;
  final List<TaskEntity> allTasks;
  final TaskFilter filter;
  final String? errorMessage;
  final String? actionError;

  const TaskState({
    this.status = TaskLoadStatus.initial,
    this.allTasks = const [],
    this.filter = const TaskFilter(),
    this.errorMessage,
    this.actionError,
  });

  /// Applies the active filter, keeping the due-date ordering that already
  /// comes from the Firestore query.
  List<TaskEntity> get visibleTasks =>
      allTasks.where(filter.matches).toList(growable: false);

  int get completedCount => allTasks.where((t) => t.isCompleted).length;

  TaskState copyWith({
    TaskLoadStatus? status,
    List<TaskEntity>? allTasks,
    TaskFilter? filter,
    String? errorMessage,
    bool clearError = false,
    String? actionError,
    bool clearActionError = false,
  }) {
    return TaskState(
      status: status ?? this.status,
      allTasks: allTasks ?? this.allTasks,
      filter: filter ?? this.filter,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      actionError:
      clearActionError ? null : (actionError ?? this.actionError),
    );
  }

  @override
  List<Object?> get props =>
      [status, allTasks, filter, errorMessage, actionError];
}