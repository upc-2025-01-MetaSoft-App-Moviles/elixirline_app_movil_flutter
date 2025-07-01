
/*
{
  "batchId": "string",
  "stageType": "string",
  "startedAt": "string",
  "completedAt": "string",
  "completedBy": "string",
  "isCompleted": true,
  "sugarLevel": 0,
  "pH": 0,
  "temperature": 0,
  "quantityKg": 0,
  "observations": "string"
}
*/
class ReceptionStageDTO {
  final String batchId;
  final String stageType;
  final String startedAt;
  final String completedAt;
  final String completedBy;
  final bool isCompleted;
  final double sugarLevel;
  final double pH;
  final double temperature;
  final double quantityKg;
  final String observations;

  ReceptionStageDTO({
    required this.batchId,
    required this.stageType,
    required this.startedAt,
    required this.completedAt,
    required this.completedBy,
    required this.isCompleted,
    required this.sugarLevel,
    required this.pH,
    required this.temperature,
    required this.quantityKg,
    required this.observations,
  });
}
