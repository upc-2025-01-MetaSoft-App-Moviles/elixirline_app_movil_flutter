

/*
{
  "batchId": "string",
  "stageType": "string",
  "startedAt": "string",
  "completedAt": "string",
  "completedBy": "string",
  "observations": "string",
  "isCompleted": true,
  "filterType": "string",
  "filtrationType": "string",
  "filterMedia": "string",
  "poreMicrons": 0,
  "turbidityBefore": 0,
  "turbidityAfter": 0,
  "temperature": 0,
  "pressureBars": 0,
  "filteredVolumeLiters": 0,
  "isSterile": true,
  "filterChanged": true,
  "changeReason": "string"
}
*/
import 'package:elixirline_app_movil_flutter/features/winemaking-process/domain/entities/filtration_stage.dart';

class FiltrationStageDto {
  final String batchId;
  final String stageType;
  final String startedAt;
  final String completedAt;
  final String completedBy;
  final String observations;
  final bool isCompleted;
  final String filterType;
  final String filtrationType;
  final String filterMedia;
  final double poreMicrons;
  final double turbidityBefore;
  final double turbidityAfter;
  final double temperature;
  final double pressureBars;
  final double filteredVolumeLiters;
  final bool isSterile;
  final bool filterChanged;
  final String changeReason;

  FiltrationStageDto({
    required this.batchId,
    required this.stageType,
    required this.startedAt,
    required this.completedAt,
    required this.completedBy,
    required this.observations,
    required this.isCompleted,
    required this.filterType,
    required this.filtrationType,
    required this.filterMedia,
    required this.poreMicrons,
    required this.turbidityBefore,
    required this.turbidityAfter,
    required this.temperature,
    required this.pressureBars,
    required this.filteredVolumeLiters,
    required this.isSterile,
    required this.filterChanged,
    required this.changeReason,
  });


  factory FiltrationStageDto.fromJson(Map<String, dynamic> json) {
    return FiltrationStageDto(
      batchId: json['batchId'] ?? '',
      stageType: json['stageType'] ?? '',
      startedAt: json['startedAt']?.toString() ?? '',
      completedAt: json['completedAt']?.toString() ?? '',
      completedBy: json['completedBy'] ?? '',
      observations: json['observations'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      filterType: json['filterType'] ?? '',
      filtrationType: json['filtrationType'] ?? '',
      filterMedia: json['filterMedia'] ?? '',
      poreMicrons: (json['poreMicrons'] ?? 0).toDouble(),
      turbidityBefore: (json['turbidityBefore'] ?? 0).toDouble(),
      turbidityAfter: (json['turbidityAfter'] ?? 0).toDouble(),
      temperature: (json['temperature'] ?? 0).toDouble(),
      pressureBars: (json['pressureBars'] ?? 0).toDouble(),
      filteredVolumeLiters: (json['filteredVolumeLiters'] ?? 0).toDouble(),
      isSterile: json['isSterile'] ?? false,
      filterChanged: json['filterChanged'] ?? false,
      changeReason: json['changeReason'] ?? '',
    );
  }

  FiltrationStage toDomain() {
    return FiltrationStage(
      batchId: batchId,
      stageType: stageType,
      startedAt: startedAt,
      completedAt: completedAt,
      completedBy: completedBy,
      observations: observations,
      isCompleted: isCompleted,
      filterType: filterType,
      filtrationType: filtrationType,
      filterMedia: filterMedia,
      poreMicrons: poreMicrons,
      turbidityBefore: turbidityBefore,
      turbidityAfter: turbidityAfter,
      temperature: temperature,
      pressureBars: pressureBars,
      filteredVolumeLiters: filteredVolumeLiters,
      isSterile: isSterile,
      filterChanged: filterChanged,
      changeReason: changeReason,
    );
  }

}