
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
      batchId: json['batchId']?.toString() ?? '',
      stageType: json['stageType']?.toString() ?? '',
      startedAt: json['startedAt']?.toString() ?? '',
      completedAt: json['completedAt']?.toString() ?? '',
      completedBy: json['completedBy']?.toString() ?? '',
      observations: json['observations']?.toString() ?? '',
      isCompleted: json['isCompleted'] == true || json['isCompleted'] == 'true',
      bottlingLine: json['bottlingLine']?.toString() ?? '',
      bottlesFilled: _parseInt(json['bottlesFilled']),
      bottleVolumeMl: _parseInt(json['bottleVolumeMl']),
      totalVolumeLiters: _parseDouble(json['totalVolumeLiters']),
      sealType: json['sealType']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      temperature: _parseDouble(json['temperature']),
      wasFiltered: json['wasFiltered'] == true || json['wasFiltered'] == 'true',
      wereLabelsApplied: json['wereLabelsApplied'] == true || json['wereLabelsApplied'] == 'true',
      wereCapsulesApplied: json['wereCapsulesApplied'] == true || json['wereCapsulesApplied'] == 'true',
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