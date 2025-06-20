class Task {
  final String id;
  final String title;
  final String description;
  final String scheduledDate;
  final String parcelId;
  final int status;
  final String responsible;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.scheduledDate,
    required this.parcelId,
    required this.status,
    required this.responsible,
  });
}