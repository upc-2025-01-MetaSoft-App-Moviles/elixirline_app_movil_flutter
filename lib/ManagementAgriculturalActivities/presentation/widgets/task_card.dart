// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    const darkRed = Color(0xFF8B0000);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFD9D9D9),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Actividad: ${task.title}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Lote ID: ${task.parcelId}'),
            Text('Fecha: ${task.scheduledDate}'),
            Text('Responsable: ${task.responsible}'),
            Text('Notas: ${task.description}'),
          ],
        ),
      ),
    );
  }
}
