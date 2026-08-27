import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';

/// Tasks are stored per-user at `users/{uid}/tasks/{taskId}` so Firestore
/// security rules can simply check `request.auth.uid == uid` — no
/// cross-user reads are possible even if a rule is misconfigured for one
/// collection.
class TaskRemoteDataSource {
  final FirebaseFirestore _firestore;

  TaskRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _tasksRef(String userId) =>
      _firestore.collection('users').doc(userId).collection('tasks');

  Stream<List<TaskModel>> watchTasks(String userId) {
    return _tasksRef(userId)
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => TaskModel.fromMap(doc.id, doc.data()))
        .toList());
  }

  Future<void> addTask(TaskModel task) {
    return _tasksRef(task.userId).doc(task.id).set(task.toMap());
  }

  Future<void> updateTask(TaskModel task) {
    return _tasksRef(task.userId).doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask({required String userId, required String taskId}) {
    return _tasksRef(userId).doc(taskId).delete();
  }

  Future<void> toggleComplete({
    required String userId,
    required String taskId,
    required bool isCompleted,
  }) {
    return _tasksRef(userId).doc(taskId).update({'isCompleted': isCompleted});
  }
}