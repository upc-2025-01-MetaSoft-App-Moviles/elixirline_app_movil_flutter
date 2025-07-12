import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

class CreateTaskUseCase {
  final TaskRepository _taskRepository;

  CreateTaskUseCase(this._taskRepository);

  Future<void> execute(Task task) async {
    await _taskRepository.createTask(task);
  }
}
