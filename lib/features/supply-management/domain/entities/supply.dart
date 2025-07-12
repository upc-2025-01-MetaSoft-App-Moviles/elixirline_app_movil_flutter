import 'package:equatable/equatable.dart';

class Supply extends Equatable {
  final String id;
  final String name;
  final String category;
  final double quantity;
  final String unit;
  final String location;
  final String expirationDate;
  final String status;

  const Supply({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.location,
    required this.expirationDate,
    required this.status,
  });

  Supply copyWith({
    String? id,
    String? name,
    String? category,
    double? quantity,
    String? unit,
    String? location,
    String? expirationDate,
    String? status,
  }) {
    return Supply(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      location: location ?? this.location,
      expirationDate: expirationDate ?? this.expirationDate,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        quantity,
        unit,
        location,
        expirationDate,
        status,
      ];
}
