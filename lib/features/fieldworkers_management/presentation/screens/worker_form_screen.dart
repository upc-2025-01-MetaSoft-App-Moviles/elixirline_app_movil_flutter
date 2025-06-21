import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class WorkerFormScreen extends StatefulWidget {
  final Map<String, dynamic>? worker;

  const WorkerFormScreen({Key? key, this.worker}) : super(key: key);

  @override
  State<WorkerFormScreen> createState() => _WorkerFormScreenState();
}

class _WorkerFormScreenState extends State<WorkerFormScreen> {
  DateTime? entryDate;
  DateTime? contractEndDate;
  String? imagePath;
  late TextEditingController nameController;
  late TextEditingController roleController;
  late TextEditingController dniController;
  bool isActive = true;

  @override
  void initState() {
    entryDate = widget.worker?['entryDate'] != null
        ? DateTime.tryParse(widget.worker!['entryDate'])
        : null;

    contractEndDate = widget.worker?['contractEndDate'] != null
        ? DateTime.tryParse(widget.worker!['contractEndDate'])
        : null;

    imagePath = widget.worker?['imagePath'];

    super.initState();
    nameController = TextEditingController(text: widget.worker?['name'] ?? '');
    roleController = TextEditingController(text: widget.worker?['role'] ?? '');
    dniController = TextEditingController(text: widget.worker?['dni'] ?? '');
    isActive = widget.worker?['isActive'] ?? true;
  }

  @override
  void dispose() {
    nameController.dispose();
    roleController.dispose();
    dniController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imagePath = picked.path;
      });
    }
  }

  void saveWorker() {
    final updatedWorker = {
      'name': nameController.text,
      'role': roleController.text,
      'dni': dniController.text,
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
              controller: roleController,
              decoration: const InputDecoration(labelText: 'Rol'),
            ),
            TextField(
              controller: dniController,
              decoration: const InputDecoration(labelText: 'DNI'),
            ),
            const SizedBox(height: 10),

            // Fecha de ingreso
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
                    DateTime now = DateTime.now();
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: entryDate ?? now,
                      firstDate: DateTime(now.year - 10),
                      lastDate: DateTime(now.year + 1),
                    );
                    if (picked != null) {
                      setState(() {
                        entryDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),

            // Fecha de contrato fin
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
                    DateTime now = DateTime.now();
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: contractEndDate ?? now,
                      firstDate: now,
                      lastDate: DateTime(now.year + 5),
                    );
                    if (picked != null) {
                      setState(() {
                        contractEndDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),

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
