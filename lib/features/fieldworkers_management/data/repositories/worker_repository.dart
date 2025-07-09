// lib/features/fieldworkers_management/data/repositories/worker_repository.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/domain/models/worker.dart';

class WorkerRepository {
  final String _storageKey = 'workers_data';

  /// ✅ Guarda todos los trabajadores en SharedPreferences
  Future<void> saveWorkers(List<Worker> workers) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      workers.map((w) => w.toMap()).toList(),
    ); // CAMBIO AQUÍ
    await prefs.setString(_storageKey, encoded);
  }

  /// ✅ Carga los trabajadores desde SharedPreferences
  Future<List<Worker>> loadWorkers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((w) => Worker.fromMap(w)).toList(); // CAMBIO AQUÍ
    }
    return [];
  }

  /// ✅ Elimina todos los trabajadores almacenados
  Future<void> deleteAllWorkers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
