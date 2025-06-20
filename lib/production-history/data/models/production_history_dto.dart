import '../../domain/entities/production_history.dart';

class ProductionHistoryDto {
  final String recordId;
  final String batchId;
  final String startDate;
  final String endDate;
  final double volumeProduced;
  final QualityMetricsDto qualityMetrics;

  const ProductionHistoryDto({
    required this.recordId,
    required this.batchId,
    required this.startDate,
    required this.endDate,
    required this.volumeProduced,
    required this.qualityMetrics,
  });

  // Convertir DTO a entidad de dominio
  ProductionHistory toDomain() {
    return ProductionHistory(
      recordId: recordId,
      batchId: batchId,
      startDate: DateTime.parse(startDate),
      endDate: DateTime.parse(endDate),
      volumeProduced: volumeProduced,
      qualityMetrics: qualityMetrics.toDomain(),
    );
  }

  // Crear DTO desde JSON
  factory ProductionHistoryDto.fromJson(Map<String, dynamic> json) {
    return ProductionHistoryDto(
      recordId: json['recordId'] as String? ?? '',
      batchId: json['batchId'] as String? ?? '',
      startDate: json['startDate'] as String? ?? DateTime.now().toIso8601String(),
      endDate: json['endDate'] as String? ?? DateTime.now().toIso8601String(),
      volumeProduced: (json['volumeProduced'] as num?)?.toDouble() ?? 0.0,
      qualityMetrics: QualityMetricsDto(
        brix: (json['brix'] as num?)?.toDouble() ?? 0.0,
        ph: (json['ph'] as num?)?.toDouble() ?? 0.0,
        temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      ),
    );
  }
}

class QualityMetricsDto {
  final double brix;
  final double ph;
  final double temperature;

  const QualityMetricsDto({
    required this.brix,
    required this.ph,
    required this.temperature,
  });

  // Convertir DTO a entidad de dominio
  QualityMetrics toDomain() {
    return QualityMetrics(
      brix: brix,
      ph: ph,
      temperature: temperature,
    );
  }
}