/*
{
  "batchId": "string",
  "stageType": "string",
  "startedAt": "string",
  "completedAt": "string",
  "completedBy": "string",
  "observations": "string",
  "isCompleted": true,
  "initialSugarLevel": 0,
  "finalSugarLevel": 0,
  "addedSugarKg": 0,
  "finalPh": 0,
  "initialPh": 0,
  "acidType": "string",
  "acidAddedGl": 0,
  "so2AddedMgL": 0,
  "justification": "string"
}
*/
import 'package:elixirline_app_movil_flutter/features/winemaking-process/domain/entities/correction_stage.dart';

class CorrectionStageDTO {
  final String batchId;
  final String stageType;
  final String startedAt;
  final String completedAt;
  final String completedBy;
  final String observations;
  final bool isCompleted;
  final double initialSugarLevel;
  final double finalSugarLevel;
  final double addedSugarKg;
  final double finalPh;
  final double initialPh;
  final String acidType;
  final double acidAddedGl;
  final double so2AddedMgL;
  final String justification;

  CorrectionStageDTO({
    required this.batchId,
    required this.stageType,
    required this.startedAt,
    required this.completedAt,
    required this.completedBy,
    required this.observations,
    required this.isCompleted,
    required this.initialSugarLevel,
    required this.finalSugarLevel,
    required this.addedSugarKg,
    required this.finalPh,
    required this.initialPh,
    required this.acidType,
    required this.acidAddedGl,
    required this.so2AddedMgL,
    required this.justification,
  });

  factory CorrectionStageDTO.fromJson(Map<String, dynamic> json) {
    return CorrectionStageDTO(
      batchId: json['batchId'] ?? '',
      stageType: json['stageType'] ?? '',
      startedAt: json['startedAt'] ?? '',
      completedAt: json['completedAt'] ?? '',
      completedBy: json['completedBy'] ?? '',
      observations: json['observations'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      initialSugarLevel: (json['initialSugarLevel'] as num).toDouble(),
      finalSugarLevel: (json['finalSugarLevel'] as num).toDouble(),
      addedSugarKg: (json['addedSugarKg'] as num).toDouble(),
      finalPh: (json['finalPh'] as num).toDouble(),
      initialPh: (json['initialPh'] as num).toDouble(),
      acidType: json['acidType'] ?? '',
      acidAddedGl: (json['acidAddedGl'] as num).toDouble(),
      so2AddedMgL: (json['so2AddedMgL'] as num).toDouble(),
      justification: json['justification'] ?? '',
    );
  }

  CorrectionStage toDomain() {
    return CorrectionStage(
      batchId: batchId,
      stageType: stageType,
      startedAt: startedAt,
      completedAt: completedAt,
      completedBy: completedBy,
      observations: observations,
      isCompleted: isCompleted,
      initialSugarLevel: initialSugarLevel,
      finalSugarLevel: finalSugarLevel,
      addedSugarKg: addedSugarKg,
      finalPh: finalPh,
      initialPh: initialPh,
      acidType: acidType,
      acidAddedGl: acidAddedGl,
      so2AddedMgL: so2AddedMgL,
      justification: justification,
    );
  }
}
