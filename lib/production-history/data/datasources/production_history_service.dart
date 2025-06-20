import 'dart:convert';
import 'dart:io';

import 'package:elixirline_app_movil_flutter/production-history/data/models/production_history_dto.dart';
import 'package:http/http.dart' as http;

/// Servicio para obtener historiales de producción desde la API
class ProductionHistoryService {
  final http.Client client;
  final String baseUrl = 'https://my-json-server.typicode.com/fabricio011001/fakeapi';

  ProductionHistoryService({http.Client? client}) 
      : this.client = client ?? http.Client();

  /// Obtiene todos los historiales de producción
  Future<List<ProductionHistoryDto>> getAllProductionHistories() async {
    try {
      final uri = Uri.parse('$baseUrl/id');
      final response = await client.get(uri);
      
      if (response.statusCode == HttpStatus.ok) {
        // Decodificar y convertir la respuesta JSON
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => ProductionHistoryDto.fromJson(json))
            .toList();
      } else {
        throw Exception('Error al obtener historiales: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  void dispose() {
    client.close();
  }
}