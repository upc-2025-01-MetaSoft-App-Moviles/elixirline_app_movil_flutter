

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
class FiltrationStage {
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

  FiltrationStage({
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
 
}