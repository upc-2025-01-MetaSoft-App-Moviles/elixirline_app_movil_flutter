

/*
{
  "batchId": "string",
  "stageType": "string",
  "startedAt": "string",
  "completedAt": "string",
  "completedBy": "string",
  "observations": "string",
  "isCompleted": true,
  "containerType": "string",
  "material": "string",
  "containerCode": "string",
  "avgTemperature": 0,
  "volumeLiters": 0,
  "durationMonths": 0,
  "frequencyDays": 0,
  "refilled": 0,
  "batonnage": 0,
  "rackings": 0,
  "purpose": "string"
}
*/

class AgingStage {
  final String batchId;
  final String stageType;
  final String startedAt;
  final String completedAt;
  final String completedBy;
  final String observations;
  final bool isCompleted;
  final String containerType;
  final String material;
  final String containerCode;
  final double avgTemperature;
  final double volumeLiters;
  final int durationMonths;
  final int frequencyDays;
  final int refilled;
  final int batonnage;
  final int rackings;
  final String purpose;

  AgingStage({
    required this.batchId,
    required this.stageType,
    required this.startedAt,
    required this.completedAt,
    required this.completedBy,
    required this.observations,
    required this.isCompleted,
    required this.containerType,
    required this.material,
    required this.containerCode,
    required this.avgTemperature,
    required this.volumeLiters,
    required this.durationMonths,
    required this.frequencyDays,
    required this.refilled,
    required this.batonnage,
    required this.rackings,
    required this.purpose,
  });
  
}