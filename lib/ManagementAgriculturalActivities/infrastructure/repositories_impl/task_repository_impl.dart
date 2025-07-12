import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../data_sources/task_remote_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _remoteDataSource = TaskRemoteDataSource();

  @override
  Future<List<Task>> getTasks() async {
    return await _remoteDataSource.getTasks();
  }

  @override
  Future<void> createTask(Task task) async {
    await _remoteDataSource.addTask(task);
  }
}