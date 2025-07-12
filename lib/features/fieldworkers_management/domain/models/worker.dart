import 'worker_task.dart'; // Asegúrate de importar el modelo de tareas

class Worker {
  final String id; // DNI como ID único
  final String fullName;
  final String role;
  final bool isActive;
  final DateTime? entryDate;
  final DateTime? contractEndDate;
  final String? imagePath;
  final String? contractType;
  final String? zonaAsignada;
  final String? nivelExperiencia;

  final List<String> documentPaths;
  final List<WorkerTask> tasks; // 🆕 Por defecto vacío
  // clave: tipoDoc, valor: path
  // 🆕 Nuevos documentos subidos

  Worker({
    required this.id,
    required this.fullName,
    required this.role,
    required this.isActive,
    this.entryDate,
    this.contractEndDate,
    this.imagePath,
    this.contractType,
    this.zonaAsignada,
    this.nivelExperiencia,
    this.documentPaths = const [],
    this.tasks = const [],
    // 🆕 Por defecto vacío
  });

  factory Worker.fromMap(Map<String, dynamic> map) {
    return Worker(
      id: map['dni'] ?? '',
      fullName: map['name'] ?? '',
      role: map['role'] ?? '',
      isActive: map['isActive'] ?? false,
      entryDate: map['entryDate'] != null
          ? DateTime.tryParse(map['entryDate'])
          : null,
      contractEndDate: map['contractEndDate'] != null
          ? DateTime.tryParse(map['contractEndDate'])
          : null,
      imagePath: map['imagePath'],
      contractType: map['contractType'],
      zonaAsignada: map['zonaAsignada'],
      nivelExperiencia: map['nivelExperiencia'],
      documentPaths: List<String>.from(map['documentPaths'] ?? []),
      tasks:
          (map['tasks'] as List<dynamic>?)
              ?.map((e) => WorkerTask.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      // 🆕 Carga documentos
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dni': id,
      'name': fullName,
      'role': role,
      'isActive': isActive,
      'entryDate': entryDate?.toIso8601String(),
      'contractEndDate': contractEndDate?.toIso8601String(),
      'imagePath': imagePath,
      'contractType': contractType,
      'zonaAsignada': zonaAsignada,
      'nivelExperiencia': nivelExperiencia,
      'tasks': tasks.map((e) => e.toMap()).toList(),
      'documentPaths': documentPaths, // 🆕 Serialización de documentos
    };
  }

  Map<String, dynamic> toJson() => toMap();

  factory Worker.fromJson(Map<String, dynamic> json) => Worker.fromMap(json);
}
