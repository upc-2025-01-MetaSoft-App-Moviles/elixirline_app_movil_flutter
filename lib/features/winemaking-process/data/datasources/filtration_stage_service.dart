import 'dart:convert';
import 'dart:io';

import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/filtration_stage_dto.dart';
import 'package:http/http.dart' as http;

class FiltrationStageService {
  final String _baseUrl;

  FiltrationStageService(String resourceEndpoint)
    : _baseUrl = 'http://10.0.2.2:5110/api/v1$resourceEndpoint';

  Future<FiltrationStageDto> getFiltrationStage(String wineBatchId) {
    return http
        .get(Uri.parse("$_baseUrl/$wineBatchId"))
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final map = jsonDecode(response.body);
            return FiltrationStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error fetching filtration stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception("Unexpected error in getFiltrationStage: $error");
        });
  }

  Future<FiltrationStageDto> create(Map<String, dynamic> stageData) {
    return http
        .post(
          Uri.parse(_baseUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(stageData),
        )
        .then((response) {
          if (response.statusCode == HttpStatus.created) {
            final map = jsonDecode(response.body);
            return FiltrationStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error creating filtration stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception(
            "Unexpected error in createFiltrationStage: $error",
          );
        });
  }

  Future<FiltrationStageDto> update(
    String id,
    Map<String, dynamic> stageData,
  ) {
    return http
        .put(
          Uri.parse("$_baseUrl/$id"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(stageData),
        )
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final map = jsonDecode(response.body);
            return FiltrationStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error updating filtration stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception(
            "Unexpected error in updateFiltrationStage: $error",
          );
        });
  }
}
