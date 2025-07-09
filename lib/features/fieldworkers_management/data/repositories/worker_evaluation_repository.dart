// lib/features/fieldworkers_management/data/repositories/worker_evaluation_repository.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/worker_evaluation.dart';

class WorkerEvaluationRepository {
  static const String _prefix = 'evaluations_';

  /// ✅ Guarda todas las evaluaciones de un trabajador
  Future<void> saveEvaluations(
    String workerId,
    List<WorkerEvaluation> evaluations,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(evaluations.map((e) => e.toJson()).toList());
    await prefs.setString('$_prefix$workerId', encoded);
  }

  /// ✅ Carga todas las evaluaciones de un trabajador
  Future<List<WorkerEvaluation>> loadEvaluations(String workerId) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('$_prefix$workerId');
    if (data == null) return [];

    final List<dynamic> decoded = jsonDecode(data);
    return decoded.map((e) => WorkerEvaluation.fromJson(e)).toList();
  }

  /// ✅ Elimina una evaluación específica de un trabajador
  Future<void> deleteEvaluation(
    String workerId,
    WorkerEvaluation evaluation,
  ) async {
    final evaluations = await loadEvaluations(workerId);
    evaluations.removeWhere(
      (e) => e.id == evaluation.id,
    ); // Usamos el ID para precisión
    await saveEvaluations(workerId, evaluations);
  }

  /// ✅ Limpia todas las evaluaciones guardadas (de todos los trabajadores)
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs
        .getKeys()
        .where((key) => key.startsWith(_prefix))
        .toList();
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
