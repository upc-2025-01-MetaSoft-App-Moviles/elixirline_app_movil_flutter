
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
class CorrectionStage {
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

  CorrectionStage({
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
  
}