

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
  final double durationMinutes;
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
      batchId: json['batchId']?.toString() ?? '',
      stageType: json['stageType']?.toString() ?? '',
      startedAt: json['startedAt']?.toString() ?? '',
      completedAt: json['completedAt']?.toString() ?? '',
      completedBy: json['completedBy']?.toString() ?? '',
      isCompleted: json['isCompleted'] == true || json['isCompleted'] == 'true',
      pressType: json['pressType']?.toString() ?? '',
      pressPressureBars: _parseDouble(json['pressPressureBars']),
      durationMinutes: _parseDouble(json['durationMinutes']),
      pomaceKg: _parseDouble(json['pomaceKg']),
      yieldLiters: _parseDouble(json['yieldLiters']),
      mustUsage: json['mustUsage']?.toString() ?? '',
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
