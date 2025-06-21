import 'dart:io';
import 'package:flutter/material.dart';
import 'worker_form_screen.dart';

class WorkerListScreen extends StatefulWidget {
  const WorkerListScreen({super.key});

  @override
  State<WorkerListScreen> createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  final List<Map<String, dynamic>> allWorkers = [
    {
      'name': 'Juan Pérez',
      'dni': '12345678',
      'role': 'Podador',
      'isActive': true,
      'entryDate': '2023-03-01T00:00:00',
      'contractEndDate': '2025-06-26T00:00:00',
      'imagePath': null
    },
    {
      'name': 'Ana Torres',
      'dni': '87654321',
      'role': 'Cosechador',
      'isActive': false,
      'entryDate': '2024-01-15T00:00:00',
      'contractEndDate': '2025-06-23T00:00:00',
      'imagePath': null
    },
    {
      'name': 'Carlos Huamán',
      'dni': '45671234',
      'role': 'Supervisor',
      'isActive': true,
      'entryDate': '2022-05-20T00:00:00',
      'contractEndDate': '2025-09-19T00:00:00',
      'imagePath': null
    },
    {
      'name': 'Lucía Ramírez',
      'dni': '22334455',
      'role': 'Recolectora',
      'isActive': true,
      'entryDate': '2023-09-10T00:00:00',
      'contractEndDate': '2025-06-22T00:00:00',
      'imagePath': null
    },
    {
      'name': 'Andrés Quispe',
      'dni': '99887766',
      'role': 'Fumigador',
      'isActive': false,
      'entryDate': '2021-12-05T00:00:00',
      'contractEndDate': '2025-07-21T00:00:00',
      'imagePath': null
    },
    {
      'name': 'María Ccahuana',
      'dni': '33445566',
      'role': 'Encargada de riego',
      'isActive': true,
      'entryDate': '2022-08-01T00:00:00',
      'contractEndDate': '2025-06-24T00:00:00',
      'imagePath': null
    },
    {
      'name': 'Pedro Gutiérrez',
      'dni': '11223344',
      'role': 'Jornalero',
      'isActive': true,
      'entryDate': '2023-11-15T00:00:00',
      'contractEndDate': '2025-12-18T00:00:00',
      'imagePath': null
    },
  ];

  List<Map<String, dynamic>> filteredWorkers = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredWorkers = List.from(allWorkers);
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredWorkers = allWorkers.where((worker) {
        return worker['name'].toLowerCase().contains(searchQuery) ||
            worker['dni'].contains(searchQuery);
      }).toList();
    });
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
                filteredWorkers = List.from(allWorkers);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Trabajador eliminado')),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _sortWorkers(String sortBy) {
    setState(() {
      if (sortBy == 'name') {
        allWorkers.sort((a, b) => a['name'].compareTo(b['name']));
      } else if (sortBy == 'date') {
        allWorkers.sort((a, b) {
          final dateA = a['entryDate'] != null
              ? DateTime.tryParse(a['entryDate'])
              : null;
          final dateB = b['entryDate'] != null
              ? DateTime.tryParse(b['entryDate'])
              : null;
          if (dateA == null && dateB == null) return 0;
          if (dateA == null) return 1;
          if (dateB == null) return -1;
          return dateB.compareTo(dateA);
        });
      }
      filteredWorkers = List.from(allWorkers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Trabajadores'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: _sortWorkers,
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'name', child: Text('Ordenar por nombre')),
              PopupMenuItem(value: 'date', child: Text('Ordenar por fecha de ingreso')),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newWorker = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const WorkerFormScreen(),
            ),
          );

          if (newWorker != null) {
            setState(() {
              allWorkers.add(newWorker);
              filteredWorkers = List.from(allWorkers);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: updateSearch,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o DNI...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredWorkers.length,
              itemBuilder: (context, index) {
                final worker = filteredWorkers[index];
                final imagePath = worker['imagePath'];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: (imagePath != null && imagePath != '')
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
                      Text('DNI: ${worker['dni']} • Rol: ${worker['role']}'),
                      if (worker['entryDate'] != null)
                        Text(
                          'Ingreso: ${worker['entryDate'].toString().split("T")[0]}',
                        ),
                      if (worker['contractEndDate'] != null)
                        Text(
                          'Contrato hasta: ${worker['contractEndDate'].toString().split("T")[0]}',
                          style: TextStyle(
                            color: DateTime.tryParse(worker['contractEndDate']) != null &&
                                    DateTime.tryParse(worker['contractEndDate'])!.difference(DateTime.now()).inDays <= 30
                                ? Colors.red
                                : null,
                          ),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(
                        label: Text(
                            worker['isActive'] ? 'Activo' : 'Inactivo'),
                        backgroundColor:
                            worker['isActive'] ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(worker),
                      ),
                    ],
                  ),
                  onTap: () async {
                    final updatedWorker = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorkerFormScreen(worker: worker),
                      ),
                    );

                    if (updatedWorker != null) {
                      setState(() {
                        final index = allWorkers.indexOf(worker);
                        allWorkers[index] = updatedWorker;
                        filteredWorkers = List.from(allWorkers);
                      });
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
