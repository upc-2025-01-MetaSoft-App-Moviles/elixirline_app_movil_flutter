import 'dart:convert';
import 'dart:io';

import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/models/wine_batch_dto.dart';
import 'package:http/http.dart' as http;

class WineBatchService {
  final String _baseUrl;

  WineBatchService(String resourceEndpoint) : _baseUrl = 'http://10.0.2.2:5110/api/v1$resourceEndpoint';

  Future<List<WineBatchDTO>> getWineBatches() {
    return http
        .get(Uri.parse(_baseUrl))
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final List<dynamic> maps = jsonDecode(response.body);
            return maps.map((e) => WineBatchDTO.fromJson(e)).toList();
          } else {
            throw HttpException(
              "Error fetching wine batches: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception("Unexpected error in getWineBatches: $error");
        });
  }

  Future<WineBatchDTO> getWineBatchById(int id) {
    return http
        .get(Uri.parse("$_baseUrl/$id"))
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final map = jsonDecode(response.body);
            return WineBatchDTO.fromJson(map);
          } else {
            throw HttpException(
              "Error fetching wine batch: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception("Unexpected error in getWineBatchById: $error");
        });
  }

  Future<WineBatchDTO> createWineBatch(Map<String, dynamic> batchData) {
    return http
        .post(
          Uri.parse(_baseUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(batchData),
        )
        .then((response) {
          if (response.statusCode == HttpStatus.created) {
            final map = jsonDecode(response.body);
            return WineBatchDTO.fromJson(map);
          } else {
            throw HttpException(
              "Error creating wine batch: ${response.statusCode}",
            );
          }
        })
        .catchError((error) {
          throw Exception("Unexpected error in createWineBatch: $error");
        });
  }

  Future<WineBatchDTO> updateWineBatch(String id, Map<String, dynamic> batchData) {
  return http
    .put(
      Uri.parse("$_baseUrl/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(batchData),
    )
    .then((response) {
      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.noContent) {
        if (response.body.isNotEmpty) {
          final map = jsonDecode(response.body);
          return WineBatchDTO.fromJson(map);
        } else {
          throw Exception("Respuesta vacía del servidor.");
        }
      } else {
        throw HttpException("Error updating wine batch: ${response.statusCode}");
      }
    })
    .catchError((error) {
      throw Exception("Unexpected error in updateWineBatch: $error");
    });
  }


}
