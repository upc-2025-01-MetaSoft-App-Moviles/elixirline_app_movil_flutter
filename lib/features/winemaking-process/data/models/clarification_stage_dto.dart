
/*
{
  "batchId": "string",
  "stageType": "string",
  "startedAt": "string",
  "completedAt": "string",
  "completedBy": "string",
  "isCompleted": true,
  "method": "string",
  "initialTurbidityNtu": 0,
  "finalTurbidityNtu": 0,
  "wineVolumeLitres": 0,
  "temperature": 0,
  "durationHours": 0,
  "observations": "string"
}
*/
class ClarificationStageDto {
  final String batchId;
  final String stageType;
  final String startedAt;
  final String completedAt;
  final String completedBy;
  final bool isCompleted;
  final String method;
  final double initialTurbidityNtu;
  final double finalTurbidityNtu;
  final double wineVolumeLitres;
  final double temperature;
  final int durationHours;
  final String observations;

  ClarificationStageDto({
    required this.batchId,
    required this.stageType,
    required this.startedAt,
    required this.completedAt,
    required this.completedBy,
    required this.isCompleted,
    required this.method,
    required this.initialTurbidityNtu,
    required this.finalTurbidityNtu,
    required this.wineVolumeLitres,
    required this.temperature,
    required this.durationHours,
    required this.observations,
  });
  
}