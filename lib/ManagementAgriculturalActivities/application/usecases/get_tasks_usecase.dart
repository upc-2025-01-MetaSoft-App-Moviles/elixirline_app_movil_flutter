import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository _taskRepository;

  GetTasksUseCase(this._taskRepository);

  Future<List<Task>> execute() async {
    return await _taskRepository.getTasks();
  }
}
