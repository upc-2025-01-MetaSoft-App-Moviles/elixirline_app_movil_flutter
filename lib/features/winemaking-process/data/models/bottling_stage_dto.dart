
/*
{
  "batchId": "string",
  "stageType": "string",
  "startedAt": "string",
  "completedAt": "string",
  "completedBy": "string",
  "observations": "string",
  "isCompleted": true,
  "bottlingLine": "string",
  "bottlesFilled": 0,
  "bottleVolumeMl": 0,
  "totalVolumeLiters": 0,
  "sealType": "string",
  "code": "string",
  "temperature": 0,
  "wasFiltered": true,
  "wereLabelsApplied": true,
  "wereCapsulesApplied": true
}
*/
import 'package:elixirline_app_movil_flutter/features/winemaking-process/domain/entities/bottling_stage.dart';

class BottlingStageDto {
  final String batchId;
  final String stageType;
  final String startedAt;
  final String completedAt;
  final String completedBy;
  final String observations;
  final bool isCompleted;
  final String bottlingLine;
  final int bottlesFilled;
  final int bottleVolumeMl;
  final double totalVolumeLiters;
  final String sealType;
  final String code;
  final double temperature;
  final bool wasFiltered;
  final bool wereLabelsApplied;
  final bool wereCapsulesApplied;

  BottlingStageDto({
    required this.batchId,
    required this.stageType,
    required this.startedAt,
    required this.completedAt,
    required this.completedBy,
    required this.observations,
    required this.isCompleted,
    required this.bottlingLine,
    required this.bottlesFilled,
    required this.bottleVolumeMl,
    required this.totalVolumeLiters,
    required this.sealType,
    required this.code,
    required this.temperature,
    required this.wasFiltered,
    required this.wereLabelsApplied,
    required this.wereCapsulesApplied,
  });


  factory BottlingStageDto.fromJson(Map<String, dynamic> json) {
    return BottlingStageDto(
      batchId: json['batchId'] ?? '',
      stageType: json['stageType'] ?? '',
      startedAt: json['startedAt']?.toString() ?? '',
      completedAt: json['completedAt']?.toString() ?? '',
      completedBy: json['completedBy'] ?? '',
      observations: json['observations'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      bottlingLine: json['bottlingLine'] ?? '',
      bottlesFilled: json['bottlesFilled'] ?? 0,
      bottleVolumeMl: json['bottleVolumeMl'] ?? 0,
      totalVolumeLiters: (json['totalVolumeLiters'] ?? 0).toDouble(),
      sealType: json['sealType'] ?? '',
      code: json['code'] ?? '',
      temperature: (json['temperature'] ?? 0).toDouble(),
      wasFiltered: json['wasFiltered'] ?? false,
      wereLabelsApplied: json['wereLabelsApplied'] ?? false,
      wereCapsulesApplied: json['wereCapsulesApplied'] ?? false,
    );
  }

  BottlingStage toDomain() {
    return BottlingStage(
      batchId: batchId,
      stageType: stageType,
      startedAt: startedAt,
      completedAt: completedAt,
      completedBy: completedBy,
      observations: observations,
      isCompleted: isCompleted,
      bottlingLine: bottlingLine,
      bottlesFilled: bottlesFilled,
      bottleVolumeMl: bottleVolumeMl,
      totalVolumeLiters: totalVolumeLiters,
      sealType: sealType,
      code: code,
      temperature: temperature,
      wasFiltered: wasFiltered,
      wereLabelsApplied: wereLabelsApplied,
      wereCapsulesApplied: wereCapsulesApplied,
    );
  }

}