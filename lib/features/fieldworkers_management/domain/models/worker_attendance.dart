import 'package:uuid/uuid.dart';

class WorkerAttendance {
  final String id;
  final String workerId;
  final DateTime date;
  final DateTime checkIn;
  final DateTime? checkOut;
  final bool inField;
  final String? remarks; // NUEVO campo agregado

  WorkerAttendance({
    required this.id,
    required this.workerId,
    required this.date,
    required this.checkIn,
    this.checkOut,
    this.inField = true,
    this.remarks, // incluido en constructor
  });

  factory WorkerAttendance.create({
    required String workerId,
    required DateTime checkIn,
    bool inField = true,
    String? remarks,
  }) {
    return WorkerAttendance(
      id: const Uuid().v4(),
      workerId: workerId,
      date: DateTime(checkIn.year, checkIn.month, checkIn.day),
      checkIn: checkIn,
      inField: inField,
      remarks: remarks,
    );
  }

  WorkerAttendance copyWith({
    DateTime? checkOut,
    bool? inField,
    String? remarks,
  }) {
    return WorkerAttendance(
      id: id,
      workerId: workerId,
      date: date,
      checkIn: checkIn,
      checkOut: checkOut ?? this.checkOut,
      inField: inField ?? this.inField,
      remarks: remarks, // ✅ acepta null explícitamente
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workerId': workerId,
      'date': date.toIso8601String(),
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut?.toIso8601String(),
      'inField': inField,
      'remarks': remarks,
    };
  }

  factory WorkerAttendance.fromJson(Map<String, dynamic> json) {
    return WorkerAttendance(
      id: json['id'],
      workerId: json['workerId'],
      date: DateTime.parse(json['date']),
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: json['checkOut'] != null
          ? DateTime.parse(json['checkOut'])
          : null,
      inField: json['inField'] ?? true,
      remarks: json['remarks'],
    );
  }
}
