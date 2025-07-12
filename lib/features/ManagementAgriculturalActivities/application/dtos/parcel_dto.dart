class ParcelDto {
  final String id;
  final String name;
  final String cropType;
  final String growthStage;
  final String lastTask;
  final String yieldEstimate;
  final String location;
  final String status;

  ParcelDto({
    required this.id,
    required this.name,
    required this.cropType,
    required this.growthStage,
    required this.lastTask,
    required this.yieldEstimate,
    required this.location,
    required this.status,
  });
}