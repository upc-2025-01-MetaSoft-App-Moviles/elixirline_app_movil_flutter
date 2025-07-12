import 'dart:convert';
import 'dart:io';

import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/correction_stage_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


class CorrectionStageService {
  final String _baseUrl;

  CorrectionStageService(String resourceEndpoint)
    : _baseUrl = 'https://elixirline.azurewebsites.net/api/v1$resourceEndpoint';  

  Future<CorrectionStageDto> getCorrectionStage(String wineBatchId) {
    return http
        .get(Uri.parse("$_baseUrl/$wineBatchId/correction"))
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final map = jsonDecode(response.body);
            return CorrectionStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error fetching correction stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception("Unexpected error in getCorrectionStage: $error");
        });
  }

  Future<CorrectionStageDto> create(String wineBatchId, Map<String, dynamic> stageData) {
    if (kDebugMode) {
      print('📤 ======================= Creando Correction Stage');
      print('📤 URL: $_baseUrl/$wineBatchId/correction');
      print('📤 Datos: $stageData');
    }
    return http
        .post(
          Uri.parse("$_baseUrl/$wineBatchId/correction"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(stageData),
        )
        .then((response) {
          if (kDebugMode) {
            print('📤 Response status: ${response.statusCode}');
            print('📤 Response body: ${response.body}');
          }
          if (response.statusCode == HttpStatus.created) {
            final map = jsonDecode(response.body);
            return CorrectionStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error creating correction stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception(
            "Unexpected error in createCorrectionStage: $error",
          );
        });
  }

  Future<CorrectionStageDto> update(
    String id,
    Map<String, dynamic> stageData,
  ) {
    return http
        .put(
          Uri.parse("$_baseUrl/$id/correction"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(stageData),
        )
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final map = jsonDecode(response.body);
            return CorrectionStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error updating correction stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception(
            "Unexpected error in updateCorrectionStage: $error",
          );
        });
  }
}
