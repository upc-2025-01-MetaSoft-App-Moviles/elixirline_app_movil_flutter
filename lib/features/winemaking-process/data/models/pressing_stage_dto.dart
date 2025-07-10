

/*
{
  "batchId": "string",
  "stageType": "string",
  "startedAt": "string",
  "completedAt": "string",
  "completedBy": "string",
  "isCompleted": true,
  "pressType": "string",
  "pressPressureBars": 0,
  "durationMinutes": 0,
  "pomaceKg": 0,
  "yieldLiters": 0,
  "mustUsage": "string",
  "observations": "string"
}
*/
import 'package:elixirline_app_movil_flutter/features/winemaking-process/domain/entities/pressing_stage.dart';

class PressingStageDto {
  final String batchId;
  final String stageType;
  final String startedAt;
  final String completedAt;
  final String completedBy;
  final bool isCompleted;
  final String pressType;
  final double pressPressureBars;
  final int durationMinutes;
  final double pomaceKg;
  final double yieldLiters;
  final String mustUsage;
  final String observations;

  PressingStageDto({
    required this.batchId,
    required this.stageType,
    required this.startedAt,
    required this.completedAt,
    required this.completedBy,
    required this.isCompleted,
    required this.pressType,
    required this.pressPressureBars,
    required this.durationMinutes,
    required this.pomaceKg,
    required this.yieldLiters,
    required this.mustUsage,
    required this.observations,
  });


  factory PressingStageDto.fromJson(Map<String, dynamic> json) {
    return PressingStageDto(
      batchId: json['batchId'] ?? '',
      stageType: json['stageType'] ?? '',
      startedAt: json['startedAt'] ?? '',
      completedAt: json['completedAt'] ?? '',
      completedBy: json['completedBy'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      pressType: json['pressType'] ?? '',
      pressPressureBars: (json['pressPressureBars'] ?? 0).toDouble(),
      durationMinutes: (json['durationMinutes'] ?? 0).toInt(),
      pomaceKg: (json['pomaceKg'] ?? 0).toDouble(),
      yieldLiters: (json['yieldLiters'] ?? 0).toDouble(),
      mustUsage: json['mustUsage'] ?? '',
      observations: json['observations'] ?? '',
    );
  }

  PressingStage toDomain() {
    return PressingStage(
      batchId: batchId,
      stageType: stageType,
      startedAt: startedAt,
      completedAt: completedAt,
      completedBy: completedBy,
      isCompleted: isCompleted,
      pressType: pressType,
      pressPressureBars: pressPressureBars,
      durationMinutes: durationMinutes,
      pomaceKg: pomaceKg,
      yieldLiters: yieldLiters,
      mustUsage: mustUsage,
      observations: observations,
    );
  }

}
