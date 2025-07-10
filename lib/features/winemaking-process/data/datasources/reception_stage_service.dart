import 'dart:convert';
import 'dart:io';

import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/reception_stage_dto.dart';
import 'package:http/http.dart' as http;

class ReceptionStageService {
  final String _baseUrl;

  ReceptionStageService(String resourceEndpoint)
    : _baseUrl = 'http://10.0.2.2:5110/api/v1$resourceEndpoint';

  Future<ReceptionStageDto> getReceptionStage(String wineBatchId) {
    return http
        .get(Uri.parse("$_baseUrl/$wineBatchId"))
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final map = jsonDecode(response.body);
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

  Future<ReceptionStageDto> create(Map<String, dynamic> stageData) {
    return http
        .post(
          Uri.parse(_baseUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(stageData),
        )
        .then((response) {
          if (response.statusCode == HttpStatus.created) {
            final map = jsonDecode(response.body);
            return ReceptionStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error creating reception stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception(
            "Unexpected error in createReceptionStage: $error",
          );
        });
  }

  Future<ReceptionStageDto> update(
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
            return ReceptionStageDto.fromJson(map);
          } else {
            throw HttpException(
              "Error updating reception stage: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception(
            "Unexpected error in updateReceptionStage: $error",
          );
        });
  }
}
