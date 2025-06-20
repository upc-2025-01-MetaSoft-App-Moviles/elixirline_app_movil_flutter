import '../models/supply_model.dart';
import '../models/supply_usage_model.dart';

abstract class SupplyLocalDataSource {
  Future<List<SupplyModel>> getAllSupplies();
  Future<SupplyModel?> getSupplyById(String id);
  Future<bool> createSupply(SupplyModel supply);
  Future<bool> updateSupply(SupplyModel supply);
  Future<bool> deleteSupply(String id);
  Future<List<SupplyUsageModel>> getAllSupplyUsages();
  Future<bool> registerSupplyUsage(SupplyUsageModel usage);
}

class SupplyLocalDataSourceImpl implements SupplyLocalDataSource {
  // Simulamos una base de datos local con listas en memoria
  final List<SupplyModel> _supplies = [
    const SupplyModel(
      id: '1',
      name: 'Fosfato Monopotásico',
      category: 'Fertilizante',
      quantity: 25.0,
      unit: 'kg',
      location: 'Bodega Principal',
      expirationDate: '12/05/2025',
      status: 'Disponible',
    ),
    const SupplyModel(
      id: '2',
      name: 'Herbicida A',
      category: 'Pesticida',
      quantity: 8.0,
      unit: 'lt',
      location: 'Bodega Principal',
      expirationDate: '12/05/2025',
      status: 'Disponible',
    ),
    const SupplyModel(
      id: '3',
      name: 'Guante de Trabajo',
      category: 'Herramientas',
      quantity: 10.0,
      unit: 'Pares',
      location: 'Almacén',
      expirationDate: '12/05/2025',
      status: 'Disponible',
    ),
  ];

  final List<SupplyUsageModel> _supplyUsages = [];

  @override
  Future<List<SupplyModel>> getAllSupplies() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simular delay
    return List.from(_supplies);
  }

  @override
  Future<SupplyModel?> getSupplyById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _supplies.firstWhere((supply) => supply.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> createSupply(SupplyModel supply) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      _supplies.add(supply);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateSupply(SupplyModel supply) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final index = _supplies.indexWhere((s) => s.id == supply.id);
      if (index != -1) {
        _supplies[index] = supply;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteSupply(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      _supplies.removeWhere((supply) => supply.id == id);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<SupplyUsageModel>> getAllSupplyUsages() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_supplyUsages);
  }

  @override
  Future<bool> registerSupplyUsage(SupplyUsageModel usage) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      _supplyUsages.add(usage);
      
      // Actualizar la cantidad del insumo
      final supplyIndex = _supplies.indexWhere((s) => s.id == usage.supplyId);
      if (supplyIndex != -1) {
        final supply = _supplies[supplyIndex];
        final newQuantity = supply.quantity - usage.quantity;
        if (newQuantity >= 0) {
          _supplies[supplyIndex] = SupplyModel(
            id: supply.id,
            name: supply.name,
            category: supply.category,
            quantity: newQuantity,
            unit: supply.unit,
            location: supply.location,
            expirationDate: supply.expirationDate,
            status: supply.status,
          );
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
