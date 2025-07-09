import 'package:uuid/uuid.dart';

class WorkerEvaluation {
  final String id;
  final String workerId;
  final DateTime date;
  final String evaluator;
  final String comment;
  final int score;

  WorkerEvaluation({
    required this.id,
    required this.workerId,
    required this.date,
    required this.evaluator,
    required this.comment,
    required this.score,
  });

  factory WorkerEvaluation.create({
    required String workerId,
    required String evaluator,
    required String comment,
    required int score,
  }) {
    return WorkerEvaluation(
      id: const Uuid().v4(),
      workerId: workerId,
      date: DateTime.now(),
      evaluator: evaluator,
      comment: comment,
      score: score,
    );
  }

  /// ✅ Serialización a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workerId': workerId,
      'date': date.toIso8601String(),
      'evaluator': evaluator,
      'comment': comment,
      'score': score,
    };
  }

  /// ✅ Deserialización desde JSON
  factory WorkerEvaluation.fromJson(Map<String, dynamic> json) {
    return WorkerEvaluation(
      id: json['id'] ?? '',
      workerId: json['workerId'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      evaluator: json['evaluator'] ?? '',
      comment: json['comment'] ?? '',
      score: json['score'] ?? 0,
    );
  }

  /// ✅ Clonado con modificaciones
  WorkerEvaluation copyWith({
    String? id,
    String? workerId,
    DateTime? date,
    String? evaluator,
    String? comment,
    int? score,
  }) {
    return WorkerEvaluation(
      id: id ?? this.id,
      workerId: workerId ?? this.workerId,
      date: date ?? this.date,
      evaluator: evaluator ?? this.evaluator,
      comment: comment ?? this.comment,
      score: score ?? this.score,
    );
  }

  /// ✅ Comparación por ID (útil para listas y sets)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkerEvaluation &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
