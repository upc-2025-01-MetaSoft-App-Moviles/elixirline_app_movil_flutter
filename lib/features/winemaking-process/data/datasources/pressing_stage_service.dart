import 'dart:convert';
import 'dart:io';

import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/pressing_stage_dto.dart';
import 'package:http/http.dart' as http;


class PressingStageService {
  final String _baseUrl;

  PressingStageService(String resourceEndpoint)
    : _baseUrl = 'http://10.0.2.2:5110/api/v1$resourceEndpoint';

  Future<PressingStageDto> getPressingStage(String wineBatchId) {
    return http
        .get(Uri.parse("$_baseUrl/$wineBatchId/pressing"))
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final map = jsonDecode(response.body);
            return PressingStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error fetching pressing stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception("Unexpected error in getPressingStage: $error");
        });
  }

  Future<PressingStageDto> create(String wineBatchId, Map<String, dynamic> stageData) {
    return http
        .post(
          Uri.parse("$_baseUrl/$wineBatchId/pressing"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(stageData),
        )
        .then((response) {
          if (response.statusCode == HttpStatus.created) {
            final map = jsonDecode(response.body);
            return PressingStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error creating pressing stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception(
            "Unexpected error in createPressingStage: $error",
          );
        });
  }

  Future<PressingStageDto> update(
    String wineBatchId,
    Map<String, dynamic> stageData,
  ) {
    return http
        .put(
          Uri.parse("$_baseUrl/$wineBatchId/pressing"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(stageData),
        )
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final map = jsonDecode(response.body);
            return PressingStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error updating pressing stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception(
            "Unexpected error in updatePressingStage: $error",
          );
        });
  }
}
