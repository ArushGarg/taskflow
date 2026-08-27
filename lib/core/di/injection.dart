import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/tasks/data/datasources/task_remote_data_source.dart';
import '../../features/tasks/data/repositories/task_repository_impl.dart';
import '../../features/tasks/domain/repositories/task_repository.dart';
import '../../features/tasks/domain/usecases/add_task_usecase.dart';
import '../../features/tasks/domain/usecases/delete_task_usecase.dart';
import '../../features/tasks/domain/usecases/toggle_task_status_usecase.dart';
import '../../features/tasks/domain/usecases/update_task_usecase.dart';
import '../../features/tasks/domain/usecases/watch_tasks_usecase.dart';
import '../../features/tasks/presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

/// Wires the dependency graph bottom-up: data sources -> repositories ->
/// use cases -> blocs. Called once from main() before runApp.
Future<void> setupServiceLocator() async {
  // Auth feature
  sl.registerLazySingleton(() => AuthRemoteDataSource());
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerFactory(
        () => AuthBloc(
      authRepository: sl(),
      signInUseCase: sl(),
      signUpUseCase: sl(),
      signOutUseCase: sl(),
    ),
  );

  // Tasks feature
  sl.registerLazySingleton(() => TaskRemoteDataSource());
  sl.registerLazySingleton<TaskRepository>(
        () => TaskRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => WatchTasksUseCase(sl()));
  sl.registerLazySingleton(() => AddTaskUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));
  sl.registerLazySingleton(() => ToggleTaskStatusUseCase(sl()));
  sl.registerFactory(
        () => TaskBloc(
      watchTasksUseCase: sl(),
      addTaskUseCase: sl(),
      updateTaskUseCase: sl(),
      deleteTaskUseCase: sl(),
      toggleTaskStatusUseCase: sl(),
    ),
  );
}