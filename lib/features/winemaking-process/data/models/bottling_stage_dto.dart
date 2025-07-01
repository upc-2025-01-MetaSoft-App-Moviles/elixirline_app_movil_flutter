
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
  
}