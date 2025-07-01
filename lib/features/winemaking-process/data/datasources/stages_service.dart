import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class StagesByWineBatchService {

  final String _baseUrl;

  StagesByWineBatchService(String resourceEndpoint)
      : _baseUrl = 'https://elixirline-api.com/$resourceEndpoint';

  Future<List<dynamic>> getStagesByWineBatch(String wineBatchId) {
    return http
        .get(Uri.parse("$_baseUrl/$wineBatchId"))
        .then((response) {
          if (response.statusCode == HttpStatus.ok) {
            final List<dynamic> maps = jsonDecode(response.body);
            return maps;
          } else {
            throw HttpException("Error fetching stages: ${response.statusCode}");
          }
        })
        .catchError((error) {
          throw Exception("Unexpected error in getStagesByWineBatch: $error");
        });
  }
  
 


}