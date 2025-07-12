import '../../domain/entities/production_history.dart';

abstract class ProductionHistoryRepository {
  Future<List<ProductionHistory>> getAllProductionHistories();
  void dispose();
}