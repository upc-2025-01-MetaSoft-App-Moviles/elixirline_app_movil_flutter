import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/worker_attendance.dart';

class WorkerAttendanceRepository {
  static const _key = 'worker_attendance_records';

  /// Obtiene todos los registros almacenados
  Future<List<WorkerAttendance>> getAllAttendances() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List decoded = jsonDecode(jsonString);
    return decoded.map((record) => WorkerAttendance.fromJson(record)).toList();
  }

  /// Guarda toda la lista de asistencias
  Future<void> _saveAll(List<WorkerAttendance> attendances) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(attendances.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  /// Añade un nuevo registro de asistencia
  Future<void> addAttendance(WorkerAttendance attendance) async {
    final all = await getAllAttendances();
    all.add(attendance);
    await _saveAll(all);
  }

  /// Actualiza un registro existente por ID (usando copyWith)
  Future<void> updateAttendance(WorkerAttendance updated) async {
    final all = await getAllAttendances();
    final index = all.indexWhere((a) => a.id == updated.id);
    if (index != -1) {
      all[index] = updated;
      await _saveAll(all);
    }
  }

  /// Elimina un registro por ID
  Future<void> deleteAttendance(String id) async {
    final all = await getAllAttendances();
    all.removeWhere((a) => a.id == id);
    await _saveAll(all);
  }

  /// Limpia todos los registros
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
