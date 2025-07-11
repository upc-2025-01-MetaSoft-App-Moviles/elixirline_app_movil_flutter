import 'dart:convert';
import 'dart:io';

import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/aging_stage_dto.dart';
import 'package:http/http.dart' as http;

class AgingStageService {
  final String _baseUrl;

  AgingStageService(String resourceEndpoint)
    : _baseUrl = 'http://10.0.2.2:5110/api/v1$resourceEndpoint';

  Future<AgingStageDto> getAgingStage(String wineBatchId) {
    return http
        .get(Uri.parse("$_baseUrl/$wineBatchId/aging"))
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final map = jsonDecode(response.body);
            return AgingStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error fetching aging stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception("Unexpected error in getAgingStage: $error");
        });
  }

  Future<AgingStageDto> create(String wineBatchId, Map<String, dynamic> stageData) {
    return http
        .post(
          Uri.parse("$_baseUrl/$wineBatchId/aging"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(stageData),
        )
        .then((response) {
          if (response.statusCode == HttpStatus.created) {
            final map = jsonDecode(response.body);
            return AgingStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error creating aging stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception(
            "Unexpected error in createAgingStage: $error",
          );
        });
  }

  Future<AgingStageDto> update(
    String id,
    Map<String, dynamic> stageData,
  ) {
    return http
        .put(
          Uri.parse("$_baseUrl/$id/aging"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(stageData),
        )
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final map = jsonDecode(response.body);
            return AgingStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error updating aging stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception(
            "Unexpected error in updateAgingStage: $error",
          );
        });
  }
}
