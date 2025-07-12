import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:elixirline_app_movil_flutter/features/fieldlog/data/field_log_entry_dto.dart';
import 'package:elixirline_app_movil_flutter/features/fieldlog/domain/field_log_entry.dart';

class FieldLogEntryService {
  final String _backendUrl = 'https://elixirline.azurewebsites.net/api/v1/field-log-entry';
  final String _cloudinaryUploadUrl = 'https://api.cloudinary.com/v1_1/dum0eajyn/image/upload';
final String _cloudinaryUploadPreset = 'elixir';

  Future<List<FieldLogEntry>> fetchAll() async {
    final response = await http.get(Uri.parse(_backendUrl));

    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => FieldLogEntryDto.fromJson(e).toDomain()).toList();
    } else {
      throw Exception('Error al obtener bitácoras');
    }
  }

  Future<void> create(FieldLogEntry entry) async {
    final dto = FieldLogEntryDto.fromDomain(entry);
    final response = await http.post(
      Uri.parse(_backendUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear entrada');
    }
  }

  Future<String> uploadImageToCloudinary(File imageFile) async {
    final imageStream = http.ByteStream(imageFile.openRead());
    final length = await imageFile.length();

    final multipartFile = http.MultipartFile(
      'file',
      imageStream,
      length,
      filename: imageFile.path.split('/').last,
      contentType: MediaType('image', 'jpeg'), // cambia a 'png' si corresponde
    );

    final request = http.MultipartRequest('POST', Uri.parse(_cloudinaryUploadUrl));
    request.fields['upload_preset'] = _cloudinaryUploadPreset;
    request.files.add(multipartFile);

    print("Subiendo imagen: ${imageFile.path}");
    print("Tamaño: $length bytes");

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final json = jsonDecode(resBody);
      print("Imagen subida con éxito: ${json['secure_url']}");
      return json['secure_url'];
    } else {
      print("Cloudinary error: $resBody");
      throw Exception('Cloudinary respondió con error: $resBody');
    }
  }
}
