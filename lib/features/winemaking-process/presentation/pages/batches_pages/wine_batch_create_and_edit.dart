import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/datasources/wine_batch_service.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/domain/entities/wine_batch.dart';
import 'package:flutter/material.dart';

class CreateWineBatchPage extends StatefulWidget {
  final WineBatch? initialData; // null si es creación

  const CreateWineBatchPage({super.key, this.initialData});

  @override
  State<CreateWineBatchPage> createState() => _CreateOrEditWineBatchPageState();
}

class _CreateOrEditWineBatchPageState extends State<CreateWineBatchPage> {
  // Inyectamos el servicio de lotes de vino aquí si es necesario
  final wineBatchService = WineBatchService('/wine-batch');

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _internalCodeController;
  late final TextEditingController _campaignController;
  late final TextEditingController _vineyardController;
  late final TextEditingController _grapeVarietyController;
  late final TextEditingController _createdByController;

  @override
  void initState() {
    super.initState();
    _internalCodeController = TextEditingController(
      text: widget.initialData?.internalCode ?? '',
    );
    _campaignController = TextEditingController(
      text: widget.initialData?.campaign ?? '',
    );
    _vineyardController = TextEditingController(
      text: widget.initialData?.vineyard ?? '',
    );
    _grapeVarietyController = TextEditingController(
      text: widget.initialData?.grapeVariety ?? '',
    );
    _createdByController = TextEditingController(
      text: widget.initialData?.createdBy ?? '',
    );
  }

  @override
  void dispose() {
    _internalCodeController.dispose();
    _campaignController.dispose();
    _vineyardController.dispose();
    _grapeVarietyController.dispose();
    _createdByController.dispose();
    super.dispose();
  }

  void _onSave() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'internalCode': _internalCodeController.text.trim(),
        'campaign': _campaignController.text.trim(),
        'vineyard': _vineyardController.text.trim(),
        'grapeVariety': _grapeVarietyController.text.trim(),
        'createdBy': _createdByController.text.trim(),
      };

      try {
        if (widget.initialData == null) {
          // Crear lote
          final newBatch = await wineBatchService.createWineBatch(data);
          Navigator.pop(context, newBatch);
        } else {
          // Editar lote
          final id = int.tryParse(widget.initialData!.id);
          if (id != null) {
            await wineBatchService.updateWineBatch(id, data);
            Navigator.pop(context, 'updated');
          } else {
            throw Exception('ID inválido para actualizar');
          }
        }
      } catch (e) {
        print('Error al guardar el lote: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar el lote')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialData != null;

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorPalette.vinoTinto,
            foregroundColor: Colors.white,
            title: Text(
              isEditing ? 'Editar Lote' : 'Crear Lote',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildTextField('Código Interno', _internalCodeController),
                  _buildTextField('Campaña', _campaignController),
                  _buildTextField('Viñedo', _vineyardController),
                  _buildTextField('Variedad de uva', _grapeVarietyController),
                  _buildTextField('Creado por', _createdByController),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _onSave,
                    child: Text(isEditing ? 'Actualizar' : 'Crear'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.trim().isEmpty ? 'Campo requerido' : null,
      ),
    );
  }
}
