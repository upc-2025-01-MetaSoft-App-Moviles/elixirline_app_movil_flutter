
/*
{
  "batchId": "string",
  "stageType": "string",
  "startedAt": "string",
  "completedAt": "string",
  "completedBy": "string",
  "isCompleted": true,
  "yeastUsed": "string",
  "initialSugarLevel": 0,
  "finalSugarLevel": 0,
  "initialPh": 0,
  "finalPh": 0,
  "temperatureMax": 0,
  "temperatureMin": 0,
  "fermentationType": "string",
  "tankCode": "string",
  "observations": "string"
}
*/

import 'package:elixirline_app_movil_flutter/features/winemaking-process/domain/entities/fermentation_stage.dart';

class FermentationStageDTO {
  final String batchId;
  final String stageType;
  final String startedAt;
  final String completedAt;
  final String completedBy;
  final bool isCompleted;
  final String yeastUsed;
  final double initialSugarLevel;
  final double finalSugarLevel;
  final double initialPh;
  final double finalPh;
  final double temperatureMax;
  final double temperatureMin;
  final String fermentationType;
  final String tankCode;
  final String observations;

  FermentationStageDTO({
    required this.batchId,
    required this.stageType,
    required this.startedAt,
    required this.completedAt,
    required this.completedBy,
    required this.isCompleted,
    required this.yeastUsed,
    required this.initialSugarLevel,
    required this.finalSugarLevel,
    required this.initialPh,
    required this.finalPh,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.fermentationType,
    required this.tankCode,
    required this.observations,
  });


  factory FermentationStageDTO.fromJson(Map<String, dynamic> json) {
    return FermentationStageDTO(
      batchId: json['batchId'] ?? '',
      stageType: json['stageType'] ?? '',
      startedAt: json['startedAt'] ?? '',
      completedAt: json['completedAt'] ?? '',
      completedBy: json['completedBy'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      yeastUsed: json['yeastUsed'] ?? '',
      initialSugarLevel: (json['initialSugarLevel'] ?? 0).toDouble(),
      finalSugarLevel: (json['finalSugarLevel'] ?? 0).toDouble(),
      initialPh: (json['initialPh'] ?? 0).toDouble(),
      finalPh: (json['finalPh'] ?? 0).toDouble(),
      temperatureMax: (json['temperatureMax'] ?? 0).toDouble(),
      temperatureMin: (json['temperatureMin'] ?? 0).toDouble(),
      fermentationType: json['fermentationType'] ?? '',
      tankCode: json['tankCode'] ?? '',
      observations: json['observations'] ?? '',
    );
  }

  FermentationStage toDomain() {
    return FermentationStage(
      batchId: batchId,
      stageType: stageType,
      startedAt: startedAt,
      completedAt: completedAt,
      completedBy: completedBy,
      isCompleted: isCompleted,
      yeastUsed: yeastUsed,
      initialSugarLevel: initialSugarLevel,
      finalSugarLevel: finalSugarLevel,
      initialPh: initialPh,
      finalPh: finalPh,
      temperatureMax: temperatureMax,
      temperatureMin: temperatureMin,
      fermentationType: fermentationType,
      tankCode: tankCode,
      observations: observations,
    );
  }

}