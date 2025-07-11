/*
{
  "batchId": "string",
  "stageType": "string",
  "startedAt": "string",
  "completedAt": "string",
  "completedBy": "string",
  "isCompleted": true,
  "sugarLevel": 0,
  "pH": 0,
  "temperature": 0,
  "quantityKg": 0,
  "observations": "string"
}
*/
import 'package:elixirline_app_movil_flutter/features/winemaking-process/domain/entities/reception_stage.dart';

class ReceptionStageDto {
  final String batchId;
  final String stageType;
  final String startedAt;
  final String completedAt;
  final String completedBy;
  final bool isCompleted;
  final double sugarLevel;
  final double pH;
  final double temperature;
  final double quantityKg;
  final String observations;

  ReceptionStageDto({
    required this.batchId,
    required this.stageType,
    required this.startedAt,
    required this.completedAt,
    required this.completedBy,
    required this.isCompleted,
    required this.sugarLevel,
    required this.pH,
    required this.temperature,
    required this.quantityKg,
    required this.observations,
  });

  factory ReceptionStageDto.fromJson(Map<String, dynamic> json) {
    
    return ReceptionStageDto(
      batchId: json['batchId'] ?? '',
      stageType: json['stageType'] ?? '',
      startedAt: json['startedAt']?.toString().trim() ?? '',
      completedAt: json['completedAt']?.toString().trim() ?? '',
      completedBy: json['completedBy'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      sugarLevel: (json['sugarLevel'] ?? 0).toDouble(),
      pH: (json['pH'] ?? 0).toDouble(),
      temperature: (json['temperature'] ?? 0).toDouble(),
      quantityKg: (json['quantityKg'] ?? 0).toDouble(),
      observations: json['observations'] ?? '',
    );
  }

  ReceptionStage toDomain() {
    return ReceptionStage(
      batchId: batchId,
      stageType: stageType,
      startedAt: startedAt,
      completedAt: completedAt,
      completedBy: completedBy,
      isCompleted: isCompleted,
      sugarLevel: sugarLevel,
      pH: pH,
      temperature: temperature,
      quantityKg: quantityKg,
      observations: observations,
    );
  }
}
