import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/data/datasources/wine_batch_service.dart';
import 'package:elixirline_app_movil_flutter/features/winemaking-process/domain/entities/wine_batch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CreateAndEditWineBatchPage extends StatefulWidget {
  final WineBatch? initialData;

  const CreateAndEditWineBatchPage({super.key, this.initialData});

  @override
  State<CreateAndEditWineBatchPage> createState() =>
      _CreateOrEditWineBatchPageState();
}

class _CreateOrEditWineBatchPageState extends State<CreateAndEditWineBatchPage> {
  
  final wineBatchService = WineBatchService('/wine-batch');
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _internalCodeController;
  late final TextEditingController _vineyardController;
  late final TextEditingController _grapeVarietyController;
  late final TextEditingController _createdByController;
  late final TextEditingController _campaignController;



  @override
  void initState() {
    super.initState();
    _internalCodeController = TextEditingController(
      text: widget.initialData?.internalCode ?? '',
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
    _campaignController = TextEditingController(
      text: widget.initialData?.campaign ?? '',
    );
    
  }

  @override
  void dispose() {
    _internalCodeController.dispose();
    _vineyardController.dispose();
    _grapeVarietyController.dispose();
    _createdByController.dispose();
    _campaignController.dispose();
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
          final newBatch = await wineBatchService.createWineBatch(data);
          Navigator.pop(context, newBatch);
        } else {
          final id = widget.initialData!.id;
          if (id.isNotEmpty) {
            final updatedBatch = await wineBatchService.updateWineBatch(id, data);
            Navigator.pop(context, updatedBatch);
          } else {
            throw Exception('ID inválido para actualizar');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error al guardar el lote: $e');
        }
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
              isEditing ? 'Editar Lote de Vino' : 'Crear Lote de Vino',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card con información
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 6,
                    shadowColor: ColorPalette.vinoTinto.withOpacity(0.2),
                    color: Colors.grey.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: ColorPalette.vinoTinto.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.local_drink,
                                  color: ColorPalette.vinoTinto,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isEditing ? 'Modificar Lote de Vino' : 'Nuevo Lote de Vino',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: ColorPalette.vinoTinto,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isEditing 
                                        ? 'Actualiza la información del lote existente'
                                        : 'Completa la información para crear un nuevo lote',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Campos de formulario organizados en cards
                  _buildFormSection(
                    'Información Básica',
                    Icons.info_outline,
                    Colors.blue,
                    [
                      _buildTextField('Código Interno', _internalCodeController, Icons.qr_code),
                      _buildTextField('Campaña', _campaignController, Icons.calendar_today),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildFormSection(
                    'Origen y Variedad',
                    Icons.nature,
                    Colors.green,
                    [
                      _buildTextField('Viñedo', _vineyardController, Icons.landscape),
                      _buildTextField('Variedad de uva', _grapeVarietyController, Icons.eco),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildFormSection(
                    'Información del Usuario',
                    Icons.person,
                    Colors.orange,
                    [
                      _buildTextField('Creado por', _createdByController, Icons.account_circle),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Botón de acción mejorado
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          ColorPalette.vinoTinto,
                          ColorPalette.vinoTinto.withOpacity(0.8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorPalette.vinoTinto.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isEditing ? Icons.update : Icons.add_circle,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            isEditing ? 'Actualizar Lote' : 'Crear Lote',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection(String title, IconData icon, Color color, List<Widget> fields) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: color.withOpacity(0.2),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...fields,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, [IconData? icon]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon, color: ColorPalette.vinoTinto) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: ColorPalette.vinoTinto, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.all(16),
        ),
        validator: (value) =>
            value == null || value.trim().isEmpty ? 'Campo requerido' : null,
      ),
    );
  }


}






