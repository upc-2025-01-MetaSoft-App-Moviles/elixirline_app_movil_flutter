

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
class PressingStage {
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

  PressingStage({
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
 
}
