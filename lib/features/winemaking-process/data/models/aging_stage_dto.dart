

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
      batchId: json['batchId'] ?? '',
      stageType: json['stageType'] ?? '',
      startedAt: json['startedAt'] ?? '',
      completedAt: json['completedAt'] ?? '',
      completedBy: json['completedBy'] ?? '',
      observations: json['observations'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      containerType: json['containerType'] ?? '',
      material: json['material'] ?? '',
      containerCode: json['containerCode'] ?? '',
      avgTemperature: (json['avgTemperature'] ?? 0).toDouble(),
      volumeLiters: (json['volumeLiters'] ?? 0).toDouble(),
      durationMonths: (json['durationMonths'] ?? 0).toInt(),
      frequencyDays: (json['frequencyDays'] ?? 0).toInt(),
      refilled: (json['refilled'] ?? 0).toInt(),
      batonnage: (json['batonnage'] ?? 0).toInt(),
      rackings: (json['rackings'] ?? 0).toInt(),
      purpose: json['purpose'] ?? '',
    );
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