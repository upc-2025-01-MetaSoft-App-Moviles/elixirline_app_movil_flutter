class FieldLogEntry {
  final String entryId;
  final String authorId;
  final String parcelId;
  final String relatedTaskId; // ✅ nuevo campo
  final String description;
  final String entryType;
  final DateTime timestamp;
  final List<String> photoUrls;

  const FieldLogEntry({
    required this.entryId,
    required this.authorId,
    required this.parcelId,
    required this.relatedTaskId,
    required this.description,
    required this.entryType,
    required this.timestamp,
    required this.photoUrls,
  });
}
