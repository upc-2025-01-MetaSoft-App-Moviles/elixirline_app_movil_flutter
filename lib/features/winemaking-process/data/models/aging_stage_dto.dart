

/*
{
  "batchId": "string",
  "stageType": "string",
  "startedAt": "string",
  "completedAt": "string",
  "completedBy": "string",
  "observations": "string",
  "isCompleted": true,
  "containerType": "string",
  "material": "string",
  "containerCode": "string",
  "avgTemperature": 0,
  "volumeLiters": 0,
  "durationMonths": 0,
  "frequencyDays": 0,
  "refilled": 0,
  "batonnage": 0,
  "rackings": 0,
  "purpose": "string"
}
*/

import 'package:elixirline_app_movil_flutter/features/winemaking-process/domain/entities/aging_stage.dart';

class AgingStageDto {
  final String batchId;
  final String stageType;
  final String startedAt;
  final String completedAt;
  final String completedBy;
  final String observations;
  final bool isCompleted;
  final String containerType;
  final String material;
  final String containerCode;
  final double avgTemperature;
  final double volumeLiters;
  final int durationMonths;
  final int frequencyDays;
  final int refilled;
  final int batonnage;
  final int rackings;
  final String purpose;

  AgingStageDto({
    required this.batchId,
    required this.stageType,
    required this.startedAt,
    required this.completedAt,
    required this.completedBy,
    required this.observations,
    required this.isCompleted,
    required this.containerType,
    required this.material,
    required this.containerCode,
    required this.avgTemperature,
    required this.volumeLiters,
    required this.durationMonths,
    required this.frequencyDays,
    required this.refilled,
    required this.batonnage,
    required this.rackings,
    required this.purpose,
  });

  factory AgingStageDto.fromJson(Map<String, dynamic> json) {
    return AgingStageDto(
      batchId: json['batchId']?.toString() ?? '',
      stageType: json['stageType']?.toString() ?? '',
      startedAt: json['startedAt']?.toString() ?? '',
      completedAt: json['completedAt']?.toString() ?? '',
      completedBy: json['completedBy']?.toString() ?? '',
      observations: json['observations']?.toString() ?? '',
      isCompleted: json['isCompleted'] == true || json['isCompleted'] == 'true',
      containerType: json['containerType']?.toString() ?? '',
      material: json['material']?.toString() ?? '',
      containerCode: json['containerCode']?.toString() ?? '',
      avgTemperature: _parseDouble(json['avgTemperature']),
      volumeLiters: _parseDouble(json['volumeLiters']),
      durationMonths: _parseInt(json['durationMonths']),
      frequencyDays: _parseInt(json['frequencyDays']),
      refilled: _parseInt(json['refilled']),
      batonnage: _parseInt(json['batonnage']),
      rackings: _parseInt(json['rackings']),
      purpose: json['purpose']?.toString() ?? '',
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

  AgingStage toDomain() {
    return AgingStage(
      batchId: batchId,
      stageType: stageType,
      startedAt: startedAt,
      completedAt: completedAt,
      completedBy: completedBy,
      observations: observations,
      isCompleted: isCompleted,
      containerType: containerType,
      material: material,
      containerCode: containerCode,
      avgTemperature: avgTemperature,
      volumeLiters: volumeLiters,
      durationMonths: durationMonths,
      frequencyDays: frequencyDays,
      refilled: refilled,
      batonnage: batonnage,
      rackings: rackings,
      purpose: purpose,
    );
  }


  
}