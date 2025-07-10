import 'dart:convert';
import 'dart:io';

import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/clarification_stage_dto.dart';
import 'package:http/http.dart' as http;

class ClarificationStageService {
  final String _baseUrl;

  ClarificationStageService(String resourceEndpoint)
    : _baseUrl = 'http://10.0.2.2:5110/api/v1$resourceEndpoint';

  Future<ClarificationStageDto> getClarificationStage(String wineBatchId) {
    return http
        .get(Uri.parse("$_baseUrl/$wineBatchId/clarification"))
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final map = jsonDecode(response.body);
            return ClarificationStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error fetching clarification stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception("Unexpected error in getClarificationStage: $error");
        });
  }

  Future<ClarificationStageDto> create(String wineBatchId, Map<String, dynamic> stageData) {
    return http
        .post(
          Uri.parse("$_baseUrl/$wineBatchId/clarification"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(stageData),
        )
        .then((response) {
          if (response.statusCode == HttpStatus.created) {
            final map = jsonDecode(response.body);
            return ClarificationStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error creating clarification stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception(
            "Unexpected error in createClarificationStage: $error",
          );
        });
  }

  Future<ClarificationStageDto> update(
    String id,
    Map<String, dynamic> stageData,
  ) {
    return http
        .put(
          Uri.parse("$_baseUrl/$id/clarification"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(stageData),
        )
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final map = jsonDecode(response.body);
            return ClarificationStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error updating clarification stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception(
            "Unexpected error in updateClarificationStage: $error",
          );
        });
  }
}
