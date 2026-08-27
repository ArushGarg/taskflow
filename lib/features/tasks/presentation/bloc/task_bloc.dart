import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_filter.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/toggle_task_status_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import '../../domain/usecases/watch_tasks_usecase.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final WatchTasksUseCase watchTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final ToggleTaskStatusUseCase toggleTaskStatusUseCase;

  StreamSubscription<List<TaskEntity>>? _tasksSubscription;
  String? _userId;

  TaskBloc({
    required this.watchTasksUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
    required this.toggleTaskStatusUseCase,
  }) : super(const TaskState()) {
    on<TasksSubscriptionRequested>(_onSubscriptionRequested);
    on<_TasksUpdated>(_onTasksUpdated);
    on<_TasksFailed>(_onTasksFailed);
    on<TaskAdded>(_onTaskAdded);
    on<TaskUpdated>(_onTaskUpdated);
    on<TaskDeleted>(_onTaskDeleted);
    on<TaskCompletionToggled>(_onTaskCompletionToggled);
    on<TaskPriorityFilterChanged>(_onPriorityFilterChanged);
    on<TaskStatusFilterChanged>(_onStatusFilterChanged);
  }

  Future<void> _onSubscriptionRequested(
      TasksSubscriptionRequested event,
      Emitter<TaskState> emit,
      ) async {
    _userId = event.userId;
    emit(state.copyWith(status: TaskLoadStatus.loading, clearError: true));
    await _tasksSubscription?.cancel();
    _tasksSubscription = watchTasksUseCase(event.userId).listen(
          (tasks) => add(_TasksUpdated(tasks)),
      onError: (error) => add(
        _TasksFailed('Could not load tasks. Check your connection.'),
      ),
    );
  }

  void _onTasksUpdated(_TasksUpdated event, Emitter<TaskState> emit) {
    emit(state.copyWith(
      status: TaskLoadStatus.success,
      allTasks: event.tasks,
      clearError: true,
    ));
  }

  void _onTasksFailed(_TasksFailed event, Emitter<TaskState> emit) {
    emit(state.copyWith(
      status: TaskLoadStatus.failure,
      errorMessage: event.message,
    ));
  }

  Future<void> _onTaskAdded(TaskAdded event, Emitter<TaskState> emit) async {
    final result = await addTaskUseCase(event.task);
    result.fold(
          (failure) => emit(state.copyWith(actionError: failure.message)),
          (_) => emit(state.copyWith(clearActionError: true)),
    );
  }

  Future<void> _onTaskUpdated(TaskUpdated event, Emitter<TaskState> emit) async {
    final result = await updateTaskUseCase(event.task);
    result.fold(
          (failure) => emit(state.copyWith(actionError: failure.message)),
          (_) => emit(state.copyWith(clearActionError: true)),
    );
  }

  Future<void> _onTaskDeleted(TaskDeleted event, Emitter<TaskState> emit) async {
    if (_userId == null) return;
    final result = await deleteTaskUseCase(
      DeleteTaskParams(userId: _userId!, taskId: event.taskId),
    );
    result.fold(
          (failure) => emit(state.copyWith(actionError: failure.message)),
          (_) => emit(state.copyWith(clearActionError: true)),
    );
  }

  Future<void> _onTaskCompletionToggled(
      TaskCompletionToggled event,
      Emitter<TaskState> emit,
      ) async {
    if (_userId == null) return;
    final result = await toggleTaskStatusUseCase(
      ToggleTaskStatusParams(
        userId: _userId!,
        taskId: event.taskId,
        isCompleted: event.isCompleted,
      ),
    );
    result.fold(
          (failure) => emit(state.copyWith(actionError: failure.message)),
          (_) => emit(state.copyWith(clearActionError: true)),
    );
  }

  void _onPriorityFilterChanged(
      TaskPriorityFilterChanged event,
      Emitter<TaskState> emit,
      ) {
    emit(state.copyWith(
      filter: state.filter.copyWith(
        priority: event.priority,
        clearPriority: event.priority == null,
      ),
    ));
  }

  void _onStatusFilterChanged(
      TaskStatusFilterChanged event,
      Emitter<TaskState> emit,
      ) {
    emit(state.copyWith(filter: state.filter.copyWith(status: event.status)));
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}