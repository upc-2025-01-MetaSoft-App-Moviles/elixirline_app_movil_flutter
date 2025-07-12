import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:provider/provider.dart';
import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/domain/models/worker.dart';
// import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/presentation/viewmodels/worker_viewmodel.dart';

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
  List<String> documentPaths = [];
  String? selectedRole;
  String? selectedContractType;
  String? selectedZona;
  String? selectedNivel;
  late TextEditingController nameController;
  late TextEditingController dniController;
  bool isActive = true;

  final List<String> roleOptions = [
    'Podador(a)',
    'Cosechador(a)',
    'Supervisor(a)',
    'Recolector(a)',
    'Fumigador(a)',
    'Encargado(a) de riego',
    'Jornalero(a)',
    'Clasificador(a) de uvas',
    'Conductor(a) de tractor',
    'Técnico(a) agrícola',
    'Capataz de campo',
    'Encargado(a) de bodega',
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
    'Parcela A',
    'Parcela B',
    'Viñedo Central',
    'Sector Norte',
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
    documentPaths = List<String>.from(widget.worker?['documentPaths'] ?? []);
    nameController = TextEditingController(
      text: widget.worker?['fullName'] ?? '',
    );
    dniController = TextEditingController(text: widget.worker?['id'] ?? '');
    selectedRole = widget.worker?['role'];
    selectedContractType = widget.worker?['contractType'];
    selectedZona = widget.worker?['zonaAsignada'];
    selectedNivel = widget.worker?['nivelExperiencia'];
    isActive = widget.worker?['isActive'] ?? true;
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

  Future<void> pickDocuments() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      final appDir = await getApplicationDocumentsDirectory();

      for (final file in result.files) {
        if (file.path != null) {
          final newFile = File(file.path!);
          final fileName = file.name;

          // Copiar el archivo a una ruta persistente
          final savedPath = '${appDir.path}/$fileName';
          await newFile.copy(savedPath);

          setState(() {
            documentPaths.add(savedPath);
          });
        }
      }
    }
  }

  void removeDocument(int index) {
    setState(() {
      documentPaths.removeAt(index);
    });
  }

  void saveWorker() {
    final newWorker = Worker(
      id: dniController.text,
      fullName: nameController.text,
      role: selectedRole ?? '',
      isActive: isActive,
      entryDate: entryDate,
      contractEndDate: contractEndDate,
      imagePath: imagePath,
      contractType: selectedContractType,
      zonaAsignada: selectedZona,
      nivelExperiencia: selectedNivel,
      documentPaths: documentPaths,
    );
    if (documentPaths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se ha subido ningún documento')),
      );
      return;
    }

    print(" 📦 Documentos guardados: ${newWorker.documentPaths}"); // 🔍
    Navigator.pop(context, newWorker);
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
                backgroundImage: imagePath != null
                    ? FileImage(File(imagePath!))
                    : null,
                child: imagePath == null
                    ? const Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: Colors.white70,
                      )
                    : null,
              ),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre completo'),
            ),
            TextField(
              controller: dniController,
              decoration: const InputDecoration(labelText: 'DNI'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: const InputDecoration(labelText: 'Rol'),
              items: roleOptions
                  .map(
                    (role) => DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => selectedRole = value),
            ),
            DropdownButtonFormField<String>(
              value: selectedContractType,
              decoration: const InputDecoration(labelText: 'Tipo de contrato'),
              items: contractTypes
                  .map(
                    (type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    ),
                  )
                  .toList(),
              onChanged: (value) =>
                  setState(() => selectedContractType = value),
            ),
            DropdownButtonFormField<String>(
              value: selectedZona,
              decoration: const InputDecoration(
                labelText: 'Zona o campo asignado',
              ),
              items: zonaOptions
                  .map(
                    (zona) => DropdownMenuItem<String>(
                      value: zona,
                      child: Text(zona),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => selectedZona = value),
            ),
            DropdownButtonFormField<String>(
              value: selectedNivel,
              decoration: const InputDecoration(
                labelText: 'Nivel de experiencia',
              ),
              items: nivelesExperiencia
                  .map(
                    (nivel) => DropdownMenuItem<String>(
                      value: nivel,
                      child: Text(nivel),
                    ),
                  )
                  .toList(),
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
            const SizedBox(height: 12),

            // 🆕 Documentos subidos
            ElevatedButton.icon(
              onPressed: pickDocuments,
              icon: const Icon(Icons.upload_file),
              label: Text('Subir documentos (${documentPaths.length})'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            if (documentPaths.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text('📄 Documentos cargados:'),
              ...documentPaths.map((path) {
                final fileName = path.split('/').last;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: Text(fileName, overflow: TextOverflow.ellipsis),
                  leading: const Icon(Icons.insert_drive_file),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.open_in_new, color: Colors.blue),
                        tooltip: 'Abrir documento',
                        onPressed: () async {
                          final file = File(path);
                          if (await file.exists()) {
                            final result = await OpenFile.open(file.path);
                            print(
                              "🔍 Resultado de apertura: ${result.message}",
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Archivo no encontrado'),
                              ),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Eliminar',
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('¿Eliminar documento?'),
                              content: Text('¿Deseas eliminar "$fileName"?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    'Eliminar',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            final fileToDelete = File(path);
try {
  if (await fileToDelete.exists()) {
    await fileToDelete.delete();
  }
} catch (e) {
  print("⚠️ Error eliminando archivo: $e");
}


                            setState(() => documentPaths.remove(path));

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Documento eliminado'),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],

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

  // ignore: unused_element
  String _calcularAntiguedad(DateTime? fechaIngreso) {
    if (fechaIngreso == null) return '';
    final hoy = DateTime.now();
    int anios = hoy.year - fechaIngreso.year;
    int meses = hoy.month - fechaIngreso.month;
    if (meses < 0) {
      anios--;
      meses += 12;
    }
    return "$anios año(s), $meses mes(es)";
  }
}
