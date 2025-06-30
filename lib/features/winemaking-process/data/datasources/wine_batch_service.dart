import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;


class WineBatchService {
  final String _baseUrl;

  WineBatchService(String resourceEndpoint)
      : _baseUrl = 'https://elixirline-api.com/$resourceEndpoint';

  Future<List<dynamic>> getWineBatches() {
    return http
        .get(Uri.parse(_baseUrl))
        .then((response) {
          final List<dynamic> maps = jsonDecode(response.body);
          return maps;
        })
        .catchError((error) {
          throw Exception("Unexpected error in getWineBatches: $error");
        });
  }

  Future<dynamic> getWineBatchById(int id) {
    return http
        .get(Uri.parse("$_baseUrl/$id"))
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final map = jsonDecode(response.body);
            return map;
          } else {
            throw HttpException("Error fetching wine batch: ${response.statusCode}");
          }
        })
        .catchError((error) {
          throw Exception("Unexpected error in getWineBatchById: $error");
        });
  }

  Future<void> createWineBatch(Map<String, dynamic> batchData) {
    return http
        .post(
          Uri.parse(_baseUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(batchData),
        )
        .then((response) {
          if (response.statusCode != HttpStatus.created) {
            throw HttpException("Error creating wine batch: ${response.statusCode}");
          }
        })
        .catchError((error) {
          throw Exception("Unexpected error in createWineBatch: $error");
        });
  }

  Future<void> updateWineBatch(int id, Map<String, dynamic> batchData) {
    return http
        .put(
          Uri.parse("$_baseUrl/$id"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(batchData),
        )
        .then((response) {
          if (response.statusCode != HttpStatus.ok) {
            throw HttpException("Error updating wine batch: ${response.statusCode}");
          }
        })
        .catchError((error) {
          throw Exception("Unexpected error in updateWineBatch: $error");
        });
  }
}