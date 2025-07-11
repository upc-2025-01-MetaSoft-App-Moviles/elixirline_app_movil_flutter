import 'dart:convert';
import 'dart:io';

import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/fermentation_stage_dto.dart';
import 'package:http/http.dart' as http;

class FermentationStageService {
  final String _baseUrl;

  FermentationStageService(String resourceEndpoint)
    : _baseUrl = 'http://10.0.2.2:5110/api/v1$resourceEndpoint';

  Future<FermentationStageDto> getFermentationStage(String wineBatchId) {
    return http
        .get(Uri.parse("$_baseUrl/$wineBatchId/fermentation"))
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final map = jsonDecode(response.body);
            return FermentationStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error fetching fermentation stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception("Unexpected error in getFermentationStage: $error");
        });
  }

  Future<FermentationStageDto> create(String wineBatchId, Map<String, dynamic> stageData) {
    return http
        .post(
          Uri.parse("$_baseUrl/$wineBatchId/fermentation"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(stageData),
        )
        .then((response) {
          if (response.statusCode == HttpStatus.created) {
            final map = jsonDecode(response.body);
            return FermentationStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error creating fermentation stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception(
            "Unexpected error in createFermentationStage: $error",
          );
        });
  }

  Future<FermentationStageDto> update(
    String id,
    Map<String, dynamic> stageData,
  ) {
    return http
        .put(
          Uri.parse("$_baseUrl/$id/fermentation"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(stageData),
        )
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final map = jsonDecode(response.body);
            return FermentationStageDto.fromJson(map);
          } else {
            // Mostrar más detalles del error
            String responseBody = '';
            try {
              responseBody = response.body;
            } catch (e) {
              responseBody = 'No se pudo leer el cuerpo de la respuesta';
            }
            throw HttpException(
              "Error updating fermentation stage: ${response.statusCode}. Response: $responseBody",
            );
          }
        })
        .catchError((error) {
          throw Exception(
            "Unexpected error in updateFermentationStage: $error",
          );
        });
  }
}
