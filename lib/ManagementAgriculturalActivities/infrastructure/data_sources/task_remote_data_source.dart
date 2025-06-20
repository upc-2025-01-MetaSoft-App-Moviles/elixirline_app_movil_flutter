import '../../domain/entities/task.dart';

class TaskRemoteDataSource {
  final List<Task> _fakeTasks = [];

  Future<List<Task>> getTasks() async {
    await Future.delayed(Duration(milliseconds: 500));
    return _fakeTasks;
  }

  Future<void> addTask(Task task) async {
    await Future.delayed(Duration(milliseconds: 500));
    _fakeTasks.add(task);
  }
}
