import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/worker_task.dart';

class WorkerTaskViewModel extends ChangeNotifier {
  final List<WorkerTask> _tasks = [];
  String? _workerId;

  List<WorkerTask> get tasks => List.unmodifiable(_tasks);

  // Inicializa con el ID del trabajador
  Future<void> loadTasksForWorker(String workerId) async {
    _workerId = workerId;
    final prefs = await SharedPreferences.getInstance();
    final rawData = prefs.getString('tasks_$workerId');
    if (rawData != null) {
      final List<dynamic> decoded = jsonDecode(rawData);
      _tasks.clear();
      _tasks.addAll(decoded.map((e) => WorkerTask.fromJson(e)));
      notifyListeners();
    }
  }

  Future<void> _saveTasks() async {
    if (_workerId == null) return;
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(_tasks.map((e) => e.toJson()).toList());
    await prefs.setString('tasks_$_workerId', data);
  }

  void addTask(WorkerTask task) {
    _tasks.add(task);
    _saveTasks();
    notifyListeners();
  }

  void updateTask(
    String id, {
    String? title,
    String? description,
    String? status,
  }) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      final oldTask = _tasks[index];
      _tasks[index] = oldTask.copyWith(
        title: title ?? oldTask.title,
        description: description ?? oldTask.description,
        status: status ?? oldTask.status,
      );
      _saveTasks();
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasks();
    notifyListeners();
  }

  void clearAllTasks() {
    _tasks.clear();
    _saveTasks();
    notifyListeners();
  }
}
