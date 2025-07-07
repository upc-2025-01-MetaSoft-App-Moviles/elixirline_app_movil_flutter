import 'package:elixirline_app_movil_flutter/features/fieldlog/domain/field_log_entry.dart';

class FieldLogEntryDto {
  final String entryId;
  final String authorId;
  final String parcelId;
  final String relatedTaskId; // ✅ nuevo campo
  final String description;
  final String entryType;
  final String timestamp;
  final List<String> photoUrls;

  FieldLogEntryDto({
    required this.entryId,
    required this.authorId,
    required this.parcelId,
    required this.relatedTaskId,
    required this.description,
    required this.entryType,
    required this.timestamp,
    required this.photoUrls,
  });

  factory FieldLogEntryDto.fromJson(Map<String, dynamic> json) {
    return FieldLogEntryDto(
      entryId: json['entryId'] ?? '',
      authorId: json['authorId'] ?? '',
      parcelId: json['parcelId'] ?? '',
      relatedTaskId: json['relatedTaskId'] ?? '',
      description: json['description'] ?? '',
      entryType: json['entryType'] ?? '',
      timestamp: json['timestamp'] ?? '',
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entryId': entryId,
      'authorId': authorId,
      'parcelId': parcelId,
      'relatedTaskId': relatedTaskId,
      'description': description,
      'entryType': entryType,
      'timestamp': timestamp,
      'photoUrls': photoUrls,
    };
  }

  FieldLogEntry toDomain() {
    return FieldLogEntry(
      entryId: entryId,
      authorId: authorId,
      parcelId: parcelId,
      relatedTaskId: relatedTaskId,
      description: description,
      entryType: entryType,
      timestamp: DateTime.parse(timestamp),
      photoUrls: photoUrls,
    );
  }

  static FieldLogEntryDto fromDomain(FieldLogEntry entry) {
    return FieldLogEntryDto(
      entryId: entry.entryId,
      authorId: entry.authorId,
      parcelId: entry.parcelId,
      relatedTaskId: entry.relatedTaskId,
      description: entry.description,
      entryType: entry.entryType,
      timestamp: entry.timestamp.toIso8601String(),
      photoUrls: entry.photoUrls,
    );
  }
}
