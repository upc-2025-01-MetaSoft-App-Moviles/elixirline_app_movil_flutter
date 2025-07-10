import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/usecases/get_tasks_usecase.dart';
import '../../domain/entities/task.dart';
import '../../infrastructure/repositories_impl/task_repository_impl.dart';

final taskRepositoryProvider = Provider<TaskRepositoryImpl>((ref) {
  return TaskRepositoryImpl();
});

final getTasksUseCaseProvider = Provider<GetTasksUseCase>((ref) {
  final repository = ref.read(taskRepositoryProvider);
  return GetTasksUseCase(repository);
});

final taskProvider = FutureProvider<List<Task>>((ref) async {
  final getTasksUseCase = ref.read(getTasksUseCaseProvider);
  return await getTasksUseCase.execute();
});

class TaskNotifier extends StateNotifier<List<Task>> {
  final GetTasksUseCase getTasksUseCase;

  TaskNotifier(this.getTasksUseCase) : super([]) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    final tasks = await getTasksUseCase.execute();
    state = tasks;
  }
}
