import '../../domain/entities/production_history.dart';
import '../repositories/production_history_repository.dart';
import '../datasources/production_history_service.dart';

class ProductionHistoryRepositoryImpl implements ProductionHistoryRepository {
  final ProductionHistoryService _productionHistoryService;

  ProductionHistoryRepositoryImpl({
    required ProductionHistoryService productionHistoryService,
  }) : _productionHistoryService = productionHistoryService;

  @override
  Future<List<ProductionHistory>> getAllProductionHistories() async {
    try {
      final dtos = await _productionHistoryService.getAllProductionHistories();
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (e) {
      throw Exception('Error en repositorio: $e');
    }
  }


  @override
  void dispose() {
    _productionHistoryService.dispose();
  }
}