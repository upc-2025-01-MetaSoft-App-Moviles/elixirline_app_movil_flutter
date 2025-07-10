import 'dart:convert';
import 'dart:io';

import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/bottling_stage_dto.dart';
import 'package:http/http.dart' as http;


class BottlingStageService {
  final String _baseUrl;

  BottlingStageService(String resourceEndpoint)
    : _baseUrl = 'http://10.0.2.2:5110/api/v1$resourceEndpoint';

  Future<BottlingStageDto> getBottlingStage(String wineBatchId) {
    return http
        .get(Uri.parse("$_baseUrl/$wineBatchId/bottling"))
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final map = jsonDecode(response.body);
            return BottlingStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error fetching bottling stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception("Unexpected error in getBottlingStage: $error");
        });
  }

  Future<BottlingStageDto> create(String wineBatchId, Map<String, dynamic> stageData) {
    return http
        .post(
          Uri.parse("$_baseUrl/$wineBatchId/bottling"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(stageData),
        )
        .then((response) {
          if (response.statusCode == HttpStatus.created) {
            final map = jsonDecode(response.body);
            return BottlingStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error creating bottling stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception(
            "Unexpected error in createBottlingStage: $error",
          );
        });
  }

  Future<BottlingStageDto> update(
    String id,
    Map<String, dynamic> stageData,
  ) {
    return http
        .put(
          Uri.parse("$_baseUrl/$id/bottling"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(stageData),
        )
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final map = jsonDecode(response.body);
            return BottlingStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error updating bottling stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception(
            "Unexpected error in updateBottlingStage: $error",
          );
        });
  }
}
