import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class WorkerFormScreen extends StatefulWidget {
  final Map<String, dynamic>? worker;

  const WorkerFormScreen({super.key, this.worker});

  @override
  State<WorkerFormScreen> createState() => _WorkerFormScreenState();
}

class _WorkerFormScreenState extends State<WorkerFormScreen> {
  DateTime? entryDate;
  DateTime? contractEndDate;
  String? imagePath;
  String? selectedRole;
  String? selectedContractType;
  String? selectedZona;
  String? selectedNivel;
  late TextEditingController nameController;
  late TextEditingController dniController;
  bool isActive = true;

  final List<String> roleOptions = [
    'Podador',
    'Cosechador',
    'Supervisor',
    'Recolector',
    'Fumigador',
    'Encargado de riego',
    'Jornalero',
    'Clasificador de uvas',
    'Conductor de tractor',
    'Técnico agrícola',
    'Capataz de campo',
    'Encargado de bodega',
    'Control de calidad',
  ];

  final List<String> contractTypes = [
    'Permanente',
    'Temporal',
    'Por obra',
    'Practicante',
  ];

  final List<String> zonaOptions = [
    'Zona Norte',
    'Zona Sur',
    'Zona Este',
    'Zona Oeste',
    'Lote 1',
    'Lote 2',
    'Viñedo Principal',
    'Zona de Riego',
    'Zona de Empaque',
    'Zona Experimental',
  ];

  final List<String> nivelesExperiencia = [
    'Básico',
    'Intermedio',
    'Avanzado',
    'Experto',
  ];

  @override
  void initState() {
    super.initState();
    entryDate = widget.worker?['entryDate'] != null
        ? DateTime.tryParse(widget.worker!['entryDate'])
        : null;

    contractEndDate = widget.worker?['contractEndDate'] != null
        ? DateTime.tryParse(widget.worker!['contractEndDate'])
        : null;

    imagePath = widget.worker?['imagePath'];

    nameController = TextEditingController(text: widget.worker?['name'] ?? '');
    dniController = TextEditingController(text: widget.worker?['dni'] ?? '');
    selectedRole = widget.worker?['role'];
    selectedContractType = widget.worker?['contractType'];
    selectedZona = widget.worker?['zonaAsignada'];
    selectedNivel = widget.worker?['nivelExperiencia'];
    isActive = widget.worker?['isActive'] ?? true;

    // 🛠️ Asegurar que los valores seleccionados existan en sus listas
    if (selectedZona != null && !zonaOptions.contains(selectedZona)) {
      zonaOptions.insert(0, selectedZona!);
    }
    if (selectedRole != null && !roleOptions.contains(selectedRole)) {
      roleOptions.insert(0, selectedRole!);
    }
    if (selectedContractType != null && !contractTypes.contains(selectedContractType)) {
      contractTypes.insert(0, selectedContractType!);
    }
    if (selectedNivel != null && !nivelesExperiencia.contains(selectedNivel)) {
      nivelesExperiencia.insert(0, selectedNivel!);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    dniController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (!mounted) return;
    if (picked != null) {
      setState(() {
        imagePath = picked.path;
      });
    }
  }

  void saveWorker() {
    final updatedWorker = {
      'name': nameController.text,
      'dni': dniController.text,
      'role': selectedRole,
      'contractType': selectedContractType,
      'zonaAsignada': selectedZona,
      'nivelExperiencia': selectedNivel,
      'isActive': isActive,
      'entryDate': entryDate?.toIso8601String(),
      'contractEndDate': contractEndDate?.toIso8601String(),
      'imagePath': imagePath,
    };
    Navigator.pop(context, updatedWorker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Trabajador')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    imagePath != null ? FileImage(File(imagePath!)) : null,
                child: imagePath == null
                    ? const Icon(Icons.camera_alt, size: 40, color: Colors.white70)
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),

            TextField(
              controller: dniController,
              decoration: const InputDecoration(labelText: 'DNI'),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: const InputDecoration(labelText: 'Rol'),
              items: roleOptions.map((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedRole = value),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: selectedContractType,
              decoration: const InputDecoration(labelText: 'Tipo de contrato'),
              items: contractTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedContractType = value),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: selectedZona,
              decoration: const InputDecoration(labelText: 'Zona o campo asignado'),
              items: zonaOptions.map((zona) {
                return DropdownMenuItem<String>(
                  value: zona,
                  child: Text(zona),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedZona = value),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: selectedNivel,
              decoration: const InputDecoration(labelText: 'Nivel de experiencia'),
              items: nivelesExperiencia.map((nivel) {
                return DropdownMenuItem<String>(
                  value: nivel,
                  child: Text(nivel),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedNivel = value),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Text(
                    entryDate != null
                        ? 'Fecha de ingreso: ${entryDate!.toLocal().toString().split(' ')[0]}'
                        : 'Seleccionar fecha de ingreso',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: entryDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (!mounted) return;
                    if (picked != null) {
                      setState(() {
                        entryDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: Text(
                    contractEndDate != null
                        ? 'Fin de contrato: ${contractEndDate!.toLocal().toString().split(' ')[0]}'
                        : 'Seleccionar fin de contrato',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.event),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: contractEndDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (!mounted) return;
                    if (picked != null) {
                      setState(() {
                        contractEndDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Activo'),
              value: isActive,
              onChanged: (val) => setState(() => isActive = val),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveWorker,
              child: const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
