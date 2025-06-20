import '../../domain/entities/supply.dart';

class SupplyModel extends Supply {
  const SupplyModel({
    required super.id,
    required super.name,
    required super.category,
    required super.quantity,
    required super.unit,
    required super.location,
    required super.expirationDate,
    required super.status,
  });

  factory SupplyModel.fromJson(Map<String, dynamic> json) {
    return SupplyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      location: json['location'] ?? '',
      expirationDate: json['expirationDate'] ?? '',
      status: json['status'] ?? 'Disponible',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'unit': unit,
      'location': location,
      'expirationDate': expirationDate,
      'status': status,
    };
  }

  factory SupplyModel.fromEntity(Supply supply) {
    return SupplyModel(
      id: supply.id,
      name: supply.name,
      category: supply.category,
      quantity: supply.quantity,
      unit: supply.unit,
      location: supply.location,
      expirationDate: supply.expirationDate,
      status: supply.status,
    );
  }
}
