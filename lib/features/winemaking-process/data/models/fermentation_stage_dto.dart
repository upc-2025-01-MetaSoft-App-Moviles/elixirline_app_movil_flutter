
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
 
}