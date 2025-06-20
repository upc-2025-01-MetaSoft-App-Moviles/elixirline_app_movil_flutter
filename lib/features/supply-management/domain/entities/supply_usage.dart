import 'package:equatable/equatable.dart';

class SupplyUsage extends Equatable {
  final String id;
  final String supplyId;
  final String batchId;
  final double quantity;
  final String activity;
  final String date;
  final String operatorName;

  const SupplyUsage({
    required this.id,
    required this.supplyId,
    required this.batchId,
    required this.quantity,
    required this.activity,
    required this.date,
    required this.operatorName,
  });

  SupplyUsage copyWith({
    String? id,
    String? supplyId,
    String? batchId,
    double? quantity,
    String? activity,
    String? date,
    String? operatorName,
  }) {
    return SupplyUsage(
      id: id ?? this.id,
      supplyId: supplyId ?? this.supplyId,
      batchId: batchId ?? this.batchId,
      quantity: quantity ?? this.quantity,
      activity: activity ?? this.activity,
      date: date ?? this.date,
      operatorName: operatorName ?? this.operatorName,
    );
  }

  @override
  List<Object?> get props => [
        id,
        supplyId,
        batchId,
        quantity,
        activity,
        date,
        operatorName,
      ];
}
