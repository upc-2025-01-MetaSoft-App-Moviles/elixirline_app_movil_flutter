class ProductionHistory {
  final String recordId;
  final String batchId;
  final DateTime startDate;
  final DateTime endDate;
  final double volumeProduced;
  final QualityMetrics qualityMetrics;

  const ProductionHistory({
    required this.recordId,
    required this.batchId,
    required this.startDate,
    required this.endDate,
    required this.volumeProduced,
    required this.qualityMetrics,
  });
}

class QualityMetrics {
  final double brix;
  final double ph;
  final double temperature;

  const QualityMetrics({
    required this.brix,
    required this.ph,
    required this.temperature,
  });
}