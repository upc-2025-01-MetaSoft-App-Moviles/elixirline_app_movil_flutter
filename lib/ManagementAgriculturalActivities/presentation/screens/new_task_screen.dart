// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/parcel.dart';
import '../../domain/entities/task.dart';
import '../../application/usecases/create_task_usecase.dart';
import '../../infrastructure/repositories_impl/task_repository_impl.dart';
import '../providers/parcel_provider.dart';
import '../widgets/task_card.dart';

class NewTaskScreen extends ConsumerStatefulWidget {
  const NewTaskScreen({super.key});

  @override
  ConsumerState<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends ConsumerState<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  String? tipoTask;
  Parcel? loteSeleccionado;
  DateTime? fechaHoraSeleccionada;
  String responsable = '';
  String notas = '';

  final opcionesTask = ['Riego', 'Fertilización', 'Cosecha', 'Poda'];
  final opcionesResponsables = ['Juan Pérez', 'Ana Gómez', 'Carlos Ruiz'];

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaHoraSeleccionada ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          fechaHoraSeleccionada = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      if (tipoTask == null ||
          loteSeleccionado == null ||
          fechaHoraSeleccionada == null ||
          responsable.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor completa todos los campos obligatorios')),
        );
        return;
      }

      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: tipoTask!,
        description: notas,
        scheduledDate: fechaHoraSeleccionada!.toIso8601String(),
        parcelId: loteSeleccionado!.id,
        status: 0,
        responsible: responsable,
      );

      final createTaskUseCase = CreateTaskUseCase(TaskRepositoryImpl());
      await createTaskUseCase.execute(newTask);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Actividad guardada con éxito')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final parcelsAsyncValue = ref.watch(parcelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Actividad'),
        backgroundColor: const Color(0xFF8B0000),
      ),
      bottomNavigationBar: Container(
        height: 56,
        color: const Color(0xFF8B0000),
      ),
      backgroundColor: const Color(0xFFF2F8FF),
      body: parcelsAsyncValue.when(
        data: (parcels) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: const Color(0xFFD9D9D9),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tipo de actividad:', style: TextStyle(fontWeight: FontWeight.bold)),
                        DropdownButtonFormField<String>(
                          value: tipoTask,
                          items: opcionesTask.map((task) {
                            return DropdownMenuItem(value: task, child: Text(task));
                          }).toList(),
                          onChanged: (value) => setState(() => tipoTask = value),
                          validator: (value) => value == null ? 'Selecciona un tipo' : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: const Color(0xFFD9D9D9),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Seleccionar lote:', style: TextStyle(fontWeight: FontWeight.bold)),
                        DropdownButtonFormField<Parcel>(
                          value: loteSeleccionado,
                          items: parcels.map((parcel) {
                            return DropdownMenuItem(value: parcel, child: Text(parcel.name));
                          }).toList(),
                          onChanged: (value) => setState(() => loteSeleccionado = value),
                          validator: (value) => value == null ? 'Selecciona un lote' : null,
                        ),
                        const SizedBox(height: 12),
                        const Text('Fecha y hora:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ElevatedButton(
                          onPressed: _selectDateTime,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B0000)),
                          child: Text(
                            fechaHoraSeleccionada == null
                                ? 'Seleccionar fecha y hora'
                                : DateFormat('dd/MM/yyyy HH:mm').format(fechaHoraSeleccionada!),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text('Responsable:', style: TextStyle(fontWeight: FontWeight.bold)),
                        DropdownButtonFormField<String>(
                          value: responsable.isNotEmpty ? responsable : null,
                          items: opcionesResponsables.map((resp) {
                            return DropdownMenuItem(value: resp, child: Text(resp));
                          }).toList(),
                          onChanged: (value) => setState(() => responsable = value!),
                          validator: (value) => value == null || value.isEmpty ? 'Selecciona responsable' : null,
                        ),
                        const SizedBox(height: 12),
                        const Text('Notas (opcional):', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextFormField(
                          maxLines: 3,
                          onChanged: (value) => notas = value,
                          decoration: const InputDecoration(hintText: 'Escribir...'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Guardar actividad', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const SizedBox(height: 24),
                if (tipoTask != null && loteSeleccionado != null && fechaHoraSeleccionada != null && responsable.isNotEmpty)
                  TaskCard(
                    task: Task(
                      id: 'preview',
                      title: tipoTask!,
                      description: notas,
                      scheduledDate: fechaHoraSeleccionada!.toIso8601String(),
                      parcelId: loteSeleccionado!.id,
                      status: 0,
                      responsible: responsable,
                    ),
                  ),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}