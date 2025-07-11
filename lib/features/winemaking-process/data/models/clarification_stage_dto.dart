
/*
{
  "batchId": "string",
  "stageType": "string",
  "startedAt": "string",
  "completedAt": "string",
  "completedBy": "string",
  "isCompleted": true,
  "method": "string",
  "initialTurbidityNtu": 0,
  "finalTurbidityNtu": 0,
  "wineVolumeLitres": 0,
  "temperature": 0,
  "durationHours": 0,
  "observations": "string"
}
*/
import 'package:elixirline_app_movil_flutter/features/winemaking-process/domain/entities/clarification_stage.dart';

class ClarificationStageDto {
  final String batchId;
  final String stageType;
  final String startedAt;
  final String completedAt;
  final String completedBy;
  final bool isCompleted;
  final String method;
  final double initialTurbidityNtu;
  final double finalTurbidityNtu;
  final double wineVolumeLitres;
  final double temperature;
  final int durationHours;
  final String observations;

  ClarificationStageDto({
    required this.batchId,
    required this.stageType,
    required this.startedAt,
    required this.completedAt,
    required this.completedBy,
    required this.isCompleted,
    required this.method,
    required this.initialTurbidityNtu,
    required this.finalTurbidityNtu,
    required this.wineVolumeLitres,
    required this.temperature,
    required this.durationHours,
    required this.observations,
  });


  factory ClarificationStageDto.fromJson(Map<String, dynamic> json) {
    return ClarificationStageDto(
      batchId: json['batchId'] ?? '',
      stageType: json['stageType'] ?? '',
      startedAt: json['startedAt']?.toString() ?? '',
      completedAt: json['completedAt']?.toString() ?? '',
      completedBy: json['completedBy'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      method: json['method'] ?? '',
      initialTurbidityNtu: (json['initialTurbidityNtu'] ?? 0).toDouble(),
      finalTurbidityNtu: (json['finalTurbidityNtu'] ?? 0).toDouble(),
      wineVolumeLitres: (json['wineVolumeLitres'] ?? 0).toDouble(),
      temperature: (json['temperature'] ?? 0).toDouble(),
      durationHours: (json['durationHours'] ?? 0).toInt(),
      observations: json['observations'] ?? '',
    );
  }

  ClarificationStage toDomain() {
    return ClarificationStage(
      batchId: batchId,
      stageType: stageType,
      startedAt: startedAt,
      completedAt: completedAt,
      completedBy: completedBy,
      isCompleted: isCompleted,
      method: method,
      initialTurbidityNtu: initialTurbidityNtu,
      finalTurbidityNtu: finalTurbidityNtu,
      wineVolumeLitres: wineVolumeLitres,
      temperature: temperature,
      durationHours: durationHours,
      observations: observations,
    );
  }
  
}