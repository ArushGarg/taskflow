import 'task_entity.dart';

enum StatusFilter { all, completed, incomplete }

/// Combines the priority + status filters the assignment asks for.
/// `priority == null` means "all priorities".
class TaskFilter {
  final TaskPriority? priority;
  final StatusFilter status;

  const TaskFilter({this.priority, this.status = StatusFilter.all});

  TaskFilter copyWith({
    TaskPriority? priority,
    bool clearPriority = false,
    StatusFilter? status,
  }) {
    return TaskFilter(
      priority: clearPriority ? null : (priority ?? this.priority),
      status: status ?? this.status,
    );
  }

  bool matches(TaskEntity task) {
    if (priority != null && task.priority != priority) return false;
    switch (status) {
      case StatusFilter.completed:
        return task.isCompleted;
      case StatusFilter.incomplete:
        return !task.isCompleted;
      case StatusFilter.all:
        return true;
    }
  }
}