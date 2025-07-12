import 'package:uuid/uuid.dart';

class WorkerTask {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String status; // Ejemplo: "Pendiente", "En progreso", "Completada"

  WorkerTask({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
  });

  // Constructor de conveniencia para tareas nuevas
  factory WorkerTask.newTask({
    required String title,
    required String description,
    required DateTime date,
    required String status,
  }) {
    return WorkerTask(
      id: const Uuid().v4(), // Genera un ID único automáticamente
      title: title,
      description: description,
      date: date,
      status: status,
    );
  }

  // Para poder editar con una copia
  WorkerTask copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? status,
  }) {
    return WorkerTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }

  // ✅ Método para crear desde un Map
  factory WorkerTask.fromMap(Map<String, dynamic> map) {
    return WorkerTask(
      id: map['id'] ?? const Uuid().v4(),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      status: map['status'] ?? 'Pendiente',
    );
  }

  // ✅ Método para convertir a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'status': status,
    };
  }

  factory WorkerTask.fromJson(Map<String, dynamic> json) {
    return WorkerTask(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'status': status,
    };
  }
}
