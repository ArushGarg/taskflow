import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<TaskEntity>> watchTasks(String userId) {
    // Errors on the stream (e.g. permission-denied) surface to the bloc's
    // error handler via the stream's onError, so we let them propagate
    // rather than swallowing them here.
    return remoteDataSource.watchTasks(userId);
  }

  @override
  Future<Result<void>> addTask(TaskEntity task) async {
    try {
      await remoteDataSource.addTask(TaskModel.fromEntity(task));
      return const Result.success(null);
    } on FirebaseException catch (e) {
      return Result.failure(ServerFailure(e.message ?? 'Failed to add task.'));
    } catch (_) {
      return const Result.failure(UnexpectedFailure('Failed to add task.'));
    }
  }

  @override
  Future<Result<void>> updateTask(TaskEntity task) async {
    try {
      await remoteDataSource.updateTask(TaskModel.fromEntity(task));
      return const Result.success(null);
    } on FirebaseException catch (e) {
      return Result.failure(ServerFailure(e.message ?? 'Failed to update task.'));
    } catch (_) {
      return const Result.failure(UnexpectedFailure('Failed to update task.'));
    }
  }

  @override
  Future<Result<void>> deleteTask({
    required String userId,
    required String taskId,
  }) async {
    try {
      await remoteDataSource.deleteTask(userId: userId, taskId: taskId);
      return const Result.success(null);
    } on FirebaseException catch (e) {
      return Result.failure(ServerFailure(e.message ?? 'Failed to delete task.'));
    } catch (_) {
      return const Result.failure(UnexpectedFailure('Failed to delete task.'));
    }
  }

  @override
  Future<Result<void>> toggleComplete({
    required String userId,
    required String taskId,
    required bool isCompleted,
  }) async {
    try {
      await remoteDataSource.toggleComplete(
        userId: userId,
        taskId: taskId,
        isCompleted: isCompleted,
      );
      return const Result.success(null);
    } on FirebaseException catch (e) {
      return Result.failure(ServerFailure(e.message ?? 'Failed to update task.'));
    } catch (_) {
      return const Result.failure(UnexpectedFailure('Failed to update task.'));
    }
  }
}