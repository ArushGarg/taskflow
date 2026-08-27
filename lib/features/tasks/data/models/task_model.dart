import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.description,
    required super.dueDate,
    required super.priority,
    required super.isCompleted,
    required super.createdAt,
  });

  factory TaskModel.fromEntity(TaskEntity entity) => TaskModel(
    id: entity.id,
    userId: entity.userId,
    title: entity.title,
    description: entity.description,
    dueDate: entity.dueDate,
    priority: entity.priority,
    isCompleted: entity.isCompleted,
    createdAt: entity.createdAt,
  );

  factory TaskModel.fromMap(String id, Map<String, dynamic> map) {
    return TaskModel(
      id: id,
      userId: map['userId'] as String,
      title: map['title'] as String,
      description: (map['description'] as String?) ?? '',
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      priority: TaskPriorityX.fromString(map['priority'] as String),
      isCompleted: (map['isCompleted'] as bool?) ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'priority': priority.name,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}