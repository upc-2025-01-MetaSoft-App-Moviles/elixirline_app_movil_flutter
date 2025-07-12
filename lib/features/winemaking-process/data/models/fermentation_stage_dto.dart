
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

class FermentationStageDto {
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

  FermentationStageDto({
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


  factory FermentationStageDto.fromJson(Map<String, dynamic> json) {
    return FermentationStageDto(
      batchId: json['batchId']?.toString() ?? '',
      stageType: json['stageType']?.toString() ?? '',
      startedAt: json['startedAt']?.toString() ?? '',
      completedAt: json['completedAt']?.toString() ?? '',
      completedBy: json['completedBy']?.toString() ?? '',
      isCompleted: json['isCompleted'] == true || json['isCompleted'] == 'true',
      yeastUsed: json['yeastUsed']?.toString() ?? '',
      initialSugarLevel: _parseDouble(json['initialSugarLevel']),
      finalSugarLevel: _parseDouble(json['finalSugarLevel']),
      initialPh: _parseDouble(json['initialPh']),
      finalPh: _parseDouble(json['finalPh']),
      temperatureMax: _parseDouble(json['temperatureMax']),
      temperatureMin: _parseDouble(json['temperatureMin']),
      fermentationType: json['fermentationType']?.toString() ?? '',
      tankCode: json['tankCode']?.toString() ?? '',
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