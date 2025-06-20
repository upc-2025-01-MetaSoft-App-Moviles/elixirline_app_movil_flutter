import '../../domain/entities/wine_batch.dart';
import '../../domain/entities/stages.dart';
import '../datasources/wine_batch_remote_datasource.dart';

abstract class WineBatchRepository {
  Future<List<WineBatch>> getWineBatches();
  Future<WineBatch?> getWineBatchById(String batchId);
  Future<List<Stages>> getAllStages();
  Future<List<Stages>> getStagesByBatchId(String batchId);
}

class WineBatchRepositoryImpl implements WineBatchRepository {
  final WineBatchRemoteDataSource remoteDataSource;

  WineBatchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<WineBatch>> getWineBatches() async {
    try {
      final batches = await remoteDataSource.getWineBatches();
      return batches.map((model) => model as WineBatch).toList();
    } catch (e) {
      throw Exception('Error al obtener lotes de vino: $e');
    }
  }

  @override
  Future<WineBatch?> getWineBatchById(String batchId) async {
    try {
      final batch = await remoteDataSource.getWineBatchById(batchId);
      return batch;
    } catch (e) {
      throw Exception('Error al obtener lote de vino: $e');
    }
  }

  @override
  Future<List<Stages>> getAllStages() async {
    try {
      final stages = await remoteDataSource.getAllStages();
      return stages.map((model) => model as Stages).toList();
    } catch (e) {
      throw Exception('Error al obtener etapas: $e');
    }
  }

  @override
  Future<List<Stages>> getStagesByBatchId(String batchId) async {
    try {
      final stages = await remoteDataSource.getStagesByBatchId(batchId);
      return stages.map((model) => model as Stages).toList();
    } catch (e) {
      throw Exception('Error al obtener etapas del lote: $e');
    }
  }
}
