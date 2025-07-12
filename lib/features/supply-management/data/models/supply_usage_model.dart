import '../../domain/entities/supply_usage.dart';

class SupplyUsageModel extends SupplyUsage {
  const SupplyUsageModel({
    required super.id,
    required super.supplyId,
    required super.batchId,
    required super.quantity,
    required super.activity,
    required super.date,
    required super.operatorName,
  });

  factory SupplyUsageModel.fromJson(Map<String, dynamic> json) {
    return SupplyUsageModel(
      id: json['id'] ?? '',
      supplyId: json['supplyId'] ?? '',
      batchId: json['batchId'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      activity: json['activity'] ?? '',
      date: json['date'] ?? '',
      operatorName: json['operatorName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplyId': supplyId,
      'batchId': batchId,
      'quantity': quantity,
      'activity': activity,
      'date': date,
      'operatorName': operatorName,
    };
  }

  factory SupplyUsageModel.fromEntity(SupplyUsage usage) {
    return SupplyUsageModel(
      id: usage.id,
      supplyId: usage.supplyId,
      batchId: usage.batchId,
      quantity: usage.quantity,
      activity: usage.activity,
      date: usage.date,
      operatorName: usage.operatorName,
    );
  }
}
