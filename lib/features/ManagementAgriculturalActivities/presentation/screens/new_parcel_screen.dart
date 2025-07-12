// ignore_for_file: unused_import, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/parcel.dart';
import '../providers/parcel_provider.dart';
import '../../application/usecases/create_parcel_usecase.dart';
import '../../infrastructure/repositories_impl/parcel_repository_impl.dart';
import '../../domain/repositories/parcel_repository.dart';

class NewParcelScreen extends ConsumerStatefulWidget {
  const NewParcelScreen({super.key});

  @override
  ConsumerState<NewParcelScreen> createState() => _NewParcelScreenState();
}

class _NewParcelScreenState extends ConsumerState<NewParcelScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _yieldEstimateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String? cropType;
  String? growthStage;
  String? status;
  DateTime? receptionDate;

  final cropOptions = ['Cabernet', 'Merlot'];
  final stageOptions = ['Siembra', 'Crecimiento', 'Cosecha'];
  final statusOptions = ['Saludable', 'Enfermo'];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: receptionDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        receptionDate = picked;
      });
    }
  }

  Future<void> _saveParcel() async {
    if (_formKey.currentState!.validate()) {
      if (cropType == null || growthStage == null || status == null || receptionDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor completa todos los campos obligatorios')),
        );
        return;
      }

      final newParcel = Parcel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        cropType: cropType!,
        location: _locationController.text,
        growthStage: growthStage!,
        lastTask: '',
        yieldEstimate: _yieldEstimateController.text,
        status: status!,
      );

      final parcelRepository = ref.read(parcelRepositoryProvider);
      final createParcelUseCase = CreateParcelUseCase(parcelRepository);
      await createParcelUseCase.execute(newParcel);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lote creado con éxito')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const darkRed = Color(0xFF8B0000);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Lote'),
        backgroundColor: darkRed,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nameController, 'Nombre del lote'),
              _buildDropdown('Variedad', cropOptions, cropType, (value) => setState(() => cropType = value)),
              _buildTextField(_locationController, 'Viñedo'),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: darkRed),
                onPressed: _pickDate,
                child: Text(
                  receptionDate != null
                      ? DateFormat('dd/MM/yyyy').format(receptionDate!)
                      : 'Seleccionar fecha',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              _buildDropdown('Estado', statusOptions, status, (value) => setState(() => status = value)),
              _buildDropdown('Etapa actual', stageOptions, growthStage, (value) => setState(() => growthStage = value)),
              _buildTextField(_yieldEstimateController, 'Cantidad (hectáreas)'),
              _buildTextField(_notesController, 'Notas (opcional)', required: false),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkRed,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _saveParcel,
                child: const Text('Guardar Lote', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          fillColor: const Color(0xFFD9D9D9),
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, String? selectedValue, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          fillColor: const Color(0xFFD9D9D9),
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        value: selectedValue,
        items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Por favor selecciona una opción' : null,
      ),
    );
  }
}
