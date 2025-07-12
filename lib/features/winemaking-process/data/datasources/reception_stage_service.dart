import 'dart:convert';
import 'dart:io';

import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/reception_stage_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ReceptionStageService {
  final String _baseUrl;

  ReceptionStageService(String resourceEndpoint)
    : _baseUrl = 'https://elixirline.azurewebsites.net/api/v1$resourceEndpoint';

  Future<ReceptionStageDto> getReceptionStage(String wineBatchId) {
    return http
        .get(Uri.parse("$_baseUrl/$wineBatchId/reception"))
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final map = jsonDecode(response.body);

    debugPrint('📥 ======================= Reception Stage recibido: $map');

            return ReceptionStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error fetching reception stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception("Unexpected error in getReceptionStage: $error");
        });
  }

  Future<ReceptionStageDto> create(String wineBatchId, Map<String, dynamic> stageData) {
    debugPrint('📤 ======================= Creando Reception Stage');
    debugPrint('📤 URL: $_baseUrl/$wineBatchId/reception');
    debugPrint('📤 Datos: $stageData');
    
    return http
        .post(
          Uri.parse("$_baseUrl/$wineBatchId/reception"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(stageData),
        )
        .then((response) {
          debugPrint('📤 Response status: ${response.statusCode}');
          debugPrint('📤 Response body: ${response.body}');
          
          if (response.statusCode == HttpStatus.created) {
            final map = jsonDecode(response.body);
            return ReceptionStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error creating reception stage: ${response.statusCode} - ${response.body}",
            );
          }
        })
        .catchError((error) {
          debugPrint('❌ Error en createReceptionStage: $error');
          throw Exception(
            "Unexpected error in createReceptionStage: $error",
          );
        });
  }

  Future<ReceptionStageDto> update(
    String wineBatchId,
    Map<String, dynamic> stageData,
  ) {
    debugPrint('📤 ======================= Actualizando Reception Stage');
    debugPrint('📤 URL: $_baseUrl/$wineBatchId/reception');
    debugPrint('📤 Datos: $stageData');
    
    return http
        .put(
          Uri.parse("$_baseUrl/$wineBatchId/reception"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(stageData),
        )
        .then((response) {
          debugPrint('📤 Response status: ${response.statusCode}');
          debugPrint('📤 Response body: ${response.body}');
          
          if (response.statusCode == HttpStatus.ok) {
            final map = jsonDecode(response.body);
            return ReceptionStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error updating reception stage: ${response.statusCode} - ${response.body}",
            );
          }
        })
        .catchError((error) {
          debugPrint('❌ Error en updateReceptionStage: $error');
          throw Exception(
            "Unexpected error in updateReceptionStage: $error",
          );
        });
  }
}
