import 'package:flutter/material.dart';
import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/domain/models/worker.dart';
import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/domain/models/worker_evaluation.dart';
import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/data/repositories/worker_evaluation_repository.dart';
import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/data/repositories/worker_repository.dart';

class WorkerViewModel extends ChangeNotifier {
  final List<Worker> _workers = [];
  final Map<String, List<WorkerEvaluation>> _evaluations = {};

  final WorkerEvaluationRepository _repository = WorkerEvaluationRepository();
  final WorkerRepository _workerRepo = WorkerRepository();

  WorkerViewModel() {
    _loadWorkers(); // Cargar desde almacenamiento local al iniciar
  }

  Future<void> _loadWorkers() async {
    final storedWorkers = await _workerRepo.loadWorkers();
    _workers.addAll(storedWorkers);
    for (var worker in _workers) {
      final evals = await _repository.loadEvaluations(worker.id);
      _evaluations[worker.id] = evals;
    }
    notifyListeners();
  }

  // === Evaluaciones ===

  void addEvaluation(WorkerEvaluation evaluation) async {
    _evaluations.putIfAbsent(evaluation.workerId, () => []).add(evaluation);
    await _repository.saveEvaluations(
      evaluation.workerId,
      _evaluations[evaluation.workerId]!,
    );
    notifyListeners();
  }

  void updateEvaluation(String workerId, WorkerEvaluation updatedEval) async {
    final list = _evaluations[workerId];
    if (list != null) {
      final index = list.indexWhere((e) => e.id == updatedEval.id);
      if (index != -1) {
        list[index] = updatedEval;
        await _repository.saveEvaluations(workerId, list);
        notifyListeners();
      }
    }
  }

  List<WorkerEvaluation> getEvaluations(String workerId) {
    return _evaluations[workerId] ?? [];
  }

  void deleteEvaluation(String workerId, WorkerEvaluation evaluation) async {
    final list = _evaluations[workerId];
    if (list != null) {
      list.removeWhere((e) => e.id == evaluation.id);
      await _repository.saveEvaluations(workerId, list);
      notifyListeners();
    }
  }

  // === Trabajadores ===

  List<Worker> get workers => List.unmodifiable(_workers);

  void addWorker(Worker worker) async {
    _workers.add(worker);
    await _workerRepo.saveWorkers(_workers);
    print("Documentos guardados localmente: ${worker.documentPaths}"); // ✅
    final evals = await _repository.loadEvaluations(worker.id);
    _evaluations[worker.id] = evals;
    notifyListeners();
  }

  void updateWorker(String id, Worker updatedWorker) async {
    final index = _workers.indexWhere((w) => w.id == id);
    if (index != -1) {
      _workers[index] = updatedWorker;
      await _workerRepo.saveWorkers(_workers);
      notifyListeners();
    }
  }

  void deleteWorker(String id) async {
    _workers.removeWhere((w) => w.id == id);
    _evaluations.remove(id);
    await _workerRepo.saveWorkers(_workers);
    await _repository.saveEvaluations(id, []);
    notifyListeners();
  }

  Worker? getWorkerById(String id) {
    try {
      return _workers.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }
}
