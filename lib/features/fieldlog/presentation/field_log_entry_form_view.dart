import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:elixirline_app_movil_flutter/features/fieldlog/domain/field_log_entry.dart';
import 'package:elixirline_app_movil_flutter/features/fieldlog/data/field_log_entry_service.dart';

class FieldLogEntryFormView extends StatefulWidget {
  const FieldLogEntryFormView({super.key});

  @override
  State<FieldLogEntryFormView> createState() => _FieldLogEntryFormViewState();
}

class _FieldLogEntryFormViewState extends State<FieldLogEntryFormView> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  final List<File> _selectedImages = [];
  final List<String> _entryTypes = ['Observation', 'Incident', 'CompletedTask'];
  String _selectedEntryType = '';
  bool _isLoading = false;

  final _uuid = const Uuid();
  late final String _authorId;
  late final String _parcelId;
  late final String _relatedTaskId;

  @override
  void initState() {
    super.initState();
    _authorId = _uuid.v4();
    _parcelId = _uuid.v4();
    _relatedTaskId = _uuid.v4();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages.clear();
        _selectedImages.addAll(pickedFiles.map((x) => File(x.path)));
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedEntryType.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final service = FieldLogEntryService();
      final List<String> uploadedUrls = [];

      for (File image in _selectedImages) {
        final url = await service.uploadImageToCloudinary(image);
        uploadedUrls.add(url);
      }

      final entry = FieldLogEntry(
        entryId: '',
        authorId: _authorId,
        parcelId: _parcelId,
        description: _descriptionController.text.trim(),
        entryType: _selectedEntryType,
        timestamp: DateTime.now(),
        photoUrls: uploadedUrls,
        relatedTaskId: _relatedTaskId,
      );

      await service.create(entry);

      if (mounted) {
        Navigator.pop(context, true); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bitácora registrada exitosamente')),
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Bitácora')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tipo de Entrada'),
                value: _selectedEntryType.isNotEmpty ? _selectedEntryType : null,
                items: _entryTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedEntryType = value ?? '');
                },
                validator: (v) => v == null || v.isEmpty ? 'Selecciona un tipo' : null,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedImages
                    .map((f) => Image.file(f, width: 100, height: 100, fit: BoxFit.cover))
                    .toList(),
              ),
              TextButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Seleccionar Imágenes'),
                onPressed: _pickImages,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Registrar Bitácora'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
