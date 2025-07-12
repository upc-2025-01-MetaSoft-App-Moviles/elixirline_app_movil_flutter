import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/worker.dart';
import '../../domain/models/worker_task.dart';
import '../viewmodels/worker_task_viewmodel.dart';

class WorkerTaskHistoryScreen extends StatefulWidget {
  final Worker worker;

  const WorkerTaskHistoryScreen({super.key, required this.worker});

  @override
  State<WorkerTaskHistoryScreen> createState() =>
      _WorkerTaskHistoryScreenState();
}

class _WorkerTaskHistoryScreenState extends State<WorkerTaskHistoryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  String _status = 'Pendiente';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkerTaskViewModel>().loadTasksForWorker(widget.worker.id);
    });
  }

  void _showTaskDialog({WorkerTask? task}) {
    final isEditing = task != null;
    _title = task?.title;
    _description = task?.description;
    _status = task?.status ?? 'Pendiente';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEditing ? 'Editar tarea' : 'Agregar tarea'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Requerido' : null,
                onSaved: (value) => _title = value,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Requerido' : null,
                onSaved: (value) => _description = value,
              ),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Estado'),
                items: const [
                  DropdownMenuItem(
                    value: 'Pendiente',
                    child: Text('Pendiente'),
                  ),
                  DropdownMenuItem(
                    value: 'En progreso',
                    child: Text('En progreso'),
                  ),
                  DropdownMenuItem(
                    value: 'Completada',
                    child: Text('Completada'),
                  ),
                ],
                onChanged: (val) {
                  setState(() {
                    _status = val!;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text(isEditing ? 'Guardar' : 'Agregar'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final taskViewModel = context.read<WorkerTaskViewModel>();

                if (isEditing) {
                  taskViewModel.updateTask(
                    task.id,
                    title: _title!,
                    description: _description!,
                    status: _status,
                  );
                } else {
                  taskViewModel.addTask(
                    WorkerTask(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: _title!,
                      description: _description!,
                      date: DateTime.now(),
                      status: _status,
                    ),
                  );
                }

                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: const Text('¿Estás seguro de que deseas eliminar esta tarea?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Eliminar'),
            onPressed: () {
              context.read<WorkerTaskViewModel>().deleteTask(id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<WorkerTaskViewModel>().tasks;

    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de tareas de ${widget.worker.fullName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Agregar tarea',
            onPressed: () => _showTaskDialog(),
          ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No hay tareas registradas.'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  leading: const Icon(Icons.task_alt),
                  title: Text(task.title),
                  subtitle: Text(
                    '${task.description}\nEstado: ${task.status}\n${task.date.day}/${task.date.month}/${task.date.year}',
                  ),
                  isThreeLine: true,
                  onTap: () => _showTaskDialog(task: task),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(task.id),
                  ),
                );
              },
            ),
    );
  }
}
