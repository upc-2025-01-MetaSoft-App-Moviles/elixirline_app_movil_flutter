import 'dart:io';
import 'package:flutter/material.dart';
import 'worker_form_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:open_file/open_file.dart';
import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/presentation/screens/worker_evaluation_screen.dart';
import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/domain/models/worker.dart';
import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/data/repositories/worker_repository.dart';
import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/domain/models/worker_task.dart';
import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/presentation/viewmodels/worker_task_viewmodel.dart';
import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/presentation/screens/worker_attendance_screen.dart';

import 'package:elixirline_app_movil_flutter/features/fieldworkers_management/presentation/screens/worker_task_history_screen.dart';

// ... (imports se mantienen igual)

class WorkerListScreen extends StatefulWidget {
  const WorkerListScreen({super.key});

  @override
  State<WorkerListScreen> createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  final mockTasks = [
    WorkerTask(
      id: const Uuid().v4(),
      title: 'Podado de vides',
      description: 'Lote A - Sur',
      date: DateTime(2024, 5, 10),
      status: 'Completada',
    ),
    WorkerTask(
      id: const Uuid().v4(),
      title: 'Aplicación de pesticida',
      description: 'Zona Norte',
      date: DateTime(2024, 6, 3),
      status: 'En progreso',
    ),
    WorkerTask(
      id: const Uuid().v4(),
      title: 'Cosecha',
      description: 'Parcela 2',
      date: DateTime(2024, 6, 28),
      status: 'Pendiente',
    ),
  ];

  final WorkerRepository _repository = WorkerRepository();

  List<Worker> allWorkers = [];
  List<Worker> filteredWorkers = [];
  String searchQuery = '';
  String? selectedRole;
  String? selectedStatus;

  List<String> get availableRoles =>
      allWorkers.map((w) => w.role).toSet().toList()..sort();

  @override
  void initState() {
    super.initState();
    _loadWorkers();
  }

  Future<void> _loadWorkers() async {
    final workers = await _repository.loadWorkers();
    if (!mounted) return;
    setState(() {
      allWorkers = workers;
      _applyFilters();
    });
  }

  Future<void> _saveWorkers() async {
    await _repository.saveWorkers(allWorkers);
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      filteredWorkers = allWorkers.where((worker) {
        final matchesSearch =
            worker.fullName.toLowerCase().contains(searchQuery) ||
            worker.id.contains(searchQuery);
        final matchesStatus = selectedStatus == null
            ? true
            : selectedStatus == 'Activo'
            ? worker.isActive
            : !worker.isActive;
        final matchesRole = selectedRole == null || worker.role == selectedRole;
        return matchesSearch && matchesStatus && matchesRole;
      }).toList();
    });
  }

  void _confirmDelete(Worker worker) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar trabajador?'),
        content: Text('¿Estás seguro de eliminar a ${worker.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (!mounted) return;
    if (confirm == true) {
      setState(() {
        allWorkers.removeWhere((w) => w.id == worker.id);
        _applyFilters();
      });
      await _saveWorkers();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Trabajador eliminado')));
    }
  }

  void _sortWorkers(String sortBy) {
    setState(() {
      if (sortBy == 'name') {
        allWorkers.sort((a, b) => a.fullName.compareTo(b.fullName));
      } else if (sortBy == 'date') {
        allWorkers.sort((a, b) {
          return (b.entryDate ?? DateTime(0)).compareTo(
            a.entryDate ?? DateTime(0),
          );
        });
      }
      _applyFilters();
    });
  }

  Color _getContractColor(DateTime? endDate) {
    if (endDate == null) return Colors.black;
    final daysLeft = endDate.difference(DateTime.now()).inDays;
    if (daysLeft <= 30) return Colors.red;
    if (daysLeft <= 60) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<Worker>>{};
    for (var worker in filteredWorkers) {
      final role = worker.role.isNotEmpty ? worker.role : 'Otros';
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

          if (!mounted) return;

          if (newWorker != null && newWorker is Worker) {
            setState(() {
              allWorkers.add(newWorker);
              _applyFilters();
            });
            await _saveWorkers();
            if (!mounted) return;
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
                          DropdownMenuItem(
                            value: 'Activo',
                            child: Text('Activo'),
                          ),
                          DropdownMenuItem(
                            value: 'Inactivo',
                            child: Text('Inactivo'),
                          ),
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
                            .map(
                              (r) => DropdownMenuItem(value: r, child: Text(r)),
                            )
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
                    ),
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
                      final contractEnd = worker.contractEndDate;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: worker.imagePath != null
                              ? FileImage(File(worker.imagePath!))
                              : null,
                          child: worker.imagePath == null
                              ? const Icon(Icons.person, color: Colors.white70)
                              : null,
                        ),
                        title: Text(worker.fullName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('DNI: ${worker.id}'),
                            if (worker.entryDate != null)
                              Text(
                                'Ingreso: ${worker.entryDate!.toIso8601String().split("T")[0]}',
                              ),
                            if (worker.zonaAsignada != null)
                              Text('Zona: ${worker.zonaAsignada}'),
                            if (worker.contractEndDate != null)
                              Text(
                                'Contrato hasta: ${worker.contractEndDate!.toIso8601String().split("T")[0]}',
                                style: TextStyle(
                                  color: _getContractColor(contractEnd),
                                ),
                              ),
                            if (worker.contractType != null)
                              Text('Tipo de contrato: ${worker.contractType}'),
                            Text(
                              'Estado: ${worker.isActive ? 'Activo' : 'Inactivo'}',
                              style: TextStyle(
                                color: worker.isActive
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (worker.documentPaths.isNotEmpty)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.picture_as_pdf,
                                    size: 18,
                                    color: Colors.purple,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${worker.documentPaths.length} doc(s)',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.folder_open_rounded,
                                      size: 20,
                                      color: Colors.indigo,
                                    ),
                                    tooltip: 'Ver documentos',
                                    onPressed: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text(
                                            '📁 Documentos del trabajador',
                                          ),
                                          content: SizedBox(
                                            width: double.maxFinite,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  worker.documentPaths.length,
                                              itemBuilder: (context, index) {
                                                final docPath =
                                                    worker.documentPaths[index];
                                                final fileName = docPath
                                                    .split('/')
                                                    .last;
                                                return ListTile(
                                                  leading: const Icon(
                                                    Icons.picture_as_pdf,
                                                  ),
                                                  title: Text(
                                                    fileName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  onTap: () async {
                                                    final file = File(docPath);
                                                    if (await file.exists()) {
                                                      await OpenFile.open(
                                                        file.path,
                                                      );
                                                    } else {
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'Archivo no encontrado: $fileName',
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cerrar'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
  icon: const Icon(Icons.add_circle_outline),
  onSelected: (value) {
    switch (value) {
      case 'asistencia':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkerAttendanceScreen(
              workerId: worker.id,
              workerName: worker.fullName,
            ),
          ),
        );
        break;
      case 'tareas':
        final viewModel = Provider.of<WorkerTaskViewModel>(
          context,
          listen: false,
        );
        viewModel.loadTasksForWorker(worker.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkerTaskHistoryScreen(worker: worker),
          ),
        );
        break;
      case 'evaluaciones':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkerEvaluationScreen(worker: worker),
          ),
        );
        break;
      case 'eliminar':
        _confirmDelete(worker);
        break;
    }
  },
  itemBuilder: (context) => [
    const PopupMenuItem(
      value: 'asistencia',
      child: ListTile(
        leading: Icon(Icons.access_time),
        title: Text('Asistencia'),
      ),
    ),
    const PopupMenuItem(
      value: 'tareas',
      child: ListTile(
        leading: Icon(Icons.history),
        title: Text('Historial de tareas'),
      ),
    ),
    const PopupMenuItem(
      value: 'evaluaciones',
      child: ListTile(
        leading: Icon(Icons.bar_chart_rounded, color: Colors.indigo),
        title: Text('Evaluaciones'),
      ),
    ),
    const PopupMenuItem(
      value: 'eliminar',
      child: ListTile(
        leading: Icon(Icons.delete, color: Colors.red),
        title: Text('Eliminar'),
      ),
    ),
  ],
),

                        onTap: () async {
                          final updatedWorker = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  WorkerFormScreen(worker: worker.toJson()),
                            ),
                          );
if (updatedWorker != null && updatedWorker is Worker) {
  print("📦 DOCUMENTOS RECIBIDOS EN LISTSCREEN: ${updatedWorker.documentPaths}");

  setState(() {
    final index = allWorkers.indexWhere((w) => w.id == updatedWorker.id);
    if (index != -1) {
      allWorkers[index] = updatedWorker;
    }
    _applyFilters();
  });

  await _saveWorkers();

  // Mostrar documentos en diálogo
  if (updatedWorker.documentPaths.isNotEmpty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📄 Documentos del trabajador'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: updatedWorker.documentPaths.map((path) {
              final fileName = path.split('/').last;
              return ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text(fileName, overflow: TextOverflow.ellipsis),
                trailing: IconButton(
                  icon: const Icon(Icons.open_in_new, color: Colors.blue),
                  onPressed: () async {
                    final file = File(path);
                    if (await file.exists()) {
                      await OpenFile.open(file.path);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Archivo no encontrado'),
                        ),
                      );
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

                          if (!mounted) return;

                          if (updatedWorker != null &&
                              updatedWorker is Worker) {
                            print(
                              "📦 DOCUMENTOS RECIBIDOS EN LISTSCREEN: ${updatedWorker.documentPaths}",
                            );

                            setState(() {
                              final index = allWorkers.indexWhere(
                                (w) => w.id == updatedWorker.id,
                              );
                              if (index != -1) {
                                allWorkers[index] = updatedWorker;
                              }
                              _applyFilters();
                            });

                            await _saveWorkers();

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
