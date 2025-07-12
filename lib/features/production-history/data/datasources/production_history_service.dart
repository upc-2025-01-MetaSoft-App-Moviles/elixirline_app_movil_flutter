import 'dart:convert';
import 'dart:io';
import '../models/production_history_dto.dart';
import 'package:http/http.dart' as http;

/// Servicio para obtener historiales de producción desde la API
class ProductionHistoryService {
  final http.Client client;
  final String baseUrl = 'https://elixirline.azurewebsites.net/api/v1/production-record';

  ProductionHistoryService({http.Client? client}) 
      : this.client = client ?? http.Client();

  /// Obtiene todos los historiales de producción
  Future<List<ProductionHistoryDto>> getAllProductionHistories() async {
    try {
      final uri = Uri.parse(baseUrl); 
      final response = await client.get(uri);
      
      if (response.statusCode == 200) { 
        print('Respuesta API: ${response.body}');
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => ProductionHistoryDto.fromJson(json))
            .toList();
      } else {
        throw Exception('Error al obtener historiales: ${response.statusCode}');
      }
    } catch (e) {
      print('Error detallado: $e'); 
      throw Exception('Error de conexión: $e');
    }
  }

  /// Crea un nuevo registro de producción
Future<ProductionHistoryDto> createProductionRecord(Map<String, dynamic> data) async {
  try {
    final uri = Uri.parse(baseUrl);
    
    // Debug: imprimir URL y datos
    print('URL: $uri');
    print('Datos JSON: ${json.encode(data)}');
    
    final response = await client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(data),
    );
    
    // Debug: imprimir respuesta completa
    print('Status Code: ${response.statusCode}');
    print('Response Headers: ${response.headers}');
    print('Response Body: ${response.body}');
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ProductionHistoryDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error del servidor (${response.statusCode}): ${response.body}');
    }
  } catch (e) {
    print('Error en createProductionRecord: $e');
    throw Exception('Error de conexión: $e');
  }
}

  /// Obtiene un historial de producción por RecordId
  Future<ProductionHistoryDto> getProductionHistoryByRecordId(String recordId) async {
    try {
      final uri = Uri.parse('$baseUrl/$recordId');
      final response = await client.get(uri);
      
      if (response.statusCode == 200) {
        return ProductionHistoryDto.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al obtener historial: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Obtiene un historial de producción por BatchId
  Future<ProductionHistoryDto> getProductionHistoryByBatchId(String batchId) async {
    try {
      final uri = Uri.parse('$baseUrl/batch/$batchId');
      final response = await client.get(uri);
      
      if (response.statusCode == 200) {
        return ProductionHistoryDto.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al obtener historial: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Elimina un historial de producción
  Future<void> deleteProductionHistory(String recordId) async {
    try {
      final uri = Uri.parse('$baseUrl/$recordId');
      final response = await client.delete(uri);
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error al eliminar historial: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  void dispose() {
    client.close();
  }
}