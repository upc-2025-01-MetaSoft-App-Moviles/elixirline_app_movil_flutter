import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wine_batch_model.dart';
import '../models/stages_model.dart';

abstract class WineBatchRemoteDataSource {
  Future<List<WineBatchModel>> getWineBatches();
  Future<WineBatchModel?> getWineBatchById(String batchId);
  Future<List<StagesModel>> getAllStages();
  Future<List<StagesModel>> getStagesByBatchId(String batchId);
}

class WineBatchRemoteDataSourceImpl implements WineBatchRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://my-json-server.typicode.com/upc-2025-01-MetaSoft-App-Moviles/fake-api-winemaking-process';

  WineBatchRemoteDataSourceImpl({required this.client});

  @override
  Future<List<WineBatchModel>> getWineBatches() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/wine_batches'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => WineBatchModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load wine batches: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching wine batches: $e');
    }
  }

  @override
  Future<WineBatchModel?> getWineBatchById(String batchId) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/wine_batches/$batchId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return WineBatchModel.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load wine batch: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching wine batch: $e');
    }
  }

  @override
  Future<List<StagesModel>> getAllStages() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/stages'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => StagesModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load stages: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching stages: $e');
    }
  }

  @override
  Future<List<StagesModel>> getStagesByBatchId(String batchId) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/stages?batchId=$batchId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => StagesModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load stages for batch: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching stages for batch: $e');
    }
  }
}
