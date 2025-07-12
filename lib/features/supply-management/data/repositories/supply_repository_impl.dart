import '../../domain/entities/supply.dart';
import '../../domain/entities/supply_usage.dart';
import '../datasources/supply_local_datasource.dart';
import '../models/supply_model.dart';
import '../models/supply_usage_model.dart';

abstract class SupplyRepository {
  Future<List<Supply>> getAllSupplies();
  Future<Supply?> getSupplyById(String id);
  Future<bool> createSupply(Supply supply);
  Future<bool> updateSupply(Supply supply);
  Future<bool> deleteSupply(String id);
  Future<List<SupplyUsage>> getAllSupplyUsages();
  Future<bool> registerSupplyUsage(SupplyUsage usage);
}

class SupplyRepositoryImpl implements SupplyRepository {
  final SupplyLocalDataSource localDataSource;

  SupplyRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Supply>> getAllSupplies() async {
    try {
      final supplies = await localDataSource.getAllSupplies();
      return supplies.map((model) => model as Supply).toList();
    } catch (e) {
      throw Exception('Error al obtener insumos: $e');
    }
  }

  @override
  Future<Supply?> getSupplyById(String id) async {
    try {
      final supply = await localDataSource.getSupplyById(id);
      return supply;
    } catch (e) {
      throw Exception('Error al obtener insumo: $e');
    }
  }

  @override
  Future<bool> createSupply(Supply supply) async {
    try {
      final model = SupplyModel.fromEntity(supply);
      return await localDataSource.createSupply(model);
    } catch (e) {
      throw Exception('Error al crear insumo: $e');
    }
  }

  @override
  Future<bool> updateSupply(Supply supply) async {
    try {
      final model = SupplyModel.fromEntity(supply);
      return await localDataSource.updateSupply(model);
    } catch (e) {
      throw Exception('Error al actualizar insumo: $e');
    }
  }

  @override
  Future<bool> deleteSupply(String id) async {
    try {
      return await localDataSource.deleteSupply(id);
    } catch (e) {
      throw Exception('Error al eliminar insumo: $e');
    }
  }

  @override
  Future<List<SupplyUsage>> getAllSupplyUsages() async {
    try {
      final usages = await localDataSource.getAllSupplyUsages();
      return usages.map((model) => model as SupplyUsage).toList();
    } catch (e) {
      throw Exception('Error al obtener usos de insumos: $e');
    }
  }

  @override
  Future<bool> registerSupplyUsage(SupplyUsage usage) async {
    try {
      final model = SupplyUsageModel.fromEntity(usage);
      return await localDataSource.registerSupplyUsage(model);
    } catch (e) {
      throw Exception('Error al registrar uso de insumo: $e');
    }
  }
}
