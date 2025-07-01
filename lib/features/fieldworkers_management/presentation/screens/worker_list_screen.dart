import 'dart:io';
import 'package:flutter/material.dart';
import 'worker_form_screen.dart';

class WorkerListScreen extends StatefulWidget {
  const WorkerListScreen({super.key});

  @override
  State<WorkerListScreen> createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  final List<String> roleOptions = [
    'Podador', 'Cosechador', 'Supervisor', 'Recolector', 'Fumigador',
    'Encargado de riego', 'Jornalero', 'Clasificador de uvas',
    'Conductor de tractor', 'Técnico agrícola', 'Capataz de campo',
    'Encargado de bodega', 'Control de calidad',
  ];

  final List<String> zonaOptions = [
    'Zona Norte', 'Zona Sur', 'Zona Este', 'Zona Oeste', 'Lote 1', 'Lote 2',
    'Viñedo Principal', 'Zona de Riego', 'Zona de Empaque', 'Zona Experimental',
  ];

  final List<String> nivelesExperiencia = [
    'Básico', 'Intermedio', 'Avanzado', 'Experto',
  ];

  final List<Map<String, dynamic>> allWorkers = [
    {
      'name': 'Juan Pérez', 'dni': '12345678', 'role': 'Podador', 'isActive': true,
      'entryDate': '2023-03-01T00:00:00', 'contractEndDate': '2025-06-26T00:00:00',
      'imagePath': null, 'contractType': 'Temporal', 'zonaAsignada': 'Parcela A',
      'nivelExperiencia': 'Intermedio',
    },
    {
      'name': 'Ana Torres', 'dni': '87654321', 'role': 'Cosechador', 'isActive': false,
      'entryDate': '2024-01-15T00:00:00', 'contractEndDate': '2025-06-23T00:00:00',
      'imagePath': null, 'contractType': 'Por obra', 'zonaAsignada': 'Zona Sur',
      'nivelExperiencia': 'Avanzado',
    },
    {
      'name': 'Carlos Huamán', 'dni': '45671234', 'role': 'Supervisor', 'isActive': true,
      'entryDate': '2022-05-20T00:00:00', 'contractEndDate': '2025-09-19T00:00:00',
      'imagePath': null, 'contractType': 'Permanente', 'zonaAsignada': 'Viñedo Central',
      'nivelExperiencia': 'Experto',
    },
    {
      'name': 'Lucía Ramírez', 'dni': '22334455', 'role': 'Recolectora', 'isActive': true,
      'entryDate': '2023-09-10T00:00:00', 'contractEndDate': '2025-06-22T00:00:00',
      'imagePath': null, 'contractType': 'Temporal', 'zonaAsignada': 'Parcela B',
      'nivelExperiencia': 'Básico',
    },
    {
      'name': 'Andrés Quispe', 'dni': '99887766', 'role': 'Fumigador', 'isActive': false,
      'entryDate': '2021-12-05T00:00:00', 'contractEndDate': '2025-07-21T00:00:00',
      'imagePath': null, 'contractType': 'Por obra', 'zonaAsignada': 'Sector Norte',
      'nivelExperiencia': 'Intermedio',
    },
    {
      'name': 'María Ccahuana', 'dni': '33445566', 'role': 'Encargada de riego', 'isActive': true,
      'entryDate': '2022-08-01T00:00:00', 'contractEndDate': '2025-06-24T00:00:00',
      'imagePath': null, 'contractType': 'Permanente', 'zonaAsignada': 'Zona Este',
      'nivelExperiencia': 'Avanzado',
    },
    {
      'name': 'Pedro Gutiérrez', 'dni': '11223344', 'role': 'Jornalero', 'isActive': true,
      'entryDate': '2023-11-15T00:00:00', 'contractEndDate': '2025-12-18T00:00:00',
      'imagePath': null, 'contractType': 'Temporal', 'zonaAsignada': 'Zona Sur',
      'nivelExperiencia': 'Básico',
    },
  ];

  List<Map<String, dynamic>> filteredWorkers = [];
  String searchQuery = '';
  String? selectedRole;
  String? selectedStatus;

  List<String> get availableRoles =>
      allWorkers.map((w) => w['role'] as String).toSet().toList()..sort();

  @override
  void initState() {
    super.initState();
    filteredWorkers = List.from(allWorkers);
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      _applyFilters();
    });
  }

  void _applyFilters() {
    filteredWorkers = allWorkers.where((worker) {
      final matchesSearch =
          worker['name'].toLowerCase().contains(searchQuery) ||
          worker['dni'].contains(searchQuery);
      final matchesStatus = selectedStatus == null
          ? true
          : selectedStatus == 'Activo'
              ? worker['isActive']
              : !worker['isActive'];
      final matchesRole =
          selectedRole == null || worker['role'] == selectedRole;
      return matchesSearch && matchesStatus && matchesRole;
    }).toList();
  }

  void _confirmDelete(Map<String, dynamic> worker) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar trabajador?'),
        content: Text('¿Estás seguro de eliminar a ${worker['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                allWorkers.remove(worker);
                _applyFilters();
              });
              Navigator.pop(context);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Trabajador eliminado')),
                );
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _calcularAntiguedad(String? fechaIngresoStr) {
    if (fechaIngresoStr == null) return '';
    final ingreso = DateTime.tryParse(fechaIngresoStr);
    if (ingreso == null) return '';
    final hoy = DateTime.now();
    int anios = hoy.year - ingreso.year;
    int meses = hoy.month - ingreso.month;
    if (meses < 0) {
      anios--;
      meses += 12;
    }
    return "$anios año(s), $meses mes(es)";
  }

  void _sortWorkers(String sortBy) {
    setState(() {
      if (sortBy == 'name') {
        allWorkers.sort((a, b) => a['name'].compareTo(b['name']));
      } else if (sortBy == 'date') {
        allWorkers.sort((a, b) {
          final dateA = DateTime.tryParse(a['entryDate']);
          final dateB = DateTime.tryParse(b['entryDate']);
          return (dateB ?? DateTime(0)).compareTo(dateA ?? DateTime(0));
        });
      }
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (var worker in filteredWorkers) {
      final role = worker['role'] ?? 'Otros';
      grouped.putIfAbsent(role, () => []).add(worker);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Trabajadores'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: _sortWorkers,
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'name', child: Text('Ordenar por nombre')),
              PopupMenuItem(
                value: 'date',
                child: Text('Ordenar por fecha de ingreso'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newWorker = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WorkerFormScreen()),
          );

          if (!context.mounted) return;

          if (newWorker != null) {
            setState(() {
              allWorkers.add(newWorker);
              _applyFilters();
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Trabajador agregado')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  onChanged: updateSearch,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o DNI...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedStatus,
                        decoration: const InputDecoration(labelText: 'Estado'),
                        items: const [
                          DropdownMenuItem(value: 'Activo', child: Text('Activo')),
                          DropdownMenuItem(value: 'Inactivo', child: Text('Inactivo')),
                        ],
                        onChanged: (val) {
                          setState(() {
                            selectedStatus = val;
                            _applyFilters();
                          });
                        },
                        isExpanded: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedRole,
                        decoration: const InputDecoration(labelText: 'Rol'),
                        items: availableRoles
                            .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedRole = val;
                            _applyFilters();
                          });
                        },
                        isExpanded: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      tooltip: 'Limpiar filtros',
                      onPressed: () {
                        setState(() {
                          selectedStatus = null;
                          selectedRole = null;
                          searchQuery = '';
                          filteredWorkers = List.from(allWorkers);
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: grouped.entries.map((entry) {
                final role = entry.key;
                final workers = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.grey[200],
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Text(
                        role,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...workers.map((worker) {
                      final imagePath = worker['imagePath'];
                      final contractEnd = DateTime.tryParse(
                        worker['contractEndDate'] ?? '',
                      );
                      final isExpiringSoon =
                          contractEnd != null &&
                          contractEnd.difference(DateTime.now()).inDays <= 30;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              (imagePath != null && imagePath != '')
                                  ? FileImage(File(imagePath))
                                  : null,
                          child: (imagePath == null || imagePath == '')
                              ? const Icon(Icons.person, color: Colors.white70)
                              : null,
                        ),
                        title: Text(worker['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('DNI: ${worker['dni']}'),
                            if (worker['entryDate'] != null)
                              Text(
                                'Ingreso: ${worker['entryDate'].split("T")[0]}',
                              ),
                            if (worker['zonaAsignada'] != null)
                              Text('Zona: ${worker['zonaAsignada']}'),
                            if (worker['contractEndDate'] != null)
                              Text(
                                'Contrato hasta: ${worker['contractEndDate'].split("T")[0]}',
                                style: TextStyle(
                                  color: isExpiringSoon ? Colors.red : null,
                                ),
                              ),
                            if (worker['contractType'] != null)
                              Text(
                                'Tipo de contrato: ${worker['contractType']}',
                              ),
                          ],
                        ),
                        trailing: Wrap(
                          spacing: 8.0,
                          direction: Axis.horizontal,
                          children: [
                            Chip(
                              label: Text(
                                worker['isActive'] ? 'Activo' : 'Inactivo',
                              ),
                              backgroundColor: worker['isActive']
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(worker),
                            ),
                          ],
                        ),
                        onTap: () async {
                          final validatedWorker = Map<String, dynamic>.from(worker);
                          if (!roleOptions.contains(validatedWorker['role'])) {
                            validatedWorker['role'] = null;
                          }
                          if (!zonaOptions.contains(validatedWorker['zonaAsignada'])) {
                            validatedWorker['zonaAsignada'] = null;
                          }
                          if (!nivelesExperiencia.contains(validatedWorker['nivelExperiencia'])) {
                            validatedWorker['nivelExperiencia'] = null;
                          }

                          final updatedWorker = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WorkerFormScreen(worker: validatedWorker),
                            ),
                          );

                          if (!context.mounted) return;

                          if (updatedWorker != null) {
                            setState(() {
                              final index = allWorkers.indexOf(worker);
                              allWorkers[index] = updatedWorker;
                              _applyFilters();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Trabajador actualizado'),
                              ),
                            );
                          }
                        },
                      );
                    }),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
