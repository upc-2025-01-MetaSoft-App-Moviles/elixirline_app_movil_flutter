
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
      batchId: json['batchId']?.toString() ?? '',
      stageType: json['stageType']?.toString() ?? '',
      startedAt: json['startedAt']?.toString() ?? '',
      completedAt: json['completedAt']?.toString() ?? '',
      completedBy: json['completedBy']?.toString() ?? '',
      isCompleted: json['isCompleted'] == true || json['isCompleted'] == 'true',
      method: json['method']?.toString() ?? '',
      initialTurbidityNtu: _parseDouble(json['initialTurbidityNtu']),
      finalTurbidityNtu: _parseDouble(json['finalTurbidityNtu']),
      wineVolumeLitres: _parseDouble(json['wineVolumeLitres']),
      temperature: _parseDouble(json['temperature']),
      durationHours: _parseInt(json['durationHours']),
      observations: json['observations']?.toString() ?? '',
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
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