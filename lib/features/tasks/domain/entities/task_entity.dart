import 'package:equatable/equatable.dart';

enum TaskPriority { low, medium, high }

extension TaskPriorityX on TaskPriority {
  String get label => switch (this) {
    TaskPriority.low => 'Low',
    TaskPriority.medium => 'Medium',
    TaskPriority.high => 'High',
  };

  static TaskPriority fromString(String value) {
    return TaskPriority.values.firstWhere(
          (p) => p.name == value,
      orElse: () => TaskPriority.medium,
    );
  }
}

class TaskEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final bool isCompleted;
  final DateTime createdAt;

  const TaskEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
    required this.createdAt,
  });

  TaskEntity copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    bool? isCompleted,
  }) {
    return TaskEntity(
      id: id,
      userId: userId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, userId, title, description, dueDate, priority, isCompleted, createdAt];
}